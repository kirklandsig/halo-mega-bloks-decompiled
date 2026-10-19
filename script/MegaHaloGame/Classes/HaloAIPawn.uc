class HaloAIPawn extends HaloPawn
	config(Game);

enum EnemySfx
{
	SfxSeeEnemy,                    // 0
	SfxThreaten,                    // 1
	SfxReload,                      // 2
	SfxRetreat,                     // 3
	SfxPain,                        // 4
	SfxPainFall,                    // 5
	SfxDie,                         // 6
	SfxGrenadeDodge,                // 7
	SfxRoadkillDodge,               // 8
	SfxFlee,                        // 9
	SfxGrenadeStuck,                // 10
	SfxTakeDown,                    // 11
	EnemySfx_MAX                    // 12
};

struct DeathBehavior
{
	var const name DamageTypeName;
	var const name DeathAnimName;
	var const float DistanceAnimThreshold;
	var const bool bIsDirectional;
	var const float AnimHitDirection;
	var const bool bSnapDirection;
	var const float GibHealthThreshold;
	var const float MinimumDeathAnimRate;
	var const float MaximumDeathAnimRate;
	var Rotator rDirection;

	structdefaultproperties
	{
		DamageTypeName="None"
		DeathAnimName="None"
		DistanceAnimThreshold=0.0000000
		bIsDirectional=false
		AnimHitDirection=0.0000000
		bSnapDirection=false
		GibHealthThreshold=0.0000000
		MinimumDeathAnimRate=0.8000000
		MaximumDeathAnimRate=1.2000000
		rDirection=(Pitch=0,Yaw=0,Roll=0)
	}
};

var float RotationSpeed;
var Class<HaloWeapon> DefaultWeapon;
var float DamageScale;
var int Rank;
var UTVehicle AttemptToEnter;
var int SeatToEnter;
var UDKVehicleBase AttemptToExit;
var AkEvent EnemyAkEvents[12];
var float CongratsDistance;
var int DefaultGrenadeCountMax;
var float DefaultGrenadeChance;
var Class<DamageType> LastDamageType;
var float TetherDistance;
var bool DoingChargedShot;
var bool IsWeaponReady;
var bool IsLastBurst;
var bool bShouldGib;
var float FiringAnimBlendTime;
var name CurrentDeathAnimName;
var float DeathAnimRate;
var Vector GibHitLoc;
var array<DeathBehavior> DeathBehaviors;
var export editinline HaloCameraEncounterTargetableComponent CameraEncounterTargetableComponent;

function PlayEnemyAkEvent(AkEvent EventName)
{
	// End:0x28
	if(EventName != none)
	{
		PlayAkEvent(EventName);
	}
	//return;	
}

function PlayEnemySfx(HaloAIPawn.EnemySfx SFX)
{
	PlayEnemyAkEvent(EnemyAkEvents[int(SFX)]);
	//return;	
}

simulated function TakeFallingDamage()
{
	super.TakeFallingDamage();
	PlayEnemySfx(5);
	//return;	
}

simulated event NotifyDodgingThreat(CCSBlackboard.EThreatType threat)
{
	switch(threat)
	{
		// End:0x27
		case 1:
			PlayEnemySfx(7);
			// End:0x41
			break;
		// End:0x3B
		case 2:
			PlayEnemySfx(8);
			// End:0x41
			break;
		// End:0xFFFF
		default:
			// End:0x41
			break;
			break;
	}
	//return;	
}

simulated event NotifyBecameThreatened()
{
	PlayEnemySfx(1);
	//return;	
}

simulated event NotifyGrenadeStuck()
{
	PlayEnemySfx(10);
	//return;	
}

