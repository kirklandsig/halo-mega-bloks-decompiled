class Inventory extends Actor
	abstract
	native
	nativereplication
	notplaceable;

var Inventory Inventory;
var InventoryManager InvManager;
var const localized string ItemName;
var bool bDropOnDeath;
var bool bDelayedSpawn;
var bool bPredictRespawns;
var float RespawnTime;
var float MaxDesireability;
var const localized string PickupMessage;
var SoundCue PickupSound;
var string PickupForce;
var Class<DroppedPickup> DroppedPickupClass;
var export editinline PrimitiveComponent DroppedPickupMesh;
var export editinline PrimitiveComponent PickupFactoryMesh;
var export editinline ParticleSystemComponent DroppedPickupParticles;

replication
{
	// Pos:0x000
	if(((Role == ROLE_Authority) && bNetDirty) && bNetOwner)
		InvManager, Inventory;
}

simulated function string GetHumanReadableName()
{
	return default.ItemName;
	//return ReturnValue;	
}

event Destroyed()
{
	// End:0x85
	if((Pawn(Owner) != none) && Pawn(Owner).InvManager != none)
	{
		Pawn(Owner).InvManager.RemoveFromInventory(self);
	}
	//return;	
}

static function float BotDesireability(Actor PickupHolder, Pawn P, Controller C)
{
	local Inventory AlreadyHas;
	local float desire;

	desire = default.MaxDesireability;
	// End:0x6D
	if(default.RespawnTime < float(10))
	{
		AlreadyHas = P.FindInventoryType(default.Class);
		// End:0x6D
		if(AlreadyHas != none)
		{
			return -1.0000000;
		}
	}
	return desire;
	//return ReturnValue;	
}

static function float DetourWeight(Pawn Other, float PathWeight)
{
	return 0.0000000;
	//return ReturnValue;	
}

final function GiveTo(Pawn Other)
{
	// End:0x6B
	if((Other != none) && Other.InvManager != none)
	{
		Other.InvManager.AddInventory(self);
	}
	//return;	
}

function AnnouncePickup(Pawn Other)
{
	Other.HandlePickup(self);
	// End:0x5D
	if(PickupSound != none)
	{
		Other.PlaySound(PickupSound);
	}
	//return;	
}

function GivenTo(Pawn thisPawn, optional bool bDoNotActivate)
{
	LogInternal((((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ string(thisPawn)) @ "Weapon:") @ string(self), 'Inventory');
	Instigator = thisPawn;
	ClientGivenTo(thisPawn, bDoNotActivate);
	//return;	
}

reliable client simulated function ClientGivenTo(Pawn NewOwner, bool bDoNotActivate)
{
	SetOwner(NewOwner);
	Instigator = NewOwner;
	LogInternal((((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ string(NewOwner)) @ "Weapon:") @ string(self), 'Inventory');
	// End:0x116
	if((NewOwner != none) && NewOwner.Controller != none)
	{
		NewOwner.Controller.NotifyAddInventory(self);
	}
	//return;	
}

function ItemRemovedFromInvManager()
{
	//return;	
}

function bool DenyPickupQuery(Class<Inventory> ItemClass, Actor Pickup)
{
	// End:0x19
	if(ItemClass == Class)
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

function DropFrom(Vector StartLocation, Vector StartVelocity)
{
	local DroppedPickup P;

	// End:0x6A
	if((Instigator != none) && Instigator.InvManager != none)
	{
		Instigator.InvManager.RemoveFromInventory(self);
	}
	// End:0x8F
	if((DroppedPickupClass == none) || DroppedPickupMesh == none)
	{
		Destroy();
		return;
	}
	P = Spawn(DroppedPickupClass,,, StartLocation);
	// End:0xCF
	if(P == none)
	{
		Destroy();
		return;
	}
	P.SetPhysics(2);
	P.Inventory = self;
	P.InventoryClass = Class;
	P.Velocity = StartVelocity;
	P.Instigator = Instigator;
	P.SetPickupMesh(DroppedPickupMesh);
	P.SetPickupParticles(DroppedPickupParticles);
	Instigator = none;
	GotoState('None');
	//return;	
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	return default.PickupMessage;
	//return ReturnValue;	
}

defaultproperties
{
	MaxDesireability=0.1000000
	PickupMessage="Snagged an item."
	DroppedPickupClass=Class'Engine.DroppedPickup'
	Components[0]=none
	RemoteRole=ROLE_SimulatedProxy
	CollisionType=COLLIDE_CustomDefault
	bHidden=true
	bOnlyRelevantToOwner=true
	bReplicateMovement=false
	bOnlyDirtyReplication=true
	NetPriority=1.4000000
}