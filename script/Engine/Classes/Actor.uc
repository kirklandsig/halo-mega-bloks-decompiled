class Actor extends Object
	abstract
	native
	nativereplication;

const TRACEFLAG_Bullet = 1;
const TRACEFLAG_PhysicsVolumes = 2;
const TRACEFLAG_SkipMovers = 4;
const TRACEFLAG_Blocking = 8;
const TRACEFLAG_ForceController = 16;
const REP_RBLOCATION_ERROR_TOLERANCE_SQ = 16.0f;
const MINFLOORZ = 0.7;
const ACTORMAXSTEPHEIGHT = 35.0;
const RBSTATE_LINVELSCALE = 10.0;
const RBSTATE_ANGVELSCALE = 1000.0;
const RB_None = 0x00;
const RB_NeedsUpdate = 0x01;
const RB_Sleeping = 0x02;

enum EPhysics
{
	PHYS_None,                      // 0
	PHYS_Walking,                   // 1
	PHYS_Falling,                   // 2
	PHYS_Swimming,                  // 3
	PHYS_Flying,                    // 4
	PHYS_Rotating,                  // 5
	PHYS_Projectile,                // 6
	PHYS_Interpolating,             // 7
	PHYS_Spider,                    // 8
	PHYS_Ladder,                    // 9
	PHYS_RigidBody,                 // 10
	PHYS_SoftBody,                  // 11
	PHYS_NavMeshWalking,            // 12
	PHYS_Unused,                    // 13
	PHYS_Custom,                    // 14
	PHYS_MAX                        // 15
};

enum EMoveDir
{
	MD_Stationary,                  // 0
	MD_Forward,                     // 1
	MD_Backward,                    // 2
	MD_Left,                        // 3
	MD_Right,                       // 4
	MD_Up,                          // 5
	MD_Down,                        // 6
	MD_MAX                          // 7
};

enum EActorMetricsType
{
	METRICS_VERTS,                  // 0
	METRICS_TRIS,                   // 1
	METRICS_SECTIONS,               // 2
	METRICS_MAX                     // 3
};

enum ENetRole
{
	ROLE_None,                      // 0
	ROLE_SimulatedProxy,            // 1
	ROLE_AutonomousProxy,           // 2
	ROLE_Authority,                 // 3
	ROLE_MAX                        // 4
};

enum ECollisionType
{
	COLLIDE_CustomDefault,          // 0
	COLLIDE_NoCollision,            // 1
	COLLIDE_BlockAll,               // 2
	COLLIDE_BlockWeapons,           // 3
	COLLIDE_TouchAll,               // 4
	COLLIDE_TouchWeapons,           // 5
	COLLIDE_BlockAllButWeapons,     // 6
	COLLIDE_TouchAllButWeapons,     // 7
	COLLIDE_BlockWeaponsKickable,   // 8
	COLLIDE_MAX                     // 9
};

enum ETravelType
{
	TRAVEL_Absolute,                // 0
	TRAVEL_Partial,                 // 1
	TRAVEL_Relative,                // 2
	TRAVEL_MAX                      // 3
};

enum EDoubleClickDir
{
	DCLICK_None,                    // 0
	DCLICK_Left,                    // 1
	DCLICK_Right,                   // 2
	DCLICK_Forward,                 // 3
	DCLICK_Back,                    // 4
	DCLICK_Active,                  // 5
	DCLICK_Done,                    // 6
	DCLICK_MAX                      // 7
};

struct native TimerData
{
	var bool bLoop;
	var bool bPaused;
	var name FuncName;
	var float Rate;
	var float Count;
	var float TimerTimeDilation;
	var Object TimerObj;

	structdefaultproperties
	{
		bLoop=false
		bPaused=false
		FuncName="None"
		Rate=0.0000000
		Count=0.0000000
		TimerTimeDilation=1.0000000
		TimerObj=none
	}
};

struct native transient TraceHitInfo
{
	var init Material Material;
	var init PhysicalMaterial PhysMaterial;
	var init int Item;
	var init int LevelIndex;
	var init name BoneName;
	var init export editinline PrimitiveComponent HitComponent;

	structdefaultproperties
	{
		Material=none
		PhysMaterial=none
		Item=0
		LevelIndex=0
		BoneName="None"
		HitComponent=none
	}
};

struct native transient ImpactInfo
{
	var init Actor HitActor;
	var init Vector HitLocation;
	var init Vector HitNormal;
	var init Vector RayDir;
	var init Vector StartTrace;
	var init TraceHitInfo HitInfo;

	structdefaultproperties
	{
		HitActor=none
		HitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		HitNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		RayDir=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		StartTrace=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		HitInfo=(Material=none,PhysMaterial=none,Item=0,LevelIndex=0,BoneName="None",HitComponent=none)
	}
};

struct native transient AnimSlotInfo
{
	var init name SlotName;
	var init array<float> ChannelWeights;

	structdefaultproperties
	{
		SlotName="None"
		ChannelWeights=none
	}
};

struct native transient AnimSlotDesc
{
	var init name SlotName;
	var init int NumChannels;

	structdefaultproperties
	{
		SlotName="None"
		NumChannels=0
	}
};

struct RigidBodyState
{
	var Vector Position;
	var Quat Quaternion;
	var Vector LinVel;
	var Vector AngVel;
	var byte bNewData;

	structdefaultproperties
	{
		Position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		Quaternion=(X=0.0000000,Y=0.0000000,Z=0.0000000,W=0.0000000)
		LinVel=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		AngVel=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		bNewData=0
	}
};

struct RigidBodyContactInfo
{
	var Vector ContactPosition;
	var Vector ContactNormal;
	var float ContactPenetration;
	var Vector ContactVelocity[2];
	var PhysicalMaterial PhysMaterial[2];

	structdefaultproperties
	{
		ContactPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		ContactNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		ContactPenetration=0.0000000
		ContactVelocity[0]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		ContactVelocity[1]=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		PhysMaterial[0]=none
		PhysMaterial[1]=none
	}
};

struct CollisionImpactData
{
	var array<RigidBodyContactInfo> ContactInfos;
	var Vector TotalNormalForceVector;
	var Vector TotalFrictionForceVector;

	structdefaultproperties
	{
		ContactInfos=none
		TotalNormalForceVector=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		TotalFrictionForceVector=(X=0.0000000,Y=0.0000000,Z=0.0000000)
	}
};

struct native PhysEffectInfo
{
	var float Threshold;
	var float ReFireDelay;
	var ParticleSystem Effect;
	var SoundCue Sound;

	structdefaultproperties
	{
		Threshold=0.0000000
		ReFireDelay=0.0000000
		Effect=none
		Sound=none
	}
};

struct native atomicwhencooked immutablewhencooked ActorReference
{
	var Actor Actor;
	var const editconst Guid Guid;

	structdefaultproperties
	{
		Actor=none
		Guid=(A=0,B=0,C=0,D=0)
	}
};

struct native atomicwhencooked immutablewhencooked NavReference
{
	var NavigationPoint Nav;
	var const editconst Guid Guid;

	structdefaultproperties
	{
		Nav=none
		Guid=(A=0,B=0,C=0,D=0)
	}
};

struct native BasedPosition
{
	var Actor Base;
	var Vector Position;
	var Vector CachedBaseLocation;
	var Rotator CachedBaseRotation;
	var Vector CachedTransPosition;

	structdefaultproperties
	{
		Base=none
		Position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		CachedBaseLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		CachedBaseRotation=(Pitch=0,Yaw=0,Roll=0)
		CachedTransPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
	}
};

var const Actor Next_Actor;
var const Actor Next_Reactive;
var const Actor Next_Vehicle;
var const Actor Next_Target_Actor;
var private const export editinline array<export editinline ActorComponent> Components;
var private const export editinline transient array<export editinline ActorComponent> AllComponents;
var const Vector Location;
var const Rotator Rotation;
var repnotify interp const float DrawScale;
var interp const Vector DrawScale3D;
var const Vector PrePivot;
var private native const RenderCommandFence DetachFence;
var float CustomTimeDilation;
var const Actor.EPhysics Physics;
var Actor.ENetRole RemoteRole;
var Actor.ENetRole Role;
var const transient Actor.ECollisionType CollisionType;
var transient Actor.ECollisionType ReplicatedCollisionType;
var const Object.ETickingGroup TickGroup;
var const Actor Owner;
var const Actor Base;
var const array<TimerData> Timers;
var const bool bStatic;
var const bool bHidden;
var const bool bNoDelete;
var const bool bDeleteMe;
var const transient bool bTicked;
var const bool bOnlyOwnerSee;
var const bool bTickIsDisabled;
var bool bWorldGeometry;
var bool bIgnoreRigidBodyPawns;
var bool bOrientOnSlope;
var const bool bIgnoreEncroachers;
var bool bPushedByEncroachers;
var bool bDestroyedByInterpActor;
var const bool bRouteBeginPlayEvenIfStatic;
var const bool bIsMoving;
var bool bAlwaysEncroachCheck;
var bool bHasAlternateTargetLocation;
var bool bCanStepUpOn;
var const bool bNetTemporary;
var const bool bOnlyRelevantToOwner;
var transient bool bNetDirty;
var bool bAlwaysRelevant;
var bool bReplicateInstigator;
var bool bReplicateMovement;
var bool bSkipActorPropertyReplication;
var bool bUpdateSimulatedPosition;
var bool bTearOff;
var bool bOnlyDirtyReplication;
var bool bAllowFluidSurfaceInteraction;
var transient bool bDemoRecording;
var bool bDemoOwner;
var bool bForceDemoRelevant;
var const bool bNetInitialRotation;
var bool bReplicateRigidBodyLocation;
var bool bKillDuringLevelTransition;
var const bool bExchangedRoles;
var bool bConsiderAllStaticMeshComponentsForStreaming;
var bool bDebug;
var bool bPostRenderIfNotVisible;
var transient bool bForceNetUpdate;
var const transient bool bPendingNetUpdate;
var const bool bHardAttach;
var bool bIgnoreBaseRotation;
var bool bShadowParented;
var bool bSkipAttachedMoves;
var bool bCanBeAdheredTo;
var bool bCanBeFrictionedTo;
var bool bHurtEntry;
var bool bGameRelevant;
var const bool bMovable;
var bool bDestroyInPainVolume;
var bool bCanBeDamaged;
var bool bShouldBaseAtStartup;
var bool bPendingDelete;
var bool bCanTeleport;
var const bool bAlwaysTick;
var bool bBlocksNavigation;
var const transient bool BlockRigidBody;
var bool bCollideWhenPlacing;
var const bool bCollideActors;
var bool bCollideWorld;
var bool bCollideComplex;
var bool bBlockActors;
var bool bProjTarget;
var bool bBlocksTeleport;
var bool bMoveIgnoresDestruction;
var bool bProjectileMoveSingleBlocking;
var bool bNoEncroachCheck;
var bool bCollideAsEncroacher;
var bool bPhysRigidBodyOutOfWorldCheck;
var const transient bool bComponentOutsideWorld;
var bool bForceOctreeSNFilter;
var bool bForceOctreeMNFilter;
var const transient bool bRigidBodyWasAwake;
var bool bCallRigidBodyWakeEvents;
var bool bBounce;
var const bool bJustTeleported;
var bool bEnableMobileTouch;
var const bool bNetInitial;
var const bool bNetOwner;
var const bool bHiddenEd;
var const bool bEditable;
var const deprecated bool bHiddenEdGroup;
var const bool bHiddenEdLayer;
var const bool bHiddenEdCustom;
var editoronly transient bool bHiddenEdTemporary;
var editoronly transient bool bHiddenEdLevel;
var editoronly transient bool bHiddenEdScene;
var bool bEdShouldSnap;
var const transient bool bTempEditor;
var bool bPathColliding;
var transient bool bPathTemp;
var bool bScriptInitialized;
var bool bLockLocation;
var const bool bForceAllowKismetModification;
var bool bDebugEffectIsRelevant;
var const transient int NetTag;
var const float NetUpdateTime;
var float NetUpdateFrequency;
var float NetPriority;
var const transient float LastNetUpdateTime;
var float TimeSinceLastTick;
var Pawn Instigator;
var const transient WorldInfo WorldInfo;
var float LifeSpan;
var const float CreationTime;
var transient float LastRenderTime;
var name Tag;
var name InitialState;
var name Layer;
var deprecated name Group;
var transient QWord HiddenEditorViews;
var const transient array<Actor> Touching;
var const transient array<Actor> Children;
var const float LatentFloat;
var const AnimNodeSequence LatentSeqNode;
var const transient PhysicsVolume PhysicsVolume;
var Vector Velocity;
var Vector Acceleration;
var const transient Vector AngularVelocity;
var export editinline SkeletalMeshComponent BaseSkelComponent;
var name BaseBoneName;
var const array<Actor> Attached;
var const Vector RelativeLocation;
var const Rotator RelativeRotation;
var editconst export editinline PrimitiveComponent CollisionComponent;
var native int OverlapTag;
var Rotator RotationRate;
var Actor PendingTouch;
var Class<LocalMessage> MessageClass;
var const array< Class<SequenceEvent> > SupportedEvents;
var const array<SequenceEvent> GeneratedEvents;
var array<SeqAct_Latent> LatentActions;

