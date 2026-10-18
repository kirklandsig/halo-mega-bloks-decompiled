class HaloGib extends UTGib
	config(Game);

var ParticleSystem PS_GibExplosionEffect;
var ParticleSystem PS_GibTrailEffect;

simulated event PreBeginPlay()
{
	super(Actor).PreBeginPlay();
	//return;	
}

simulated function ActivateGibExplosionEffect()
{
	local editinline ParticleSystemComponent PSC_Trail;

	// End:0x2B
	if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
	{
		return;
	}
	WorldInfo.MyEmitterPool.SpawnEmitter(PS_GibExplosionEffect, Location, Rotation);
	PSC_Trail = new (self) Class'Engine.ParticleSystemComponent';
	PSC_Trail.SetTemplate(PS_GibTrailEffect);
	AttachComponent(PSC_Trail);
	//return;	
}

simulated function SetGibStaticMesh(StaticMesh NewStaticMesh)
{
	local editinline StaticMeshComponent SMC;

	LogInternal("SetGibStaticMesh to" @ string(NewStaticMesh));
	GibMeshComp = new (self) Class'MegaHaloGame.HaloGibStaticMeshComponent';
	CollisionComponent = GibMeshComp;
	SMC = StaticMeshComponent(GibMeshComp);
	AttachComponent(GibMeshComp);
	SMC.SetStaticMesh(NewStaticMesh);
	SMC.SetLightEnvironment(GibLightEnvironment);
	//return;	
}

defaultproperties
{
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloGib.GibLightEnvironmentComp'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'GibLightEnvironmentComp'
	// Archetype: DynamicLightEnvironmentComponent'UTGame.Default__UTGib.GibLightEnvironmentComp'
	begin object name="GibLightEnvironmentComp"
	end object
	GibLightEnvironment=GibLightEnvironmentComp
	Components[0]=GibLightEnvironmentComp
}