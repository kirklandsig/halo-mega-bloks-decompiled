"""Searches for source rewrites that bring one function closer to retail, in
the spirit of decomp-permuter.

    python tools/permute.py src/<Package>/Src/<File>.cpp 0x8331DE98 [--jobs 8] [--time 600]

The function is the one whose "// @retail" marker names the address (or the
name). Each worker starts from the source as written, applies one to three
random rewrites to its current best, compiles the file with the object's
command line (check.py's machinery), and scores our function against
retail's bytes: an instruction diff, where a word that differs only in its
registers or immediate costs 1 and any other inserted, deleted or replaced
word costs 2. A candidate that scores lower becomes the worker's best; one
that scores the same is kept now and then, to walk plateaus. Score 0 is a
match.

The rewrites (--kinds picks some; all by default):

    reorder  swap two adjacent statements that don't depend on each other
    commute  swap the operands of + * & | ^ == !=, or mirror < <= > >=
    temp     hoist a call or arithmetic into an `auto` temporary, or inline a
             temporary that is used once in the next statement
    if       if/else of one assignment or return <-> ?:, or invert an if/else
    loop     for <-> while, while <-> if + do/while
    cast     add or drop (bool) on a condition, a declaration's own type on
             its initializer, or an arithmetic cast on an assigned value
    const    add or drop a local's const
    split    T x = e; <-> T x; x = e;  x op= e <-> x = x op e;  x++ <-> ++x
             <-> x += 1;  x = a op b; <-> x = a; x op= b;

They are meant to preserve meaning. They are type-blind, though: commuting
`+` on a class whose operator+ isn't commutative (FString), or an `auto`
copy of a call that returns a reference the code then changes, would not,
so read the winning candidate before keeping it. Comments inside the
function move to the statement after them, and the body is re-indented.

Output goes to --out (default build/permute/<address>/): best.cpp (the
whole file with the best function), result.json (base and best score, the
rewrites that improved it, counts). Without --iterations the run is limited
only by --time; with --seed and --iterations it is deterministic.
"""
import argparse
import collections
import copy
import difflib
import json
import multiprocessing
import os
import random
import re
import sys
import time
from pathlib import Path

import check
import coff
import paths

# ---------------------------------------------------------------- tokens

TOKEN = re.compile(r'''
    (?P<ws>\s+)
  | (?P<comment>//[^\n]*|/\*.*?\*/)
  | (?P<pp>\#[^\n]*(?:\\\n[^\n]*)*)
  | (?P<str>L?"(?:\\.|[^"\\\n])*")
  | (?P<chr>L?'(?:\\.|[^'\\\n])*')
  | (?P<num>(?:0[xX][0-9a-fA-F]+|\d+\.?\d*(?:[eE][+-]?\d+)?|\.\d+(?:[eE][+-]?\d+)?)[uUlLfF]*)
  | (?P<id>[A-Za-z_]\w*)
  | (?P<op>>>=|<<=|->\*|\.\.\.|::|->|\+\+|--|<<|>>|<=|>=|==|!=|&&|\|\||[-+*/%&|^!=]=|\.\*|[-+*/%&|^~!=<>?:;,.(){}\[\]])
''', re.X | re.S)

KEYWORDS = {'if', 'else', 'while', 'do', 'for', 'switch', 'case', 'default', 'return', 'break', 'continue', 'goto',
            'new', 'delete', 'sizeof', 'this', 'true', 'false', 'const', 'static', 'unsigned', 'signed', 'auto',
            'volatile', 'struct', 'class', 'enum', 'typename', 'template', 'operator', 'throw', 'try', 'catch',
            'void', 'int', 'char', 'short', 'long', 'float', 'double', 'bool', '__int64', 'wchar_t', 'NULL',
            'static_cast', 'reinterpret_cast', 'const_cast', 'dynamic_cast', 'register', 'inline', '__forceinline'}
TYPE_WORDS = {'void', 'int', 'char', 'short', 'long', 'float', 'double', 'bool', '__int64', 'wchar_t', 'unsigned',
              'signed', 'const', 'volatile', 'struct', 'class', 'enum', 'typename', 'BYTE', 'WORD', 'DWORD', 'INT',
              'UINT', 'FLOAT', 'DOUBLE', 'UBOOL', 'BITFIELD', 'SWORD', 'SBYTE', 'QWORD', 'SQWORD', 'TCHAR', 'ANSICHAR',
              'PTRINT', 'size_t'}
ARITH_TYPES = TYPE_WORDS - {'void', 'const', 'volatile', 'struct', 'class', 'enum', 'typename'}
ASSIGN_OPS = {'=', '+=', '-=', '*=', '/=', '%=', '<<=', '>>=', '&=', '^=', '|='}
BIN_PREC = {'||': 3, '&&': 4, '|': 5, '^': 6, '&': 7, '==': 8, '!=': 8, '<': 9, '>': 9, '<=': 9, '>=': 9,
            '<<': 10, '>>': 10, '+': 11, '-': 11, '*': 12, '/': 12, '%': 12, '.*': 13, '->*': 13}
COMMUTATIVE = {'+', '*', '&', '|', '^', '==', '!='}
MIRROR = {'<': '>', '>': '<', '<=': '>=', '>=': '<='}
ARITH_OPS = {'+', '-', '*', '/', '%', '<<', '>>', '&', '|', '^'}


def tokenize(text):
    """[(kind, text)] without whitespace; comments and preprocessor lines kept."""
    out, pos = [], 0
    while pos < len(text):
        m = TOKEN.match(text, pos)
        if not m:
            raise SyntaxError(f'cannot tokenize at {text[pos:pos + 20]!r}')
        if m.lastgroup != 'ws':
            out.append((m.lastgroup, m.group()))
        pos = m.end()
    return out


def is_id(tok):
    return bool(tok) and (tok[0].isalpha() or tok[0] == '_') and not tok.startswith(('L"', "L'"))


def is_name(tok):
    return is_id(tok) and tok not in KEYWORDS


def is_literal(tok):
    return tok[:1].isdigit() or tok[:1] in '"\'.' or tok.startswith(('L"', "L'"))


def fmt(toks):
    """Tokens back to source text, spaced so no two tokens merge."""
    out = []
    prev = None
    for t in toks:
        if prev is None:
            out.append(t)
        else:
            tight = (t in (',', ';', ')', ']', '.', '->', '::', '.*', '->*')
                     or prev in ('(', '[', '.', '->', '::', '~', '!')
                     or (t in ('(', '[') and (is_id(prev) or prev in (')', ']', '>')))
                     or (t in ('++', '--') and (is_id(prev) or prev in (')', ']'))))
            out.append(t if tight else ' ' + t)
        prev = t
    return ''.join(out)


# ------------------------------------------------------------ statements

class Stmt:
    """kind: simple (toks), label (toks), block (body), if (cond, then, else_),
    while (cond, body), do (body, cond), for (init, cond, step, body),
    switch (cond, body), raw (text: a preprocessor line)."""

    def __init__(self, kind, **fields):
        self.kind = kind
        self.lead = []
        self.__dict__.update(fields)

    def children(self):
        if self.kind == 'block':
            return list(self.body)
        return [s for s in (getattr(self, 'then', None), getattr(self, 'else_', None),
                            getattr(self, 'body', None)) if isinstance(s, Stmt)]