simulated function NotifyTrap(int Type, bool bEntered, optional bool bBroadcast = false, optional float broadcastDist = 5000.0000000)
{
	// End:0xE9
	if(Type == 1)
	{
		// End:0x8B
		if(bEntered)
		{
			CCSController(Controller).NotifyEvent(EventBroadcastClass, 3, Location);
			// End:0x88
			if(bBroadcast)
			{
				BroadcastEvent(3, broadcastDist);
			}			
		}
		else
		{
			CCSController(Controller).NotifyEvent(EventBroadcastClass, 4, Location);
			// End:0xE9
			if(bBroadcast)
			{
				BroadcastEvent(4, broadcastDist);
			}
		}
	}
	//return;	
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local Class<HaloDamageType> HaloDamageType;

	HaloDamageType = Class<HaloDamageType>(DamageType);
	// End:0x83
	if((Damage <= Health) && (HaloDamageType == none) || !HaloDamageType.default.Staggers)
	{
		Momentum = vect(0.0000000, 0.0000000, 0.0000000);
	}
	super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	// End:0x127
	if(CCSController(Controller) != none)
	{
		CCSController(Controller).HaloNotifyTakeHit(InstigatedBy, Damage, DamageCauser);
	}
	LastDamageType = DamageType;
	// End:0x155
	if(Health < 0)
	{
		PlayEnemySfx(6);
	}
	//return;	
}

function bool HandleHitReaction(int Damage, Class<DamageType> DamageType, Vector HitLocation, Vector Momentum)
{
	local Class<HaloDamageType> HaloDamageType;

	PlayEnemySfx(4);
	// End:0x3F
	if(super.HandleHitReaction(Damage, DamageType, HitLocation, Momentum))
	{
		return true;
	}
	HaloDamageType = Class<HaloDamageType>(DamageType);
	// End:0x98
	if(HaloDamageType != none)
	{
		// End:0x98
		if(HaloDamageType.default.Staggers)
		{
			Stagger();
			return true;
		}
	}
	Flinch();
	return true;
	//return ReturnValue;	
}

function Stagger()
{
	IsWeaponReady = false;
	// End:0x4E
	if(CCSController(Controller) != none)
	{
		CCSController(Controller).Staggered = true;
	}
	//return;	
}

simulated event PostBeginPlay()
{
	local int I, Angle;

	super.PostBeginPlay();
	CreateDefaultInventory();
	LastDamageType = none;
	I = 0;
	J0x2A:

	// End:0x170 [Loop If]
	if(I < DeathBehaviors.Length)
	{
		// End:0x162
		if(DeathBehaviors[I].bIsDirectional)
		{
			Angle = int(DeathBehaviors[I].AnimHitDirection * 32768.0000000) / 180;
			DeathBehaviors[I].rDirection.Yaw = Angle;
			DeathBehaviors[I].rDirection.Pitch = 0;
			DeathBehaviors[I].rDirection.Roll = 0;
		}
		++I;
		// [Loop Continue]
		goto J0x2A;
	}
	CurrentDeathAnimName = 'None';
	IsWeaponReady = false;
	//return;	
}

simulated function Tick(float Delta)
{
	local bool EnteredVehicle;

	super.Tick(Delta);
	// End:0xCF
	if((AttemptToEnter != none) && SeatToEnter != -1)
	{
		// End:0x74
		if(SeatToEnter == 0)
		{
			EnteredVehicle = AttemptToEnter.DriverEnter(self);			
		}
		else
		{
			EnteredVehicle = AttemptToEnter.PassengerEnter(self, SeatToEnter);
		}
		// End:0xCF
		if(EnteredVehicle)
		{
			AttemptToEnter = none;
			SeatToEnter = -1;
		}
	}
	// End:0x109
	if(AttemptToExit != none)
	{
		AttemptToExit.DriverLeave(true);
		AttemptToExit = none;
	}
	SetRotation(RInterpTo(Rotation, DesiredRotation, Delta, RotationSpeed, true));
	// End:0x183
	if((Health > 0) && CameraEncounterTargetableComponent != none)
	{
		CameraEncounterTargetableComponent.Tick(Delta);
	}
	//return;	
}

function CreateDefaultInventory()
{
	local HaloPlayerInventoryManager invMgr;

	CreateInventory(DefaultWeapon, false);
	SetSwitch('Weapon_Type', HaloWeapon(Weapon).akWeaponType);
	// End:0x9B
	if((DefaultGrenadeCountMax > 0) && DefaultGrenadeChance > 0.0000000)
	{
		// End:0x9B
		if(FRand() < DefaultGrenadeChance)
		{
			AddPlasmaGrenadesToInventory(Rand(DefaultGrenadeCountMax) + 1, false);
		}
	}
	// End:0x10B
	if(Instigator != none)
	{
		invMgr = HaloPlayerInventoryManager(Instigator.InvManager);
		// End:0x10B
		if(invMgr != none)
		{
			invMgr.bDropGrenadesOnDeath = true;
		}
	}
	//return;	
}