replication
{
	// Pos:0x000
	if(((!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement) && ((int(RemoteRole) == int(ROLE_AutonomousProxy)) && bNetInitial) || ((int(RemoteRole) == int(ROLE_SimulatedProxy)) && bNetInitial || bUpdateSimulatedPosition) && (Base == none) || Base.bWorldGeometry)
		Location, Rotation;

	// Pos:0x0B8
	if(((!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement) && int(RemoteRole) == int(ROLE_SimulatedProxy))
		Base;

	// Pos:0x0F8
	if((((((!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement) && bNetInitial || bUpdateSimulatedPosition) && int(RemoteRole) == int(ROLE_SimulatedProxy)) && Base != none) && !Base.bWorldGeometry)
		RelativeLocation, RelativeRotation;

	// Pos:0x18D
	if(((!bSkipActorPropertyReplication || bNetInitial) && bReplicateMovement) && (int(RemoteRole) == int(ROLE_SimulatedProxy)) && bNetInitial || bUpdateSimulatedPosition)
		Physics, Velocity;

	// Pos:0x1EB
	if((!bSkipActorPropertyReplication || bNetInitial) && int(Role) == int(ROLE_Authority))
		bHardAttach;

	// Pos:0x21C
	if(((!bSkipActorPropertyReplication || bNetInitial) && int(Role) == int(ROLE_Authority)) && bNetDirty)
		bHidden;

	// Pos:0x25C
	if((((!bSkipActorPropertyReplication || bNetInitial) && int(Role) == int(ROLE_Authority)) && bNetDirty) && bCollideActors || bCollideWorld)
		bBlockActors, bProjTarget;

	// Pos:0x2BA
	if((!bSkipActorPropertyReplication || bNetInitial) && int(Role) == int(ROLE_Authority))
		RemoteRole, Role, 
		bNetOwner, bTearOff;

	// Pos:0x2EB
	if((((!bSkipActorPropertyReplication || bNetInitial) && int(Role) == int(ROLE_Authority)) && bNetDirty) && bReplicateInstigator)
		Instigator;

	// Pos:0x33A
	if(((!bSkipActorPropertyReplication || bNetInitial) && int(Role) == int(ROLE_Authority)) && bNetDirty)
		DrawScale, ReplicatedCollisionType, 
		bCollideActors, bCollideWorld;

	// Pos:0x37A
	if(((bNetOwner && !bSkipActorPropertyReplication || bNetInitial) && int(Role) == int(ROLE_Authority)) && bNetDirty)
		Owner;
}

// Export UActor::execForceUpdateComponents(FFrame&, void* const)
native function ForceUpdateComponents(optional bool bCollisionUpdate = false, optional bool bTransformOnly = true);

// Export UActor::execConsoleCommand(FFrame&, void* const)
native function string ConsoleCommand(string Command, optional bool bWriteToLog = true);

// Export UActor::execSleep(FFrame&, void* const)
native(256) final latent function Sleep(float Seconds);

// Export UActor::execFinishAnim(FFrame&, void* const)
native(261) final latent function FinishAnim(AnimNodeSequence SeqNode, optional bool bFinishOnBlendOut);

// Export UActor::execSetCollision(FFrame&, void* const)
native(262) final function SetCollision(optional bool bNewColActors, optional bool bNewBlockActors, optional bool bNewIgnoreEncroachers);

// Export UActor::execSetCollisionSize(FFrame&, void* const)
native(283) final function SetCollisionSize(float NewRadius, float NewHeight);

// Export UActor::execSetCollisionType(FFrame&, void* const)
native final function SetCollisionType(Actor.ECollisionType NewCollisionType);

// Export UActor::execSetDrawScale(FFrame&, void* const)
native final function SetDrawScale(float NewScale);

// Export UActor::execSetDrawScale3D(FFrame&, void* const)
native final function SetDrawScale3D(Vector NewScale3D);

// Export UActor::execMove(FFrame&, void* const)
native(266) final function bool Move(Vector Delta);

// Export UActor::execSetLocation(FFrame&, void* const)
native(267) final function bool SetLocation(Vector NewLocation);

// Export UActor::execSetRotation(FFrame&, void* const)
native(299) final function bool SetRotation(Rotator NewRotation);

// Export UActor::execMovingWhichWay(FFrame&, void* const)
native function Actor.EMoveDir MovingWhichWay(out float Amount);

// Export UActor::execSetZone(FFrame&, void* const)
native final function SetZone(bool bForceRefresh);

// Export UActor::execSetRelativeRotation(FFrame&, void* const)
native final function bool SetRelativeRotation(Rotator NewRotation);

// Export UActor::execSetRelativeLocation(FFrame&, void* const)
native final function bool SetRelativeLocation(Vector NewLocation);

// Export UActor::execSetHardAttach(FFrame&, void* const)
native final function SetHardAttach(optional bool bNewHardAttach);

// Export UActor::execSetShadowParentOnAllAttachedComponents(FFrame&, void* const)
native simulated function SetShadowParentOnAllAttachedComponents(PrimitiveComponent MyPrimComp, LightEnvironmentComponent MyLightEnv);

// Export UActor::execfixedTurn(FFrame&, void* const)
native final function int fixedTurn(int Current, int Desired, int DeltaRate);

// Export UActor::execMoveSmooth(FFrame&, void* const)
native(3969) final function bool MoveSmooth(Vector Delta);

// Export UActor::execAutonomousPhysics(FFrame&, void* const)
native(3971) final function AutonomousPhysics(float DeltaSeconds);

// Export UActor::execGetTerminalVelocity(FFrame&, void* const)
native function float GetTerminalVelocity();

// Export UActor::execSetBase(FFrame&, void* const)
native(298) final function SetBase(Actor NewBase, optional Vector NewFloor, optional SkeletalMeshComponent SkelComp, optional name AttachName);

// Export UActor::execSetOwner(FFrame&, void* const)
native(272) final function SetOwner(Actor NewOwner);

// Export UActor::execFindBase(FFrame&, void* const)
native function FindBase();

// Export UActor::execSearchForBaseBelow(FFrame&, void* const)
native function SearchForBaseBelow(float HeightBelow, out Actor NewBase, out Vector HitNormal);

// Export UActor::execIsBasedOn(FFrame&, void* const)
native final function bool IsBasedOn(Actor TestActor);

// Export UActor::execGetBaseMost(FFrame&, void* const)
native function Actor GetBaseMost();

// Export UActor::execIsOwnedBy(FFrame&, void* const)
native final function bool IsOwnedBy(Actor TestActor);

// Export UActor::execGetAggregateBaseVelocity(FFrame&, void* const)
native final function Vector GetAggregateBaseVelocity(optional Actor TestBase);

simulated event ReplicatedEvent(name VarName)
{
	//return;	
}

// Export UActor::execSetForcedInitialReplicatedProperty(FFrame&, void* const)
native final function SetForcedInitialReplicatedProperty(Property PropToReplicate, bool bAdd);

// Export UActor::execVect2BP(FFrame&, void* const)
native static final function Vect2BP(out BasedPosition BP, Vector pos, optional Actor ForcedBase);

// Export UActor::execBP2Vect(FFrame&, void* const)
native static final function Vector BP2Vect(BasedPosition BP);

// Export UActor::execSetBasedPosition(FFrame&, void* const)
native static final function SetBasedPosition(out BasedPosition BP, Vector pos, optional Actor ForcedBase);

// Export UActor::execGetBasedPosition(FFrame&, void* const)
native static final function Vector GetBasedPosition(BasedPosition BP);

// Export UActor::execFlushPersistentDebugLines(FFrame&, void* const)
native static final function FlushPersistentDebugLines();

// Export UActor::execDrawDebugLine(FFrame&, void* const)
native static final function DrawDebugLine(Vector LineStart, Vector LineEnd, byte R, byte G, byte B, optional bool bPersistentLines);

// Export UActor::execDrawDebugPoint(FFrame&, void* const)
native static final function DrawDebugPoint(Vector Position, float Size, LinearColor PointColor, optional bool bPersistentLines);

// Export UActor::execDrawDebugBox(FFrame&, void* const)
native static final function DrawDebugBox(Vector Center, Vector Extent, byte R, byte G, byte B, optional bool bPersistentLines);

// Export UActor::execDrawDebugStar(FFrame&, void* const)
native static final function DrawDebugStar(Vector Position, float Size, byte R, byte G, byte B, optional bool bPersistentLines);

// Export UActor::execDrawDebugCoordinateSystem(FFrame&, void* const)
native static final function DrawDebugCoordinateSystem(Vector AxisLoc, Rotator AxisRot, float Scale, optional bool bPersistentLines);

// Export UActor::execDrawDebugSphere(FFrame&, void* const)
native static final function DrawDebugSphere(Vector Center, float Radius, int Segments, byte R, byte G, byte B, optional bool bPersistentLines);

// Export UActor::execDrawDebugCylinder(FFrame&, void* const)
native static final function DrawDebugCylinder(Vector Start, Vector End, float Radius, int Segments, byte R, byte G, byte B, optional bool bPersistentLines);

// Export UActor::execDrawDebugCone(FFrame&, void* const)
native static final function DrawDebugCone(Vector Origin, Vector Direction, float Length, float AngleWidth, float AngleHeight, int NumSides, Color DrawColor, optional bool bPersistentLines);

// Export UActor::execDrawDebugString(FFrame&, void* const)
native static final function DrawDebugString(Vector TextLocation, coerce string Text, optional Actor TestBaseActor, optional Color TextColor, optional float Duration = -1.0000000);

// Export UActor::execDrawDebugFrustrum(FFrame&, void* const)
native static final function DrawDebugFrustrum(const out Matrix FrustumToWorld, byte R, byte G, byte B, optional bool bPersistentLines);

// Export UActor::execFlushDebugStrings(FFrame&, void* const)
native static final exec function FlushDebugStrings();

// Export UActor::execChartData(FFrame&, void* const)
native final function ChartData(string DataName, float DataValue);

// Export UActor::execSetHidden(FFrame&, void* const)
native final function SetHidden(bool bNewHidden);

// Export UActor::execSetOnlyOwnerSee(FFrame&, void* const)
native final function SetOnlyOwnerSee(bool bNewOnlyOwnerSee);

// Export UActor::execSetPhysics(FFrame&, void* const)
native(3970) final function SetPhysics(Actor.EPhysics newPhysics);

// Export UActor::execClock(FFrame&, void* const)
native final function Clock(out float Time);

// Export UActor::execUnClock(FFrame&, void* const)
native final function UnClock(out float Time);

// Export UActor::execAttachComponent(FFrame&, void* const)
native final function AttachComponent(ActorComponent NewComponent);

// Export UActor::execDetachComponent(FFrame&, void* const)
native final function DetachComponent(ActorComponent ExComponent);

// Export UActor::execReattachComponent(FFrame&, void* const)
native final function ReattachComponent(ActorComponent ComponentToReattach);

// Export UActor::execSetTickGroup(FFrame&, void* const)
native final function SetTickGroup(Object.ETickingGroup NewTickGroup);

// Export UActor::execSetTickIsDisabled(FFrame&, void* const)
native final function SetTickIsDisabled(bool bInDisabled);

event Destroyed()
{
	//return;	
}

event GainedChild(Actor Other)
{
	//return;	
}

event LostChild(Actor Other)
{
	//return;	
}

event Tick(float DeltaTime)
{
	//return;	
}

event Timer()
{
	//return;	
}

event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	TriggerEventClass(Class'Engine.SeqEvent_HitWall', Wall);
	//return;	
}

event Falling()
{
	//return;	
}

event Landed(Vector HitNormal, Actor FloorActor)
{
	//return;	
}

event PhysicsVolumeChange(PhysicsVolume NewVolume)
{
	//return;	
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	//return;	
}

event PostTouch(Actor Other)
{
	//return;	
}

event UnTouch(Actor Other)
{
	//return;	
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
	//return;	
}

event BaseChange()
{
	//return;	
}

event Attach(Actor Other)
{
	//return;	
}

event Detach(Actor Other)
{
	//return;	
}

event Actor SpecialHandling(Pawn Other)
{
	//return ReturnValue;	
}

event CollisionChanged()
{
	//return;	
}

event bool EncroachingOn(Actor Other)
{
	//return ReturnValue;	
}

event EncroachedBy(Actor Other)
{
	//return;	
}

event RanInto(Actor Other)
{
	//return;	
}

event OnWakeRBPhysics()
{
	//return;	
}

event OnSleepRBPhysics()
{
	//return;	
}

// Export UActor::execClampRotation(FFrame&, void* const)
native final simulated function bool ClampRotation(out Rotator out_Rot, Rotator rBase, Rotator rUpperLimits, Rotator rLowerLimits);

simulated event bool OverRotated(out Rotator out_Desired, out Rotator out_Actual)
{
	//return ReturnValue;	
}

function bool UsedBy(Pawn User)
{
	return TriggerEventClass(Class'Engine.SeqEvent_Used', User, -1);
	//return ReturnValue;	
}

simulated event FellOutOfWorld(Class<DamageType> dmgType)
{
	SetPhysics(0);
	SetHidden(true);
	SetCollision(false, false);
	Destroy();
	//return;	
}

simulated event OutsideWorldBounds()
{
	Destroy();
	//return;	
}

simulated function VolumeBasedDestroy(PhysicsVolume PV)
{
	Destroy();
	//return;	
}

// Export UActor::execTrace(FFrame&, void* const)
native(277) final function Actor Trace(out Vector HitLocation, out Vector HitNormal, Vector TraceEnd, optional Vector TraceStart, optional bool bTraceActors, optional Vector Extent, optional out TraceHitInfo HitInfo, optional int ExtraTraceFlags);

// Export UActor::execTraceComponent(FFrame&, void* const)
native final function bool TraceComponent(out Vector HitLocation, out Vector HitNormal, PrimitiveComponent InComponent, Vector TraceEnd, optional Vector TraceStart, optional Vector Extent, optional out TraceHitInfo HitInfo, optional bool bComplexCollision);

// Export UActor::execPointCheckComponent(FFrame&, void* const)
native final function bool PointCheckComponent(PrimitiveComponent InComponent, Vector PointLocation, Vector PointExtent);

// Export UActor::execFastTrace(FFrame&, void* const)
native(548) final function bool FastTrace(Vector TraceEnd, optional Vector TraceStart, optional Vector BoxExtent, optional bool bTraceBullet);

// Export UActor::execTraceAllPhysicsAssetInteractions(FFrame&, void* const)
native final function bool TraceAllPhysicsAssetInteractions(SkeletalMeshComponent SkelMeshComp, Vector EndTrace, Vector StartTrace, out array<ImpactInfo> out_Hits, optional Vector Extent);

// Export UActor::execFindSpot(FFrame&, void* const)
native final function bool FindSpot(Vector BoxExtent, out Vector SpotLocation);

// Export UActor::execContainsPoint(FFrame&, void* const)
native final function bool ContainsPoint(Vector Spot);

// Export UActor::execIsOverlapping(FFrame&, void* const)
native final function bool IsOverlapping(Actor A);

// Export UActor::execGetComponentsBoundingBox(FFrame&, void* const)
native final function GetComponentsBoundingBox(out Box ActorBox);

// Export UActor::execGetBoundingCylinder(FFrame&, void* const)
native function GetBoundingCylinder(out float CollisionRadius, out float CollisionHeight);

// Export UActor::execIsBlockedBy(FFrame&, void* const)
native final function bool IsBlockedBy(const Actor Other);

// Export UActor::execSpawn(FFrame&, void* const)
native final function Actor Spawn(Class<Actor> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor ActorTemplate, optional bool bNoCollisionFail, optional bool bOnlyPerformSpawnCheck);

// Export UActor::execDestroy(FFrame&, void* const)
native(279) final function bool Destroy();

event TornOff()
{
	//return;	
}

// Export UActor::execSetTimer(FFrame&, void* const)
native(280) final function SetTimer(float InRate, optional bool inbLoop, optional name inTimerFunc = 'Timer', optional Object inObj);

// Export UActor::execClearTimer(FFrame&, void* const)
native final function ClearTimer(optional name inTimerFunc = 'Timer', optional Object inObj);

// Export UActor::execClearAllTimers(FFrame&, void* const)
native final function ClearAllTimers(optional Object inObj);

// Export UActor::execPauseTimer(FFrame&, void* const)
native final function PauseTimer(bool bPause, optional name inTimerFunc = 'Timer', optional Object inObj);

// Export UActor::execIsTimerActive(FFrame&, void* const)
native final function bool IsTimerActive(optional name inTimerFunc = 'Timer', optional Object inObj);

// Export UActor::execGetTimerCount(FFrame&, void* const)
native final function float GetTimerCount(optional name inTimerFunc = 'Timer', optional Object inObj);

// Export UActor::execGetTimerRate(FFrame&, void* const)
native final function float GetTimerRate(optional name TimerFuncName = 'Timer', optional Object inObj);

final simulated function float GetRemainingTimeForTimer(optional name TimerFuncName = 'Timer', optional Object inObj)
{
	local float Count, Rate;

	Rate = GetTimerRate(TimerFuncName, inObj);
	// End:0x82
	if(Rate != -1.0000000)
	{
		Count = GetTimerCount(TimerFuncName, inObj);
		return Rate - Count;
	}
	return -1.0000000;
	//return ReturnValue;	
}

// Export UActor::execModifyTimerTimeDilation(FFrame&, void* const)
native final function ModifyTimerTimeDilation(const name TimerName, const float InTimerTimeDilation, optional Object inObj);

// Export UActor::execResetTimerTimeDilation(FFrame&, void* const)
native final function ResetTimerTimeDilation(const name TimerName, optional Object inObj);

// Export UActor::execCreateAudioComponent(FFrame&, void* const)
native final function AudioComponent CreateAudioComponent(SoundCue InSoundCue, optional bool bPlay, optional bool bStopWhenOwnerDestroyed, optional bool bUseLocation, optional Vector SourceLocation, optional bool bAttachToSelf = true);

// Export UActor::execPlaySound(FFrame&, void* const)
native final function PlaySound(SoundCue InSoundCue, optional bool bNotReplicated, optional bool bNoRepToOwner, optional bool bStopWhenOwnerDestroyed, optional Vector SoundLocation, optional bool bNoRepToRelevant, optional float NoiseRadius = 0.0000000);

// Export UActor::execPlayAkEvent(FFrame&, void* const)
native final function PlayAkEvent(AkEvent InSoundCue, optional bool bNotReplicated, optional bool bNoRepToOwner, optional bool bStopWhenOwnerDestroyed, optional Vector SoundLocation, optional bool bNoRepToRelevant, optional float NoiseRadius = 0.0000000);

// Export UActor::execPlaySoundBase(FFrame&, void* const)
native final function PlaySoundBase(AkBaseSoundObject InSoundCue, optional bool bNotReplicated, optional bool bNoRepToOwner, optional bool bStopWhenOwnerDestroyed, optional Vector SoundLocation, optional bool bNoRepToRelevant, optional float NoiseRadius = 0.0000000);

// Export UActor::execPostAkEvent(FFrame&, void* const)
native final function PostAkEvent(AkEvent InAkEvent);

// Export UActor::execPostGlobalAkEvent(FFrame&, void* const)
native final function PostGlobalAkEvent(AkEvent InAkEvent);

// Export UActor::execPostAkEventOnBone(FFrame&, void* const)
native final function PostAkEventOnBone(AkEvent InAkEvent, name BoneName);

// Export UActor::execSetRTPCValue(FFrame&, void* const)
native final function SetRTPCValue(name InRTPC, float targetvalue);

// Export UActor::execSetAkState(FFrame&, void* const)
native final function SetAkState(name InStateGroup, name InState);

// Export UActor::execSetSwitch(FFrame&, void* const)
native final function SetSwitch(name InSwitchGroup, name InSwitch);

// Export UActor::execPostTrigger(FFrame&, void* const)
native final function PostTrigger(name InTrigger);

// Export UActor::execActivateOcclusion(FFrame&, void* const)
native final function ActivateOcclusion(bool bInActivate);

// Export UActor::execMakeNoise(FFrame&, void* const)
native(512) final function MakeNoise(float Loudness, optional name NoiseType);

// Export UActor::execPlayerCanSeeMe(FFrame&, void* const)
native(532) final function bool PlayerCanSeeMe(optional bool bForceLOSCheck);

// Export UActor::execSuggestTossVelocity(FFrame&, void* const)
native final function bool SuggestTossVelocity(out Vector TossVelocity, Vector Destination, Vector Start, float TossSpeed, optional float BaseTossZ, optional float DesiredZPct, optional Vector CollisionSize, optional float TerminalVelocity, optional float OverrideGravityZ, optional bool bOnlyTraceUp);

// Export UActor::execCalculateMinSpeedTrajectory(FFrame&, void* const)
native final function bool CalculateMinSpeedTrajectory(out Vector out_Velocity, Vector End, Vector Start, float MaxTossSpeed, float MinTossSpeed, optional Vector CollisionSize, optional float TerminalVelocity, optional float GravityZ = GetGravityZ(), optional bool bOnlyTraceUp);

// Export UActor::execGetDestination(FFrame&, void* const)
native final function Vector GetDestination(Controller C);

function bool PreTeleport(Teleporter InTeleporter)
{
	//return ReturnValue;	
}

function PostTeleport(Teleporter OutTeleporter)
{
	//return;	
}

// Export UActor::execGetURLMap(FFrame&, void* const)
native(547) final function string GetURLMap();

// Export UActor::execAllActors(FFrame&, void* const)
native(304) final iterator function AllActors(Class<Actor> BaseClass, out Actor Actor, optional Class<Interface> InterfaceClass);

// Export UActor::execDynamicActors(FFrame&, void* const)
native(313) final iterator function DynamicActors(Class<Actor> BaseClass, out Actor Actor, optional Class<Interface> InterfaceClass);

// Export UActor::execChildActors(FFrame&, void* const)
native(305) final iterator function ChildActors(Class<Actor> BaseClass, out Actor Actor);

// Export UActor::execBasedActors(FFrame&, void* const)
native(306) final iterator function BasedActors(Class<Actor> BaseClass, out Actor Actor);

// Export UActor::execTouchingActors(FFrame&, void* const)
native(307) final iterator function TouchingActors(Class<Actor> BaseClass, out Actor Actor);

// Export UActor::execTraceActors(FFrame&, void* const)
native(309) final iterator function TraceActors(Class<Actor> BaseClass, out Actor Actor, out Vector HitLoc, out Vector HitNorm, Vector End, optional Vector Start, optional Vector Extent, optional out TraceHitInfo HitInfo, optional int ExtraTraceFlags);

// Export UActor::execVisibleActors(FFrame&, void* const)
native(311) final iterator function VisibleActors(Class<Actor> BaseClass, out Actor Actor, optional float Radius, optional Vector Loc);

// Export UActor::execVisibleCollidingActors(FFrame&, void* const)
native(312) final iterator function VisibleCollidingActors(Class<Actor> BaseClass, out Actor Actor, float Radius, optional Vector Loc, optional bool bIgnoreHidden, optional Vector Extent, optional bool bTraceActors, optional Class<Interface> InterfaceClass, optional out TraceHitInfo HitInfo);

// Export UActor::execCollidingActors(FFrame&, void* const)
native(321) final iterator function CollidingActors(Class<Actor> BaseClass, out Actor Actor, float Radius, optional Vector Loc, optional bool bUseOverlapCheck, optional Class<Interface> InterfaceClass, optional out TraceHitInfo HitInfo);

// Export UActor::execOverlappingActors(FFrame&, void* const)
native final iterator function OverlappingActors(Class<Actor> BaseClass, out Actor out_Actor, float Radius, optional Vector Loc, optional bool bIgnoreHidden);

// Export UActor::execComponentList(FFrame&, void* const)
native final iterator function ComponentList(Class<ActorComponent> BaseClass, out ActorComponent out_Component);

// Export UActor::execGetComponentOfType(FFrame&, void* const)
native final function ActorComponent GetComponentOfType(Class<ActorComponent> BaseClass);

// Export UActor::execAllOwnedComponents(FFrame&, void* const)
native final iterator function AllOwnedComponents(Class<Component> BaseClass, out ActorComponent OutComponent);

// Export UActor::execLocalPlayerControllers(FFrame&, void* const)
native final iterator function LocalPlayerControllers(Class<PlayerController> BaseClass, out PlayerController PC);

// Export UActor::execGetALocalPlayerController(FFrame&, void* const)
native final function PlayerController GetALocalPlayerController();

event PreBeginPlay()
{
	// End:0xA4
	if(((!bGameRelevant && !bStatic) && int(WorldInfo.NetMode) != int(NM_Client)) && !WorldInfo.Game.CheckRelevance(self))
	{
		// End:0xA1
		if(bNoDelete)
		{
			ShutDown();			
		}
		else
		{
			Destroy();
		}
	}
	//return;	
}

event BroadcastLocalizedMessage(Class<LocalMessage> InMessageClass, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	WorldInfo.Game.BroadcastLocalized(self, InMessageClass, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	//return;	
}

event BroadcastLocalizedTeamMessage(int TeamIndex, Class<LocalMessage> InMessageClass, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	WorldInfo.Game.BroadcastLocalizedTeam(TeamIndex, self, InMessageClass, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	//return;	
}

event PostBeginPlay()
{
	//return;	
}

simulated event SetInitialState()
{
	bScriptInitialized = true;
	// End:0x34
	if(InitialState != 'None')
	{
		GotoState(InitialState);		
	}
	else
	{
		GotoState('Auto');
	}
	//return;	
}

simulated event ConstraintBrokenNotify(Actor ConOwner, RB_ConstraintSetup ConSetup, RB_ConstraintInstance ConInstance)
{
	//return;	
}

simulated event NotifySkelControlBeyondLimit(SkelControlLookAt LookAt)
{
	//return;	
}

simulated function bool StopsProjectile(Projectile P)
{
	return bProjTarget || bBlockActors;
	//return ReturnValue;	
}

simulated function bool HurtRadius(float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, optional Actor IgnoredActor, optional Controller InstigatedByController = ((Instigator != none) ? Instigator.Controller : none), optional bool bDoFullDamage)
{
	local Actor Victim;
	local bool bCausedDamage;
	local TraceHitInfo HitInfo;
	local editinline StaticMeshComponent HitComponent;
	local KActorFromStatic NewKActor;

	// End:0x45
	if(bHurtEntry)
	{
		return false;
	}
	bHurtEntry = true;
	bCausedDamage = false;
	// End:0x29D
	foreach VisibleCollidingActors(Class'Engine.Actor', Victim, DamageRadius, HurtOrigin,,,,, HitInfo)
	{
		// End:0x16C
		if(Victim.bWorldGeometry)
		{
			HitComponent = StaticMeshComponent(HitInfo.HitComponent);
			// End:0x16C
			if((HitComponent != none) && HitComponent.CanBecomeDynamic())
			{
				NewKActor = Class'Engine.KActorFromStatic'.static.MakeDynamic(HitComponent);
				// End:0x16C
				if(NewKActor != none)
				{
					Victim = NewKActor;
				}
			}
		}
		// End:0x29C
		if(((!Victim.bWorldGeometry && Victim != self) && Victim != IgnoredActor) && Victim.bCanBeDamaged || Victim.bProjTarget)
		{
			Victim.TakeRadiusDamage(InstigatedByController, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bDoFullDamage, self);
			bCausedDamage = bCausedDamage || Victim.bProjTarget;
		}		
	}	
	bHurtEntry = false;
	return bCausedDamage;
	//return ReturnValue;	
}

function KilledBy(Pawn EventInstigator)
{
	//return;	
}

event TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local int Idx;
	local SeqEvent_TakeDamage dmgEvent;

	Idx = 0;
	J0x0D:

	// End:0xA3 [Loop If]
	if(Idx < GeneratedEvents.Length)
	{
		dmgEvent = SeqEvent_TakeDamage(GeneratedEvents[Idx]);
		// End:0x95
		if(dmgEvent != none)
		{
			dmgEvent.HandleDamage(self, EventInstigator, DamageType, DamageAmount);
		}
		Idx++;
		// [Loop Continue]
		goto J0x0D;
	}
	//return;	
}

event bool HealDamage(int Amount, Controller Healer, Class<DamageType> DamageType)
{
	//return ReturnValue;	
}

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0000000)
{
	local float ColRadius, ColHeight, DamageScale, Dist, ScaledDamage;

	local Vector Dir;

	GetBoundingCylinder(ColRadius, ColHeight);
	Dir = Location - HurtOrigin;
	Dist = VSize(Dir);
	Dir = Normal(Dir);
	// End:0x8C
	if(bFullDamage)
	{
		DamageScale = 1.0000000;		
	}
	else
	{
		Dist = FMax(Dist - ColRadius, 0.0000000);
		DamageScale = FClamp(1.0000000 - (Dist / DamageRadius), 0.0000000, 1.0000000);
		DamageScale = DamageScale ** DamageFalloffExponent;
	}
	// End:0x1B2
	if(DamageScale > 0.0000000)
	{
		ScaledDamage = DamageScale * BaseDamage;
		TakeDamage(int(ScaledDamage), InstigatedBy, Location - ((0.5000000 * (ColHeight + ColRadius)) * Dir), (DamageScale * Momentum) * Dir, DamageType,, DamageCauser);
	}
	//return;	
}

final simulated function CheckHitInfo(out TraceHitInfo HitInfo, PrimitiveComponent FallBackComponent, Vector Dir, out Vector out_HitLocation)
{
	local Vector out_NewHitLocation, out_HitNormal, TraceEnd, TraceStart;
	local TraceHitInfo newHitInfo;

	// End:0x59
	if((SkeletalMeshComponent(HitInfo.HitComponent) != none) && HitInfo.BoneName != 'None')
	{
		return;
	}
	// End:0xE8
	if((HitInfo.HitComponent == none) || (SkeletalMeshComponent(HitInfo.HitComponent) == none) && SkeletalMeshComponent(FallBackComponent) != none)
	{
		HitInfo.HitComponent = FallBackComponent;
	}
	// End:0x2BA
	if((SkeletalMeshComponent(HitInfo.HitComponent) != none) && HitInfo.BoneName == 'None')
	{
		// End:0x163
		if(IsZero(Dir))
		{
			Dir = Vector(Rotation);
		}
		// End:0x185
		if(IsZero(out_HitLocation))
		{
			out_HitLocation = Location;
		}
		TraceStart = out_HitLocation - (float(128) * Normal(Dir));
		TraceEnd = out_HitLocation + (float(128) * Normal(Dir));
		// End:0x2BA
		if(TraceComponent(out_NewHitLocation, out_HitNormal, HitInfo.HitComponent, TraceEnd, TraceStart, vect(0.0000000, 0.0000000, 0.0000000), newHitInfo))
		{
			HitInfo.BoneName = newHitInfo.BoneName;
			HitInfo.PhysMaterial = newHitInfo.PhysMaterial;
			out_HitLocation = out_NewHitLocation;
		}
	}
	//return;	
}

// Export UActor::execGetGravityZ(FFrame&, void* const)
native function float GetGravityZ();

event DebugFreezeGame(optional Actor ActorToLookAt)
{
	local PlayerController PC;

	ScriptTrace();
	PC = GetALocalPlayerController();
	// End:0x9C
	if(PC != none)
	{		
		PC.ConsoleCommand("PlayersOnly");
		// End:0x9C
		if(ActorToLookAt != none)
		{
			PC.SetViewTarget(ActorToLookAt);
		}
	}
	//return;	
}

function bool CheckForErrors()
{
	//return ReturnValue;	
}

event BecomeViewTarget(PlayerController PC)
{
	//return;	
}

event EndViewTarget(PlayerController PC)
{
	//return;	
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
	local Vector HitNormal;
	local float Radius, Height;

	GetBoundingCylinder(Radius, Height);
	// End:0x9F
	if(Trace(out_CamLoc, HitNormal, Location - ((Vector(out_CamRot) * Radius) * float(20)), Location, false) == none)
	{
		out_CamLoc = Location - ((Vector(out_CamRot) * Radius) * float(20));		
	}
	else
	{
		out_CamLoc = Location + (Height * Vector(Rotation));
	}
	return false;
	//return ReturnValue;	
}

simulated function string GetItemName(string FullName)
{
	local int pos;

	pos = InStr(FullName, ".");
	J0x1B:

	// End:0x7A [Loop If]
	if(pos != -1)
	{
		FullName = Right(FullName, (Len(FullName) - pos) - 1);
		pos = InStr(FullName, ".");
		// [Loop Continue]
		goto J0x1B;
	}
	return FullName;
	//return ReturnValue;	
}

simulated function string GetHumanReadableName()
{
	return GetItemName(string(Class));
	//return ReturnValue;	
}

static function ReplaceText(out string Text, string Replace, string With)
{
	local int I;
	local string Input;

	Input = Text;
	Text = "";
	I = InStr(Input, Replace);
	J0x40:

	// End:0xD7 [Loop If]
	if(I != -1)
	{
		Text = (Text $ Left(Input, I)) $ With;
		Input = Mid(Input, I + Len(Replace));
		I = InStr(Input, Replace);
		// [Loop Continue]
		goto J0x40;
	}
	Text = Text $ Input;
	//return;	
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	return "";
	//return ReturnValue;	
}

function MatchStarting()
{
	//return;	
}

function string GetDebugName()
{
	return GetItemName(string(self));
	//return ReturnValue;	
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local string T;
	local Actor A;
	local float MyRadius, MyHeight;
	local Canvas Canvas;

	Canvas = HUD.Canvas;
	Canvas.SetPos(4.0000000, out_YPos);
	Canvas.SetDrawColor(255, 0, 0);
	T = GetDebugName();
	// End:0xD0
	if(bDeleteMe)
	{
		T = T $ " DELETED (bDeleteMe == true)";
	}
	// End:0x14E
	if(T != "")
	{
		Canvas.DrawText(T, false);
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
	}
	Canvas.SetDrawColor(255, 255, 255);
	// End:0x2CA
	if(HUD.ShouldDisplayDebug('net'))
	{
		// End:0x2CA
		if(int(WorldInfo.NetMode) != int(NM_Standalone))
		{
			T = (((("ROLE:" @ string(Role)) @ "RemoteRole:") @ string(RemoteRole)) @ "NetMode:") @ string(WorldInfo.NetMode);
			// End:0x25C
			if(bTearOff)
			{
				T = T @ "Tear Off";
			}
			Canvas.DrawText(T, false);
			out_YPos += out_YL;
			Canvas.SetPos(4.0000000, out_YPos);
		}
	}
	Canvas.DrawText((("Location:" @ string(Location)) @ "Rotation:") @ string(Rotation), false);
	out_YPos += out_YL;
	Canvas.SetPos(4.0000000, out_YPos);
	// End:0x6D6
	if(HUD.ShouldDisplayDebug('Physics'))
	{
		T = (((((("Physics" @ (GetPhysicsName())) @ "in physicsvolume") @ (GetItemName(string(PhysicsVolume)))) @ "on base") @ (GetItemName(string(Base)))) @ "gravity") @ string(GetGravityZ());
		// End:0x443
		if(bBounce)
		{
			T = T $ " - will bounce";
		}
		Canvas.DrawText(T, false);
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
		Canvas.DrawText((((((((("bHardAttach:" @ string(bHardAttach)) @ "RelativeLoc:") @ string(RelativeLocation)) @ "RelativeRot:") @ string(RelativeRotation)) @ "SkelComp:") @ string(BaseSkelComponent)) @ "Bone:") @ string(BaseBoneName), false);
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
		Canvas.DrawText((((("Velocity:" @ string(Velocity)) @ "Speed:") @ string(VSize(Velocity))) @ "Speed2D:") @ string(VSize2D(Velocity)), false);
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
		Canvas.DrawText("Acceleration:" @ string(Acceleration), false);
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
	}
	// End:0xA34
	if(HUD.ShouldDisplayDebug('Collision'))
	{
		Canvas.DrawColor.B = 0;
		GetBoundingCylinder(MyRadius, MyHeight);
		Canvas.DrawText((("Collision Radius:" @ string(MyRadius)) @ "Height:") @ string(MyHeight));
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
		Canvas.DrawText((((("Collides with Actors:" @ string(bCollideActors)) @ " world:") @ string(bCollideWorld)) @ "proj. target:") @ string(bProjTarget));
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
		Canvas.DrawText("Blocks Actors:" @ string(bBlockActors));
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
		T = "Touching ";
		// End:0x990
		foreach TouchingActors(Class'Engine.Actor', A)
		{
			T = (T $ (GetItemName(string(A)))) $ " ";			
		}		
		// End:0x9C6
		if(T == "Touching ")
		{
			T = "Touching nothing";
		}
		Canvas.DrawText(T, false);
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
	}
	Canvas.DrawColor.B = 255;
	Canvas.DrawText(" STATE:" @ string(GetStateName()), false);
	out_YPos += out_YL;
	Canvas.SetPos(4.0000000, out_YPos);
	Canvas.DrawText(((" Instigator:" @ (GetItemName(string(Instigator)))) @ "Owner:") @ (GetItemName(string(Owner))));
	out_YPos += out_YL;
	Canvas.SetPos(4.0000000, out_YPos);
	//return;	
}

simulated function string GetPhysicsName()
{
	switch(Physics)
	{
		// End:0x22
		case 0:
			return "None";
			// End:0x105
			break;
		// End:0x34
		case 1:
			return "Walking";
			// End:0x105
			break;
		// End:0x46
		case 2:
			return "Falling";
			// End:0x105
			break;
		// End:0x59
		case 3:
			return "Swimming";
			// End:0x105
			break;
		// End:0x6A
		case 4:
			return "Flying";
			// End:0x105
			break;
		// End:0x7D
		case 5:
			return "Rotating";
			// End:0x105
			break;
		// End:0x92
		case 6:
			return "Projectile";
			// End:0x105
			break;
		// End:0xAA
		case 7:
			return "Interpolating";
			// End:0x105
			break;
		// End:0xBB
		case 8:
			return "Spider";
			// End:0x105
			break;
		// End:0xCC
		case 9:
			return "Ladder";
			// End:0x105
			break;
		// End:0xE0
		case 10:
			return "RigidBody";
			// End:0x105
			break;
		// End:0xF1
		case 13:
			return "Unused";
			// End:0x105
			break;
		// End:0x102
		case 14:
			return "Custom";
			// End:0x105
			break;
		// End:0xFFFF
		default:
			break;
	}
	return "Unknown";
	//return ReturnValue;	
}

simulated event ModifyHearSoundComponent(AudioComponent AC)
{
	//return;	
}

simulated event AudioComponent GetFaceFXAudioComponent()
{
	return none;
	//return ReturnValue;	
}

event Reset()
{
	//return;	
}

function bool IsInPain()
{
	local PhysicsVolume V;

	// End:0x66
	foreach TouchingActors(Class'Engine.PhysicsVolume', V)
	{
		// End:0x65
		if(V.bPainCausing && V.DamagePerSec > float(0))
		{			
			return true;
		}		
	}	
	return false;
	//return ReturnValue;	
}

function PlayTeleportEffect(bool bOut, bool bSound)
{
	//return;	
}

simulated function bool CanSplash()
{
	return false;
	//return ReturnValue;	
}

simulated function ApplyFluidSurfaceImpact(FluidSurfaceActor Fluid, Vector HitLocation)
{
	local float Radius, Height, AdjustedVelocity;

	// End:0xE4
	if(bAllowFluidSurfaceInteraction)
	{
		AdjustedVelocity = 0.0100000 * Abs(Velocity.Z);
		GetBoundingCylinder(Radius, Height);
		Fluid.FluidComponent.ApplyForce(HitLocation, AdjustedVelocity * Fluid.FluidComponent.ForceImpact, Radius * 0.3000000, true);
	}
	//return;	
}

simulated function bool EffectIsRelevant(Vector SpawnLocation, bool bForceDedicated, optional float VisibleCullDistance = 5000.0000000, optional float HiddenCullDistance = 350.0000000)
{
	// End:0x5C
	if(SpawnLocation == Location)
	{
		return ActorEffectIsRelevant(Instigator, bForceDedicated, VisibleCullDistance, HiddenCullDistance);		
	}
	else
	{
		return ImpactEffectIsRelevant(Instigator, SpawnLocation, bForceDedicated, VisibleCullDistance, HiddenCullDistance);
	}
	//return ReturnValue;	
}

simulated function bool ActorEffectIsRelevant(Pawn EffectInstigator, bool bForceDedicated, optional float VisibleCullDistance = 5000.0000000, optional float HiddenCullDistance = 350.0000000)
{
	local PlayerController P;
	local float DistSq;
	local Vector CameraLoc;
	local Rotator CameraRot;

	// End:0x98
	if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
	{
		// End:0x8D
		if(bDebugEffectIsRelevant && bForceDedicated)
		{
			DebugMessagePlayer("EffectIsRelevant FAILED - dedicated server");
		}
		return bForceDedicated;
	}
	// End:0x10D
	if((bForceDedicated && int(WorldInfo.NetMode) == int(NM_ListenServer)) && WorldInfo.Game.NumPlayers > 1)
	{
		return true;
	}
	// End:0x167
	if(((EffectInstigator != none) && EffectInstigator.IsHumanControlled()) && EffectInstigator.IsLocallyControlled())
	{
		return true;
	}
	DistSq = 10000000000.0000000;
	// End:0x23C
	foreach LocalPlayerControllers(Class'Engine.PlayerController', P)
	{
		// End:0x1BD
		if(P.GetViewTarget() == self)
		{			
			return true;
		}
		P.GetPlayerViewPoint(CameraLoc, CameraRot);
		DistSq = FMin(DistSq, VSizeSq(Location - CameraLoc) * Square(P.LODDistanceFactor));		
	}	
	// End:0x2B0
	if(DistSq > (VisibleCullDistance * VisibleCullDistance))
	{
		// End:0x2AB
		if(bDebugEffectIsRelevant && true)
		{
			DebugMessagePlayer("EffectIsRelevant FAILED - VisibleCullDistance");
		}
		return false;		
	}
	else
	{
		// End:0x2D4
		if(DistSq < (HiddenCullDistance * HiddenCullDistance))
		{
			return true;
		}
	}
	return (WorldInfo.TimeSeconds - LastRenderTime) < 0.3000000;
	//return ReturnValue;	
}

simulated function bool ImpactEffectIsRelevant(Pawn EffectInstigator, Vector SpawnLocation, bool bForceDedicated, optional float VisibleCullDistance = 5000.0000000, optional float HiddenCullDistance = 350.0000000, optional bool bSkipLOSCheck)
{
	local PlayerController P;
	local float DistSq, InViewThreshold;
	local bool bIsInViewFrustrum;
	local Vector CameraLoc;
	local Rotator CameraRot;

	// End:0x99
	if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
	{
		// End:0x8E
		if(bDebugEffectIsRelevant && bForceDedicated)
		{
			DebugMessagePlayer("EffectIsRelevant FAILED - dedicated server");
		}
		return bForceDedicated;
	}
	// End:0x10E
	if((bForceDedicated && int(WorldInfo.NetMode) == int(NM_ListenServer)) && WorldInfo.Game.NumPlayers > 1)
	{
		return true;
	}
	// End:0x168
	if(((EffectInstigator != none) && EffectInstigator.IsHumanControlled()) && EffectInstigator.IsLocallyControlled())
	{
		return true;
	}
	DistSq = 10000000000.0000000;
	// End:0x215
	foreach LocalPlayerControllers(Class'Engine.PlayerController', P)
	{
		P.GetPlayerViewPoint(CameraLoc, CameraRot);
		DistSq = FMin(DistSq, VSizeSq(SpawnLocation - CameraLoc) * Square(P.LODDistanceFactor));		
	}	
	// End:0x289
	if(DistSq > (VisibleCullDistance * VisibleCullDistance))
	{
		// End:0x284
		if(bDebugEffectIsRelevant && true)
		{
			DebugMessagePlayer("EffectIsRelevant FAILED - VisibleCullDistance");
		}
		return false;		
	}
	else
	{
		// End:0x2AD
		if(DistSq < (HiddenCullDistance * HiddenCullDistance))
		{
			return true;
		}
	}
	bIsInViewFrustrum = false;
	// End:0x3A5
	foreach LocalPlayerControllers(Class'Engine.PlayerController', P)
	{
		P.GetPlayerViewPoint(CameraLoc, CameraRot);
		InViewThreshold = Cos(P.GetFOVAngle()) - 0.1000000;
		// End:0x3A4
		if((Normal(SpawnLocation - CameraLoc) Dot Vector(CameraRot)) > InViewThreshold)
		{
			// End:0x3A4
			if(bSkipLOSCheck || FastTrace(SpawnLocation, CameraLoc))
			{
				bIsInViewFrustrum = true;
				// End:0x3A5
				break;
			}
		}		
	}	
	// End:0x3FD
	if(bDebugEffectIsRelevant && bIsInViewFrustrum)
	{
		DebugMessagePlayer("EffectIsRelevant FAILED - Outside View Frustrum");
	}
	return bIsInViewFrustrum;
	//return ReturnValue;	
}

final event DebugMessagePlayer(coerce string msg)
{
	local PlayerController PC;

	LogInternal(("!!!!" @ msg) @ "!!!!");
	ScriptTrace();
	// End:0x70
	foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		PC.ClientMessage(msg);		
	}	
	//return;	
}

simulated function bool TriggerEventClass(Class<SequenceEvent> InEventClass, Actor InInstigator, optional int ActivateIndex = -1, optional bool bTest, optional out array<SequenceEvent> ActivatedEvents)
{
	local array<int> ActivateIndices;

	// End:0x2F
	if(ActivateIndex >= 0)
	{
		ActivateIndices[0] = ActivateIndex;
	}
	return ActivateEventClass(InEventClass, InInstigator, GeneratedEvents, ActivateIndices, bTest, ActivatedEvents);
	//return ReturnValue;	
}

simulated event ReceivedNewEvent(SequenceEvent Evt)
{
	//return;	
}

simulated function bool TriggerGlobalEventClass(Class<SequenceEvent> InEventClass, Actor InInstigator, optional int ActivateIndex = -1)
{
	local array<SequenceObject> EventsToActivate;
	local array<int> ActivateIndices;
	local Sequence GameSeq;
	local bool bResult;
	local int I;

	// End:0x2D
	if(ActivateIndex >= 0)
	{
		ActivateIndices[0] = ActivateIndex;
	}
	GameSeq = WorldInfo.GetGameSequence();
	// End:0x11E
	if(GameSeq != none)
	{
		GameSeq.FindSeqObjectsByClass(InEventClass, true, EventsToActivate);
		I = 0;
		J0xA2:

		// End:0x11E [Loop If]
		if(I < EventsToActivate.Length)
		{
			// End:0x110
			if(SequenceEvent(EventsToActivate[I]).CheckActivate(self, InInstigator,, ActivateIndices))
			{
				bResult = true;
			}
			I++;
			// [Loop Continue]
			goto J0xA2;
		}
	}
	return bResult;
	//return ReturnValue;	
}

final simulated function bool ActivateEventClass(Class<SequenceEvent> InClass, Actor InInstigator, const out array<SequenceEvent> EventList, const optional out array<int> ActivateIndices, optional bool bTest, optional out array<SequenceEvent> ActivatedEvents)
{
	local SequenceEvent Evt;

	ActivatedEvents.Length = 0;
	// End:0xAC
	foreach EventList(Evt)
	{
		// End:0xAB
		if(ClassIsChildOf(Evt.Class, InClass) && Evt.CheckActivate(self, InInstigator, bTest, ActivateIndices))
		{
			ActivatedEvents.AddItem(Evt);
		}		
	}	
	return ActivatedEvents.Length > 0;
	//return ReturnValue;	
}

final simulated function bool FindEventsOfClass(Class<SequenceEvent> EventClass, optional out array<SequenceEvent> out_EventList, optional bool bIncludeDisabled)
{
	local SequenceEvent Evt;
	local bool bFoundEvent;

	// End:0x116
	foreach GeneratedEvents(Evt)
	{
		// End:0x115
		if((((Evt != none) && Evt.bEnabled || bIncludeDisabled) && ClassIsChildOf(Evt.Class, EventClass)) && (Evt.MaxTriggerCount == 0) || Evt.MaxTriggerCount > Evt.TriggerCount)
		{
			out_EventList.AddItem(Evt);
			bFoundEvent = true;
		}		
	}	
	return bFoundEvent;
	//return ReturnValue;	
}

final simulated function ClearLatentAction(Class<SeqAct_Latent> actionClass, optional bool bAborted, optional SeqAct_Latent exceptionAction)
{
	local int Idx;

	Idx = 0;
	J0x0D:

	// End:0x10E [Loop If]
	if(Idx < LatentActions.Length)
	{
		// End:0x58
		if(LatentActions[Idx] == none)
		{
			LatentActions.Remove(Idx--, 1);			
		}
		else
		{
			// End:0x100
			if(ClassIsChildOf(LatentActions[Idx].Class, actionClass) && LatentActions[Idx] != exceptionAction)
			{
				// End:0xE9
				if(bAborted)
				{
					LatentActions[Idx].AbortFor(self);
				}
				LatentActions.Remove(Idx--, 1);
			}
		}
		Idx++;
		// [Loop Continue]
		goto J0x0D;
	}
	//return;	
}

simulated function OnDestroy(SeqAct_Destroy Action)
{
	local int AttachIdx, IgnoreIdx;
	local Actor A;

	// End:0x14A
	if(Action.bDestroyBasedActors)
	{
		AttachIdx = 0;
		J0x2D:

		// End:0x14A [Loop If]
		if(AttachIdx < Attached.Length)
		{
			A = Attached[AttachIdx];
			IgnoreIdx = 0;
			J0x6D:

			// End:0x102 [Loop If]
			if(IgnoreIdx < Action.IgnoreBasedClasses.Length)
			{
				// End:0xF4
				if(ClassIsChildOf(A.Class, Action.IgnoreBasedClasses[IgnoreIdx]))
				{
					A = none;
					// [Explicit Break]
					goto J0x102;
				}
				IgnoreIdx++;
				// [Loop Continue]
				goto J0x6D;
			}
			J0x102:

			// End:0x114
			if(A == none)
			{				
			}
			else
			{
				A.OnDestroy(Action);
			}
			AttachIdx++;
			// [Loop Continue]
			goto J0x2D;
		}
	}
	// End:0x17A
	if(bNoDelete || int(Role) < int(ROLE_Authority))
	{
		ShutDown();		
	}
	else
	{
		// End:0x18C
		if(!bDeleteMe)
		{
			Destroy();
		}
	}
	//return;	
}

event ForceNetRelevant()
{
	// End:0x5B
	if(((int(RemoteRole) == int(ROLE_None)) && bNoDelete) && !bStatic)
	{
		RemoteRole = ROLE_SimulatedProxy;
		bAlwaysRelevant = true;
		NetUpdateFrequency = 0.1000000;
	}
	bForceNetUpdate = true;
	//return;	
}

// Export UActor::execSetNetUpdateTime(FFrame&, void* const)
native final function SetNetUpdateTime(float NewUpdateTime);

simulated event ShutDown()
{
	SetPhysics(0);
	SetCollision(false, false);
	// End:0x3A
	if(CollisionComponent != none)
	{
		CollisionComponent.SetBlockRigidBody(false);
	}
	SetHidden(true);
	SetTickIsDisabled(true);
	ForceNetRelevant();
	// End:0x114
	if(int(RemoteRole) != int(ROLE_None))
	{
		SetForcedInitialReplicatedProperty(BoolProperty'Engine.Actor.bCollideActors', bCollideActors == default.bCollideActors);
		SetForcedInitialReplicatedProperty(BoolProperty'Engine.Actor.bBlockActors', bBlockActors == default.bBlockActors);
		SetForcedInitialReplicatedProperty(BoolProperty'Engine.Actor.bHidden', bHidden == default.bHidden);
		SetForcedInitialReplicatedProperty(ByteProperty'Engine.Actor.Physics', int(Physics) == int(default.Physics));
	}
	NetUpdateFrequency = 0.1000000;
	bForceNetUpdate = true;
	//return;	
}

// Export UActor::execPrestreamTextures(FFrame&, void* const)
native function PrestreamTextures(float Seconds, bool bEnableStreaming, optional int CinematicTextureGroups = 0);

simulated function OnModifyHealth(SeqAct_ModifyHealth Action)
{
	local Controller InstigatorController;
	local Pawn InstigatorPawn;

	InstigatorController = Controller(Action.Instigator);
	// End:0xA8
	if(InstigatorController == none)
	{
		InstigatorPawn = Pawn(Action.Instigator);
		// End:0xA8
		if(InstigatorPawn != none)
		{
			InstigatorController = InstigatorPawn.Controller;
		}
	}
	// End:0x11E
	if(Action.bHeal)
	{
		HealDamage(int(Action.Amount), InstigatorController, Action.DamageType);		
	}
	else
	{
		TakeDamage(int(Action.Amount), InstigatorController, Location, Vector(Rotation) * -Action.Momentum, Action.DamageType);
	}
	//return;	
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
	local array<Object> objVars;
	local int Idx;
	local Actor destActor, tempActor, A;
	local Controller C;
	local bool bOccupiedDest, bColliding;
	local float ColRadius, ColHeight;
	local Vector Extent;

	GetBoundingCylinder(ColRadius, ColHeight);
	Extent.X = ColRadius;
	Extent.Y = ColRadius;
	Extent.Z = ColHeight;
	bOccupiedDest = false;
	Action.GetObjectVars(objVars, "Destination");
	Idx = 0;
	J0xDA:

	// End:0x2CA [Loop If]
	if(Idx < objVars.Length)
	{
		tempActor = Actor(objVars[Idx]);
		// End:0x12A
		if(tempActor == none)
		{			
		}
		else
		{
			C = Controller(tempActor);
			// End:0x1A3
			if((C != none) && C.Pawn != none)
			{
				tempActor = C.Pawn;
			}
			// End:0x260
			if(Action.bCheckOverlap)
			{
				bColliding = false;
				// End:0x24A
				foreach VisibleCollidingActors(Class'Engine.Actor', A, ColRadius * 2.0000000, tempActor.Location, false, Extent, true)
				{
					// End:0x249
					if(IsBlockedBy(A))
					{
						bColliding = true;
						// End:0x24A
						break;
					}					
				}				
				bOccupiedDest = bColliding;
			}
			destActor = tempActor;
			// End:0x2BC
			if((!Action.bCheckOverlap || !bOccupiedDest) && destActor != none)
			{
				// [Explicit Break]
				goto J0x2CA;
			}
		}
		Idx++;
		// [Loop Continue]
		goto J0xDA;
	}
	J0x2CA:

	// End:0x419
	if((destActor != none) && Action.ShouldTeleport(self, destActor.Location, Action.TeleportDistance, Action.TeleportVolumes))
	{
		// End:0x3F0
		if(SetLocation(destActor.Location))
		{
			PlayTeleportEffect(false, true);
			// End:0x3CB
			if(Action.bUpdateRotation)
			{
				SetRotation(destActor.Rotation);
			}
			ForceNetRelevant();
			bUpdateSimulatedPosition = true;
			bNetDirty = true;			
		}
		else
		{
			WarnInternal("Unable to teleport to" @ string(destActor));
		}		
	}
	else
	{
		// End:0x44E
		if(destActor != none)
		{
			WarnInternal("Unable to teleport to" @ string(destActor));
		}
	}
	//return;	
}

simulated function OnSetVelocity(SeqAct_SetVelocity Action)
{
	local Vector V;
	local float Mag;

	Mag = Action.VelocityMag;
	// End:0x65
	if(Mag <= 0.0000000)
	{
		Mag = VSize(Action.VelocityDir);
	}
	V = Normal(Action.VelocityDir) * Mag;
	// End:0xDB
	if(Action.bVelocityRelativeToActorRotation)
	{
		V = V >> Rotation;
	}
	Velocity = V;
	// End:0x13C
	if((int(Physics) == int(10)) && CollisionComponent != none)
	{
		CollisionComponent.SetRBLinearVelocity(Velocity);
	}
	//return;	
}

simulated function OnSetBlockRigidBody(SeqAct_SetBlockRigidBody Action)
{
	// End:0xC0
	if(CollisionComponent != none)
	{
		// End:0x69
		if(Action.InputLinks[0].bHasImpulse)
		{
			CollisionComponent.SetBlockRigidBody(true);			
		}
		else
		{
			// End:0xC0
			if(Action.InputLinks[1].bHasImpulse)
			{
				CollisionComponent.SetBlockRigidBody(false);
			}
		}
	}
	//return;	
}

simulated function OnSetPhysics(SeqAct_SetPhysics Action)
{
	ForceNetRelevant();
	SetPhysics(Action.newPhysics);
	// End:0xA3
	if(int(RemoteRole) != int(ROLE_None))
	{
		// End:0x78
		if(int(Physics) != int(0))
		{
			bUpdateSimulatedPosition = true;
			// End:0x78
			if(bOnlyDirtyReplication)
			{
				bNetDirty = true;
			}
		}
		SetForcedInitialReplicatedProperty(ByteProperty'Engine.Actor.Physics', int(Physics) == int(default.Physics));
	}
	//return;	
}

function OnChangeCollision(SeqAct_ChangeCollision Action)
{
	// End:0xA5
	if(Action.ObjInstanceVersion < Action.GetObjClassVersion())
	{
		SetCollision(Action.bCollideActors, Action.bBlockActors, Action.bIgnoreEncroachers);		
	}
	else
	{
		SetCollisionType(Action.CollisionType);
	}
	ForceNetRelevant();
	// End:0x13D
	if(int(RemoteRole) != int(ROLE_None))
	{
		SetForcedInitialReplicatedProperty(BoolProperty'Engine.Actor.bCollideActors', bCollideActors == default.bCollideActors);
		SetForcedInitialReplicatedProperty(BoolProperty'Engine.Actor.bBlockActors', bBlockActors == default.bBlockActors);
	}
	//return;	
}

simulated function OnToggleHidden(SeqAct_ToggleHidden Action)
{
	local int AttachIdx, IgnoreIdx;
	local Actor A;

	// End:0x14A
	if(Action.bToggleBasedActors)
	{
		AttachIdx = 0;
		J0x2D:

		// End:0x14A [Loop If]
		if(AttachIdx < Attached.Length)
		{
			A = Attached[AttachIdx];
			IgnoreIdx = 0;
			J0x6D:

			// End:0x102 [Loop If]
			if(IgnoreIdx < Action.IgnoreBasedClasses.Length)
			{
				// End:0xF4
				if(ClassIsChildOf(A.Class, Action.IgnoreBasedClasses[IgnoreIdx]))
				{
					A = none;
					// [Explicit Break]
					goto J0x102;
				}
				IgnoreIdx++;
				// [Loop Continue]
				goto J0x6D;
			}
			J0x102:

			// End:0x114
			if(A == none)
			{				
			}
			else
			{
				A.OnToggleHidden(Action);
			}
			AttachIdx++;
			// [Loop Continue]
			goto J0x2D;
		}
	}
	// End:0x18F
	if(Action.InputLinks[0].bHasImpulse)
	{
		SetHidden(true);		
	}
	else
	{
		// End:0x1D4
		if(Action.InputLinks[1].bHasImpulse)
		{
			SetHidden(false);			
		}
		else
		{
			SetHidden(!bHidden);
		}
	}
	ForceNetRelevant();
	// End:0x231
	if(int(RemoteRole) != int(ROLE_None))
	{
		SetForcedInitialReplicatedProperty(BoolProperty'Engine.Actor.bHidden', bHidden == default.bHidden);
	}
	//return;	
}

function OnAttachToActor(SeqAct_AttachToActor Action)
{
	local int Idx;
	local Actor Attachment;
	local Controller C;
	local array<Object> objVars;

	Action.GetObjectVars(objVars, "Attachment");
	Idx = 0;
	J0x3F:

	// End:0x233 [Loop If]
	if((Idx < objVars.Length) && Attachment == none)
	{
		Attachment = Actor(objVars[Idx]);
		C = Controller(Attachment);
		// End:0x107
		if((C != none) && C.Pawn != none)
		{
			Attachment = C.Pawn;
		}
		// End:0x225
		if(Attachment != none)
		{
			// End:0x177
			if(Action.bDetach)
			{
				Attachment.SetBase(none);
				Attachment.SetHardAttach(false);				
			}
			else
			{
				C = Controller(self);
				// End:0x209
				if((C != none) && C.Pawn != none)
				{
					C.Pawn.DoKismetAttachment(Attachment, Action);					
				}
				else
				{
					DoKismetAttachment(Attachment, Action);
				}
			}
		}
		Idx++;
		// [Loop Continue]
		goto J0x3F;
	}
	//return;	
}

function DoKismetAttachment(Actor Attachment, SeqAct_AttachToActor Action)
{
	local bool bOldCollideActors, bOldBlockActors;
	local Vector X, Y, Z;

	Attachment.SetBase(none);
	Attachment.SetHardAttach(Action.bHardAttach);
	// End:0x2C3
	if(Action.bUseRelativeOffset || Action.bUseRelativeRotation)
	{
		bOldCollideActors = Attachment.bCollideActors;
		bOldBlockActors = Attachment.bBlockActors;
		Attachment.SetCollision(false, false);
		// End:0x173
		if(Action.bUseRelativeRotation)
		{
			Attachment.SetRotation(Rotation + Action.RelativeRotation);
		}
		// End:0x296
		if(Action.bUseRelativeOffset)
		{
			GetAxes(Rotation, X, Y, Z);
			Attachment.SetLocation(((Location + (Action.RelativeOffset.X * X)) + (Action.RelativeOffset.Y * Y)) + (Action.RelativeOffset.Z * Z));
		}
		Attachment.SetCollision(bOldCollideActors, bOldBlockActors);
	}
	Attachment.SetBase(self);
	Attachment.ForceNetRelevant();
	Attachment.bNetDirty = true;
	// End:0x45C
	if((int(Attachment.RemoteRole) != int(ROLE_None)) && Attachment.bStatic || Attachment.bNoDelete)
	{
		Attachment.SetForcedInitialReplicatedProperty(StructProperty'Engine.Actor.RelativeLocation', Attachment.RelativeLocation == Attachment.default.RelativeLocation);
		Attachment.SetForcedInitialReplicatedProperty(StructProperty'Engine.Actor.RelativeRotation', Attachment.RelativeRotation == Attachment.default.RelativeRotation);
	}
	//return;	
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	//return;	
}

event OnAnimPlay(AnimNodeSequence SeqNode)
{
	//return;	
}

event BeginAnimControl(InterpGroup InInterpGroup)
{
	//return;	
}

event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping, bool bEnableRootMotion)
{
	//return;	
}

