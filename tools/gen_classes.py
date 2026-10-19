"""Writes the C++ that UE3's class macros expand to, for n-Space's native
classes: DECLARE_CLASS's inline members (operator new, the constructor and
destructor, InternalConstructor, StaticClass) and IMPLEMENT_CLASS's two
functions (GetPrivateStaticClass<Class>, InitializePrivateStaticClass<Class>).

    python tools/gen_classes.py <package> [...]

For each package it writes include/<Package>/Inc/<Package>Classes.h (the
classes' declarations from the PDB through gen_header.py, then the macro
bodies; a hand-written part below gen_header's marker is kept) and, for each
object holding the package's rows, src/<Package>/Src/<Object>Classes.cpp
with a // @retail marker per generated function. Rows come from
config/functions.csv (owner nspace). Script facts (within, config) come from
script/<Package>/Classes/.
"""
import argparse
import re
import struct
from pathlib import Path

import gen_header
import inventory
import paths
import pdbtype
from pdbfile import IMAGE_BASE

# Classes the hand-written code of a package needs in its header as well:
# with their members (TARGETS) or opaque (OPAQUE).
TARGETS = {'MegaHaloGame': ['FSystemSettings', 'FArchive', 'FMemoryArchive', 'FArchiveProxy'], 'UDKBase': ['FRenderCommandFence', 'FBox', 'FOutputDeviceRedirectorBase', 'UCCSBlackboard', 'FCCSTargetData', 'FCCSCoverData', 'FCCSMoveCmdData', 'CCSAFFactory', 'UCCSAFExitCover', 'UCCSAFIdle', 'UCCSAFMoveTo', 'UCCSAFStrafeTo', 'UCCSAFFlee', 'UCCSAFOrientToward', 'UCCSAFMoveToActor', 'UCCSAFStrafeTarget', 'UCCSAFEncircleTarget', 'UCCSAFFireBurst', 'UCCSAFEnterCover', 'UCCSAFGetInCover', 'UCCSAFGetOutCover', 'AUDKWeaponPawn', 'AUDKCover', 'ACoverLink', 'UUDKTargetableComponent', 'CCSNorman', 'FVector', 'AActor', 'CCSPSTargetAwareness', 'CCSPSCover',
                       'ActorWrapper', 'CCSGameCover', 'FCoverInfo', 'CCSCharacter', 'CCSGameCharacter', 'FCoverSlot',
                       'APawn', 'UActorComponent', 'ACCSController', 'CCSBrain', 'Grip_Vector', 'AController',
                       'UAnimNode', 'UAnimNodeBlendBase', 'UAnimNodeBlendList', 'FAnimBlendChild', 'UUDKAnimBlendBase',
                       'UUDKAnimBlendByPhysics', 'UUDKAnimBlendByTurnInPlace', 'UUDKAnimNodeCopyBoneTranslation',
                       'FAimOffsetProfile', 'USkeletalMeshComponent', 'UProperty', 'UClass', 'UObject', 'UStruct', 'UField',
                       'UAnimObject', 'AUDKPawn', 'Grip_Rotation', 'FRotator', 'Kaim::IQuery', 'Kaim::BaseAStarQuery', 'CCSTarget', 'CCSMeatPuppet', 'GwNavBot', 'UGwNavBotHandle', 'Kaim::Bot',
                       'GripRBTNumericCondition<float>', 'GripRBTNumericCondition<int>']}
OPAQUE = {'MegaHaloGame': ['FMemoryWriter', 'FMemoryReader', 'FObjectAndNameAsStringProxyArchive'],
          'UDKBase': ['Grip::Memory', 'Grip::MemoryHeap', 'GripRBTAllocator', 'UWorld', 'AUDKPlayerController', 'CCSBlackboard', 'EPhysics', 'ECoverType', 'GwNavEngineServices', 'Kaim::World', 'Kaim::Memory', 'Kaim::MemoryHeap', 'GripEngineServices', 'IGripEngineServices', 'UAnimNodeAimOffset', 'UHaloAnimBlendByJumpLand', 'UByteProperty',
                       # the behaviour-tree nodes' runtime classes
                       'CCSRBTEnemyClosestRange',
                       'CCSRBTEnemyLowestLKPAge',
                       'CCSRBTMoveToBestCover',
                       'CCSRBTSelectTarget',
                       'CCSRBTTargetRange',
                       'CCSRBTTimeSinceAimedAt',
                       'CCSRBTTimeSinceBecameAware',
                       'CCSRBTTimeSinceDamage',
                       'CCSRBTTimeSinceEvent',
                       'CCSRBTTimeSinceGrenadeStuck',
                       'CCSRBTTimeSinceStaggered',
                       'CCSRBTTimeSinceSuccessfulAttack',
                       'CCSRBTTimeSinceTargetCamoed',
                       'CCSRBTTimeSinceThreatChanged',
                       'CCSRBTTimeSinceThreatened',
                       'CCSRBTEncircleTarget',
                       'CCSRBTEnemyAware',
                       'CCSRBTMoveToClosestCover',
                       'CCSRBTMoveToInitialCover',
                       'CCSRBTMoveToTether',
                       'CCSRBTSearch',
                       'CCSRBTShoot',
                       'CCSRBTShootFromCover',
                       'CCSRBTStrafeTarget',
                       'CCSRBTTargetAngle',
                       'CCSRBTTargetClear',
                       'CCSRBTTargetInCover',
                       'CCSRBTTargetKnockedDown',
                       'CCSRBTTargetShootable',
                       'CCSRBTTargetVisible',
                       'CCSRBTVisibleToPlayerCamera',
                       'CCSRBTWaitInCover',
                       'HaloRBTKamikaze',
                       ]}