def _match(toks, i, open_, close):
    """Index of the token closing toks[i] (an `open_`)."""
    depth = 0
    for j in range(i, len(toks)):
        if toks[j][1] == open_:
            depth += 1
        elif toks[j][1] == close:
            depth -= 1
            if depth == 0:
                return j
    raise SyntaxError(f'unbalanced {open_}')


def _code(toks):
    return [t for k, t in toks if k not in ('comment', 'pp')]


def parse_body(toks):
    """The statements of a function body (its tokens, without the braces)."""
    stmts, i = [], 0
    while i < len(toks):
        s, i = _stmt(toks, i)
        if s is not None:
            stmts.append(s)
    return stmts


def _stmt(toks, i):
    lead = []
    while i < len(toks) and toks[i][0] == 'comment':
        lead.append(toks[i][1])
        i += 1
    if i >= len(toks):
        if not lead:
            return None, i
        s = Stmt('raw', text='')
    elif toks[i][0] == 'pp':
        s = Stmt('raw', text=toks[i][1])
        i += 1
    else:
        s, i = _stmt_core(toks, i)
    s.lead = lead
    return s, i


def _paren(toks, i):
    """(tokens inside the parentheses starting at toks[i], index after them)."""
    if toks[i][1] != '(':
        raise SyntaxError('expected (')
    j = _match(toks, i, '(', ')')
    return _code(toks[i + 1:j]), j + 1


def _stmt_core(toks, i):
    t = toks[i][1]
    nxt = toks[i + 1][1] if i + 1 < len(toks) else None
    if t == '{':
        j = _match(toks, i, '{', '}')
        return Stmt('block', body=parse_body(toks[i + 1:j])), j + 1
    if t == 'if':
        cond, i = _paren(toks, i + 1)
        then, i = _stmt(toks, i)
        else_ = None
        if i < len(toks) and toks[i][1] == 'else':
            else_, i = _stmt(toks, i + 1)
        return Stmt('if', cond=cond, then=then, else_=else_), i
    if t == 'while':
        cond, i = _paren(toks, i + 1)
        body, i = _stmt(toks, i)
        return Stmt('while', cond=cond, body=body), i
    if t == 'do':
        body, i = _stmt(toks, i + 1)
        if toks[i][1] != 'while':
            raise SyntaxError('expected while')
        cond, i = _paren(toks, i + 1)
        return Stmt('do', body=body, cond=cond), i + 1
    if t == 'for':
        inner, i = _paren(toks, i + 1)
        parts, depth, cur = [], 0, []
        for x in inner:
            depth += x in ('(', '[', '{') and 1 or x in (')', ']', '}') and -1 or 0
            if x == ';' and depth == 0:
                parts.append(cur)
                cur = []
            else:
                cur.append(x)
        parts.append(cur)
        if len(parts) != 3:
            raise SyntaxError('range-for or odd for')
        body, i = _stmt(toks, i)
        return Stmt('for', init=parts[0], cond=parts[1], step=parts[2], body=body), i
    if t == 'switch':
        cond, i = _paren(toks, i + 1)
        body, i = _stmt(toks, i)
        return Stmt('switch', cond=cond, body=body), i
    if t in ('try', '__try', 'asm', '__asm'):
        raise SyntaxError(f'{t} is not supported')
    if t in ('case', 'default') or (is_name(t) and nxt == ':'):
        j = i
        depth = 0
        while not (toks[j][1] == ':' and depth == 0):
            depth += toks[j][1] in ('(', '[') and 1 or toks[j][1] in (')', ']') and -1 or 0
            j += 1
        return Stmt('label', toks=_code(toks[i:j])), j + 1
    j, depth = i, 0
    while j < len(toks):
        x = toks[j][1]
        if x in ('(', '[', '{'):
            depth += 1
        elif x in (')', ']', '}'):
            depth -= 1
        elif x == ';' and depth == 0:
            break
        j += 1
    if j >= len(toks):
        raise SyntaxError('statement without ;')
    return Stmt('simple', toks=_code(toks[i:j])), j + 1


def render(stmts, indent=1):
    out = []
    pad = '    ' * indent
    for s in stmts:
        out.extend(_render(s, indent, pad))
    return out


def _sub(s, indent):
    """A child statement: a block keeps its braces at the parent's level."""
    if s.kind == 'block':
        return _render(s, indent - 1, '    ' * (indent - 1))
    return _render(s, indent, '    ' * indent)


def _render(s, indent, pad):
    lines = [pad + c for lead in s.lead for c in lead.splitlines()]
    if s.kind == 'raw':
        return lines + ([s.text] if s.text else [])
    if s.kind == 'simple':
        return lines + [pad + fmt(s.toks) + ';']
    if s.kind == 'label':
        return lines + [pad[4:] + fmt(s.toks) + ':']
    if s.kind == 'block':
        return lines + [pad + '{'] + render(s.body, indent + 1) + [pad + '}']
    if s.kind == 'if':
        lines.append(pad + f'if ({fmt(s.cond)})')
        lines += _sub(s.then, indent + 1)
        if s.else_ is not None:
            if s.else_.kind == 'if' and not s.else_.lead:
                rest = _render(s.else_, indent, pad)
                lines.append(pad + 'else ' + rest[0].lstrip())
                lines += rest[1:]
            else:
                lines.append(pad + 'else')
                lines += _sub(s.else_, indent + 1)
        return lines
    if s.kind == 'while':
        return lines + [pad + f'while ({fmt(s.cond)})'] + _sub(s.body, indent + 1)
    if s.kind == 'do':
        return lines + [pad + 'do'] + _sub(s.body, indent + 1) + [pad + f'while ({fmt(s.cond)});']
    if s.kind == 'for':
        head = f'for ({fmt(s.init)}; {fmt(s.cond)}; {fmt(s.step)})'.replace('( ;', '(;').replace('; ;', ';;')
        return lines + [pad + head] + _sub(s.body, indent + 1)
    if s.kind == 'switch':
        return lines + [pad + f'switch ({fmt(s.cond)})'] + _sub(s.body, indent + 1)
    raise ValueError(s.kind)


def statements(s):
    """A loop body's statements (a block's, or the one statement)."""
    return list(s.body) if s.kind == 'block' else [s]


def walk(stmts):
    """Every statement, depth first."""
    for s in stmts:
        yield s
        yield from walk(s.children())


def containers(stmts):
    """Every statement list (a body or a block's body), depth first."""
    yield stmts
    for s in walk(stmts):
        if s.kind == 'block':
            yield s.body


# ---------------------------------------------------------- expressions

class Node:
    """A parsed expression over a token list: kind is bin, assign, tern, un,
    post, call, index, member, paren, cast, prim; [lo, hi) is its span, opi
    the index of its operator token."""

    def __init__(self, kind, lo, hi, kids=(), op=None, opi=None):
        self.kind, self.lo, self.hi, self.kids, self.op, self.opi = kind, lo, hi, list(kids), op, opi

    def nodes(self, cond=False):
        """(node, under a short-circuit or ?: arm) of this tree, preorder."""
        yield self, cond
        for n, k in enumerate(self.kids):
            c = cond or (self.kind == 'bin' and self.op in ('&&', '||') and n == 1) or (self.kind == 'tern' and n > 0)
            yield from k.nodes(c)