event FinishAnimControl(InterpGroup InInterpGroup)
{
	//return;	
}

event bool PlayActorFaceFXAnim(FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay, AkEvent AkEventToPlay)
{
	//return ReturnValue;	
}

event StopActorFaceFXAnim()
{
	//return;	
}

event SetMorphWeight(name MorphNodeName, float MorphWeight)
{
	//return;	
}

event SetSkelControlScale(name SkelControlName, float Scale)
{
	//return;	
}

event TickSkelControl(float DeltaTime, SkeletalMeshComponent SkelComp, SkelControlBase SkelCtrl)
{
	//return;	
}

simulated function bool IsActorPlayingFaceFXAnim()
{
	return false;
	//return ReturnValue;	
}

simulated function bool CanActorPlayFaceFXAnim()
{
	return true;
	//return ReturnValue;	
}

event FaceFXAsset GetActorFaceFXAsset()
{
	//return ReturnValue;	
}

function bool IsStationary()
{
	return true;
	//return ReturnValue;	
}

simulated event GetActorEyesViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
	out_Location = Location;
	out_Rotation = Rotation;
	//return;	
}

// Export UActor::execIsPlayerOwned(FFrame&, void* const)
native simulated function bool IsPlayerOwned();

function PawnBaseDied()
{
	//return;	
}