# Member declarations the PDB lacks (member templates), per package.
EXTRA = {'UDKBase': {'IGripBTInterface': ['template <class T0> T0 *GetBlackboard();'],
                     'IGripAFInterface': ['template <class T0> T0 *GetSystem();'],
                     # the action handles' CreateAction call it
                     'CCSAFFactory': ['HG_PRIVATE:', 'template <class AO, class AF> int CreateActionInternal(const AO &);', 'public:']
                     + [f'friend class UCCSAF{a};' for a in ('ExitCover', 'Idle', 'MoveTo', 'StrafeTo', 'Flee', 'OrientToward', 'MoveToActor',
                                                             'StrafeTarget', 'EncircleTarget', 'FireBurst', 'EnterCover', 'GetInCover', 'GetOutCover')]}}
# Event thunks of other classes that a package's code calls (inlined there).
EVENTS = {'UDKBase': ['ACoverLink::eventSetDisabled']}


def code_rows(package):
    """A package's rows of n-Space's code: owner nspace, and the rest of
    its AI library (udkbase\\ccsref*), which the owner heuristic splits."""
    return [r for r in inventory.read_csv(paths.CONFIG / 'functions.csv') if r['package'] == package.lower()
            and (r['owner'] == 'nspace' or r['source'].startswith('udkbase\\ccsref'))]


def nspace_rows():
    return [r for r in inventory.read_csv(paths.CONFIG / 'functions.csv') if r['owner'] == 'nspace']


def script_packages():
    """{script class name: package} from config/script_classes.csv."""
    return {r['class']: r['package'] for r in inventory.read_csv(paths.CONFIG / 'script_classes.csv')}


def script_header(package, cls):
    """(within, config) of a native class's script declaration."""
    path = paths.ROOT / 'script' / package / 'Classes' / f'{cls[1:]}.uc'
    text = path.read_text(encoding='utf-8', errors='replace') if path.exists() else ''
    head = text.split(';', 1)[0]
    within = re.search(r'\bwithin\s+(\w+)', head)
    config = re.search(r'\bconfig\((\w+)\)', head)
    return (within.group(1) if within else None), (config.group(1) if config else None)


def kind(row):
    """The macro member a row is, or None: 'new', 'ctor', 'dtor', 'sdd'
    (scalar deleting destructor), 'internal', 'static', 'get', 'init',
    'event' (a script event's thunk)."""
    name = row['name']
    if '::' not in name:
        return None
    cls, member = name.rsplit('::', 1)
    cls = cls.split('::')[-1]
    if member == 'operator new' and 'EInternal' in row['symbol']:
        return 'new'
    if member == cls:
        return 'ctor'
    if member == '~' + cls:
        return 'dtor'
    if member == "`scalar deleting destructor'":
        return 'sdd'
    if member == 'InternalConstructor':
        return 'internal'
    if member == 'StaticClass':
        return 'static'
    if member == f'GetPrivateStaticClass{cls}':
        return 'get'
    if member == f'InitializePrivateStaticClass{cls}':
        return 'init'
    if re.match(r'event[A-Z]', member):
        return 'event'
    if re.match(r'exec[A-Z]', member):
        return 'exec'
    return None


