class PickupFactory extends NavigationPoint
	abstract
	native
	nativereplication
	placeable;

var bool bOnlyReplicateHidden;
var repnotify bool bPickupHidden;
var bool bPredictRespawns;
var bool bIsSuperItem;
var bool bRespawnPaused;
var repnotify Class<Inventory> InventoryType;
var float RespawnEffectTime;
var float MaxDesireability;
var export editinline PrimitiveComponent PickupMesh;
var PickupFactory ReplacementFactory;
var PickupFactory OriginalFactory;

replication
{
	// Pos:0x000
	if(bNetDirty && int(Role) == int(ROLE_Authority))
		bPickupHidden;

	// Pos:0x020
	if(bNetInitial && int(Role) == int(ROLE_Authority))
		InventoryType;
}

simulated event ReplicatedEvent(name VarName)
{
	// End:0x3E
	if(VarName == 'bPickupHidden')
	{
		// End:0x31
		if(bPickupHidden)
		{
			SetPickupHidden();			
		}
		else
		{
			SetPickupVisible();
		}		
	}
	else
	{
		// End:0x5F
		if(VarName == 'InventoryType')
		{
			InitializePickup();
		}
	}
	//return;	
}

simulated event PreBeginPlay()
{
	InitializePickup();
	super(Actor).PreBeginPlay();
	//return;	
}

simulated function InitializePickup()
{
	// End:0x2F
	if(InventoryType == none)
	{
		WarnInternal("No inventory type for" @ string(self));
		return;
	}
	bPredictRespawns = InventoryType.default.bPredictRespawns;
	MaxDesireability = InventoryType.default.MaxDesireability;
	SetPickupMesh();
	bIsSuperItem = InventoryType.default.bDelayedSpawn;
	//return;	
}

simulated event SetInitialState()
{
	bScriptInitialized = true;
	// End:0x58
	if(InventoryType == none)
	{
		WarnInternal("Disabling as no inventory type for " $ string(self));
		GotoState('Disabled');		
	}
	else
	{
		// End:0x76
		if(bIsSuperItem)
		{
			GotoState('WaitingForMatch');			
		}
		else
		{
			super(Actor).SetInitialState();
		}
	}
	//return;	
}

simulated function ShutDown()
{
	GotoState('Disabled');
	//return;	
}

simulated function SetPickupMesh()
{
	// End:0xE7
	if(InventoryType.default.PickupFactoryMesh != none)
	{
		// End:0x51
		if(PickupMesh != none)
		{
			DetachComponent(PickupMesh);
			PickupMesh = none;
		}
		PickupMesh = new (self) InventoryType.default.PickupFactoryMesh.Class (InventoryType.default.PickupFactoryMesh);
		AttachComponent(PickupMesh);
		// End:0xDD
		if(bPickupHidden)
		{
			SetPickupHidden();			
		}
		else
		{
			SetPickupVisible();
		}
	}
	//return;	
}

function Reset()
{
	// End:0x1E
	if(bIsSuperItem)
	{
		GotoState('Sleeping');		
	}
	else
	{
		GotoState('Pickup');
	}
	super(Actor).Reset();
	//return;	
}

function bool CheckForErrors()
{
	local Actor HitActor;
	local Vector HitLocation, HitNormal;

	HitActor = Trace(HitLocation, HitNormal, Location - vect(0.0000000, 0.0000000, 10.0000000), Location, false);
	// End:0x68
	if(HitActor == none)
	{
		LogInternal(string(self) $ " FLOATING");
		return true;
	}
	return super(Actor).CheckForErrors();
	//return ReturnValue;	
}

function SetRespawn()
{
	// End:0x6D
	if((InventoryType.default.RespawnTime != float(0)) && WorldInfo.Game.ShouldRespawn(self))
	{
		StartSleeping();		
	}
	else
	{
		GotoState('Disabled');
	}
	//return;	
}

function StartSleeping()
{
	GotoState('Sleeping');
	//return;	
}

event float DetourWeight(Pawn Other, float PathWeight)
{
	return ((ReplacementFactory != none) ? ReplacementFactory.DetourWeight(Other, PathWeight) : 0.0000000);
	//return ReturnValue;	
}

function SpawnCopyFor(Pawn Recipient)
{
	local Inventory Inv;

	Inv = Spawn(InventoryType);
	// End:0x83
	if(Inv != none)
	{
		Inv.GiveTo(Recipient);
		Inv.AnnouncePickup(Recipient);
	}
	//return;	
}

function bool ReadyToPickup(float MaxWait)
{
	return false;
	//return ReturnValue;	
}

function GiveTo(Pawn P)
{
	SpawnCopyFor(P);
	PickedUpBy(P);
	//return;	
}

function PickedUpBy(Pawn P)
{
	SetRespawn();
	TriggerEventClass(Class'Engine.SeqEvent_PickupStatusChange', P, 1);
	// End:0xE1
	if((P.Controller != none) && P.Controller.MoveTarget == self)
	{
		P.SetAnchor(self);
		P.Controller.MoveTimer = -1.0000000;
	}
	//return;	
}

function RecheckValidTouch()
{
	//return;	
}

function float GetRespawnTime()
{
	return InventoryType.default.RespawnTime;
	//return ReturnValue;	
}

function RespawnEffect()
{
	//return;	
}

