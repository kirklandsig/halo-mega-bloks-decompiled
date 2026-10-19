class HaloTurret extends UTVehicle
	abstract
	config(GwNavEngine)
	implements(HaloVehicleInterface,IHaloDeployable,HaloUpgradableInterface);

var GFxHaloMinimapHUD.PlayerPawnType PawnType;
var HaloWeapon_TargetDesignator.ETargetDesignatorCategory DeployableCategory;
var float AttackHorizontalRange;
var float AttackVerticalRange;
var float TargetInterpTime;
var float MannedFireSpread;
var float UnmannedFireSpread;
var float MaxBurstTime;
var float CurBurstTime;
var float CurBurstCD;
var float BurstCooldown;
var float AITargetingMaxAngle;
var bool ContinuousTracking;
var bool ShowTurretDebug;
var bool bSleepTurret;
var bool bTurretManable;
var bool IsMeshMaterialInstanceReady;
var name PawnMountAnimName;
var name PawnDismountAnimName;
var name YawPitchBoneName;
var export editinline HaloCollectibleBlokSpawnerComponent BlokSpawner;
var AkEvent DeathSoundEvent;
var name AkExplosionType;
var name AkExplosionSize;
var name AkObjectType;
var float LastAttackTime;
var float UpdateAITimer;
var float UpdateAIMaxTime;
var transient HaloPawn Target;
var array<PlayerController> EnteringPlayers;
var array<name> TurretControls;
var editinline array<editinline UDKSkelControl_TurretConstrained> TurretControllers;
var Rotator TurretRotation;
var int ViewYawMin;
var int ViewYawMax;
var name DeployableName;
var Actor DeployableBase;
var AnimNodeSlot TurretAnimNode;
var name TurretRecoilAnimName;
var name TurretAnimNodeName;
var HaloUpgrade Upgrade;
var int UpgradeXP;
var const localized string ManTurretMessage;
var export editinline HaloTargetableComponent_Vehicle HaloTargetableComponent;
var export editinline HaloNeedleTargetComponent NeedleTargetComponent;

replication
{
	// Pos:0x000
	if(bNetDirty)
		Target;

	// Pos:0x00A
	if(bNetDirty && !bNetOwner)
		TurretRotation;
}

simulated function InitializeTurrets()
{
	local int I;
	local UTSkelControl_TurretConstrained Turret;

	ViewPitchMin = 32768.0000000;
	ViewPitchMax = -32768.0000000;
	ViewYawMin = 32768;
	ViewYawMax = -32768;
	I = 0;
	J0x47:

	// End:0x2A3 [Loop If]
	if(I < TurretControls.Length)
	{
		Turret = UTSkelControl_TurretConstrained(Mesh.FindSkelControl(TurretControls[I]));
		// End:0x295
		if(Turret != none)
		{
			Turret.AssociatedSeatIndex = 0;
			TurretControllers[I] = Turret;
			Turret.InitTurret(Rotation, Mesh);
			ViewPitchMin = float(Min(int(ViewPitchMin), NormalizeRotAxis((Turret.MinAngle.PitchConstraint * 32768) / 180)));
			ViewPitchMax = float(Max(int(ViewPitchMax), NormalizeRotAxis((Turret.MaxAngle.PitchConstraint * 32768) / 180)));
			ViewYawMin = Min(ViewYawMin, NormalizeRotAxis((Turret.MinAngle.YawConstraint * 32768) / 180));
			ViewYawMax = Max(ViewYawMax, NormalizeRotAxis((Turret.MaxAngle.YawConstraint * 32768) / 180));
		}
		I++;
		// [Loop Continue]
		goto J0x47;
	}
	TurretRotation = Rotation;
	//return;	
}

simulated function Rotator GetAdjustedAim()
{
	local Vector StartLocation;
	local Rotator StartRotation;
	local float Width, Height;

	GetBarrelLocationAndRotation(0, StartLocation, StartRotation);
	GetBoundingCylinder(Width, Height);
	StartLocation -= (Vector(StartRotation) * Width);
	// End:0xD7
	if((Controller != none) && !Controller.IsA('CCSController'))
	{
		return Controller.GetAdjustedAimFor(Seats[0].Gun, StartLocation);
	}
	return StartRotation;
	//return ReturnValue;	
}

simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
	local int deltaViewYaw, deltaViewPitch;

	super.ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
	deltaViewYaw = NormalizeRotAxis(out_ViewRotation.Yaw - Rotation.Yaw);
	deltaViewYaw = Clamp(deltaViewYaw, ViewYawMin, ViewYawMax);
	out_ViewRotation.Yaw = NormalizeRotAxis(deltaViewYaw + Rotation.Yaw);
	deltaViewPitch = NormalizeRotAxis(out_ViewRotation.Pitch - Rotation.Pitch);
	deltaViewPitch = Clamp(deltaViewPitch, int(ViewPitchMin), int(ViewPitchMax));
	out_ViewRotation.Pitch = NormalizeRotAxis(deltaViewPitch + Rotation.Pitch);
	//return;	
}

simulated function UpdateTurrets(float DeltaTime)
{
	local int I;
	local Rotator NewRotation;
	local Vector TargetLocation;

	// End:0x4D
	if((Controller != none) && !Controller.IsA('CCSController'))
	{
		TurretRotation = GetAdjustedAim();		
	}
	else
	{
		// End:0xCA
		if((CalculateTargetLocation(TargetLocation, DeltaTime)) == true)
		{
			NewRotation = Rotator(TargetLocation - (GetEffectLocation(0)));
			TurretRotation = RInterpTo(TurretRotation, NewRotation, DeltaTime, TargetInterpTime);
		}
	}
	I = 0;
	J0xD5:

	// End:0x146 [Loop If]
	if(I < TurretControllers.Length)
	{
		// End:0x138
		if(TurretControllers[I] != none)
		{
			TurretControllers[I].DesiredBoneRotation = TurretRotation;
		}
		I++;
		// [Loop Continue]
		goto J0xD5;
	}
	//return;	
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	LastAttackTime = WorldInfo.TimeSeconds;
	CurBurstTime = 0.0000000;
	CurBurstCD = 0.0000000;
	UpgradeXP = 0;
	// End:0xDC
	if(HaloGameDefault(WorldInfo.Game) != none)
	{
		HaloGameDefault(WorldInfo.Game).GetUpgradeManager().AddUpgradable(self);
	}
	Mesh.WakeRigidBody();
	// End:0x12A
	if(HaloTargetableComponent != none)
	{
		HaloTargetableComponent.PostBeginPlay();
	}
	//return;	
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	// End:0x52
	if(TurretAnimNodeName != 'None')
	{
		TurretAnimNode = AnimNodeSlot(Mesh.FindAnimNode(TurretAnimNodeName));
	}
	//return;	
}

simulated event Destroyed()
{
	super.Destroyed();
	// End:0x38
	if(NeedleTargetComponent != none)
	{
		NeedleTargetComponent.OnOwnerDestroyed();
	}
	// End:0xB9
	if(HaloGameDefault(WorldInfo.Game) != none)
	{
		HaloGameDefault(WorldInfo.Game).GetUpgradeManager().RemoveUpgradable(self);
	}
	//return;	
}

simulated function bool CalculateTargetLocation(out Vector Loc, float DeltaTime)
{
	// End:0x39
	if(Target != none)
	{
		Loc = Target.Location;
		return true;
	}
	return false;
	//return ReturnValue;	
}

function CalculateTossVelocity(out Vector TossVelocity, const float tossDegrees, const float Gravity, const Vector End, const Vector Start)
{
	local float Range, Speed, Angle;
	local Vector Trace, horzTrace;
	local Rotator Rot;

	Angle = tossDegrees * 0.0174533;
	Trace = End - Start;
	horzTrace = Trace;
	horzTrace.Z = 0.0000000;
	Range = VSize(horzTrace);
	Speed = Sqrt(((Range * Abs(Gravity)) / Cos(Angle)) / (2.0000000 * Sin(Angle)));
	Rot = Rotator(horzTrace);
	Rot.Pitch = int(tossDegrees * 182.0444031);
	TossVelocity = Vector(Rot) * Speed;
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
	Angle = (90.0000000 * 0.0174533) - Abs(Angle);
	Rot = Rotator(horzTrace);
	Rot.Pitch = int((Angle * 10430.3779297) + float(Rotator(Trace).Pitch));
	tossDirection = Vector(Rot);
	//return;	
}