class Classes:
    """The macro bodies of one package's native classes."""

    def __init__(self, types, package, rows):
        self.t = types
        self.package = package
        all_rows = rows
        rows = [r for r in rows if r['package'] == package.lower() and kind(r)]
        self.events = [r for r in rows if kind(r) == 'event']
        self.execs = [r for r in rows if kind(r) == 'exec']
        rows = [r for r in rows if kind(r) not in ('event', 'exec')]
        self.classes = sorted(c for c in {r['name'].rsplit('::', 1)[0] for r in rows} if self.is_uobject(c))
        self.rows = [r for r in rows if r['name'].rsplit('::', 1)[0] in self.classes] + self.events + self.execs
        self.events_all = self.events + [{'name': n} for n in EVENTS.get(package, [])]
        event_classes = sorted({r['name'].rsplit('::', 1)[0] for r in self.events_all + self.execs})
        self.tiny = [(r, shape) for r in all_rows if r['package'] == package.lower() and not kind(r)
                     and (shape := tiny_shape(r)) and self._exists(r['name'].rsplit('::', 1)[0])]
        event_classes += sorted({r['name'].rsplit('::', 1)[0] for r, _s in self.tiny})
        self.parms = [self.parms_name(r) for r in self.events_all if self._exists(self.parms_name(r))]
        self.header = gen_header.Header(types)  # a probe, for the member checks below
        # a class whose destructor destroys members needs them rendered
        self.member_targets = sorted({b for c in self.classes for b in self.chain(c) if not self.own_members_trivial(b)})
        # every class with n-Space code in the package, and its bases: their code reads members
        self.code_classes = self.with_bases(sorted(
            c for c in {r['name'].rsplit('::', 1)[0] for r in code_rows(package) if '::' in r['name']}
            if self._exists(c) and self._is_record(c)))
        # and the classes their members point at, and their methods take, one level deep
        self.code_classes = self.with_bases(sorted(set(self.code_classes) | self.referenced(self.code_classes)))
        # structs that exec thunks read or return by value must be complete
        exec_structs = sorted({t for r in self.execs for v in self.native_types(r)
                               for t in [gen_header.template_args(v)[1][0] if v.startswith('TArray<') else v]
                               if re.fullmatch(r'F\w+', t) and self._exists(t)})
        self.header = gen_header.Header(types, self.parms + ['FName', 'UObject', 'UClass'] + TARGETS.get(package, []) + self.member_targets
                                        + self.classes + self.code_classes
                                        + (['FFrame'] if self.execs else []),
                                        self.classes + event_classes + ['UClass'] + exec_structs
                                        + OPAQUE.get(package, []))
        self.packages = script_packages()
        for name, decls in EXTRA.get(package, {}).items():
            self.header.extra.setdefault(name, []).extend(decls)
        for name, ti in self.header.classes.items():  # DECLARE_CLASS's typedef Super
            bases = self.header.bases(ti)
            if bases and any(m['name'] == 'StaticClass' for m in self.header.methods(ti)):
                self.header.extra.setdefault(name, []).append(f'typedef {self.header._rname(bases[0][0])} Super;')

    def _exists(self, name):
        try:
            self.t.find(name)
            return True
        except KeyError:
            return False

    @staticmethod
    def parms_name(row):
        cls, member = row['name'].rsplit('::', 1)
        return f'{cls[1:]}_{member}_Parms'

    def is_uobject(self, cls):
        """Whether `cls` derives from UObject."""
        h = gen_header.Header(self.t)
        while cls != 'UObject':
            try:
                bases = h.bases(self.t.find(cls))
            except KeyError:
                return False
            if not bases:
                return False
            cls = h._rname(bases[0][0])
        return True

    def chain(self, cls):
        """`cls` and its bases up to, not including, UObject."""
        out = []
        while cls != 'UObject':
            out.append(cls)
            bases = self.header.bases(self.t.find(cls))
            cls = self.header._rname(bases[0][0])
        return out

    def own_members_trivial(self, cls):
        """Whether none of `cls`'s own data members has a destructor."""
        return not any(off is not None and self._destructible(mtype)
                       for _n, mtype, off, _a in self.header.members(self.t.find(cls)))

    def _destructible(self, ti):
        if ti < self.t.begin:
            return False
        kind_, p = self.t.record(ti)
        if kind_ in (pdbtype.LF_MODIFIER, pdbtype.LF_ARRAY):
            return self._destructible(int.from_bytes(self.t.data[p:p + 4], 'little'))
        if kind_ not in (pdbtype.LF_CLASS, pdbtype.LF_STRUCTURE, pdbtype.LF_UNION):
            return False
        ti = self.t._resolve(ti)
        if any(m['name'].startswith('~') for m in self.header.methods(ti)):
            return True
        return any(self._destructible(b) for b, _o in self.header.bases(ti)) or any(
            off is not None and self._destructible(t) for _n, t, off, _a in self.header.members(ti))

    def known_cause(self, cls, name):
        """Why a generated member is known not to match, or None."""
        if cls not in self.classes:
            return None
        if name in ('ctor', 'internal') and len(self.header.bases(self.t.find(cls))) > 1:
            return 'the vtable pointers of its interfaces, which the opaque layout leaves out'
        if name in ('dtor', 'sdd') and not self.own_members_trivial(cls) and cls not in self.header.targets:
            return 'the destructor also destroys members, which the opaque layout leaves out'
        return None

    def _is_record(self, name):
        return self.t.record(self.t.find(name))[0] in (pdbtype.LF_CLASS, pdbtype.LF_STRUCTURE, pdbtype.LF_UNION)

    def referenced(self, names):
        """The records that `names`' data members point at or hold, and
        that their methods take or return (through pointers and references)."""
        out = set()

        def record_of(ti):
            while ti >= self.t.begin:
                kind_, p = self.t.record(ti)
                if kind_ in (pdbtype.LF_POINTER, pdbtype.LF_MODIFIER, pdbtype.LF_ARRAY):
                    ti = int.from_bytes(self.t.data[p:p + 4], 'little')
                elif kind_ in (pdbtype.LF_CLASS, pdbtype.LF_STRUCTURE, pdbtype.LF_UNION):
                    name = self.header._rname(self.t._resolve(ti))
                    return None if '<' in name or 'unnamed' in name else name
                else:
                    return None
            return None

        for n in names:
            ti = self.t.find(n)
            types = [t for _m, t, off, _a in self.header.members(ti) if off is not None]
            for m in self.header.methods(ti):
                ret, params = self.signature_types(m['type'])
                types += [ret] + params
            for t in types:
                name = record_of(t)
                if name and self._exists(name):
                    out.add(name)
        return out

    def signature_types(self, mtype):
        d = self.t.data
        _kind, p = self.t.record(mtype)
        ret = int.from_bytes(d[p:p + 4], 'little')
        args = int.from_bytes(d[p + 16:p + 20], 'little')
        _akind, ap = self.t.record(args)
        count = int.from_bytes(d[ap:ap + 4], 'little')
        return ret, [int.from_bytes(d[ap + 4 + 4 * i:ap + 8 + 4 * i], 'little') for i in range(count)]

    def with_bases(self, names):
        """`names` and all their bases, recursively."""
        out, todo = set(), list(names)
        while todo:
            n = todo.pop()
            if n in out:
                continue
            out.add(n)
            todo += [self.header._rname(b) for b, _o in self.header.bases(self.t.find(n))]
        return sorted(out)

    def native_types(self, row):
        """The value types (no const, no reference) of the native function
        an exec<Name> row calls."""
        cls, member = row['name'].rsplit('::', 1)
        out = []
        for m in self.header.methods(self.t.find(cls)):
            if m['name'] == member[4:]:
                ret, params = self.signature(m['type'])
                out += [re.sub(r'^const |\s*&$', '', t) for t in [ret] + params]
        return out

    def out_of_line(self):
        """Names of functions defined in a .cpp (not inline in a header).
        A constructor row from a .cpp counts for every overload: the PDB
        often has no decorated name to tell which one it is."""
        if not hasattr(self, '_out_of_line'):
            self._out_of_line = {r['name'] for r in inventory.read_csv(paths.CONFIG / 'functions.csv')
                                 if r['source'].endswith('.cpp')}
        return self._out_of_line

    def script_struct_constructors(self):
        """The script compiler's empty default constructor of each struct
        that has one beside its (EEventParm) one, unless the struct's
        cpptext defines it in a .cpp (an out-of-line row)."""
        defined = self.out_of_line()
        out = []
        for t, ti in sorted(self.header.classes.items()):
            short = gen_header.split_scope(t)[-1]
            ctors = [self.header.method_decl(t, m) for m in self.header.methods(ti) if m['name'] == short]
            if f'{short}();' in ctors and f'{short}(EEventParm);' in ctors and f'{t}::{short}' not in defined \
                    and t not in EMPTY_CONSTRUCTORS and t not in {k for k, _b, _t in KNOWN_BODIES}:
                out.append(f'inline {t}::{short}() {{}}')
        return ['#ifndef HAGGAR_HOST'] + out + ['#endif'] if out else []

    def _has_default_constructor(self, cls):
        short = gen_header.split_scope(cls)[-1]
        return any(self.header.method_decl(cls, m) == f'{short}();'
                   for m in self.header.methods(self.t.find(cls)) if m['name'] == short)

    def _has(self, cls, method):
        return any(m['name'] == method for m in self.header.methods(self.t.find(cls)))

    def package_of(self, cls):
        return self.packages.get(cls[1:], self.package)

    def inline_bodies(self):
        """DECLARE_CLASS's members, for the package's classes and their bases."""
        out, done = [], set()
        for cls in self.classes:
            for c in reversed(self.chain(cls)):
                if c in done:
                    continue
                done.add(c)
                if self._has(c, c) and f'{c}::{c}' not in self.out_of_line():  # NO_DEFAULT_CONSTRUCTOR
                    out.append(f'inline {c}::{c}() {{}}')
                out += [f'inline UClass *{c}::StaticClass()', '{', '    if (!PrivateStaticClass)', '    {',
                        f'        PrivateStaticClass = GetPrivateStaticClass{c}(L"{self.package_of(c)}");',
                        f'        InitializePrivateStaticClass{c}();', '    }', '    return PrivateStaticClass;', '}']
                _within, config = script_header(self.package_of(c), c)
                if config and self._has(c, 'StaticConfigName'):
                    out.append(f'inline const wchar_t *{c}::StaticConfigName() {{ return L"{config}"; }}')
                if c in self.classes or self.own_members_trivial(c) or c in self.member_targets:
                    out.append(f'inline {c}::~{c}() {{ ConditionalDestroy(); }}')
                if c in self.classes:
                    out += [f'inline void *{c}::operator new(const unsigned int, EInternal *InMem) {{ return (void *)InMem; }}',
                            f'inline void {c}::InternalConstructor(void *X) {{ new ((EInternal *)X) {c}; }}']
                out.append('')
        # StaticClass of every other UObject class the header renders
        for c in sorted(self.header.classes):
            if c not in done and c != 'UObject' and self._has(c, 'StaticClass') and self._has(c, f'GetPrivateStaticClass{c}'):
                out += [f'inline UClass *{c}::StaticClass()', '{', '    if (!PrivateStaticClass)', '    {',
                        f'        PrivateStaticClass = GetPrivateStaticClass{c}(L"{self.package_of(c)}");',
                        f'        InitializePrivateStaticClass{c}();', '    }', '    return PrivateStaticClass;', '}']
        return out

    def tiny_definition(self, row, shape):
        """The definition of a one-instruction function (a constant or a
        string returned, or nothing done), or None when its declaration
        isn't unique."""
        cls, member = row['name'].rsplit('::', 1)
        methods = [m for m in self.header.methods(self.t.find(cls)) if m['name'] == member]
        if len(methods) != 1:
            return None
        m = methods[0]
        decl = self.header.method_decl(cls, m)
        if decl is None or member.startswith('operator'):
            return None
        decl = re.sub(r'^(HG_VIRTUAL |static )', '', decl).rstrip(';').replace(' HG_PURE', '')
        decl = decl.replace(f'{member}(', f'{cls}::{member}(', 1)
        ret = self.signature(m['type'])[0]
        what, value = shape
        if what == 'empty':
            if ret != 'void':
                return None  # a lone blr returns r3 untouched: not an empty body
            body = ''
        elif what == 'string':
            wide = 'wchar_t' in ret
            body = f' return {"L" if wide else ""}"{read_string(basefile(), value, wide)}"; '
        elif ret == 'bool':
            body = f' return {"true" if value else "false"}; '
        else:
            enum = self.header._enum_index(ret)
            name = enumerator(self.t, enum, value) if enum else None
            body = f' return {(ret.rsplit("::", 1)[0] + "::" if "::" in ret else "") + name if name else value}; '
        return [f'// @retail {row["address"]}', f'{decl}', '{' + body + '}', '']

    def exec_bodies(self):
        """The script compiler's exec<Name> thunks it can write; the names
        it wrote go to self.exec_done."""
        self.exec_done, out = set(), []
        for r in self.execs:
            text = self.exec_thunk(r)
            if text:
                self.exec_done.add(r['name'].rsplit('::', 1)[1])
                out += text + ['']
        return out

    def exec_thunk(self, row):
        """DECLARE_FUNCTION(exec<Name>): read each parameter with the
        script compiler's P_GET_* macro (Stack.Step into a local; by
        reference through GPropAddr; optional ones clear
        RUC_SkippedOptionalParm first), P_FINISH, call <Name>, store its
        result. None when a parameter is of a kind it doesn't read."""
        cls, member = row['name'].rsplit('::', 1)
        native = [m for m in self.header.methods(self.t.find(cls)) if m['name'] == member[4:]]
        native = [m for m in native if 'Grip::' not in self.header.method_decl(cls, m)]  # script-facing overload
        if len(native) != 1:
            return None
        ret, params = self.signature(native[0]['type'])
        optional = script_optionals(self.package_of(cls), cls, member[4:], len(params))
        if ret != 'void' and parameter_kind(ret) not in ('scalar', 'object', 'value'):
            return None
        lines = [f'inline void {cls}::{member}(FFrame &Stack, void *const{"" if ret == "void" else " Result"})', '{']
        for i, p in enumerate(params):
            kind = parameter_kind(p)
            opt, default = optional[i]
            a = f'A{i}'
            if kind in ('scalar', 'object'):
                value = cpp_default(p, default) if opt else '0'
                lines.append(f'    {declare(p, a)} = {value};')
            elif kind == 'value' and not opt:
                lines.append(f'    {declare(p, a)};')
            elif kind == 'const-ref' and not opt:
                lines.append(f'    {declare(p[6:-2], a)};')
            elif kind == 'ref' and not opt:  # P_GET_*_REF: the caller's variable, when script passed one
                base = p[:-2]
                lines += [f'    {declare(base, a + "T")}{" = 0" if parameter_kind(base) == "scalar" else ""};',
                          '    GPropAddr = 0;',
                          f'    Stack.Step(Stack.Object, &{a}T);',
                          '    if (GPropObject)',
                          '    {',
                          '        GPropObject->NetDirty(GProperty);',
                          '    }',
                          f'    {base} &{a} = GPropAddr ? *({base} *)GPropAddr : {a}T;']
                continue
            else:
                return None
            if opt:
                lines.append('    GRuntimeUCFlags &= ~RUC_SkippedOptionalParm;')
            lines.append(f'    Stack.Step(Stack.Object, &{a});')
            if p == UBOOL:  # P_GET_UBOOL: script's bitfield bit becomes 1
                lines.append(f'    {a} = {a} ? 1 : 0;')
        lines.append('    Stack.Code++;')
        call = f'{member[4:]}({", ".join(f"A{i}" for i in range(len(params)))})'
        lines.append(f'    {call};' if ret == 'void' else f'    *({ret}{"" if ret.endswith("*") else " "}*)Result = {call};')
        return lines + ['}']

    def event_bodies(self):
        names = sorted({f'{self.package.upper()}_{r["name"].rsplit("::", 1)[1][5:]}' for r in self.events_all})
        out = [f'extern FName {n};' for n in names] + ['']
        for t in EMPTY_CONSTRUCTORS:
            if t in self.header.classes and self._has_default_constructor(t):
                out.append(f'inline {t}::{t}() {{}}')
        known = [body for t, body, target in KNOWN_BODIES
                 if t in self.header.classes and (t in self.header.targets or not target)]
        out += ['#ifndef HAGGAR_HOST'] + known + ['#endif'] if known else []
        out += self.script_struct_constructors()
        for t, ti in sorted(self.header.classes.items()):
            # an interface (a vtable pointer and nothing else): its constructor only sets that
            if not self.header.bases(ti) and self.header.has_vfptr(ti) and self.t.sizeof(ti) == 4                     and self._has(t, gen_header.split_scope(t)[-1]):
                short = gen_header.split_scope(t)[-1]
                out.append(f'inline {t}::{short}() {{}}')
                if self._has(t, '~' + short):
                    out.append(f'inline {t}::~{short}() {{}}')
        for parms in self.parms:
            if any(m['name'] == parms for m in self.header.methods(self.t.find(parms))):
                out.append(f'inline {parms}::{parms}(EEventParm) {{}}')
        for r in self.events_all:
            out += self.event_thunk(r) + ['']
        return out

    def event_thunk(self, row):
        """The script compiler's event<Name> thunk for a row: fill the
        _Parms struct, ProcessEvent(FindFunctionChecked(<PKG>_<Name>)), copy
        the out parameters and the return value back."""
        cls, member = row['name'].rsplit('::', 1)
        m = next(m for m in self.header.methods(self.t.find(cls)) if m['name'] == member)
        ret, params = self.signature(m['type'])
        fname = f'{self.package.upper()}_{member[5:]}'
        parms = self.parms_name(row)
        if not self._exists(parms):
            return event_thunk(cls, member, ret, [], fname, None, False)
        members = [(n, self.t.name(t)) for n, t, off, _a in self.header.members(self.t.find(parms)) if off is not None]
        if not members:  # an event without parameters passes no Parms
            return event_thunk(cls, member, ret, [], fname, None, False)
        has_ctor = any(x['name'] == parms for x in self.header.methods(self.t.find(parms)))
        args = [(name, ptype) for (name, _mt), ptype in zip([x for x in members if x[0] != 'ReturnValue'], params)]
        return event_thunk(cls, member, ret, args, fname, parms, has_ctor)

    def signature(self, mtype):
        """(return type, [parameter types]) of a member function type."""
        d = self.t.data
        _kind, p = self.t.record(mtype)
        ret = int.from_bytes(d[p:p + 4], 'little')
        args = int.from_bytes(d[p + 16:p + 20], 'little')
        _akind, ap = self.t.record(args)
        count = int.from_bytes(d[ap:ap + 4], 'little')
        types = [int.from_bytes(d[ap + 4 + 4 * i:ap + 8 + 4 * i], 'little') for i in range(count)]
        return self.t.name(ret), [self.t.name(t) for t in types]

    def implement_class(self, cls, line=None):
        """IMPLEMENT_CLASS(cls): its two functions, without markers. `line`
        is the macro's line in the original file, which check() records."""
        super_ = self.chain(cls)[1] if len(self.chain(cls)) > 1 else 'UObject'
        within, _config = script_header(self.package_of(cls), cls)
        within_cls = self._cpp_name(within) if within else 'UObject'
        return [
            f'UClass *{cls}::PrivateStaticClass = 0;',
            '',
            f'UClass *{cls}::GetPrivateStaticClass{cls}(const wchar_t *Package)',
            '{',
            '    UClass *ReturnClass;',
            f'    ReturnClass = ::new UClass(EC_StaticConstructor, sizeof({cls}), {self.class_flags(cls)}, {self.cast_flags(cls)},',
            f'                               L"{cls}" + 1, Package, StaticConfigName(), RF_IMPLEMENT_CLASS,',
            f'                               (void (*)(void *)){cls}::InternalConstructor,',
            f'                               (void (UObject::*)())&{cls}::StaticConstructor,',
            f'                               (void (UObject::*)())&{cls}::InitializeIntrinsicPropertyValues);',
            *([f'#line {line}'] if line else []),
            '    check(ReturnClass);',
            '    return ReturnClass;',
            '}',
            '',
            f'void {cls}::InitializePrivateStaticClass{cls}()',
            '{',
            f'    InitializePrivateStaticClass({super_}::StaticClass(), {cls}::PrivateStaticClass, {within_cls}::StaticClass());',
            '}',
        ]

    def _cpp_name(self, script_name):
        for prefix in ('U', 'A', 'F'):
            try:
                self.t.find(prefix + script_name)
                return prefix + script_name
            except KeyError:
                pass
        return 'U' + script_name

    def class_flags(self, cls):
        return self._flags(cls)[0]

    def cast_flags(self, cls):
        return self._flags(cls)[1]

    def _flags(self, cls):
        """DECLARE_CLASS's static flags and cast flags, as the retail
        GetPrivateStaticClass passes them to UClass::UClass (r6, r7)."""
        if not hasattr(self, '_flag_cache'):
            self._flag_cache = {}
        if cls not in self._flag_cache:
            row = next((r for r in self.rows if kind(r) == 'get' and r['name'].startswith(cls + '::')), None)
            self._flag_cache[cls] = ('0', '0') if row is None else tuple(
                f'0x{v:X}' if v else '0' for v in argument_registers(int(row['address'], 16), int(row['size']), (6, 7)))
        return self._flag_cache[cls]


