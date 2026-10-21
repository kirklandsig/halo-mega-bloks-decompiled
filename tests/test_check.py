import pytest

import check

RETAIL = bytes.fromhex('7d8802a6' '4bff0f05' '4e800020')


def test_compare_masked():
    ours = bytes.fromhex('7d8802a6' '48000001' '4e800020')
    assert check.compare(ours, [(4, 0x03FFFFFC)], RETAIL) == 'matched'
    assert check.compare(bytes.fromhex('7d8802a6' '4bff0f05' '4e800021'), [(4, 0x03FFFFFC)], RETAIL) == 'near'
    assert check.compare(ours, [], RETAIL) == 'near'
    assert check.compare(ours[:8], [(4, 0x03FFFFFC)], RETAIL) == 'todo'


def test_compare_mask_keeps_opcode():
    # bl vs b: the opcode bits lie outside the REL24 mask
    ours = bytes.fromhex('7d8802a6' '48000000' '4e800020')
    assert check.compare(ours, [(4, 0x03FFFFFC)], RETAIL) == 'near'


def test_parse_markers(tmp_path):
    src = tmp_path / 'a.cpp'
    src.write_text('// @object Unity_AEtAl.cpp.obj\n\n// @retail 0x8331ED40\nvoid f() {}\n// @retail 0x8331ED48\n')
    assert check.parse_markers(src) == ('Unity_AEtAl.cpp.obj', [0x8331ED40, 0x8331ED48])


def test_compile_args_replace_includes_and_output(tmp_path):
    cmd = r'-nologo -Ox -IF:\a -I"C:\Program Files\x" -DX=1 -FoF:\o\a.obj -TP -X'
    args = check.compile_args(cmd, [tmp_path / 'inc', tmp_path / 'xdk'], tmp_path / 'b.obj')
    assert args == ['-nologo', '-Ox', '-DX=1', '-TP', '-X', f'-I{tmp_path / "inc"}', f'-I{tmp_path / "xdk"}',
                    f'-Fo{tmp_path / "b.obj"}']


def test_split_cmd_keeps_escaped_quotes():
    # MSVC rules: \" is a literal quote; quotes around a path are dropped
    cmd = r'-D_MACHINENAME=\"EDGE-XEN-02\" -I"C:\Program Files\x" -DA'
    assert check.split_cmd(cmd) == ['-D_MACHINENAME="EDGE-XEN-02"', r'-IC:\Program Files\x', '-DA']


def test_update_status_merges_and_sorts(tmp_path):
    path = tmp_path / 'status.csv'
    path.write_text('address,status\n0x82000200,near\n0x82000300,matched\n')
    check.update_status(path, {0x82000100: 'matched', 0x82000200: 'matched', 0x82000300: 'todo'})
    assert path.read_text() == 'address,status\n0x82000100,matched\n0x82000200,matched\n'


def test_check_writes_status_only(tmp_path, monkeypatch):
    import paths
    monkeypatch.setattr(paths, 'CONFIG', tmp_path)
    functions = tmp_path / 'functions' / 'game.csv'
    functions.parent.mkdir()
    functions.write_bytes(b'address,size,name\n0x82000100,8,f\n')
    check.save({0x82000100: 'matched'})
    assert functions.read_bytes() == b'address,size,name\n0x82000100,8,f\n'
    assert (tmp_path / 'status.csv').read_text() == 'address,status\n0x82000100,matched\n'


def test_plain_name_of_decorated_symbol():
    assert check.plain_name('?CheckVA@@YAXPBDZZ') == 'CheckVA'
    assert check.plain_name('?Tick@AHaloPawn@@UAAXM@Z') == 'AHaloPawn::Tick'
    assert check.plain_name('_memcpy') == '_memcpy'


def test_find_symbol_pairs_namesakes_by_address():
    # two file statics named UnwindRot, no decorated name in the PDB: the
    # n-th by retail address is the n-th our object defines
    import coff
    c = coff.Coff(0x1F2, [], {0: coff.Symbol('?UnwindRot@@YA?AUFRotator@@U1@@Z', 0, 3, 3),
                              1: coff.Symbol('?UnwindRot@@YAHH@Z', 0, 2, 3),
                              2: coff.Symbol('?UnwindRot@@YAHH@Z', 0, 0, 2)})
    rows = [{'address': '0x83322568', 'symbol': '', 'object': 'a.obj', 'name': 'UnwindRot'},
            {'address': '0x833225B8', 'symbol': '', 'object': 'a.obj', 'name': 'UnwindRot'},
            {'address': '0x83382000', 'symbol': '', 'object': 'b.obj', 'name': 'UnwindRot'}]
    same = check.namesakes(rows)
    assert same[('a.obj', 'UnwindRot')] == [0x83322568, 0x833225B8]
    assert check.find_symbol(c, rows[0], same) == '?UnwindRot@@YAHH@Z'
    assert check.find_symbol(c, rows[1], same) == '?UnwindRot@@YA?AUFRotator@@U1@@Z'
    with pytest.raises(KeyError):  # without the namesakes it stays ambiguous
        check.find_symbol(c, rows[0])


def test_diff_score():
    ret = bytes.fromhex('7d6321d6' '7d432850' '7d2a5850' '4e800020')
    assert check.diff_score(ret, ret) == 0
    # a register-only difference costs 1, another instruction 2
    assert check.diff_score(bytes.fromhex('7d6321d6' '7d432850' '7d2b5050' '4e800020'), ret) == 1
    assert check.diff_score(bytes.fromhex('7d6321d6' '7d432850' '4e800020'), ret) == 2
    # relocated fields don't count: bl targets, lis/addi pairs
    a = bytes.fromhex('48000001' '3d600000' '396b0000')
    b = bytes.fromhex('4bff0f05' '3d608200' '396b1234')
    assert check.diff_score(a, b) == 0
    assert check.score('matched', ret, ret) == 0
    assert check.score('near', ret, ret) == 1  # near is never 0
    assert check.score('todo', None, ret) == 8  # missing: every retail word