simulated function SetPickupHidden()
{
	bForceNetUpdate = true;
	bPickupHidden = true;
	// End:0x47
	if(PickupMesh != none)
	{
		PickupMesh.SetHidden(true);
	}
	//return;	
}

simulated function SetPickupVisible()
{
	bForceNetUpdate = true;
	bPickupHidden = false;
	// End:0x47
	if(PickupMesh != none)
	{
		PickupMesh.SetHidden(false);
	}
	//return;	
}

event Destroyed()
{
	// End:0x37
	if(OriginalFactory != none)
	{
		OriginalFactory.ReplacementFactory = ReplacementFactory;
	}
	// End:0x6E
	if(ReplacementFactory != none)
	{
		ReplacementFactory.OriginalFactory = OriginalFactory;
	}
	//return;	
}

function bool DelayRespawn()
{
	return false;
	//return ReturnValue;	
}

auto state Pickup
{
	event float DetourWeight(Pawn Other, float PathWeight)
	{
		return InventoryType.static.DetourWeight(Other, PathWeight);
		//return ReturnValue;		
	}

	function bool ReadyToPickup(float MaxWait)
	{
		return true;
		//return ReturnValue;		
	}

	function bool ValidTouch(Pawn Other)
	{
		// End:0x3A
		if((Other == none) || Other.bCanPickupInventory!)
		{
			return false;			
		}
		else
		{
			// End:0x76
			if(Other.Controller == none)
			{
				SetTimer(0.2000000, false, 'RecheckValidTouch');
				return false;				
			}
			else
			{
				// End:0xBC
				if(FastTrace(Other.Location, Location)!)
				{
					SetTimer(0.5000000, false, 'RecheckValidTouch');
					return false;
				}
			}
		}
		// End:0x108
		if(WorldInfo.Game.PickupQuery(Other, InventoryType, self))
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

	function CheckTouching()
	{
		local Pawn P;

		// End:0x61
		foreach TouchingActors(Class'Engine.Pawn', P)
		{
			Touch(P, none, Location, Normal(Location - P.Location));			
		}		
		//return;		
	}

	event BeginState(name PreviousStateName)
	{
		TriggerEventClass(Class'Engine.SeqEvent_PickupStatusChange', none, 0);
		//return;		
	}
Begin:

	CheckTouching();
	stop;		
}

state WaitingForMatch
{
	ignores Touch;

	function MatchStarting()
	{
		GotoState('Sleeping');
		//return;		
	}

	event BeginState(name PreviousStateName)
	{
		SetPickupHidden();
		//return;		
	}
	stop;	
}

state Sleeping
{
	ignores StartSleeping, Touch;

	function bool ReadyToPickup(float MaxWait)
	{
		return ((bPredictRespawns && bRespawnPaused!) && LatentFloat <= MaxWait) && LatentFloat > 0.0000000;
		//return ReturnValue;		
	}

	event BeginState(name PreviousStateName)
	{
		SetPickupHidden();
		//return;		
	}

	event EndState(name NextStateName)
	{
		SetPickupVisible();
		//return;		
	}
Begin:

	bRespawnPaused = true;
	J0x0C:

	// End:0x24 [Loop If]
	if(DelayRespawn())
	{
		Sleep(1.0000000);
		// [Loop Continue]
		goto J0x0C;
	}
	bRespawnPaused = false;
	Sleep((GetRespawnTime()) - RespawnEffectTime);
Respawn:


	RespawnEffect();
	Sleep(RespawnEffectTime);
	GotoState('Pickup');
	stop;				
}

state Disabled
{
	ignores StartSleeping, Reset;

	function bool ReadyToPickup(float MaxWait)
	{
		return false;
		//return ReturnValue;		
	}

	simulated event SetInitialState()
	{
		bScriptInitialized = true;
		//return;		
	}

	simulated event BeginState(name PreviousStateName)
	{
		SetPickupHidden();
		SetCollision(false, false);
		//return;		
	}

	simulated event EndState(name NextStateName)
	{
		SetPickupVisible();
		//return;		
	}
	stop;	
}

defaultproperties
{
	bOnlyReplicateHidden=true
	// Reference: CylinderComponent'Engine.Default__PickupFactory.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__NavigationPoint.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=80.0000000
		CollisionRadius=40.0000000
		ReplacementPrimitive=none
		CollideActors=true
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=none
	Components[1]=none
	Components[2]=none
	Components[3]=CollisionCylinder
	Components[4]=none
	RemoteRole=ENetRole.ROLE_SimulatedProxy
	TickGroup=ETickingGroup.TG_DuringAsyncWork
	bStatic=false
	bIgnoreEncroachers=true
	bAlwaysRelevant=true
	bCollideWhenPlacing=false
	bCollideActors=true
	NetUpdateFrequency=1.0000000
	CollisionComponent=CollisionCylinder
	SupportedEvents[0]=Class'Engine.SeqEvent_Touch'
	SupportedEvents[1]=Class'Engine.SeqEvent_Destroyed'
	SupportedEvents[2]=Class'Engine.SeqEvent_TakeDamage'
	SupportedEvents[3]=Class'Engine.SeqEvent_HitWall'
	SupportedEvents[4]=Class'Engine.SeqEvent_AnimNotify'
	SupportedEvents[5]=Class'Engine.SeqEvent_MobileTouch'
	SupportedEvents[6]=Class'Engine.SeqEvent_PickupStatusChange'
}