UBOOL = 'unsigned int'
# The script VM's scalar parameter kinds (P_GET_INT, _FLOAT, _UBOOL, _BYTE)
SCALAR_PARAMETERS = ('int', 'float', 'unsigned int', 'unsigned char')


def parameter_kind(ptype):
    """How an exec thunk reads a parameter of C++ type `ptype`: 'scalar',
    'object' (a pointer), 'value' (a struct, string, name or array by
    value), 'const-ref', 'ref' (an out parameter), or None."""
    if ptype in SCALAR_PARAMETERS:
        return 'scalar'
    if re.fullmatch(r'[AU]\w+ \*', ptype):
        return 'object'
    if re.fullmatch(r'(F\w+|TArray<.+>)', ptype):
        return 'value'
    if ptype.startswith('const ') and ptype.endswith(' &') and parameter_kind(ptype[6:-2]) == 'value':
        return 'const-ref'
    if ptype.endswith(' &') and parameter_kind(ptype[:-2]) in ('scalar', 'value'):
        return 'ref'
    return None


def declare(ptype, name):
    return f'{ptype}{"" if ptype.endswith("*") else " "}{name}'


def cpp_default(ptype, default):
    """A script default value as C++ (0 when the script gives none)."""
    if default is None or default in ('None', 'false', 'False'):
        return '0'
    if default in ('true', 'True'):
        return '1'
    if ptype == 'float':
        return f'{float(default)!r}f'
    return default


