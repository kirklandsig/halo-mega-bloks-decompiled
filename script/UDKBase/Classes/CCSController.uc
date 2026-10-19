class CCSController extends GameAIController
	native
	config(Game);

struct native EnemyThreatInfo
{
	var Controller DamageInstigator;
	var Actor DamagingActor;
	var int TotalDamageAmount;

	structdefaultproperties
	{
		DamageInstigator=none
		DamagingActor=none
		TotalDamageAmount=0
	}
};

var CCSBTTree BehaviorTreeTemplate;
var export editinline GripBTScriptNodeCache ScriptNodeCache;
var export editinline GripBTInterface BTInterface;
var native Pointer Brain;
var native Pointer MeatPuppet;
var CCSSystemConfigData SystemConfig;
var CCSPawn CCSPawn;
var Actor TargetObj;
var NavigationHandle SecondaryNavigationHandle;
var int FireBurstCount;
var Actor AimingFocus;
var Rotator AimingRot;
var Rotator DesiredRot;
var byte CCSTeam;
var CCSBlackboard.EThreatType ThreatType;
var CCSBlackboard.EEventType EventType;
var export editinline CCSVisualizationComponent DebugVizComponent;
var array<Actor> NoiseMakers;
var bool HasHeardNoise;
var bool AimedAt;
var bool NewThreat;
var bool GrenadeStuck;
var bool Staggered;
var bool SuccessfulAttack;
var bool NewEvent;
var float HasHeardNoiseTimer;
var Vector ThreatLocation;
var Vector ThreatDirection;
var int AIHeatValue;
var float AccurateChance;
var float HorizontalInaccuracy;
var float VerticalInaccuracy;
var float HorizontalAccurateZone;
var float VerticalAccurateZone;
var float AccuracyYaw;
var float AccuracyPitch;
var float DeadZoneYaw;
var float DeadZonePitch;
var float RandomYaw;
var float RandomPitch;
var int BurstsBeforeRecalc;
var int AccuracyRecalcBurstCount;
var Vector EventLocation;
var Class<Actor> EventClass;
var array<EnemyThreatInfo> TotalEnemyThreat;
var float ThreatDecayTime;
var int ThreatDecayAmount;
var float ThreatOverpowerPct;
var float LeadingTimeScalar;

simulated function InitNavigationHandle()
{
	super(Controller).InitNavigationHandle();
	// End:0x31
	if(NavigationHandleClass != none)
	{
		SecondaryNavigationHandle = new (self) NavigationHandleClass;
	}
	//return;	
}

function Possess(Pawn aPawn, bool bVehicleTransition)
{
	super(Controller).Possess(aPawn, bVehicleTransition);
	// End:0x73
	if(BehaviorTreeTemplate != none)
	{
		CCSPawn = CCSPawn(aPawn);
		Pawn.bCanJump = false;
		TakePossession();
	}
	NewThreat = false;
	GrenadeStuck = false;
	//return;	
}

function UnPossess()
{
	// End:0x2F
	if(Pawn != none)
	{
		Pawn.SetTickIsDisabled(false);
	}
	super(Controller).UnPossess();
	//return;	
}

function OnAIMoveToActor(SeqAct_AIMoveToActor Action)
{
	local Actor destActor;

	destActor = Action.PickDestination(Pawn);
	// End:0x54
	if(destActor != none)
	{
		SetDesiredPosition(destActor);
	}
	//return;	
}

event NotifyAIMoveToActorCompleted()
{
	ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', false);
	//return;	
}

// Export UCCSController::execSetDesiredPosition(FFrame&, void* const)
native function SetDesiredPosition(Actor Actor);

// Export UCCSController::execActuallySetDesiredPosition(FFrame&, void* const)
native function ActuallySetDesiredPosition(Vector Position);

event bool CanFireAt(Actor Target)
{
	return LineOfSightTo(Target);
	//return ReturnValue;	
}

