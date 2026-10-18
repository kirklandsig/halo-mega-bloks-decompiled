import stub_recomp


def test_stub_files(tmp_path):
    names = stub_recomp.write(tmp_path)
    assert names == ['haggar_init.cpp', 'haggar_init.h', 'haggar_pch.h', 'sources.cmake']
    assert 'PPCImageConfig' in (tmp_path / 'haggar_init.cpp').read_text()
    assert 'haggar_init.cpp' in (tmp_path / 'sources.cmake').read_text()