// Export UActor::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

// Export UActor::execSetTeamNum(FFrame&, void* const)
native simulated function SetTeamNum(byte newTeamNum);

simulated event byte ScriptGetTeamNum()
{
	return 255;
	//return ReturnValue;	
}

simulated event ScriptSetTeamNum(byte newTeamNum)
{
	//return;	
}

simulated function NotifyLocalPlayerTeamReceived()
{
	//return;	
}

simulated function FindGoodEndView(PlayerController PC, out Rotator GoodRotation)
{
	GoodRotation = PC.Rotation;
	//return;	
}

// Export UActor::execGetTargetLocation(FFrame&, void* const)
native simulated function Vector GetTargetLocation(optional Actor RequestedBy, optional bool bRequestAlternateLoc);

event SpawnedByKismet()
{
	//return;	
}

simulated event InterpolationStarted(SeqAct_Interp InterpAction, InterpGroupInst GroupInst)
{
	//return;	
}

simulated event InterpolationFinished(SeqAct_Interp InterpAction)
{
	//return;	
}

simulated event InterpolationChanged(SeqAct_Interp InterpAction)
{
	//return;	
}

event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
	//return;	
}

event OnRanOver(SVehicle Vehicle, PrimitiveComponent RunOverComponent, int WheelIndex)
{
	//return;	
}

