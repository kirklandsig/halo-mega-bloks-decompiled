class UDKEmitterPool extends EmitterPool
	transient
	native
	config(Game);

struct native AttachedExplosionLight
{
	var export editinline UDKExplosionLight Light;
	var Actor Base;
	var Vector RelativeLocation;

	structdefaultproperties
	{
		Light=none
		Base=none
		RelativeLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
	}
};

var array<AttachedExplosionLight> RelativeExplosionLights;

function ParticleSystemComponent SpawnEmitter(ParticleSystem EmitterTemplate, Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor AttachToActor, optional Actor InInstigator, optional int MaxDLEPooledReuses, optional bool bInheritScaleFromBase)
{
	local PlayerController PC;
	local int LODLevel;
	local editinline ParticleSystemComponent PSC;

	// End:0x4B
	if(EmitterTemplate == none)
	{
		LogInternal("UDKEmitterPool was passed a none EmitterTemplate");
		return none;
	}
	PSC = super.SpawnEmitter(EmitterTemplate, SpawnLocation, SpawnRotation, AttachToActor, InInstigator, MaxDLEPooledReuses, bInheritScaleFromBase);
	// End:0xCF
	if(WorldInfo.bDropDetail)
	{
		LODLevel = 1;		
	}
	else
	{
		// End:0x245
		if(EmitterTemplate.LODDistances.Length > 1)
		{
			LODLevel = 1;
			// End:0x244
			foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
			{
				// End:0x243
				if(((PC.ViewTarget != none) && (VSize(PC.ViewTarget.Location - SpawnLocation) * PC.LODDistanceFactor) < EmitterTemplate.LODDistances[1]) && (Vector(PC.Rotation) Dot (SpawnLocation - PC.ViewTarget.Location)) >= 0.0000000)
				{
					LODLevel = 0;
					// End:0x244
					break;
				}				
			}			
		}
	}
	PSC.SetLODLevel(LODLevel);
	PSC.SetDepthPriorityGroup(1);
	return PSC;
	//return ReturnValue;	
}

function OnExplosionLightFinished(UDKExplosionLight Light)
{
	local int I;

	DetachComponent(Light);
	I = RelativeExplosionLights.Find('Light', Light);
	// End:0x64
	if(I != -1)
	{
		RelativeExplosionLights.Remove(I, 1);
	}
	//return;	
}

function UDKExplosionLight SpawnExplosionLight(Class<UDKExplosionLight> LightClass, Vector SpawnLocation, optional Actor AttachToActor)
{
	local editinline UDKExplosionLight Light;
	local int I;

	// End:0x65
	if((AttachToActor != none) && AttachToActor.bStatic || !AttachToActor.bMovable)
	{
		AttachToActor = none;
	}
	Light = new (self) LightClass;
	Light.SetTranslation(SpawnLocation);
	Light.__OnLightFinished__Delegate = OnExplosionLightFinished;
	AttachComponent(Light);
	// End:0x1D2
	if(AttachToActor != none)
	{
		I = RelativeExplosionLights.Length;
		RelativeExplosionLights.Length = I + 1;
		RelativeExplosionLights[I].Light = Light;
		RelativeExplosionLights[I].Base = AttachToActor;
		RelativeExplosionLights[I].RelativeLocation = SpawnLocation - AttachToActor.Location;
	}
	return Light;
	//return ReturnValue;	
}

defaultproperties
{
	// Reference: ParticleSystemComponent'UDKBase.Default__UDKEmitterPool.ParticleSystemComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent0'
	// Archetype: ParticleSystemComponent'Engine.Default__EmitterPool.ParticleSystemComponent0'
	begin object name="ParticleSystemComponent0"
		bOverrideLODMethod=true
		LODMethod=ParticleSystemLODMethod.PARTICLESYSTEMLODMETHOD_DirectSet
		ReplacementPrimitive=none
	end object
	PSCTemplate=ParticleSystemComponent0
	MaxActiveEffects=200
	SMC_MIC_ReductionTime=2.0000000
	IdealStaticMeshComponents=200
	IdealMaterialInstanceConstants=200
}