class Parser:
    def __init__(self, toks):
        self.t = toks
        self.i = 0

    def peek(self):
        return self.t[self.i] if self.i < len(self.t) else None

    def take(self, want=None):
        tok = self.peek()
        if tok is None or (want is not None and tok != want):
            raise SyntaxError(f'expected {want}, got {tok}')
        self.i += 1
        return tok

    def expr(self):
        return self.assign()

    def assign(self):
        lo = self.i
        left = self.tern()
        if self.peek() in ASSIGN_OPS:
            opi = self.i
            op = self.take()
            right = self.assign()
            return Node('assign', lo, self.i, [left, right], op, opi)
        return left

    def tern(self):
        lo = self.i
        c = self.binary(3)
        if self.peek() == '?':
            self.take()
            a = self.assign()
            self.take(':')
            b = self.assign()
            return Node('tern', lo, self.i, [c, a, b])
        return c

    def binary(self, minp):
        lo = self.i
        left = self.unary()
        while self.peek() in BIN_PREC and BIN_PREC[self.peek()] >= minp:
            opi = self.i
            op = self.take()
            right = self.binary(BIN_PREC[op] + 1)
            left = Node('bin', lo, self.i, [left, right], op, opi)
        return left

    def unary(self):
        lo = self.i
        tok = self.peek()
        if tok in ('!', '~', '-', '+', '*', '&', '++', '--'):
            self.take()
            x = self.unary()
            return Node('un', lo, self.i, [x], tok, lo)
        if tok == 'sizeof':
            self.take()
            if self.peek() == '(':
                self.skip_group('(', ')')
                return Node('prim', lo, self.i)
            x = self.unary()
            return Node('un', lo, self.i, [x], tok, lo)
        if tok in ('new', 'delete'):
            return self.new_delete()
        if tok == '(' and self.is_cast():
            self.skip_group('(', ')')
            x = self.unary()
            return Node('cast', lo, self.i, [x])
        return self.postfix()

    def new_delete(self):
        lo = self.i
        if self.take() == 'delete':
            if self.peek() == '[':
                self.skip_group('[', ']')
            x = self.unary()
            return Node('un', lo, self.i, [x], 'delete', lo)
        if self.peek() == '(':
            self.skip_group('(', ')')
        while self.peek() is not None and (is_id(self.peek()) or self.peek() in ('::', '*')):
            self.take()
            if self.peek() == '<' and self.template_end() is not None:
                self.i = self.template_end() + 1
        if self.peek() == '(':
            self.skip_group('(', ')')
        elif self.peek() == '[':
            self.skip_group('[', ']')
        return Node('prim', lo, self.i)

    def skip_group(self, open_, close):
        depth = 0
        while True:
            tok = self.take()
            depth += (tok == open_) - (tok == close)
            if depth == 0:
                return

    def is_cast(self):
        """Is the '(' at i a C-style cast?"""
        depth, j = 0, self.i
        while j < len(self.t):
            depth += (self.t[j] == '(') - (self.t[j] == ')')
            if depth == 0:
                break
            j += 1
        inner = self.t[self.i + 1:j]
        after = self.t[j + 1] if j + 1 < len(self.t) else None
        if not inner or any(not (is_id(x) or x in ('::', '*', '&', '<', '>', ',')) for x in inner):
            return False
        if any(x in KEYWORDS - TYPE_WORDS for x in inner):
            return False
        typed = inner[-1] in ('*', '&') or any(x in TYPE_WORDS for x in inner)
        starts = after is not None and (is_id(after) or is_literal(after) or after in ('(', '!', '~')
                                        or (typed and after in ('&', '*', '-', '+')))
        if not starts:
            return False
        return typed or (len(inner) == 1 and inner[0][:1].isupper() and not inner[0].isupper())

    def template_end(self):
        """Index of the '>' closing a template argument list at i, or None."""
        depth, j = 0, self.i
        while j < len(self.t):
            x = self.t[j]
            if x == '<':
                depth += 1
            elif x == '>':
                depth -= 1
                if depth == 0:
                    after = self.t[j + 1] if j + 1 < len(self.t) else None
                    if after is None or after in ('(', '::', ')', ',', ';', '>', '*', '&', '{') or is_id(after):
                        return j
                    return None
            elif x == '>>':
                return None
            elif not (is_id(x) or is_literal(x) or x in ('::', '*', '&', ',', '(', ')')):
                return None
            j += 1
        return None

    def postfix(self):
        lo = self.i
        x = self.primary()
        while True:
            tok = self.peek()
            if tok == '(':
                self.take()
                args = []
                while self.peek() != ')':
                    args.append(self.assign())
                    if self.peek() == ',':
                        self.take()
                self.take(')')
                x = Node('call', lo, self.i, [x] + args)
            elif tok == '[':
                self.take()
                k = self.expr()
                self.take(']')
                x = Node('index', lo, self.i, [x, k])
            elif tok in ('.', '->'):
                opi = self.i
                self.take()
                if self.peek() == '~':
                    self.take()
                self.take()
                while self.peek() == '::':
                    self.take()
                    self.take()
                if self.peek() == '<' and self.template_end() is not None:
                    self.i = self.template_end() + 1
                x = Node('member', lo, self.i, [x], tok, opi)
            elif tok in ('++', '--'):
                self.take()
                x = Node('post', lo, self.i, [x], tok, self.i - 1)
            else:
                return x

    def primary(self):
        lo = self.i
        tok = self.peek()
        if tok == '(':
            self.take()
            x = self.expr()
            self.take(')')
            return Node('paren', lo, self.i, [x])
        if tok is None:
            raise SyntaxError('unexpected end')
        if is_literal(tok):
            self.take()
            while self.peek() is not None and self.peek()[:1] in '"L' and self.peek().endswith('"'):
                self.take()
            return Node('prim', lo, self.i)
        if tok == '::' or is_id(tok):
            if tok == '::':
                self.take()
            if self.peek() == 'operator':
                raise SyntaxError('operator names are not supported')
            self.take()
            while True:
                if self.peek() == '<' and self.template_end() is not None:
                    self.i = self.template_end() + 1
                elif self.peek() == '::':
                    self.take()
                    if self.peek() == '~':
                        self.take()
                    self.take()
                else:
                    break
            return Node('prim', lo, self.i)
        raise SyntaxError(f'unexpected {tok}')


def parse_expr(toks):
    p = Parser(toks)
    node = p.expr()
    if p.i != len(toks):
        raise SyntaxError('trailing tokens')
    return node


def declaration(toks):
    """(name, index of '=' or None) of a one-declarator local declaration,
    else None."""
    if not toks or toks[0] in ('return', 'delete', 'new', 'throw', 'goto', 'break', 'continue', 'case', 'typedef'):
        return None
    j, words = 0, 0
    while j < len(toks) and toks[j] in ('const', 'static', 'volatile', 'unsigned', 'signed', 'struct', 'class',
                                        'enum', 'typename', 'register'):
        j += 1
    while j < len(toks):
        if is_id(toks[j]) and toks[j] not in KEYWORDS - TYPE_WORDS - {'auto'}:
            words += 1
            j += 1
            while j < len(toks) and toks[j] == '::' and j + 1 < len(toks) and is_id(toks[j + 1]):
                j += 2
            if j < len(toks) and toks[j] == '<':
                p = Parser(toks)
                p.i = j
                end = p.template_end()
                if end is None:
                    return None
                j = end + 1
        else:
            break
        while j < len(toks) and toks[j] in ('*', '&', 'const', 'volatile'):
            j += 1
        if words >= 2 and (j >= len(toks) or toks[j] in ('=', ';', '[', '(', ',')):
            if not is_name(toks[j - 1]) or (j < len(toks) and toks[j] in ('(', ',', '[')):
                return None
            return toks[j - 1], (j if j < len(toks) and toks[j] == '=' else None)
    return None


