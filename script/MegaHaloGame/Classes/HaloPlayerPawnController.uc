class HaloPlayerPawnController extends UTPlayerController
	config(Game)
	implements(HaloSaveInterface);

struct VehicleEntryInfo
{
	var UTVehicle Vehicle;
	var int Seat;

	structdefaultproperties
	{
		Vehicle=none
		Seat=-1
	}
};

var HaloPlayerGroup PlayerGroup;
var Class<Pawn> PawnClass;
var Vector PlayerInputRawPawnMotion;
var Vector PlayerInputRawViewMotion;
var bool IsPlayerInputRawViewMotionDisabled;
var bool bLockMotionDuringTargetedMelee;
var bool bPawnControlsLocked;
var bool bIsAimingTargetDesignator;
var bool bWasHoldingDownBuildTrigger;
var bool IsZoomEnabled;
var bool IsAutoAimEnabled;
var bool bMarkAutoAimTargets;
var bool ConstructionCameraAlreadyActive;
var bool bShowHVCCPrompt;
var bool bVehicleAccel;
var bool bVehicleBrake;
var bool bVehicleStrafe;
var bool bAltAccelJoystickIsUp;
var bool bAltVehicleAccel;
var bool bVehicleAutoBrake;
var bool bTeleportToBreadcrumbOnFall;
var bool bForciblyAddNextValidBreadcrumb;
var bool bIsCheatButtonDown;
var bool bUpdateCompassPath;
var bool bIsCompassPathValid;
var bool bShouldHavePath;
var bool bPersistentDataReadComplete;
var bool bProfileSettingsReadComplete;
var bool bProfileSettingsUpdated;
var bool bHasLostContactWithServer;
var transient bool bHasSigninChanged;
var bool bIsReturningToMainMenu;
var float DeadZone;
var HaloWeapon_TargetDesignator TDWeapon;
var array<HaloStudGridActor> StudGridsInRange;
var HaloStudGridActor ActionableStudGrid;
var const int RegularWeaponGroupID;
var const int ThrownWeaponGroupID;
var const int DesignatorWeaponGroupID;
var float LastWeaponSwapTime;
var float LastTargetDesignatorToggleTime;
var Weapon LastWeaponEquippedBeforeTD;
var int ToggleZoomLevel;
var input byte bFireButtonState;
var byte cachedTeamNum;
var float UseButtonTimer;
var HaloBaseEnhanceTrigger ActiveEnhancementTrigger;
var HaloConstructionBuildPadTrigger ActiveConstructionTrigger;
var HaloConstructionBuildPadTrigger InactiveConstructionTrigger;
var HaloConstructionBuildPad ActiveConstructionPadTarget;
var float LastConstructionToggleTime;
var HaloVehicleCustomizationPanel ActiveVehiclePanel;
var HaloVehicle DeployedVehicle;
var HaloWeaponCloset ActiveWeaponCloset;
var export editinline HaloBlokCollectorComponent BlokCollector;
var Rotator VehicleRotator;
var float AltAccelReverseRange;
var float AltAccelYDeadzone;
var float AltAccelThrottleMultiplier;
var float VehicleXVal;
var float VehicleCameraToReverseDelay;
var float VehicleCameraToForwardDelay;
var float VehicleMaxThrottleToAutoBrake;
var ForceFeedbackWaveform GrenadeWaveform;
var ForceFeedbackWaveform EngineWaveform;
var Rotator WeaponAimRotation;
var array<HaloDeploymentMonitor> DeploymentMonitors;
var float MinBreadcrumbDistance;
var const int MaxBreadcrumbListSize;
var array<Vector> BreadcrumbList;
var float DistToAdvancePath;
var float DistToRepath;
var float RepathTimer;
var float RepathDelay;
var array<Vector> CompassPath;
var VehicleEntryInfo ActionableVehicleEntry;
var float LedgeJumpDuration;
var config float TimeBetweenSaves;
var HaloProfileSettings ProfileSettings;
var HaloPlayerPersistentData PersistentData;
var UniqueNetId HostId;

reliable client simulated function ClientAddToBank(byte Amount)
{
	// End:0x3A
	if(BlokCollector != none)
	{
		BlokCollector.Bank += int(Amount);
	}
	//return;	
}

reliable client simulated function ClientRemoveFromBank(byte Amount)
{
	// End:0x7A
	if(BlokCollector != none)
	{
		BlokCollector.Bank -= int(Amount);
		BlokCollector.Bank = Max(0, BlokCollector.Bank);
	}
	//return;	
}

function CameraReset()
{
	local bool encounterViewEnabled;

	encounterViewEnabled = CameraEncounterViewIsEnabled();
	// End:0x47
	if(PlayerCamera != none)
	{
		PlayerCamera.Destroy();
		PlayerCamera = none;
	}
	SpawnPlayerCamera();
	CameraSetViewRotation(((Pawn != none) ? Pawn.Rotation : Rotation));
	// End:0xB7
	if(encounterViewEnabled != (CameraEncounterViewIsEnabled()))
	{
		CameraEncounterViewToggle();
	}
	//return;	
}

function CameraSetViewRotation(Rotator vRotation, optional ViewTargetTransitionParams vTransition)
{
	// End:0x53
	if(HaloPlayerCamera(PlayerCamera) != none)
	{
		HaloPlayerCamera(PlayerCamera).SetViewRotation(vRotation, vTransition);
	}
	//return;	
}

function CameraEncounterDisableAdd(const name aName)
{
	// End:0x49
	if(HaloPlayerCamera(PlayerCamera) != none)
	{
		HaloPlayerCamera(PlayerCamera).EncounterDisableAdd(aName);
	}
	//return;	
}

function CameraEncounterDisableRemove(const name aName)
{
	// End:0x49
	if(HaloPlayerCamera(PlayerCamera) != none)
	{
		HaloPlayerCamera(PlayerCamera).EncounterDisableRemove(aName);
	}
	//return;	
}

function bool CameraEncounterViewIsEnabled()
{
	// End:0x4D
	if(HaloPlayerCamera(PlayerCamera) != none)
	{
		return HaloPlayerCamera(PlayerCamera).HasEncounterDisable(Name) == false;
	}
	return false;
	//return ReturnValue;	
}

function CameraEncounterViewToggle()
{
	// End:0x26
	if((CameraEncounterViewIsEnabled()) == true)
	{
		CameraEncounterDisableAdd(Name);		
	}
	else
	{
		CameraEncounterDisableRemove(Name);
	}
	//return;	
}

function bool CameraInputViewMotionIsEnabled()
{
	return IsPlayerInputRawViewMotionDisabled == false;
	//return ReturnValue;	
}

function CameraInputViewMotionToggle()
{
	IsPlayerInputRawViewMotionDisabled = ((IsPlayerInputRawViewMotionDisabled == true) ? false : true);
	//return;	
}

function CameraSetLockView(const LockViewStruct aLock)
{
	// End:0x49
	if(HaloPlayerCamera(PlayerCamera) != none)
	{
		HaloPlayerCamera(PlayerCamera).SetLockView(aLock);
	}
	//return;	
}

function CameraRemoveLockView(name aName)
{
	// End:0x49
	if(HaloPlayerCamera(PlayerCamera) != none)
	{
		HaloPlayerCamera(PlayerCamera).RemoveLockView(aName);
	}
	//return;	
}

function CameraSetOrbitLockOn(const OrbitLockOnStruct aLockOn)
{
	// End:0x49
	if(HaloPlayerCamera(PlayerCamera) != none)
	{
		HaloPlayerCamera(PlayerCamera).SetOrbitLockOn(aLockOn);
	}
	//return;	
}

function CameraRemoveOrbitLockOn(name aName)
{
	// End:0x49
	if(HaloPlayerCamera(PlayerCamera) != none)
	{
		HaloPlayerCamera(PlayerCamera).RemoveOrbitLockOn(aName);
	}
	//return;	
}

function CameraSetOrbitSettingsByName(name aName)
{
	// End:0x49
	if(HaloPlayerCamera(PlayerCamera) != none)
	{
		HaloPlayerCamera(PlayerCamera).SetOrbitSettingsByName(aName);
	}
	//return;	
}

function CameraSetOrbitSettings(const OrbitStruct aOrbit)
{
	// End:0x49
	if(HaloPlayerCamera(PlayerCamera) != none)
	{
		HaloPlayerCamera(PlayerCamera).SetOrbitSettings(aOrbit);
	}
	//return;	
}

function CameraRemoveOrbitSettings(name aName)
{
	// End:0x49
	if(HaloPlayerCamera(PlayerCamera) != none)
	{
		HaloPlayerCamera(PlayerCamera).RemoveOrbitSettings(aName);
	}
	//return;	
}

function CameraSetLocationMask(const LocationMaskStruct aMask)
{
	// End:0x49
	if(HaloPlayerCamera(PlayerCamera) != none)
	{
		HaloPlayerCamera(PlayerCamera).SetLocationMask(aMask);
	}
	//return;	
}

function CameraRemoveLocationMask(name aName)
{
	// End:0x49
	if(HaloPlayerCamera(PlayerCamera) != none)
	{
		HaloPlayerCamera(PlayerCamera).RemoveLocationMask(aName);
	}
	//return;	
}

exec function EnableZoom()
{
	IsZoomEnabled = true;
	PushAimSettingToPawn();
	//return;	
}

exec function DisableZoom()
{
	IsZoomEnabled = false;
	PushAimSettingToPawn();
	//return;	
}

exec function ToggleZoom()
{
	local int zoomLevelCt;
	local HaloPawn P;
	local HaloWeapon W;

	zoomLevelCt = 1;
	P = HaloPawn(Pawn);
	// End:0x9E
	if(P != none)
	{
		W = HaloWeapon(P.Weapon);
		// End:0x9E
		if(W != none)
		{
			zoomLevelCt = W.zoomLevelCt;
		}
	}
	// End:0xC3
	if(ToggleZoomLevel >= zoomLevelCt)
	{
		ToggleZoomLevel = 0;		
	}
	else
	{
		ToggleZoomLevel += 1;
	}
	PushAimSettingToPawn();
	//return;	
}

exec function EnableCameraAim()
{
	// End:0x38
	if(!bPawnControlsLocked && !bCinematicMode)
	{
		IsAutoAimEnabled = bIsAimingTargetDesignator == false;
	}
	//return;	
}

exec function DisableCameraAim()
{
	IsAutoAimEnabled = false;
	//return;	
}

exec function ToggleVehicleAccel()
{
	bAltVehicleAccel = !bAltVehicleAccel;
	//return;	
}

exec function ToggleVehicleBrake()
{
	bVehicleAutoBrake = !bVehicleAutoBrake;
	//return;	
}

exec function CompleteObjective()
{
	local HaloMission ActiveMission;
	local HaloObjective HPObjective;
	local HaloGameDefault Game;

	Game = HaloGameDefault(WorldInfo.Game);
	// End:0xCF
	if(Game != none)
	{
		ActiveMission = Game.GetActiveMission();
		// End:0xCF
		if(ActiveMission != none)
		{
			HPObjective = ActiveMission.GetHighestPriorityObjective();
			// End:0xCF
			if(HPObjective != none)
			{
				HPObjective.Complete();
			}
		}
	}
	//return;	
}

function PushAimSettingToPawn()
{
	local HaloPawn myPawn;

	myPawn = HaloPawn(Pawn);
	// End:0x54
	if(myPawn != none)
	{
		myPawn.SetIsCameraAimEnabled(IsZooming());
	}
	//return;	
}

function bool IsZooming()
{
	return (IsZoomEnabled == true) || ToggleZoomLevel > 0;
	//return ReturnValue;	
}

function int GetZoomLevel()
{
	// End:0x1C
	if(ToggleZoomLevel > 0)
	{
		return ToggleZoomLevel;		
	}
	else
	{
		// End:0x2B
		if(IsZoomEnabled)
		{
			return 1;
		}
	}
	return 0;
	//return ReturnValue;	
}

event Possess(Pawn inPawn, bool bVehicleTransition)
{
	ActionableStudGrid = none;
	StudGridsInRange.Length = 0;
	ClearTargetDesignatorState();
	super.Possess(inPawn, bVehicleTransition);
	// End:0xD1
	if((((Pawn != none) && Pawn.Mesh != none) && int(Role) == int(ROLE_Authority)) && (IsLocalPlayerController()) == false)
	{
		Pawn.Mesh.bUpdateSkelWhenNotRendered = true;
	}
	// End:0x11A
	if(HaloPawn(inPawn) != none)
	{
		cachedTeamNum = HaloPawn(inPawn).TeamNum;
	}
	//return;	
}

event UnPossess()
{
	// End:0x6B
	if((Pawn != none) && Pawn.Mesh != none)
	{
		Pawn.Mesh.bUpdateSkelWhenNotRendered = false;
	}
	super(PlayerController).UnPossess();
	//return;	
}

simulated event PostBeginPlay()
{
	local HaloGameDefault Game;

	super(PlayerController).PostBeginPlay();
	ServerSetCharacterClass(none);
	BlokCollector.MyController = self;
	Game = HaloGameDefault(WorldInfo.Game);
	// End:0xCD
	if(Game != none)
	{
		PlayerGroup = Game.GetPlayerGroup();
		// End:0xCD
		if(PlayerGroup != none)
		{
			PlayerGroup.AddPlayerController(self);
		}
	}
	UseButtonTimer = -1.0000000;
	//return;	
}

simulated event Destroyed()
{
	// End:0x3A
	if(PlayerGroup != none)
	{
		PlayerGroup.RemovePlayerController(self);
		PlayerGroup = none;
	}
	super.Destroyed();
	//return;	
}

function EnableCameraDOF(bool IsEnabled, optional float InnerRadius = 2000.0000000, optional float kernalSize = 16.0000000)
{
	PlayerCamera.CamPostProcessSettings.bOverride_EnableDOF = IsEnabled;
	PlayerCamera.CamPostProcessSettings.bOverride_DOF_FocusInnerRadius = IsEnabled;
	PlayerCamera.CamPostProcessSettings.bOverride_DOF_BlurKernelSize = IsEnabled;
	PlayerCamera.CamPostProcessSettings.bEnableDOF = IsEnabled;
	PlayerCamera.CamPostProcessSettings.DOF_FocusInnerRadius = InnerRadius;
	PlayerCamera.CamPostProcessSettings.DOF_BlurKernelSize = kernalSize;
	//return;	
}

simulated function ClearTargetDesignatorState()
{
	// End:0x2E
	if(TDWeapon != none)
	{
		TDWeapon.StopBuildSoundLoop();
	}
	TDWeapon = none;
	bIsAimingTargetDesignator = false;
	LastWeaponEquippedBeforeTD = none;
	CameraRemoveOrbitSettings('HaloWeapon_TargetDesignator');
	CameraRemoveOrbitLockOn('HaloWeapon_TargetDesignator_OrbitLockOn');
	PlayerInputRawViewMotion = vect(0.0000000, 0.0000000, 0.0000000);
	PlayerInputRawPawnMotion = vect(0.0000000, 0.0000000, 0.0000000);
	ProcessMove(0.0000000, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));
	EnableCameraDOF(false);
	//return;	
}

simulated event GetPlayerViewPoint(out Vector OutLocation, out Rotator OutRotation)
{
	// End:0x65
	if((PlayerCamera == none) || (Pawn != none) && Pawn.DrivenVehicle != none)
	{
		super.GetPlayerViewPoint(OutLocation, OutRotation);		
	}
	else
	{
		PlayerCamera.GetCameraViewPoint(OutLocation, OutRotation);
	}
	//return;	
}

simulated function Actor GetCameraAutoAimTarget()
{
	// End:0x78
	if((HaloPlayerCamera(PlayerCamera) != none) && (Pawn != none) && Pawn.DrivenVehicle == none)
	{
		return HaloPlayerCamera(PlayerCamera).GetAutoAimTarget();
	}
	return none;
	//return ReturnValue;	
}

simulated function Actor GetCameraAutoAimExtendedTarget()
{
	// End:0x78
	if((HaloPlayerCamera(PlayerCamera) != none) && (Pawn != none) && Pawn.DrivenVehicle == none)
	{
		return HaloPlayerCamera(PlayerCamera).GetAutoAimExtendedTarget();
	}
	return none;
	//return ReturnValue;	
}

simulated function Vector BestAutoAimTargetLocation(const Actor Target)
{
	local Vector aLocation, bestLocation;
	local float aDistance, BestDistance;
	local HaloPawn aPawn;
	local int Index;
	local Box BBox;

	aPawn = HaloPawn(Target);
	// End:0x2A8
	if((aPawn != none) && aPawn.Mesh != none)
	{
		bestLocation = Target.Location;
		BestDistance = 10000000.0000000;
		Index = 0;
		J0x93:

		// End:0x29B [Loop If]
		if(Index < aPawn.TargetNodes.Length)
		{
			// End:0x1A2
			if(aPawn.Mesh.GetSocketWorldLocationAndRotation(aPawn.TargetNodes[Index], aLocation,, 0) == true)
			{
				aDistance = VSize(aLocation - Pawn.Location);
				// End:0x19F
				if(aDistance < BestDistance)
				{
					BestDistance = aDistance;
					bestLocation = aLocation;
				}				
			}
			else
			{
				aLocation = aPawn.Mesh.GetBoneLocation(aPawn.TargetNodes[Index], 0);
				// End:0x28D
				if(IsZero(aLocation) == false)
				{
					aDistance = VSize(aLocation - Pawn.Location);
					// End:0x28D
					if(aDistance < BestDistance)
					{
						BestDistance = aDistance;
						bestLocation = aLocation;
					}
				}
			}
			Index++;
			// [Loop Continue]
			goto J0x93;
		}
		return bestLocation;		
	}
	else
	{
		// End:0x364
		if(Target != none)
		{
			Target.GetComponentsBoundingBox(BBox);
			// End:0x364
			if(IsZero(BBox.Min - BBox.Max) == false)
			{
				return (BBox.Min + BBox.Max) * 0.5000000;
			}
		}
	}
	return Class'MegaHaloGame.HaloPawn'.static.GetRealLocationOf(Target);
	//return ReturnValue;	
}

