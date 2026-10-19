class HaloCameraConfig extends Actor
	config(Camera)
	notplaceable;

enum ELocationMaskFunction
{
	LMF_Angular,                    // 0
	LMF_Distance,                   // 1
	LMF_MAX                         // 2
};

struct FBlendDistance
{
	var float Time;
	var float Distance;

	structdefaultproperties
	{
		Time=1.5000000
		Distance=0.0000000
	}
};

struct FBlendRange
{
	var FBlendDistance Min;
	var FBlendDistance Max;
	var name OnBlendInEventName;
	var name OnBlendOutEventName;

	structdefaultproperties
	{
		Min=(Time=1.5000000,Distance=0.0000000)
		Max=(Time=1.5000000,Distance=0.0000000)
		OnBlendInEventName="None"
		OnBlendOutEventName="None"
	}
};

struct LockViewStruct
{
	var name Name;
	var array<Actor> Target;
	var bool LockRotation;
	var bool LockLocation;
	var bool LockFOV;
	var Rotator Rotation;
	var Vector Location;
	var float FOV;
	var FBlendRange RotationBlendRange;
	var FBlendRange LocationBlendRange;
	var FBlendRange FOVBlendRange;
	var int Priority;

	structdefaultproperties
	{
		Name="None"
		Target=none
		LockRotation=false
		LockLocation=false
		LockFOV=false
		Rotation=(Pitch=0,Yaw=0,Roll=0)
		Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		FOV=90.0000000
		RotationBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None")
		LocationBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None")
		FOVBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None")
		Priority=0
	}
};

struct OrbitLockOnStruct
{
	var name Name;
	var Actor Target;
	var bool ReverseDirection;
	var bool EnablePitch;
	var FBlendRange RotationBlendRange;
	var int Priority;
	var bool EnableDuringPlayerTargetDesignatorMode;

	structdefaultproperties
	{
		Name="None"
		Target=none
		ReverseDirection=false
		EnablePitch=false
		RotationBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None")
		Priority=0
		EnableDuringPlayerTargetDesignatorMode=false
	}
};

struct OrbitStruct
{
	var name Name;
	var float Distance;
	var float Pitch;
	var float FOV;
	var float AimYawSpeed;
	var float AimPitchSpeed;
	var Vector FocusOffset;
	var FBlendRange RotationBlendRange;
	var FBlendRange LocationBlendRange;
	var FBlendRange FOVBlendRange;
	var int Priority;

	structdefaultproperties
	{
		Name="None"
		Distance=900.0000000
		Pitch=10.0000000
		FOV=90.0000000
		AimYawSpeed=120.0000000
		AimPitchSpeed=60.0000000
		FocusOffset=(X=150.0000000,Y=0.0000000,Z=0.0000000)
		RotationBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None")
		LocationBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None")
		FOVBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None")
		Priority=-10
	}
};

struct LocationMaskStruct
{
	var name Name;
	var HaloCameraConfig.ELocationMaskFunction MaskFunction;
	var float Width;
	var float Height;
	var float Depth;
	var int Priority;

	structdefaultproperties
	{
		Name="None"
		MaskFunction=LMF_Angular
		Width=0.0000000
		Height=0.0000000
		Depth=0.0000000
		Priority=0
	}
};

struct MagnetAimStruct
{
	var name Name;
	var float Angle;
	var float Range;
	var float NearFalloff;
	var float FarFalloff;

	structdefaultproperties
	{
		Name="None"
		Angle=0.0000000
		Range=0.0000000
		NearFalloff=0.0000000
		FarFalloff=0.0000000
	}
};

var config bool AutoAimEnabled;
var config bool AutoCenterPitchEnabled;
var config bool AutoCenterPitchCollideEnabled;
var config bool AutoCenterYawEnabled;
var config bool AutoCenterYawCollideEnabled;
var config bool EncounterDebugDrawEnabled;
var config bool OrbitAimEnabled;
var config bool OrbitLockOnEnabled;
var config float AutoAimExtendedRange;
var config float AutoCenterPitchLowCeilingDegrees;
var config float AutoCenterPitchSpeed;
var config float AutoCenterPitchCollideSpeed;
var config float AutoCenterYawTargetSpeed;
var config float AutoCenterYawTargetAngle;
var config float AutoCenterYawCollideAngle;
var config float AutoCenterYawCollideSpeed;
var config float AutoCenterYawCollideAccelSpeed;
var config float AutoCenterYawCollideDecelSpeed;
var config float AutoCenterYawCollideLookAheadDistance;
var config float AutoCenterYawCollideLookAheadHeight;
var config float EncounterInactiveDistance;
var config float EncounterActiveDistance;
var config float CollideExtent;
var config float CollideMinDistance;
var config float CollideInRate;
var config float CollideOutRate;
var config float OrbitAimFreshTime;
var config float OrbitAimMultiplier;
var config float OrbitAimMultiplierAngleMax;
var config float OrbitAimMultiplierAngleMin;
var config float OrbitLockOnRate;
var config float OrbitPitchHighLimit;
var config float OrbitPitchLowLimit;
var config array<config MagnetAimStruct> MagnetAimArray;
var config name MagnetAimDefaultName;
var config float TargetFollowSpeed;
var config array<config OrbitStruct> OrbitArray;
var config name OrbitDefaultName;