simulated event Tick(float DeltaTime)
{
	local HaloPawn HaloDriver;

	// End:0x151
	if((Health > 0) && !bHidden)
	{
		UpdateAITimer += DeltaTime;
		// End:0x13E
		if(int(Role) == int(ROLE_Authority))
		{
			// End:0xC0
			if(Seats[0].Gun.IsFiring())
			{
				CurBurstTime += DeltaTime;
				// End:0xBD
				if(CurBurstTime > MaxBurstTime)
				{
					CurBurstTime = MaxBurstTime;
				}				
			}
			else
			{
				CurBurstCD -= DeltaTime;
				// End:0xF4
				if(CurBurstCD < float(0))
				{
					CurBurstCD = 0.0000000;
				}
			}
			// End:0x13E
			if(!bSleepTurret && UpdateAITimer >= UpdateAIMaxTime)
			{
				UpdateAITimer = 0.0000000;
				UpdateAI(DeltaTime);
			}
		}
		UpdateTurrets(DeltaTime);
	}
	super(Actor).Tick(DeltaTime);
	HaloDriver = HaloPawn(Driver);
	// End:0x228
	if((HaloDriver != none) && HaloDriver.TurretAnimNode != none)
	{
		HaloDriver.TurretAnimNode.SetRotation(QuatToRotator(Mesh.GetBoneQuaternion(YawPitchBoneName)) - Rotation);
	}
	// End:0x23F
	if(ShowTurretDebug)
	{
		DisplayTurretDebug();
	}
	TickNeedleTargetComponent(DeltaTime);
	//return;	
}

simulated function DisplayTurretDebug()
{
	local Vector fireLoc, cylStart, cylEnd;
	local Rotator FireRot;

	GetBarrelLocationAndRotation(0, fireLoc, FireRot);
	cylStart = fireLoc;
	cylEnd = fireLoc;
	cylStart.Z -= AttackVerticalRange;
	cylEnd.Z += AttackVerticalRange;
	DrawDebugCylinder(cylStart, cylEnd, AttackHorizontalRange, 16, 255, 0, 0);
	//return;	
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local Vector fireLoc, cylStart, cylEnd;
	local Rotator FireRot;

	super(SVehicle).DisplayDebug(HUD, out_YL, out_YPos);
	GetBarrelLocationAndRotation(0, fireLoc, FireRot);
	cylStart = fireLoc;
	cylEnd = fireLoc;
	cylStart.Z -= AttackVerticalRange;
	cylEnd.Z += AttackVerticalRange;
	DrawDebugCylinder(cylStart, cylEnd, AttackHorizontalRange, 16, 255, 0, 0);
	//return;	
}

function UpdateAI(float DeltaTime)
{
	//return;	
}

simulated function bool SeatAvailable(int SeatIndex)
{
	return (Seats[SeatIndex].SeatPawn == none) || Seats[SeatIndex].SeatPawn.Controller == none;
	//return ReturnValue;	
}

simulated function bool CanEnterVehicle(Pawn P)
{
	// End:0x97
	if(((P.Controller != none) && HaloPlayerPawnController(P.Controller) != none) && HaloPlayerPawnController(P.Controller).bIsAimingTargetDesignator)
	{
		return false;
	}
	return super.CanEnterVehicle(P);
	//return ReturnValue;	
}

simulated function bool ShouldShowUseable(PlayerController PC, float Dist)
{
	local UTPlayerController UTPC;

	UTPC = UTPlayerController(PC);
	return (CanEnterVehicle(PC.Pawn)) && (UTPC.CheckVehicleToDrive(false) == self) || (bRequestedEntryWithFlag && UTPC.bJustFoundVehicle) && UTPlayerReplicationInfo(PC.PlayerReplicationInfo).bHasFlag;
	//return ReturnValue;	
}

