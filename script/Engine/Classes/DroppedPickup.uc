class DroppedPickup extends Actor
	native
	notplaceable;

var Inventory Inventory;
var repnotify Class<Inventory> InventoryClass;
var NavigationPoint PickupCache;
var repnotify bool bFadeOut;

replication
{
	// Pos:0x000
	if(int(Role) == int(ROLE_Authority))
		InventoryClass, bFadeOut;
}

// Export UDroppedPickup::execAddToNavigation(FFrame&, void* const)
native final function AddToNavigation();

// Export UDroppedPickup::execRemoveFromNavigation(FFrame&, void* const)
native final function RemoveFromNavigation();

event Destroyed()
{
	// End:0x27
	if(Inventory != none)
	{
		Inventory.Destroy();
	}
	//return;	
}

simulated event ReplicatedEvent(name VarName)
{
	// End:0x6A
	if(VarName == 'InventoryClass')
	{
		SetPickupMesh(InventoryClass.default.DroppedPickupMesh);
		SetPickupParticles(InventoryClass.default.DroppedPickupParticles);		
	}
	else
	{
		// End:0x92
		if(VarName == 'bFadeOut')
		{
			GotoState('FadeOut');			
		}
		else
		{
			super.ReplicatedEvent(VarName);
		}
	}
	//return;	
}

function Reset()
{
	Destroy();
	//return;	
}

simulated event SetPickupMesh(PrimitiveComponent PickupMesh)
{
	local editinline ActorComponent Comp;

	// End:0x82
	if((PickupMesh != none) && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		Comp = new (self) PickupMesh.Class (PickupMesh);
		AttachComponent(Comp);
	}
	//return;	
}

simulated event SetPickupParticles(ParticleSystemComponent PickupParticles)
{
	local editinline ParticleSystemComponent Comp;

	// End:0xA3
	if((PickupParticles != none) && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		Comp = new (self) PickupParticles.Class (PickupParticles);
		AttachComponent(Comp);
		Comp.SetActive(true);
	}
	//return;	
}

event EncroachedBy(Actor Other)
{
	Destroy();
	//return;	
}

function float DetourWeight(Pawn Other, float PathWeight)
{
	return Inventory.DetourWeight(Other, PathWeight);
	//return ReturnValue;	
}

event Landed(Vector HitNormal, Actor FloorActor)
{
	bForceNetUpdate = true;
	bNetDirty = true;
	NetUpdateFrequency = 3.0000000;
	AddToNavigation();
	//return;	
}

function GiveTo(Pawn P)
{
	// End:0x6A
	if(Inventory != none)
	{
		Inventory.AnnouncePickup(P);
		Inventory.super(DroppedPickup).GiveTo(P);
		Inventory = none;
	}
	PickedUpBy(P);
	//return;	
}

function PickedUpBy(Pawn P)
{
	Destroy();
	//return;	
}

function RecheckValidTouch()
{
	//return;	
}

auto state Pickup
{
	function bool ValidTouch(Pawn Other)
	{
		// End:0x83
		if(((Other == none) || !Other.bCanPickupInventory) || (Other.DrivenVehicle == none) && Other.Controller == none)
		{
			return false;
		}
		// End:0xD8
		if(((int(Physics) == int(2)) && Other == Instigator) && Velocity.Z > float(0))
		{
			return false;
		}
		// End:0x11E
		if(!FastTrace(Other.Location, Location))
		{
			SetTimer(0.5000000, false, 'RecheckValidTouch');
			return false;
		}
		// End:0x17F
		if(WorldInfo.Game.PickupQuery(Other, Inventory.Class, self))
		{
			return true;
		}
		return false;
		//return ReturnValue;		
	}

	function RecheckValidTouch()
	{
		CheckTouching();
		//return;		
	}

	event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
	{
		local Pawn P;

		P = Pawn(Other);
		// End:0x56
		if((P != none) && ValidTouch(P))
		{
			GiveTo(P);
		}
		//return;		
	}

	event Timer()
	{
		GotoState('FadeOut');
		//return;		
	}

	function CheckTouching()
	{
		local Pawn P;

		// End:0x43
		foreach TouchingActors(Class'Engine.Pawn', P)
		{
			Touch(P, none, Location, vect(0.0000000, 0.0000000, 1.0000000));			
		}		
		//return;		
	}

	event BeginState(name PreviousStateName)
	{
		AddToNavigation();
		// End:0x31
		if(LifeSpan > 0.0000000)
		{
			SetTimer(LifeSpan - float(1), false);
		}
		//return;		
	}

	event EndState(name NextStateName)
	{
		RemoveFromNavigation();
		//return;		
	}
Begin:

	CheckTouching();
	stop;		
}

state FadeOut extends Pickup
{
	simulated event BeginState(name PreviousStateName)
	{
		bFadeOut = true;
		RotationRate.Yaw = 60000;
		SetPhysics(5);
		LifeSpan = 1.0000000;
		//return;		
	}
	stop;	
}

defaultproperties
{
	Components[0]=none
	// Reference: CylinderComponent'Engine.Default__DroppedPickup.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	begin object name="CollisionCylinder" class=Engine.CylinderComponent
		CollisionHeight=20.0000000
		CollisionRadius=30.0000000
		ReplacementPrimitive=none
		CollideActors=true
	end object
	Components[1]=CollisionCylinder
	RemoteRole=ENetRole.ROLE_SimulatedProxy
	CollisionType=ECollisionType.COLLIDE_CustomDefault
	bIgnoreRigidBodyPawns=true
	bOrientOnSlope=true
	bUpdateSimulatedPosition=true
	bOnlyDirtyReplication=true
	bShouldBaseAtStartup=true
	bCollideActors=true
	bCollideWorld=true
	NetUpdateFrequency=8.0000000
	NetPriority=1.4000000
	LifeSpan=16.0000000
	CollisionComponent=CollisionCylinder
	RotationRate=(Pitch=0,Yaw=5000,Roll=0)
}