def test_scores_lists_near_and_todo_and_unwritten_nspace(tmp_path, monkeypatch, capsys):
    src = tmp_path / 'a.cpp'
    src.write_text('')
    rows = {0x82000100: {'address': '0x82000100', 'name': 'A::f', 'symbol': '', 'owner': 'nspace', 'size': '8'},
            0x82000200: {'address': '0x82000200', 'name': 'A::g, h', 'symbol': '', 'owner': 'nspace', 'size': '8'},
            0x82000300: {'address': '0x82000300', 'name': 'B::k', 'symbol': '', 'owner': 'nspace', 'size': '12'},
            0x82000400: {'address': '0x82000400', 'name': 'Epic::x', 'symbol': '', 'owner': 'epic', 'size': '4'}}

    class Ctx:
        by_address = rows

        def retail(self, row):
            return bytes(int(row['size']))

    monkeypatch.setattr(check, 'Context', Ctx)
    monkeypatch.setattr(check, 'all_sources', lambda: [src])
    monkeypatch.setattr(check, 'save', lambda results: None)
    monkeypatch.setattr(check, 'check_file', lambda ctx, path: {
        0x82000100: (rows[0x82000100], 'matched', 0, ''), 0x82000200: (rows[0x82000200], 'near', 3, ''),
        0x82000400: (rows[0x82000400], 'near', 1, '')})
    assert check.main(['--scores']) == 1
    # the matched one is left out, the epic one too; B::k isn't written: all 3 words missing
    assert capsys.readouterr().out == ('address,name,status,score\n0x82000200,"A::g, h",near,3\n'
                                       '0x82000300,B::k,todo,6\n')
    assert check.main(['--scores', str(src)]) == 1
    assert capsys.readouterr().out == 'address,name,status,score\n0x82000200,"A::g, h",near,3\n0x82000400,Epic::x,near,1\n'


def test_line_report_maps_statements():
    # retail: two statements of 8 bytes; ours puts the second one's code on
    # the first line, and one line more
    retail = bytes.fromhex('7d6321d6' '7d432850' '7d2a5850' '4e800020')
    ours = bytes.fromhex('7d6321d6' '7d432850' '7d2a5850' '4e800020')
    report = check.line_report(ours, [(0, 20, 'a.cpp'), (12, 22, 'a.cpp')], retail, [(0, 100), (8, 101)],
                               lambda f, n: {20: 'x = a;', 22: 'return;'}.get(n))
    assert report[1].split() [:4] == ['0', 'L+0', 'mullw', 'r11,']
    assert '20: x = a;' in report[1] and '22: return;' in report[4]
    summary = report[report.index('') + 2:]
    assert summary[0].split()[:4] == ['L+0', '8', 'B', '@0']
    assert 'L+0 12 B' in summary[0] and 'ours +4 B' in summary[0]
    assert 'L+2 4 B' in summary[1] and 'ours -4 B' in summary[1]


def test_line_report_flags_order():
    # retail runs statement B (line 2) before C (line 3); ours the other way
    a, b, c, ret = ['7d6321d6'], ['7d432850', '7d2a5850', '38630001'], ['38840002', '38a50003', '38c00004'], ['4e800020']
    retail = bytes.fromhex(''.join(a + b + c + ret))
    ours = bytes.fromhex(''.join(a + c + b + ret))
    report = check.line_report(ours, [(0, 1, 'a.cpp'), (4, 3, 'a.cpp'), (16, 2, 'a.cpp'), (28, 4, 'a.cpp')],
                               retail, [(0, 1), (4, 2), (16, 3), (28, 4)])
    summary = report[report.index('') + 2:]
    assert 'L+1 12 B' in summary[1] and 'ours runs it after L+2' in summary[1]
    assert 'L+2 12 B' in summary[2]
    assert not any('every statement' in line for line in summary)
    same = check.line_report(retail, [(0, 5, 'a.cpp'), (16, 6, 'a.cpp')], retail, [(0, 9), (16, 10)])
    assert 'every statement' in same[-1]


@pytest.mark.orig
def test_object_lines_from_our_compile(tmp_path):
    import paths
    xdk = paths.xdk()
    if not (xdk / 'bin' / 'win32' / 'cl.exe').exists():
        pytest.skip('needs the XDK')
    import coff
    import inventory
    cmd = {r['object']: r for r in inventory.read_csv(paths.CONFIG / 'objects.csv')}['Unity_HaloRBTKamikazeEtAl.cpp.obj']['cmd']
    src = tmp_path / 'lines.cpp'
    src.write_text('int Lines(int a, int b)\n{\n    int x = a * b;\n\n    return x - a;\n}\n')
    obj = tmp_path / 'lines.obj'
    assert check.compile_file(xdk / 'bin' / 'win32' / 'cl.exe', cmd, [xdk / 'include' / 'xbox'], src, obj).returncode == 0
    lines = check.object_lines(coff.parse(obj.read_bytes()), '?Lines@@YAHHH@Z')
    assert lines and lines[0][0] == 0 and all(f.lower() == str(src).lower() for _, _, f in lines)
    assert {n for _, n, _ in lines} <= {2, 3, 5, 6} and 5 in {n for _, n, _ in lines}