// Export UActor::execSetHUDLocation(FFrame&, void* const)
native simulated function SetHUDLocation(Vector NewHUDLocation);

// Export UActor::execNativePostRenderFor(FFrame&, void* const)
native simulated function NativePostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir);

simulated event PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
	//return;	
}

simulated event RootMotionModeChanged(SkeletalMeshComponent SkelComp)
{
	//return;	
}

simulated event RootMotionProcessed(SkeletalMeshComponent SkelComp)
{
	//return;	
}

simulated event RootMotionExtracted(SkeletalMeshComponent SkelComp, out BoneAtom ExtractedRootMotionDelta)
{
	//return;	
}

event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	//return;	
}

// Export UActor::execGetPackageGuid(FFrame&, void* const)
native static final function Guid GetPackageGuid(name PackageName);

simulated event OnRigidBodySpringOverextension(RB_BodyInstance BodyInstance)
{
	//return;	
}

// Export UActor::execIsInPersistentLevel(FFrame&, void* const)
native final function bool IsInPersistentLevel(optional bool bIncludeLevelStreamingPersistent);

simulated function GetAimFrictionExtent(out float Width, out float Height, out Vector Center)
{
	// End:0x2C
	if(bCanBeFrictionedTo)
	{
		GetBoundingCylinder(Width, Height);		
	}
	else
	{
		Width = 0.0000000;
		Height = 0.0000000;
	}
	Center = Location;
	//return;	
}