simulated event PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
	local float Dist;
	local bool bShowUseable;
	local UTHUDBase HUD;

	HUD = UTHUDBase(PC.myHUD);
	Dist = VSize(CameraPosition - Location);
	EnteringPlayers.Length = 0;
	// End:0x45E
	if(!bPlayingSpawnEffect && (UTPawn(PC.Pawn) != none) || UTVehicle_Hoverboard(PC.Pawn) != none)
	{
		// End:0x3C8
		if(bShowUseable || ShouldShowUseable(PC, Dist))
		{
			bShowUseable = true;
			// End:0x273
			if(bRequestedEntryWithFlag && UTPlayerReplicationInfo(PC.PlayerReplicationInfo).bHasFlag)
			{
				HUD.DrawToolTip(Canvas, PC, "GBA_Use", Canvas.ClipX * 0.5000000, Canvas.ClipY * 0.6000000, DropFlagIconCoords.U, DropFlagIconCoords.V, DropFlagIconCoords.UL, DropFlagIconCoords.VL, Canvas.ClipY / float(720));				
			}
			else
			{
				// End:0x3AF
				if(bIsInverted && bCanFlip)
				{
					HUD.DrawToolTip(Canvas, PC, "GBA_Use", Canvas.ClipX * 0.5000000, Canvas.ClipY * 0.6000000, FlipToolTipIconCoords.U, FlipToolTipIconCoords.V, FlipToolTipIconCoords.UL, FlipToolTipIconCoords.VL, Canvas.ClipY / float(720));					
				}
				else
				{
					EnteringPlayers.AddItem(PC);
				}
			}			
		}
		else
		{
			// End:0x418
			if(!WorldInfo.GRI.GameClass.default.bTeamGame)
			{
				return;
			}
			// End:0x44F
			if(bRequestedEntryWithFlag)
			{
				UTPlayerController(PC).bJustFoundVehicle = false;
			}
			bRequestedEntryWithFlag = false;
		}		
	}
	else
	{
		// End:0x4AE
		if(!WorldInfo.GRI.GameClass.default.bTeamGame)
		{
			return;
		}
		// End:0x4E5
		if(bRequestedEntryWithFlag)
		{
			UTPlayerController(PC).bJustFoundVehicle = false;
		}
		bRequestedEntryWithFlag = false;
	}
	//return;	
}

simulated event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local CCSController aiAttackerController;
	local editinline UDKTargetableComponent targetableComponent;
	local HaloPawn damagerPawn;
	local Controller Killer;

	// End:0x11
	if(bHidden)
	{
		return;
	}
	// End:0x140
	if(HaloAIPawn(Driver) != none)
	{
		// End:0x81
		if(Driver.Health > Damage)
		{
			Driver.Health -= Damage;			
		}
		else
		{
			Killer = Driver.SetKillInstigator(InstigatedBy, DamageType);
			Driver.Health = 0;
			Driver.TearOffMomentum = Momentum;
			Driver.Died(Killer, DamageType, HitLocation);
		}
		return;
	}
	aiAttackerController = CCSController(InstigatedBy);
	targetableComponent = UDKTargetableComponent(GetComponentOfType(Class'UDKBase.UDKTargetableComponent'));
	// End:0x35B
	if(aiAttackerController != none)
	{
		// End:0x358
		if(aiAttackerController.Pawn != none)
		{
			damagerPawn = HaloPawn(aiAttackerController.Pawn);
			// End:0x358
			if(damagerPawn != none)
			{
				// End:0x358
				if(targetableComponent != none)
				{
					// End:0x259
					if(int(targetableComponent.AITargetType) == int(1))
					{
						Damage *= damagerPawn.PassiveObjectivePrejudice;						
					}
					else
					{
						// End:0x2AE
						if(int(targetableComponent.AITargetType) == int(2))
						{
							Damage *= damagerPawn.PassiveSecondaryPrejudice;							
						}
						else
						{
							// End:0x303
							if(int(targetableComponent.AITargetType) == int(3))
							{
								Damage *= damagerPawn.AggressiveStationaryPrejudice;								
							}
							else
							{
								// End:0x355
								if(int(targetableComponent.AITargetType) == int(4))
								{
									Damage *= damagerPawn.AggressiveMobilePrejudice;
								}
							}
						}
					}					
				}
			}
		}		
	}
	else
	{
		// End:0x531
		if(DamageCauser != none)
		{
			damagerPawn = HaloPawn(Projectile(DamageCauser).InstigatorController.Pawn);
			// End:0x52E
			if(damagerPawn != none)
			{
				// End:0x52B
				if(targetableComponent != none)
				{
					// End:0x42C
					if(int(targetableComponent.AITargetType) == int(1))
					{
						Damage *= damagerPawn.PassiveObjectivePrejudice;						
					}
					else
					{
						// End:0x481
						if(int(targetableComponent.AITargetType) == int(2))
						{
							Damage *= damagerPawn.PassiveSecondaryPrejudice;							
						}
						else
						{
							// End:0x4D6
							if(int(targetableComponent.AITargetType) == int(3))
							{
								Damage *= damagerPawn.AggressiveStationaryPrejudice;								
							}
							else
							{
								// End:0x528
								if(int(targetableComponent.AITargetType) == int(4))
								{
									Damage *= damagerPawn.AggressiveMobilePrejudice;
								}
							}
						}
					}					
				}				
			}			
		}
	}
	super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	SetSwitch('Surface', 'Concrete');
	SetRTPCValue('Impulse_Value', float(Min(Damage * 2, 100)));
	BlokSpawner.TryToThrowBloks((float(Health) / float(HealthMax)) * 100.0000000);
	SetSwitch('Object_Type', AkObjectType);
	// End:0x76F
	if(Health <= 0)
	{
		// End:0x653
		if(targetableComponent != none)
		{
			targetableComponent.BeginDeath();
		}
		SetCollision(false, false, true);
		Mesh.SetRBChannel(1);
		Mesh.SetBlockRigidBody(false);
		StartBurnOut();
		WorldInfo.MyEmitterPool.SpawnEmitter(ExplosionTemplate, Location);
		// End:0x76C
		if(((Health <= 0) && Seats.Length > 0) && Seats[0].Gun != none)
		{
			Seats[0].Gun.EndFire(0);
		}		
	}
	else
	{
		// End:0x7BD
		if(Damage > 1)
		{
			SetRTPCValue('Impulse_Value', float(Min(Damage * 2, 100)));
			PlayAkEvent(AkEvent'Objects.Play_Object_Impact');
		}
	}
	//return;	
}