def script_optionals(package, cls, func, count):
    """(optional, default text) of each of a native function's parameters,
    from its script declaration; all (False, None) when it isn't found."""
    path = paths.ROOT / 'script' / package / 'Classes' / f'{cls[1:]}.uc'
    text = path.read_text(encoding='utf-8', errors='replace') if path.exists() else ''
    m = re.search(r'\bfunction\s+(?:[\w.<>]+\s+)?' + re.escape(func) + r'\s*\(([^)]*)\)', text)
    out = []
    for p in (m.group(1).split(',') if m and m.group(1).strip() else []):
        default = p.split('=', 1)[1].strip() if '=' in p else None
        out.append(('optional' in p.split(), default))
    return out if len(out) == count else [(False, None)] * count
# Inline constructors of engine classes the packages' constructors expand
# (written from the disassembly); emitted when the class is a target.
# (class, body, whether the class must be a target)
KNOWN_BODIES = [
    ('FRenderCommandFence', 'inline FRenderCommandFence::FRenderCommandFence() : NumPendingFences(0) {}', True),
    ('FString', 'inline FString::FString() {}', False),
    ('FString', 'inline FString::FString(ENoInit) : TArray<wchar_t, FDefaultAllocator>(E_NoInit) {}', False),
    ('FStringNoInit', 'inline FStringNoInit::FStringNoInit() : FString(E_NoInit) {}', False),
    # structcpptext constructors (retail's out-of-line copies in engineclasses.h)
    ('FCoverInfo', 'inline FCoverInfo::FCoverInfo() : Link(0), SlotIdx(0) {}', True),
    ('FCoverInfo', 'inline FCoverInfo::FCoverInfo(ACoverLink *InLink, int InSlotIdx) : Link(InLink), SlotIdx(InSlotIdx) {}', True),
]
# UE3 math types whose default constructor leaves them uninitialised
EMPTY_CONSTRUCTORS = ('FBoneAtom', 'FVector', 'FRotator', 'FVector2D', 'FVector4', 'FPlane', 'FQuat', 'FLinearColor', 'FColor', 'FMatrix')