function bool CanFireAtFromLoc(Vector TraceStart, Pawn Target)
{
	return LineOfSightTo(Target, TraceStart);
	//return ReturnValue;	
}

// Export UCCSController::execCalcAccuracyAngles(FFrame&, void* const)
native function CalcAccuracyAngles(Actor Target);

function Vector GetAccuracy()
{
	local float Rand;
	local Vector V;

	V.Y = 0.0000000;
	Rand = FRand();
	// End:0x122
	if(Rand < AccurateChance)
	{
		Rand = Rand / AccurateChance;
		V.X = FRand() * Rand;
		V.Z = Rand - V.X;
		V.X *= DeadZoneYaw;
		V.Z *= DeadZonePitch;		
	}
	else
	{
		Rand = (Rand - AccurateChance) / (1.0000000 - AccurateChance);
		V.X = FRand() * Rand;
		V.Z = Rand - V.X;
		V.X *= (AccuracyYaw - DeadZoneYaw);
		V.X += DeadZoneYaw;
		V.Z *= (AccuracyPitch - DeadZonePitch);
		V.Z += DeadZonePitch;
	}
	Rand = FRand();
	// End:0x30A
	if(Rand >= 0.7500000)
	{
		V.X = -V.X;
		V.Z = -V.Z;		
	}
	else
	{
		// End:0x35B
		if(Rand >= 0.5000000)
		{
			V.Z = -V.Z;			
		}
		else
		{
			// End:0x3A9
			if(Rand >= 0.2500000)
			{
				V.X = -V.X;
			}
		}
	}
	return V;
	//return ReturnValue;	
}

event bool StartFireBurst(Pawn Target)
{
	local Vector accuracyVector;

	Enemy = Target;
	TargetObj = none;
	// End:0xB3
	if(AccuracyRecalcBurstCount >= BurstsBeforeRecalc)
	{
		CalcAccuracyAngles(Target);
		accuracyVector = GetAccuracy();
		RandomYaw = accuracyVector.X;
		RandomPitch = accuracyVector.Z;
		AccuracyRecalcBurstCount = 0;
	}
	FireBurstCount = 0;
	return true;
	//return ReturnValue;	
}

event bool StartFireBurstObj(Actor Target)
{
	local Vector accuracyVector;

	TargetObj = Target;
	Focus = Target;
	Enemy = none;
	// End:0xC6
	if(AccuracyRecalcBurstCount >= BurstsBeforeRecalc)
	{
		CalcAccuracyAngles(Target);
		accuracyVector = GetAccuracy();
		RandomYaw = accuracyVector.X;
		RandomPitch = accuracyVector.Z;
		AccuracyRecalcBurstCount = 0;
	}
	FireBurstCount = 0;
	return true;
	//return ReturnValue;	
}

function NotifyWeaponFired(Weapon W, byte FireMode)
{
	++AccuracyRecalcBurstCount;
	//return;	
}

function NotifyAimedAt(Weapon W)
{
	AimedAt = true;
	//return;	
}

function NotifyThreatened(Actor A, Vector Direction, CCSBlackboard.EThreatType newThreatType)
{
	NewThreat = true;
	ThreatLocation = A.Location;
	ThreatDirection = Direction;
	ThreatType = newThreatType;
	//return;	
}

function NotifyGrenadeStuck(Actor A)
{
	GrenadeStuck = true;
	Pawn.NotifyGrenadeStuck();
	//return;	
}

function NotifyStaggered()
{
	Staggered = true;
	//return;	
}

function NotifySuccessfulAttack()
{
	SuccessfulAttack = true;
	//return;	
}

function NotifyEvent(Class<Actor> C, CCSBlackboard.EEventType Type, Vector Loc)
{
	EventType = Type;
	NewEvent = true;
	EventLocation = Loc;
	EventClass = C;
	//return;	
}

