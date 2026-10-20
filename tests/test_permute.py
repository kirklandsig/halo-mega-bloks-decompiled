import random

import pytest

import check
import coff
import inventory
import paths
import permute

SOURCE = '''// @object Unity_Test.cpp.obj
#include "x.h"

// @retail 0x82000100
int PermuteTest(int a, int b, int c)
{
    // the products
    int x = a * b;
    int y = c - a;
    for (int i = 0; i < c; i++)
    {
        x += i;
    }
    if (x > 0)
    {
        y = 1;
    }
    else
    {
        y = 2;
    }
    y = y + a * c;
    return y == x;
}

int After() { return 0; }
'''


def function():
    return permute.Source(SOURCE, 0x82000100).function()


def body(f):
    return '\n'.join(permute.render(f.body))


def test_source_splits_around_the_function():
    src = permute.Source(SOURCE, 0x82000100)
    assert src.header.startswith('int PermuteTest(int a, int b, int c)')
    assert src.suffix.startswith('\n\nint After()')
    out = src.with_function(src.function().text())
    # line numbers inside and after the function stay those of the file
    assert '#line 5\nint PermuteTest' in out and '#line 24' in out
    assert permute._params(src.header) == {'a', 'b', 'c'}


def test_round_trip_keeps_tokens_and_comments():
    f = function()
    src = permute.Source(SOURCE, 0x82000100)
    want = [t for k, t in permute.tokenize(src.header + '{' + src.body + '}')]
    assert [t for k, t in permute.tokenize(f.text())] == want


def test_markers_without_a_body_are_refused():
    text = '// @retail 0x82000100\n// Foo::Foo (in the header)\n// @retail 0x82000200\nvoid g() {}\n'
    with pytest.raises(SystemExit, match='no body'):
        permute.Source(text, 0x82000100)
    with pytest.raises(SystemExit, match='no body'):
        permute.Source('// @retail 0x82000100\nextern int x;\n', 0x82000100)


def test_expressions_parse_with_precedence_and_casts():
    toks = [t for _, t in permute.tokenize('a + b * c == (int)d - -e')]
    tree = permute.parse_expr(toks)
    assert (tree.kind, tree.op) == ('bin', '==')
    left, right = tree.kids
    assert (left.op, left.kids[1].op) == ('+', '*')
    assert right.op == '-' and right.kids[0].kind == 'cast' and right.kids[1].kind == 'un'
    call = permute.parse_expr([t for _, t in permute.tokenize('p->Get<UFoo>(x, y + 1).Num()')])
    assert call.kind == 'call' and call.kids[0].kind == 'member'


def test_declarations():
    decl = lambda s: permute.declaration([t for _, t in permute.tokenize(s)])
    assert decl('const FVector &Dir = Rot.Vector()') == ('Dir', 4)
    assert decl('TArray<int> Items') == ('Items', None)
    assert decl('x = y') is None
    assert decl('p->f(x)') is None
    assert decl('return a') is None


def test_independence():
    s = lambda text: permute.Stmt('simple', toks=[t for _, t in permute.tokenize(text)])
    local = {'a', 'b', 'x', 't'}
    assert permute.independent(s('a = 1'), s('b = 2'), local)
    assert not permute.independent(s('a = 1'), s('b = a'), local)
    assert not permute.independent(s('f()'), s('g()'), local)
    assert permute.independent(s('int t = x + 1'), s('f()'), local)
    assert not permute.independent(s('t = x + 1'), s('f(t)'), local)
    assert not permute.independent(s('m_y = 1'), s('f()'), local)  # a member the call may read


def test_commute_mirrors_and_keeps_grouping():
    f = function()
    toks = f.body[-1].toks
    assert toks == ['return', 'y', '==', 'x']
    rng = random.Random(1)
    while not permute.rw_commute(f, rng) or f.body[-1].toks == toks:
        pass
    assert f.body[-1].toks == ['return', 'x', '==', 'y']
    g = permute.Function('int g()', permute.tokenize('return a - b + c;'), set())
    permute.rw_commute(g, random.Random(0))
    assert body(g).strip() == 'return c + (a - b);'