function bool NeedToTurn(Vector targ)
{
	local Vector LookDir, AimDir;

	LookDir = Vector(Rotation);
	LookDir.Z = 0.0000000;
	LookDir = Normal(LookDir);
	AimDir = targ - Location;
	AimDir.Z = 0.0000000;
	AimDir = Normal(AimDir);
	return (LookDir Dot AimDir) < 0.9300000;
	//return ReturnValue;	
}

function bool LastDamageSourceWasPlayer()
{
	return (LastDamageType != none) && LastDamageType.IsA('HaloDamageType_Turret');
	//return ReturnValue;	
}

function MeleeContact()
{
	MeleeTarget = none;
	// End:0x57
	if(Controller.Enemy != none)
	{
		MeleeTarget = Controller.Enemy;
	}
	super.MeleeContact();
	//return;	
}

simulated function PlayFiringAnimation(optional bool charge = false, optional bool lastShot = false)
{
	DoingChargedShot = charge;
	IsLastBurst = lastShot;
	// End:0x5B
	if(IsInState('Firing'))
	{
		NetworkGotoState('Firing', true);		
	}
	else
	{
		NetworkGotoState('ReadyWeapon');
	}
	//return;	
}

simulated function PullTrigger()
{
	StartFire(0);
	SetIsFiring(true);
	//return;	
}

simulated function ReleaseTrigger()
{
	StopFire(0);
	SetIsFiring(false);
	//return;	
}

simulated function AltPullTrigger()
{
	StartFire(1);
	SetIsFiring(true);
	//return;	
}

simulated function AltReleaseTrigger()
{
	StopFire(1);
	SetIsFiring(false);
	//return;	
}

function bool IsFiring()
{
	return bIsFiring;
	//return ReturnValue;	
}