def event_thunk(cls, member, ret, args, fname, parms, has_ctor):
    """The text of an event thunk. `args` are (name, C++ type) in order;
    a non-const reference is an out parameter."""
    decl = ', '.join(f'{t} {n}' if not t.endswith(('&', '*')) else f'{t}{n}' for n, t in args)
    lines = [f'inline {ret} {cls}::{member}({decl})', '{']
    if parms is None:
        lines.append(f'    ProcessEvent(FindFunctionChecked({fname}, 0), 0, 0);')
    else:
        lines.append(f'    {parms} Parms{"(EC_EventParm)" if has_ctor else ""};')
        if ret != 'void':
            lines.append('    Parms.ReturnValue = 0;')
        for n, t in args:
            value = f'{n} ? FIRST_BITFIELD : 0' if t == UBOOL else n
            lines.append(f'    Parms.{n} = {value};')
        lines.append(f'    ProcessEvent(FindFunctionChecked({fname}, 0), &Parms, 0);')
        for n, t in args:
            if t.endswith('&') and not t.startswith('const '):
                lines.append(f'    {n} = Parms.{n};')
        if ret != 'void':
            lines.append('    return Parms.ReturnValue;')
    return lines + ['}']


def tiny_shape(row):
    """('const', value), ('string', text), ('empty', None) for a function
    whose whole body is `li r3, N; blr`, `lis; addi r3; blr` (a string) or
    `blr`, else None."""
    size = int(row['size'])
    if size > 12 or not paths.basefile().exists():
        return None
    va = int(row['address'], 16)
    image = basefile()
    words = [int.from_bytes(image[va - IMAGE_BASE + i:va - IMAGE_BASE + i + 4], 'big') for i in range(0, size, 4)]
    if words == [0x4E800020]:
        return ('empty', None)
    if len(words) == 2 and words[1] == 0x4E800020 and words[0] >> 16 == 0x3860:
        imm = words[0] & 0xFFFF
        return ('const', imm - 0x10000 if imm & 0x8000 else imm)
    addr = string_address(words)
    if addr is not None:
        return ('string', addr)  # read once the return type says how wide
    return None