defaultproperties
{
	AutoAimEnabled=true
	AutoCenterPitchEnabled=true
	AutoCenterPitchCollideEnabled=true
	AutoCenterYawEnabled=true
	AutoCenterYawCollideEnabled=true
	OrbitAimEnabled=true
	OrbitLockOnEnabled=true
	AutoAimExtendedRange=10000.0000000
	AutoCenterPitchLowCeilingDegrees=6.0000000
	AutoCenterPitchSpeed=16.0000000
	AutoCenterPitchCollideSpeed=45.0000000
	AutoCenterYawTargetSpeed=360.0000000
	AutoCenterYawTargetAngle=30.0000000
	AutoCenterYawCollideAngle=180.0000000
	AutoCenterYawCollideSpeed=130.0000000
	AutoCenterYawCollideAccelSpeed=28.0000000
	AutoCenterYawCollideDecelSpeed=8.0000000
	AutoCenterYawCollideLookAheadDistance=100.0000000
	EncounterInactiveDistance=2000.0000000
	EncounterActiveDistance=6000.0000000
	CollideExtent=40.0000000
	CollideMinDistance=80.0000000
	CollideInRate=12.0000000
	CollideOutRate=2.0000000
	OrbitAimFreshTime=1.5000000
	OrbitAimMultiplier=2.0000000
	OrbitAimMultiplierAngleMax=120.0000000
	OrbitAimMultiplierAngleMin=20.0000000
	OrbitLockOnRate=6.0000000
	OrbitPitchHighLimit=45.0000000
	OrbitPitchLowLimit=55.0000000
	MagnetAimArray[0]=(Name="Default",Angle=40.0000000,Range=3500.0000000,NearFalloff=300.0000000,FarFalloff=300.0000000)
	MagnetAimArray[1]=(Name="HaloWeapon_AssaultRifle",Angle=40.0000000,Range=2300.0000000,NearFalloff=300.0000000,FarFalloff=300.0000000)
	MagnetAimArray[2]=(Name="HaloWeapon_BattleRifle",Angle=40.0000000,Range=3500.0000000,NearFalloff=300.0000000,FarFalloff=300.0000000)
	MagnetAimArray[3]=(Name="HaloWeapon_Shotgun",Angle=40.0000000,Range=1800.0000000,NearFalloff=300.0000000,FarFalloff=300.0000000)
	MagnetAimArray[4]=(Name="HaloWeapon_Pistol",Angle=40.0000000,Range=3500.0000000,NearFalloff=300.0000000,FarFalloff=300.0000000)
	MagnetAimArray[5]=(Name="HaloWeapon_StormRifle",Angle=40.0000000,Range=2300.0000000,NearFalloff=300.0000000,FarFalloff=300.0000000)
	MagnetAimArray[6]=(Name="HaloWeapon_Needler",Angle=40.0000000,Range=2300.0000000,NearFalloff=300.0000000,FarFalloff=300.0000000)
	MagnetAimDefaultName="Default"
	TargetFollowSpeed=15.0000000
	OrbitArray[0]=(Name="Default",Distance=600.0000000,Pitch=5.0000000,FOV=90.0000000,AimYawSpeed=130.0000000,AimPitchSpeed=60.0000000,FocusOffset=(X=180.0000000,Y=0.0000000,Z=0.0000000),RotationBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None"),LocationBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None"),FOVBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None"),Priority=-10)
	OrbitArray[1]=(Name="HaloWeapon_TargetDesignator",Distance=500.0000000,Pitch=5.0000000,FOV=90.0000000,AimYawSpeed=115.0000000,AimPitchSpeed=60.0000000,FocusOffset=(X=200.0000000,Y=50.0000000,Z=0.0000000),RotationBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None"),LocationBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None"),FOVBlendRange=(Min=(Time=1.5000000,Distance=0.0000000),Max=(Time=1.5000000,Distance=0.0000000),OnBlendInEventName="None",OnBlendOutEventName="None"),Priority=-10)
	OrbitDefaultName="Default"
	CollisionType=COLLIDE_CustomDefault
}