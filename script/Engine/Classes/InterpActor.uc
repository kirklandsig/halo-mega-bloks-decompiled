class InterpActor extends DynamicSMActor
	native
	placeable;

struct CheckpointRecord
{
	var Vector Location;
	var Rotator Rotation;
	var Actor.ECollisionType CollisionType;
	var bool bHidden;
	var bool bIsShutdown;
	var bool bNeedsPositionReplication;

	structdefaultproperties
	{
		Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		Rotation=(Pitch=0,Yaw=0,Roll=0)
		CollisionType=ECollisionType.COLLIDE_CustomDefault
		bHidden=false
		bIsShutdown=false
		bNeedsPositionReplication=false
	}
};

var bool bShouldSaveForCheckpoint;
var bool bMonitorMover;
var bool bMonitorZVelocity;
var bool bDestroyProjectilesOnEncroach;
var bool bContinueOnEncroachPhysicsObject;
var bool bStopOnEncroach;
var bool bShouldShadowParentAllAttachedActors;
var bool bIsLift;
var NavigationPoint MyMarker;
var float MaxZVelocity;
var float StayOpenTime;
var SoundCue OpenSound;
var SoundCue OpeningAmbientSound;
var SoundCue OpenedSound;
var SoundCue CloseSound;
var SoundCue ClosingAmbientSound;
var SoundCue ClosedSound;
var export editinline AudioComponent AmbientSoundComponent;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	// End:0x33
	if(bShouldShadowParentAllAttachedActors)
	{
		SetShadowParentOnAllAttachedComponents(StaticMeshComponent, LightEnvironment);
	}
	// End:0x7E
	if((OpeningAmbientSound != none) || ClosingAmbientSound != none)
	{
		AmbientSoundComponent = new (self) Class'Engine.AudioComponent';
		AttachComponent(AmbientSoundComponent);
	}
	// End:0xD2
	if((Base != none) && bHardAttach || (BaseSkelComponent != none) && BaseBoneName != 'None')
	{
		bShouldSaveForCheckpoint = false;
	}
	//return;	
}

event bool EncroachingOn(Actor Other)
{
	local int I;
	local SeqEvent_Mover MoverEvent;
	local Pawn P;
	local Vector Height, HitLocation, HitNormal;
	local bool bLandingPawn;

	// End:0x3A
	if(bContinueOnEncroachPhysicsObject && int(Other.Physics) == int(10))
	{
		return false;
	}
	// End:0x76
	if(Other.bDestroyedByInterpActor)
	{
		Other.Destroy();
		return false;
	}
	// End:0x4F2
	if((Other.Base == self) || (Normal(Velocity) Dot Normal(Other.Location - Location)) >= 0.0000000)
	{
		P = Pawn(Other);
		// End:0x3C3
		if(P != none)
		{
			// End:0x2BA
			if((int(P.Physics) == int(2)) && Velocity.Z > 0.0000000)
			{
				Height = P.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000);
				// End:0x2B7
				if(TraceComponent(HitLocation, HitNormal, StaticMeshComponent, P.Location - Height, P.Location + Height, P.GetCollisionExtent()))
				{
					// End:0x2AB
					if(P.Location.Z < Location.Z)
					{
						P.SetLocation(HitLocation + Height);
					}
					bLandingPawn = true;
				}				
			}
			else
			{
				// End:0x3C0
				if((((P.Base != self) && P.Controller != none) && P.Controller.PendingMover != none) && P.Controller.PendingMover == self)
				{
					P.Controller.UnderLift(LiftCenter(MyMarker));
				}
			}			
		}
		else
		{
			// End:0x44A
			if(bDestroyProjectilesOnEncroach && Other.IsA('Projectile'))
			{
				Projectile(Other).Explode(Other.Location, Normal(Velocity)-);
				return false;
			}
		}
		// End:0x4F2
		if(bLandingPawn!)
		{
			I = 0;
			J0x464:

			// End:0x4E7 [Loop If]
			if(I < GeneratedEvents.Length)
			{
				MoverEvent = SeqEvent_Mover(GeneratedEvents[I]);
				// End:0x4D9
				if(MoverEvent != none)
				{
					MoverEvent.NotifyEncroachingOn(Other);
				}
				I++;
				// [Loop Continue]
				goto J0x464;
			}
			return bStopOnEncroach;
		}
	}
	return false;
	//return ReturnValue;	
}

event RanInto(Actor Other)
{
	local int I;
	local SeqEvent_Mover MoverEvent;

	// End:0x88
	if(bDestroyProjectilesOnEncroach && Other.IsA('Projectile'))
	{
		Projectile(Other).Explode(Other.Location, Normal(Velocity)-);		
	}
	else
	{
		// End:0xC5
		if(Other.bDestroyedByInterpActor)
		{
			Other.Destroy();			
		}
		else
		{
			// End:0xD7
			if(bIsLift)
			{
				return;				
			}
			else
			{
				I = 0;
				J0xE2:

				// End:0x165 [Loop If]
				if(I < GeneratedEvents.Length)
				{
					MoverEvent = SeqEvent_Mover(GeneratedEvents[I]);
					// End:0x157
					if(MoverEvent != none)
					{
						MoverEvent.NotifyEncroachingOn(Other);
					}
					I++;
					// [Loop Continue]
					goto J0xE2;
				}
			}
		}
	}
	//return;	
}