simulated event BecomeViewTarget(PlayerController PC)
{
	super(Pawn).BecomeViewTarget(PC);
	// End:0x55
	if(UTPlayerController(PC) != none)
	{
		UTPlayerController(PC).bNoCrosshair = false;
	}
	//return;	
}

function bool Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
	local bool B;

	B = super.Died(Killer, DamageType, HitLocation);
	// End:0x75
	if(B)
	{
		// End:0x6B
		if(NeedleTargetComponent != none)
		{
			NeedleTargetComponent.OnDeath();
		}
		PlayDeathSound();
	}
	return B;
	//return ReturnValue;	
}

simulated function PlayDeathSound()
{
	// End:0xAD
	if(DeathSoundEvent != none)
	{
		SetSwitch('Explosion_Type', AkExplosionType);
		SetSwitch('Explosion_Size', AkExplosionSize);
		PlayAkEvent(AkEvent'Foley.Play_Explosion');
		SetSwitch('Object_Type', AkObjectType);
		SetRTPCValue('Impulse_Value', 100.0000000);
		PlayAkEvent(DeathSoundEvent);
	}
	//return;	
}

simulated function AttachDriver(Pawn P)
{
	AttachDriverToSeat(P, 0);
	//return;	
}

function AttachDriverToSeat(Pawn P, int SeatIndex)
{
	local HaloPawn HP;
	local name SeatBone;
	local Vector SeatOffset;

	HP = HaloPawn(P);
	// End:0xDE
	if(HP != none)
	{
		// End:0xA3
		if(Seats.Length > SeatIndex)
		{
			SeatBone = Seats[SeatIndex].SeatBone;
			SeatOffset = Seats[SeatIndex].SeatOffset;
		}
		HP.AttachToVehicle(self, SeatBone, SeatOffset, PawnMountAnimName);
	}
	//return;	
}

function AttachDriverNow(HaloPawn P)
{
	AttachDriver(P);
	//return;	
}

event bool DriverLeave(bool bForceLeave)
{
	local HaloPawn HaloDriver;
	local Rotator targRot;

	HaloDriver = HaloPawn(Driver);
	// End:0xB6
	if(HaloDriver != none)
	{
		targRot = QuatToRotator(Mesh.GetBoneQuaternion(YawPitchBoneName));
		HaloDriver.DriverLeaveTurret(PawnDismountAnimName, Controller, Rotation, targRot, Location);
		return true;
	}
	return super.DriverLeave(bForceLeave);
	//return ReturnValue;	
}

