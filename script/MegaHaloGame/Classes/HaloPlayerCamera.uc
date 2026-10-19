class HaloPlayerCamera extends Camera
	transient;

const PRIORITY_NONE = -99999999;

enum EEncounterPriorityLevel
{
	EPL_High,                       // 0
	EPL_Medium,                     // 1
	EPL_Low,                        // 2
	EPL_Count,                      // 3
	EPL_MAX                         // 4
};

struct FBlendStruct
{
	var float Base;
	var float Target;
	var float BlendTime;
	var Camera.EViewTargetBlendFunction BlendFunction;
	var float BlendExp;
	var float Time;
	var float Value;

	structdefaultproperties
	{
		Base=0.0000000
		Target=0.0000000
		BlendTime=0.0000000
		BlendFunction=VTBlend_Cubic
		BlendExp=2.0000000
		Time=0.0000000
		Value=0.0000000
	}
};

struct RTransitionStruct
{
	var Rotator ARotation;
	var Rotator BRotation;
	var ViewTargetTransitionParams Params;
	var float Time;

	structdefaultproperties
	{
		ARotation=(Pitch=0,Yaw=0,Roll=0)
		BRotation=(Pitch=0,Yaw=0,Roll=0)
		Params=(BlendTime=0.0000000,BlendFunction=VTBlend_Cubic,BlendExp=2.0000000,bLockOutgoing=false)
		Time=0.0000000
	}
};

struct PriorityInfo
{
	var name Name;
	var name Call;
	var int Priority;

	structdefaultproperties
	{
		Name="None"
		Call="None"
		Priority=-99999999
	}
};

struct RNamedBlend
{
	var name Name;
	var Rotator Base;
	var Rotator Target;
	var Rotator Value;
	var FBlendStruct Blend;
	var FBlendRange BlendRange;
	var name OnBlendOutEventName;

	structdefaultproperties
	{
		Name="None"
		Base=(Pitch=0,Yaw=0,Roll=0)
		Target=(Pitch=0,Yaw=0,Roll=0)
		Value=(Pitch=0,Yaw=0,Roll=0)
		Blend=(Base=0.0000000,Target=0.0000000,BlendTime=0.0000000,BlendFunction=VTBlend_Cubic,BlendExp=2.0000000,Time=0.0000000,Value=0.0000000)
		BlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None")
		OnBlendOutEventName="None"
	}
};

struct VNamedBlend
{
	var name Name;
	var Vector Base;
	var Vector Target;
	var Vector Value;
	var FBlendStruct Blend;
	var FBlendRange BlendRange;
	var name OnBlendOutEventName;

	structdefaultproperties
	{
		Name="None"
		Base=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		Target=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		Value=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		Blend=(Base=0.0000000,Target=0.0000000,BlendTime=0.0000000,BlendFunction=VTBlend_Cubic,BlendExp=2.0000000,Time=0.0000000,Value=0.0000000)
		BlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None")
		OnBlendOutEventName="None"
	}
};

struct FNamedBlend
{
	var name Name;
	var float Base;
	var float Target;
	var float Value;
	var FBlendStruct Blend;
	var FBlendRange BlendRange;
	var name OnBlendOutEventName;

	structdefaultproperties
	{
		Name="None"
		Base=0.0000000
		Target=0.0000000
		Value=0.0000000
		Blend=(Base=0.0000000,Target=0.0000000,BlendTime=0.0000000,BlendFunction=VTBlend_Cubic,BlendExp=2.0000000,Time=0.0000000,Value=0.0000000)
		BlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None")
		OnBlendOutEventName="None"
	}
};

struct EncounterActor
{
	var Actor Target;
	var float TimeOut;

	structdefaultproperties
	{
		Target=none
		TimeOut=0.0000000
	}
};

struct EncounterArray
{
	var array<EncounterActor> Items;

	structdefaultproperties
	{
		Items=none
	}
};

var const FBlendRange FBlendRangeDefault;
var RNamedBlend RotationBlend;
var VNamedBlend LocationBlend;
var FNamedBlend FOVBlend;
var VNamedBlend OrbitFocusOffsetBlend;
var FNamedBlend OrbitDistanceBlend;
var editinline HaloCameraConfig CameraConfig;
var TPOV POVCache;
var float ManualAimActiveTimeout;
var float OrbitManualAimMultiplierAngle;
var Actor AutoAimTarget;
var Actor AutoAimExtendedTarget;
var Vector AutoCenterYawLastRawTargetMotion;
var float AutoCenterYawSpeed;
var EncounterArray OrbitEncounterPriorityList[4];
var array<name> OrbitEncounterDisableReferences;
var PriorityInfo OrbitEncounterPriorityInfo;
var FBlendRange OrbitEncounterRotationBlendRange;
var Vector OrbitEncounterAverageLocation;
var Vector TargetLocation;
var Vector TargetFocusOffset;
var float TargetZHeight;
var float TargetZSpeed;
var array<LocationMaskStruct> LocationMaskArray;
var array<LockViewStruct> LockViewArray;
var PriorityInfo LockViewRotationPriorityInfo;
var PriorityInfo LockViewLocationPriorityInfo;
var PriorityInfo LockViewFOVPriorityInfo;
var MagnetAimStruct MagnetAim;
var array<OrbitStruct> OrbitSettingsArray;
var PriorityInfo OrbitSettingsPriorityInfo;
var float OrbitSettingsLastDistance;
var array<OrbitLockOnStruct> OrbitLockOnArray;
var PriorityInfo OrbitLockOnPriorityInfo;
var Actor OrbitAutoAimTarget;
var RTransitionStruct RotationTransition;
var const Camera.EViewTargetBlendFunction PRIORITY_BLEND_FUNCTION;
var float TestOrbitFollowScale;

event PostBeginPlay()
{
	super.PostBeginPlay();
	POVCache.Location = Location;
	POVCache.Rotation = Rotation;
	POVCache.FOV = DefaultFOV;
	CameraConfig = Spawn(Class'MegaHaloGame.HaloCameraConfig');
	SetOrbitSettingsByName(CameraConfig.OrbitDefaultName);
	SetMagnetAimByName(CameraConfig.MagnetAimDefaultName);
	//return;	
}

function UpdatePostProcessAlpha()
{
	// End:0x35
	if(CamPostProcessSettings.bEnableDOF == true)
	{
		CamOverridePostProcessAlpha = 1.0000000;		
	}
	else
	{
		CamOverridePostProcessAlpha = 0.0000000;
	}
	//return;	
}

function UpdateViewTarget(out TViewTarget outViewTarget, float DeltaTime)
{
	// End:0x4A
	if(CameraActor(outViewTarget.Target) != none)
	{
		super.UpdateViewTarget(outViewTarget, DeltaTime);		
	}
	else
	{
		// End:0x24A
		if((IsOwnerUsingExternalCamera(outViewTarget.Target)) == true)
		{
			super.UpdateViewTarget(outViewTarget, DeltaTime);
			outViewTarget.POV.Rotation = RNamedBlendUpdate(RotationBlend, '__EXTERNAL__', outViewTarget.POV.Rotation, DeltaTime);
			outViewTarget.POV.Location = VNamedBlendUpdate(LocationBlend, '__EXTERNAL__', outViewTarget.POV.Location, DeltaTime);
			outViewTarget.POV.FOV = FNamedBlendUpdate(FOVBlend, '__EXTERNAL__', outViewTarget.POV.FOV, DeltaTime);
			POVCache = outViewTarget.POV;			
		}
		else
		{
			HACKUpdateMagnetAim(outViewTarget.Target);
			outViewTarget.POV = UpdateView(POVCache, outViewTarget.Target, CameraConfig, DeltaTime);
			POVCache = outViewTarget.POV;
			ApplyCameraModifiers(DeltaTime, outViewTarget.POV);
			UpdatePostProcessAlpha();
		}
	}
	//return;	
}

simulated event UpdateCamera(float DeltaTime)
{
	// End:0x170
	if((PCOwner.IsLocalPlayerController() || !bUseClientSideCameraUpdates) || bDebugClientSideCamera)
	{
		DoUpdateCamera(DeltaTime);
		// End:0x170
		if(int(WorldInfo.NetMode) == int(NM_Client))
		{
			PCOwner.ServerUpdateCamera(CameraCache.POV.Location, (CameraCache.POV.Rotation.Pitch & 65535) + ((CameraCache.POV.Rotation.Yaw & 65535) << 16));
			bShouldSendClientSideCameraUpdate = false;
		}
	}
	//return;	
}

function FBlendRange FBlendRangeMax(const FBlendRange A, const FBlendRange B)
{
	return ((A.Max.Time > B.Max.Time) ? A : B);
	//return ReturnValue;	
}

function float FBlendRangeTimeEval(const FBlendRange Range, float Distance)
{
	local float Pct, minTime, MaxTime, MinDistance, MaxDistance;

	MinDistance = FMin(Range.Min.Distance, Range.Max.Distance);
	MaxDistance = FMax(Range.Min.Distance, Range.Max.Distance);
	// End:0x14E
	if((MaxDistance - MinDistance) > float(0))
	{
		Distance = FClamp(Distance, MinDistance, MaxDistance);
		Pct = (Distance - MinDistance) / (MaxDistance - MinDistance);		
	}
	else
	{
		Pct = 1.0000000;
	}
	minTime = FMin(Range.Min.Time, Range.Max.Time);
	MaxTime = FMax(Range.Min.Time, Range.Max.Time);
	return ((MaxTime - minTime) * Pct) + minTime;
	//return ReturnValue;	
}