simulated function GetAimAdhesionExtent(out float Width, out float Height, out Vector Center)
{
	// End:0x2C
	if(bCanBeAdheredTo)
	{
		GetBoundingCylinder(Width, Height);		
	}
	else
	{
		Width = 0.0000000;
		Height = 0.0000000;
	}
	Center = Location;
	//return;	
}

event bool PlayParticleEffect(const AnimNotify_PlayParticleEffect AnimNotifyData)
{
	// End:0x60
	if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
	{
		LogInternal("(Actor): PlayParticleEffect on dedicated server!");
		return true;
	}
	return false;
	//return ReturnValue;	
}

event bool CreateForceField(const AnimNotify_ForceField AnimNotifyData)
{
	return false;
	//return ReturnValue;	
}

event TrailsNotify(const AnimNotify_Trails AnimNotifyData)
{
	//return;	
}

event TrailsNotifyTick(const AnimNotify_Trails AnimNotifyData)
{
	//return;	
}

event TrailsNotifyEnd(const AnimNotify_Trails AnimNotifyData)
{
	//return;	
}

// Export UActor::execGetAnimTrailParticleSystem(FFrame&, void* const)
native function ParticleSystem GetAnimTrailParticleSystem(const AnimNotify_Trails AnimNotifyData);

// Export UActor::execSupportsKismetModification(FFrame&, void* const)
native final function bool SupportsKismetModification(SequenceOp AskingOp, out string Reason);