function DriverLeaveNow()
{
	DriverLeave(true);
	//return;	
}

function bool PlaceExitingDriver(optional Pawn ExitingDriver)
{
	local HaloPawn HaloDriver;

	// End:0x23
	if(ExitingDriver == none)
	{
		ExitingDriver = Driver;
	}
	// End:0x34
	if(ExitingDriver == none)
	{
		return false;
	}
	HaloDriver = HaloPawn(ExitingDriver);
	// End:0x84
	if(HaloDriver != none)
	{
		// End:0x84
		if(HaloDriver.PlaceExitingDriver(self))
		{
			return true;
		}
	}
	return FindAutoExit(ExitingDriver);
	//return ReturnValue;	
}

function SetMeshColor(LinearColor newColor)
{
	local int M;
	local MaterialInterface Mat;
	local MaterialInstanceConstant MIC;

	LogInternal((("SETTING MESH COLOR ON " $ string(Mesh.Name)) $ "  w/ X mats: ") $ string(Mesh.Materials.Length));
	M = 0;
	J0x7C:

	// End:0x1AC [Loop If]
	if(M < Mesh.GetNumElements())
	{
		Mat = Mesh.GetMaterial(M);
		MIC = MaterialInstanceConstant(Mat);
		// End:0x139
		if(IsMeshMaterialInstanceReady == false)
		{
			MIC = Mesh.CreateAndSetMaterialInstanceConstant(M);
		}
		// End:0x19E
		if(MIC != none)
		{
			MIC.SetVectorParameterValue('CLR_Tinting', newColor);
			LogInternal("SHOULD BE SETTING NEW COLOR HERE");
		}
		++M;
		// [Loop Continue]
		goto J0x7C;
	}
	IsMeshMaterialInstanceReady = true;
	//return;	
}

function HaloWeapon_TargetDesignator.ETargetDesignatorCategory GetDeployableCategory()
{
	return DeployableCategory;
	//return ReturnValue;	
}

function SetDeployableCategory(HaloWeapon_TargetDesignator.ETargetDesignatorCategory newCategory)
{
	DeployableCategory = newCategory;
	//return;	
}

function name GetDeployableName()
{
	return DeployableName;
	//return ReturnValue;	
}

function SetDeployableName(name NewName)
{
	DeployableName = NewName;
	//return;	
}

function Actor GetDeployableBase()
{
	return DeployableBase;
	//return ReturnValue;	
}

function SetDeployableBase(Actor NewBase)
{
	DeployableBase = NewBase;
	//return;	
}

function Actor GetDeployable()
{
	return self;
	//return ReturnValue;	
}

function array< Class<HaloVCustomizationComponent> > GetCustomizations()
{
	local array< Class<HaloVCustomizationComponent> > returnArr;

	returnArr.Length = 0;
	return returnArr;
	//return ReturnValue;	
}

function SetCustomizations(array< Class<HaloVCustomizationComponent> > Customizations)
{
	//return;	
}

function AddUpgradeXP(int xp)
{
	local HaloGameDefault curHaloGameType;
	local HaloUpgradeManager upgradeMan;
	local int prevXP;

	curHaloGameType = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x117
	if(curHaloGameType != none)
	{
		upgradeMan = curHaloGameType.GetUpgradeManager();
		// End:0x117
		if((upgradeMan != none) && upgradeMan.bAllowXPBasedUpgrades == true)
		{
			prevXP = UpgradeXP;
			UpgradeXP += xp;
			upgradeMan.AttemptUpgradesFromXP(HaloUpgradableInterface(self), prevXP, UpgradeXP);
		}
	}
	//return;	
}