def string_address(words):
    """The address `lis r11, hi; addi r3, r11, lo; blr` returns, or None."""
    if len(words) == 3 and words[2] == 0x4E800020 and words[0] >> 16 == (15 << 10) | (11 << 5) \
            and words[1] >> 16 == (14 << 10) | (3 << 5) | 11:
        hi, lo = words[0] & 0xFFFF, words[1] & 0xFFFF
        return ((hi << 16) + (lo - 0x10000 if lo & 0x8000 else lo)) & 0xFFFFFFFF
    return None


def read_string(image, addr, wide):
    """The C string at `addr` (UTF-16 when `wide`), escaped for C++."""
    data = image[addr - IMAGE_BASE:addr - IMAGE_BASE + 512]
    if wide:
        text = data[:next(i for i in range(0, len(data), 2) if data[i:i + 2] == b'\0\0')].decode('utf-16-be')
    else:
        text = data[:data.index(0)].decode('latin1')
    return text.replace('\\', '\\\\').replace('"', '\\"')


def basefile():
    if not hasattr(basefile, 'cache'):
        basefile.cache = paths.basefile().read_bytes()
    return basefile.cache


def enumerator(types, ti, value):
    """The name of `value` in enum `ti`, or None."""
    _count, _prop, _utype, field = struct.unpack_from('<HHII', types.data, types.record(types._resolve(ti))[1])
    for leaf, q in types._fields(field):
        if leaf == pdbtype.LF_ENUMERATE:
            v, r = pdbtype.numeric(types.data, q + 2)
            if v == value:
                return pdbtype.cstr(types.data, r)[0]
    return None


def argument_registers(va, size, regs, callee='UClass::UClass'):
    """The constants loaded into `regs` (li, or lis then ori) at the
    function's call to `callee`, from the basefile."""
    import capstone
    md = capstone.Cs(capstone.CS_ARCH_PPC, capstone.CS_MODE_32 | capstone.CS_MODE_BIG_ENDIAN)
    code = basefile()[va - IMAGE_BASE:va - IMAGE_BASE + size]
    values, calls = {r: 0 for r in regs}, []
    for ins in md.disasm(code, va):
        ops = [o.strip() for o in ins.op_str.split(',')]
        if ins.mnemonic == 'bl':
            if names().get(int(ops[0], 0)) == callee:
                calls.append(dict(values))
        elif ins.mnemonic in ('li', 'lis', 'ori') and ops[0].startswith('r') and int(ops[0][1:]) in regs:
            reg, imm = int(ops[0][1:]), int(ops[-1], 0)
            if ins.mnemonic == 'li':
                values[reg] = imm & 0xFFFFFFFF
            elif ins.mnemonic == 'lis':
                values[reg] = (imm << 16) & 0xFFFFFFFF
            else:
                values[reg] |= imm
    return [calls[0][r] for r in regs]


