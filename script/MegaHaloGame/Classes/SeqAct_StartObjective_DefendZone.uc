class SeqAct_StartObjective_DefendZone extends SeqAct_StartObjective;

var array<DefendZone> Zones;
var float CaptureRate;
var float NeutralizeRate;
var int FriendlyZoneCountToComplete;
var int HostileZoneCountToFail;
var AkEvent OnNeutralCaptureSound;
var AkEvent OnFriendlyCaptureSound;
var AkEvent OnHostileCaptureSound;

function CreateObjective()
{
	Objective = new Class'MegaHaloGame.HaloObjective_DefendZone';
	//return;	
}

function SetObjectiveProperties()
{
	local HaloObjective_DefendZone DefZone;

	DefZone = HaloObjective_DefendZone(Objective);
	// End:0x16E
	if(DefZone != none)
	{
		DefZone.Zones = Zones;
		DefZone.CaptureRate = CaptureRate;
		DefZone.NeutralizeRate = NeutralizeRate;
		DefZone.FriendlyZoneCountToComplete = FriendlyZoneCountToComplete;
		DefZone.HostileZoneCountToFail = HostileZoneCountToFail;
		DefZone.OnNeutralCaptureSound = OnNeutralCaptureSound;
		DefZone.OnFriendlyCaptureSound = OnFriendlyCaptureSound;
		DefZone.OnHostileCaptureSound = OnHostileCaptureSound;		
	}
	else
	{
		WarnInternal("Error creating new Objective -- not of type HaloObjective_UseObject");
	}
	super.SetObjectiveProperties();
	//return;	
}

defaultproperties
{
	Zones[0]=(Zone=(Actor=none,Marker=OMN_Zone,bDraw=true,bDrawTagSymbol=false,bShowHealth=false,bShowDistance=true,bClampToScreen=true),Status=DZS_Neutral,Value=0.0000000,PerimeterEffect=none)
	CaptureRate=1.0000000
	NeutralizeRate=0.0100000
	FriendlyZoneCountToComplete=1
	HostileZoneCountToFail=1
	ObjectiveName="Defend Zone"
	ObjName="Start Defend Zone Objective"
}