function Vector GetAimLocationFor(Weapon W, Vector StartFireLoc, optional out Actor HitActor)
{
	local Vector AimLoc;
	local Rotator AimRot;
	local Vector HitLocation, HitNormal;

	HaloPawn(Pawn).BubbleShieldLOSHackActor = none;
	// End:0x1B0
	if(((bIsAimingTargetDesignator == false) && (IsZooming()) == false) && HaloPawn(Pawn) != none)
	{
		AimLoc = StartFireLoc;
		AimRot.Yaw = WeaponAimRotation.Yaw;
		AimRot.Pitch = WeaponAimRotation.Pitch;
		HitActor = GetCameraAutoAimTarget();
		// End:0x14B
		if(HitActor != none)
		{
			HitLocation = BestAutoAimTargetLocation(HitActor);
			AimRot = Rotator(HitLocation - AimLoc);
		}
		HitActor = Trace(HitLocation, HitNormal, AimLoc + (Vector(AimRot) * W.WeaponRange), AimLoc, true);		
	}
	else
	{
		GetPlayerViewPoint(AimLoc, AimRot);
		AimLoc = AimLoc + (Normal(Vector(AimRot)) * VSize(AimLoc - Pawn.Location));
		HitActor = Trace(HitLocation, HitNormal, AimLoc + (Vector(AimRot) * W.WeaponRange), AimLoc, true);
	}
	// End:0x2FE
	if((HaloDestructibleActor(HitActor) != none) && HaloDestructibleActor(HitActor).bPassShotsFromWithin)
	{
		HaloPawn(Pawn).BubbleShieldLOSHackActor = HitActor;
		HitActor = none;
	}
	// End:0x34D
	if(HitActor == none)
	{
		HitLocation = AimLoc + (Vector(AimRot) * W.WeaponRange);
	}
	return HitLocation;
	//return ReturnValue;	
}