event Tick(float Delta)
{
	super(Actor).Tick(Delta);
	//return;	
}

event bool StopFireBurst()
{
	Pawn.StopFiring();
	Focus = none;
	TargetObj = none;
	Enemy = none;
	return true;
	//return ReturnValue;	
}

function bool CanHitTarget(Actor Target)
{
	local Vector StartTrace, EndTrace;
	local array<ImpactInfo> ImpactList;
	local int Idx;

	// End:0x5F
	if((Pawn.Weapon == none) || Pawn.Weapon.bMeleeWeapon)
	{
		return false;
	}
	StartTrace = Pawn.GetWeaponStartTraceLocation();
	EndTrace = StartTrace + (Vector(Pawn.Weapon.GetAdjustedAim(StartTrace)) * Pawn.Weapon.GetTraceRange());	
	Pawn.Weapon.CalcWeaponFire(StartTrace, EndTrace, ImpactList);
	Idx = 0;
	J0x177:

	// End:0x1D3 [Loop If]
	if(Idx < ImpactList.Length)
	{
		// End:0x1C5
		if(ImpactList[Idx].HitActor == Target)
		{
			return true;
		}
		Idx++;
		// [Loop Continue]
		goto J0x177;
	}
	return false;
	//return ReturnValue;	
}

event bool FireWeapon(optional bool charge = false, optional bool lastShot = false, optional bool alwaysFire = false)
{
	local bool bFireSuccess;
	local Vector AimingLoc;

	bFireSuccess = true;
	// End:0x7A
	if((Pawn.Weapon == none) || Pawn.Weapon.bMeleeWeapon)
	{
		return false;
	}
	// End:0x9F
	if(TargetObj != none)
	{
		AimingFocus = TargetObj;		
	}
	else
	{
		AimingFocus = Enemy;
	}
	// End:0xD0
	if(AimingFocus == none)
	{
		bFireSuccess = false;		
	}
	else
	{
		AimingLoc = AimingFocus.GetPawnViewLocation();
		AimingRot = Rotator(AimingLoc - Pawn.GetWeaponStartTraceLocation());
		AimingRot.Roll = 0;
	}
	// End:0x2B3
	if(bFireSuccess)
	{
		// End:0x2B1
		if(!Pawn.IsFiring())
		{
			// End:0x2AC
			if(!Pawn.NeedToTurn(AimingFocus.Location) && (alwaysFire == true) || Pawn.CanAttack(AimingFocus))
			{
				// End:0x24E
				if(GwNavVehicle(Pawn) != none)
				{
					bFireSuccess = Pawn.BotFire(true);
					return bFireSuccess;
				}
				// End:0x273
				if(CCSPawn.IsPlayingCustomAnimation())
				{
					return true;
				}
				CCSPawn.PlayFiringAnimation(charge, lastShot);
				return true;				
			}
			else
			{
				return true;
			}			
		}
		else
		{
			return true;
		}
	}
	Pawn.StopFiring();
	return false;
	//return ReturnValue;	
}

event AimAt(Actor newFocus)
{
	local Vector AimingLoc;

	AimingFocus = newFocus;
	// End:0xA0
	if(AimingFocus != none)
	{
		AimingLoc = AimingFocus.GetPawnViewLocation();
		AimingRot = Rotator(AimingLoc - Pawn.GetWeaponStartTraceLocation());
		AimingRot.Roll = 0;
	}
	//return;	
}

event ActionStopFiring()
{
	AimingFocus = none;
	Pawn.StopFiring();
	//return;	
}

function NotifyBurstFinished(Weapon W, byte FireMode)
{
	FireBurstCount++;
	//return;	
}

