class HaloHandheldPlasmaShield extends SkeletalMeshActor;

var float MaxHealth;
var float currentHealth;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	currentHealth = MaxHealth;
	//return;	
}

simulated event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	// End:0x3A
	if(((int(Role) < int(ROLE_Authority)) || currentHealth <= float(0)) || bHidden)
	{
		return;
	}
	SetSwitch('Equipment_Type', 'Jackal_Shield');
	PlayAkEvent(AkEvent'Equipment.Play_Equipment_Impact');
	super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	currentHealth -= float(Damage);
	// End:0xEE
	if(currentHealth <= float(0))
	{
		LifeSpan = 0.0010000;
	}
	//return;	
}

defaultproperties
{
	MaxHealth=350.0000000
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloHandheldPlasmaShield.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	// Archetype: SkeletalMeshComponent'Engine.Default__SkeletalMeshActor.SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0"
		SkeletalMesh=SkeletalMesh'Plasma_Shield.Plasma_Shield'
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloHandheldPlasmaShield.SkeletalMeshComponent0.AnimNodeSeq0'
		// Archetype: AnimNodeSequence'Engine.Default__SkeletalMeshActor.AnimNodeSeq0'
		begin object name="AnimNodeSeq0"
		end object
		Animations=AnimNodeSeq0
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloHandheldPlasmaShield.MyLightEnvironment'
		RBChannel=RBCC_Nothing
		Scale=1.5500000
	end object
	SkeletalMeshComponent=SkeletalMeshComponent0
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloHandheldPlasmaShield.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'Engine.Default__SkeletalMeshActor.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	// Reference: AudioComponent'MegaHaloGame.Default__HaloHandheldPlasmaShield.FaceAudioComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'FaceAudioComponent'
	// Archetype: AudioComponent'Engine.Default__SkeletalMeshActor.FaceAudioComponent'
	begin object name="FaceAudioComponent"
	end object
	FacialAudioComp=FaceAudioComponent
	Components[0]=MyLightEnvironment
	Components[1]=SkeletalMeshComponent0
	Components[2]=FaceAudioComponent
	CollisionType=COLLIDE_BlockWeapons
	bNoDelete=false
	bCollideActors=true
	CollisionComponent=SkeletalMeshComponent0
}