def regions(func):
    """Every expression region: (statement, attribute, first token)."""
    out = []
    for s in walk(func.body):
        if s.kind == 'simple' and s.toks:
            if s.toks[0] == 'return':
                if len(s.toks) > 1:
                    out.append((s, 'toks', 1))
            elif s.toks[0] in ('break', 'continue', 'goto', 'delete', 'throw'):
                continue
            else:
                d = declaration(s.toks)
                if d is None:
                    out.append((s, 'toks', 0))
                elif d[1] is not None:
                    out.append((s, 'toks', d[1] + 1))
        elif s.kind in ('if', 'while', 'do', 'switch') and s.cond:
            out.append((s, 'cond', 0))
        elif s.kind == 'for':
            for attr in ('cond', 'step'):
                if getattr(s, attr):
                    out.append((s, attr, 0))
    return out


def parsed(region):
    """(tokens, tree) of an expression region; tree spans are absolute."""
    s, attr, lo = region
    toks = getattr(s, attr)
    tree = parse_expr(toks[lo:])
    for n, _ in tree.nodes():
        n.lo += lo
        n.hi += lo
        if n.opi is not None:
            n.opi += lo
    return toks, tree


def wrap(toks, node, prec, right):
    """`node`'s tokens, in parentheses where a parent operator of precedence
    `prec` would otherwise bind differently."""
    t = toks[node.lo:node.hi]
    p = BIN_PREC.get(node.op, 99) if node.kind == 'bin' else (0 if node.kind in ('tern', 'assign') else 99)
    if p < prec or (right and p == prec):
        return ['('] + t + [')']
    return t


# ------------------------------------------------------------- analysis

class Function:
    def __init__(self, header, body_tokens, params):
        self.header = header
        self.body = parse_body(body_tokens)
        self.params = params
        self.returns_bool = bool(re.match(r'\s*(?:static\s+|inline\s+|virtual\s+)*(?:bool|UBOOL)\s', header))
        self.temps = 0

    def text(self):
        return '\n'.join([self.header.rstrip(), '{'] + render(self.body) + ['}'])

    def locals(self):
        names = set(self.params)
        for s in walk(self.body):
            for toks in ([s.toks] if s.kind == 'simple' else [s.init] if s.kind == 'for' else []):
                d = declaration(toks)
                if d:
                    names.add(d[0])
        return names - self.escaped()

    def escaped(self):
        """Locals whose address is taken or that are passed to a call (a
        reference parameter could write them)."""
        out = set()
        for region in regions(self):
            try:
                toks, tree = parsed(region)
            except SyntaxError:
                continue
            for n, _ in tree.nodes():
                if n.kind == 'un' and n.op == '&':
                    out |= {t for t in toks[n.lo:n.hi] if is_name(t)}
                if n.kind == 'call':
                    for a in n.kids[1:]:
                        out |= {t for t in toks[a.lo:a.hi] if is_name(t)}
                    callee = n.kids[0]
                    if callee.kind == 'member':
                        out |= {t for t in toks[callee.lo:callee.hi] if is_name(t)}
        for s in walk(self.body):
            if s.kind == 'simple' and declaration(s.toks) and '&' in s.toks[:s.toks.index('=') if '=' in s.toks else len(s.toks)]:
                out |= {t for t in s.toks if is_name(t)}
        return out


def names_in(toks):
    """Variable-like names: identifiers not after '.', '->' or '::'."""
    return {t for i, t in enumerate(toks) if is_name(t) and (i == 0 or toks[i - 1] not in ('.', '->', '::'))}


def effects(toks):
    """Does a statement call, allocate or touch memory beyond its locals?"""
    for i, t in enumerate(toks):
        if t in ('new', 'delete', '->', '[', 'operator', 'throw'):
            return True
        if t == '(' and i > 0 and (is_id(toks[i - 1]) or toks[i - 1] in (')', ']', '>')) and toks[i - 1] not in KEYWORDS - TYPE_WORDS:
            return True
        if t == '*' and (i == 0 or toks[i - 1] in ASSIGN_OPS or toks[i - 1] in BIN_PREC or toks[i - 1] in ('(', ',', 'return', '!')):
            return True
    return False


def writes(toks):
    d = declaration(toks)
    out = {d[0]} if d else set()
    for i, t in enumerate(toks):
        if t in ASSIGN_OPS and not d:
            if i and is_name(toks[0]):
                out.add(toks[0])
        if t in ('++', '--'):
            for j in (i - 1, i + 1):
                if 0 <= j < len(toks) and is_name(toks[j]):
                    out.add(toks[j])
    return out


def movable(s):
    return s.kind == 'simple' and s.toks and s.toks[0] not in ('return', 'break', 'continue', 'goto', 'throw')


def variables(toks):
    """The names a statement reads or writes as variables: not types, scopes,
    members, or ALL_CAPS constants."""
    d = declaration(toks)
    start = ((d[1] if d[1] is not None else len(toks)) - 1) if d else 0
    out = set()
    for i in range(start, len(toks)):
        t = toks[i]
        if not is_name(t) or t in TYPE_WORDS or re.fullmatch(r'[A-Z][A-Z0-9_]*', t):
            continue
        if (i and toks[i - 1] in ('.', '->', '::')) or (i + 1 < len(toks) and toks[i + 1] == '::'):
            continue
        out.add(t)
    return out


def independent(a, b, local):
    """May simple statements a and b run in either order? At most one may
    call, allocate or touch memory; the other must then name only unescaped
    locals, none of which the first names. Two plain ones must not write
    what the other names."""
    ea, eb = effects(a.toks), effects(b.toks)
    na, nb = variables(a.toks), variables(b.toks)
    if ea and eb:
        return False
    if ea or eb:
        n_pure, n_other = (nb, na) if ea else (na, nb)
        return n_pure <= local and not n_pure & n_other
    return not (writes(a.toks) & nb or writes(b.toks) & na)


def continues(s):
    """Does a loop body contain a continue of its own loop?"""
    if s.kind == 'simple':
        return s.toks[:1] == ['continue']
    if s.kind in ('while', 'do', 'for'):
        return False
    return any(continues(c) for c in s.children())


def pure_cond(toks):
    return not effects(toks) and not any(t in ASSIGN_OPS or t in ('++', '--') for t in toks)


# ------------------------------------------------------------- rewrites

def _parsed_regions(func):
    out = []
    for r in regions(func):
        try:
            out.append((r, *parsed(r)))
        except SyntaxError:
            pass
    return out


def rw_reorder(func, rng):
    local = func.locals()
    sites = [(c, i) for c in containers(func.body) for i in range(len(c) - 1)
             if movable(c[i]) and movable(c[i + 1]) and independent(c[i], c[i + 1], local)]
    if not sites:
        return False
    c, i = rng.choice(sites)
    c[i], c[i + 1] = c[i + 1], c[i]
    return True


def rw_commute(func, rng):
    sites = []
    for (s, attr, _), toks, tree in _parsed_regions(func):
        for n, _ in tree.nodes():
            if n.kind == 'bin' and (n.op in COMMUTATIVE or n.op in MIRROR):
                if n.op in ('+', '*') and any(t.startswith(('"', 'L"')) for t in toks[n.lo:n.hi]):
                    continue
                sites.append((s, attr, toks, n))
    if not sites:
        return False
    s, attr, toks, n = rng.choice(sites)
    left, right = n.kids
    p = BIN_PREC[n.op]
    new = wrap(toks, right, p, False) + [MIRROR.get(n.op, n.op)] + wrap(toks, left, p, True)
    setattr(s, attr, toks[:n.lo] + new + toks[n.hi:])
    return True