function SetUpgrade(HaloUpgrade aUpgrade)
{
	local HaloUpgrade_Turret Up;

	Upgrade = aUpgrade;
	Up = HaloUpgrade_Turret(Upgrade);
	// End:0x40
	if(Up == none)
	{
		return;
	}
	Health = Up.Health;
	AttackHorizontalRange = Up.AttackRange;
	MannedFireSpread = Up.Spread;
	UnmannedFireSpread = Up.Spread;
	MaxBurstTime = Up.BurstTime;
	BurstCooldown = Up.BurstCooldown;
	TargetInterpTime = Up.TargetInterpTime;
	// End:0x1BB
	if(Up.MeshColor.A > 0.0000000)
	{
		SetMeshColor(Up.MeshColor);
	}
	// End:0x2FF
	if((Seats.Length > 0) && HaloVehicleWeapon(Seats[0].Gun) != none)
	{
		Seats[0].Gun.FireInterval[0] = Up.FireRate;
		Seats[0].Gun.Spread[0] = Up.Spread;
		HaloVehicleWeapon(Seats[0].Gun).WeaponProjectileArchetypes[0] = Up.ProjectileArchetype;
	}
	//return;	
}

function HaloUpgrade GetUpgrade()
{
	return Upgrade;
	//return ReturnValue;	
}

function bool AnySeatAvailable()
{
	// End:0x14
	if(!bTurretManable)
	{
		return false;		
	}
	else
	{
		return super.AnySeatAvailable();
	}
	//return ReturnValue;	
}

simulated function VehicleWeaponFired(bool bViaReplication, Vector HitLocation, int SeatIndex)
{
	// End:0x61
	if(TurretAnimNode != none)
	{
		// End:0x61
		if(TurretRecoilAnimName != 'None')
		{
			TurretAnimNode.PlayCustomAnim(TurretRecoilAnimName, 1.0000000, 0.0000000, 0.0000000, false, true);
		}
	}
	super.VehicleWeaponFired(bViaReplication, HitLocation, SeatIndex);
	//return;	
}

