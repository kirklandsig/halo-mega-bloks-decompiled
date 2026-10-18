import decomp_dev_export

FUNCTIONS = """address,size,name,symbol,object,package,tier,owner,source,line
0x82000000,4,A::f,?f@A@@QAAXXZ,Unity_A.cpp.obj,udkbase,game,nspace,udkbase\\src\\a.cpp,1
0x82000004,4,A::g,?g@A@@QAAXXZ,Unity_A.cpp.obj,udkbase,game,nspace,udkbase\\src\\a.cpp,2
0x82000008,4,B::h,?h@B@@QAAXXZ,Unity_B.cpp.obj,megahalogame,game,nspace,,
0x8200000C,8,U::k,?k@U@@QAAXXZ,Unity_A.cpp.obj,udkbase,game,epic,,
0x82000014,16,E::e,,Unity_E.cpp.obj,engine,engine,,,
"""
STATUS = """address,status
0x82000000,matched
0x8200000C,matched
"""


def write(tmp_path):
    f, s = tmp_path / 'functions.csv', tmp_path / 'status.csv'
    f.write_text(FUNCTIONS)
    s.write_text(STATUS)
    return f, s


def test_report_counts(tmp_path):
    report = decomp_dev_export.build_report(*write(tmp_path))
    m = report['measures']
    assert (m['total_code'], m['matched_code'], m['total_functions'], m['matched_functions']) == ('12', '4', 3, 1)
    assert abs(m['matched_code_percent'] - 100 / 3) < 1e-9
    categories = {c['id']: c['measures'] for c in report['categories']}
    assert set(categories) == {'nspace', 'game'}
    assert (categories['game']['total_code'], categories['game']['matched_code']) == ('20', '12')
    assert categories['nspace']['matched_code'] == '4'
    names = sorted(u['name'] for u in report['units'])
    assert names == ['Unity_A.cpp.obj', 'Unity_A.cpp.obj [epic]', 'Unity_B.cpp.obj']


def test_report_without_status_file(tmp_path):
    f, s = write(tmp_path)
    s.unlink()
    assert decomp_dev_export.build_report(f, s)['measures']['matched_functions'] == 0