def names():
    """{address: name} of every function, read once."""
    if not hasattr(names, 'cache'):
        names.cache = {int(r['address'], 16): r['name'] for r in inventory.read_csv(paths.CONFIG / 'functions.csv')}
    return names.cache




def main(argv=None):
    ap = argparse.ArgumentParser(description="Write the C++ of UE3's class macros for n-Space's classes.")
    ap.add_argument('packages', nargs='+')
    ap.add_argument('--pdb', default=None)
    args = ap.parse_args(argv)
    from pdbfile import Pdb
    types = pdbtype.Types(Pdb(args.pdb or paths.pdb()))
    rows = nspace_rows()
    for package in args.packages:
        c = Classes(types, package, rows)
        header = paths.ROOT / 'include' / package / 'Inc' / f'{package}Classes.h'
        old = header.read_text(encoding='utf-8') if header.exists() else ''
        tail = old.split(gen_header.HAND, 1)[1] if gen_header.HAND in old else '\n'
        text = '\n'.join([f'// Generated from the PDB by: python tools/gen_classes.py {package}',
                          c.header.render(), '#include "Core/Inc/UnObjBas.h"']
                         + (['#include "Core/Inc/UnScript.h"'] if c.execs else []) + [''] + c.inline_bodies() + c.event_bodies() + c.exec_bodies())
        header.parent.mkdir(parents=True, exist_ok=True)
        header.write_text(f'{text}\n{gen_header.HAND}{tail}', encoding='utf-8', newline='\n')
        by_object = {}
        for r in c.rows:
            by_object.setdefault(r['object'], []).append(r)
        for obj, orows in sorted(by_object.items()):
            write_source(c, package, obj, orows)
        tiny = {}
        for r, shape in c.tiny:
            text = c.tiny_definition(r, shape)
            if text:
                tiny.setdefault(r['object'], []).extend(text)
        for obj, lines in sorted(tiny.items()):
            stem = obj.split('.')[0].replace('Unity_', '')
            path = paths.ROOT / 'src' / package / 'Src' / f'{stem}Constants.cpp'
            head = [f'// @object {obj}', f'// Generated by: python tools/gen_classes.py {package}',
                    '// Functions whose whole body returns a constant or a string, or does nothing.',
                    f'#include "{package}/Inc/{package}Classes.h"', '']
            path.write_text('\n'.join(head + lines), encoding='utf-8', newline='\n')
    return 0


def write_source(c, package, obj, rows):
    stem = obj.split('.')[0].replace('Unity_', '')
    lines = [f'// @object {obj}', f'// Generated by: python tools/gen_classes.py {package}',
             f'#include "{package}/Inc/{package}Classes.h"', '']
    kinds = {}
    for r in rows:
        member = r['name'].rsplit('::', 1)[1]
        kinds.setdefault(r['name'].rsplit('::', 1)[0], {})[member if kind(r) in ('event', 'exec') else kind(r)] = r
    emit = []
    for cls in sorted(kinds):
        k = kinds[cls]
        if 'new' in k:
            emit.append(f'extern void *(*const Emit{cls}New)(const unsigned int, EInternal *) = &{cls}::operator new;')
        if 'static' in k:
            emit.append(f'extern UClass *(*const Emit{cls}StaticClass)() = &{cls}::StaticClass;')
        if 'internal' in k:
            emit.append(f'extern void (*const Emit{cls}InternalConstructor)(void *) = &{cls}::InternalConstructor;')
        for name, r in sorted(k.items()):
            if name.startswith('event') or name in c.exec_done:
                emit.append(f'extern decltype(&{cls}::{name}) const Emit{cls}_{name} = &{cls}::{name};')
    lines += ['// Out-of-line copies, as in retail.', '#pragma inline_depth(0)'] + emit + ['#pragma inline_depth()', '']
    for cls in sorted(kinds):
        k = kinds[cls]
        for name in ['new', 'ctor', 'dtor', 'sdd', 'internal', 'static'] + sorted(n for n in k if n.startswith(('event', 'exec'))):
            if name in k:
                lines += [f'// @retail {k[name]["address"]}', f'// {k[name]["name"]} (in the header)']
                note = c.known_cause(cls, name)
                if name.startswith('exec') and name not in c.exec_done:
                    note = 'its parameters are of a kind the generator does not read yet (references, strings, arrays)'
                if note:
                    lines.append(f'//   not matched yet: {note}')
        if 'get' in k or 'init' in k:
            body = c.implement_class(cls, k['get']['line'] if 'get' in k else None)
            lines.append('')
            for line in body:
                if line.startswith(f'UClass *{cls}::GetPrivateStaticClass') and 'get' in k:
                    lines.append(f'// @retail {k["get"]["address"]}')
                if line.startswith(f'void {cls}::InitializePrivateStaticClass') and 'init' in k:
                    lines.append(f'// @retail {k["init"]["address"]}')
                lines.append(line)
        lines.append('')
    path = paths.ROOT / 'src' / package / 'Src' / f'{stem}Classes.cpp'
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text('\n'.join(lines), encoding='utf-8', newline='\n')


if __name__ == '__main__':
    raise SystemExit(main())