simulated event bool GwNavBotExitVehicle(Pawn WeaponPawn)
{
	// End:0x3A
	if(Driver != none)
	{
		HaloAIPawn(Driver).AttemptToExit = self;
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function BlowupVehicle()
{
	super.BlowupVehicle();
	SetCollision(false, false, true);
	SetCollisionType(1);
	//return;	
}

simulated function UTGib SpawnGibVehicle(Vector SpawnLocation, Rotator SpawnRotation, StaticMesh TheMesh, Vector HitLocation, bool bSpinGib, Vector ImpulseDirection, ParticleSystem PS_OnBreak, ParticleSystem PS_Trail)
{
	local UTGib Gib;

	Gib = super.SpawnGibVehicle(SpawnLocation, SpawnRotation, TheMesh, HitLocation, bSpinGib, ImpulseDirection, PS_OnBreak, PS_Trail);
	// End:0x102
	if(Gib != none)
	{
		// End:0xB5
		if(UTGib_VehiclePiece(Gib) != none)
		{
			UTGib_VehiclePiece(Gib).AkObjectType = AkObjectType;
		}
		SetRTPCValue('Impulse_Value', 40.0000000);
		SetSwitch('Object_Type', AkObjectType);
		PlayAkEvent(AkEvent'Objects.Play_Object_Destroyed');
	}
	return Gib;
	//return ReturnValue;	
}

simulated function int GetDriverTeamNum()
{
	local HaloPawn P;

	P = HaloPawn(Driver);
	// End:0x4C
	if(P != none)
	{
		return int(P.TeamNum);
	}
	return int(Team);
	//return ReturnValue;	
}

simulated function HaloNeedleTargetComponent GetNeedleTargetComponent()
{
	return NeedleTargetComponent;
	//return ReturnValue;	
}

simulated function TickNeedleTargetComponent(float DeltaTime)
{
	// End:0x6A
	if(NeedleTargetComponent != none)
	{
		// End:0x4B
		if(int(Role) == int(ROLE_Authority))
		{
			NeedleTargetComponent.Tick(DeltaTime);
		}
		NeedleTargetComponent.UpdateStickyAttachments();
	}
	//return;	
}

simulated state DyingVehicle
{
	simulated function BeginState(name PreviousStateName)
	{
		local Pawn leavingDriver;

		leavingDriver = Driver;
		DriverLeave(true);
		super.BeginState(PreviousStateName);
		// End:0xCD
		if(leavingDriver != none)
		{
			leavingDriver.TakeDamage(int(float(leavingDriver.Health) * 100.0000000), none, Location, (leavingDriver.Location - Location) * 500.0000000, Class'UTGame.UTDmgType_Instagib',, self);
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	PawnType=PlayerPawnType.PPT_Turret
	AttackHorizontalRange=5000.0000000
	AttackVerticalRange=5000.0000000
	TargetInterpTime=5.0000000
	MannedFireSpread=0.0750000
	UnmannedFireSpread=0.0750000
	MaxBurstTime=0.7500000
	BurstCooldown=3.0000000
	AITargetingMaxAngle=90.0000000
	YawPitchBoneName="MG_Turret_Pivot02"
	// Reference: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloTurret.BlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'BlokSpawnerComponent'
	begin object name="BlokSpawnerComponent" class=MegaHaloGame.HaloCollectibleBlokSpawnerComponent
		WaveData[0]=(bThrown=false,PercentHealthToThrowBloks=0.0000000,MinTotalValue=32,MaxTotalValue=33)
	end object
	BlokSpawner=BlokSpawnerComponent
	DeathSoundEvent=AkEvent'Objects.Play_Object_Destroyed'
	AkExplosionType="Explosion_Concussive"
	AkExplosionSize="Explosion_Med"
	AkObjectType="UNSC_Turret"
	UpdateAIMaxTime=0.5000000
	ManTurretMessage="Hold [MainHUD.InlineInputIcons.inputIcon_y] To Operate Turret"
	// Reference: HaloTargetableComponent_Vehicle'MegaHaloGame.Default__HaloTurret.MyHaloTargetableComponent'
	begin object name="MyHaloTargetableComponent" class=MegaHaloGame.HaloTargetableComponent_Vehicle
	end object
	HaloTargetableComponent=MyHaloTargetableComponent
	// Reference: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloTurret.NeedleTarget'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NeedleTarget'
	begin object name="NeedleTarget" class=MegaHaloGame.HaloNeedleTargetComponent
	end object
	NeedleTargetComponent=NeedleTarget
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloTurret.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'UTGame.Default__UTVehicle.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	BurnOutTime=0.1000000
	InnerExplosionShakeRadius=1.0000000
	OuterExplosionShakeRadius=300.0000000
	Team=1
	bDisableDriverlessReset=true
	// Reference: GwNavBotHandle'MegaHaloGame.Default__HaloTurret.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'UTGame.Default__UTVehicle.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	// Reference: RB_StayUprightSetup'MegaHaloGame.Default__HaloTurret.MyStayUprightSetup'
	// Archetype: RB_StayUprightSetup'UTGame.Default__UTVehicle.MyStayUprightSetup'
	begin object name="MyStayUprightSetup"
	end object
	StayUprightConstraintSetup=MyStayUprightSetup
	// Reference: RB_ConstraintInstance'MegaHaloGame.Default__HaloTurret.MyStayUprightConstraintInstance'
	// Archetype: RB_ConstraintInstance'UTGame.Default__UTVehicle.MyStayUprightConstraintInstance'
	begin object name="MyStayUprightConstraintInstance"
	end object
	StayUprightConstraintInstance=MyStayUprightConstraintInstance
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloTurret.SVehicleMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SVehicleMesh'
	// Archetype: SkeletalMeshComponent'UTGame.Default__UTVehicle.SVehicleMesh'
	begin object name="SVehicleMesh"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloTurret.MyLightEnvironment'
	end object
	Mesh=SVehicleMesh
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloTurret.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'UTGame.Default__UTVehicle.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	Components[1]=SVehicleMesh
	Components[2]=myGwNavBotHandle
	Components[3]=MyLightEnvironment
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloTurret.targetableComponent'
	begin object name="targetableComponent" class=UDKBase.UDKTargetableComponent
		BaseThreatVal=700
		MaxAIHeat=40.0000000
		OutterThreatRadius=10000.0000000
		fAITargetHeight=1000.0000000
		AITargetType=HaloTargetType.TARGET_AGGRESSIVE_STATIONARY
		bAITargetable=true
	end object
	Components[4]=targetableComponent
	Components[5]=MyHaloTargetableComponent
	Components[6]=BlokSpawnerComponent
	Components[7]=NeedleTarget
	CollisionComponent=SVehicleMesh
}