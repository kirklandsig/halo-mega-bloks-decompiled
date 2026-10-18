class GwNavAStarLockVolume extends TriggerVolume
	native;

var bool bEnabled;
var bool IsAStarLocked;
var native Pointer gwNavDynamicNavTagVolume;

// Export UGwNavAStarLockVolume::execLockAStar(FFrame&, void* const)
native function bool LockAStar(bool Lock);

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	LockAStar(IsAStarLocked);
	SetCollision(bEnabled, bBlockActors);
	//return;	
}

simulated function OnSetLockAStarVolumeState(SeqAct_SetLockAStarVolumeState Action)
{
	//return;	
}

defaultproperties
{
	bEnabled=true
	IsAStarLocked=true
	BrushColor=(R=255,G=100,B=255,A=255)
	// Reference: BrushComponent'GwNavEngine.Default__GwNavAStarLockVolume.BrushComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'BrushComponent0'
	// Archetype: BrushComponent'Engine.Default__TriggerVolume.BrushComponent0'
	begin object name="BrushComponent0"
		ReplacementPrimitive=none
	end object
	BrushComponent=BrushComponent0
	Components[0]=BrushComponent0
	bStatic=false
	bAlwaysRelevant=true
	bOnlyDirtyReplication=true
	CollisionComponent=BrushComponent0
}