simulated function PlayDying(Class<DamageType> DamageType, Vector HitLoc, optional Controller Killer)
{
	local Class<HaloDamageType> HDT;
	local bool bAlwaysGib;
	local int I;
	local float MyGibHealthThreshold;
	local Vector HitVec;
	local float fKillerDistanceSq;
	local bool bIsDirectional;
	local float DistanceAnimThreshold, BestDot, thisdot;
	local Rotator bestrot, thisrot;
	local bool bSnapDirection;
	local HaloAIMarinePawn marine;
	local array<HaloAIMarinePawn> friendlies;

	// End:0x35
	if(bIsKnockedDown)
	{
		super(UTPawn).PlayDying(DamageType, HitLoc, Killer);
		return;
	}
	// End:0x29E
	if((Killer != none) && Killer.Pawn != none)
	{
		fKillerDistanceSq = VSizeSq(Location - Killer.Pawn.Location);
		// End:0x17C
		if(HaloAIMarinePawn(Killer.Pawn) != none)
		{
			marine = HaloAIMarinePawn(Killer.Pawn);
			// End:0x179
			if(marine.KillSoundEvent != none)
			{
				marine.PlayAkEvent(marine.KillSoundEvent);
			}			
		}
		else
		{
			// End:0x29B
			if((HaloPlayerPawnController(Killer) != none) && HaloAIMarinePawn(self) == none)
			{
				// End:0x227
				foreach WorldInfo.AllPawns(Class'MegaHaloGame.HaloAIMarinePawn', marine, Location, CongratsDistance)
				{
					// End:0x226
					if(marine.CongratsSoundEvent != none)
					{
						friendlies.AddItem(marine);
					}					
				}				
				// End:0x29B
				if(friendlies.Length > 0)
				{
					marine = friendlies[Rand(friendlies.Length)];
					marine.PlayAkEvent(marine.CongratsSoundEvent);
				}
			}
		}		
	}
	else
	{
		fKillerDistanceSq = 0.0000000;
	}
	HitVec = ((!IsZero(HitLoc)) ? HitLoc - Location : HitVec);
	HitVec.Z = 0.0000000;
	HDT = Class<HaloDamageType>(DamageType);
	bAlwaysGib = ((HDT == none) ? false : HDT.default.bAlwaysGibs);
	MyGibHealthThreshold = float(GibHealthThreshold);
	CurrentDeathAnimName = 'None';
	bIsDirectional = false;
	bSnapDirection = false;
	DeathAnimRate = 0.8000000 + (FRand() * (1.2000000 - 0.8000000));
	I = 0;
	J0x3CD:

	// End:0x929 [Loop If]
	if(I < DeathBehaviors.Length)
	{
		// End:0x45F
		if(bIsDirectional)
		{
			// End:0x45F
			if((CurrentDeathAnimName != DeathBehaviors[I].DamageTypeName) || DeathBehaviors[I].DistanceAnimThreshold != DistanceAnimThreshold)
			{
				// [Explicit Break]
				goto J0x929;
			}
		}
		// End:0x91B
		if(((DeathBehaviors[I].DamageTypeName == 'None') || DamageType.Class.Name == DeathBehaviors[I].DamageTypeName) && fKillerDistanceSq >= (DeathBehaviors[I].DistanceAnimThreshold * DeathBehaviors[I].DistanceAnimThreshold))
		{
			DeathAnimRate = DeathBehaviors[I].MinimumDeathAnimRate + (FRand() * (DeathBehaviors[I].MaximumDeathAnimRate - DeathBehaviors[I].MinimumDeathAnimRate));
			// End:0x664
			if(!DeathBehaviors[I].bIsDirectional)
			{
				MyGibHealthThreshold = DeathBehaviors[I].GibHealthThreshold;
				CurrentDeathAnimName = DeathBehaviors[I].DeathAnimName;				
			}
			else
			{
				// End:0x7D0
				if(!bIsDirectional)
				{
					bIsDirectional = true;
					MyGibHealthThreshold = DeathBehaviors[I].GibHealthThreshold;
					CurrentDeathAnimName = DeathBehaviors[I].DeathAnimName;
					DistanceAnimThreshold = DeathBehaviors[I].DistanceAnimThreshold;
					bestrot = DeathBehaviors[I].rDirection;
					thisrot = Rotation + DeathBehaviors[I].rDirection;
					BestDot = HitVec Dot Vector(thisrot);
					bSnapDirection = DeathBehaviors[I].bSnapDirection;					
				}
				else
				{
					thisrot = Rotation + DeathBehaviors[I].rDirection;
					thisdot = HitVec Dot Vector(thisrot);
					// End:0x918
					if(thisdot > BestDot)
					{
						MyGibHealthThreshold = DeathBehaviors[I].GibHealthThreshold;
						CurrentDeathAnimName = DeathBehaviors[I].DeathAnimName;
						BestDot = thisdot;
						bestrot = DeathBehaviors[I].rDirection;
						bSnapDirection = DeathBehaviors[I].bSnapDirection;
					}
				}
			}
			// [Explicit Break]
			goto J0x929;
		}
		++I;
		// [Loop Continue]
		goto J0x3CD;
	}
	J0x929:

	// End:0x973
	if(bAlwaysGib || float(Health) < MyGibHealthThreshold)
	{
		bShouldGib = true;
		GibHitLoc = HitLoc;		
	}
	else
	{
		// End:0x9C0
		if(CurrentDeathAnimName != 'None')
		{
			bShouldGib = false;
			// End:0x9BD
			if(bSnapDirection)
			{
				SetRotation(Rotator(HitVec >> bestrot));
			}			
		}
		else
		{
			bShouldGib = false;
			StartRagdoll();
		}
	}
	GotoState('Dying');
	bReplicateMovement = false;
	bTearOff = true;
	//return;	
}

simulated function StartGib(Vector HitLoc)
{
	// End:0x19D
	if(bGibbed == false)
	{
		// End:0x8C
		if(GibPhysics != none)
		{
			Mesh.SetPhysicsAsset(GibPhysics);
			Mesh.PhysicsWeight = 1.0000000;
			Mesh.SetAnimTreeTemplate(none);
		}
		// End:0xC4
		if(GibMesh != none)
		{
			Mesh.SetSkeletalMesh(GibMesh);
		}
		bGibbed = true;
		Velocity += TearOffMomentum;
		StartRagdoll();
		Mesh.AddRadialImpulse(HitLoc, 200.0000000, VSize(TearOffMomentum) * GibMomentumScalar, 1, true);
		// End:0x19D
		if(Mesh.PhysicsAssetInstance != none)
		{
			Mesh.PhysicsAssetInstance.AddRandomSpinToEachBody(3.1415927, 6.0000000 * 3.1415927);
		}
	}
	//return;	
}

