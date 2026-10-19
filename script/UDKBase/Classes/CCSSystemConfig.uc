class CCSSystemConfig extends Object
	native;

enum ECCSTargetSelectionConfig
{
	CCSTargetEnemy,                 // 0
	CCSTargetPlayer,                // 1
	CCSTargetPlayerOrEnemy,         // 2
	CCSTargetObjective,             // 3
	ECCSTargetSelectionConfig_MAX   // 4
};

enum ECCSMovementConfig
{
	CCSMovementUnreal,              // 0
	CCSMovementGwNav,               // 1
	ECCSMovementConfig_MAX          // 2
};

struct native CCSSystemConfigData
{
	var float MaxAwareRadius;
	var float MaxSightRadius;
	var float MaxBehindSightRadius;
	var float MaxHearingRadius;
	var float VisionCone;
	var float PassiveObjectiveWeight;
	var float PassiveSecondaryWeight;
	var float AggressiveMobileWeight;
	var float AggressiveStationaryWeight;
	var float CoverQueryRadius;
	var CCSSystemConfig.ECCSTargetSelectionConfig TargetSelection;
	var CCSSystemConfig.ECCSMovementConfig Movement;

	structdefaultproperties
	{
		MaxAwareRadius=10000.0000000
		MaxSightRadius=4300.0000000
		MaxBehindSightRadius=400.0000000
		MaxHearingRadius=4300.0000000
		VisionCone=180.0000000
		PassiveObjectiveWeight=-1.0000000
		PassiveSecondaryWeight=-1.0000000
		AggressiveMobileWeight=-1.0000000
		AggressiveStationaryWeight=-1.0000000
		CoverQueryRadius=5000.0000000
		TargetSelection=CCSTargetPlayer
		Movement=CCSMovementGwNav
	}
};
