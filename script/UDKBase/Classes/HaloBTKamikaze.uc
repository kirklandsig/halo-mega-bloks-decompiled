class HaloBTKamikaze extends CCSBTMoveTo
	native;

var name ArmKamikazeAnimName;
var name DetonateKamikazeAnimName;
var float DetonationDistance;
var float BlendInTime;
var float BlendOutTime;

defaultproperties
{
	ArmKamikazeAnimName="Kamikaze_Arm"
	DetonateKamikazeAnimName="Kamikaze_Detonate"
	DetonationDistance=200.0000000
	ShootChance=0.0000000
	NodeDescription="Suicide rush the target with grenades."
	DefaultTitle="Kamikaze"
}