function Rotator GetAdjustedAimFor(Weapon InWeapon, Vector projStart)
{
	local Rotator YawAdjust, PitchAdjust, AdjustedAim;
	local Vector targetVel, predictedPos, AimingLoc, muzzlePos;
	local float tarSpeed, projSpeed, AIprojSpeed, distanceToTarget, approxTravelTime;

	local byte FireMode;
	local Class<Projectile> projClass;

	AdjustedAim = AimingRot;
	// End:0x2EE
	if(Vehicle(Pawn) == none)
	{
		// End:0x2EE
		if(AimingFocus != none)
		{
			// End:0xB9
			if((UDKPawn(AimingFocus) != none) && UDKPawn(AimingFocus).Camo == 1.0000000)
			{
				AimingLoc = UDKPawn(AimingFocus).CamoVanishingPoint;				
			}
			else
			{
				AimingLoc = AimingFocus.GetPawnViewLocation();
			}
			targetVel = AimingFocus.Velocity;
			tarSpeed = VSize(targetVel);
			// End:0x2EE
			if(tarSpeed != 0.0000000)
			{
				muzzlePos = Pawn.GetWeaponStartTraceLocation();
				FireMode = Pawn.Weapon.CurrentFireMode;
				projClass = Pawn.Weapon.WeaponProjectiles[int(FireMode)];
				// End:0x2EE
				if(projClass != none)
				{
					projSpeed = projClass.default.Speed;
					AIprojSpeed = projClass.default.AISpeedOverride;
					// End:0x267
					if(AIprojSpeed > 0.0000000)
					{
						projSpeed = AIprojSpeed;
					}
					distanceToTarget = VSize(AimingLoc - muzzlePos);
					approxTravelTime = distanceToTarget / projSpeed;
					predictedPos = AimingLoc + (targetVel * approxTravelTime);
					AdjustedAim = Rotator(predictedPos - muzzlePos);
				}
			}
		}
	}
	YawAdjust.Yaw = int(RandomYaw * 182.0444031);
	PitchAdjust.Pitch = int(RandomPitch * 182.0444031);
	AdjustedAim = Rotator(Vector(AdjustedAim) >> YawAdjust);
	AdjustedAim = Rotator(Vector(AdjustedAim) >> PitchAdjust);
	return AdjustedAim;
	//return ReturnValue;	
}

function Rotator GetAdjustedGrenadeAim(Rotator accurateRotation)
{
	local Rotator YawAdjust, PitchAdjust, AdjustedAim;
	local Vector accuracyVector;

	accuracyVector = GetAccuracy();
	YawAdjust.Yaw = int(accuracyVector.X * 182.0444031);
	PitchAdjust.Pitch = int(accuracyVector.Z * 182.0444031);
	AdjustedAim = accurateRotation;
	AdjustedAim = Rotator(Vector(AdjustedAim) >> YawAdjust);
	AdjustedAim = Rotator(Vector(AdjustedAim) >> PitchAdjust);
	return AdjustedAim;
	//return ReturnValue;	
}

event bool FindNavMeshPath(Vector targetPos)
{
	NavigationHandle.PathConstraintList = none;
	NavigationHandle.PathGoalList = none;
	Class'Engine.NavMeshPath_Toward'.static.TowardPoint(NavigationHandle, targetPos);
	Class'Engine.NavMeshGoal_At'.static.AtLocation(NavigationHandle, targetPos);
	return NavigationHandle.FindPath();
	//return ReturnValue;	
}

event bool FindNavMeshDistance(Vector targetPos, out float Distance)
{
	// End:0x64
	if(SecondaryNavigationHandle.PointReachable(targetPos))
	{
		Distance = VSize(targetPos - Pawn.Location);
		return true;
	}
	SecondaryNavigationHandle.PathConstraintList = none;
	SecondaryNavigationHandle.PathGoalList = none;
	Class'Engine.NavMeshPath_Toward'.static.TowardPoint(SecondaryNavigationHandle, targetPos);
	Class'Engine.NavMeshGoal_At'.static.AtLocation(SecondaryNavigationHandle, targetPos);
	// End:0x159
	if(SecondaryNavigationHandle.FindPath())
	{
		Distance = SecondaryNavigationHandle.CalculatePathDistance();
		return true;
	}
	return false;
	//return ReturnValue;	
}

