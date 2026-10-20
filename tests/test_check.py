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