function bool TargetLocked()
{
	local HaloPlayerCamera Camera;

	// End:0x75
	if((HaloPlayerCamera(PlayerCamera) != none) && Vehicle(Pawn) == none)
	{
		Camera = HaloPlayerCamera(PlayerCamera);
		// End:0x75
		if(Camera.IsOrbitAutoAimTargetValid() == true)
		{
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function bool IsTargetLocked()
{
	return TargetLocked();
	//return ReturnValue;	
}

simulated function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
	local Vector HitLocation;

	HitLocation = GetAimLocationFor(W, StartFireLoc);
	return Rotator(HitLocation - StartFireLoc);
	//return ReturnValue;	
}

exec function SwapWeapons(optional bool bOnlyIfNextWeaponHasAmmo = false)
{
	local HaloPawn P;
	local Weapon CurrentWeapon;
	local array<UTWeapon> regularWeaponList;
	local int I, newWeaponIdx;
	local UTInventoryManager InvManager;

	// End:0x121
	if((((((((WorldInfo.TimeSeconds - LastWeaponSwapTime) < 0.5000000) || Pawn == none) || Pawn.InvManager == none) || (Pawn.Weapon != none) && Pawn.Weapon.GetStateName() == 'WeaponEquipping') || UTInventoryManager(Pawn.InvManager) == none) || bCinematicMode) || bPawnControlsLocked)
	{
		return;
	}
	P = HaloPawn(Pawn);
	// End:0x196
	if(((P == none) || P.IsBusy()) || P.IsGrabbingLedge())
	{
		return;
	}
	// End:0x1AF
	if(bIsAimingTargetDesignator)
	{
		CancelTargetDesignator();
		return;
	}
	LastWeaponSwapTime = WorldInfo.TimeSeconds;
	InvManager = UTInventoryManager(Pawn.InvManager);
	InvManager.GetWeaponList(regularWeaponList, true, RegularWeaponGroupID, false);
	// End:0x24D
	if(regularWeaponList.Length == 0)
	{
		return;
	}
	CurrentWeapon = UTWeapon(InvManager.PendingWeapon);
	// End:0x2BE
	if(CurrentWeapon == none)
	{
		CurrentWeapon = UTWeapon(Pawn.Weapon);
	}
	I = 0;
	J0x2C9:

	// End:0x329 [Loop If]
	if(I < regularWeaponList.Length)
	{
		// End:0x31B
		if(regularWeaponList[I] == CurrentWeapon)
		{
			newWeaponIdx = I + 1;
			// [Explicit Break]
			goto J0x329;
		}
		I++;
		// [Loop Continue]
		goto J0x2C9;
	}
	J0x329:

	// End:0x34C
	if(newWeaponIdx >= regularWeaponList.Length)
	{
		newWeaponIdx = 0;
	}
	// End:0x3ED
	if((newWeaponIdx >= 0) && regularWeaponList[newWeaponIdx] != CurrentWeapon)
	{
		// End:0x3ED
		if(!bOnlyIfNextWeaponHasAmmo || regularWeaponList[newWeaponIdx].HasAnyAmmo())
		{
			InvManager.SetCurrentWeapon(regularWeaponList[newWeaponIdx]);
		}
	}
	//return;	
}

function UTWeapon GetUnequippedWeapon()
{
	local Weapon CurrentWeapon;
	local array<UTWeapon> regularWeaponList;
	local int I, newWeaponIdx;
	local UTInventoryManager InvManager;

	InvManager = UTInventoryManager(Pawn.InvManager);
	InvManager.GetWeaponList(regularWeaponList, true, RegularWeaponGroupID, false);
	// End:0x76
	if(regularWeaponList.Length == 0)
	{
		return none;
	}
	CurrentWeapon = UTWeapon(Pawn.Weapon);
	I = 0;
	J0xB2:

	// End:0x112 [Loop If]
	if(I < regularWeaponList.Length)
	{
		// End:0x104
		if(regularWeaponList[I] == CurrentWeapon)
		{
			newWeaponIdx = I + 1;
			// [Explicit Break]
			goto J0x112;
		}
		I++;
		// [Loop Continue]
		goto J0xB2;
	}
	J0x112:

	// End:0x135
	if(newWeaponIdx >= regularWeaponList.Length)
	{
		newWeaponIdx = 0;
	}
	// End:0x16A
	if(regularWeaponList[newWeaponIdx] != CurrentWeapon)
	{
		return regularWeaponList[newWeaponIdx];
	}
	return none;
	//return ReturnValue;	
}

simulated event NotifyOfTargetDesignatorDeploy()
{
	// End:0xF7
	if(bIsAimingTargetDesignator && TDWeapon != none)
	{
		// End:0xB4
		if((HaloPawn(Pawn) != none) && HaloWeaponAttachment_TargetDesignator(HaloPawn(Pawn).CurrentWeaponAttachment) != none)
		{
			HaloWeaponAttachment_TargetDesignator(HaloPawn(Pawn).CurrentWeaponAttachment).NotifyOfSuccessfulDeploy();
		}
		CancelTargetDesignator();
		// End:0xF7
		if(ActionableStudGrid != none)
		{
			ActionableStudGrid.TurnOffBuildIndicator();
			ActionableStudGrid = none;
		}
	}
	//return;	
}

simulated function RegisterActionableStudGrid(HaloStudGridActor newStudGrid)
{
	// End:0x32
	if(StudGridsInRange.Find(newStudGrid) < 0)
	{
		StudGridsInRange.AddItem(newStudGrid);
	}
	//return;	
}

simulated function UnregisterActionableStudGrid(HaloStudGridActor studGridToRemove)
{
	StudGridsInRange.RemoveItem(studGridToRemove);
	// End:0x57
	if(ActionableStudGrid == studGridToRemove)
	{
		ActionableStudGrid.TurnOffBuildIndicator();
		ActionableStudGrid = none;
	}
	//return;	
}

simulated function bool ToggleTargetDesignatorAutoMode()
{
	local Weapon CurrentWeapon;
	local UTInventoryManager InvManager;
	local array<UTWeapon> designatorWeaponList;
	local HaloPawn P;

	// End:0xC6
	if((((((WorldInfo.TimeSeconds - LastTargetDesignatorToggleTime) < 0.5000000) || Pawn == none) || Pawn.InvManager == none) || UTInventoryManager(Pawn.InvManager) == none) || int(Pawn.Physics) != int(1))
	{
		return false;
	}
	P = HaloPawn(Pawn);
	// End:0x13B
	if(((P == none) || P.IsBusy()) || P.IsGrabbingLedge())
	{
		return false;
	}
	LastTargetDesignatorToggleTime = WorldInfo.TimeSeconds;
	InvManager = UTInventoryManager(Pawn.InvManager);
	// End:0x298
	if(bIsAimingTargetDesignator && TDWeapon != none)
	{
		StopFire(0);
		// End:0x21C
		if((LastWeaponEquippedBeforeTD != none) && LastWeaponEquippedBeforeTD.HasAnyAmmo())
		{
			InvManager.SetCurrentWeapon(LastWeaponEquippedBeforeTD);			
		}
		else
		{
			SwitchToBestWeapon(false);
		}
		ClearTargetDesignatorState();
		IsZoomEnabled = false;
		ToggleZoomLevel = 0;
		PushAimSettingToPawn();
		// End:0x293
		if(HaloPawn(Pawn) != none)
		{
			HaloPawn(Pawn).SetIsFiring(false);
		}
		return true;		
	}
	else
	{
		// End:0x3FE
		if(!bIsAimingTargetDesignator)
		{
			CurrentWeapon = UTWeapon(InvManager.PendingWeapon);
			// End:0x318
			if(CurrentWeapon == none)
			{
				CurrentWeapon = UTWeapon(Pawn.Weapon);
			}
			LastWeaponEquippedBeforeTD = CurrentWeapon;
			InvManager.GetWeaponList(designatorWeaponList, true, DesignatorWeaponGroupID, false);
			// End:0x3FE
			if((designatorWeaponList.Length >= 1) && HaloWeapon_TargetDesignator(designatorWeaponList[0]) != none)
			{
				TDWeapon = HaloWeapon_TargetDesignator(designatorWeaponList[0]);
				InvManager.SetCurrentWeapon(TDWeapon);
				bIsAimingTargetDesignator = true;
				StartFire(0);
				PushState('TargetDesignatorTransitionIn');
				return true;
			}
		}
	}
	return false;
	//return ReturnValue;	
}

exec function PrevCategoryItem()
{
	// End:0x4E
	if((bIsAimingTargetDesignator && TDWeapon != none) && !bCinematicMode)
	{
		TDWeapon.ChoosePrevItem();
	}
	//return;	
}

exec function NextCategoryItem()
{
	// End:0x4E
	if((bIsAimingTargetDesignator && TDWeapon != none) && !bCinematicMode)
	{
		TDWeapon.ChooseNextItem();
	}
	//return;	
}

exec function ToggleTargetDesignator()
{
	// End:0x2A
	if(!bCinematicMode && !bPawnControlsLocked)
	{
		ToggleTargetDesignatorAutoMode();
	}
	//return;	
}

exec function CancelTargetDesignator()
{
	// End:0x4A
	if(((bIsAimingTargetDesignator && TDWeapon != none) && !bCinematicMode) && !bPawnControlsLocked)
	{
		ToggleTargetDesignatorAutoMode();
	}
	//return;	
}

exec function AddBloksToBank(int BlokCount, optional bool bForceAdd = false)
{
	local HaloCheatManager HCM;

	// End:0x75
	if(bIsCheatButtonDown || bForceAdd)
	{
		HCM = HaloCheatManager(CheatManager);
		// End:0x75
		if(HCM != none)
		{
			HCM.AddBank(BlokCount);
		}
	}
	//return;	
}

exec function ToggleCheatRunSpeed()
{
	// End:0xEC
	if(bIsCheatButtonDown)
	{
		// End:0xEC
		if(Pawn != none)
		{
			// End:0xC7
			if(Pawn.GroundSpeed != Pawn.Class.default.GroundSpeed)
			{
				Pawn.GroundSpeed = Pawn.Class.default.GroundSpeed;				
			}
			else
			{
				Pawn.GroundSpeed *= 2.0000000;
			}
		}
	}
	//return;	
}

exec function ActivateKillAllEnemiesCheat()
{
	// End:0x4F
	if(bIsCheatButtonDown && HaloCheatManager(CheatManager) != none)
	{
		HaloCheatManager(CheatManager).KillAllEnemies();
	}
	//return;	
}

exec function ToggleVehicleBuildCheat()
{
	// End:0x50
	if(TDWeapon != none)
	{
		TDWeapon.bCheatToBuildVehiclesAnywhere = !TDWeapon.bCheatToBuildVehiclesAnywhere;
	}
	//return;	
}

exec function OnCheatButtonDown()
{
	bIsCheatButtonDown = true;
	//return;	
}

exec function OnCheatButtonUp()
{
	bIsCheatButtonDown = false;
	//return;	
}

exec function OnCheatSuicide()
{
	// End:0x1A
	if(bIsCheatButtonDown == true)
	{
		Suicide();
	}
	//return;	
}

simulated function NetworkGotoState(name StateName)
{
	GotoState(StateName);
	// End:0x35
	if(int(Role) < int(ROLE_Authority))
	{
		ServerGotoState(StateName);
	}
	//return;	
}

reliable server function ServerGotoState(name StateName)
{
	GotoState(StateName);
	//return;	
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local Canvas Canvas;
	local Vector attackLocStart, attackLocEnd, attackLeft, attackRight;
	local Rotator myrot;
	local HaloWeapon myWeapon;

	myWeapon = HaloWeapon(Pawn.Weapon);
	// End:0x2F3
	if(myWeapon != none)
	{
		attackLocStart = Pawn.Location - (Vector(Pawn.Rotation) * Pawn.CylinderComponent.CollisionRadius);
		attackLocEnd = attackLocStart + (Vector(Pawn.Rotation) * myWeapon.MeleeRange);
		myrot.Yaw = int(myWeapon.MaxMeleeAngle * 182.0444031);
		attackRight = attackLocStart + ((Vector(Pawn.Rotation) >> myrot) * myWeapon.MeleeRange);
		myrot.Yaw = int((myWeapon.MaxMeleeAngle * 182.0444031) * float(-1));
		attackLeft = attackLocStart + ((Vector(Pawn.Rotation) >> myrot) * myWeapon.MeleeRange);
		DrawDebugLine(attackLocStart, attackLocEnd, 0, 0, 255);
		DrawDebugLine(attackLocStart, attackLeft, 255, 0, 0);
		DrawDebugLine(attackLocStart, attackRight, 255, 0, 0);
		DrawDebugLine(attackLeft, attackRight, 255, 0, 0);
	}
	// End:0x415
	if(bIsAimingTargetDesignator && TDWeapon != none)
	{
		Canvas = HUD.Canvas;
		Canvas.SetPos(4.0000000, out_YPos);
		Canvas.DrawText((("[TARGET DESIGNATOR ACTIVE] Category: " $ string(TDWeapon.CurrentTDCategory)) $ "  Item: ") $ string(TDWeapon.CurrentTDItemIdx));
		out_YPos += out_YL;
	}
	//return;	
}

exec function RamAttack()
{
	//return;	
}

exec function ThrowGrenade()
{
	//return;	
}

exec function JumpReleased()
{
	local HaloPawn P;

	P = HaloPawn(Pawn);
	// End:0x4A
	if(P != none)
	{
		P.JumpReleased();
	}
	//return;	
}

function bool IsGrabbingLedge()
{
	local HaloPawn P;

	P = HaloPawn(Pawn);
	// End:0x4B
	if(P != none)
	{
		return P.IsGrabbingLedge();
	}
	return false;
	//return ReturnValue;	
}

static function int LerpAngle(int ang, int desiredAng, float turnSpeed, float DeltaTime)
{
	local int Turn, deltaAng;

	Turn = int(turnSpeed * DeltaTime);
	deltaAng = NormalizeRotAxis(desiredAng - ang);
	// End:0x7A
	if(deltaAng < 0)
	{
		deltaAng = Max(deltaAng, -Turn);		
	}
	else
	{
		deltaAng = Min(deltaAng, Turn);
	}
	return NormalizeRotAxis(ang + deltaAng);
	//return ReturnValue;	
}

static function int TetherAngle(int ang, int desiredAng, int tetherAng)
{
	local int deltaAng;

	deltaAng = NormalizeRotAxis(desiredAng - ang);
	// End:0x6C
	if(deltaAng < -tetherAng)
	{
		ang = NormalizeRotAxis(desiredAng + tetherAng);		
	}
	else
	{
		// End:0xAB
		if(deltaAng > tetherAng)
		{
			ang = NormalizeRotAxis(desiredAng - tetherAng);
		}
	}
	return ang;
	//return ReturnValue;	
}

function Vector GetPlayerAimMotion()
{
	return ((IsPlayerInputRawViewMotionDisabled == false) ? PlayerInputRawViewMotion : vect(0.0000000, 0.0000000, 0.0000000));
	//return ReturnValue;	
}

function Vector GetPlayerPawnMotion()
{
	return PlayerInputRawPawnMotion;
	//return ReturnValue;	
}

function bool CanSprint()
{
	// End:0x78
	if(PlayerInput != none)
	{
		// End:0x78
		if(!bIsAimingTargetDesignator && (Abs(PlayerInput.aBaseY) > 0.1000000) || Abs(PlayerInput.aStrafe) > 0.1000000)
		{
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

exec function Sprint()
{
	//return;	
}

exec function OnUseButtonPressed()
{
	local HaloPawn P;

	// End:0x122
	if((!bCinematicMode && !bIsAimingTargetDesignator) && !bPawnControlsLocked)
	{
		// End:0x40
		if(TryToUnpause())
		{
			return;
		}
		P = HaloPawn(Pawn);
		// End:0xD7
		if(P != none)
		{
			// End:0xD7
			if((P.IsBusy() || P.IsGrabbingLedge()) || P.IsSwappingWeapon())
			{
				return;
			}
		}
		// End:0xE6
		if(TryToActionABuildPad())
		{
			return;
		}
		// End:0xF5
		if(TryToStartBaseEnhancement())
		{
			return;
		}
		// End:0x104
		if(TryToStartVehicleCustomization())
		{
			return;
		}
		// End:0x113
		if(TryToStartConstruction())
		{
			return;
		}
		UseButtonTimer = 0.2500000;
	}
	//return;	
}

exec function OnUseButtonReleased()
{
	// End:0x2A
	if(UseButtonTimer > float(0))
	{
		OnUseButtonQuickRelease();
		UseButtonTimer = -1.0000000;
	}
	//return;	
}

function TickUseButtonTimer(float DeltaTime)
{
	// End:0x44
	if(UseButtonTimer >= 0.0000000)
	{
		UseButtonTimer -= DeltaTime;
		// End:0x44
		if(UseButtonTimer < 0.0000000)
		{
			OnUseButtonHeld();
		}
	}
	//return;	
}

function OnUseButtonHeld()
{
	// End:0x0F
	if(TryToFinishBaseEnhancement())
	{
		return;
	}
	// End:0x1E
	if(TryToFinishConstruction())
	{
		return;
	}
	// End:0x2D
	if(TryToEnterOrExitVehicle())
	{
		return;
	}
	// End:0x3C
	if(TryToPickupWeapon())
	{
		return;
	}
	// End:0x4B
	if(TryToUseWeaponCloset())
	{
		return;
	}
	// End:0x5A
	if(TriggerInteracted())
	{
		return;
	}
	SwapWeapons();
	//return;	
}

function OnUseButtonQuickRelease()
{
	CancelBaseEnhancement();
	CancelConstruction();
	SwapWeapons();
	//return;	
}

exec function OnAltUseButtonPressed()
{
	// End:0x4A
	if((!bCinematicMode && !bIsAimingTargetDesignator) && !bPawnControlsLocked)
	{
		// End:0x40
		if(TryToAltActionABuildPad())
		{
			return;
		}
		RamAttack();
	}
	//return;	
}

function bool TryToUnpause()
{
	// End:0x4E
	if(WorldInfo.Pauser == PlayerReplicationInfo)
	{
		// End:0x4C
		if(int(Role) == int(ROLE_Authority))
		{
			SetPause(false);
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool TryToEnterOrExitVehicle()
{
	// End:0x42
	if(Vehicle(Pawn) != none)
	{
		return Vehicle(Pawn).DriverLeave(false);
	}
	// End:0x51
	if(FindVehicleToDrive())
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool TryToActionABuildPad()
{
	// End:0x3F
	if((ActionableStudGrid != none) && ActionableStudGrid.CanBeActionedNow())
	{
		ToggleTargetDesignator();
		return true;
	}
	// End:0x52
	if((TryToUpgradeABuildPad()) == true)
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool TryToAltActionABuildPad()
{
	// End:0x13
	if((TryToUpgradeABuildPad(1)) == true)
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool TryToUpgradeABuildPad(optional int upgradeIndex)
{
	local HaloUpgradeManager Upgrade;
	local HaloGameDefault Game;

	Game = HaloGameDefault(WorldInfo.Game);
	// End:0x43
	if(Game == none)
	{
		return false;
	}
	Upgrade = Game.GetUpgradeManager();
	// End:0x7D
	if(Upgrade == none)
	{
		return false;
	}
	// End:0xAE
	if(Upgrade.TryToUpgradeNearby(self, upgradeIndex) == true)
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool TryToPickupWeapon()
{
	local HaloPawn P;

	P = HaloPawn(Pawn);
	// End:0x4B
	if(P != none)
	{
		return P.PickupClosestWeapon();
	}
	return false;
	//return ReturnValue;	
}

function bool TryToUseWeaponCloset()
{
	local HaloPawn P;

	P = HaloPawn(Pawn);
	// End:0x65
	if((P != none) && ActiveWeaponCloset != none)
	{
		return P.UseWeaponCloset(ActiveWeaponCloset);
	}
	return false;
	//return ReturnValue;	
}

function bool TryToStartBaseEnhancement()
{
	// End:0xDB
	if((((ActiveEnhancementTrigger != none) && ActiveEnhancementTrigger.bIsUnlocked) && BlokCollector != none) && BlokCollector.GetBankCount() >= ActiveEnhancementTrigger.BlokCost)
	{
		UseButtonTimer = ActiveEnhancementTrigger.RequiredActivationTimeSecs;
		ActiveEnhancementTrigger.StartActivation(self, Pawn);
		return true;
	}
	return false;
	//return ReturnValue;	
}

function CancelBaseEnhancement()
{
	// End:0x38
	if(ActiveEnhancementTrigger != none)
	{
		ActiveEnhancementTrigger.StopActivation(self, Pawn);
	}
	//return;	
}

function bool TryToFinishBaseEnhancement()
{
	// End:0x121
	if(ActiveEnhancementTrigger != none)
	{
		// End:0xCD
		if((ActiveEnhancementTrigger.bIsUnlocked && BlokCollector != none) && BlokCollector.GetBankCount() >= ActiveEnhancementTrigger.BlokCost)
		{
			BlokCollector.RemoveFromBank(ActiveEnhancementTrigger.BlokCost);
			Use();
		}
		ActiveEnhancementTrigger.StopLookingAt(self, Pawn);
		ActiveEnhancementTrigger.StopActivation(self, Pawn);
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool TryToStartVehicleCustomization()
{
	// End:0x3A
	if(ActiveVehiclePanel != none)
	{
		ActiveVehiclePanel.StartActivation(self, Pawn);
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool TryToStartConstruction()
{
	// End:0xCE
	if(((ActiveConstructionTrigger != none) && BlokCollector != none) && ActiveConstructionTrigger.CanBeActivated())
	{
		// End:0xB5
		if(ActiveConstructionTrigger.GetConstructionCost() <= BlokCollector.GetBankCount())
		{
			StartConstructionBuildPadMode(ActiveConstructionTrigger.GetConstructionBuildTarget());
			return true;			
		}
		else
		{
			PlayAkEvent(AkEvent'Builds.Play_Blok_Place_Wrong');
		}
	}
	return false;
	//return ReturnValue;	
}

function CancelConstruction()
{
	// End:0x38
	if(ActiveConstructionTrigger != none)
	{
		ActiveConstructionTrigger.StopActivation(self, Pawn);
	}
	//return;	
}

function bool TryToFinishConstruction()
{
	// End:0x8F
	if(ActiveConstructionTrigger != none)
	{
		// End:0x3B
		if(ActiveConstructionTrigger.CanBeActivated())
		{
			Use();
		}
		ActiveConstructionTrigger.StopLookingAt(self, Pawn);
		ActiveConstructionTrigger.StopActivation(self, Pawn);
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function TickActionableBuildPads(float DeltaTime)
{
	local int I;
	local HaloStudGridActor prevActionableGrid, newActionableGrid;

	prevActionableGrid = ActionableStudGrid;
	newActionableGrid = ActionableStudGrid;
	// End:0xFE
	if((ActionableStudGrid == none) || !ActionableStudGrid.CanBeActionedNow())
	{
		newActionableGrid = none;
		I = 0;
		J0x71:

		// End:0xFE [Loop If]
		if(I < StudGridsInRange.Length)
		{
			// End:0xF0
			if((StudGridsInRange[I] != none) && StudGridsInRange[I].CanBeActionedNow())
			{
				newActionableGrid = StudGridsInRange[I];
				// [Explicit Break]
				goto J0xFE;
			}
			++I;
			// [Loop Continue]
			goto J0x71;
		}
	}
	J0xFE:

	// End:0x184
	if(prevActionableGrid != newActionableGrid)
	{
		// End:0x143
		if(prevActionableGrid != none)
		{
			prevActionableGrid.TurnOffBuildIndicator();
		}
		// End:0x184
		if(newActionableGrid != none)
		{
			ActionableStudGrid = newActionableGrid;
			newActionableGrid.TurnOnBuildIndicator();
		}
	}
	//return;	
}

simulated function TickBaseEnhancementTriggers(float DeltaTime)
{
	local array<Trigger> usableTriggerList;
	local HaloBaseEnhanceTrigger desiredBaseEnhanceTrigger;

	GetTriggerUseList(InteractDistance, 60.0000000, 0.0000000, true, usableTriggerList, Class'MegaHaloGame.HaloBaseEnhanceTrigger');
	// End:0x61
	if(usableTriggerList.Length > 0)
	{
		desiredBaseEnhanceTrigger = HaloBaseEnhanceTrigger(usableTriggerList[0]);		
	}
	else
	{
		desiredBaseEnhanceTrigger = none;
	}
	// End:0x106
	if(desiredBaseEnhanceTrigger != ActiveEnhancementTrigger)
	{
		// End:0xBB
		if(ActiveEnhancementTrigger != none)
		{
			ActiveEnhancementTrigger.StopLookingAt(self, Pawn);
		}
		ActiveEnhancementTrigger = desiredBaseEnhanceTrigger;
		// End:0x106
		if(ActiveEnhancementTrigger != none)
		{
			ActiveEnhancementTrigger.StartLookingAt(self, Pawn);
		}
	}
	//return;	
}

simulated function TickVehicleCustomizationTriggers(float DeltaTime)
{
	local array<Trigger> usableTriggerList;
	local HaloVehicleCustomizationPanel desiredPanel;

	GetTriggerUseList(InteractDistance, 60.0000000, 0.0000000, true, usableTriggerList, Class'MegaHaloGame.HaloVehicleCustomizationPanel');
	// End:0x61
	if(usableTriggerList.Length > 0)
	{
		desiredPanel = HaloVehicleCustomizationPanel(usableTriggerList[0]);		
	}
	else
	{
		desiredPanel = none;
	}
	// End:0x106
	if(desiredPanel != ActiveVehiclePanel)
	{
		// End:0xBB
		if(ActiveVehiclePanel != none)
		{
			ActiveVehiclePanel.StopLookingAt(self, Pawn);
		}
		ActiveVehiclePanel = desiredPanel;
		// End:0x106
		if(ActiveVehiclePanel != none)
		{
			ActiveVehiclePanel.StartLookingAt(self, Pawn);
		}
	}
	//return;	
}

exec function UseAbility()
{
	local HaloPawn P;

	// End:0x7B
	if((!bIsAimingTargetDesignator && !bCinematicMode) && !bPawnControlsLocked)
	{
		P = HaloPawn(Pawn);
		// End:0x7B
		if(P != none)
		{
			P.ActivateArmorAbility();
		}
	}
	//return;	
}

simulated function TickAutoAim(float DeltaTime)
{
	IsAutoAimEnabled = (IsAutoAimEnabled == true) && bIsAimingTargetDesignator == false;
	//return;	
}

function PlayGrenadeForceFeedback(float Left, float Right)
{
	// End:0xA1
	if(GrenadeWaveform != none)
	{
		GrenadeWaveform.Samples[0].LeftAmplitude = byte(Left);
		GrenadeWaveform.Samples[0].RightAmplitude = byte(Right);
		ClientPlayForceFeedbackWaveform(GrenadeWaveform);
	}
	//return;	
}

function UpdateVehicleControls()
{
	local HaloVehicle HV;

	HV = HaloVehicle(Pawn);
	// End:0x8F
	if((HV != none) && HV.Health > 0)
	{
		VehicleRotator = HV.Mesh.GetRotation();
	}
	VehicleXVal = 0.0000000;
	bAltAccelJoystickIsUp = true;
	//return;	
}

function OnExitingVehicleBegin()
{
	GotoState('PlayerExitVehicle');
	//return;	
}

function OnExitingVehicleDetach()
{
	local Vehicle V;

	V = Vehicle(Pawn);
	// End:0x7A
	if((V != none) && V.Driver != none)
	{
		SetViewTarget(V.Driver);
	}
	//return;	
}

function OnExitingVehicleEnd()
{
	//return;	
}

function CheckAutoObjective(bool bOnlyNotifyDifferent)
{
	// End:0x3E
	if((Pawn != none) && PlayerReplicationInfo != none)
	{
		LastAutoObjective = none;
		ClientSetAutoObjective(LastAutoObjective);
	}
	//return;	
}

function InitiatePlayEngineFeedback(float Delay)
{
	((Delay == 0.0000000) ? PlayEngineForceFeedback() : SetTimer(Delay, false, 'PlayEngineForceFeedback'));
	//return;	
}

function InitiateStopEngineFeedback(float Delay)
{
	((Delay == 0.0000000) ? StopEngineForceFeedback() : SetTimer(Delay, false, 'StopEngineForceFeedback'));
	//return;	
}

function PlayEngineForceFeedback()
{
	// End:0x37
	if(EngineWaveform != none)
	{
		ClearTimer('StopEngineForceFeedback');
		ClientPlayForceFeedbackWaveform(EngineWaveform);
	}
	//return;	
}

function StopEngineForceFeedback()
{
	// End:0x36
	if(EngineWaveform != none)
	{
		ClearTimer('PlayEngineForceFeedback');
		ClientStopForceFeedbackWaveform(EngineWaveform);
	}
	//return;	
}

function UpdateEngineWaveform(float Left, float Right)
{
	// End:0x8D
	if(EngineWaveform != none)
	{
		EngineWaveform.Samples[0].LeftAmplitude = byte(Left);
		EngineWaveform.Samples[0].RightAmplitude = byte(Right);
	}
	//return;	
}

function OpenHVCMenu(HaloVehicleCustomizationPanel HVCP)
{
	//return;	
}

function TookDamage()
{
	//return;	
}

event PlayerTick(float DeltaTime)
{
	CheckForProfileUpdate();
	TickUseButtonTimer(DeltaTime);
	// End:0x51
	if((ActionableStudGrid != none) || StudGridsInRange.Length > 0)
	{
		TickActionableBuildPads(DeltaTime);
	}
	TickBaseEnhancementTriggers(DeltaTime);
	TickVehicleCustomizationTriggers(DeltaTime);
	TickCompass(DeltaTime);
	TickAutoAim(DeltaTime);
	TickBreadcrumbs(DeltaTime);
	super(PlayerController).PlayerTick(DeltaTime);
	//return;	
}

function DoWeaponPickup()
{
	local HaloDroppedPickup testPickup, bestPickup;
	local float testDistSq, BestDistSq;

	// End:0x23
	if((Pawn == none) || (IsLocalController()) == false)
	{
		return;
	}
	BestDistSq = 100000000.0000000;
	// End:0xE7
	foreach Pawn.TouchingActors(Class'MegaHaloGame.HaloDroppedPickup', testPickup)
	{
		testDistSq = VSizeSq(testPickup.Location - Pawn.Location);
		// End:0xE6
		if(testDistSq < BestDistSq)
		{
			bestPickup = testPickup;
			BestDistSq = testDistSq;
		}		
	}	
	// End:0x10A
	if(bestPickup != none)
	{
		ServerWeaponPickup(bestPickup);
	}
	//return;	
}

reliable server function ServerWeaponPickup(HaloDroppedPickup Pickup)
{
	// End:0x73
	if(HaloPlayerInventoryManager(Pawn.InvManager) != none)
	{
		HaloPlayerInventoryManager(Pawn.InvManager).AddDroppedPickup(Pickup);
	}
	//return;	
}

simulated function SetActiveWeaponCloset(HaloWeaponCloset closet)
{
	// End:0x25
	if(closet != none)
	{
		ActiveWeaponCloset = closet;		
	}
	else
	{
		ActiveWeaponCloset = none;
	}
	//return;	
}

simulated function NotifyOfPawnReadyForPossession(Pawn PawnToPossess)
{
	local Pawn prevPawn;
	local Actor.ECollisionType collType;

	collType = 2;
	prevPawn = Pawn;
	StopFire();
	// End:0x6C
	if(int(Role) < int(ROLE_Authority))
	{
		ReplicateMove(0.1000000, vect(0.0000000, 0.0000000, 0.0000000), ROLE_None, rot(0, 0, 0));		
	}
	else
	{
		ProcessMove(0.1000000, vect(0.0000000, 0.0000000, 0.0000000), ROLE_None, rot(0, 0, 0));
	}
	self.UnPossess();
	self.Possess(PawnToPossess, false);
	// End:0x197
	if(prevPawn != none)
	{
		collType = prevPawn.CollisionType;
		// End:0x15E
		if(prevPawn.InvManager != none)
		{
			prevPawn.InvManager.ClearInventory();
		}
		prevPawn.PlayTeleportEffect(true, false);
		prevPawn.Destroy();
	}
	PawnToPossess.SetHidden(false);
	PawnToPossess.SetCollisionType(collType);
	PawnClass = PawnToPossess.Class;
	//return;	
}

event InitInputSystem()
{
	local LocalPlayer LocalPlayer;

	super.InitInputSystem();
	LocalPlayer = LocalPlayer(Player);
	// End:0xA0
	if((LocalPlayer != none) && LocalPlayer.ControllerId == 0)
	{
		LocalPlayer.ViewportClient.__HandleInputKey__Delegate = HandleInputKey;
	}
	//return;	
}

function bool HandleInputKey(int ControllerId, name Key, Object.EInputEvent EventType, float AmountDepressed, optional bool gamePad)
{
	local LocalPlayer LocalPlayer, joiningLocalPlayer;
	local string Error;
	local int PlayerCount;
	local PlayerController PlayerController;

	// End:0x230
	if(((int(EventType) == int(0)) && Key == 'XboxTypeS_Start') && ControllerId != 0)
	{
		PlayerCount = 0;
		// End:0x8A
		foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PlayerController)
		{
			PlayerCount++;			
		}		
		// End:0x172
		if(PlayerCount < 2)
		{
			LocalPlayer = LocalPlayer(Player);
			// End:0x16D
			if(LocalPlayer != none)
			{
				joiningLocalPlayer = LocalPlayer.ViewportClient.FindPlayerByControllerId(ControllerId);
				// End:0x16D
				if(joiningLocalPlayer == none)
				{
					joiningLocalPlayer = LocalPlayer.ViewportClient.CreatePlayer(ControllerId, Error, true);
				}
			}
			return true;			
		}
		else
		{
			// End:0x22F
			foreach LocalPlayerControllers(Class'Engine.PlayerController', PlayerController)
			{
				LocalPlayer = LocalPlayer(PlayerController.Player);
				// End:0x22E
				if(LocalPlayer.ControllerId == ControllerId)
				{
					LocalPlayer.ViewportClient.RemovePlayer(LocalPlayer);					
					return true;
				}				
			}			
		}
	}
	return false;
	//return ReturnValue;	
}

function DisplayTextToHUD(SeqAct_DisplayTextToHUD Action)
{
	local GFxHaloHUD HUD;

	HUD = GFxHaloHUD(myHUD);
	// End:0x53
	if(HUD != none)
	{
		HUD.DisplayText(Action);
	}
	//return;	
}

function DisplayMessage(SeqAct_DisplayMessage Action)
{
	local GFxHaloHUD HUD;

	HUD = GFxHaloHUD(myHUD);
	// End:0x53
	if(HUD != none)
	{
		HUD.DisplayMessage(Action);
	}
	//return;	
}

function SetCinematicMode(bool bInCinematicMode, bool bHidePlayer, bool bAffectsHUD, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsButtons)
{
	local int I;
	local HaloVehicle V;

	V = HaloVehicle(Pawn);
	// End:0x57
	if(bInCinematicMode == true)
	{		
		ConsoleCommand("DisableSplitscreen");		
	}
	else
	{		
		ConsoleCommand("EnableSplitscreen");
	}
	// End:0x20A
	if(bInCinematicMode && bHidePlayer)
	{
		// End:0x1F0
		if(V != none)
		{
			I = 0;
			J0xB4:

			// End:0x1C3 [Loop If]
			if(I < V.Seats.Length)
			{
				// End:0x1B5
				if(V.Seats[I].bSeatVisible && V.Seats[I].StoragePawn != none)
				{
					V.Seats[I].StoragePawn.SetHidden(true);
				}
				++I;
				// [Loop Continue]
				goto J0xB4;
			}
			// End:0x1F0
			if(bAffectsMovement)
			{
				V.SetDriving(false);
			}
		}
		// End:0x207
		if(bIsAimingTargetDesignator)
		{
			CancelTargetDesignator();
		}		
	}
	else
	{
		// End:0x353
		if(V != none)
		{
			I = 0;
			J0x224:

			// End:0x333 [Loop If]
			if(I < V.Seats.Length)
			{
				// End:0x325
				if(V.Seats[I].bSeatVisible && V.Seats[I].StoragePawn != none)
				{
					V.Seats[I].StoragePawn.SetHidden(false);
				}
				++I;
				// [Loop Continue]
				goto J0x224;
			}
			V.SetDriving(true);
		}
	}
	super(PlayerController).SetCinematicMode(bInCinematicMode, bHidePlayer, bAffectsHUD, bAffectsMovement, bAffectsTurning, bAffectsButtons);
	//return;	
}

function PawnDied(Pawn P)
{
	local HaloPawn HP;

	// End:0x62
	if(BlokCollector != none)
	{
		HP = HaloPawn(P);
		// End:0x62
		if(HP != none)
		{
			BlokCollector.ThrowBloks(HP);
		}
	}
	ActionableStudGrid = none;
	StudGridsInRange.Length = 0;
	ClearTargetDesignatorState();
	super.PawnDied(P);
	//return;	
}

function AddDeploymentMonitor(HaloDeploymentMonitor HDM)
{
	// End:0x36
	if(DeploymentMonitors.Find(HDM) == -1)
	{
		DeploymentMonitors.AddItem(HDM);
	}
	//return;	
}

function RemoveDeploymentMonitor(HaloDeploymentMonitor HDM)
{
	DeploymentMonitors.RemoveItem(HDM);
	//return;	
}

function NotifyOfDeployment(IHaloDeployable deployable)
{
	local HaloDeploymentMonitor HDM;
	local HaloPlayerPawnController PC;
	local array<HaloDeploymentMonitor> DoneList;

	// End:0x59
	foreach DeploymentMonitors(HDM)
	{
		// End:0x58
		if(HDM.NotifyOfDeployment(deployable))
		{
			DoneList.AddItem(HDM);
		}		
	}	
	// End:0xD0
	foreach WorldInfo.AllControllers(Class'MegaHaloGame.HaloPlayerPawnController', PC)
	{
		// End:0xCE
		foreach DoneList(HDM)
		{
			PC.RemoveDeploymentMonitor(HDM);			
		}				
	}	
	//return;	
}

function Restart(bool bVehicleTransition)
{
	bPawnControlsLocked = false;
	super.Restart(bVehicleTransition);
	//return;	
}

simulated function bool StartConstructionBuildPadMode(Actor Target)
{
	local HaloPawn P;

	// End:0x93
	if((((((WorldInfo.TimeSeconds - LastConstructionToggleTime) < 2.0000000) || Pawn == none) || int(Pawn.Physics) != int(1)) || ActiveConstructionTrigger == none) || BlokCollector == none)
	{
		return false;
	}
	P = HaloPawn(Pawn);
	// End:0x108
	if(((P == none) || P.IsBusy()) || P.IsGrabbingLedge())
	{
		return false;
	}
	LastConstructionToggleTime = WorldInfo.TimeSeconds;
	ActiveConstructionPadTarget = HaloConstructionBuildPad(Target);
	// End:0x180
	if((IsInState('ConstructionBuildState') == false) && ActiveConstructionPadTarget != none)
	{
		GotoState('ConstructionBuildStateTransitionIn');
		return true;
	}
	return false;
	//return ReturnValue;	
}

function TickBreadcrumbs(float DeltaTime)
{
	local bool IsValid;
	local float breadcrumbMinDistanceSq;
	local SVehicle aVehicle;
	local int I;

	// End:0x179
	if(Pawn != none)
	{
		// End:0xA0
		if(((Pawn.Base != none) && InterpActor(Pawn.Base) == none) && DynamicBlockingVolume(Pawn.Base) == none)
		{
			IsValid = true;			
		}
		else
		{
			// End:0x179
			if(SVehicle(Pawn) != none)
			{
				IsValid = true;
				aVehicle = SVehicle(Pawn);
				I = 0;
				J0xEB:

				// End:0x179 [Loop If]
				if(I < aVehicle.Wheels.Length)
				{
					// End:0x16B
					if(aVehicle.Wheels[I].bWheelOnGround == false)
					{
						IsValid = false;
						// [Explicit Break]
						goto J0x179;
					}
					I++;
					// [Loop Continue]
					goto J0xEB;
				}
			}
		}
	}
	J0x179:

	// End:0x26B
	if(IsValid == true)
	{
		breadcrumbMinDistanceSq = MinBreadcrumbDistance * MinBreadcrumbDistance;
		// End:0x26B
		if(((BreadcrumbList.Length == 0) || bForciblyAddNextValidBreadcrumb) || VSizeSq(Pawn.Location - BreadcrumbList[BreadcrumbList.Length - 1]) > breadcrumbMinDistanceSq)
		{
			BreadcrumbList.AddItem(Pawn.Location);
			// End:0x25F
			if(BreadcrumbList.Length > MaxBreadcrumbListSize)
			{
				BreadcrumbList.Remove(0, 1);
			}
			bForciblyAddNextValidBreadcrumb = false;
		}
	}
	//return;	
}

function bool FindABreadcrumbSpot(const Vector Extent, out Vector Spot)
{
	local Vector aLocation;
	local int I;

	// End:0xAC
	if(Pawn != none)
	{
		I = BreadcrumbList.Length - 1;
		J0x26:

		// End:0xAC [Loop If]
		if(I >= 0)
		{
			aLocation = BreadcrumbList[I];
			// End:0x9E
			if(Pawn.FindSpot(Extent, aLocation) == true)
			{
				Spot = aLocation;
				return true;
			}
			I--;
			// [Loop Continue]
			goto J0x26;
		}
	}
	return false;
	//return ReturnValue;	
}

function bool FindANearbyBreadcrumbSpot(out Vector Spot, const Vector Extent, optional float MaxDistance = 0.0000000)
{
	local Vector aLocation;
	local int I;

	// End:0x104
	if(Pawn != none)
	{
		I = BreadcrumbList.Length - 1;
		J0x2F:

		// End:0x104 [Loop If]
		if(I >= 0)
		{
			aLocation = BreadcrumbList[I];
			// End:0xAA
			if((MaxDistance > float(0)) && VSize(aLocation - Pawn.Location) > MaxDistance)
			{				
			}
			else
			{
				// End:0xF6
				if(Pawn.FindSpot(Extent, aLocation) == true)
				{
					Spot = aLocation;
					return true;
				}
			}
			I--;
			// [Loop Continue]
			goto J0x2F;
		}
	}
	return false;
	//return ReturnValue;	
}

simulated event byte ScriptGetTeamNum()
{
	return cachedTeamNum;
	//return ReturnValue;	
}

function TickCompass(float DeltaTime)
{
	// End:0x8F
	if(bUpdateCompassPath == false)
	{
		RepathTimer += DeltaTime;
		// End:0x8F
		if(RepathTimer >= RepathDelay)
		{
			// End:0x62
			if(bIsCompassPathValid)
			{
				bUpdateCompassPath = !IsPathStillValid();				
			}
			else
			{
				bUpdateCompassPath = ShouldHavePath(DeltaTime);
			}
			RepathTimer = 0.0000000;
		}
	}
	// End:0xC4
	if(bUpdateCompassPath == true)
	{
		RepathTimer = 0.0000000;
		UpdateCompassPath();
		bUpdateCompassPath = false;
	}
	// End:0x143
	if(bIsCompassPathValid)
	{
		// End:0x143
		if(CompassPath.Length > 1)
		{
			// End:0x143
			if(Pawn != none)
			{
				// End:0x143
				if(VSizeSq(CompassPath[0] - Pawn.Location) < (DistToAdvancePath * DistToAdvancePath))
				{
					CompassPath.Remove(0, 1);
				}
			}
		}
	}
	//return;	
}

function bool IsPathStillValid()
{
	// End:0x15
	if(CompassPath.Length == 0)
	{
		return false;		
	}
	else
	{
		// End:0x6C
		if(Pawn != none)
		{
			// End:0x6C
			if(VSizeSq(CompassPath[0] - Pawn.Location) > (DistToRepath * DistToRepath))
			{
				return false;
			}
		}
	}
	return true;
	//return ReturnValue;	
}

function bool ShouldHavePath(float DeltaTime)
{
	local HaloGameDefault HGD;
	local HaloPlayerPawnController HPPC;

	// End:0x12
	if(bShouldHavePath)
	{
		return true;		
	}
	else
	{
		HGD = HaloGameDefault(WorldInfo.Game);
		// End:0xCE
		if(HGD != none)
		{
			// End:0xCD
			foreach HGD.TheMainPlayerGroup.PlayerControllers(HPPC)
			{
				// End:0xCC
				if((HPPC != none) && HPPC.bShouldHavePath == true)
				{					
					return true;
				}				
			}			
		}
	}
	return false;
	//return ReturnValue;	
}

function UpdateCompassPath()
{
	local bool bNavigate;
	local Actor compassNavPoint;

	CompassPath.Length = 0;
	bNavigate = GetHighestPriorityNavigationPoint(compassNavPoint);
	// End:0x109
	if(compassNavPoint != none)
	{
		bShouldHavePath = true;
		// End:0xCF
		if(bNavigate == true)
		{
			bIsCompassPathValid = FindPath(compassNavPoint.Location, CompassPath);
			// End:0xCC
			if(bIsCompassPathValid == false)
			{
				CompassPath.AddItem(compassNavPoint.Location);
			}			
		}
		else
		{
			bIsCompassPathValid = true;
			CompassPath.AddItem(compassNavPoint.Location);
		}		
	}
	else
	{
		bShouldHavePath = false;
		bIsCompassPathValid = false;
	}
	//return;	
}

function bool GetHighestPriorityNavigationPoint(out Actor NavPoint)
{
	local HaloMission ActiveMission;
	local HaloGameDefault Game;

	Game = HaloGameDefault(WorldInfo.Game);
	// End:0xA1
	if(Game != none)
	{
		ActiveMission = Game.GetActiveMission();
		// End:0xA1
		if(ActiveMission != none)
		{
			return ActiveMission.GetHighestPriorityNavigationPoint(NavPoint);
		}
	}
	NavPoint = none;
	return false;
	//return ReturnValue;	
}

function bool CompassHasPath()
{
	return CompassPath.Length > 0;
	//return ReturnValue;	
}

function Vector GetCurrentCompassTarget()
{
	// End:0x1C
	if(CompassPath.Length > 0)
	{
		return CompassPath[0];
	}
	return vect(0.0000000, 0.0000000, 0.0000000);
	//return ReturnValue;	
}

function NotifyLedgeGrab(bool Enabled, optional bool Jumping)
{
	// End:0x1C
	if(Enabled)
	{
		GotoState('PlayerLedgeGrab');
	}
	//return;	
}

exec function LetGoOfLedge()
{
	//return;	
}

function EnableLockedState(bool Enabled)
{
	// End:0x1B
	if(Enabled)
	{
		GotoState('PlayerLocked');
	}
	//return;	
}

simulated function OnTeleport(SeqAct_Teleport Action)
{
	super(Controller).OnTeleport(Action);
	// End:0x2C
	if(Action == none)
	{
		CameraReset();
	}
	//return;	
}

protected simulated function RegisterCustomPlayerDataStores()
{
	local LocalPlayer LP;

	// End:0x19
	if(ProfileSettings != none)
	{
		UnregisterPlayerDataStores();
	}
	LP = LocalPlayer(Player);
	super.RegisterCustomPlayerDataStores();
	// End:0x108
	if(LP != none)
	{
		ProfileSettings = HaloProfileSettings(OnlinePlayerData.ProfileProvider.Profile);
		// End:0xC2
		if(OnlineSub == none)
		{
			ProfileSettings.SetToDefaults();
		}
		PersistentData = HaloPlayerPersistentData(OnlinePlayerData.StorageProvider.Profile);
	}
	//return;	
}

function AddOnlineDelegates(bool bRegisterVoice)
{
	local LocalPlayer LP;

	super.AddOnlineDelegates(bRegisterVoice);
	LP = LocalPlayer(Player);
	// End:0x195
	if(OnlineSub != none)
	{
		// End:0x195
		if(LP != none)
		{
			// End:0x195
			if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
			{
				OnlineSub.PlayerInterface.AddLoginStatusChangeDelegate(OnLoginStatusChange, byte(LP.ControllerId));
				OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
				OnlineSub.PlayerInterface.AddReadPlayerStorageCompleteDelegate(byte(LP.ControllerId), OnPersistentDataReadComplete);
			}
		}
	}
	//return;	
}

event ClearOnlineDelegates()
{
	local LocalPlayer LP;

	super.ClearOnlineDelegates();
	LP = LocalPlayer(Player);
	// End:0x1B2
	if((OnlineSub != none) && (int(Role) < int(ROLE_Authority)) || LP != none)
	{
		// End:0x1B2
		if(LP != none)
		{
			// End:0x1B2
			if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
			{
				OnlineSub.PlayerInterface.ClearLoginStatusChangeDelegate(OnLoginStatusChange, byte(LP.ControllerId));
				OnlineSub.PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
				OnlineSub.PlayerInterface.ClearReadPlayerStorageCompleteDelegate(byte(LP.ControllerId), OnPersistentDataReadComplete);
			}
		}
	}
	//return;	
}

function OnLoginStatusChange(OnlineSubsystem.ELoginStatus NewStatus, UniqueNetId NewId)
{
	// End:0x36
	if(int(NewStatus) == int(0))
	{
		bPersistentDataReadComplete = false;
		bProfileSettingsReadComplete = false;
		RestartFrontEnd();
	}
	// End:0x6D
	if(PlayerReplicationInfo != none)
	{
		PlayerReplicationInfo.SetUniqueId(NewId);
	}
	//return;	
}

function OnLoginChange(byte LocalUserNum)
{
	local LocalPlayer HLP;
	local UniqueNetId NetId;
	local string Gamertag;

	bProfileSettingsReadComplete = false;
	// End:0x28A
	if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
	{
		HLP = LocalPlayer(Player);
		// End:0x1CD
		if((HLP != none) && HLP.ControllerId == int(LocalUserNum))
		{
			OnlineSub.PlayerInterface.GetUniquePlayerId(byte(HLP.ControllerId), NetId);
			PlayerReplicationInfo.SetUniqueId(NetId);
			Gamertag = OnlineSub.PlayerInterface.GetPlayerNickname(byte(HLP.ControllerId));
			// End:0x1CD
			if(Gamertag != "")
			{
				PlayerReplicationInfo.SetPlayerName(Gamertag);				
			}
		}
		// End:0x280
		if(int(OnlineSub.PlayerInterface.GetLoginStatus(LocalUserNum)) == int(0))
		{
			OnPersistentDataReadComplete(LocalUserNum, true);
			OnReadProfileSettingsComplete(LocalUserNum, true);
			// End:0x27D
			if(int(WorldInfo.NetMode) == int(NM_Client))
			{
				ShowLoginChangeError();
				ReturnToMainMenu(true);
			}			
		}
		else
		{
			OnNewLogin();
		}
	}
	//return;	
}

function RestartFrontEnd()
{
	local HaloLocalPlayer LP;

	LP = HaloLocalPlayer(Player);
	// End:0x95
	if(IsPrimaryPlayer())
	{
		// End:0x68
		if(bIsReturningToMainMenu)
		{
			// End:0x68
			if(LP != none)
			{
				LP.bIsFirstFrontEndLoad = true;
				return;
			}
		}
		LP.bIsFirstFrontEndLoad = true;
		ReturnToMainMenu(true, true);
	}
	//return;	
}

event FadeToBlack()
{
	// End:0x45
	if(GFxHaloHUD(myHUD) != none)
	{
		GFxHaloHUD(myHUD).FadeScreenToBlack(1.0000000);
	}
	//return;	
}

event FadeToClear()
{
	// End:0x45
	if(GFxHaloHUD(myHUD) != none)
	{
		GFxHaloHUD(myHUD).FadeScreenToClear(0.5000000);
	}
	//return;	
}

simulated function ReturnToMainMenu(bool bReturnToStartScreen, optional bool bClearMenuHistory)
{
	local HaloLocalPlayer LP;
	local HaloGameDefault Game;

	LP = HaloLocalPlayer(Player);
	LogInternal("BACK TO MAIN MENU");
	// End:0x7C
	if(bIsReturningToMainMenu)
	{
		LogInternal("Client has already started returning to the main menu");
		return;
	}
	LP = HaloLocalPlayer(Player);
	// End:0xF5
	if(LP != none)
	{
		LP.ClearPostProcessSettingsOverride(0.0000000);
		LP.bIsFirstFrontEndLoad = bReturnToStartScreen;
	}
	Game = HaloGameDefault(WorldInfo.Game);
	// End:0x172
	if(Game != none)
	{		
		ConsoleCommand("open " $ Game."Main_Menu");
	}
	//return;	
}

function OnNewLogin()
{
	ShowLoginChangeError();
	//return;	
}

final function ShowLoginChangeError()
{
	local HaloLocalPlayer LP;

	LP = HaloLocalPlayer(Player);
	// End:0x4F
	if((LP != none) && LP.bHasSeenStartScreen)
	{
	}
	//return;	
}

function OnPersistentDataReadComplete(byte LocalUserNum, bool bWasSuccessful)
{
	PersistentData = HaloPlayerPersistentData(OnlinePlayerData.StorageProvider.Profile);
	LogInternal((((((("OnPersistentDataReadComplete SUCCESS=" $ string(bWasSuccessful)) $ " USERNUM=") $ string(LocalUserNum)) $ " PS=") $ string(ProfileSettings)) $ " DeviceId=") $ string(PersistentData.DeviceID));
	bPersistentDataReadComplete = true;
	ProfileSettings.SetProfileSettingValueInt(ProfileSettings.35, PersistentData.DeviceID);
	ClientSaveAllPlayerData(true, true);
	//return;	
}

function OnReadProfileSettingsComplete(byte LocalUserNum, bool bWasSuccessful)
{
	ProfileSettings = HaloProfileSettings(OnlinePlayerData.ProfileProvider.Profile);
	LogInternal((((("OnReadProfileSettingsComplete SUCCESS=" $ string(bWasSuccessful)) $ " USERNUM=") $ string(LocalUserNum)) $ " PS=") $ string(ProfileSettings));
	bProfileSettingsReadComplete = true;
	bHasSigninChanged = false;
	bProfileSettingsUpdated = true;
	// End:0xF3
	if(bWasSuccessful && ProfileSettings != none)
	{		
	}
	else
	{
		LogInternal("WARNING: OnReadProfileSettingsComplete was not successful!!!");
	}
	//return;	
}

function CheckForProfileUpdate()
{
	// End:0x5B
	if((bProfileSettingsUpdated && ProfileSettings != none) && ProfileSettings.ProfileSettings.Length > 0)
	{
		UpdateLocalCacheOfProfileSettings();
		bProfileSettingsUpdated = false;
	}
	//return;	
}

exec function UpdateLocalCacheOfProfileSettings()
{
	local int Value;
	local HaloGameDefault Game;

	Game = HaloGameDefault(WorldInfo.Game);
	// End:0x263
	if((Game != none) && !Game.bIsDemoMode)
	{
		UpdateControllerConfig();
		ProfileSettings.GetProfileSettingValueId(ProfileSettings.34, Value);
		bMarkAutoAimTargets = bool(Value);
		ProfileSettings.GetProfileSettingValueInt(ProfileSettings.35, Value);
		SetDeviceId(Value);
		ProfileSettings.GetProfileSettingValueId(ProfileSettings.36, Value);
		// End:0x17C
		if(bool(Value))
		{
			CameraEncounterDisableRemove(Name);			
		}
		else
		{
			CameraEncounterDisableAdd(Name);
		}
		LogInternal((((((("UpdateLocalCacheOfProfileSettings: YInversion=" $ string(ProfileSettings.GetInvertMouseOption())) $ " MarkAutoAim=") $ string(bMarkAutoAimTargets)) $ " Camera Encounter View=") $ string()) $ " StorageDeviceId=") $ string(PersistentData.DeviceID));
	}
	//return;	
}

function int GetDeviceId()
{
	// End:0x2E
	if(PersistentData != none)
	{
		return PersistentData.DeviceID;
	}
	return -1;
	//return ReturnValue;	
}

function SetDeviceId(int DeviceID)
{
	// End:0x37
	if(PersistentData != none)
	{
		PersistentData.DeviceID = DeviceID;
	}
	//return;	
}

function bool IsStorageDeviceValid()
{
	// End:0x76
	if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
	{
		return OnlineSub.PlayerInterfaceEx.IsDeviceValid(GetDeviceId());
	}
	return true;
	//return ReturnValue;	
}

function UpdateControllerConfig()
{
	// End:0x4E
	if(ProfileSettings != none)
	{
		PlayerInput.bInvertMouse = ProfileSettings.GetInvertMouseOption();
	}
	//return;	
}

reliable client simulated function ClientSaveAllPlayerData(optional bool bShouldForce, optional bool bSkipCacheUpdate)
{
	local HaloLocalPlayer LP;

	LP = HaloLocalPlayer(Player);
	LogInternal("SAVING PROFILE SETTINGS NOW ###### ");
	// End:0x103
	if(((LP != none) && (WorldInfo.RealTimeSeconds - LP.LastSaveTime) >= TimeBetweenSaves) || bShouldForce)
	{
		LP.LastSaveTime = WorldInfo.RealTimeSeconds;
		SaveProfile();
		SavePersistentData();
	}
	// End:0x128
	if(!bSkipCacheUpdate)
	{
		UpdateLocalCacheOfProfileSettings();
		bProfileSettingsUpdated = false;
	}
	//return;	
}

private final function SavePersistentData()
{
	local OnlinePlayerInterface PlayerInt;
	local int ControllerId;

	ControllerId = LocalPlayer(Player).ControllerId;
	// End:0xED
	if(OnlineSub != none)
	{
		PlayerInt = OnlineSub.PlayerInterface;
		// End:0xED
		if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
		{
			// End:0xED
			if(ControllerId != -1)
			{
				PlayerInt.WritePlayerStorage(byte(ControllerId), PersistentData, PersistentData.DeviceID);
			}
		}
	}
	//return;	
}

private final function SaveProfile()
{
	local int ControllerId;

	ControllerId = LocalPlayer(Player).ControllerId;
	// End:0xE2
	if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
	{
		// End:0xE2
		if(ControllerId != -1)
		{
			// End:0xE2
			if(!bHasSigninChanged)
			{
				OnlineSub.PlayerInterface.WriteProfileSettings(byte(ControllerId), ProfileSettings);
			}
		}
	}
	//return;	
}

event LevelStreamingStatusChanged(LevelStreaming LevelObject, bool bNewShouldBeLoaded, bool bNewShouldBeVisible, bool bNewShouldBlockOnLoad)
{
	super(PlayerController).LevelStreamingStatusChanged(LevelObject, bNewShouldBeLoaded, bNewShouldBeVisible, bNewShouldBlockOnLoad);
	bForciblyAddNextValidBreadcrumb = true;
	//return;	
}

function JsonObject Serialize()
{
	local HaloPlayerInventoryManager InvManager;
	local JsonObject Data, serializedObjData;

	Data = new Class'Engine.JsonObject';
	// End:0x1D5
	if(Data != none)
	{
		Data.SetStringValue("Name", PathName(self));
		Data.SetStringValue("ObjectArchetype", PathName(ObjectArchetype));
		Data.SetStringValue("CharacterRole", PathName(Pawn.Class));
		InvManager = HaloPlayerInventoryManager(Pawn.InvManager);
		// End:0x18C
		if(InvManager != none)
		{
			serializedObjData = InvManager.Serialize();
			Data.SetObject("Inventory", serializedObjData);
		}
		Data.SetIntValue("BlokCount", BlokCollector.GetBankCount());
	}
	return Data;
	//return ReturnValue;	
}

function Deserialize(JsonObject Data)
{
	local HaloPlayerInventoryManager InvManager;

	InvManager = HaloPlayerInventoryManager(Pawn.InvManager);
	// End:0x89
	if(InvManager != none)
	{
		InvManager.Deserialize(Data.GetObject("Inventory"));
	}
	BlokCollector.Bank = Data.GetIntValue("BlokCount");
	//return;	
}

state PlayerWalking
{
	event ContinuedState()
	{
		// End:0x26
		if(bIsAimingTargetDesignator && bWasHoldingDownBuildTrigger)
		{
			StartBuilding();
		}
		bWasHoldingDownBuildTrigger = false;
		//return;		
	}

	exec function StartFire(optional byte FireModeNum)
	{
		// End:0x34
		if(!bIsAimingTargetDesignator && !bPawnControlsLocked)
		{
			super(PlayerController).StartFire(FireModeNum);
		}
		//return;		
	}

	exec function StopFire(optional byte FireModeNum)
	{
		// End:0x23
		if(!bIsAimingTargetDesignator)
		{
			super(PlayerController).StopFire(FireModeNum);
		}
		//return;		
	}

	exec function StartBuilding()
	{
		// End:0x5F
		if(((bIsAimingTargetDesignator && TDWeapon != none) && !bCinematicMode) && !bPawnControlsLocked)
		{
			TDWeapon.StartPullingTrigger();
		}
		//return;		
	}

	exec function StopBuilding()
	{
		// End:0x3D
		if(bIsAimingTargetDesignator && TDWeapon != none)
		{
			TDWeapon.ReleaseTrigger();
		}
		//return;		
	}

	function ProcessPlayerRotation(float DeltaTime, Vector desiredMotion)
	{
		local HaloPawn HaloPawn;
		local bool isAiming, isMoving, snapLegs;
		local Actor AimTarget;
		local Vector AimDir;
		local Rotator AimRot, legRot, desiredMotionRot;

		isMoving = VSizeSq(desiredMotion) > 0.0000001;
		HaloPawn = HaloPawn(Pawn);
		// End:0x130
		if((HaloPawn != none) && HaloPawn.MeleeTarget != none)
		{
			isAiming = true;
			AimTarget = HaloPawn.MeleeTarget;
			AimDir = HaloPawn.MeleeTarget.Location - Pawn.Location;
			AimDir.Z = 0.0000000;
			snapLegs = true;			
		}
		else
		{
			// End:0x158
			if(IsTargetLocked())
			{
				isAiming = true;
				snapLegs = true;				
			}
			else
			{
				// End:0x1D0
				if(HaloPawn != none)
				{
					isAiming = HaloPawn.bIsGunRaised || IsAutoAimEnabled == true;
					snapLegs = HaloPawn.IsThrowingGrenade();					
				}
				else
				{
					isAiming = Pawn.IsFiring();
				}
			}
			// End:0x289
			if((isAiming && !bIsAimingTargetDesignator) && !IsZooming())
			{
				AimTarget = GetCameraAutoAimTarget();
				// End:0x289
				if(AimTarget != none)
				{
					AimDir = (BestAutoAimTargetLocation(AimTarget)) - Pawn.Location;
				}
			}
		}
		// End:0x590
		if(isAiming)
		{
			// End:0x2E8
			if(AimTarget != none)
			{
				// End:0x2D0
				if(VSizeSq(AimDir) < 0.0000001)
				{
					AimRot = WeaponAimRotation;					
				}
				else
				{
					AimRot = Rotator(AimDir);
				}				
			}
			else
			{
				// End:0x36F
				if(IsAutoAimEnabled == true)
				{
					AimRot.Yaw = PlayerCamera.ViewTarget.POV.Rotation.Yaw;					
				}
				else
				{
					AimRot = WeaponAimRotation;
					// End:0x43D
					if(isMoving)
					{
						desiredMotionRot = Rotator(desiredMotion);
						AimRot.Yaw = TetherAngle(AimRot.Yaw, desiredMotionRot.Yaw, 16384);
						AimRot = RInterpTo(AimRot, desiredMotionRot, DeltaTime, 81920.0000000, true);
					}
				}
			}
			// End:0x486
			if(snapLegs)
			{
				legRot.Yaw = AimRot.Yaw;				
			}
			else
			{
				legRot.Yaw = TetherAngle(Pawn.Rotation.Yaw, AimRot.Yaw, ((isMoving) ? 8192 : 16384));
				// End:0x58D
				if(isMoving)
				{
					legRot.Yaw = LerpAngle(legRot.Yaw, AimRot.Yaw, 65536.0000000, DeltaTime);
				}
			}			
		}
		else
		{
			// End:0x799
			if(isMoving)
			{
				desiredMotionRot = Rotator(desiredMotion);
				// End:0x5FB
				if(snapLegs)
				{
					legRot.Yaw = desiredMotionRot.Yaw;					
				}
				else
				{
					legRot.Yaw = TetherAngle(Pawn.Rotation.Yaw, desiredMotionRot.Yaw, 16384);
					legRot.Yaw = LerpAngle(legRot.Yaw, desiredMotionRot.Yaw, 65536.0000000, DeltaTime);
				}
				AimRot = WeaponAimRotation;
				AimRot.Yaw += (legRot.Yaw - Pawn.Rotation.Yaw);
				AimRot = RInterpTo(AimRot, desiredMotionRot, DeltaTime, 16384.0000000, true);				
			}
			else
			{
				legRot = Pawn.Rotation;
				AimRot.Yaw = LerpAngle(WeaponAimRotation.Yaw, legRot.Yaw, 65536.0000000, DeltaTime);
			}
		}
		WeaponAimRotation = AimRot;
		SetRotation(AimRot);
		Pawn.SetRotation(legRot);
		Pawn.SetDesiredRotation(legRot);
		//return;		
	}

	function bool IsMoveInputIgnored()
	{
		// End:0x1E
		if(bIsAimingTargetDesignator || IsZooming())
		{
			return true;
		}
		return super(PlayerController).IsMoveInputIgnored();
		//return ReturnValue;		
	}

	function ProcessPlayerMotion(float DeltaTime, Vector2D leftStick)
	{
		local Vector newAccel;
		local Rotator OldRotation;
		local bool bSaveJump;
		local Vector desiredMotion;

		// End:0x20
		if(Pawn == none)
		{
			GotoState('Dead');			
		}
		else
		{
			desiredMotion = CalcDesiredMotion(DeltaTime, leftStick);
			newAccel = Pawn.AccelRate * desiredMotion;
			// End:0x99
			if(IsLocalPlayerController())
			{
				AdjustPlayerWalkingMoveAccel(newAccel);
			}
			OldRotation = Rotation;
			ProcessPlayerRotation(DeltaTime, desiredMotion);
			bDoubleJump = false;
			// End:0x120
			if(bPressedJump && Pawn.CannotJumpNow())
			{
				bSaveJump = true;
				bPressedJump = false;				
			}
			else
			{
				bSaveJump = false;
			}
			// End:0x176
			if(int(Role) < int(ROLE_Authority))
			{
				ReplicateMove(DeltaTime, newAccel, 0, OldRotation - Rotation);				
			}
			else
			{
				ProcessMove(DeltaTime, newAccel, 0, OldRotation - Rotation);
			}
			bPressedJump = bSaveJump;
		}
		//return;		
	}

	function Rotator CalcDesiredRotation(float DeltaTime, Vector desiredMotion)
	{
		// End:0x1F
		if(VSize(desiredMotion) > float(0))
		{
			return Rotator(desiredMotion);
		}
		return Rotation;
		//return ReturnValue;		
	}

	function Rotator CalcDesiredAttackRotation(float DeltaTime)
	{
		local Vector ViewLocation;
		local Rotator ViewRotation;

		GetPlayerViewPoint(ViewLocation, ViewRotation);
		return ViewRotation;
		//return ReturnValue;		
	}

	function Vector CalcDesiredMotion(float DeltaTime, Vector2D leftStick)
	{
		local Vector Direction, ViewLocation;
		local Rotator ViewRotation;

		// End:0xB4
		if(!IsMoveInputIgnored() && !IsGrabbingLedge())
		{
			Direction.X = leftStick.Y;
			Direction.Y = leftStick.X;
			Direction.Z = 0.0000000;
		}
		PlayerInputRawPawnMotion = Direction;
		// End:0x1A9
		if(VSize(Direction) > float(0))
		{
			Direction = Normal(Direction);
			GetPlayerViewPoint(ViewLocation, ViewRotation);
			Direction = Direction >> ViewRotation;
			Direction.Z = 0.0000000;
			// End:0x19F
			if(bLockMotionDuringTargetedMelee && HaloPawn(Pawn).MeleeTarget != none)
			{
				Direction = vect(0.0000000, 0.0000000, 0.0000000);
			}
			return Direction;
		}
		return vect(0.0000000, 0.0000000, 0.0000000);
		//return ReturnValue;		
	}

	function ProcessPlayerAim(float DeltaTime, Vector2D leftStick, Vector2D rightStick)
	{
		// End:0x79
		if(bCinematicMode == true)
		{
			PlayerInputRawViewMotion.X = 0.0000000;
			PlayerInputRawViewMotion.Y = 0.0000000;
			PlayerInputRawViewMotion.Z = 0.0000000;			
		}
		else
		{
			// End:0x18F
			if((bIsAimingTargetDesignator == true) || (IsZooming()) == true)
			{
				PlayerInputRawViewMotion.X = leftStick.X;
				PlayerInputRawViewMotion.Y = 0.0000000;
				PlayerInputRawViewMotion.Z = leftStick.Y;
				// End:0x18C
				if(PlayerInput.bInvertMouse)
				{
					PlayerInputRawViewMotion.Z = -PlayerInputRawViewMotion.Z;
				}				
			}
			else
			{
				PlayerInputRawViewMotion.X = rightStick.X;
				PlayerInputRawViewMotion.Y = 0.0000000;
				PlayerInputRawViewMotion.Z = -rightStick.Y;
				// End:0x282
				if(PlayerInput.bInvertMouse)
				{
					PlayerInputRawViewMotion.Z = -PlayerInputRawViewMotion.Z;
				}
			}
		}
		//return;		
	}

	function Vector2D ApplyDeadZone(float stickX, float stickY)
	{
		local Vector2D stickValue;
		local float magnitude;

		stickValue.X = stickX;
		stickValue.Y = stickY;
		magnitude = (stickValue.X * stickValue.X) + (stickValue.Y * stickValue.Y);
		// End:0x1A3
		if(magnitude > float(0))
		{
			magnitude = Sqrt(magnitude);
			// End:0x15F
			if(magnitude > DeadZone)
			{
				DivideEqual_Vector2DFloat(stickValue, magnitude);
				MultiplyEqual_Vector2DFloat(stickValue, (magnitude - DeadZone) / (float(1) - DeadZone));				
			}
			else
			{
				stickValue.X = 0.0000000;
				stickValue.Y = 0.0000000;
			}
		}
		return stickValue;
		//return ReturnValue;		
	}

	function PlayerMove(float DeltaTime)
	{
		local Vector2D leftStick, rightStick;

		leftStick = ApplyDeadZone(PlayerInput.RawJoyRight, PlayerInput.RawJoyUp);
		rightStick = ApplyDeadZone(PlayerInput.RawJoyLookRight, PlayerInput.RawJoyLookUp);
		rightStick.X = ((rightStick.X == float(0)) ? PlayerInput.aMouseX / 600.0000000 : rightStick.X);
		rightStick.Y = ((rightStick.Y == float(0)) ? -PlayerInput.aMouseY / 600.0000000 : rightStick.Y);
		ProcessPlayerAim(DeltaTime, leftStick, rightStick);
		ProcessPlayerMotion(DeltaTime, leftStick);
		//return;		
	}

	unreliable server function ServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte MoveFlags, byte ClientRoll, int View)
	{
		local float DeltaTime;
		local Rotator OldRotation, DeltaRot;
		local Vector Accel;

		// End:0x19
		if(CurrentTimeStamp >= TimeStamp)
		{
			return;
		}
		// End:0x5A
		if(AcknowledgedPawn != Pawn)
		{
			InAccel = vect(0.0000000, 0.0000000, 0.0000000);
			GivePawn(Pawn);
		}
		Accel = InAccel * 0.1000000;
		DeltaTime = GetServerMoveDeltaTime(TimeStamp);
		CurrentTimeStamp = TimeStamp;
		ServerTimeStamp = WorldInfo.TimeSeconds;
		// End:0x10F
		if(InAccel != vect(0.0000000, 0.0000000, 0.0000000))
		{
			LastActiveTime = WorldInfo.TimeSeconds;
		}
		OldRotation = Rotation;
		ProcessPlayerRotation(DeltaTime, InAccel);
		DeltaRot = OldRotation - Rotation;
		// End:0x1C2
		if((WorldInfo.Pauser == none) && DeltaTime > float(0))
		{
			MoveAutonomous(DeltaTime, MoveFlags, Accel, DeltaRot);
		}
		ServerMoveHandleClientError(TimeStamp, Accel, ClientLoc);
		//return;		
	}

	exec function Sprint()
	{
		local HaloPawn P;

		// End:0xBB
		if((!bCinematicMode && !bPawnControlsLocked) && !bIsAimingTargetDesignator)
		{
			P = HaloPawn(Pawn);
			// End:0xBB
			if(((P != none) && !P.IsBusy()) && !P.IsGrabbingLedge())
			{
				NetworkGotoState('PlayerSprinting');
			}
		}
		//return;		
	}

	simulated function bool IsGrenadeThrowAllowed()
	{
		local HaloPawn P;

		// End:0xA6
		if((!bCinematicMode && !bIsAimingTargetDesignator) && !bPawnControlsLocked)
		{
			P = HaloPawn(Pawn);
			return ((P != none) && !P.IsBusy()) && !P.IsGrabbingLedge();
		}
		return false;
		//return ReturnValue;		
	}

	exec function ThrowGrenade()
	{
		local HaloPawn P;

		// End:0x57
		if(IsGrenadeThrowAllowed())
		{
			P = HaloPawn(Pawn);
			// End:0x57
			if(P != none)
			{
				P.ThrowGrenade();
			}
		}
		//return;		
	}

	simulated function bool IsMeleeAttackAllowed()
	{
		local HaloPawn P;

		// End:0x95
		if(!bCinematicMode && !bIsAimingTargetDesignator)
		{
			P = HaloPawn(Pawn);
			return ((P != none) && !P.IsBusy()) && !P.IsGrabbingLedge();
		}
		return false;
		//return ReturnValue;		
	}

	exec function RamAttack()
	{
		local HaloPawn P;

		// End:0x6D
		if(IsMeleeAttackAllowed())
		{
			P = HaloPawn(Pawn);
			// End:0x6D
			if(P != none)
			{
				P.RamAttack();
				ToggleZoomLevel = 0;
				DisableZoom();
			}
		}
		//return;		
	}
	stop;	
}

state PlayerSprinting extends PlayerWalking
{
	event BeginState(name PrevStateName)
	{
		local HaloPawn HaloPawn;

		StopFire(0);
		HaloPawn = HaloPawn(Pawn);
		// End:0xD7
		if(HaloPawn != none)
		{
			HaloPawn.GroundSpeed = HaloPawn.SprintGroundSpeed;
			ToggleZoomLevel = 0;
			DisableZoom();
			HaloPawn.TimerLowerGun();
			SetTimer(HaloPawn.SprintTime, false, 'EndSprint');			
		}
		else
		{
			NetworkGotoState('PlayerWalking');
		}
		//return;		
	}

	event EndState(name NextStateName)
	{
		// End:0x4C
		if(Pawn != none)
		{
			Pawn.GroundSpeed = Pawn.default.GroundSpeed;
		}
		ClearTimer('EndSprint');
		// End:0x80
		if(int(bFireButtonState) > int(0))
		{
			StartFire(0);
		}
		//return;		
	}

	function PlayerMove(float DeltaTime)
	{
		// End:0x19
		if(!CanSprint())
		{
			EndSprint();
		}
		super.PlayerMove(DeltaTime);
		//return;		
	}

	function EndSprint()
	{
		NetworkGotoState('PlayerWalking');
		//return;		
	}

	exec function Sprint()
	{
		EndSprint();
		//return;		
	}

	exec function StartFire(optional byte FireModeNum)
	{
		EndSprint();
		// End:0x2D
		if(!bPawnControlsLocked)
		{
			super.StartFire(FireModeNum);
		}
		//return;		
	}

	exec function ThrowGrenade()
	{
		EndSprint();
		super.ThrowGrenade();
		//return;		
	}

	exec function RamAttack()
	{
		EndSprint();
		super.RamAttack();
		//return;		
	}
	stop;	
}

state PlayerDriving
{
	ignores Bump, HearNoise, SeePlayer;

	event BeginState(name PreviousStateName)
	{
		UpdateVehicleControls();
		bVehicleAccel = false;
		bVehicleBrake = false;
		bVehicleStrafe = false;
		ActiveVehiclePanel = none;
		super.BeginState(PreviousStateName);
		//return;		
	}

	event PlayerTick(float DeltaTime)
	{
		local HaloVehicle HV;
		local float Throttle;
		local editinline SVehicleSimCar SimCar;

		CheckForProfileUpdate();
		TickUseButtonTimer(DeltaTime);
		TickBaseEnhancementTriggers(DeltaTime);
		TickCompass(DeltaTime);
		TickBreadcrumbs(DeltaTime);
		HV = HaloVehicle(Pawn);
		// End:0x35B
		if(HV != none)
		{
			SimCar = SVehicleSimCar(HV.SimObj);
			// End:0x35B
			if(HV.KidFriendlyControls)
			{
				// End:0x123
				if(bVehicleAccel && !bVehicleBrake)
				{
					Throttle = 1.0000000;
					HV.ApplyNormalVariables();					
				}
				else
				{
					// End:0x172
					if(!bVehicleAccel && bVehicleBrake)
					{
						Throttle = -1.0000000;
						HV.ApplyBrakingVariables();						
					}
					else
					{
						// End:0x1BF
						if(bVehicleAccel && bVehicleBrake)
						{
							Throttle = 0.0000000;
							HV.ApplyPowerslideVariables();							
						}
						else
						{
							Throttle = 0.0000000;
							HV.ApplyNormalVariables();
						}
					}
				}
				// End:0x2ED
				if((bVehicleAutoBrake && HV.bAutoBrakeEnabled) && Abs(Throttle) <= VehicleMaxThrottleToAutoBrake)
				{
					// End:0x2ED
					if(SimCar != none)
					{
						// End:0x29B
						if(HV.ForwardVel >= SimCar.StopThreshold)
						{
							Throttle = -1.0000000;							
						}
						else
						{
							// End:0x2ED
							if(HV.ForwardVel <= -SimCar.StopThreshold)
							{
								Throttle = 1.0000000;
							}
						}
					}
				}
				HV.GetPlayerInput(PlayerInput, bVehicleAccel, bVehicleBrake, bVehicleStrafe);
				PlayerInput.aBaseY = Throttle;
			}
		}
		super(PlayerController).PlayerTick(DeltaTime);
		//return;		
	}

	function UpdateRotation(float DeltaTime)
	{
		local Rotator DeltaRot, NewRotation, ViewRotation;
		local HaloVehicle HV;
		local float InterpRate, TurretTurnRate;
		local HaloWeaponPawn HWP;

		// End:0x6C9
		if(Pawn != none)
		{
			ViewRotation = Rotation;
			HV = HaloVehicle(Pawn);
			// End:0x138
			if((HV != none) && !HV.bLookSteerOnAllPlatforms)
			{
				HV.GetRotation(ViewRotation);
				InterpRate = HV.GetCamInterpRate();
				Pawn.SetDesiredRotation(ViewRotation);
				VehicleRotator = RInterpTo(VehicleRotator, ViewRotation, DeltaTime, InterpRate);
				SetRotation(VehicleRotator);				
			}
			else
			{
				Pawn.SetDesiredRotation(ViewRotation);
				// End:0x230
				if(HV != none)
				{
					DeltaRot.Yaw = int(PlayerInput.aTurn * HV.CameraLookSteerXSensitivity);
					DeltaRot.Pitch = int(PlayerInput.aLookUp * HV.CameraLookSteerYSensitivity);					
				}
				else
				{
					// End:0x587
					if((HaloTurret(Pawn) != none) || HaloWeaponPawn(Pawn) != none)
					{
						HWP = HaloWeaponPawn(Pawn);
						// End:0x2B8
						if(HWP != none)
						{
							TurretTurnRate = HWP.CameraYawRate;							
						}
						else
						{
							TurretTurnRate = 100.0000000;
						}
						// End:0x382
						if(Abs(PlayerInput.RawJoyRight) >= Abs(PlayerInput.RawJoyLookRight))
						{
							DeltaRot.Yaw = int(((PlayerInput.RawJoyRight * TurretTurnRate) * DeltaTime) * PlayerInput.LookRightScale);							
						}
						else
						{
							DeltaRot.Yaw = int(((PlayerInput.RawJoyLookRight * TurretTurnRate) * DeltaTime) * PlayerInput.LookRightScale);
						}
						// End:0x4B5
						if(Abs(PlayerInput.RawJoyUp) >= Abs(PlayerInput.RawJoyLookUp))
						{
							DeltaRot.Pitch = int((((-PlayerInput.RawJoyUp * 50.0000000) * DeltaTime) * PlayerInput.LookUpScale) * 0.6500000);							
						}
						else
						{
							DeltaRot.Pitch = int(((PlayerInput.RawJoyLookUp * 50.0000000) * DeltaTime) * PlayerInput.LookUpScale);
						}
						// End:0x584
						if(PlayerInput.bInvertMouse == true)
						{
							DeltaRot.Pitch = -DeltaRot.Pitch;
						}						
					}
					else
					{
						DeltaRot.Yaw = int(PlayerInput.aTurn * 0.7500000);
						DeltaRot.Pitch = int(PlayerInput.aLookUp);
					}
				}
				ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
				SetRotation(ViewRotation);
				ViewShake(DeltaTime);
				NewRotation = ViewRotation;
				NewRotation.Roll = Rotation.Roll;
				Pawn.FaceRotation(NewRotation, DeltaTime);
			}
		}
		//return;		
	}

	event Rotator LimitViewRotation(Rotator ViewRotation, float ViewPitchMin, float ViewPitchMax)
	{
		local HaloVehicle HV;
		local float Angle, Pitch, Roll;
		local int Min, Max;

		HV = HaloVehicle(Pawn);
		// End:0x25F
		if(HV != none)
		{
			Angle = HV.GetCameraToVehicleYawAngle();
			Pitch = ((3.1415927 / 2.0000000) - Abs(Angle)) / (3.1415927 / 2.0000000);
			Roll = Abs(1.0000000 - Abs(Pitch));
			// End:0xC4
			if(Angle > float(0))
			{
				Roll *= -1.0000000;
			}
			Min = int((Pitch * float(Pawn.Mesh.Rotation.Pitch)) + (Roll * float(Pawn.Mesh.Rotation.Roll)));
			Max = int(float(Min) + ViewPitchMax);
			Min = int(float(Min) + ViewPitchMin);
			// End:0x20F
			if(ViewRotation.Pitch > Max)
			{
				ViewRotation.Pitch = Max;				
			}
			else
			{
				// End:0x25F
				if(ViewRotation.Pitch < Min)
				{
					ViewRotation.Pitch = Min;
				}
			}
		}
		return ViewRotation;
		//return ReturnValue;		
	}

	exec function StartFire(optional byte FireModeNum)
	{
		local HaloVehicle HV;

		HV = HaloVehicle(Pawn);
		// End:0xAB
		if((!((HV != none) && HV.CanBoost) && HV.bBoostersActivated && !bCinematicMode) && !bPawnControlsLocked)
		{
			super(PlayerController).StartFire(FireModeNum);
		}
		//return;		
	}

	exec function HonkHorn()
	{
		local HaloVehicle HV;

		HV = HaloVehicle(Pawn);
		// End:0x92
		if((((HV != none) && HV.Health > 0) && !bCinematicMode) && !bPawnControlsLocked)
		{
			HV.AttemptPlayHornSound();
		}
		//return;		
	}

	exec function UnhonkHorn()
	{
		local HaloVehicle HV;

		HV = HaloVehicle(Pawn);
		// End:0x70
		if((HV != none) && HV.Health > 0)
		{
			HV.AttemptStopHornSound();
		}
		//return;		
	}

	exec function StartBoost()
	{
		local HaloVehicle HV;

		HV = HaloVehicle(Pawn);
		// End:0x92
		if((((HV != none) && HV.Health > 0) && !bCinematicMode) && !bPawnControlsLocked)
		{
			HV.StartBoosting();
		}
		//return;		
	}

	exec function StopBoost()
	{
		local HaloVehicle HV;

		HV = HaloVehicle(Pawn);
		// End:0x70
		if((HV != none) && HV.Health > 0)
		{
			HV.StopBoosting();
		}
		//return;		
	}

	event EndState(name NextStateName)
	{
		StopEngineForceFeedback();
		UnhonkHorn();
		UpdateVehicleControls();
		bVehicleAccel = false;
		bVehicleBrake = false;
		bVehicleStrafe = false;
		CameraSetViewRotation(PlayerCamera.ViewTarget.POV.Rotation);
		super.EndState(NextStateName);
		//return;		
	}

	exec function StartVehicleAccel()
	{
		// End:0x2C
		if(!bCinematicMode && !bPawnControlsLocked)
		{
			bVehicleAccel = true;
		}
		//return;		
	}

	exec function StopVehicleAccel()
	{
		bVehicleAccel = false;
		//return;		
	}

	exec function StartVehicleBrake()
	{
		// End:0x2C
		if(!bCinematicMode && !bPawnControlsLocked)
		{
			bVehicleBrake = true;
		}
		//return;		
	}

	exec function StopVehicleBrake()
	{
		bVehicleBrake = false;
		//return;		
	}

	exec function StartVehicleStrafe()
	{
		// End:0x2C
		if(!bCinematicMode && !bPawnControlsLocked)
		{
			bVehicleStrafe = true;
		}
		//return;		
	}

	exec function StopVehicleStrafe()
	{
		bVehicleStrafe = false;
		//return;		
	}

	exec function UseVehicleAbility()
	{
		// End:0x62
		if(((HaloVehicle(Pawn) != none) && !bCinematicMode) && !bPawnControlsLocked)
		{
			HaloVehicle(Pawn).UseAddonAbility();
		}
		//return;		
	}

	exec function CancelVehicleAbility()
	{
		// End:0x62
		if(((HaloVehicle(Pawn) != none) && !bCinematicMode) && !bPawnControlsLocked)
		{
			HaloVehicle(Pawn).CancelAddonAbility();
		}
		//return;		
	}

	exec function OnUseButtonPressed()
	{
		TryToEnterOrExitVehicle();
		//return;		
	}
	stop;	
}

state PlayerExitVehicle
{
	function OnExitingVehicleEnd()
	{
		GotoState('PlayerWalking');
		//return;		
	}
	stop;	
}

state VehicleCustomizationBuildStateTransitionIn
{
	ignores StartFire;

	event BeginState(name PreviousState)
	{
		local Vector zero;

		Pawn.Velocity = zero;
		Pawn.Acceleration = zero;
		FadeToBlack();
		ActiveVehiclePanel.ReturnState = PreviousState;
		super(Object).BeginState(PreviousState);
		//return;		
	}

	event PlayerTick(float DeltaTime)
	{
		// End:0x6E
		if((GFxHaloHUD(myHUD) != none) && GFxHaloHUD(myHUD).ScreenIsBlack())
		{
			ActiveVehiclePanel.FadeComplete();
			FadeToClear();
		}
		//return;		
	}

	function bool IsMoveInputIgnored()
	{
		return true;
		//return ReturnValue;		
	}
	stop;	
}

state VehicleCustomizationBuildStateTransitionOut
{
	ignores StartFire;

	event BeginState(name PreviousState)
	{
		FadeToBlack();
		super(Object).BeginState(PreviousState);
		//return;		
	}

	event PlayerTick(float DeltaTime)
	{
		local HaloGameDefault TheGame;

		// End:0x130
		if((GFxHaloHUD(myHUD) != none) && GFxHaloHUD(myHUD).ScreenIsBlack())
		{
			bShowHVCCPrompt = false;
			FadeToClear();
			TheGame = HaloGameDefault(WorldInfo.Game);
			// End:0x130
			if(TheGame.TheCustomizationManager.IsActive())
			{
				TheGame.TheCustomizationManager.CloseHVCMenu();
				TheGame.TheCustomizationManager.MagicMomentDeployTimer = 0.0000000;
			}
		}
		//return;		
	}

	function bool IsMoveInputIgnored()
	{
		return true;
		//return ReturnValue;		
	}
	stop;	
}

state VehicleBuilding
{
	ignores StartFire;

	function bool IsMoveInputIgnored()
	{
		return true;
		//return ReturnValue;		
	}

	function TookDamage()
	{
		bShowHVCCPrompt = false;
		CloseHVCMenu();
		//return;		
	}

	function OpenHVCMenu(HaloVehicleCustomizationPanel HVCP)
	{
		local HaloGameDefault TheGame;
		local Vector zero;

		Pawn.Velocity = zero;
		Pawn.Acceleration = zero;
		TheGame = HaloGameDefault(WorldInfo.Game);
		// End:0x119
		if(((HVCP != none) && !TheGame.TheCustomizationManager.IsActive()) && !bShowHVCCPrompt)
		{
			TheGame.TheCustomizationManager.OpenHVCMenu(HVCP);
		}
		//return;		
	}

	exec function CloseHVCMenu()
	{
		// End:0x66
		if(!bShowHVCCPrompt)
		{
			GFxHaloHUD(myHUD).VCMovie.PlayAkEvent(AkEvent'Global.Play_UI_Construction_Exit');
			GotoState('VehicleCustomizationBuildStateTransitionOut');			
		}
		else
		{
			bShowHVCCPrompt = false;
		}
		//return;		
	}

	exec function HVCMenuPressUp()
	{
		local HaloGameDefault TheGame;

		TheGame = HaloGameDefault(WorldInfo.Game);
		// End:0xEE
		if(TheGame.TheCustomizationManager.IsActive() && !bShowHVCCPrompt)
		{
			GFxHaloHUD(myHUD).VCMovie.PlayMenuSound("up");
			TheGame.TheCustomizationManager.IncrementCurrentCategoryIndex();
		}
		//return;		
	}

	exec function HVCMenuPressDown()
	{
		local HaloGameDefault TheGame;

		TheGame = HaloGameDefault(WorldInfo.Game);
		// End:0xF0
		if(TheGame.TheCustomizationManager.IsActive() && !bShowHVCCPrompt)
		{
			GFxHaloHUD(myHUD).VCMovie.PlayMenuSound("down");
			TheGame.TheCustomizationManager.DecrementCurrentCategoryIndex();
		}
		//return;		
	}

	exec function HVCMenuPressLeft()
	{
		local HaloGameDefault TheGame;

		TheGame = HaloGameDefault(WorldInfo.Game);
		// End:0xF0
		if(TheGame.TheCustomizationManager.IsActive() && !bShowHVCCPrompt)
		{
			GFxHaloHUD(myHUD).VCMovie.PlayMenuSound("left");
			TheGame.TheCustomizationManager.DecrementCurrentItemIndex();
		}
		//return;		
	}

	exec function HVCMenuPressRight()
	{
		local HaloGameDefault TheGame;

		TheGame = HaloGameDefault(WorldInfo.Game);
		// End:0xF1
		if(TheGame.TheCustomizationManager.IsActive() && !bShowHVCCPrompt)
		{
			GFxHaloHUD(myHUD).VCMovie.PlayMenuSound("right");
			TheGame.TheCustomizationManager.IncrementCurrentItemIndex();
		}
		//return;		
	}

	event PlayerTick(float DeltaTime)
	{
		local HaloGameDefault TheGame;

		TheGame = HaloGameDefault(WorldInfo.Game);
		// End:0xB6
		if(TheGame.TheCustomizationManager.IsActive() && !bShowHVCCPrompt)
		{
			TheGame.TheCustomizationManager.ProcessJoyStickInput(PlayerInput);
		}
		//return;		
	}

	exec function StartCustomizing()
	{
		local HaloVehicleCustomizationManager HVCCManager;

		HVCCManager = HaloGameDefault(WorldInfo.Game).TheCustomizationManager;
		// End:0xDC
		if(HVCCManager.IsActive() && !bShowHVCCPrompt)
		{
			GFxHaloHUD(myHUD).VCMovie.PlayMenuSound("start");
			HVCCManager.StartConfirm();
		}
		//return;		
	}

	exec function StopCustomizing()
	{
		local HaloVehicleCustomizationManager HVCCManager;

		HVCCManager = HaloGameDefault(WorldInfo.Game).TheCustomizationManager;
		// End:0xDB
		if(HVCCManager.IsActive() && !bShowHVCCPrompt)
		{
			GFxHaloHUD(myHUD).VCMovie.PlayMenuSound("back");
			HVCCManager.AbortConfirm();
		}
		//return;		
	}

	exec function SelectCurrentCustomizationIndex()
	{
		local HaloVehicleCustomizationManager HVCCManager;

		HVCCManager = HaloGameDefault(WorldInfo.Game).TheCustomizationManager;
		// End:0xA3
		if(bShowHVCCPrompt)
		{
			// End:0x94
			if(HVCCManager.IsActive())
			{
				HVCCManager.SelectCurrentIndex();
			}
			bShowHVCCPrompt = false;			
		}
		else
		{
			// End:0x1A3
			if((((int(HVCCManager.CurrentHVCCType) == int(1)) && int(HVCCManager.CurrentHVCCItemIdx) != int(255)) && HVCCManager.GetCurrentCustomizationArray()[int(HVCCManager.CurrentHVCCItemIdx)].Unlocked) && int(HVCCManager.CurrentHVCCItemIdx) != int(HVCCManager.SelectedAddonIdx))
			{
				bShowHVCCPrompt = true;
			}
		}
		//return;		
	}
	stop;	
}

state Dead
{
	ignores StartFire;

	event BeginState(name PrevStateName)
	{
		super.BeginState(PrevStateName);
		SetTimer(2.0000000, false, 'FadeToBlack');
		SetTimer(3.2000000, false, 'ServerRestartPlayer');
		// End:0x73
		if(ActiveConstructionTrigger != none)
		{
			ActiveConstructionTrigger.OnControllerDeath(self);
			ActiveConstructionTrigger = none;
		}
		// End:0xAD
		if(InactiveConstructionTrigger != none)
		{
			InactiveConstructionTrigger.OnControllerDeath(self);
			InactiveConstructionTrigger = none;
		}
		//return;		
	}

	event EndState(name NextStateName)
	{
		bUsePhysicsRotation = false;
		CleanOutSavedMoves();
		Velocity = vect(0.0000000, 0.0000000, 0.0000000);
		Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
		bPressedJump = false;
		StopViewShaking();
		ClearTimer('DoForcedRespawn');
		//return;		
	}

	reliable server function ServerRestartPlayer()
	{
		// End:0x2B
		if(int(WorldInfo.NetMode) == int(NM_Client))
		{
			return;
		}
		WorldInfo.Game.RestartPlayer(self);
		GotoState('HeldInPlaceAfterSpawning');
		//return;		
	}
	stop;	
}

state HeldInPlaceAfterSpawning
{
	ignores PlayerMove, StartFire;

	event BeginState(name PrevStateName)
	{
		bPawnControlsLocked = true;
		Pawn.SetPhysics(4);
		SetTimer(0.2500000, false, 'CheckAndWaitForAsyncLoading');
		//return;		
	}

	event CheckAndWaitForAsyncLoading()
	{
		// End:0x23
		if(IsAsyncLoadingActive())
		{
			SetTimer(0.2500000, false, 'CheckAndWaitForAsyncLoading');			
		}
		else
		{
			ReleasePlayer();
		}
		//return;		
	}

	event ReleasePlayer()
	{
		Restart(false);
		FadeToClear();
		// End:0x55
		if(HaloPawn(Pawn) != none)
		{
			HaloPawn(Pawn).PlaySpawnSound();
		}
		//return;		
	}
	stop;	
}

state TargetDesignatorTransitionIn
{
	ignores TickActionableBuildPads;

	function SetupTargetDesignatorCamera()
	{
		local ViewTargetTransitionParams vTransition;
		local Rotator vRotation;
		local OrbitLockOnStruct LockOn;

		TDWeapon.SoftLockTarget = ((ActionableStudGrid != none) ? ActionableStudGrid : FindSoftTarget());
		TDWeapon.ActionedLockedTarget = ActionableStudGrid;
		// End:0x144
		if(TDWeapon.SoftLockTarget != none)
		{
			LockOn.Name = 'HaloWeapon_TargetDesignator_OrbitLockOn';
			LockOn.Target = TDWeapon.SoftLockTarget;
			LockOn.EnableDuringPlayerTargetDesignatorMode = true;
			LockOn.EnablePitch = true;
			CameraSetOrbitLockOn(LockOn);			
		}
		else
		{
			vTransition.BlendTime = 1.0500000;
			vTransition.bLockOutgoing = true;
			vTransition.BlendFunction = 1;
			vRotation.Yaw = Pawn.Rotation.Yaw;
			vRotation.Pitch = PlayerCamera.ViewTarget.POV.Rotation.Pitch;
			CameraSetViewRotation(vRotation, vTransition);
		}
		CameraSetOrbitSettingsByName('HaloWeapon_TargetDesignator');
		EnableCameraDOF(true, TDWeapon.WeaponRange + 256.0000000, 1.0000000);
		//return;		
	}

	function RotatePlayerToTarget(float DeltaTime)
	{
		local Rotator vRotation;
		local Vector ToTarget;

		// End:0x1CD
		if(TDWeapon.SoftLockTarget != none)
		{
			ToTarget = TDWeapon.SoftLockTarget.Location - Pawn.Location;
			vRotation = RInterpTo(Pawn.Rotation, Rotator(ToTarget), DeltaTime, 6.0000000);
			vRotation.Roll = Pawn.Rotation.Roll;
			vRotation.Pitch = Pawn.Rotation.Pitch;
			Pawn.SetRotation(vRotation);
			SetRotation(vRotation);
			WeaponAimRotation = RInterpTo(WeaponAimRotation, Rotator(ToTarget), DeltaTime, 12.0000000);
		}
		//return;		
	}

	function Rotator GetDesiredCameraRotation()
	{
		local Vector toSoftTarget, camLocation;
		local Rotator camRotation;

		// End:0x8A
		if(TDWeapon.SoftLockTarget != none)
		{
			GetPlayerViewPoint(camLocation, camRotation);
			toSoftTarget = Normal(TDWeapon.SoftLockTarget.Location - camLocation);
		}
		return Rotator(toSoftTarget);
		//return ReturnValue;		
	}

	function bool CheckIfFinished()
	{
		local bool isFinished;
		local Vector camLocation;
		local Rotator camRotation;

		isFinished = true;
		// End:0x7B
		if(TDWeapon.SoftLockTarget != none)
		{
			GetPlayerViewPoint(camLocation, camRotation);
			isFinished = RDiff(GetDesiredCameraRotation(), camRotation) < 1.0000000;
		}
		return isFinished;
		//return ReturnValue;		
	}

	function Actor FindSoftTarget()
	{
		local Actor softTarget;

		softTarget = CheckCameraSoftTarget();
		// End:0x37
		if(softTarget == none)
		{
			softTarget = CheckPlayerSoftTarget();
		}
		return softTarget;
		//return ReturnValue;		
	}

	function Actor CheckCameraSoftTarget()
	{
		local Vector camLocation;
		local Rotator camRotation;

		GetPlayerViewPoint(camLocation, camRotation);
		return TDWeapon.SearchForSoftLockPeggedActors(camLocation, camRotation, 80.0000000, 25.0000000, 55000.0000000, 3900000.0000000, 0.5500000, 0.1000000, 0.3500000,,, true);
		//return ReturnValue;		
	}

	function Actor CheckPlayerSoftTarget()
	{
		return TDWeapon.SearchForSoftLockPeggedActors(Pawn.Location, Pawn.Rotation, 80.0000000, 25.0000000, 55000.0000000, 3900000.0000000, 0.5500000, 0.1000000, 0.3500000,,, true);
		//return ReturnValue;		
	}

	function TickUseButtonTimer(float DeltaTime)
	{
		RotatePlayerToTarget(DeltaTime);
		//return;		
	}

	exec function StartBuilding()
	{
		bWasHoldingDownBuildTrigger = true;
		//return;		
	}

	exec function StopBuilding()
	{
		bWasHoldingDownBuildTrigger = false;
		//return;		
	}
Begin:

	SetupTargetDesignatorCamera();
	bWasHoldingDownBuildTrigger = false;
	PlayerInputRawViewMotion = vect(0.0000000, 0.0000000, 0.0000000);
	PlayerInputRawPawnMotion = vect(0.0000000, 0.0000000, 0.0000000);
	ProcessMove(0.0000000, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));
	Sleep(0.2000000);
	J0x77:

	// End:0x92 [Loop If]
	if((CheckIfFinished()) == false)
	{
		Sleep(0.2000000);
		// [Loop Continue]
		goto J0x77;
	}
	PopState();
	stop;			
}

state ConstructionBuildStateTransitionIn
{
	ignores StartFire, RamAttack, ThrowGrenade, UseAbility, Sprint, ToggleTargetDesignator;
Begin:

	// End:0x45
	if(GFxHaloHUD(myHUD) != none)
	{
		GFxHaloHUD(myHUD).FadeScreenToBlack(0.2500000);
	}
	PlayerInputRawViewMotion = vect(0.0000000, 0.0000000, 0.0000000);
	PlayerInputRawPawnMotion = vect(0.0000000, 0.0000000, 0.0000000);
	ProcessMove(0.0000000, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));
	goto 'ToBlack';
ToBlack:


	// End:0xFB
	if((GFxHaloHUD(myHUD) != none) && GFxHaloHUD(myHUD).ScreenIsBlack())
	{
		GotoState('ConstructionBuildState');
	}
	Sleep(0.1000000);
	goto 'ToBlack';
	stop;			
}

state ConstructionBuildStateTransitionOut
{
	local Vector Loc;
	local Rotator rota;

	ignores StartFire, RamAttack, ThrowGrenade, UseAbility, Sprint, ToggleTargetDesignator;

	function bool CheckFadeBlack()
	{
		// End:0x264
		if(((GFxHaloHUD(myHUD) != none) && GFxHaloHUD(myHUD).ScreenIsBlack()) && ActiveConstructionTrigger != none)
		{
			ActiveConstructionTrigger.ExitBuildMode();
			bPressedJump = false;
			// End:0x1B0
			if(HaloPawn(Pawn) != none)
			{
				HaloPawn(Pawn).bIsInvulnerable = false;
				Loc = ActiveConstructionTrigger.GetConstructionBuildTargetLocation();
				Loc.Z = Pawn.Location.Z;
				rota = Rotator(Loc - Pawn.Location);
				Pawn.SetRotation(rota);
				SetRotation(rota);
				CameraSetViewRotation(rota);
			}
			// End:0x1FF
			if(ActiveConstructionTrigger.bIsComplete == true)
			{
				ActiveConstructionTrigger.StartMagicMoment();
				ActiveConstructionTrigger = none;
			}
			GFxHaloHUD(myHUD).ToggleBCMenu();
			GFxHaloHUD(myHUD).FadeScreenToClear(0.2500000);
			GotoState('PlayerWalking');
			return true;
		}
		return false;
		//return ReturnValue;		
	}
Begin:

	// End:0x45
	if(GFxHaloHUD(myHUD) != none)
	{
		GFxHaloHUD(myHUD).FadeScreenToBlack(0.2500000);
	}
	goto 'ToBlack';
ToBlack:


	// End:0x66
	if(CheckFadeBlack())
	{
		goto 'ToClear';
	}
	Sleep(0.1000000);
	goto 'ToBlack';
ToClear:


	// End:0xC8
	if((GFxHaloHUD(myHUD) != none) && GFxHaloHUD(myHUD).ScreenIsClear())
	{
		PopState();
	}
	Sleep(0.1000000);
	goto 'ToClear';
	stop;		
}

state ConstructionBuildState
{
	ignores StartFire, RamAttack, ThrowGrenade, UseAbility, Sprint, ToggleTargetDesignator;

	function InitConstruction()
	{
		// End:0xF4
		if(((ActiveConstructionPadTarget != none) && ActiveConstructionTrigger != none) && GFxHaloHUD(myHUD) != none)
		{
			// End:0x7C
			if(UTPawn(Pawn) != none)
			{
				UTPawn(Pawn).bIsInvulnerable = true;
			}
			ActiveConstructionTrigger.EnterBuildMode(self);
			GFxHaloHUD(myHUD).ToggleBCMenu();
			GFxHaloHUD(myHUD).FadeScreenToClear(0.7500000);			
		}
		else
		{
			GotoState('PlayerWalking');
			return;
		}
		//return;		
	}

	function ShutdownConstruction()
	{
		GotoState('ConstructionBuildStateTransitionOut');
		//return;		
	}

	event PlayerTick(float DeltaTime)
	{
		local HaloGameDefault TheGame;

		TheGame = HaloGameDefault(WorldInfo.Game);
		// End:0xDB
		if(TheGame.TheConstructionManager.IsActive())
		{
			TheGame.TheConstructionManager.ProcessJoyStickInput(PlayerInput.aBaseY, PlayerInput.aStrafe);			
		}
		else
		{
			// End:0x23E
			if(TheGame.TheConstructionManager.IsComplete())
			{
				// End:0x23E
				if(ActiveConstructionTrigger.ConstructionCompleteDelay > 0.0000000)
				{
					ActiveConstructionTrigger.ConstructionCompleteDelay -= DeltaTime;
					// End:0x23E
					if(ActiveConstructionTrigger.ConstructionCompleteDelay <= 0.0000000)
					{
						ActiveConstructionTrigger.ConstructionCompleteDelay = 0.0000000;
						BlokCollector.RemoveFromBank(ActiveConstructionTrigger.GetConstructionCost());
						ActiveConstructionTrigger.UsedBy(Pawn);
						ActiveConstructionTrigger.BuildConstructionObject();
						ShutdownConstruction();
					}
				}
			}
		}
		// End:0x2DA
		if((((ActiveConstructionTrigger != none) && ActiveConstructionTrigger.IsConstructionCameraLocked()) && GFxHaloHUD(myHUD) != none) && GFxHaloHUD(myHUD).ScreenIsClear() == true)
		{
			ActiveConstructionTrigger.UnlockConstructionCamera();
		}
		super(HaloPlayerPawnController).PlayerTick(DeltaTime);
		//return;		
	}

	exec function ConstructionCameraRight()
	{
		PlayerInputRawViewMotion.X = FInterpEaseIn(PlayerInputRawViewMotion.X, -0.6000000, 0.9000000, 0.8000000);
		ConstructionCameraAlreadyActive = true;
		//return;		
	}

	exec function ConstructionCameraLeft()
	{
		PlayerInputRawViewMotion.X = FInterpEaseIn(PlayerInputRawViewMotion.X, 0.6000000, 0.9000000, 0.8000000);
		ConstructionCameraAlreadyActive = true;
		//return;		
	}

	exec function StopConstructionCamera()
	{
		PlayerInputRawViewMotion.X = 0.0000000;
		ConstructionCameraAlreadyActive = false;
		//return;		
	}

	exec function SelectNextConstructionPrimitive()
	{
		// End:0x2E
		if(ActiveConstructionTrigger != none)
		{
			ActiveConstructionTrigger.SelectNextConstructionPrimitive();
		}
		//return;		
	}

	exec function SelectPreviousConstructionPrimitive()
	{
		// End:0x2E
		if(ActiveConstructionTrigger != none)
		{
			ActiveConstructionTrigger.SelectPreviousConstructionPrimitive();
		}
		//return;		
	}

	exec function SelectConstructionPrimitive()
	{
		local HaloGameDefault TheGame;

		TheGame = HaloGameDefault(WorldInfo.Game);
		// End:0xD7
		if((ActiveConstructionTrigger != none) && TheGame.TheConstructionManager.IsActive())
		{
			// End:0xD7
			if(TheGame.TheConstructionManager.ActivatePrimitiveSelection() == false)
			{
				ActiveConstructionTrigger.ConstructionCompleteDelay = 2.2500000;
			}
		}
		//return;		
	}

	exec function SelectNextConstructionPrimitive_UI()
	{
		// End:0x2E
		if(ActiveConstructionTrigger != none)
		{
			ActiveConstructionTrigger.IncrementPrimitiveSelection();
		}
		//return;		
	}

	exec function SelectPreviousConstructionPrimitive_UI()
	{
		// End:0x2E
		if(ActiveConstructionTrigger != none)
		{
			ActiveConstructionTrigger.DecrementPrimitiveSelection();
		}
		//return;		
	}

	exec function ExitConstructionMode()
	{
		// End:0x35
		if((ActiveConstructionTrigger != none) && ActiveConstructionTrigger.bIsComplete)
		{
			return;
		}
		ShutdownConstruction();
		//return;		
	}

	function ProcessPlayerAim(float DeltaTime, Vector2D leftStick, Vector2D rightStick)
	{
		// End:0xB4
		if(ConstructionCameraAlreadyActive == false)
		{
			PlayerInputRawViewMotion.X = -rightStick.X * 0.8000000;
			PlayerInputRawViewMotion.Y = rightStick.Y * 0.8000000;
			PlayerInputRawViewMotion.Z = 0.0000000;
		}
		// End:0x150
		if(ActiveConstructionTrigger != none)
		{
			// End:0x10B
			if(PlayerInputRawViewMotion.X > 0.2000000)
			{
				ActiveConstructionTrigger.RotateMeshRight();				
			}
			else
			{
				// End:0x150
				if(PlayerInputRawViewMotion.X < -0.2000000)
				{
					ActiveConstructionTrigger.RotateMeshLeft();
				}
			}
		}
		//return;		
	}

	function PlayerMove(float DeltaTime)
	{
		local Vector2D leftStick, rightStick;

		leftStick = ApplyDeadZone(PlayerInput.RawJoyRight, PlayerInput.RawJoyUp);
		rightStick = ApplyDeadZone(PlayerInput.RawJoyLookRight, PlayerInput.RawJoyLookUp);
		rightStick.X = ((rightStick.X == float(0)) ? PlayerInput.aMouseX / 600.0000000 : rightStick.X);
		rightStick.Y = ((rightStick.Y == float(0)) ? -PlayerInput.aMouseY / 600.0000000 : rightStick.Y);
		ProcessPlayerAim(DeltaTime, leftStick, rightStick);
		//return;		
	}

	function Vector2D ApplyDeadZone(float stickX, float stickY)
	{
		local Vector2D stickValue;
		local float magnitude;

		stickValue.X = stickX;
		stickValue.Y = stickY;
		magnitude = (stickValue.X * stickValue.X) + (stickValue.Y * stickValue.Y);
		// End:0x1A3
		if(magnitude > float(0))
		{
			magnitude = Sqrt(magnitude);
			// End:0x15F
			if(magnitude > DeadZone)
			{
				DivideEqual_Vector2DFloat(stickValue, magnitude);
				MultiplyEqual_Vector2DFloat(stickValue, (magnitude - DeadZone) / (float(1) - DeadZone));				
			}
			else
			{
				stickValue.X = 0.0000000;
				stickValue.Y = 0.0000000;
			}
		}
		return stickValue;
		//return ReturnValue;		
	}
Begin:

	InitConstruction();
	PlayerInputRawViewMotion = vect(0.0000000, 0.0000000, 0.0000000);
	PlayerInputRawPawnMotion = vect(0.0000000, 0.0000000, 0.0000000);
	ProcessMove(0.0000000, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));
	Sleep(2.0000000);
	stop;					
}

state PlayerLedgeGrab extends PlayerWalking
{
	ignores Sprint, ToggleTargetDesignator;

	function NotifyLedgeGrab(bool Enabled, optional bool Jumping)
	{
		// End:0x36
		if(!Enabled)
		{
			GotoState(((Jumping) ? 'PlayerLedgeJump' : 'PlayerWalking'));
		}
		//return;		
	}

	event BeginState(name PrevStateName)
	{
		SetRotation(Pawn.Rotation);
		//return;		
	}

	event EndState(name NextStateName)
	{
		bPressedJump = false;
		// End:0x2C
		if(int(bFireButtonState) > int(0))
		{
			StartFire(0);
		}
		//return;		
	}

	exec function LetGoOfLedge()
	{
		local HaloPawn P;

		P = HaloPawn(Pawn);
		// End:0x6C
		if(((P != none) && !bCinematicMode) && !bPawnControlsLocked)
		{
			P.LetGoOfLedge();
		}
		//return;		
	}

	function TryToAbortJumpToLedge()
	{
		local HaloPawn P;

		P = HaloPawn(Pawn);
		// End:0x6C
		if(((P != none) && !bCinematicMode) && !bPawnControlsLocked)
		{
			P.TryToAbortJumpToLedge();
		}
		//return;		
	}

	function ProcessPlayerMotion(float DeltaTime, Vector2D leftStick)
	{
		local Vector Direction, ViewLocation;
		local Rotator ViewRotation;
		local float dotProduct;
		local bool doAbortTest;

		Direction.X = leftStick.Y;
		Direction.Y = leftStick.X;
		Direction.Z = 0.0000000;
		PlayerInputRawPawnMotion = Direction;
		doAbortTest = false;
		// End:0x15B
		if(VSizeSq(Direction) > 0.0010000)
		{
			GetPlayerViewPoint(ViewLocation, ViewRotation);
			Direction = Direction >> ViewRotation;
			Direction.Z = 0.0000000;
			// End:0x15B
			if(VSizeSq(Direction) > 0.0010000)
			{
				Direction = Normal(Direction);
				doAbortTest = true;
			}
		}
		dotProduct = Direction Dot Vector(Pawn.Rotation);
		// End:0x1AD
		if(dotProduct < -0.7071068)
		{
			LetGoOfLedge();
		}
		// End:0x1D7
		if(doAbortTest)
		{
			// End:0x1D7
			if(dotProduct < 0.7071068)
			{
				TryToAbortJumpToLedge();
			}
		}
		CheckJumpOrDuck();
		//return;		
	}
	stop;	
}

state PlayerLedgeJump extends PlayerWalking
{
	ignores ToggleTargetDesignator;

	event BeginState(name PrevStateName)
	{
		SetRotation(Pawn.Rotation);
		SetTimer(LedgeJumpDuration);
		//return;		
	}

	event EndState(name NextStateName)
	{
		bPressedJump = false;
		//return;		
	}

	function ProcessPlayerMotion(float DeltaTime, Vector2D leftStick)
	{
		local Vector Direction;

		Direction.X = leftStick.Y;
		Direction.Y = leftStick.X;
		Direction.Z = 0.0000000;
		PlayerInputRawPawnMotion = Direction;
		// End:0xF8
		if((int(Pawn.Physics) != int(2)) || VSizeSq(Direction) > 0.0010000)
		{
			GotoState('PlayerWalking');			
		}
		else
		{
			Pawn.Acceleration = Pawn.AccelRate * Vector(Rotation);
		}
		//return;		
	}

	function Timer()
	{
		GotoState('PlayerWalking');
		//return;		
	}
	stop;	
}

state PlayerLocked extends PlayerWalking
{
	ignores Sprint, ToggleTargetDesignator;

	function EnableLockedState(bool Enabled)
	{
		// End:0x1D
		if(!Enabled)
		{
			GotoState('PlayerWalking');
		}
		//return;		
	}

	event BeginState(name PrevStateName)
	{
		local HaloPlayerInventoryManager invMgr;

		SetRotation(Pawn.Rotation);
		// End:0x109
		if(bIsAimingTargetDesignator)
		{
			// End:0xFF
			if(Pawn != none)
			{
				invMgr = HaloPlayerInventoryManager(Pawn.InvManager);
				// End:0xFF
				if(invMgr != none)
				{
					// End:0xC8
					if(LastWeaponEquippedBeforeTD == none)
					{
						LastWeaponEquippedBeforeTD = HaloWeapon(invMgr.FindInventoryType(Class'MegaHaloGame.HaloWeapon', true));
					}
					// End:0xFF
					if(LastWeaponEquippedBeforeTD != none)
					{
						invMgr.QuickWeaponSwap(LastWeaponEquippedBeforeTD);
					}
				}
			}
			ClearTargetDesignatorState();
		}
		//return;		
	}

	event EndState(name NextStateName)
	{
		bPressedJump = false;
		// End:0x2C
		if(int(bFireButtonState) > int(0))
		{
			StartFire(0);
		}
		//return;		
	}

	function ProcessPlayerMotion(float DeltaTime, Vector2D leftStick)
	{
		// End:0x46
		if(int(Role) < int(ROLE_Authority))
		{
			ReplicateMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));			
		}
		else
		{
			ProcessMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	bMarkAutoAimTargets=true
	bVehicleAutoBrake=true
	bTeleportToBreadcrumbOnFall=true
	DeadZone=0.2000000
	RegularWeaponGroupID=1
	ThrownWeaponGroupID=2
	DesignatorWeaponGroupID=3
	// Reference: HaloBlokCollectorComponent'MegaHaloGame.Default__HaloPlayerPawnController.BlokCollectorComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'BlokCollectorComponent'
	begin object name="BlokCollectorComponent" class=MegaHaloGame.HaloBlokCollectorComponent
	end object
	BlokCollector=BlokCollectorComponent
	AltAccelReverseRange=1.5000000
	AltAccelYDeadzone=0.0500000
	AltAccelThrottleMultiplier=1.1000000
	VehicleCameraToReverseDelay=3.0000000
	VehicleCameraToForwardDelay=1.0000000
	VehicleMaxThrottleToAutoBrake=0.0500000
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloPlayerPawnController.GrenadeWaveform1'
	begin object name="GrenadeWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=60,RightAmplitude=60,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.5000000)
	end object
	GrenadeWaveform=GrenadeWaveform1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloPlayerPawnController.EngineWaveform1'
	begin object name="EngineWaveform1" class=Engine.ForceFeedbackWaveform
		bIsLooping=true
		Samples[0]=(LeftAmplitude=40,RightAmplitude=40,LeftFunction=WF_Noise,RightFunction=WF_Noise,Duration=0.2000000)
	end object
	EngineWaveform=EngineWaveform1
	MinBreadcrumbDistance=500.0000000
	MaxBreadcrumbListSize=5
	DistToAdvancePath=2000.0000000
	DistToRepath=5000.0000000
	RepathDelay=5.0000000
	ActionableVehicleEntry=(Vehicle=none,Seat=-1)
	LedgeJumpDuration=0.2500000
	bBehindView=true
	bNoCrosshair=true
	bUsePawnRotationToCheckForVehicles=true
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloPlayerPawnController.ForceFeedbackWaveform7'
	// Archetype: ForceFeedbackWaveform'UTGame.Default__UTPlayerController.ForceFeedbackWaveform7'
	begin object name="ForceFeedbackWaveform7"
	end object
	CameraShakeShortWaveForm=ForceFeedbackWaveform7
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloPlayerPawnController.ForceFeedbackWaveform8'
	// Archetype: ForceFeedbackWaveform'UTGame.Default__UTPlayerController.ForceFeedbackWaveform8'
	begin object name="ForceFeedbackWaveform8"
	end object
	CameraShakeLongWaveForm=ForceFeedbackWaveform8
	CameraClass=Class'MegaHaloGame.HaloPlayerCamera'
	bIsStreamingFromViewTarget=true
	bCheckSoundOcclusion=false
	CheatClass=Class'MegaHaloGame.HaloCheatManager'
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloPlayerPawnController.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'UTGame.Default__UTPlayerController.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	Components[1]=BlokCollectorComponent
	CollisionComponent=CollisionCylinder
}