function DebugTrace(string Trace)
{
	LogInternal(Trace);
	//return;	
}

// Export UCCSController::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
	super(Controller).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
	UpdateThreatInformation(InstigatedBy, Damage);
	//return;	
}

function HaloNotifyTakeHit(Controller InstigatedBy, int Damage, optional Actor DamagingActor)
{
	UpdateThreatInformation(InstigatedBy, Damage, DamagingActor);
	//return;	
}

function UpdateThreatInformation(Controller EnemyController, int EnemyDamage, optional Actor DamagingActor)
{
	local int I;
	local bool Found;
	local EnemyThreatInfo enemyInfo;
	local editinline UDKTargetableComponent targetableComponent;
	local int ThreatOverpowerAmount;

	ThreatOverpowerAmount = int(float(EnemyDamage) * ThreatOverpowerPct);
	Found = false;
	I = 0;
	J0x3A:

	// End:0x3D6 [Loop If]
	if(I < TotalEnemyThreat.Length)
	{
		// End:0x15D
		if(EnemyController != none)
		{
			// End:0xD5
			if(TotalEnemyThreat[I].DamageInstigator == EnemyController)
			{
				TotalEnemyThreat[I].TotalDamageAmount += EnemyDamage;
				Found = true;				
			}
			else
			{
				TotalEnemyThreat[I].TotalDamageAmount -= ThreatOverpowerAmount;
				// End:0x15A
				if(TotalEnemyThreat[I].TotalDamageAmount < 0)
				{
					TotalEnemyThreat[I].TotalDamageAmount = 0;
				}
			}			
		}
		else
		{
			// End:0x3C8
			if((DamagingActor != none) && TotalEnemyThreat[I].DamagingActor != none)
			{
				// End:0x2CF
				if(DamagingActor.Owner != none)
				{
					// End:0x247
					if(DamagingActor.Owner == TotalEnemyThreat[I].DamagingActor)
					{
						TotalEnemyThreat[I].TotalDamageAmount += EnemyDamage;
						Found = true;						
					}
					else
					{
						TotalEnemyThreat[I].TotalDamageAmount -= ThreatOverpowerAmount;
						// End:0x2CC
						if(TotalEnemyThreat[I].TotalDamageAmount < 0)
						{
							TotalEnemyThreat[I].TotalDamageAmount = 0;
						}
					}					
				}
				else
				{
					// End:0x343
					if(DamagingActor == TotalEnemyThreat[I].DamagingActor)
					{
						TotalEnemyThreat[I].TotalDamageAmount += EnemyDamage;
						Found = true;						
					}
					else
					{
						TotalEnemyThreat[I].TotalDamageAmount -= ThreatOverpowerAmount;
						// End:0x3C8
						if(TotalEnemyThreat[I].TotalDamageAmount < 0)
						{
							TotalEnemyThreat[I].TotalDamageAmount = 0;
						}
					}
				}
			}
		}
		I++;
		// [Loop Continue]
		goto J0x3A;
	}
	// End:0x6DB
	if(!Found)
	{
		enemyInfo.DamageInstigator = EnemyController;
		enemyInfo.TotalDamageAmount = EnemyDamage;
		// End:0x4D9
		if((EnemyController == none) && DamagingActor != none)
		{
			// End:0x4B3
			if(DamagingActor.Owner != none)
			{
				enemyInfo.DamagingActor = DamagingActor.Owner;				
			}
			else
			{
				enemyInfo.DamagingActor = DamagingActor;
			}
		}
		// End:0x561
		if(enemyInfo.DamageInstigator != none)
		{
			targetableComponent = UDKTargetableComponent(enemyInfo.DamageInstigator.Pawn.GetComponentOfType(Class'UDKBase.UDKTargetableComponent'));			
		}
		else
		{
			// End:0x66E
			if(enemyInfo.DamagingActor != none)
			{
				// End:0x620
				if(enemyInfo.DamagingActor.Owner != none)
				{
					targetableComponent = UDKTargetableComponent(enemyInfo.DamagingActor.Owner.GetComponentOfType(Class'UDKBase.UDKTargetableComponent'));					
				}
				else
				{
					targetableComponent = UDKTargetableComponent(enemyInfo.DamagingActor.GetComponentOfType(Class'UDKBase.UDKTargetableComponent'));
				}
			}
		}
		// End:0x6DB
		if((targetableComponent != none) && int(targetableComponent.AITargetType) != int(targetableComponent.0))
		{
			TotalEnemyThreat[TotalEnemyThreat.Length] = enemyInfo;
		}
	}
	//return;	
}