simulated event AnimTreeUpdated(SkeletalMeshComponent SkelMesh)
{
	//return;	
}

simulated event PostDemoRewind()
{
	//return;	
}

simulated event ReplicationEnded()
{
	//return;	
}

// Export UActor::execGetAvoidanceVector(FFrame&, void* const)
native final function Vector GetAvoidanceVector(const out array<Actor> Obstacles, Vector GoalLocation, float CollisionRadius, float MaxSpeed, optional int NumSamples = 8, optional float VelocityStepRate = 0.1000000, optional float MaxTimeTilOverlap = 1.0000000);

// Export UActor::execWillOverlap(FFrame&, void* const)
native final function bool WillOverlap(Vector PosA, Vector VelA, Vector PosB, Vector VelB, float StepSize, float Radius, out float Time);

// Export UActor::execShouldBeHiddenBySHOW_NavigationNodes(FFrame&, void* const)
native function bool ShouldBeHiddenBySHOW_NavigationNodes();

function bool IsMobileTouchEnabled()
{
	return bEnableMobileTouch && bCollideActors;
	//return ReturnValue;	
}

event bool OnMobileTouch(PlayerController InPC, Vector2D TouchLocation)
{
	TriggerEventClass(Class'Engine.SeqEvent_MobileTouch', InPC, 0);
	return true;
	//return ReturnValue;	
}

