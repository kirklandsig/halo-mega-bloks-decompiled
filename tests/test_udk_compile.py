import os
import re
from pathlib import Path

import pytest

import udk_compile

LOG = r"""[0000.83] Heading: --------------------Core - Release--------------------
[0000.86] Log: Success: Compiled 3041 line(s), 492 statement(s).
[0003.61] Heading: --------------------Grip - Release--------------------
[0003.70] Error: C:\work\Development\Src\Grip\Classes\GripActionFramework.uc(10) : Error, Unrecognized type 'GripAFActionStatus' within 'GripAFActionHandle'
[0003.70] Warning: C:\work\Development\Src\Grip\Classes\GripBTNode.uc(3) : Warning, Invalid property value in defaults: X=none
[0003.71] Log: Compile aborted due to errors.
[0003.72] Error: Error, Importing defaults for Actor: Changing Role in defaultproperties is illegal
"""


def test_parse_log():
    result = udk_compile.parse_log(LOG, Path(r'C:\work'))
    assert result['packages'] == [('Core', True), ('Grip', False)]
    assert result['errors'][0] == ('Development/Src/Grip/Classes/GripActionFramework.uc', 10,
                                   "Unrecognized type 'GripAFActionStatus' within 'GripAFActionHandle'")
    assert result['errors'][1][:2] == ('', 0)
    assert len(result['warnings']) == 1


def test_add_dependson():
    lines = ['class GripActionFramework extends Object', '\tnative;', '']
    udk_compile.add_dependson(lines, 'GripAFActionHandle')
    assert lines[:3] == ['class GripActionFramework extends Object', '\tnative', '\tdependson(GripAFActionHandle);']
    udk_compile.add_dependson(lines, 'Other')
    assert lines[2] == '\tdependson(GripAFActionHandle, Other);'


def test_uncast_comparisons():
    line = 'if((int(RemoteRole) == int(ROLE_AutonomousProxy)) && int(WorldInfo.NetMode) != int(NM_Client))'
    assert udk_compile._uncast_comparisons(line) == 'if((RemoteRole == ROLE_AutonomousProxy) && WorldInfo.NetMode != NM_Client)'
    assert udk_compile._uncast_comparisons('x = int(a) + int(b);') == 'x = int(a) + int(b);'


def test_negate_comparisons():
    assert (udk_compile._negate_comparisons('if(!Left(Command, 4) ~= "set " && !History[I - 1] ~= Command)')
            == 'if(!(Left(Command, 4) ~= "set ") && !(History[I - 1] ~= Command))')
    assert udk_compile._negate_comparisons('if(!bCtrl)') == 'if(!bCtrl)'


def test_literal_casts():
    fix = udk_compile.FIXES[0][1]
    lines = ['\tif((int(LocalUserNum) >= int(0)) && int(LocalUserNum) < int(4))']
    fix(lines, 1, re.search(udk_compile.FIXES[0][0], "No need to cast 'IntProperty' to itself"))
    assert lines[0] == '\tif((int(LocalUserNum) >= 0) && int(LocalUserNum) < 4)'


def test_rebuild_loops():
    lines = ['\tI = 0;', '\tJ0x2A:', '', '\t// End:0x11A [Loop If]', '\tif(I < N)', '\t{', '\t\tF(I);',
             '\t\t++I;', '\t\t// [Loop Continue]', '\t\tgoto J0x2A;', '\t}']
    udk_compile._rebuild_loops(lines, 0, None)
    assert lines == ['\tI = 0;', '', '\t// End:0x11A [Loop If]', '\twhile(I < N)', '\t{', '\t\tF(I);', '\t\t++I;', '\t}']


def test_flatten_else_if():
    lines = ['\tif(A)', '\t{', '\t\tF();', '\t}', '\telse', '\t{', '\t\t// End:0x10', '\t\tif(B)', '\t\t{', '\t\t\tG();',
             '\t\t}', '\t}']
    udk_compile._flatten_else_if(lines, 0, None)
    assert lines == ['\tif(A)', '\t{', '\t\tF();', '\t}', '\telse if(B)', '\t{', '\t\tG();', '\t}']


@pytest.mark.skipif(not os.environ.get('UDK_DIR'), reason='needs UDK July 2012 BETA 2 (UDK_DIR)')
def test_nspace_packages_compile(tmp_path):
    """With UDK's own Epic packages, n-Space's own packages that need nothing of
    n-Space's Epic changes compile cleanly (see docs/PROGRESS.md)."""
    udk_compile.UDK_SOURCE = Path(os.environ['UDK_DIR']) / 'Development' / 'Src'
    udk_compile.prepare(Path(os.environ['UDK_DIR']), tmp_path / 'udk', nspace_only=True)
    result = udk_compile.run(tmp_path / 'udk')
    status = dict(result['packages'])
    for package in ('AkAudio', 'Grip', 'GwNavEngine', 'Cognition', 'OnlineSubsystemLive'):
        assert status.get(package), package