function OnSetState(SeqAct_SetState Action)
{
	SetState(Action.StateName);
	//return;	
}

function OnRemoveState(SeqAct_RemoveState Action)
{
	RemoveState(Action.StateName);
	//return;	
}

function OnSetInitialCover(SeqAct_SetInitialCover Action)
{
	local Actor ActorItem;

	// End:0x40
	foreach Action.Actors(ActorItem)
	{
		SetInitialCover(ActorItem);		
	}	
	//return;	
}

function OnCCSTriggerEvent(SeqAct_CCSTriggerEvent Action)
{
	TriggerEvent(Action.EventType);
	//return;	
}

event CreateDebugVizComponent()
{
	DebugVizComponent = new (self) Class'UDKBase.CCSVisualizationComponent';
	AttachComponent(DebugVizComponent);
	//return;	
}

// Export UCCSController::execTakePossession(FFrame&, void* const)
native function TakePossession();

// Export UCCSController::execSetState(FFrame&, void* const)
native function SetState(string stateToSet);

// Export UCCSController::execRemoveState(FFrame&, void* const)
native function RemoveState(string stateToRemove);

// Export UCCSController::execSetInitialCover(FFrame&, void* const)
native function SetInitialCover(Actor localLink);

// Export UCCSController::execTriggerEvent(FFrame&, void* const)
native function TriggerEvent(string kismetEventType);

// Export UCCSController::execDisableBrain(FFrame&, void* const)
native function DisableBrain(bool Disable);

defaultproperties
{
	// Reference: GripBTScriptNodeCache'UDKBase.Default__CCSController.ScriptNodeCache0'
	begin object name="ScriptNodeCache0" class=Grip.GripBTScriptNodeCache
	end object
	ScriptNodeCache=ScriptNodeCache0
	// Reference: GripBTInterface'UDKBase.Default__CCSController.BTInterface0'
	begin object name="BTInterface0" class=Grip.GripBTInterface
	end object
	BTInterface=BTInterface0
	SystemConfig=(MaxAwareRadius=10000.0000000,MaxSightRadius=4300.0000000,MaxBehindSightRadius=400.0000000,MaxHearingRadius=4300.0000000,VisionCone=180.0000000,PassiveObjectiveWeight=-1.0000000,PassiveSecondaryWeight=-1.0000000,AggressiveMobileWeight=-1.0000000,AggressiveStationaryWeight=-1.0000000,CoverQueryRadius=5000.0000000,TargetSelection=ECCSTargetSelectionConfig.CCSTargetPlayer,Movement=ECCSMovementConfig.CCSMovementGwNav)
	CCSTeam=255
	AIHeatValue=10
	AccurateChance=1.0000000
	BurstsBeforeRecalc=5
	AccuracyRecalcBurstCount=5
	ThreatDecayTime=1.0000000
	ThreatDecayAmount=5
	ThreatOverpowerPct=0.1000000
	LeadingTimeScalar=3.0000000
	bSkipExtraLOSChecks=true
	bHidden=false
}