function Rotator RNamedBlendUpdate(out RNamedBlend oBlend, name aName, const Rotator Value, float DeltaTime, const optional FBlendRange Range)
{
	local float BlendTime;
	local bool wasBlending;

	// End:0x1E3
	if(oBlend.Name != aName)
	{
		oBlend.Base = oBlend.Value;
		BlendTime = FBlendRangeTimeEval(FBlendRangeMax(oBlend.BlendRange, Range), RDiff(oBlend.Base, Value));
		oBlend.Blend = FBlendNew(0.0000000, 1.0000000, ((oBlend.Name != 'None') ? BlendTime : 0.0000000), PRIORITY_BLEND_FUNCTION);
		oBlend.OnBlendOutEventName = oBlend.BlendRange.OnBlendOutEventName;
		oBlend.BlendRange = Range;
		oBlend.Name = aName;
	}
	wasBlending = oBlend.Blend.Time < oBlend.Blend.BlendTime;
	oBlend.Blend.Time = FMin(oBlend.Blend.Time + DeltaTime, oBlend.Blend.BlendTime);
	oBlend.Target = Value;
	oBlend.Value = RNamedBlendEval(oBlend);
	// End:0x413
	if((wasBlending == true) && oBlend.Blend.Time == oBlend.Blend.BlendTime)
	{
		ActivateRemoteEvent(oBlend.OnBlendOutEventName);
		ActivateRemoteEvent(oBlend.BlendRange.OnBlendInEventName);
	}
	return oBlend.Value;
	//return ReturnValue;	
}

function Rotator RNamedBlendEval(const out RNamedBlend Blend)
{
	local float Rate;

	Rate = FBlendEval(Blend.Blend);
	// End:0x90
	if(Rate < 1.0000000)
	{
		return RLerp(Blend.Base, Blend.Target, Rate, true);
	}
	return Blend.Target;
	//return ReturnValue;	
}

function Vector VNamedBlendUpdate(out VNamedBlend oBlend, name aName, const Vector Value, float DeltaTime, const optional FBlendRange Range)
{
	local float BlendTime;
	local bool wasBlending;

	// End:0x1DD
	if(oBlend.Name != aName)
	{
		oBlend.Base = oBlend.Value;
		BlendTime = FBlendRangeTimeEval(FBlendRangeMax(oBlend.BlendRange, Range), VSize(oBlend.Base - Value));
		oBlend.Blend = FBlendNew(0.0000000, 1.0000000, ((oBlend.Name != 'None') ? BlendTime : 0.0000000), PRIORITY_BLEND_FUNCTION);
		oBlend.OnBlendOutEventName = oBlend.BlendRange.OnBlendOutEventName;
		oBlend.BlendRange = Range;
		oBlend.Name = aName;
	}
	wasBlending = oBlend.Blend.Time < oBlend.Blend.BlendTime;
	oBlend.Blend.Time = FMin(oBlend.Blend.Time + DeltaTime, oBlend.Blend.BlendTime);
	oBlend.Target = Value;
	oBlend.Value = VNamedBlendEval(oBlend);
	// End:0x40D
	if((wasBlending == true) && oBlend.Blend.Time == oBlend.Blend.BlendTime)
	{
		ActivateRemoteEvent(oBlend.OnBlendOutEventName);
		ActivateRemoteEvent(oBlend.BlendRange.OnBlendInEventName);
	}
	return oBlend.Value;
	//return ReturnValue;	
}

function Vector VNamedBlendEval(const out VNamedBlend Blend)
{
	local float Rate;

	Rate = FBlendEval(Blend.Blend);
	// End:0x8F
	if(Rate < 1.0000000)
	{
		return VLerp(Blend.Base, Blend.Target, Rate);
	}
	return Blend.Target;
	//return ReturnValue;	
}

function float FNamedBlendUpdate(out FNamedBlend oBlend, name aName, const float Value, float DeltaTime, const optional FBlendRange Range)
{
	local float BlendTime;
	local bool wasBlending;

	// End:0x1DD
	if(oBlend.Name != aName)
	{
		oBlend.Base = oBlend.Value;
		BlendTime = FBlendRangeTimeEval(FBlendRangeMax(oBlend.BlendRange, Range), Abs(oBlend.Base - Value));
		oBlend.Blend = FBlendNew(0.0000000, 1.0000000, ((oBlend.Name != 'None') ? BlendTime : 0.0000000), PRIORITY_BLEND_FUNCTION);
		oBlend.OnBlendOutEventName = oBlend.BlendRange.OnBlendOutEventName;
		oBlend.BlendRange = Range;
		oBlend.Name = aName;
	}
	wasBlending = oBlend.Blend.Time < oBlend.Blend.BlendTime;
	oBlend.Blend.Time = FMin(oBlend.Blend.Time + DeltaTime, oBlend.Blend.BlendTime);
	oBlend.Target = Value;
	oBlend.Value = FNamedBlendEval(oBlend);
	// End:0x40D
	if((wasBlending == true) && oBlend.Blend.Time == oBlend.Blend.BlendTime)
	{
		ActivateRemoteEvent(oBlend.OnBlendOutEventName);
		ActivateRemoteEvent(oBlend.BlendRange.OnBlendInEventName);
	}
	return oBlend.Value;
	//return ReturnValue;	
}

function float FNamedBlendEval(const out FNamedBlend Blend)
{
	local float Rate;

	Rate = FBlendEval(Blend.Blend);
	// End:0x87
	if(Rate < 1.0000000)
	{
		return Lerp(Blend.Base, Blend.Target, Rate);
	}
	return Blend.Target;
	//return ReturnValue;	
}

function PriorityInfo PriorityInfoMax(const PriorityInfo A, const PriorityInfo B)
{
	return ((A.Priority > B.Priority) ? A : B);
	//return ReturnValue;	
}

function PriorityInfoSet(out PriorityInfo O, name aName, int Priority, name Call)
{
	O.Name = aName;
	O.Priority = Priority;
	O.Call = Call;
	//return;	
}

function PriorityInfoClear(out PriorityInfo O)
{
	local PriorityInfo I;

	O = I;
	//return;	
}

function float FBlendTo(float A, float B, float Pct, optional Camera.EViewTargetBlendFunction BlendFunction = 1, optional float BlendExp = 2.0000000)
{
	Pct = FClamp(Pct, 0.0000000, 1.0000000);
	// End:0x18A
	if(Pct < 1.0000000)
	{
		switch(BlendFunction)
		{
			// End:0x7B
			case 0:
				Pct = Lerp(0.0000000, 1.0000000, Pct);
				// End:0x15F
				break;
			// End:0xB4
			case 1:
				Pct = FCubicInterp(0.0000000, 0.0000000, 1.0000000, 0.0000000, Pct);
				// End:0x15F
				break;
			// End:0xEC
			case 2:
				Pct = FInterpEaseIn(0.0000000, 1.0000000, Pct, BlendExp);
				// End:0x15F
				break;
			// End:0x124
			case 3:
				Pct = FInterpEaseOut(0.0000000, 1.0000000, Pct, BlendExp);
				// End:0x15F
				break;
			// End:0x15C
			case 4:
				Pct = FInterpEaseInOut(0.0000000, 1.0000000, Pct, BlendExp);
				// End:0x15F
				break;
			// End:0xFFFF
			default:
				break;
		}
		return ((B - A) * Pct) + A;
	}
	return B;
	//return ReturnValue;	
}

function FBlendStruct FBlendNew(float A, float B, float BlendTime, optional Camera.EViewTargetBlendFunction BlendFunction = 1, optional float BlendExp = 2.0000000)
{
	local FBlendStruct Blend;

	Blend.Base = A;
	Blend.Target = B;
	Blend.Time = 0.0000000;
	Blend.BlendTime = BlendTime;
	Blend.BlendFunction = BlendFunction;
	Blend.BlendExp = BlendExp;
	return Blend;
	//return ReturnValue;	
}

function FBlendStruct FBlendUpdate(const FBlendStruct Blend, float DeltaTime)
{
	local FBlendStruct oBlend;

	oBlend = Blend;
	oBlend.Time = FMin(Blend.Time + DeltaTime, Blend.BlendTime);
	return oBlend;
	//return ReturnValue;	
}

function float FBlendEval(const FBlendStruct Blend)
{
	// End:0xDB
	if(Blend.BlendTime > 0.0000000)
	{
		return FBlendTo(Blend.Base, Blend.Target, Blend.Time / Blend.BlendTime, Blend.BlendFunction, Blend.BlendExp);
	}
	return Blend.Target;
	//return ReturnValue;	
}

function int AngularDiff(const int A, const int B)
{
	local int Diff;

	Diff = int(Abs(float(NormalizeRotAxis(A - B))));
	return Min(int((float(360) * 182.0444031) - float(Diff)), Diff);
	//return ReturnValue;	
}

function float CalculateRangedMultiplier(float Multiplier, float basis, float basisMax, float basisMin)
{
	// End:0x24
	if(basis > basisMax)
	{
		return Multiplier;		
	}
	else
	{
		// End:0x7F
		if(basis > basisMin)
		{
			return ((Multiplier - 1.0000000) * ((basis - basisMin) / (basisMax - basisMin))) + 1.0000000;
		}
	}
	return 1.0000000;
	//return ReturnValue;	
}

function float AngleTo(const Vector aLocation, const Vector BaseLocation, const Rotator BaseRotation)
{
	local Vector Offset, Direction;
	local float Angle, dotValue;

	Offset = aLocation - BaseLocation;
	Direction = Vector(BaseRotation);
	dotValue = Normal(Offset) Dot Direction;
	Angle = Acos(dotValue) * 57.2957802;
	return Angle;
	//return ReturnValue;	
}

function Vector CalculateFocusLocation(const Rotator BaseRotation, const Vector BaseLocation, const Vector FocusOffset)
{
	local Vector focusLocation;
	local Rotator focusRotation;

	focusRotation.Yaw = BaseRotation.Yaw;
	focusLocation = FocusOffset >> focusRotation;
	focusLocation = focusLocation + BaseLocation;
	return focusLocation;
	//return ReturnValue;	
}

function bool IsOwnerUsingExternalCamera(const Actor Target)
{
	return (Vehicle(Target) != none) || PCOwner.GetStateName() == 'PlayerFlying';
	//return ReturnValue;	
}

function bool IsOwnerZooming()
{
	local HaloPlayerPawnController aController;

	aController = HaloPlayerPawnController(PCOwner);
	// End:0x4B
	if(aController != none)
	{
		return aController.IsZooming();
	}
	return false;
	//return ReturnValue;	
}

