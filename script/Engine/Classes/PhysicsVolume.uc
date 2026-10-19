class PhysicsVolume extends Volume
	native
	nativereplication
	placeable;

struct CheckpointRecord
{
	var bool bPainCausing;
	var bool bActive;

	structdefaultproperties
	{
		bPainCausing=false
		bActive=false
	}
};

var interp Vector ZoneVelocity;
var bool bVelocityAffectsWalking;
var bool bForceVelocityOnWalkingPawns;
var bool bPainCausing;
var bool bAIShouldIgnorePain;
var bool bEntryPain;
var bool BACKUP_bPainCausing;
var bool bDestructive;
var bool bNoInventory;
var bool bMoveProjectiles;
var bool bBounceVelocity;
var bool bNeutralZone;
var bool bCrowdAgentsPlayDeathAnim;
var bool bPhysicsOnContact;
var bool bWaterVolume;
var float GroundFriction;
var float TerminalVelocity;
var float DamagePerSec;
var Class<DamageType> DamageType;
var int Priority;
var float FluidFriction;
var float PainInterval;
var float RigidBodyDamping;
var float MaxDampingForce;
var Info PainTimer;
var Controller DamageInstigator;
var transient PhysicsVolume NextPhysicsVolume;

// Export UPhysicsVolume::execGetGravityZ(FFrame&, void* const)
native function float GetGravityZ();

// Export UPhysicsVolume::execGetZoneVelocityForActor(FFrame&, void* const)
native function Vector GetZoneVelocityForActor(Actor TheActor);

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	BACKUP_bPainCausing = bPainCausing;
	// End:0x35
	if(Role < ROLE_Authority)
	{
		return;
	}
	// End:0x66
	if(bPainCausing)
	{
		PainTimer = Spawn(Class'Engine.VolumeTimer', self);
	}
	//return;	
}

function Reset()
{
	bPainCausing = BACKUP_bPainCausing;
	bForceNetUpdate = true;
	//return;	
}

event PhysicsChangedFor(Actor Other)
{
	//return;	
}

event ActorEnteredVolume(Actor Other)
{
	//return;	
}

event ActorLeavingVolume(Actor Other)
{
	//return;	
}

event PawnEnteredVolume(Pawn Other)
{
	// End:0x6F
	if((bForceVelocityOnWalkingPawns && ZoneVelocity != vect(0.0000000, 0.0000000, 0.0000000)) && int(Other.Physics) == 1)
	{
		Other.SetPhysics(2);
	}
	//return;	
}

event PawnLeavingVolume(Pawn Other)
{
	//return;	
}

simulated function OnToggle(SeqAct_Toggle inAction)
{
	// End:0x38
	if(!bStatic || RemoteRole > ROLE_None)
	{
		super.OnToggle(inAction);
	}
	// End:0x87
	if(inAction.InputLinks[0].bHasImpulse)
	{
		bPainCausing = BACKUP_bPainCausing;		
	}
	else
	{
		// End:0xCD
		if(inAction.InputLinks[1].bHasImpulse)
		{
			bPainCausing = false;			
		}
		else
		{
			// End:0x12B
			if(inAction.InputLinks[2].bHasImpulse)
			{
				bPainCausing = !bPainCausing && BACKUP_bPainCausing;
			}
		}
	}
	//return;	
}

simulated event CollisionChanged()
{
	//return;	
}

function TimerPop(VolumeTimer T)
{
	local Actor A;

	// End:0x9D
	if(T == PainTimer)
	{
		// End:0x28
		if(!bPainCausing)
		{
			return;
		}
		// End:0x9C
		foreach TouchingActors(Class'Engine.Actor', A)
		{
			// End:0x9B
			if(A.bCanBeDamaged && !A.bStatic)
			{
				CausePainTo(A);
			}			
		}		
	}
	//return;	
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
	// End:0x63
	if((Other == none) || Other.bStatic)
	{
		return;
	}
	// End:0xD6
	if((bNoInventory && DroppedPickup(Other) != none) && Other.Owner == none)
	{
		Other.LifeSpan = 1.5000000;
		return;
	}
	// End:0x20C
	if(bMoveProjectiles && ZoneVelocity != vect(0.0000000, 0.0000000, 0.0000000))
	{
		// End:0x155
		if(int(Other.Physics) == 6)
		{
			Other.Velocity += ZoneVelocity;			
		}
		else
		{
			// End:0x20C
			if(((Other.Base == none) && Other.IsA('Emitter')) && int(Other.Physics) == 0)
			{
				Other.SetPhysics(6);
				Other.Velocity += ZoneVelocity;
			}
		}
	}
	// End:0x2A1
	if(bPainCausing)
	{
		// End:0x25D
		if(Other.bDestroyInPainVolume)
		{
			Other.VolumeBasedDestroy(self);
			return;
		}
		// End:0x2A1
		if(bEntryPain && Other.bCanBeDamaged)
		{
			CausePainTo(Other);
		}
	}
	//return;	
}

function CausePainTo(Actor Other)
{
	// End:0x132
	if(DamagePerSec > float(0))
	{
		// End:0x60
		if(WorldInfo.bSoftKillZ && int(Other.Physics) != 1)
		{
			return;
		}
		// End:0xD0
		if((DamageType == none) || DamageType == Class'Engine.DamageType')
		{
			LogInternal((("No valid damagetype (" $ string(DamageType)) $ ") specified for ") $ PathName(self));
		}
		Other.TakeDamage(int(DamagePerSec * PainInterval), DamageInstigator, Location, vect(0.0000000, 0.0000000, 1.0000000), DamageType,, self);		
	}
	else
	{
		Other.HealDamage(int(-DamagePerSec * PainInterval), DamageInstigator, DamageType);
	}
	//return;	
}

function ModifyPlayer(Pawn PlayerPawn)
{
	//return;	
}

function NotifyPawnBecameViewTarget(Pawn P, PlayerController PC)
{
	//return;	
}

function OnSetDamageInstigator(SeqAct_SetDamageInstigator Action)
{
	DamageInstigator = Action.GetController(Action.DamageInstigator);
	//return;	
}

function bool ShouldSaveForCheckpoint()
{
	return bPainCausing != BACKUP_bPainCausing;
	//return ReturnValue;	
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
	Record.bPainCausing = bPainCausing;
	//return;	
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
	bPainCausing = Record.bPainCausing;
	//return;	
}

defaultproperties
{
	bVelocityAffectsWalking=true
	bEntryPain=true
	GroundFriction=8.0000000
	TerminalVelocity=4000.0000000
	DamageType=Class'Engine.DamageType'
	FluidFriction=0.3000000
	PainInterval=1.0000000
	MaxDampingForce=1000000.0000000
	// Reference: BrushComponent'Engine.Default__PhysicsVolume.BrushComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'BrushComponent0'
	// Archetype: BrushComponent'Engine.Default__Volume.BrushComponent0'
	begin object name="BrushComponent0"
		ReplacementPrimitive=none
		BlockZeroExtent=true
	end object
	BrushComponent=BrushComponent0
	Components[0]=BrushComponent0
	bAlwaysRelevant=true
	bOnlyDirtyReplication=true
	bForceAllowKismetModification=true
	NetUpdateFrequency=0.1000000
	CollisionComponent=BrushComponent0
}