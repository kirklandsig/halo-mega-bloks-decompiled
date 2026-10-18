class HVCCAddon_Ram extends HVCCAddon
	notplaceable;

var export editinline SkeletalMeshComponent SkeletalMeshComponent;
var Class<DamageType> CrushedDamageType;

function OnAttach()
{
	//return;	
}

function OnDetach()
{
	//return;	
}

function Hide()
{
	SkeletalMeshComponent.SetHidden(true);
	//return;	
}

function show()
{
	SkeletalMeshComponent.SetHidden(false);
	//return;	
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	// End:0x71
	if(((Other != none) && HaloDestructibleActor(Other) != none) && HaloVehicle(Base) != none)
	{
		HandleHDACollision(HaloDestructibleActor(Other), HaloVehicle(Base));
	}
	super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
	//return;	
}

function HandleHDACollision(HaloDestructibleActor Other, HaloVehicle MyVehicle)
{
	local float Speed, KickbackAmount;
	local Vector Momentum, HitDir, Kickback;

	MyVehicle.VehiclePlayCollisionSound(Other);
	// End:0x2EC
	if(Other != none)
	{
		Speed = VSize(MyVehicle.Velocity);
		Momentum = MyVehicle.Velocity * MyVehicle.Mass;
		Other.TakeDamage(int((Speed * MyVehicle.Mass) * 0.0050000), MyVehicle.GetCollisionDamageInstigator(), Other.Location, Momentum, CrushedDamageType);
		// End:0x2EC
		if(MyVehicle.Mesh != none)
		{
			HitDir = Location - Other.Location;
			HitDir.Z = 0.0000000;
			HitDir = Normal(HitDir);
			KickbackAmount = Other.SkeletalMeshComponent.BodyInstance.GetBodyMass() - VSize(Momentum);
			KickbackAmount = FMax(KickbackAmount, 0.0000000);
			Kickback = HitDir * KickbackAmount;
			MyVehicle.Mesh.AddImpulse(Kickback, Location);
			MyVehicle.PlayHDACollisionForcefeedback(Speed, HitDir-);
		}
	}
	//return;	
}

defaultproperties
{
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HVCCAddon_Ram.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0" class=Engine.SkeletalMeshComponent
		SkeletalMesh=SkeletalMesh'Warthog.Addon.Ram'
		PhysicsAsset=PhysicsAsset'Warthog.Addon.Ram_Physics'
		bHasPhysicsAssetInstance=true
		ReplacementPrimitive=none
		RBChannel=ERBCollisionChannel.RBCC_Untitled3
		CollideActors=true
		AlwaysCheckCollision=true
		BlockRigidBody=true
		bNotifyRigidBodyCollision=true
		RBCollideWithChannels=(Default=true,GameplayPhysics=true,EffectPhysics=true,Untitled2=true,Untitled4=true,BlockingVolume=true)
		ScriptRigidBodyCollisionThreshold=0.0010000
	end object
	SkeletalMeshComponent=SkeletalMeshComponent0
	CrushedDamageType=Class'MegaHaloGame.HaloDamageType_WarthogRam'
	HVCParentBoneName="Addon_front"
	UnlockStringID="RamUpgradeReceived"
	Components[0]=SkeletalMeshComponent0
	BlockRigidBody=true
	bCollideActors=true
	CollisionComponent=SkeletalMeshComponent0
}