function bool IsOwnerAutoAiming()
{
	local HaloPlayerPawnController aController;

	aController = HaloPlayerPawnController(PCOwner);
	// End:0x4B
	if(aController != none)
	{
		return aController.IsAutoAimEnabled;
	}
	return false;
	//return ReturnValue;	
}

function bool IsOwnerManuallyAiming()
{
	return ManualAimActiveTimeout > WorldInfo.TimeSeconds;
	//return ReturnValue;	
}

function bool IsOwnerFiring()
{
	// End:0x6B
	if(HaloPawn(PCOwner.Pawn) != none)
	{
		return HaloPawn(PCOwner.Pawn).bIsFiring;
	}
	return false;
	//return ReturnValue;	
}

function bool IsOwnerTargetDesignating()
{
	local HaloPlayerPawnController aController;

	aController = HaloPlayerPawnController(PCOwner);
	// End:0x4B
	if(aController != none)
	{
		return aController.bIsAimingTargetDesignator;
	}
	return false;
	//return ReturnValue;	
}

function bool ShouldFollowTargetZ()
{
	local HaloPawn P;

	P = HaloPawn(PCOwner.Pawn);
	// End:0x60
	if(P != none)
	{
		return P.ShouldFollowTargetZ();
	}
	return false;
	//return ReturnValue;	
}

function Vector GetOwnerVelocity()
{
	// End:0x58
	if(PCOwner.Pawn != none)
	{
		return PCOwner.Pawn.Velocity;
	}
	return vect(0.0000000, 0.0000000, 0.0000000);
	//return ReturnValue;	
}

function int GetOwnerZoomLevel()
{
	local HaloPlayerPawnController aController;

	aController = HaloPlayerPawnController(PCOwner);
	// End:0x4B
	if(aController != none)
	{
		return aController.GetZoomLevel();
	}
	return 0;
	//return ReturnValue;	
}

function Vector GetOwnerMotionInput()
{
	local HaloPlayerPawnController aController;

	aController = HaloPlayerPawnController(PCOwner);
	// End:0x4B
	if(aController != none)
	{
		return aController.GetPlayerPawnMotion();
	}
	return vect(0.0000000, 0.0000000, 0.0000000);
	//return ReturnValue;	
}

function Vector GetOwnerAimInput()
{
	local HaloPlayerPawnController aController;

	aController = HaloPlayerPawnController(PCOwner);
	// End:0x4B
	if(aController != none)
	{
		return aController.GetPlayerAimMotion();
	}
	return vect(0.0000000, 0.0000000, 0.0000000);
	//return ReturnValue;	
}

function Actor GetAutoAimTarget()
{
	return AutoAimTarget;
	//return ReturnValue;	
}

function Actor GetAutoAimExtendedTarget()
{
	return ((AutoAimTarget != none) ? AutoAimTarget : AutoAimExtendedTarget);
	//return ReturnValue;	
}

function bool IsValidTarget(const Actor A)
{
	local int Team;

	// End:0x11
	if(A == none)
	{
		return false;
	}
	Team = int(A.GetTeamNum());
	// End:0x7F
	if((Team != 255) && Team == int(PCOwner.GetTeamNum()))
	{
		return false;
	}
	return true;
	//return ReturnValue;	
}

function bool IsValidEnemy(const Actor A)
{
	local Pawn aPawn;

	// End:0x1B
	if((IsValidTarget(A)) == false)
	{
		return false;
	}
	aPawn = Pawn(A);
	// End:0x48
	if(aPawn == none)
	{
		return true;
	}
	// End:0x6E
	if(aPawn.Health <= 0)
	{
		return false;
	}
	return true;
	//return ReturnValue;	
}

function float ScoreEnemyTarget(const Vector aLocation, float MinDistance, float MaxDistance, float nearAngle, float farAngle, const Vector bLocation, const Rotator BRotation)
{
	local Vector aDirection;
	local Rotator aYaw, bYaw;
	local float Score, Distance, Angle, adjustedAngle, distanceScale, scaledAngle;

	aDirection = aLocation - bLocation;
	Distance = VSize(aDirection);
	aYaw.Yaw = Rotator(aDirection).Yaw;
	bYaw.Yaw = BRotation.Yaw;
	Angle = RDiff(aYaw, bYaw);
	// End:0x1D4
	if((Distance > MinDistance) && Distance <= MaxDistance)
	{
		distanceScale = (Distance - MinDistance) / (MaxDistance - MinDistance);
		scaledAngle = ((farAngle - nearAngle) * distanceScale) + nearAngle;
		// End:0x1D4
		if(Angle < scaledAngle)
		{
			adjustedAngle = (180.0000000 - Angle) / 180.0000000;
			Score = adjustedAngle + (((1.0000000 - distanceScale) * adjustedAngle) * 0.6500000);
		}
	}
	return Score;
	//return ReturnValue;	
}

function Actor FindBestAutoAimTarget(const TPOV POV, const Actor Target, const HaloCameraConfig cfg)
{
	local Actor aActor, bestActor;
	local float MinDistance, MaxDistance, nearAngle, farAngle, Score, bestScore;

	local Vector aLocation, bLocation;
	local Rotator BRotation;
	local int Index, LevelIndex;

	MinDistance = 0.0000000;
	MaxDistance = MagnetAim.Range;
	nearAngle = MagnetAim.Angle * 0.5000000;
	farAngle = MagnetAim.Angle;
	bestScore = 0.0000000;
	bLocation = Target.Location;
	BRotation = Target.Rotation;
	LevelIndex = 0;
	J0xF2:

	// End:0x2D9 [Loop If]
	if(LevelIndex < 3)
	{
		// End:0x2CB
		if(bestActor == none)
		{
			Index = 0;
			J0x11C:

			// End:0x2CB [Loop If]
			if(Index < OrbitEncounterPriorityList[LevelIndex].Items.Length)
			{
				aActor = OrbitEncounterPriorityList[LevelIndex].Items[Index].Target;
				// End:0x2BD
				if((IsValidEnemy(aActor)) == true)
				{
					aLocation = Class'MegaHaloGame.HaloPawn'.static.GetRealLocationOf(aActor);
					Score = ScoreEnemyTarget(aLocation, MinDistance, MaxDistance, nearAngle, farAngle, bLocation, BRotation);
					// End:0x2BD
					if(Score > bestScore)
					{
						// End:0x2BD
						if(PCOwner.LineOfSightTo(aActor, POV.Location) == true)
						{
							bestScore = Score;
							bestActor = aActor;
						}
					}
				}
				Index++;
				// [Loop Continue]
				goto J0x11C;
			}
		}
		LevelIndex++;
		// [Loop Continue]
		goto J0xF2;
	}
	return bestActor;
	//return ReturnValue;	
}

function Actor FindBestAutoAimExtendedTarget(const TPOV POV, const Actor Target, const HaloCameraConfig cfg)
{
	local Actor aActor, bestActor;
	local float MinDistance, MaxDistance, nearAngle, farAngle, Score, bestScore;

	local Vector aLocation, bLocation;
	local Rotator BRotation;
	local int Index, LevelIndex;

	MinDistance = MagnetAim.Range;
	MaxDistance = cfg.AutoAimExtendedRange;
	nearAngle = MagnetAim.Angle * 0.5000000;
	farAngle = MagnetAim.Angle * 0.5000000;
	bestScore = 0.0000000;
	bLocation = Target.Location;
	BRotation = Target.Rotation;
	LevelIndex = 0;
	J0x112:

	// End:0x2F9 [Loop If]
	if(LevelIndex < 3)
	{
		// End:0x2EB
		if(bestActor == none)
		{
			Index = 0;
			J0x13C:

			// End:0x2EB [Loop If]
			if(Index < OrbitEncounterPriorityList[LevelIndex].Items.Length)
			{
				aActor = OrbitEncounterPriorityList[LevelIndex].Items[Index].Target;
				// End:0x2DD
				if((IsValidEnemy(aActor)) == true)
				{
					bLocation = Class'MegaHaloGame.HaloPawn'.static.GetRealLocationOf(aActor);
					Score = ScoreEnemyTarget(aLocation, MinDistance, MaxDistance, nearAngle, farAngle, bLocation, BRotation);
					// End:0x2DD
					if(Score > bestScore)
					{
						// End:0x2DD
						if(PCOwner.LineOfSightTo(aActor, POV.Location) == true)
						{
							bestScore = Score;
							bestActor = aActor;
						}
					}
				}
				Index++;
				// [Loop Continue]
				goto J0x13C;
			}
		}
		LevelIndex++;
		// [Loop Continue]
		goto J0x112;
	}
	return bestActor;
	//return ReturnValue;	
}

function SetMagnetAimByName(name aName)
{
	local int Index;

	// End:0x12D
	if(CameraConfig != none)
	{
		Index = CameraConfig.MagnetAimArray.Find('Name', aName);
		// End:0x95
		if(Index != -1)
		{
			MagnetAim = CameraConfig.MagnetAimArray[Index];			
		}
		else
		{
			Index = CameraConfig.MagnetAimArray.Find('Name', CameraConfig.MagnetAimDefaultName);
			// End:0x12D
			if(Index != -1)
			{
				MagnetAim = CameraConfig.MagnetAimArray[Index];
			}
		}
	}
	//return;	
}

function HACKUpdateMagnetAim(const Actor Target)
{
	// End:0xA2
	if((Pawn(Target) != none) && Pawn(Target).Weapon != none)
	{
		SetMagnetAimByName(Pawn(Target).Weapon.Class.Name);
	}
	//return;	
}

simulated function EncounterTarget(const Actor Target, HaloPlayerCamera.EEncounterPriorityLevel Level)
{
	local int Index;
	local EncounterActor ea;

	Index = OrbitEncounterPriorityList[int(Level)].Items.Find('Target', Target);
	// End:0xDB
	if(Index == -1)
	{
		ea.Target = Target;
		ea.TimeOut = 2.0000000;
		OrbitEncounterPriorityList[int(Level)].Items.AddItem(ea);		
	}
	else
	{
		OrbitEncounterPriorityList[int(Level)].Items[Index].TimeOut = 2.0000000;
	}
	//return;	
}