def rw_temp(func, rng):
    first, second = (_hoist, _inline) if rng.random() < 0.5 else (_inline, _hoist)
    return first(func, rng) or second(func, rng)


def _statement_regions(func):
    """{id(statement): its first toks or cond region}."""
    out = {}
    for r in regions(func):
        if r[1] in ('toks', 'cond'):
            out.setdefault(id(r[0]), r)
    return out


def _hoist(func, rng):
    sites = []
    by_stmt = _statement_regions(func)
    for c in containers(func.body):
        for i, s in enumerate(c):
            if s.kind not in ('simple', 'if', 'switch'):
                continue
            region = by_stmt.get(id(s))
            if region is None:
                continue
            try:
                toks, tree = parsed(region)
            except SyntaxError:
                continue
            parents = {}
            for n, _ in tree.nodes():
                for k in n.kids:
                    parents[id(k)] = n
            for n, cond in tree.nodes():
                if cond:
                    continue
                if not (n.kind == 'call' or (n.kind == 'bin' and n.op in ARITH_OPS)):
                    continue
                parent = parents.get(id(n))
                if parent is not None and (parent.kind in ('member', 'un', 'post') or
                                           (parent.kind == 'assign' and parent.kids[0] is n) or
                                           (parent.kind == 'call' and parent.kids[0] is n)):
                    continue
                if n is tree and s.kind == 'simple' and s.toks[0] != 'return':
                    continue  # a whole expression statement or initializer
                sites.append((c, i, s, region[1], toks, n))
    if not sites:
        return False
    c, i, s, attr, toks, n = rng.choice(sites)
    name = f'permTemp{func.temps}'
    func.temps += 1
    decl = Stmt('simple', toks=['auto', name, '='] + toks[n.lo:n.hi])
    setattr(s, attr, toks[:n.lo] + [name] + toks[n.hi:])
    decl.lead, s.lead = s.lead, []
    c.insert(i, decl)
    return True


def _uses(stmts, name):
    count = 0
    for s in walk(stmts):
        for attr in ('toks', 'cond', 'init', 'step'):
            toks = getattr(s, attr, None)
            if toks:
                count += sum(1 for j, t in enumerate(toks) if t == name and (j == 0 or toks[j - 1] not in ('.', '->', '::')))
    return count


def _inline(func, rng):
    escaped = func.escaped()
    by_stmt = _statement_regions(func)
    sites = []
    for c in containers(func.body):
        for i in range(len(c) - 1):
            s, nxt = c[i], c[i + 1]
            if s.kind != 'simple':
                continue
            d = declaration(s.toks)
            if not d or d[1] is None or 'static' in s.toks[:d[1]] or d[0] in escaped:
                continue
            name = d[0]
            if _uses(c[i + 1:], name) != 1 or _uses([nxt], name) != 1:
                continue
            region = by_stmt.get(id(nxt))
            if region is None or nxt.kind not in ('simple', 'if', 'switch'):
                continue
            try:
                toks, tree = parsed(region)
            except SyntaxError:
                continue
            spot = [n for n, cond in tree.nodes() if n.kind == 'prim' and toks[n.lo:n.hi] == [name] and not cond]
            if len(spot) != 1 or name in writes(nxt.toks if nxt.kind == 'simple' else []):
                continue
            sites.append((c, i, s, d, nxt, region[1], toks, spot[0]))
    if not sites:
        return False
    c, i, s, d, nxt, attr, toks, n = rng.choice(sites)
    init = s.toks[d[1] + 1:]
    setattr(nxt, attr, toks[:n.lo] + ['('] + init + [')'] + toks[n.hi:])
    nxt.lead = s.lead + nxt.lead
    del c[i]
    return True


def _single(s):
    """The one simple statement of s (itself, or a one-statement block)."""
    if s is not None and s.kind == 'block' and len(s.body) == 1:
        s = s.body[0]
    return s if s is not None and s.kind == 'simple' else None


def _top_assign(toks):
    try:
        tree = parse_expr(toks)
    except SyntaxError:
        return None
    if tree.kind == 'assign' and tree.op == '=':
        return tree
    return None


def rw_if(func, rng):
    sites = []
    for c in containers(func.body):
        for i, s in enumerate(c):
            if s.kind == 'if':
                a, b = _single(s.then), _single(s.else_)
                if a and b:
                    if a.toks[0] == 'return' and b.toks[0] == 'return' and len(a.toks) > 1 and len(b.toks) > 1:
                        sites.append(('ret', c, i))
                    else:
                        ta, tb = _top_assign(a.toks), _top_assign(b.toks)
                        if ta and tb and a.toks[:ta.opi] == b.toks[:tb.opi]:
                            sites.append(('asg', c, i))
                if s.else_ is None and a and a.toks[0] == 'return' and len(a.toks) > 1 and i + 1 < len(c):
                    b = c[i + 1]
                    if b.kind == 'simple' and b.toks[0] == 'return' and len(b.toks) > 1:
                        sites.append(('ret2', c, i))
                if s.else_ is not None and s.else_.kind != 'if':
                    sites.append(('inv', c, i))
            elif s.kind == 'simple' and s.toks:
                try:
                    lo = 1 if s.toks[0] == 'return' else 0
                    tree = parse_expr(s.toks[lo:])
                except SyntaxError:
                    continue
                if lo and tree.kind == 'tern':
                    sites.append(('unret', c, i))
                elif not lo and tree.kind == 'assign' and tree.op == '=' and tree.kids[1].kind == 'tern':
                    sites.append(('unasg', c, i))
    if not sites:
        return False
    kind, c, i = rng.choice(sites)
    s = c[i]
    if kind in ('ret', 'asg', 'ret2'):
        a = _single(s.then)
        b = _single(s.else_) if kind != 'ret2' else c[i + 1]
        if kind == 'asg':
            ta, tb = _top_assign(a.toks), _top_assign(b.toks)
            lhs = a.toks[:ta.opi]
            toks = lhs + ['=', '('] + s.cond + [')', '?', '('] + a.toks[ta.opi + 1:] + [')', ':', '('] + b.toks[tb.opi + 1:] + [')']
        else:
            toks = ['return', '('] + s.cond + [')', '?', '('] + a.toks[1:] + [')', ':', '('] + b.toks[1:] + [')']
        new = Stmt('simple', toks=toks)
        new.lead = s.lead
        c[i] = new
        if kind == 'ret2':
            new.lead = new.lead + c[i + 1].lead
            del c[i + 1]
    elif kind == 'inv':
        cond = s.cond
        if cond[:2] == ['!', '('] and _match([(None, x) for x in cond], 1, '(', ')') == len(cond) - 1:
            s.cond = cond[2:-1]
        else:
            s.cond = ['!', '('] + cond + [')']
        s.then, s.else_ = s.else_, s.then
    else:
        toks = s.toks
        lo = 1 if kind == 'unret' else 0
        _, tree = parsed((s, 'toks', lo))
        if kind == 'unret':
            cnd, a, b = tree.kids
            head = ['return']
        else:
            cnd, a, b = tree.kids[1].kids
            head = toks[:tree.opi] + ['=']
        arm = lambda n: Stmt('block', body=[Stmt('simple', toks=head + toks[n.lo:n.hi])])
        new = Stmt('if', cond=toks[cnd.lo:cnd.hi], then=arm(a), else_=arm(b))
        new.lead = s.lead
        c[i] = new
    return True