simulated function SetPawnRBChannelsForRagdoll(bool bTotalGibbing)
{
	// End:0xDD
	if(!bTotalGibbing)
	{
		Mesh.SetRBChannel(2);
		Mesh.SetRBCollidesWithChannel(0, true);
		Mesh.SetRBCollidesWithChannel(2, true);
		Mesh.SetRBCollidesWithChannel(3, true);
		Mesh.SetRBCollidesWithChannel(9, false);
		Mesh.SetRBCollidesWithChannel(15, true);		
	}
	else
	{
		Mesh.SetRBChannel(16);
		Mesh.SetRBCollidesWithChannel(0, true);
		Mesh.SetRBCollidesWithChannel(2, false);
		Mesh.SetRBCollidesWithChannel(3, false);
		Mesh.SetRBCollidesWithChannel(9, false);
		Mesh.SetRBCollidesWithChannel(15, true);
	}
	//return;	
}

simulated function StartRagdoll()
{
	// End:0x19
	if(int(Physics) == int(10))
	{
		SetPhysics(2);
	}
	CurrentWeaponAttachmentClass = none;
	WeaponAttachmentChanged();
	Mesh.MinDistFactorForKinematicUpdate = 0.0000000;
	SetPawnRBChannelsForRagdoll(bGibbed);
	Mesh.ForceSkelUpdate();
	Mesh.SetTickGroup(2);
	PreRagdollCollisionComponent = CollisionComponent;
	CollisionComponent = Mesh;
	CylinderComponent.SetActorCollision(false, false);
	Mesh.SetActorCollision(true, true);
	Mesh.SetTraceBlocking(true, true);
	SetPhysics(10);
	Mesh.PhysicsWeight = 1.0000000;
	// End:0x19D
	if(Mesh.bNotUpdatingKinematicDueToDistance)
	{
		Mesh.UpdateRBBonesFromSpaceBases(true, true);
	}
	Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
	Mesh.bUpdateKinematicBonesFromAnimation = false;
	Mesh.SetRBLinearVelocity(Velocity, false);
	Mesh.SetTranslation(vect(0.0000000, 0.0000000, 1.0000000) * Mesh.Translation.Z);
	Mesh.ScriptRigidBodyCollisionThreshold = MaxFallSpeed;
	Mesh.SetNotifyRigidBodyCollision(true);
	Mesh.WakeRigidBody();
	bReadyToFade = true;
	//return;	
}

function CalculateTossDirection(out Vector tossDirection, const float TossSpeed, const float Gravity, const Vector End, const Vector Start)
{
	local float Range, Angle;
	local Vector Trace, horzTrace;
	local Rotator Rot;

	Trace = End - Start;
	horzTrace = Trace;
	horzTrace.Z = 0.0000000;
	Range = VSize(horzTrace);
	Angle = Asin((((Range * Abs(Gravity)) / TossSpeed) / (2.0000000 * TossSpeed)) * 2.0000000) / 2.0000000;
	Rot = Rotator(horzTrace);
	Rot.Pitch = int((Angle * 10430.3779297) + float(Rotator(Trace).Pitch));
	Rot = CCSController(Controller).GetAdjustedGrenadeAim(Rot);
	tossDirection = Vector(Rot);
	//return;	
}

function bool CheckForLedgeGrab()
{
	return false;
	//return ReturnValue;	
}

state ReadyWeapon
{
	event BeginState(name PrevStateName)
	{
		local HaloWeapon W;
		local name AnimName;
		local float AnimTime;

		W = HaloWeapon(Weapon);
		// End:0x56
		if(W != none)
		{
			AnimName = W.ReadyPawnAnimName;			
		}
		else
		{
			AnimName = Class'MegaHaloGame.HaloWeapon'.default.ReadyPawnAnimName;
		}
		AnimTime = PlayCustomAnimation(AnimName, false,,,, FiringAnimBlendTime, FiringAnimBlendTime);
		// End:0xEA
		if(AnimTime > 0.0000000)
		{
			SetTimer(AnimTime - FiringAnimBlendTime, false, 'OnAnimDone');			
		}
		else
		{
			LogInternal(("WARNING: Readying animation" @ string(AnimName)) @ "failed.");
			OnAnimDone();
		}
		//return;		
	}

	function OnAnimDone()
	{
		IsWeaponReady = true;
		NetworkGotoState('Firing');
		//return;		
	}
	stop;	
}