// Export UActor::execGetActorMetrics(FFrame&, void* const)
native simulated function int GetActorMetrics(Actor.EActorMetricsType MetricsType);

// Export UActor::execGetActorSpriteComponent(FFrame&, void* const)
native function SpriteComponent GetActorSpriteComponent();

// Export UActor::execGetPawnViewLocation(FFrame&, void* const)
native simulated event Vector GetPawnViewLocation();

// Export UActor::execGetNavAdjustedLocation(FFrame&, void* const)
native function Vector GetNavAdjustedLocation(Vector pathOrigin, optional float radiusScale = 1.1000000);

// Export UActor::execIsInvisible(FFrame&, void* const)
native function bool IsInvisible();

simulated function float GetCollisionRadius()
{
	return 0.0000000;
	//return ReturnValue;	
}

defaultproperties
{
	DrawScale=1.0000000
	DrawScale3D=(X=1.0000000,Y=1.0000000,Z=1.0000000)
	CustomTimeDilation=1.0000000
	Role=ENetRole.ROLE_Authority
	CollisionType=ECollisionType.COLLIDE_NoCollision
	ReplicatedCollisionType=ECollisionType.None
	bPushedByEncroachers=true
	bRouteBeginPlayEvenIfStatic=true
	bCanStepUpOn=true
	bReplicateMovement=true
	bAllowFluidSurfaceInteraction=true
	bSkipAttachedMoves=true
	bMovable=true
	bJustTeleported=true
	bEditable=true
	NetUpdateFrequency=100.0000000
	NetPriority=1.0000000
	MessageClass=Class'Engine.LocalMessage'
	SupportedEvents[0]=Class'Engine.SeqEvent_Touch'
	SupportedEvents[1]=Class'Engine.SeqEvent_Destroyed'
	SupportedEvents[2]=Class'Engine.SeqEvent_TakeDamage'
	SupportedEvents[3]=Class'Engine.SeqEvent_HitWall'
	SupportedEvents[4]=Class'Engine.SeqEvent_AnimNotify'
	SupportedEvents[5]=Class'Engine.SeqEvent_MobileTouch'
}