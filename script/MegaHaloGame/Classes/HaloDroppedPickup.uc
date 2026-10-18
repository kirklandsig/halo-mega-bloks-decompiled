class HaloDroppedPickup extends KActorSpawnable;

var Inventory Inventory;
var Class<Inventory> InventoryClass;
var float SpawnTime;

replication
{
	// Pos:0x000
	if(bNetInitial)
		InventoryClass;
}

simulated event PreBeginPlay()
{
	super(Actor).PreBeginPlay();
	// End:0x62
	if(int(Role) == int(ROLE_Authority))
	{
		Inventory = Inventory(Owner);
		InventoryClass = Inventory.Class;
	}
	SpawnTime = WorldInfo.TimeSeconds;
	//return;	
}

simulated function Destroyed()
{
	local HaloPawn Pawn;
	local HaloWeapon Weap;

	// End:0x2C
	foreach TouchingActors(Class'MegaHaloGame.HaloPawn', Pawn)
	{
		UnTouch(Pawn);		
	}	
	RemoveFromGlobalList();
	// End:0xB1
	if(Inventory != none)
	{
		Weap = HaloWeapon(Inventory);
		// End:0x99
		if(Weap != none)
		{
			Weap.MergeWithDroppedWeapons(Location);
		}
		Inventory.Destroy();
	}
	super(KActor).Destroyed();
	//return;	
}

function AddToGlobalList()
{
	local HaloGameDefault Game;

	Game = HaloGameDefault(WorldInfo.Game);
	// End:0x68
	if((Game == none) || Game.ThePickupManager == none)
	{
		return;
	}
	Game.ThePickupManager.Register(self);
	//return;	
}

function RemoveFromGlobalList()
{
	local HaloGameDefault Game;

	Game = HaloGameDefault(WorldInfo.Game);
	// End:0x68
	if((Game == none) || Game.ThePickupManager == none)
	{
		return;
	}
	Game.ThePickupManager.Unregister(self);
	//return;	
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	local HaloPawn Pawn;
	local HaloPlayerInventoryManager invMgr;
	local array<UTWeapon> weapList;
	local HaloWeapon myWeap;
	local UTWeapon Weap;
	local int preAmmoCount;

	Pawn = HaloPawn(Other);
	// End:0x37B
	if(Pawn != none)
	{
		Pawn.TouchedPickupCount += 1;
		// End:0x37B
		if(HaloAIPawn(Pawn) == none)
		{
			myWeap = HaloWeapon(Inventory);
			// End:0x37B
			if(myWeap != none)
			{
				invMgr = HaloPlayerInventoryManager(Pawn.InvManager);
				// End:0x37B
				if(invMgr != none)
				{
					preAmmoCount = myWeap.AmmoCount + myWeap.ExtraAmmoCount;
					invMgr.GetDroppableWeaponList(weapList, false);
					// End:0x1AA
					foreach weapList(Weap)
					{
						myWeap.GiveAmmoTo(HaloWeapon(Weap), myWeap.default.MaxExtraAmmoCount > 0);						
					}					
					// End:0x354
					if(preAmmoCount != (myWeap.AmmoCount + myWeap.ExtraAmmoCount))
					{
						// End:0x29A
						if((HaloPlayerPawnController(Pawn.Controller) != none) && HaloPlayerPawnController(Pawn.Controller).IsLocalPlayerController())
						{
							Pawn.SetSwitch('Local_Player', 'Yes');							
						}
						else
						{
							Pawn.SetSwitch('Local_Player', 'No');
						}
						Pawn.SetSwitch('Weapon_Type', myWeap.akWeaponType);
						Pawn.PlayAkEvent(myWeap.AmmoPickupSoundEvent);
					}
					// End:0x37B
					if(myWeap.HasAnyAmmo()!)
					{
						Destroy();
					}
				}
			}
		}
	}
	//return;	
}

simulated event UnTouch(Actor Other)
{
	local HaloPawn Pawn;

	Pawn = HaloPawn(Other);
	// End:0x4C
	if(Pawn != none)
	{
		Pawn.TouchedPickupCount -= 1;
	}
	//return;	
}

function GiveTo(HaloPawn P)
{
	// End:0x74
	if(Inventory != none)
	{
		RemoveFromGlobalList();
		Inventory.AnnouncePickup(P);
		Inventory.super(HaloDroppedPickup).GiveTo(P);
		Inventory = none;
	}
	Destroy();
	//return;	
}

auto state Spinning
{
	event BeginState(name PreviousStateName)
	{
		GetALocalPlayerController().myHUD.RemovePostRenderedActor(self);
		SetTickIsDisabled(false);
		//return;		
	}

	event Tick(float DeltaTime)
	{
		local Rotator R;

		R.Yaw = int(float(Rotation.Yaw) + (float(32767) * DeltaTime));
		SetRotation(R);
		// End:0x7F
		if(PlayerCanSeeMe() == false)
		{
			// End:0x7F
			if(PlayerCanSeeMe(true) == false)
			{
				GotoState('Dormant');
			}
		}
		//return;		
	}
	stop;	
}

state Dormant
{
	event BeginState(name PreviousStateName)
	{
		GetALocalPlayerController().myHUD.AddPostRenderedActor(self);
		SetTickIsDisabled(true);
		//return;		
	}

	simulated event PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
	{
		GotoState('Spinning');
		//return;		
	}
	stop;	
}

defaultproperties
{
	// Reference: StaticMeshComponent'MegaHaloGame.Default__HaloDroppedPickup.StaticMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'StaticMeshComponent0'
	// Archetype: StaticMeshComponent'Engine.Default__KActorSpawnable.StaticMeshComponent0'
	begin object name="StaticMeshComponent0"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloDroppedPickup.MyLightEnvironment'
		RBChannel=ERBCollisionChannel.RBCC_Untitled1
		CastShadow=false
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		CanBlockCamera=false
	end object
	StaticMeshComponent=StaticMeshComponent0
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloDroppedPickup.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'Engine.Default__KActorSpawnable.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	GwNavObstacleComponentClassPath=""
	Components[0]=MyLightEnvironment
	Components[1]=StaticMeshComponent0
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloDroppedPickup.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	begin object name="CollisionCylinder" class=Engine.CylinderComponent
		CollisionHeight=75.0000000
		CollisionRadius=150.0000000
		ReplacementPrimitive=none
		CollideActors=true
		BlockZeroExtent=false
		CanBlockCamera=false
	end object
	Components[2]=CollisionCylinder
	Physics=EPhysics.PHYS_Falling
	CollisionType=ECollisionType.COLLIDE_TouchAll
	bIgnoreRigidBodyPawns=true
	bIgnoreEncroachers=true
	bCollideWorld=true
	bBlockActors=false
	bProjTarget=false
	bBlocksTeleport=false
	CollisionComponent=CollisionCylinder
}