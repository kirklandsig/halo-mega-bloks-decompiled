class UTGib_Vehicle extends UTGib
	abstract
	config(Game)
	notplaceable;

var float TimeBeforeGibExplosionEffect;
var ParticleSystem PS_GibExplosionEffect;
var ParticleSystem PS_GibTrailEffect;
var SoundCue LoopedSound;
var name BurnName;
var float BurnDuration;
var MaterialInstanceTimeVarying MITV;
var bool bFadeoutOnCollision;
var name FadeoutColorTextureName;
var name FadeoutNormalTextureName;
var MaterialInstanceTimeVarying FadeoutMITV;
var float FadeOutDuration;
var Class<UTVehicle> OwningClass;

simulated event PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	CreateAudioComponent(LoopedSound, true, true);
	//return;	
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData Collision, int ContactIndex)
{
	super.RigidBodyCollision(HitComponent, OtherComponent, Collision, ContactIndex);
	// End:0x45
	if(bFadeoutOnCollision)
	{
		ActivateGibFadeoutEffect();
	}
	//return;	
}

simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	super.HitWall(HitNormal, Wall, WallComp);
	// End:0x3C
	if(bFadeoutOnCollision)
	{
		ActivateGibFadeoutEffect();
	}
	//return;	
}

simulated function ActivateGibExplosionEffect()
{
	local int TeamNum;
	local editinline ParticleSystemComponent PSC_Trail;

	// End:0x2B
	if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
	{
		return;
	}
	// End:0x65
	if(Instigator != none)
	{
		TeamNum = int(Instigator.GetTeamNum());
	}
	// End:0x7F
	if(TeamNum > 1)
	{
		TeamNum = 0;
	}
	// End:0xF5
	if(OwningClass.default.BurnOutMaterial[TeamNum] != none)
	{
		GibMeshComp.SetMaterial(0, OwningClass.default.BurnOutMaterial[TeamNum]);
	}
	// End:0x1E3
	if((WorldInfo.TimeSeconds - GibMeshComp.LastRenderTime) < 1.0000000)
	{
		WorldInfo.MyEmitterPool.SpawnEmitter(PS_GibExplosionEffect, Location, Rotation);
		PSC_Trail = new (self) Class'Engine.ParticleSystemComponent';
		PSC_Trail.SetTemplate(PS_GibTrailEffect);
		AttachComponent(PSC_Trail);
	}
	// End:0x29C
	if((WorldInfo.TimeSeconds - GibMeshComp.LastRenderTime) < 3.0000000)
	{
		MITV = GibMeshComp.CreateAndSetMaterialInstanceTimeVarying(0);
		MITV.SetScalarStartTime('BurnTime', LifeSpan - (BurnDuration - (FRand() * 1.0000000)));
	}
	//return;	
}

simulated function ActivateGibFadeoutEffect()
{
	local int I;
	local Texture ColorMap, NormalMap;
	local MaterialInterface BaseMaterial;
	local MaterialInstanceTimeVarying instancedMITV;

	// End:0x1E4
	if(GibMeshComp != none)
	{
		I = 0;
		J0x1A:

		// End:0x1E4 [Loop If]
		if(I < GibMeshComp.GetNumElements())
		{
			BaseMaterial = GibMeshComp.GetMaterial(I);
			BaseMaterial.GetTextureParameterValue(FadeoutColorTextureName, ColorMap);
			BaseMaterial.GetTextureParameterValue(FadeoutNormalTextureName, NormalMap);
			instancedMITV = new (self) Class'Engine.MaterialInstanceTimeVarying';
			instancedMITV.SetParent(FadeoutMITV);
			instancedMITV.SetDuration(FadeOutDuration);
			instancedMITV.SetTextureParameterValue(FadeoutColorTextureName, ColorMap);
			instancedMITV.SetTextureParameterValue(FadeoutNormalTextureName, NormalMap);
			GibMeshComp.SetMaterial(I, instancedMITV);
			I++;
			// [Loop Continue]
			goto J0x1A;
		}
	}
	//return;	
}

defaultproperties
{
	TimeBeforeGibExplosionEffect=0.1000000
	PS_GibExplosionEffect=ParticleSystem'Envy_Effects.Particles.P_VH_Gib_Explosion'
	PS_GibTrailEffect=ParticleSystem'Envy_Effects.Tests.Effects.P_Vehicle_Damage_1'
	BurnName="BurnTime"
	BurnDuration=3.5000000
	bFadeoutOnCollision=true
	FadeoutColorTextureName="CLR_Texture"
	FadeoutNormalTextureName="NRM_Texture"
	FadeoutMITV=MaterialInstanceTimeVarying'Shared_Destruction_Materials.Materials.Master.Destruct_BlokDestroy_MITV'
	FadeOutDuration=5.0000000
	// Reference: DynamicLightEnvironmentComponent'UTGame.Default__UTGib_Vehicle.GibLightEnvironmentComp'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'GibLightEnvironmentComp'
	// Archetype: DynamicLightEnvironmentComponent'UTGame.Default__UTGib.GibLightEnvironmentComp'
	begin object name="GibLightEnvironmentComp"
	end object
	GibLightEnvironment=GibLightEnvironmentComp
	Components[0]=GibLightEnvironmentComp
}