def rw_loop(func, rng):
    sites = []
    for c in containers(func.body):
        for i, s in enumerate(c):
            if s.kind == 'for' and not continues(s.body):
                sites.append(('for2while', c, i))
            if s.kind == 'while' and not continues(s.body):
                body = statements(s.body)
                if body and body[-1].kind == 'simple' and movable(body[-1]) and not declaration(body[-1].toks):
                    sites.append(('while2for', c, i))
                if pure_cond(s.cond):
                    sites.append(('while2do', c, i))
            if s.kind == 'if' and s.else_ is None:
                inner = s.then.body[0] if s.then.kind == 'block' and len(s.then.body) == 1 else s.then
                if inner.kind == 'do' and inner.cond == s.cond and pure_cond(s.cond):
                    sites.append(('do2while', c, i))
    if not sites:
        return False
    kind, c, i = rng.choice(sites)
    s = c[i]
    if kind == 'for2while':
        body = statements(s.body)
        if s.step:
            body.append(Stmt('simple', toks=s.step))
        loop = Stmt('while', cond=s.cond or ['true'], body=Stmt('block', body=body))
        if s.init:
            new = Stmt('block', body=[Stmt('simple', toks=s.init), loop])
        else:
            new = loop
    elif kind == 'while2for':
        body = statements(s.body)
        step = body.pop()
        init = []
        if i > 0 and movable(c[i - 1]) and rng.random() < 0.5:
            init = c[i - 1].toks
            s.lead = c[i - 1].lead + s.lead
            del c[i - 1]
            i -= 1
        new = Stmt('for', init=init, cond=s.cond, step=step.toks, body=Stmt('block', body=body))
    elif kind == 'while2do':
        new = Stmt('if', cond=list(s.cond), then=Stmt('block', body=[Stmt('do', body=s.body, cond=list(s.cond))]), else_=None)
    else:
        inner = s.then.body[0] if s.then.kind == 'block' else s.then
        new = Stmt('while', cond=s.cond, body=inner.body)
    new.lead = s.lead
    c[i] = new
    return True


def rw_cast(func, rng):
    sites = []
    for s in walk(func.body):
        if s.kind in ('if', 'while', 'do', 'for') and s.cond:
            sites.append(('bool', s, 'cond', 0))
        if s.kind == 'simple' and s.toks:
            if s.toks[0] == 'return' and len(s.toks) > 1:
                if func.returns_bool:
                    sites.append(('bool', s, 'toks', 1))
                sites.append(('drop', s, 'toks', 1))
            d = declaration(s.toks)
            if d and d[1] is not None:
                ty = [t for t in s.toks[:d[1] - 1] if t not in ('static', 'register')]
                if 'auto' not in ty and '&' not in ty and ty:
                    sites.append(('decl', s, 'toks', d[1] + 1))
            elif not d:
                tree = _top_assign(s.toks)
                if tree is not None:
                    sites.append(('drop', s, 'toks', tree.opi + 1))
    if not sites:
        return False
    kind, s, attr, lo = rng.choice(sites)
    toks = getattr(s, attr)
    head, e = toks[:lo], toks[lo:]
    if kind == 'bool':
        if e[:3] == ['(', 'bool', ')']:
            e = e[3:]
        else:
            e = ['(', 'bool', ')', '('] + e + [')']
    elif kind == 'decl':
        d = declaration(s.toks)
        ty = [t for t in s.toks[:d[1] - 1] if t not in ('static', 'register', 'const')]
        if e[:len(ty) + 2] == ['('] + ty + [')']:
            e = e[len(ty) + 2:]
        else:
            e = ['('] + ty + [')', '('] + e + [')']
    else:
        try:
            tree = parse_expr(e)
        except SyntaxError:
            return False
        if tree.kind != 'cast':
            return False
        inner = e[1:e.index(')')]
        if not all(t in ARITH_TYPES for t in inner):
            return False
        e = e[tree.kids[0].lo:]
    setattr(s, attr, head + e)
    return True


def rw_const(func, rng):
    sites = []
    for s in walk(func.body):
        if s.kind == 'simple':
            d = declaration(s.toks)
            if d and 'static' not in s.toks[:2]:
                sites.append(s)
    if not sites:
        return False
    s = rng.choice(sites)
    d = declaration(s.toks)
    name_at = (d[1] if d[1] is not None else len(s.toks)) - 1
    if rng.random() < 0.3 and '*' in s.toks[:name_at]:
        if s.toks[name_at - 1] == 'const':
            del s.toks[name_at - 1]
        else:
            s.toks.insert(name_at, 'const')
    elif s.toks[0] == 'const':
        del s.toks[0]
    else:
        s.toks.insert(0, 'const')
    return True


def _simple_lvalue(toks):
    return bool(toks) and all(is_id(t) or t in ('.', '->', '::') for t in toks) and is_name(toks[0])


def rw_split(func, rng):
    local = func.locals()
    sites = []
    for c in containers(func.body):
        for i, s in enumerate(c):
            if s.kind != 'simple' or not s.toks:
                continue
            d = declaration(s.toks)
            nxt = c[i + 1] if i + 1 < len(c) and c[i + 1].kind == 'simple' else None
            if d:
                ty = s.toks[:d[1] if d[1] is not None else len(s.toks)]
                if d[1] is not None and not ({'const', '&', 'auto', 'static'} & set(ty)):
                    sites.append(('decl', c, i))
                if d[1] is None and nxt is not None:
                    t = _top_assign(nxt.toks)
                    if t is not None and nxt.toks[:t.opi] == [d[0]]:
                        sites.append(('undecl', c, i))
                continue
            if s.toks[0] in ('return', 'break', 'continue', 'goto', 'delete'):
                continue
            try:
                tree = parse_expr(s.toks)
            except SyntaxError:
                continue
            if tree.kind == 'assign' and tree.op != '=' and _simple_lvalue(s.toks[:tree.opi]):
                sites.append(('expand', c, i))
            if tree.kind == 'assign' and tree.op == '=' and tree.kids[1].kind == 'bin' and tree.kids[1].op in ARITH_OPS:
                rhs = tree.kids[1]
                lhs = s.toks[:tree.opi]
                if s.toks[rhs.kids[0].lo:rhs.kids[0].hi] == lhs and _simple_lvalue(lhs):
                    sites.append(('compound', c, i))
                elif lhs and len(lhs) == 1 and lhs[0] in local and lhs[0] not in names_in(s.toks[rhs.kids[1].lo:rhs.kids[1].hi]):
                    sites.append(('splitop', c, i))
            if tree.kind == 'assign' and tree.op in ('+=', '-=', '*=', '|=', '&=', '^=') and i > 0 and c[i - 1].kind == 'simple':
                prev = _top_assign(c[i - 1].toks)
                lhs = s.toks[:tree.opi]
                if (prev is not None and len(lhs) == 1 and lhs[0] in local and c[i - 1].toks[:prev.opi] == lhs
                        and lhs[0] not in names_in(s.toks[tree.opi + 1:])):
                    sites.append(('mergeop', c, i))
            if tree.kind in ('un', 'post') and tree.op in ('++', '--') or (tree.kind == 'assign' and tree.op in ('+=', '-=')
                                                                         and s.toks[tree.opi + 1:] == ['1']):
                sites.append(('incr', c, i))
    if not sites:
        return False
    kind, c, i = rng.choice(sites)
    s = c[i]
    if kind == 'decl':
        d = declaration(s.toks)
        c.insert(i + 1, Stmt('simple', toks=[d[0], '='] + s.toks[d[1] + 1:]))
        s.toks = s.toks[:d[1]]
    elif kind == 'undecl':
        nxt = c[i + 1]
        t = _top_assign(nxt.toks)
        s.toks = s.toks + ['='] + nxt.toks[t.opi + 1:]
        s.lead += nxt.lead
        del c[i + 1]
    elif kind == 'expand':
        tree = parse_expr(s.toks)
        lhs, op = s.toks[:tree.opi], tree.op[:-1]
        s.toks = lhs + ['='] + lhs + [op, '('] + s.toks[tree.opi + 1:] + [')']
    elif kind == 'compound':
        tree = parse_expr(s.toks)
        rhs = tree.kids[1]
        s.toks = s.toks[:tree.opi] + [rhs.op + '='] + s.toks[rhs.kids[1].lo:rhs.kids[1].hi]
    elif kind == 'splitop':
        tree = parse_expr(s.toks)
        rhs = tree.kids[1]
        lhs = s.toks[:tree.opi]
        first = Stmt('simple', toks=lhs + ['='] + s.toks[rhs.kids[0].lo:rhs.kids[0].hi])
        first.lead = s.lead
        s.lead = []
        s.toks = lhs + [rhs.op + '='] + s.toks[rhs.kids[1].lo:rhs.kids[1].hi]
        c.insert(i, first)
    elif kind == 'mergeop':
        tree = parse_expr(s.toks)
        prev = c[i - 1]
        p = _top_assign(prev.toks)
        prev.toks = prev.toks[:p.opi] + ['=', '('] + prev.toks[p.opi + 1:] + [')', tree.op[:-1], '('] + s.toks[tree.opi + 1:] + [')']
        prev.lead += s.lead
        del c[i]
    else:
        tree = parse_expr(s.toks)
        if tree.kind == 'assign':
            name, op = s.toks[:tree.opi], tree.op[0] * 2
        else:
            name, op = s.toks[tree.kids[0].lo:tree.kids[0].hi], tree.op
        forms = [[op] + name, name + [op], name + [op[0] + '=', '1']]
        s.toks = rng.choice([f for f in forms if f != s.toks])
    return True