state RelaxWeapon
{
	event BeginState(name PrevStateName)
	{
		local HaloWeapon W;
		local name AnimName;
		local float AnimTime;

		StopFire(0);
		W = HaloWeapon(Weapon);
		// End:0x62
		if(W != none)
		{
			AnimName = W.RelaxPawnAnimName;			
		}
		else
		{
			AnimName = Class'MegaHaloGame.HaloWeapon'.default.RelaxPawnAnimName;
		}
		AnimTime = PlayCustomAnimation(AnimName, false,,,, FiringAnimBlendTime, FiringAnimBlendTime);
		// End:0xF6
		if(AnimTime > 0.0000000)
		{
			SetTimer(AnimTime - FiringAnimBlendTime, false, 'OnAnimDone');			
		}
		else
		{
			LogInternal(("WARNING: Relaxing animation" @ string(AnimName)) @ "failed.");
			OnAnimDone();
		}
		//return;		
	}

	function OnAnimDone()
	{
		IsWeaponReady = false;
		NetworkGotoState('None');
		//return;		
	}
	stop;	
}

state Firing
{
	event BeginState(name PrevStateName)
	{
		local HaloWeapon W;
		local name AnimName;
		local float AnimTime;

		SetIsFiring(true);
		W = HaloWeapon(Weapon);
		// End:0x99
		if(DoingChargedShot)
		{
			// End:0x6E
			if(W != none)
			{
				AnimName = W.FireChargedPawnAnimName;				
			}
			else
			{
				AnimName = Class'MegaHaloGame.HaloWeapon'.default.FireChargedPawnAnimName;
			}			
		}
		else
		{
			// End:0xD3
			if(W != none)
			{
				AnimName = W.FirePawnAnimName;				
			}
			else
			{
				AnimName = Class'MegaHaloGame.HaloWeapon'.default.FirePawnAnimName;
			}
		}
		AnimTime = PlayCustomAnimation(AnimName, false,,,, FiringAnimBlendTime, FiringAnimBlendTime);
		// End:0x167
		if(AnimTime > 0.0000000)
		{
			SetTimer(AnimTime - FiringAnimBlendTime, false, 'OnAnimDone');			
		}
		else
		{
			LogInternal(("WARNING: Firing animation" @ string(AnimName)) @ "failed.");
			OnAnimDone();
		}
		//return;		
	}

	event EndState(name NextStateName)
	{
		SetIsFiring(false);
		//return;		
	}

	function OnAnimDone()
	{
		// End:0x4B
		if(CCSController(Controller) != none)
		{
			CCSController(Controller).NotifyBurstFinished(Weapon, 0);
		}
		// End:0x6F
		if(IsLastBurst)
		{
			NetworkGotoState('RelaxWeapon');			
		}
		else
		{
			global.StopFire(0);
			global.StopFire(1);
		}
		//return;		
	}
	stop;	
}

