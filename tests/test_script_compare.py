import script_compare

UDK = """/** Copyright Epic */
class UTWeapon extends UDKWeapon
\tdependson(UTPlayerController);

var int AmmoCount; // how much
var() float Spread[2], SpreadMin;

cpptext
{
\tvirtual void TickSpecial(FLOAT DeltaSeconds);
}

simulated function bool HasAmmo(int Mode, optional int Amount)
{
\tif (Amount == 0)
\t\treturn AmmoCount >= 1;  // at least one
\treturn AmmoCount >= Amount;
}

defaultproperties
{
\tAmmoCount=5
}
"""

OURS = """class UTWeapon extends UDKWeapon
\tdependson(UTPlayerController);

var int AmmoCount;
var() float Spread[2];
var() float SpreadMin;

simulated function bool HasAmmo(int Mode, optional int Amount)
{
\t// End:0x1A
\tif(Amount == 0)
\t{
\t\treturn AmmoCount >= 1;
\t}
\treturn AmmoCount >= Amount;
\t//return ReturnValue;
}

defaultproperties
{
\tAmmoCount=6
}
"""


def test_parse_members():
    c = script_compare.parse(UDK)
    assert c.parent == 'udkweapon'
    assert c.vars == {'ammocount', 'spread', 'spreadmin'}
    assert set(c.functions) == {'hasammo'}


def test_identical_ignores_comments_braces_and_defaults():
    assert script_compare.compare(script_compare.parse(OURS), script_compare.parse(UDK)) == 'identical'


def test_modified_body():
    changed = OURS.replace('return AmmoCount >= Amount;', 'return AmmoCount >= Amount && bReady;')
    assert script_compare.compare(script_compare.parse(changed), script_compare.parse(UDK)) == 'modified'


def test_modified_members():
    changed = OURS.replace('var int AmmoCount;', 'var int AmmoCount;\nvar bool bHalo;')
    assert script_compare.compare(script_compare.parse(changed), script_compare.parse(UDK)) == 'modified'


def test_classify_nspace_only(tmp_path):
    ours = tmp_path / 'script' / 'MegaHaloGame'
    ours.mkdir(parents=True)
    (ours / 'HaloPawn.uc').write_text('class HaloPawn extends UTPawn;\n')
    (ours / 'UTWeapon.uc').write_text(OURS)
    udk = tmp_path / 'udk' / 'Development' / 'Src' / 'UTGame' / 'Classes'
    udk.mkdir(parents=True)
    (udk / 'UTWeapon.uc').write_text(UDK)
    rows = script_compare.classify(tmp_path / 'script', tmp_path / 'udk')
    assert [(r['package'], r['class'], r['status'], r['udk_file']) for r in rows] == [
        ('MegaHaloGame', 'HaloPawn', 'nspace-only', ''),
        ('MegaHaloGame', 'UTWeapon', 'identical', 'Development/Src/UTGame/Classes/UTWeapon.uc'),
    ]


def test_refine_owner(monkeypatch):
    monkeypatch.setattr(script_compare, 'nspace_additions', lambda: {('AUDKPawn', 'GetAlertness')})
    game = {'tier': 'game', 'package': 'udkbase', 'source': r'udkbase\src\x.cpp'}
    rows = [dict(game, name='AHaloPawn::Tick'),
            dict(game, name='AUTWeapon::Fire'),
            dict(game, name='FHelper::Run', package='megahalogame'),
            {'name': 'AUTWeapon::Fire', 'tier': 'engine', 'package': 'engine', 'source': '', 'owner': ''},
            dict(game, name='AUDKPawn::GetAlertness'),
            dict(game, name='CCSBlackboard::Reset', source=r'udkbase\ccsref\ccsblackboard.cpp'),
            dict(game, name="IGripAISystem::`scalar deleting destructor'", source=''),
            dict(game, name='Grip_Array<int>::AddItem', source=r'external\grip\sdk\core\grip_array.h')]
    status = {'halopawn': 'nspace-only', 'utweapon': 'modified', 'udkpawn': 'modified'}
    script_compare.refine_owner(rows, status)
    assert [r['owner'] for r in rows] == ['nspace', 'epic', 'nspace', '', 'nspace', 'vendor', 'vendor', 'vendor']


def test_editoronly_vars_and_constants_ignored():
    udk = UDK.replace('var int AmmoCount; // how much', 'var int AmmoCount;\nvar editoronly color IconColor;\nconst MAX_AMMO = 9;')
    udk = udk.replace('return AmmoCount >= Amount;', 'return AmmoCount >= Amount && Amount < MAX_AMMO;')
    ours = OURS.replace('return AmmoCount >= Amount;', 'return AmmoCount >= Amount && Amount < 9;')
    ours = ours.replace('var int AmmoCount;', 'var int AmmoCount;\nconst MAX_AMMO = 9;')
    u, o = script_compare.parse(udk), script_compare.parse(ours)
    assert 'iconcolor' not in u.vars
    assert script_compare.compare(o, u, u.constants) == 'identical'