REWRITES = {'reorder': rw_reorder, 'commute': rw_commute, 'temp': rw_temp, 'if': rw_if, 'loop': rw_loop,
            'cast': rw_cast, 'const': rw_const, 'split': rw_split}


# --------------------------------------------------------------- source

class Source:
    """A source file split around one function: prefix, header, body, suffix."""

    def __init__(self, text, address):
        m = next((m for m in check.RETAIL.finditer(text) if int(m.group(1), 16) == address), None)
        if not m:
            raise SystemExit(f'no // @retail 0x{address:08X} marker')
        pos = text.find('\n', m.end()) + 1 or len(text)
        seen, depth = False, 0
        for t in TOKEN.finditer(text, pos):
            kind = t.lastgroup
            if kind in ('ws', 'comment', 'pp'):
                if kind != 'ws' and not seen:
                    if re.match(r'//\s*@retail', t.group()):
                        raise SystemExit(f'0x{address:08X} has no body in this file (an inline defined elsewhere)')
                    pos = t.end()
                continue
            seen = True
            tok = t.group()
            if depth == 0 and tok == ';':
                raise SystemExit(f'0x{address:08X} has no body in this file (a declaration)')
            if depth == 0 and tok == '{':
                break
            depth += (tok == '(') - (tok == ')')
        else:
            raise SystemExit('function body not found')
        open_ = t.start()
        depth = 0
        for t in TOKEN.finditer(text, open_):
            depth += (t.group() == '{') - (t.group() == '}')
            if depth == 0:
                close = t.start()
                break
        else:
            raise SystemExit('unbalanced braces')
        while text[pos] in ' \t\r\n':
            pos += 1
        self.prefix, self.header = text[:pos], text[pos:open_]
        self.body, self.suffix = text[open_ + 1:close], text[close + 1:]
        self.line = text[:pos].count('\n') + 1
        self.end_line = text[:close + 1].count('\n') + 1

    def function(self):
        params = _params(self.header)
        return Function(self.header, tokenize(self.body), params)

    def with_function(self, text):
        return f'{self.prefix}#line {self.line}\n{text}\n#line {self.end_line}{self.suffix}'


def _params(header):
    """Parameter names of a function header."""
    toks = [t for k, t in tokenize(header) if k not in ('comment', 'pp')]
    if '(' not in toks:
        return set()
    i = toks.index('(')
    j = _match([(None, t) for t in toks], i, '(', ')')
    names, depth, last = set(), 0, None
    for t in toks[i + 1:j] + [',']:
        if t in ('(', '<', '['):
            depth += 1
        elif t in (')', '>', ']'):
            depth -= 1
        if depth == 0 and t in (',', '='):
            if last and is_name(last):
                names.add(last)
            last = None
        elif depth == 0 and last is not False:
            last = t if t != '=' else False
    return names


# --------------------------------------------------------------- scoring

D_FORM = {14, 24, 25, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 48, 49, 50, 51, 52, 53, 54, 55, 58, 62}


def words(data):
    return [int.from_bytes(data[i:i + 4], 'big') for i in range(0, len(data) - 3, 4)]


def normalize(ws):
    """Instruction words with the fields that relocations or layout fill in
    cleared: branch displacements, lis immediates, and the low half of a
    D-form instruction addressing through a register a recent lis set."""
    out, hot = [], {}
    for w in ws:
        op = w >> 26
        ra = (w >> 16) & 31
        if op == 18:
            k = w & 0xFC000003
        elif op == 16:
            k = w & 0xFFFF0003
        elif op == 15 and ra == 0:
            k = w & 0xFFFF0000
            hot[(w >> 21) & 31] = 9
        elif op in D_FORM and hot.get(ra):
            k = w & 0xFFFF0000
        else:
            k = w
        hot = {r: n - 1 for r, n in hot.items() if n > 1}
        out.append(k)
    return out


def same_instruction(a, b):
    """Same opcode (and extended opcode where there is one)."""
    if a >> 26 != b >> 26:
        return False
    if a >> 26 in (19, 31, 59, 63, 4):
        return (a >> 1) & 0x3FF == (b >> 1) & 0x3FF
    return True


def diff_score(ours, retail):
    """Cost of turning our instruction words into retail's."""
    a, b = normalize(words(ours)), normalize(words(retail))
    cost = 0
    for tag, i1, i2, j1, j2 in difflib.SequenceMatcher(None, a, b, autojunk=False).get_opcodes():
        if tag == 'equal':
            continue
        n = min(i2 - i1, j2 - j1) if tag == 'replace' else 0
        cost += sum(1 if same_instruction(x, y) else 2 for x, y in zip(a[i1:i1 + n], b[j1:j1 + n]))
        cost += 2 * (max(i2 - i1, j2 - j1) - n)
    return cost