function EncounterPriorityArrayUpdate(out EncounterArray oList, float DeltaTime)
{
	local int Index;

	Index = oList.Items.Length - 1;
	J0x2A:

	// End:0x171 [Loop If]
	if(Index >= 0)
	{
		oList.Items[Index].TimeOut = oList.Items[Index].TimeOut - DeltaTime;
		// End:0x163
		if((oList.Items[Index].TimeOut <= 0.0000000) || oList.Items[Index].Target == none)
		{
			oList.Items.Remove(Index, 1);
		}
		Index--;
		// [Loop Continue]
		goto J0x2A;
	}
	//return;	
}

function EncounterPriorityListUpdate(float DeltaTime)
{
	local int Index;

	Index = 0;
	J0x0B:

	// End:0x4F [Loop If]
	if(Index < 3)
	{
		EncounterPriorityArrayUpdate(OrbitEncounterPriorityList[Index], DeltaTime);
		Index++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function EncounterDisableAdd(const name aName)
{
	// End:0x36
	if(OrbitEncounterDisableReferences.Find(aName) == -1)
	{
		OrbitEncounterDisableReferences.AddItem(aName);
	}
	//return;	
}

function EncounterDisableRemove(const name aName)
{
	// End:0x36
	if(OrbitEncounterDisableReferences.Find(aName) != -1)
	{
		OrbitEncounterDisableReferences.RemoveItem(aName);
	}
	//return;	
}

function bool HasEncounterDisable(const name aName)
{
	return OrbitEncounterDisableReferences.Find(aName) != -1;
	//return ReturnValue;	
}

function bool IsEncounterModeActive()
{
	return OrbitEncounterPriorityInfo.Priority != -99999999;
	//return ReturnValue;	
}

function SetOrbitSettingsByName(name aName)
{
	local int Index;

	// End:0x92
	if(CameraConfig != none)
	{
		Index = CameraConfig.OrbitArray.Find('Name', aName);
		// End:0x92
		if(Index != -1)
		{
			SetOrbitSettings(CameraConfig.OrbitArray[Index]);
		}
	}
	//return;	
}

function SetOrbitSettings(const OrbitStruct aOrbit)
{
	local int Index;

	Index = OrbitSettingsArray.Find('Name', aOrbit.Name);
	// End:0x6E
	if(Index != -1)
	{
		OrbitSettingsArray[Index] = aOrbit;
		return;
	}
	Index = 0;
	J0x79:

	// End:0xE9 [Loop If]
	if(Index < OrbitSettingsArray.Length)
	{
		// End:0xDB
		if(OrbitSettingsArray[Index].Priority <= aOrbit.Priority)
		{
			// [Explicit Break]
			goto J0xE9;
		}
		Index++;
		// [Loop Continue]
		goto J0x79;
	}
	J0xE9:

	OrbitSettingsArray.InsertItem(Index, aOrbit);
	PriorityInfoSet(OrbitSettingsPriorityInfo, '__ORBIT__', OrbitSettingsArray[0].Priority, 'Orbit');
	//return;	
}

function RemoveOrbitSettings(name aName)
{
	local int Index;

	Index = OrbitSettingsArray.Find('Name', aName);
	// End:0x51
	if(Index != -1)
	{
		OrbitSettingsArray.Remove(Index, 1);
	}
	// End:0xA7
	if(OrbitSettingsArray.Length > 0)
	{
		PriorityInfoSet(OrbitSettingsPriorityInfo, '__ORBIT__', OrbitSettingsArray[0].Priority, 'Orbit');		
	}
	else
	{
		PriorityInfoClear(OrbitSettingsPriorityInfo);
	}
	//return;	
}

function bool GetOrbitStruct(out OrbitStruct Orbit)
{
	// End:0x27
	if(OrbitSettingsArray.Length > 0)
	{
		Orbit = OrbitSettingsArray[0];
		return true;
	}
	return false;
	//return ReturnValue;	
}

function SetLockView(const LockViewStruct aLock)
{
	local int Index;

	Index = LockViewArray.Find('Name', aLock.Name);
	// End:0x6E
	if(Index != -1)
	{
		LockViewArray[Index] = aLock;
		return;
	}
	Index = 0;
	J0x79:

	// End:0xE9 [Loop If]
	if(Index < LockViewArray.Length)
	{
		// End:0xDB
		if(LockViewArray[Index].Priority <= aLock.Priority)
		{
			// [Explicit Break]
			goto J0xE9;
		}
		Index++;
		// [Loop Continue]
		goto J0x79;
	}
	J0xE9:

	LockViewArray.InsertItem(Index, aLock);
	SetupLockViewPriorityInfo();
	//return;	
}

function RemoveLockView(name aName)
{
	local int Index;

	Index = LockViewArray.Find('Name', aName);
	// End:0x51
	if(Index != -1)
	{
		LockViewArray.Remove(Index, 1);
	}
	SetupLockViewPriorityInfo();
	//return;	
}

function SetupLockViewPriorityInfo()
{
	local int Index;

	PriorityInfoClear(LockViewRotationPriorityInfo);
	PriorityInfoClear(LockViewLocationPriorityInfo);
	PriorityInfoClear(LockViewFOVPriorityInfo);
	Index = 0;
	J0x44:

	// End:0x2AD [Loop If]
	if(Index < LockViewArray.Length)
	{
		// End:0x11D
		if((LockViewArray[Index].LockRotation == true) && LockViewRotationPriorityInfo.Name == 'None')
		{
			PriorityInfoSet(LockViewRotationPriorityInfo, LockViewArray[Index].Name, LockViewArray[Index].Priority, 'LockView');
		}
		// End:0x1DE
		if((LockViewArray[Index].LockLocation == true) && LockViewLocationPriorityInfo.Name == 'None')
		{
			PriorityInfoSet(LockViewLocationPriorityInfo, LockViewArray[Index].Name, LockViewArray[Index].Priority, 'LockView');
		}
		// End:0x29F
		if((LockViewArray[Index].LockFOV == true) && LockViewFOVPriorityInfo.Name == 'None')
		{
			PriorityInfoSet(LockViewFOVPriorityInfo, LockViewArray[Index].Name, LockViewArray[Index].Priority, 'LockView');
		}
		Index++;
		// [Loop Continue]
		goto J0x44;
	}
	//return;	
}

function SetOrbitLockOn(const OrbitLockOnStruct aLockOn)
{
	local int Index;

	Index = OrbitLockOnArray.Find('Name', aLockOn.Name);
	// End:0x6E
	if(Index != -1)
	{
		OrbitLockOnArray[Index] = aLockOn;
		return;
	}
	Index = 0;
	J0x79:

	// End:0xE9 [Loop If]
	if(Index < OrbitLockOnArray.Length)
	{
		// End:0xDB
		if(OrbitLockOnArray[Index].Priority <= aLockOn.Priority)
		{
			// [Explicit Break]
			goto J0xE9;
		}
		Index++;
		// [Loop Continue]
		goto J0x79;
	}
	J0xE9:

	OrbitLockOnArray.InsertItem(Index, aLockOn);
	PriorityInfoSet(OrbitLockOnPriorityInfo, OrbitLockOnArray[0].Name, OrbitLockOnArray[0].Priority, 'OrbitLockOn');
	//return;	
}

function RemoveOrbitLockOn(name aName)
{
	local int Index;

	Index = OrbitLockOnArray.Find('Name', aName);
	// End:0x51
	if(Index != -1)
	{
		OrbitLockOnArray.Remove(Index, 1);
	}
	// End:0xBC
	if(OrbitLockOnArray.Length > 0)
	{
		PriorityInfoSet(OrbitLockOnPriorityInfo, OrbitLockOnArray[0].Name, OrbitLockOnArray[0].Priority, 'OrbitLockOn');		
	}
	else
	{
		PriorityInfoClear(OrbitLockOnPriorityInfo);
	}
	//return;	
}

function bool GetOrbitLockOnStruct(out OrbitLockOnStruct LockOn)
{
	// End:0x4D
	if((OrbitLockOnArray.Length > 0) && OrbitLockOnArray[0].Target != none)
	{
		LockOn = OrbitLockOnArray[0];
		return true;
	}
	return false;
	//return ReturnValue;	
}

function SetLocationMask(const LocationMaskStruct aMask)
{
	local int Index;

	Index = LocationMaskArray.Find('Name', aMask.Name);
	// End:0x6E
	if(Index != -1)
	{
		LocationMaskArray[Index] = aMask;
		return;
	}
	Index = 0;
	J0x79:

	// End:0xE9 [Loop If]
	if(Index < LocationMaskArray.Length)
	{
		// End:0xDB
		if(LocationMaskArray[Index].Priority <= aMask.Priority)
		{
			// [Explicit Break]
			goto J0xE9;
		}
		Index++;
		// [Loop Continue]
		goto J0x79;
	}
	J0xE9:

	LocationMaskArray.InsertItem(Index, aMask);
	//return;	
}

function RemoveLocationMask(name aName)
{
	local int Index;

	Index = LocationMaskArray.Find('Name', aName);
	// End:0x51
	if(Index != -1)
	{
		LocationMaskArray.Remove(Index, 1);
	}
	//return;	
}

function SetViewRotation(const Rotator vRotation, optional ViewTargetTransitionParams vTransition)
{
	SetRotationTransition(POVCache.Rotation, vRotation, vTransition);
	//return;	
}

function SetRotationTransition(const Rotator ARotation, const Rotator BRotation, const optional ViewTargetTransitionParams aParams)
{
	RotationTransition.ARotation = ARotation;
	RotationTransition.BRotation = BRotation;
	RotationTransition.Params = aParams;
	RotationTransition.Params.BlendTime = FMax(aParams.BlendTime, 0.0000001);
	RotationTransition.Time = RotationTransition.Params.BlendTime;
	//return;	
}

function UpdateOrbitTargetLocation(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime)
{
	local Vector NewLocation;
	local OrbitStruct Orbit;

	// End:0x429
	if(Target != none)
	{
		GetOrbitStruct(Orbit);
		TargetFocusOffset = VNamedBlendUpdate(OrbitFocusOffsetBlend, Orbit.Name, Orbit.FocusOffset, DeltaTime);
		NewLocation = CalculateFocusLocation(POV.Rotation, Target.Location, TargetFocusOffset);
		NewLocation = UpdateTargetLocationMask(POV, NewLocation, TargetLocation);
		// End:0x166
		if(TargetZSpeed == float(0))
		{
			TargetZSpeed = cfg.TargetFollowSpeed;
			TargetZHeight = NewLocation.Z;
		}
		// End:0x211
		if((ShouldFollowTargetZ()) || TargetZHeight > NewLocation.Z)
		{
			TargetZSpeed = FInterpTo(TargetZSpeed, cfg.TargetFollowSpeed, DeltaTime, 2.0000000);
			TargetZHeight = NewLocation.Z;			
		}
		else
		{
			TargetZHeight = CalculateZHeight(Target, NewLocation, TargetZHeight);
			TargetZSpeed = cfg.TargetFollowSpeed * 0.1500000;
		}
		// End:0x416
		if((cfg.TargetFollowSpeed > float(0)) && IsZero(TargetLocation) == false)
		{
			TargetLocation.X = FInterpTo(TargetLocation.X, NewLocation.X, DeltaTime, cfg.TargetFollowSpeed);
			TargetLocation.Y = FInterpTo(TargetLocation.Y, NewLocation.Y, DeltaTime, cfg.TargetFollowSpeed);
			TargetLocation.Z = FInterpTo(TargetLocation.Z, TargetZHeight, DeltaTime, TargetZSpeed);			
		}
		else
		{
			TargetLocation = NewLocation;
		}
	}
	//return;	
}

function float CalculateZHeight(const Actor Target, const Vector aLocation, const float MinHeight)
{
	local TraceHitInfo HitInfo;
	local Actor HitActor;
	local Vector HitNormal, HitLocation, TraceStart, TraceEnd;
	local int TraceFlags;

	TraceStart = aLocation;
	TraceEnd = aLocation;
	TraceEnd.Z = MinHeight;
	TraceFlags = Target.8;
	HitActor = Target.Trace(HitLocation, HitNormal, TraceEnd, TraceStart,,, HitInfo, TraceFlags);
	// End:0x17D
	if(((HitActor != none) && HitLocation.Z > MinHeight) && (HitInfo.HitComponent == none) || HitInfo.HitComponent.CanBlockCamera == true)
	{
		return HitLocation.Z;
	}
	return MinHeight;
	//return ReturnValue;	
}

function Vector UpdateTargetLocationMask(const TPOV POV, const Vector NewLocation, const Vector OldLocation)
{
	// End:0x11B
	if(LocationMaskArray.Length > 0)
	{
		// End:0x9B
		if(int(LocationMaskArray[0].MaskFunction) == int(0))
		{
			return ApplyAngularLocationMask(POV, NewLocation, OldLocation, LocationMaskArray[0].Width, LocationMaskArray[0].Height);
		}
		return ApplyDistanceLocationMask(POV, NewLocation, OldLocation, LocationMaskArray[0].Width, LocationMaskArray[0].Height, LocationMaskArray[0].Depth);
	}
	return NewLocation;
	//return ReturnValue;	
}

function Vector ApplyAngularLocationMask(const TPOV POV, const Vector aLocation, const Vector bLocation, float Yaw, float Pitch)
{
	local float Value, MaxValue;
	local Vector aDirection, bDirection, diffLocal, aLocal, bLocal, newLocal,
		Result;

	local Rotator aLocalRot, bLocalRot;

	aDirection = aLocation - POV.Location;
	bDirection = bLocation - POV.Location;
	aLocal = aDirection << POV.Rotation;
	bLocal = bDirection << POV.Rotation;
	diffLocal = aLocal - bLocal;
	newLocal = bLocal;
	newLocal.X = aLocal.X;
	MaxValue = Yaw;
	aLocalRot.Yaw = Rotator(aLocal).Yaw;
	aLocalRot.Pitch = 0;
	bLocalRot.Yaw = Rotator(bLocal).Yaw;
	bLocalRot.Pitch = 0;
	Value = RDiff(aLocalRot, bLocalRot);
	// End:0x2BC
	if(Value >= MaxValue)
	{
		newLocal.Y += ((MaxValue > float(0)) ? diffLocal.Y * ((Value - MaxValue) / Value) : diffLocal.Y);
	}
	MaxValue = Pitch;
	aLocalRot.Yaw = 0;
	aLocalRot.Pitch = Rotator(aLocal).Pitch;
	bLocalRot.Yaw = 0;
	bLocalRot.Pitch = Rotator(bLocal).Pitch;
	Value = RDiff(aLocalRot, bLocalRot);
	// End:0x448
	if(Value >= MaxValue)
	{
		newLocal.Z += ((MaxValue > float(0)) ? diffLocal.Z * ((Value - MaxValue) / Value) : diffLocal.Z);
	}
	Result = (newLocal >> POV.Rotation) + POV.Location;
	return Result;
	//return ReturnValue;	
}

function Vector ApplyDistanceLocationMask(const TPOV POV, const Vector aLocation, const Vector bLocation, float Width, float Height, float Depth)
{
	local float Value, MaxValue;
	local Vector aDirection, bDirection, diffLocal, aLocal, bLocal, newLocal,
		Result;

	aDirection = aLocation - POV.Location;
	bDirection = bLocation - POV.Location;
	aLocal = aDirection << POV.Rotation;
	bLocal = bDirection << POV.Rotation;
	diffLocal = aLocal - bLocal;
	newLocal = bLocal;
	MaxValue = Depth;
	Value = Abs(diffLocal.X);
	// End:0x1D3
	if(Value >= MaxValue)
	{
		newLocal.X += ((MaxValue > float(0)) ? diffLocal.X * ((Value - MaxValue) / Value) : diffLocal.X);
	}
	MaxValue = Width;
	Value = Abs(diffLocal.Y);
	// End:0x2AF
	if(Value >= MaxValue)
	{
		newLocal.Y += ((MaxValue > float(0)) ? diffLocal.Y * ((Value - MaxValue) / Value) : diffLocal.Y);
	}
	MaxValue = Height;
	Value = Abs(diffLocal.Z);
	// End:0x38B
	if(Value >= MaxValue)
	{
		newLocal.Z += ((MaxValue > float(0)) ? diffLocal.Z * ((Value - MaxValue) / Value) : diffLocal.Z);
	}
	Result = (newLocal >> POV.Rotation) + POV.Location;
	return Result;
	//return ReturnValue;	
}

function UpdateManualAimFreshness(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime)
{
	// End:0x83
	if(cfg.OrbitAimEnabled == true)
	{
		// End:0x83
		if(VSize(GetOwnerAimInput()) > 0.0100000)
		{
			ManualAimActiveTimeout = cfg.OrbitAimFreshTime + WorldInfo.TimeSeconds;
		}
	}
	//return;	
}

function Rotator UpdateOrbitRotation(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime, out FBlendRange oBlendRange)
{
	local TPOV oPov;
	local OrbitStruct Orbit;

	GetOrbitStruct(Orbit);
	oPov = POV;
	oPov.Rotation = UpdateOrbitFollowRotation(oPov, Target, cfg, DeltaTime);
	oPov.Rotation = UpdateOrbitManualAimRotation(oPov, Target, cfg, DeltaTime);
	oPov.Rotation = UpdateOrbitAutoAimRotation(oPov, Target, cfg, DeltaTime);
	oPov.Rotation = UpdateAutoCenterPitch(oPov, Target, cfg, DeltaTime);
	oPov.Rotation = UpdateAutoCenterPitchCollision(oPov, Target, cfg, DeltaTime);
	oPov.Rotation = UpdateAutoCenterYaw(oPov, Target, cfg, DeltaTime);
	oPov.Rotation = UpdateAutoCenterYawCollision(oPov, Target, cfg, DeltaTime);
	oPov.Rotation = UpdateRotationTransition(oPov, Target, cfg, DeltaTime);
	oBlendRange = Orbit.RotationBlendRange;
	return oPov.Rotation;
	//return ReturnValue;	
}

function Rotator UpdateRotationTransition(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime)
{
	local Rotator oRotation, ARotation;
	local float Pct;

	oRotation = POV.Rotation;
	// End:0x244
	if(RotationTransition.Time > float(0))
	{
		RotationTransition.Time = FMax(RotationTransition.Time - DeltaTime, 0.0000000);
		Pct = FBlendTo(0.0000000, 1.0000000, (RotationTransition.Params.BlendTime - RotationTransition.Time) / RotationTransition.Params.BlendTime, RotationTransition.Params.BlendFunction, RotationTransition.Params.BlendExp);
		// End:0x1EE
		if(RotationTransition.Params.bLockOutgoing == true)
		{
			ARotation = RotationTransition.ARotation;			
		}
		else
		{
			ARotation = oRotation;
		}
		oRotation = RLerp(ARotation, RotationTransition.BRotation, Pct, true);
	}
	return oRotation;
	//return ReturnValue;	
}

function Rotator UpdateOrbitFollowRotation(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime)
{
	local Rotator oRotation;

	oRotation = POV.Rotation;
	// End:0xB3
	if((((IsOwnerZooming()) == false) && (IsOwnerAutoAiming()) == false) && (IsOwnerManuallyAiming()) == false)
	{
		oRotation.Yaw = Rotator(TargetLocation - POV.Location).Yaw;
	}
	return oRotation;
	//return ReturnValue;	
}

function Rotator UpdateOrbitManualAimRotation(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime)
{
	local Rotator oRotation;
	local OrbitStruct Orbit;
	local float yawDelta;
	local Vector aimInput;

	oRotation = POV.Rotation;
	// End:0x2D0
	if((cfg.OrbitAimEnabled == true) || (IsOwnerTargetDesignating()) == true)
	{
		aimInput = GetOwnerAimInput();
		GetOrbitStruct(Orbit);
		yawDelta = aimInput.X * ((Orbit.AimYawSpeed * 182.0444031) * DeltaTime);
		// End:0x1A1
		if(Abs(aimInput.X) > 0.9000000)
		{
			yawDelta *= (CalculateRangedMultiplier(cfg.OrbitAimMultiplier, OrbitManualAimMultiplierAngle, cfg.OrbitAimMultiplierAngleMax * 182.0444031, cfg.OrbitAimMultiplierAngleMin * 182.0444031));
			OrbitManualAimMultiplierAngle += Abs(yawDelta);			
		}
		else
		{
			OrbitManualAimMultiplierAngle = 0.0000000;
		}
		oRotation.Yaw += int(yawDelta);
		oRotation.Pitch += int(aimInput.Z * ((Orbit.AimPitchSpeed * 182.0444031) * DeltaTime));
		oRotation.Pitch = Clamp(oRotation.Pitch, int(-cfg.OrbitPitchHighLimit * 182.0444031), int(cfg.OrbitPitchLowLimit * 182.0444031));
	}
	return oRotation;
	//return ReturnValue;	
}

function Rotator UpdateOrbitAutoAimRotation(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime)
{
	local Rotator oRotation, AimRotation;

	oRotation = POV.Rotation;
	// End:0xDF
	if((IsOrbitAutoAimTargetValid()) == true)
	{
		AimRotation = Rotator(OrbitAutoAimTarget.Location - TargetLocation);
		oRotation.Yaw = RInterpTo(oRotation, AimRotation, DeltaTime, cfg.OrbitLockOnRate, false).Yaw;
	}
	return oRotation;
	//return ReturnValue;	
}

function Rotator UpdateAutoCenterPitch(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime)
{
	local Rotator oRotation, aRot, bRot;
	local OrbitStruct Orbit;

	oRotation = POV.Rotation;
	// End:0x1F9
	if(((((IsOwnerManuallyAiming()) == false) && IsZero(GetOwnerVelocity()) == false) && (IsOwnerZooming()) == false) && (IsOwnerFiring()) == false)
	{
		GetOrbitStruct(Orbit);
		// End:0xEE
		if(cfg.AutoCenterPitchEnabled == false)
		{
			oRotation.Pitch = int(-Orbit.Pitch * 182.0444031);			
		}
		else
		{
			aRot.Pitch = POV.Rotation.Pitch;
			bRot.Pitch = int(-Orbit.Pitch * 182.0444031);
			oRotation.Pitch = RInterpTo(aRot, bRot, DeltaTime, cfg.AutoCenterPitchSpeed * 182.0444031, true).Pitch;
		}
	}
	return oRotation;
	//return ReturnValue;	
}

function Rotator UpdateAutoCenterPitchCollision(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime)
{
	local Rotator oRotation;
	local TraceHitInfo HitInfo;
	local Actor HitActor;
	local Vector HitLocation, HitNormal, TraceStart, TraceEnd;
	local int TraceFlags;
	local Rotator bRot;
	local Box hitBox;

	oRotation = POV.Rotation;
	// End:0x417
	if(cfg.AutoCenterPitchCollideEnabled == true)
	{
		TraceFlags = Target.8;
		TraceStart = Target.Location;
		TraceStart.Z = (TargetLocation.Z + Target.Location.Z) * 0.5000000;
		TraceEnd = POV.Location;
		TraceEnd.Z = TraceStart.Z;
		HitActor = Target.Trace(HitLocation, HitNormal, TraceEnd, TraceStart,,, HitInfo, TraceFlags);
		// End:0x417
		if(((HitActor != none) && Abs(HitNormal.Z) < 0.2000000) && (HitInfo.HitComponent == none) || HitInfo.HitComponent.CanBlockCamera == true)
		{
			HitActor.GetComponentsBoundingBox(hitBox);
			HitLocation.Z = hitBox.Max.Z;
			bRot.Pitch = -Rotator(HitLocation - TraceStart).Pitch;
			// End:0x417
			if((bRot.Pitch < oRotation.Pitch) && float(bRot.Pitch) > -cfg.OrbitPitchHighLimit * 182.0444031)
			{
				oRotation.Pitch = RInterpTo(oRotation, bRot, DeltaTime, cfg.AutoCenterPitchCollideSpeed * 182.0444031, true).Pitch;
			}
		}
	}
	return oRotation;
	//return ReturnValue;	
}

function Rotator UpdateAutoCenterYaw(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime)
{
	local Rotator oRotation;
	local float Angle, StartAngle, InterpSpeed;
	local Rotator aRot, bRot;

	oRotation = POV.Rotation;
	// End:0x222
	if((((cfg.AutoCenterYawEnabled == true) && (IsOwnerManuallyAiming()) == false) && AutoAimTarget != none) && (IsOwnerFiring()) == true)
	{
		aRot.Yaw = oRotation.Yaw;
		bRot.Yaw = Target.Rotation.Yaw;
		Angle = RDiff(aRot, bRot);
		StartAngle = cfg.AutoCenterYawTargetAngle;
		// End:0x222
		if(Angle > StartAngle)
		{
			InterpSpeed = cfg.AutoCenterYawTargetSpeed * ((Angle - StartAngle) / (180.0000000 - StartAngle));
			oRotation.Yaw = RInterpTo(aRot, bRot, DeltaTime, InterpSpeed * 182.0444031, true).Yaw;
		}
	}
	return oRotation;
	//return ReturnValue;	
}

function Rotator UpdateAutoCenterYawCollision(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime)
{
	local Rotator oRotation;
	local TraceHitInfo HitInfo;
	local Actor HitActor;
	local Vector HitLocation, HitNormal, TraceStart, TraceEnd;
	local int TraceFlags;
	local Vector motionInput;
	local Rotator aRot, bRot;
	local float Angle;
	local Vector Motion, lookAheadOffset;
	local float oYawSpeed;
	local Vector oMotionInput;

	oRotation = POV.Rotation;
	oYawSpeed = AutoCenterYawSpeed;
	oMotionInput = AutoCenterYawLastRawTargetMotion;
	// End:0x4D8
	if((cfg.AutoCenterYawCollideEnabled == true) && (IsOwnerManuallyAiming()) == false)
	{
		aRot.Yaw = oRotation.Yaw;
		bRot.Yaw = Target.Rotation.Yaw;
		Angle = RDiff(aRot, bRot);
		motionInput = GetOwnerMotionInput();
		Motion = GetOwnerVelocity();
		// End:0x2C7
		if((Angle < cfg.AutoCenterYawCollideAngle) && IsZero(Motion) == false)
		{
			lookAheadOffset = Normal(Motion) * cfg.AutoCenterYawCollideLookAheadDistance;
			lookAheadOffset.Z = cfg.AutoCenterYawCollideLookAheadHeight;
			TraceFlags = Target.8;
			TraceStart = TargetLocation + lookAheadOffset;
			TraceEnd = POV.Location;
			HitActor = Target.Trace(HitLocation, HitNormal, TraceEnd, TraceStart,,, HitInfo, TraceFlags);
		}
		// End:0x401
		if(((HitActor != none) && IsZero(TraceStart - HitLocation) == false) || ((IsZero(oMotionInput) == false) && VSize(motionInput - oMotionInput) < 0.0020000) && (HitInfo.HitComponent == none) || HitInfo.HitComponent.CanBlockCamera == true)
		{
			oMotionInput = motionInput;
			oYawSpeed = FInterpTo(oYawSpeed, cfg.AutoCenterYawCollideSpeed, DeltaTime, cfg.AutoCenterYawCollideAccelSpeed);			
		}
		else
		{
			oMotionInput = vect(0.0000000, 0.0000000, 0.0000000);
			oYawSpeed = FInterpTo(oYawSpeed, 0.0000000, DeltaTime, cfg.AutoCenterYawCollideDecelSpeed);
		}
		// End:0x4D8
		if(oYawSpeed > float(0))
		{
			oRotation.Yaw = RInterpTo(aRot, bRot, DeltaTime, oYawSpeed * 182.0444031, true).Yaw;
		}
	}
	AutoCenterYawSpeed = oYawSpeed;
	AutoCenterYawLastRawTargetMotion = oMotionInput;
	return oRotation;
	//return ReturnValue;	
}

function Rotator UpdateOrbitLockOnRotation(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime, out FBlendRange oBlendRange)
{
	local TPOV oPov;
	local Vector focusLocation, focusDir;
	local Rotator newAimRotation;
	local OrbitLockOnStruct LockOn;
	local OrbitStruct Orbit;

	// End:0x25C
	if(((GetOrbitLockOnStruct(LockOn)) == true) && (LockOn.EnableDuringPlayerTargetDesignatorMode == true) || (IsOwnerTargetDesignating()) == false)
	{
		focusLocation = TargetLocation;
		focusDir = LockOn.Target.Location - focusLocation;
		// End:0xDC
		if(LockOn.ReverseDirection == true)
		{
			focusDir *= -1.0000000;
		}
		newAimRotation = Rotator(focusDir);
		oPov.Rotation.Yaw = newAimRotation.Yaw;
		// End:0x1AF
		if(LockOn.EnablePitch == true)
		{
			oPov.Rotation.Pitch = newAimRotation.Pitch;			
		}
		else
		{
			GetOrbitStruct(Orbit);
			oPov.Rotation.Pitch = int(-Orbit.Pitch * 182.0444031);
		}
		oBlendRange = LockOn.RotationBlendRange;
		return oPov.Rotation;
	}
	return POV.Rotation;
	//return ReturnValue;	
}

function Vector UpdateOrbitLocation(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime, out FBlendRange oBlendRange)
{
	local Vector oLocation;
	local OrbitStruct Orbit;
	local Vector endLocation;
	local float Distance, lastDistance, orbitDistance;

	GetOrbitStruct(Orbit);
	orbitDistance = FNamedBlendUpdate(OrbitDistanceBlend, Orbit.Name, Orbit.Distance, DeltaTime);
	lastDistance = ((OrbitSettingsLastDistance > float(0)) ? OrbitSettingsLastDistance : orbitDistance);
	oLocation = TargetLocation + (Vector(POV.Rotation) * -orbitDistance);
	endLocation = TargetLocation + (Vector(POV.Rotation) * -orbitDistance + 400.0000000);
	Distance = CalculateCollisionDistance(endLocation, TargetLocation, Target, cfg);
	Distance = FMin(Distance, orbitDistance);
	Distance = FInterpTo(lastDistance, Distance, DeltaTime, ((Distance < lastDistance) ? cfg.CollideInRate : cfg.CollideOutRate));
	OrbitSettingsLastDistance = Distance;
	oLocation = TargetLocation + (Vector(POV.Rotation) * -Distance);
	oBlendRange = Orbit.LocationBlendRange;
	return oLocation;
	//return ReturnValue;	
}

function float CalculateCollisionDistance(const Vector End, const Vector Start, const Actor Target, const HaloCameraConfig cfg)
{
	local TraceHitInfo HitInfo;
	local Actor HitActor;
	local Vector HitLocation, HitNormal, traceDir;
	local int TraceFlags;
	local Vector localTraceDir, localTestDir;
	local float localAngle, localLength, hitLength, oDistance;

	oDistance = VSize(End - Start);
	// End:0x3D9
	if(Target != none)
	{
		TraceFlags = Target.8;
		traceDir = End - Start;
		HitActor = Target.Trace(HitLocation, HitNormal, End, Target.Location,,, HitInfo, TraceFlags);
		// End:0x1A4
		if((HitActor != none) && (HitInfo.HitComponent == none) || HitInfo.HitComponent.CanBlockCamera == true)
		{
			HitActor = Target.Trace(HitLocation, HitNormal, End, Start,,, HitInfo, TraceFlags);
		}
		// End:0x3D9
		if(((HitActor != none) && IsZero(HitLocation - Start) == false) && (HitInfo.HitComponent == none) || HitInfo.HitComponent.CanBlockCamera == true)
		{
			localTraceDir = traceDir << Rotator(HitNormal);
			localTestDir.X = localTraceDir.X;
			localTestDir.Y = 0.0000000;
			localTestDir.Z = localTraceDir.Z;
			localAngle = Acos(Normal(localTraceDir) Dot Normal(localTestDir));
			localLength = cfg.CollideExtent / Sin((3.1415927 / 2.0000000) - localAngle);
			hitLength = VSize(Start - HitLocation);
			hitLength -= localLength;
			hitLength = FMax(hitLength, cfg.CollideMinDistance);
			oDistance = FMin(oDistance, hitLength);
		}
	}
	return oDistance;
	//return ReturnValue;	
}

function float UpdateOrbitFOV(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime, out FBlendRange oBlendRange)
{
	local OrbitStruct Orbit;

	// End:0x5C
	if((GetOrbitStruct(Orbit)) == true)
	{
		oBlendRange = Orbit.FOVBlendRange;
		return Orbit.FOV;
	}
	return POV.FOV;
	//return ReturnValue;	
}

function Rotator UpdateLockViewRotation(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime, out FBlendRange oBlendRange)
{
	local int Index;

	Index = 0;
	J0x0B:

	// End:0xB5 [Loop If]
	if(Index < LockViewArray.Length)
	{
		// End:0xA7
		if(LockViewArray[Index].LockRotation == true)
		{
			oBlendRange = LockViewArray[Index].RotationBlendRange;
			return LockViewArray[Index].Rotation;
		}
		Index++;
		// [Loop Continue]
		goto J0x0B;
	}
	return POV.Rotation;
	//return ReturnValue;	
}

function Vector UpdateLockViewLocation(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime, out FBlendRange oBlendRange)
{
	local int Index;

	Index = 0;
	J0x0B:

	// End:0xB5 [Loop If]
	if(Index < LockViewArray.Length)
	{
		// End:0xA7
		if(LockViewArray[Index].LockLocation == true)
		{
			oBlendRange = LockViewArray[Index].LocationBlendRange;
			return LockViewArray[Index].Location;
		}
		Index++;
		// [Loop Continue]
		goto J0x0B;
	}
	return POV.Location;
	//return ReturnValue;	
}

function float UpdateLockViewFOV(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime, out FBlendRange oBlendRange)
{
	local int Index;

	Index = 0;
	J0x0B:

	// End:0xB5 [Loop If]
	if(Index < LockViewArray.Length)
	{
		// End:0xA7
		if(LockViewArray[Index].LockFOV == true)
		{
			oBlendRange = LockViewArray[Index].FOVBlendRange;
			return LockViewArray[Index].FOV;
		}
		Index++;
		// [Loop Continue]
		goto J0x0B;
	}
	return POV.FOV;
	//return ReturnValue;	
}

function UpdateAutoAimTarget(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime)
{
	local Vector aimLocation;

	// End:0x33
	if(cfg.AutoAimEnabled == false)
	{
		AutoAimTarget = none;		
	}
	else
	{
		// End:0x1C4
		if((((IsOwnerManuallyAiming()) == false) && (IsOwnerTargetDesignating()) == false) && (((IsOwnerAutoAiming()) == true) || (IsOwnerZooming()) == true) || (IsOwnerFiring()) == true)
		{
			aimLocation = Class'MegaHaloGame.HaloPawn'.static.GetRealLocationOf(AutoAimTarget);
			// End:0x192
			if(((IsValidEnemy(AutoAimTarget)) == true) && (ScoreEnemyTarget(aimLocation, 0.0000000, MagnetAim.Range, MagnetAim.Angle * 0.5000000, MagnetAim.Angle, Target.Location, Target.Rotation)) > float(0))
			{				
			}
			else
			{
				AutoAimTarget = FindBestAutoAimTarget(POV, Target, cfg);
			}			
		}
		else
		{
			AutoAimTarget = FindBestAutoAimTarget(POV, Target, cfg);
		}
	}
	//return;	
}

function bool IsOrbitAutoAimTargetValid()
{
	return ((((OrbitAutoAimTarget != none) && OrbitAutoAimTarget == AutoAimTarget) && (IsOwnerManuallyAiming()) == false) && (IsOwnerTargetDesignating()) == false) && (IsOwnerAutoAiming()) == true;
	//return ReturnValue;	
}

function UpdateOrbitAutoAimTarget(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime)
{
	// End:0x23
	if((IsOwnerAutoAiming()) == false)
	{
		OrbitAutoAimTarget = AutoAimTarget;
	}
	// End:0x36
	if((IsOrbitAutoAimTargetValid()) == true)
	{		
	}
	else
	{
		// End:0x51
		if((IsOwnerAutoAiming()) == true)
		{
			OrbitAutoAimTarget = none;
		}
	}
	//return;	
}

function UpdateOrbitEncounter(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime)
{
	local Vector aDirection;
	local float aDistance, aWeight, MaxDistance, maxDistance2, shortestDistance;

	local Vector bLocation;
	local Rotator BRotation;
	local Vector sumLocations;
	local float sumWeights, diffYaw, one80;
	local Actor aActor;
	local Vector aLocation;
	local int Index;

	// End:0x4E
	if((OrbitEncounterDisableReferences.Length > 0) || (IsOwnerAutoAiming()) == true)
	{
		PriorityInfoSet(OrbitEncounterPriorityInfo, '__ORBIT__', -99999999, 'OrbitEncounter');
		return;
	}
	// End:0x60
	if((IsOwnerManuallyAiming()) == true)
	{
		return;
	}
	MaxDistance = cfg.EncounterActiveDistance;
	maxDistance2 = MaxDistance * 2.0000000;
	one80 = 180.0000000 * 182.0444031;
	bLocation = Target.Location;
	BRotation = Target.Rotation;
	shortestDistance = cfg.EncounterInactiveDistance;
	Index = 0;
	J0x13B:

	// End:0x464 [Loop If]
	if(Index < OrbitEncounterPriorityList[0].Items.Length)
	{
		aActor = OrbitEncounterPriorityList[0].Items[Index].Target;
		// End:0x1C9
		if((IsValidTarget(aActor)) == false)
		{			
		}
		else
		{
			aLocation = Class'MegaHaloGame.HaloPawn'.static.GetRealLocationOf(aActor);
			aDirection = aLocation - bLocation;
			aDistance = VSize(aDirection);
			// End:0x248
			if(aDistance >= MaxDistance)
			{				
			}
			else
			{
				// End:0x2B8
				if(Abs(float(NormalizeRotAxis(POV.Rotation.Yaw - Rotator(aDirection).Yaw))) > (float(90) * 182.0444031))
				{					
				}
				else
				{
					// End:0x2E2
					if(aDistance < shortestDistance)
					{
						shortestDistance = aDistance;
					}
					aWeight = (MaxDistance - aDistance) / MaxDistance;
					aWeight = (maxDistance2 ** aWeight) / maxDistance2;
					diffYaw = one80 - Abs(float(NormalizeRotAxis(Rotator(aDirection).Yaw) - BRotation.Yaw));
					aWeight += ((one80 ** (diffYaw / one80)) / one80);
					sumLocations += (aLocation * aWeight);
					sumWeights += aWeight;
					// End:0x456
					if(cfg.EncounterDebugDrawEnabled == true)
					{
						aActor.DrawDebugSphere(aLocation, 64.0000000, 10, 255, 0, 0, false);
					}
				}
			}
		}
		Index++;
		// [Loop Continue]
		goto J0x13B;
	}
	// End:0x4BB
	if((OrbitEncounterPriorityInfo.Priority == -99999999) && shortestDistance == cfg.EncounterInactiveDistance)
	{		
	}
	else
	{
		// End:0x530
		if(sumWeights > 0.0000000)
		{
			PriorityInfoSet(OrbitEncounterPriorityInfo, '__ORBIT__', OrbitSettingsPriorityInfo.Priority, 'OrbitEncounter');
			OrbitEncounterAverageLocation = sumLocations / sumWeights;			
		}
		else
		{
			PriorityInfoSet(OrbitEncounterPriorityInfo, '__ORBIT__', -99999999, 'OrbitEncounter');
		}
	}
	//return;	
}

function Rotator UpdateOrbitEncounterRotation(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime, out FBlendRange oBlendRange)
{
	local TPOV oPov;

	oPov = POV;
	oPov.Rotation = UpdateOrbitManualAimRotation(oPov, Target, cfg, DeltaTime);
	// End:0x14F
	if((IsOwnerManuallyAiming()) == false)
	{
		oPov.Rotation = UpdateAutoCenterPitch(oPov, Target, cfg, DeltaTime);
		oPov.Rotation = UpdateAutoCenterPitchCollision(oPov, Target, cfg, DeltaTime);
		oPov.Rotation = UpdateOrbitEncounterAimRotation(oPov, Target, cfg, DeltaTime);
	}
	return oPov.Rotation;
	//return ReturnValue;	
}

function Rotator UpdateOrbitEncounterAimRotation(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime)
{
	local Rotator oRotation;

	oRotation = POV.Rotation;
	// End:0x81
	if(cfg.EncounterDebugDrawEnabled == true)
	{
		Target.DrawDebugSphere(OrbitEncounterAverageLocation, 96.0000000, 10, 0, 255, 0, false);
	}
	oRotation.Yaw = RInterpTo(POV.Rotation, Rotator(OrbitEncounterAverageLocation - TargetLocation), DeltaTime, 0.6000000, false).Yaw;
	return oRotation;
	//return ReturnValue;	
}

function ActivateRemoteEvent(name EventName)
{
	local array<SequenceObject> AllSeqEvents;
	local Sequence GameSeq;
	local int I;

	// End:0x13B
	if(EventName != 'None')
	{
		GameSeq = WorldInfo.GetGameSequence();
		// End:0x13B
		if(GameSeq != none)
		{
			GameSeq.FindSeqObjectsByClass(Class'Engine.SeqEvent_RemoteEvent', true, AllSeqEvents);
			I = 0;
			J0x8C:

			// End:0x13B [Loop If]
			if(I < AllSeqEvents.Length)
			{
				// End:0x12D
				if(SeqEvent_RemoteEvent(AllSeqEvents[I]).EventName == EventName)
				{
					SeqEvent_RemoteEvent(AllSeqEvents[I]).CheckActivate(PCOwner, PCOwner);
					// [Explicit Break]
					goto J0x13B;
				}
				I++;
				// [Loop Continue]
				goto J0x8C;
			}
		}
	}
	J0x13B:

	//return;	
}

function TPOV UpdateView(const TPOV POV, const Actor Target, const HaloCameraConfig cfg, float DeltaTime)
{
	local TPOV oPov;
	local PriorityInfo bestPriority;
	local FBlendRange BlendRange;

	oPov = POV;
	UpdateOrbitTargetLocation(oPov, Target, cfg, DeltaTime);
	UpdateManualAimFreshness(oPov, Target, cfg, DeltaTime);
	EncounterPriorityListUpdate(DeltaTime);
	UpdateOrbitEncounter(oPov, Target, cfg, DeltaTime);
	bestPriority = OrbitSettingsPriorityInfo;
	bestPriority = PriorityInfoMax(bestPriority, OrbitEncounterPriorityInfo);
	bestPriority = PriorityInfoMax(bestPriority, OrbitLockOnPriorityInfo);
	bestPriority = PriorityInfoMax(bestPriority, LockViewRotationPriorityInfo);
	BlendRange = FBlendRangeDefault;
	switch(bestPriority.Call)
	{
		// End:0x1D1
		case 'Orbit':
			oPov.Rotation = UpdateOrbitRotation(oPov, Target, cfg, DeltaTime, BlendRange);
			// End:0x2FD
			break;
		// End:0x234
		case 'OrbitEncounter':
			oPov.Rotation = UpdateOrbitEncounterRotation(oPov, Target, cfg, DeltaTime, BlendRange);
			// End:0x2FD
			break;
		// End:0x297
		case 'OrbitLockOn':
			oPov.Rotation = UpdateOrbitLockOnRotation(oPov, Target, cfg, DeltaTime, BlendRange);
			// End:0x2FD
			break;
		// End:0x2FA
		case 'LockView':
			oPov.Rotation = UpdateLockViewRotation(oPov, Target, cfg, DeltaTime, BlendRange);
			// End:0x2FD
			break;
		// End:0xFFFF
		default:
			break;
	}
	oPov.Rotation = RNamedBlendUpdate(RotationBlend, bestPriority.Name, oPov.Rotation, DeltaTime, BlendRange);
	bestPriority = OrbitSettingsPriorityInfo;
	bestPriority = PriorityInfoMax(bestPriority, LockViewLocationPriorityInfo);
	BlendRange = FBlendRangeDefault;
	switch(bestPriority.Call)
	{
		// End:0x44C
		case 'Orbit':
			oPov.Location = UpdateOrbitLocation(oPov, Target, cfg, DeltaTime, BlendRange);
			// End:0x4B2
			break;
		// End:0x4AF
		case 'LockView':
			oPov.Location = UpdateLockViewLocation(oPov, Target, cfg, DeltaTime, BlendRange);
			// End:0x4B2
			break;
		// End:0xFFFF
		default:
			break;
	}
	oPov.Location = VNamedBlendUpdate(LocationBlend, bestPriority.Name, oPov.Location, DeltaTime, BlendRange);
	bestPriority = OrbitSettingsPriorityInfo;
	bestPriority = PriorityInfoMax(bestPriority, LockViewFOVPriorityInfo);
	BlendRange = FBlendRangeDefault;
	switch(bestPriority.Call)
	{
		// End:0x601
		case 'Orbit':
			oPov.FOV = UpdateOrbitFOV(oPov, Target, cfg, DeltaTime, BlendRange);
			// End:0x667
			break;
		// End:0x664
		case 'LockView':
			oPov.FOV = UpdateLockViewFOV(oPov, Target, cfg, DeltaTime, BlendRange);
			// End:0x667
			break;
		// End:0xFFFF
		default:
			break;
	}
	oPov.FOV = FNamedBlendUpdate(FOVBlend, bestPriority.Name, oPov.FOV, DeltaTime, BlendRange);
	UpdateAutoAimTarget(oPov, Target, cfg, DeltaTime);
	UpdateOrbitAutoAimTarget(oPov, Target, cfg, DeltaTime);
	return oPov;
	//return ReturnValue;	
}

defaultproperties
{
	FBlendRangeDefault=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None")
	RotationBlend=(Name="None",Base=(Pitch=0,Yaw=0,Roll=0),Target=(Pitch=0,Yaw=0,Roll=0),Value=(Pitch=0,Yaw=0,Roll=0),Blend=(Base=0.0000000,Target=0.0000000,BlendTime=0.0000000,BlendFunction=VTBlend_Cubic,BlendExp=2.0000000,Time=0.0000000,Value=0.0000000),BlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None"),OnBlendOutEventName="None")
	LocationBlend=(Name="None",Base=(X=0.0000000,Y=0.0000000,Z=0.0000000),Target=(X=0.0000000,Y=0.0000000,Z=0.0000000),Value=(X=0.0000000,Y=0.0000000,Z=0.0000000),Blend=(Base=0.0000000,Target=0.0000000,BlendTime=0.0000000,BlendFunction=VTBlend_Cubic,BlendExp=2.0000000,Time=0.0000000,Value=0.0000000),BlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None"),OnBlendOutEventName="None")
	FOVBlend=(Name="None",Base=0.0000000,Target=0.0000000,Value=0.0000000,Blend=(Base=0.0000000,Target=0.0000000,BlendTime=0.0000000,BlendFunction=VTBlend_Cubic,BlendExp=2.0000000,Time=0.0000000,Value=0.0000000),BlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None"),OnBlendOutEventName="None")
	OrbitFocusOffsetBlend=(Name="None",Base=(X=0.0000000,Y=0.0000000,Z=0.0000000),Target=(X=0.0000000,Y=0.0000000,Z=0.0000000),Value=(X=0.0000000,Y=0.0000000,Z=0.0000000),Blend=(Base=0.0000000,Target=0.0000000,BlendTime=0.0000000,BlendFunction=VTBlend_Cubic,BlendExp=2.0000000,Time=0.0000000,Value=0.0000000),BlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None"),OnBlendOutEventName="None")
	OrbitDistanceBlend=(Name="None",Base=0.0000000,Target=0.0000000,Value=0.0000000,Blend=(Base=0.0000000,Target=0.0000000,BlendTime=0.0000000,BlendFunction=VTBlend_Cubic,BlendExp=2.0000000,Time=0.0000000,Value=0.0000000),BlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None"),OnBlendOutEventName="None")
	POVCache=(Location=(X=0.0000000,Y=0.0000000,Z=0.0000000),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=90.0000000)
	OrbitEncounterPriorityInfo=(Name="None",Call="None",Priority=-99999999)
	OrbitEncounterRotationBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None")
	LockViewRotationPriorityInfo=(Name="None",Call="None",Priority=-99999999)
	LockViewLocationPriorityInfo=(Name="None",Call="None",Priority=-99999999)
	LockViewFOVPriorityInfo=(Name="None",Call="None",Priority=-99999999)
	OrbitSettingsPriorityInfo=(Name="None",Call="None",Priority=-99999999)
	OrbitLockOnPriorityInfo=(Name="None",Call="None",Priority=-99999999)
	RotationTransition=(ARotation=(Pitch=0,Yaw=0,Roll=0),BRotation=(Pitch=0,Yaw=0,Roll=0),Params=(BlendTime=0.0000000,BlendFunction=VTBlend_Cubic,BlendExp=2.0000000,bLockOutgoing=false),Time=0.0000000)
	PRIORITY_BLEND_FUNCTION=VTBlend_Cubic
	TestOrbitFollowScale=1.0000000
}