def test_each_kind_applies_to_the_sample():
    for kind, rw in permute.REWRITES.items():
        rng = random.Random(0)
        hits = 0
        for _ in range(20):
            f = function()
            before = body(f)
            if rw(f, rng):
                hits += 1
                assert body(f) != before, kind
                permute.Source(SOURCE, 0x82000100).with_function(f.text())  # renders
        assert hits, kind


def test_specific_rewrites():
    f = function()
    loop = f.body[2]
    assert loop.kind == 'for'
    rng = random.Random(0)
    while True:
        f = function()
        permute.rw_loop(f, rng)
        if f.body[2].kind == 'block':
            break
    assert body(f).split('\n')[3:5] == ['    {', '        int i = 0;']
    g = permute.Function('void g()', permute.tokenize('if (x > 0) { y = 1; } else { y = 2; }'), set())
    seed = 0
    while '?' not in body(g):
        g = permute.Function('void g()', permute.tokenize('if (x > 0) { y = 1; } else { y = 2; }'), set())
        permute.rw_if(g, random.Random(seed))
        seed += 1
    assert body(g).strip() == 'y = (x > 0) ? (1) : (2);'
    permute.rw_if(g, random.Random(0))  # and back
    assert [s.kind for s in g.body] == ['if']


def test_diff_score():
    ret = bytes.fromhex('7d6321d6' '7d432850' '7d2a5850' '4e800020')
    assert permute.diff_score(ret, ret) == 0
    # a register-only difference costs 1, another instruction 2
    assert permute.diff_score(bytes.fromhex('7d6321d6' '7d432850' '7d2b5050' '4e800020'), ret) == 1
    assert permute.diff_score(bytes.fromhex('7d6321d6' '7d432850' '4e800020'), ret) == 2
    # relocated fields don't count: bl targets, lis/addi pairs
    a = bytes.fromhex('48000001' '3d600000' '396b0000')
    b = bytes.fromhex('4bff0f05' '3d608200' '396b1234')
    assert permute.diff_score(a, b) == 0


@pytest.mark.orig
def test_permute_finds_a_commuted_compare(tmp_path):
    xdk = paths.xdk()
    if not (xdk / 'bin' / 'win32' / 'cl.exe').exists():
        pytest.skip('needs the XDK')
    cmd = {r['object']: r for r in inventory.read_csv(paths.CONFIG / 'objects.csv')}['Unity_HaloRBTKamikazeEtAl.cpp.obj']['cmd']
    includes = [tmp_path, paths.ROOT / 'include', xdk / 'include' / 'xbox']
    cl = xdk / 'bin' / 'win32' / 'cl.exe'

    def compiled(expr):
        src = tmp_path / 'retail.cpp'
        src.write_text(f'int PermuteTest(int a, int b, int c)\n{{\n    int x = a * b;\n    int y = c - a;\n    return {expr};\n}}\n')
        obj = tmp_path / 'retail.obj'
        assert check.compile_file(cl, cmd, includes, src, obj).returncode == 0
        return coff.function_bytes(coff.parse(obj.read_bytes()), '?PermuteTest@@YAHHHH@Z')[0]

    retail = compiled('x == y')
    assert compiled('y == x') != retail
    text = ('// @retail 0x82000100\nint PermuteTest(int a, int b, int c)\n{\n    int x = a * b;\n'
            '    int y = c - a;\n    return y == x;\n}\n')
    row = {'address': '0x82000100', 'symbol': '', 'name': 'PermuteTest', 'object': 'test.obj'}
    target = permute.Target(tmp_path / 'test.cpp', 0x82000100, retail, row, cmd, cl, includes)
    out = tmp_path / 'out'
    result = permute.permute(target, text, jobs=1, seed=0, seconds=600, iterations=20, kinds=['commute', 'const'],
                             out=out, progress=lambda *_: None)
    assert result['base_score'] > 0 and result['best_score'] == 0
    assert 'commute' in result['kinds_helped']
    assert 'return x == y;' in (out / 'best.cpp').read_text()
    again = permute.permute(target, text, jobs=2, seed=0, seconds=600, iterations=20, kinds=['commute', 'const'],
                            out=tmp_path / 'out2', progress=lambda *_: None)
    assert again['best_score'] == 0
