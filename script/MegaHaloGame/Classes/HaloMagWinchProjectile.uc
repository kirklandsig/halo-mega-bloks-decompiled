class HaloMagWinchProjectile extends SkeletalMeshActorSpawnable;

var HVCCAddon_MagWinch ParentWinch;
var HaloWinchGateActor TargetGate;
var Vector TargetPosition;
var float ContactDistance;
var float ProjectileSpeed;
var float ProjectileReturnSpeed;
var bool ContactMade;
var bool FlyingBack;
var ParticleSystem ContactParticleSystem;

simulated function PostBeginPlay()
{
	super(SkeletalMeshActor).PostBeginPlay();
	PlayAkEvent(AkEvent'Vehicle_Equipment.Play_VEH_UNSC_Warthog_Winch_Launch');
	PlayAkEvent(AkEvent'Vehicle_Equipment.Play_VEH_UNSC_Warthog_Winch_Travel_Loop');
	//return;	
}

function Tick(float DeltaTime)
{
	// End:0x36
	if(!ContactMade && !FlyingBack)
	{
		FlyTowardsTarget(DeltaTime);		
	}
	else
	{
		// End:0x56
		if(FlyingBack)
		{
			FlyBackToVehicle(DeltaTime);
		}
	}
	//return;	
}

simulated event Destroyed()
{
	super(SkeletalMeshActor).Destroyed();
	PlayAkEvent(AkEvent'Vehicle_Equipment.Stop_VEH_UNSC_Warthog_Winch_Retract');
	//return;	
}

function FlyTowardsTarget(float DeltaTime)
{
	local float distanceToTarget;
	local Vector ToTarget;

	ToTarget = TargetPosition - Location;
	distanceToTarget = VSizeSq(ToTarget);
	// End:0x62
	if(distanceToTarget < (ContactDistance * ContactDistance))
	{
		OnTargetContact();		
	}
	else
	{
		Velocity = Normal(ToTarget) * ProjectileSpeed;
		SetRotation(RInterpTo(Rotation, Rotator(ToTarget), DeltaTime, 45.0000000));
		SetLocation(Location + (Velocity * DeltaTime));
	}
	//return;	
}

function FlyBackToVehicle(float DeltaTime)
{
	local float DistanceToVehicle;
	local Vector toVehicle;

	toVehicle = ParentWinch.Location - Location;
	DistanceToVehicle = VSizeSq(toVehicle);
	// End:0xA5
	if(DistanceToVehicle < (ContactDistance * ContactDistance))
	{
		PlayAkEvent(AkEvent'Vehicle_Equipment.Play_VEH_UNSC_Warthog_Winch_Impact');
		ParentWinch.DestroyProjectile();		
	}
	else
	{
		Velocity = Normal(toVehicle) * ProjectileReturnSpeed;
		SetRotation(RInterpTo(Rotation, Rotator(-toVehicle), DeltaTime, 45.0000000));
		SetLocation(Location + (Velocity * DeltaTime));
	}
	//return;	
}

function OnTargetContact()
{
	local editinline ParticleSystemComponent PSC;

	PSC = WorldInfo.MyEmitterPool.SpawnEmitter(ContactParticleSystem, TargetGate.GetWinchAttachLocation(), TargetGate.Rotation);
	PSC.CastShadow = false;
	PSC.bCastDynamicShadow = false;
	PSC.bCastStaticShadow = false;
	PSC.bAcceptsDynamicDominantLightShadows = false;
	ContactMade = true;
	PlayAkEvent(AkEvent'Vehicle_Equipment.Play_VEH_UNSC_Warthog_Winch_Impact');
	ParentWinch.OnProjectileReturning();
	//return;	
}

function StartFlyBack(bool TearDownGate)
{
	PlayAkEvent(AkEvent'Vehicle_Equipment.Play_VEH_UNSC_Warthog_Winch_Retract');
	FlyingBack = true;
	// End:0xEE
	if(TearDownGate)
	{
		ParentWinch.LockMesh = TargetGate.TearDown();
		ParentWinch.AttachLock();
		HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).SendRemoteEvent('WinchDestroyBarricade');		
	}
	else
	{
		ParentWinch.OnProjectileReturning();
	}
	//return;	
}

defaultproperties
{
	ContactDistance=100.0000000
	ProjectileSpeed=3000.0000000
	ProjectileReturnSpeed=6000.0000000
	ContactParticleSystem=ParticleSystem'V_UNSC_Warthog_FX.Effects.FX_Winch_ElectroAttch'
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloMagWinchProjectile.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	// Archetype: SkeletalMeshComponent'Engine.Default__SkeletalMeshActorSpawnable.SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloMagWinchProjectile.SkeletalMeshComponent0.AnimNodeSeq0'
		// Archetype: AnimNodeSequence'Engine.Default__SkeletalMeshActorSpawnable.SkeletalMeshComponent0.AnimNodeSeq0'
		begin object name="AnimNodeSeq0"
		end object
		Animations=AnimNodeSeq0
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloMagWinchProjectile.MyLightEnvironment'
	end object
	SkeletalMeshComponent=SkeletalMeshComponent0
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloMagWinchProjectile.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'Engine.Default__SkeletalMeshActorSpawnable.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	// Reference: AudioComponent'MegaHaloGame.Default__HaloMagWinchProjectile.FaceAudioComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'FaceAudioComponent'
	// Archetype: AudioComponent'Engine.Default__SkeletalMeshActorSpawnable.FaceAudioComponent'
	begin object name="FaceAudioComponent"
	end object
	FacialAudioComp=FaceAudioComponent
	Components[0]=MyLightEnvironment
	Components[1]=SkeletalMeshComponent0
	Components[2]=FaceAudioComponent
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloMagWinchProjectile.SkeletalMeshComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent'
	begin object name="SkeletalMeshComponent" class=Engine.SkeletalMeshComponent
		SkeletalMesh=SkeletalMesh'Winch_Addon.winch_bolt'
		ReplacementPrimitive=none
	end object
	Components[3]=SkeletalMeshComponent
	CollisionType=ECollisionType.COLLIDE_CustomDefault
	CollisionComponent=SkeletalMeshComponent0
}