simulated state Dying
{
	simulated event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
	{
		local float MyGibHealthThreshold, fKillerDistanceSq;
		local int I;

		// End:0x213
		if(bGibbed == false)
		{
			Health -= Damage;
			// End:0x6D
			if(InstigatedBy != none)
			{
				fKillerDistanceSq = VSizeSq(Location - InstigatedBy.Location);				
			}
			else
			{
				fKillerDistanceSq = 0.0000000;
			}
			MyGibHealthThreshold = float(GibHealthThreshold);
			I = 0;
			J0x9C:

			// End:0x1E7 [Loop If]
			if(I < DeathBehaviors.Length)
			{
				// End:0x1D9
				if(((DeathBehaviors[I].DamageTypeName == 'None') || DamageType.Class.Name == DeathBehaviors[I].DamageTypeName) && fKillerDistanceSq >= (DeathBehaviors[I].DistanceAnimThreshold * DeathBehaviors[I].DistanceAnimThreshold))
				{
					MyGibHealthThreshold = DeathBehaviors[I].GibHealthThreshold;
					// [Explicit Break]
					goto J0x1E7;
				}
				++I;
				// [Loop Continue]
				goto J0x9C;
			}
			J0x1E7:

			// End:0x213
			if(float(Health) < MyGibHealthThreshold)
			{
				StartGib(HitLocation);
			}
		}
		//return;		
	}

	simulated event Tick(float DeltaTime)
	{
		local AnimNode FullBodyAnimNode;
		local AnimNodeBlend DeathBlend;

		FullBodyAnimNode = FullBodyAnimSlot;
		// End:0x8E
		if(!bGibbed && bShouldGib)
		{
			// End:0x65
			if(DeathTick == 0)
			{
				StartGib(GibHitLoc);
				DeathTick = -1;				
			}
			else
			{
				// End:0x8B
				if(DeathTick == -1)
				{
					StartGib(GibHitLoc);
				}
			}			
		}
		else
		{
			// End:0x172
			if((((CurrentDeathAnimName != 'None') && DeathAnimRate > 0.0000000) && !bGibbed) && !bShouldGib)
			{
				// End:0x12E
				if(DeathTick == 0)
				{
					PlayCustomAnimation(CurrentDeathAnimName,,,,,,, DeathAnimRate);
					DeathAnimRate = 0.0000000;
					DeathTick = -1;					
				}
				else
				{
					// End:0x172
					if(DeathTick == -1)
					{
						PlayCustomAnimation(CurrentDeathAnimName,,,,,,, DeathAnimRate);
						DeathAnimRate = 0.0000000;
					}
				}
			}
		}
		super.Tick(DeltaTime);
		DeathBlend = AnimNodeBlend(FullBodyAnimNode);
		// End:0x232
		if((((DeathTick >= 0) && CurrentDeathAnimName != 'None') && DeathBlend != none) && DeathBlend.Child2Weight > float(0))
		{
			Velocity *= (1.0000000 - DeathBlend.Child2Weight);
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	RotationSpeed=90000.0000000
	DefaultWeapon=Class'MegaHaloGame.HaloWeapon_StormRifle'
	DamageScale=1.0000000
	CongratsDistance=10000.0000000
	DefaultGrenadeCountMax=2
	TetherDistance=10000.0000000
	FiringAnimBlendTime=0.1000000
	DeathBehaviors[0]=(DamageTypeName="HaloDamageType_Crushed",DeathAnimName="None",DistanceAnimThreshold=100000002004087734272.0000000,bIsDirectional=false,AnimHitDirection=0.0000000,bSnapDirection=false,GibHealthThreshold=0.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	DeathBehaviors[1]=(DamageTypeName="HaloDamageType_Grenade",DeathAnimName="None",DistanceAnimThreshold=100000002004087734272.0000000,bIsDirectional=false,AnimHitDirection=0.0000000,bSnapDirection=false,GibHealthThreshold=-25.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	DeathBehaviors[2]=(DamageTypeName="HaloDamageType_PlasmaGrenade",DeathAnimName="None",DistanceAnimThreshold=100000002004087734272.0000000,bIsDirectional=false,AnimHitDirection=0.0000000,bSnapDirection=false,GibHealthThreshold=-25.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	DeathBehaviors[3]=(DamageTypeName="HaloDamageType_Melee",DeathAnimName="None",DistanceAnimThreshold=100000002004087734272.0000000,bIsDirectional=false,AnimHitDirection=0.0000000,bSnapDirection=false,GibHealthThreshold=-25.0000000,MinimumDeathAnimRate=0.8000000,MaximumDeathAnimRate=1.2000000,rDirection=(Pitch=0,Yaw=0,Roll=0))
	// Reference: HaloCameraEncounterTargetableComponent'MegaHaloGame.Default__HaloAIPawn.HaloCameraEncounterTargetableComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'HaloCameraEncounterTargetableComponent0'
	begin object name="HaloCameraEncounterTargetableComponent0" class=MegaHaloGame.HaloCameraEncounterTargetableComponent
	end object
	CameraEncounterTargetableComponent=HaloCameraEncounterTargetableComponent0
	// Reference: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloAIPawn.CollectibleBlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollectibleBlokSpawnerComponent'
	// Archetype: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloPawn.CollectibleBlokSpawnerComponent'
	begin object name="CollectibleBlokSpawnerComponent"
	end object
	CollectibleBlokSpawner=CollectibleBlokSpawnerComponent
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloAIPawn.targetableComponent'
	// Archetype: UDKTargetableComponent'MegaHaloGame.Default__HaloPawn.targetableComponent'
	begin object name="targetableComponent"
	end object
	MyTargetableComponent=targetableComponent
	// Reference: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloAIPawn.HaloTargetableComponent'
	// Archetype: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloPawn.HaloTargetableComponent'
	begin object name="HaloTargetableComponent"
	end object
	MyHaloTargetableComponent=HaloTargetableComponent
	TeamNum=2
	CurMeleeDesc=(Damage=100,DamageType=Class'MegaHaloGame.HaloDamageType_Melee',TargetRange=250.0000000,TargetAngle=90.0000000,DamageAngle=90.0000000,DamageRange=250.0000000,AnimName="Melee_Pistol",BlendInTime=0.1000000,BlendOutTime=0.2000000,bLockMovementInput=true)
	// Reference: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloAIPawn.NeedleTarget'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NeedleTarget'
	// Archetype: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloPawn.NeedleTarget'
	begin object name="NeedleTarget"
	end object
	NeedleTargetComponent=NeedleTarget
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloAIPawn.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloPawn.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloAIPawn.ForceFeedbackWaveformFall'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloPawn.ForceFeedbackWaveformFall'
	begin object name="ForceFeedbackWaveformFall"
	end object
	FallingDamageWaveForm=ForceFeedbackWaveformFall
	YellingDistance=1000.0000000
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.OverlayMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'OverlayMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloPawn.OverlayMeshComponent0'
	begin object name="OverlayMeshComponent0"
		ReplacementPrimitive=none
	end object
	OverlayMesh=OverlayMeshComponent0
	// Refer[0]ence: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloPawn.FirstPersonArms'
	begin object name="FirstPersonArms"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms.MeshSequenceA'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloPawn.FirstPersonArms.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms2'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloPawn.FirstPersonArms2'
	begin object name="FirstPersonArms2"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms2.MeshSequenceB'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloPawn.FirstPersonArms2.MeshSequenceB'
		begin object name="MeshSequenceB"
		end object
		Animations=MeshSequenceB
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms2
	// Reference: GwNavBotHandle'MegaHaloGame.Default__HaloAIPawn.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'MegaHaloGame.Default__HaloPawn.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	bCanCrouch=false
	bDisableBraking=true
	ControllerClass=Class'UDKBase.CCSController'
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.WPawnSkeletalMeshComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'WPawnSkeletalMeshComponent'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloPawn.WPawnSkeletalMeshComponent'
	begin object name="WPawnSkeletalMeshComponent"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloAIPawn.MyLightEnvironment'
	end object
	Mesh=WPawnSkeletalMeshComponent
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloAIPawn.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloPawn.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	Components[1]=none
	Components[2]=myGwNavBotHandle
	Components[3]=MyLightEnvironment
	Components[4]=WPawnSkeletalMeshComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloAIPawn.AmbientSoundComponent'
	// Archetype: UTAmbientSoundComponent'MegaHaloGame.Default__HaloPawn.AmbientSoundComponent'
	begin object name="AmbientSoundComponent"
	end object
	Components[5]=AmbientSoundComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloAIPawn.AmbientSoundComponent2'
	// Archetype: UTAmbientSoundComponent'MegaHaloGame.Default__HaloPawn.AmbientSoundComponent2'
	begin object name="AmbientSoundComponent2"
	end object
	Components[6]=AmbientSoundComponent2
	Components[7]=targetableComponent
	Components[8]=HaloTargetableComponent
	Components[9]=CollectibleBlokSpawnerComponent
	Components[10]=NeedleTarget
	Components[11]=HaloCameraEncounterTargetableComponent0
	Physics=EPhysics.PHYS_Falling
	CollisionComponent=CollisionCylinder
}