class Target:
    """What a candidate is compiled with and compared against."""

    def __init__(self, src, address, retail, row, cmd, cl, includes, same_name=None):
        self.src, self.address, self.retail, self.row = Path(src), address, retail, row
        self.cmd, self.cl, self.includes, self.same_name = cmd, cl, includes, same_name

    @classmethod
    def load(cls, src, address, ctx):
        row = ctx.row(address)
        cmd = ctx.cmd(check.parse_markers(src)[0])
        # candidates compile from a work directory: the source's own one
        # still resolves its relative includes
        includes = [Path(src).resolve().parent] + ctx.includes
        return cls(src, address, ctx.retail(row), row, cmd, ctx.cl, includes, ctx.same_name)

    def score(self, text, work):
        """(score, status) of a candidate file's text; None if it doesn't compile."""
        work.mkdir(parents=True, exist_ok=True)
        cpp, obj = work / 'candidate.cpp', work / 'candidate.obj'
        cpp.write_text(text, encoding='utf-8')
        if obj.exists():
            obj.unlink()
        r = check.compile_file(self.cl, self.cmd, self.includes, cpp, obj)
        if r.returncode or not obj.exists():
            return None
        try:
            status, data = check.function_status(coff.parse(obj.read_bytes()), self.row, self.retail, self.same_name)
        except KeyError:
            return None
        return (0 if status == 'matched' else max(1, diff_score(data, self.retail))), status


# ---------------------------------------------------------------- search

def worker(args):
    """One random walk; returns its improvements [(score, iteration, kinds, function text)]."""
    target, source_text, start_score, wid, seed, deadline, iterations, kinds, work, queue = args
    rng = random.Random(seed * 1009 + wid)
    source = Source(source_text, target.address)
    best = source.function()
    stats = {'iterations': 0, 'compiled': 0, 'failed': 0, 'rewrite_errors': 0}
    best_score = start_score
    seen = {best.text()}
    found = []
    it = 0
    while (iterations is None or it < iterations) and time.time() < deadline and best_score > 0:
        it += 1
        cand = copy.deepcopy(best)
        applied = []
        for _ in range(rng.choice((1, 1, 1, 2, 2, 3))):
            kind = rng.choice(kinds)
            try:
                if REWRITES[kind](cand, rng):
                    applied.append(kind)
            except Exception:  # a rewrite that met code it doesn't understand
                stats['rewrite_errors'] += 1
        if not applied:
            continue
        text = cand.text()
        if text in seen:
            continue
        seen.add(text)
        result = target.score(source.with_function(text), work)
        if result is None:
            stats['failed'] += 1
            continue
        stats['compiled'] += 1
        if result[0] < best_score:
            best, best_score = cand, result[0]
            found.append((best_score, it, applied, text))
            if queue is not None:
                queue.put((wid, best_score, it, applied))
        elif result[0] == best_score and rng.random() < 0.1:
            best = cand
    stats['iterations'] = it
    return wid, found, stats


def permute(target, source_text, jobs=1, seed=0, seconds=60, iterations=None, kinds=None, out=None, progress=print):
    """Run the search; returns the result dict (and writes it under `out`)."""
    kinds = kinds or list(REWRITES)
    out = Path(out or paths.BUILD / 'permute' / f'{target.address:08X}')
    out.mkdir(parents=True, exist_ok=True)
    source = Source(source_text, target.address)
    base = target.score(source_text, out / 'base')
    if base is None:
        raise SystemExit('the source as written does not compile')
    rendered = target.score(source.with_function(source.function().text()), out / 'base')
    if rendered is None:
        raise SystemExit('the function as re-rendered does not compile')
    progress(f'base score {base[0]} ({base[1]}); re-rendered unchanged: {rendered[0]}')
    deadline = time.time() + seconds
    queue = multiprocessing.Manager().Queue() if jobs > 1 else None
    tasks = [(target, source_text, rendered[0], w, seed, deadline, iterations, kinds, out / f'w{w}', queue)
             for w in range(jobs)]
    if jobs > 1:
        with multiprocessing.Pool(jobs) as pool:
            pending = pool.map_async(worker, tasks)
            while not pending.ready():
                pending.wait(1)
                while not queue.empty():
                    wid, sc, it, applied = queue.get()
                    progress(f'worker {wid} iteration {it}: score {sc} ({", ".join(applied)})')
            results = pending.get()
    else:
        results = [worker(tasks[0])]
        for _, found, _ in results:
            for sc, it, applied, _ in found:
                progress(f'worker 0 iteration {it}: score {sc} ({", ".join(applied)})')
    improvements = sorted(((sc, wid, it, applied, text) for wid, found, _ in results for sc, it, applied, text in found),
                          key=lambda x: x[:3])
    helped = dict(collections.Counter(k for *_, applied, _ in improvements for k in applied))
    result = {'source': str(target.src), 'address': f'0x{target.address:08X}', 'base_score': base[0],
              'base_status': base[1], 'best_score': base[0], 'seed': seed, 'jobs': jobs, 'kinds': kinds,
              'improvements': [{'score': sc, 'worker': wid, 'iteration': it, 'kinds': applied}
                               for sc, wid, it, applied, _ in improvements],
              'kinds_helped': helped,
              'stats': {k: sum(st[k] for _, _, st in results) for k in ('iterations', 'compiled', 'failed', 'rewrite_errors')}}
    if improvements and improvements[0][0] < base[0]:
        best = improvements[0]
        result['best_score'] = best[0]
        (out / 'best.cpp').write_text(source.with_function(best[4]), encoding='utf-8')
        (out / 'best_function.cpp').write_text(best[4] + '\n', encoding='utf-8')
    (out / 'result.json').write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
    return result


def parse_address(src, which, by_address):
    if re.fullmatch(r'0x[0-9A-Fa-f]+', which):
        return int(which, 16)
    _, addresses = check.parse_markers(src)
    hits = [va for va in addresses if va in by_address and which in (by_address[va]['name'], by_address[va]['name'].split('::')[-1])]
    if len(hits) != 1:
        raise SystemExit(f'{which}: {len(hits)} marked functions of that name in {src}')
    return hits[0]


def main(argv=None):
    ap = argparse.ArgumentParser(description='Search for source rewrites that bring a function closer to retail.')
    ap.add_argument('source')
    ap.add_argument('function', help='retail address (0x...) or name of a marked function')
    ap.add_argument('--jobs', type=int, default=max(1, (os.cpu_count() or 2) // 2))
    ap.add_argument('--seed', type=int, default=0)
    ap.add_argument('--time', type=float, help='seconds (default 300, or unlimited with --iterations)')
    ap.add_argument('--iterations', type=int, help='per worker; with --seed, a deterministic run')
    ap.add_argument('--kinds', help='comma-separated: ' + ','.join(REWRITES))
    ap.add_argument('--out', help='output directory (default build/permute/<address>)')
    args = ap.parse_args(argv)
    src = paths.require(Path(args.source).resolve())
    ctx = check.Context()
    address = parse_address(src, args.function, ctx.by_address)
    kinds = args.kinds.split(',') if args.kinds else None
    if kinds and set(kinds) - set(REWRITES):
        raise SystemExit(f'unknown kinds: {", ".join(sorted(set(kinds) - set(REWRITES)))}')
    target = Target.load(src, address, ctx)
    seconds = args.time if args.time is not None else (300 if args.iterations is None else 1e9)
    result = permute(target, src.read_text(encoding='utf-8'), args.jobs, args.seed, seconds, args.iterations, kinds, args.out)
    print(f"best score {result['best_score']} (base {result['base_score']}); helped: {result['kinds_helped'] or 'none'}")
    return 0 if result['best_score'] == 0 else 1


if __name__ == '__main__':
    sys.exit(main())