event Attach(Actor Other)
{
	local int I;
	local SeqEvent_Mover MoverEvent;

	// End:0xA7
	if(IsTimerActive('FinishedOpen')!)
	{
		I = 0;
		J0x24:

		// End:0xA7 [Loop If]
		if(I < GeneratedEvents.Length)
		{
			MoverEvent = SeqEvent_Mover(GeneratedEvents[I]);
			// End:0x99
			if(MoverEvent != none)
			{
				MoverEvent.NotifyAttached(Other);
			}
			I++;
			// [Loop Continue]
			goto J0x24;
		}
	}
	//return;	
}

event Detach(Actor Other)
{
	local int I;
	local SeqEvent_Mover MoverEvent;

	I = 0;
	J0x0B:

	// End:0x8E [Loop If]
	if(I < GeneratedEvents.Length)
	{
		MoverEvent = SeqEvent_Mover(GeneratedEvents[I]);
		// End:0x80
		if(MoverEvent != none)
		{
			MoverEvent.NotifyDetached(Other);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function Restart()
{
	local Actor A;

	// End:0x2C
	foreach BasedActors(Class'Engine.Actor', A)
	{
		Attach(A);		
	}	
	//return;	
}

function FinishedOpen()
{
	local int I;
	local SeqEvent_Mover MoverEvent;

	I = 0;
	J0x0B:

	// End:0x85 [Loop If]
	if(I < GeneratedEvents.Length)
	{
		MoverEvent = SeqEvent_Mover(GeneratedEvents[I]);
		// End:0x77
		if(MoverEvent != none)
		{
			MoverEvent.NotifyFinishedOpen();
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

simulated function PlayMovingSound(bool bClosing)
{
	local SoundCue SoundToPlay, AmbientToPlay;

	// End:0x36
	if(bClosing)
	{
		SoundToPlay = CloseSound;
		AmbientToPlay = OpeningAmbientSound;		
	}
	else
	{
		SoundToPlay = OpenSound;
		AmbientToPlay = ClosingAmbientSound;
	}
	// End:0x84
	if(SoundToPlay != none)
	{
		PlaySound(SoundToPlay, true);
	}
	// End:0xF9
	if(AmbientToPlay != none)
	{
		AmbientSoundComponent.Stop();
		AmbientSoundComponent.SoundCue = AmbientToPlay;
		AmbientSoundComponent.Play();
	}
	//return;	
}

simulated event InterpolationStarted(SeqAct_Interp InterpAction, InterpGroupInst GroupInst)
{
	ClearTimer('Restart');
	ClearTimer('FinishedOpen');
	PlayMovingSound(InterpAction.bReversePlayback);
	bShouldSaveForCheckpoint = true;
	//return;	
}

simulated event InterpolationFinished(SeqAct_Interp InterpAction)
{
	local DoorMarker DoorNav;
	local Controller C;
	local SoundCue StoppedSound;

	// End:0x2E
	if(AmbientSoundComponent != none)
	{
		AmbientSoundComponent.Stop();
	}
	StoppedSound = ((InterpAction.bReversePlayback) ? ClosedSound : OpenedSound);
	// End:0x96
	if(StoppedSound != none)
	{
		PlaySound(StoppedSound, true);
	}
	DoorNav = DoorMarker(MyMarker);
	// End:0x12C
	if(InterpAction.bReversePlayback)
	{
		// End:0xFB
		if(Attached.Length > 0)
		{
			SetTimer(StayOpenTime, false, 'Restart');
		}
		// End:0x129
		if(DoorNav != none)
		{
			DoorNav.MoverClosed();
		}		
	}
	else
	{
		SetTimer(StayOpenTime, false, 'FinishedOpen');
		// End:0x171
		if(DoorNav != none)
		{
			DoorNav.MoverOpened();
		}
	}
	// End:0x1F7
	if(bMonitorMover)
	{
		// End:0x1F6
		foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
		{
			// End:0x1F5
			if(C.PendingMover == self)
			{
				C.MoverFinished();
			}			
		}		
	}
	// End:0x25F
	if(InterpAction.bNoResetOnRewind && InterpAction.bRewindOnPlay)
	{
		ForceNetRelevant();
		bUpdateSimulatedPosition = true;
		bReplicateMovement = true;
	}
	//return;	
}

simulated event InterpolationChanged(SeqAct_Interp InterpAction)
{
	PlayMovingSound(InterpAction.bReversePlayback);
	//return;	
}

simulated function ShutDown()
{
	super(Actor).ShutDown();
	bShouldSaveForCheckpoint = true;
	//return;	
}

function bool ShouldSaveForCheckpoint()
{
	return bShouldSaveForCheckpoint || int(RemoteRole) == int(ROLE_SimulatedProxy);
	//return ReturnValue;	
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
	Record.Location = Location;
	Record.Rotation = Rotation;
	Record.bHidden = bHidden;
	Record.CollisionType = ReplicatedCollisionType;
	Record.bNeedsPositionReplication = (int(RemoteRole) == int(ROLE_SimulatedProxy)) && bUpdateSimulatedPosition;
	Record.bIsShutdown = (int(Physics) == int(0)) && bHidden;
	//return;	
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
	local Actor OldBase;
	local editinline SkeletalMeshComponent OldBaseComp;
	local name OldBaseBoneName;
	local array<Actor> OldAttached;
	local array<Vector> OldLocations;
	local int I;

	// End:0x2D
	if(Record.bIsShutdown)
	{
		ShutDown();		
	}
	else
	{
		OldAttached = Attached;
		J0x40:

		// End:0x101 [Loop If]
		if(I < OldAttached.Length)
		{
			// End:0xE9
			if((OldAttached[I] != none) && OldAttached[I].bJustTeleported)
			{
				OldLocations[I] = OldAttached[I].Location;
				I++;				
			}
			else
			{
				OldAttached.Remove(I, 1);
			}
			// [Loop Continue]
			goto J0x40;
		}
		OldBase = Base;
		OldBaseComp = BaseSkelComponent;
		OldBaseBoneName = BaseBoneName;
		SetLocation(Record.Location);
		SetRotation(Record.Rotation);
		SetBase(OldBase,, OldBaseComp, OldBaseBoneName);
		I = 0;
		J0x1A2:

		// End:0x23C [Loop If]
		if(I < OldAttached.Length)
		{
			// End:0x22E
			if(OldAttached[I] != none)
			{
				OldAttached[I].SetLocation(OldLocations[I]);
				OldAttached[I].SetBase(self);
			}
			I++;
			// [Loop Continue]
			goto J0x1A2;
		}
		// End:0x29A
		if(int(Record.CollisionType) != int(ReplicatedCollisionType))
		{
			SetCollisionType(Record.CollisionType);
			ForceNetRelevant();
		}
		// End:0x320
		if(Record.bHidden != bHidden)
		{
			SetHidden(Record.bHidden);
			SetForcedInitialReplicatedProperty(BoolProperty'Engine.Actor.bHidden', bHidden == default.bHidden);
			ForceNetRelevant();
		}
		// End:0x362
		if(Record.bNeedsPositionReplication)
		{
			bUpdateSimulatedPosition = true;
			bReplicateMovement = true;
			ForceNetRelevant();
		}
	}
	bShouldSaveForCheckpoint = true;
	//return;	
}

defaultproperties
{
	bShouldSaveForCheckpoint=true
	bDestroyProjectilesOnEncroach=true
	bContinueOnEncroachPhysicsObject=true
	bStopOnEncroach=true
	bShouldShadowParentAllAttachedActors=true
	// Reference: StaticMeshComponent'Engine.Default__InterpActor.StaticMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'StaticMeshComponent0'
	// Archetype: StaticMeshComponent'Engine.Default__DynamicSMActor.StaticMeshComponent0'
	begin object name="StaticMeshComponent0"
		WireframeColor=(R=0,G=255,B=255,A=255)
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'Engine.Default__InterpActor.MyLightEnvironment'
		RBCollideWithChannels=(Default=true,BlockingVolume=true)
	end object
	StaticMeshComponent=StaticMeshComponent0
	// Reference: DynamicLightEnvironmentComponent'Engine.Default__InterpActor.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'Engine.Default__DynamicSMActor.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	Components[0]=MyLightEnvironment
	Components[1]=StaticMeshComponent0
	Physics=EPhysics.PHYS_Interpolating
	RemoteRole=ENetRole.ROLE_None
	CollisionType=ECollisionType.COLLIDE_CustomDefault
	bNoDelete=true
	bAlwaysRelevant=true
	bOnlyDirtyReplication=true
	bBlocksTeleport=true
	NetUpdateFrequency=1.0000000
	NetPriority=2.7000000
	CollisionComponent=StaticMeshComponent0
	SupportedEvents[0]=Class'Engine.SeqEvent_Touch'
	SupportedEvents[1]=Class'Engine.SeqEvent_Destroyed'
	SupportedEvents[2]=Class'Engine.SeqEvent_TakeDamage'
	SupportedEvents[3]=Class'Engine.SeqEvent_HitWall'
	SupportedEvents[4]=Class'Engine.SeqEvent_AnimNotify'
	SupportedEvents[5]=Class'Engine.SeqEvent_MobileTouch'
	SupportedEvents[6]=Class'Engine.SeqEvent_Mover'
}