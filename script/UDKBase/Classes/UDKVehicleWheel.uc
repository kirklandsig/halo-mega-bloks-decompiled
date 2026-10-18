class UDKVehicleWheel extends SVehicleWheel
	native;

var bool bUseMaterialSpecificEffects;
var bool bDisableWheelOnDeath;
var export editinline ParticleSystemComponent OldWheelParticleComp;
var float EffectDesiredSpinDir;
var float MinSpinVelForParticles;

event SetParticleEffect(UDKVehicle OwnerVehicle, ParticleSystem NewTemplate)
{
	// End:0x37
	if(OldWheelParticleComp != none)
	{
		OwnerVehicle.DetachComponent(OldWheelParticleComp);
	}
	OldWheelParticleComp = WheelParticleComp;
	WheelParticleComp = new (self) WheelPSCClass (OldWheelParticleComp);
	WheelParticleComp.SetTemplate(NewTemplate);
	OwnerVehicle.AttachComponent(WheelParticleComp);
	// End:0x114
	if(OldWheelParticleComp.Template == none)
	{
		OwnerVehicle.DetachComponent(OldWheelParticleComp);
		OldWheelParticleComp = none;		
	}
	else
	{
		OldWheelParticleComp.__OnSystemFinished__Delegate = OldEffectFinished;
		OldWheelParticleComp.DeactivateSystem();
	}
	//return;	
}

function OldEffectFinished(ParticleSystemComponent PSystem)
{
	PSystem.Owner.DetachComponent(PSystem);
	// End:0x5F
	if(PSystem == OldWheelParticleComp)
	{
		OldWheelParticleComp = none;
	}
	//return;	
}

defaultproperties
{
	bCollidesPawns=true
	WheelPSCClass=Class'UDKBase.UDKParticleSystemComponent'
}