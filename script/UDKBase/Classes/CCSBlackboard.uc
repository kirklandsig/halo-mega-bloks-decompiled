class CCSBlackboard extends GripBlackboard
	native
	dependson(CCSCover, CCSTarget);

enum CCSMoveCmd
{
	MOVE_CMD_NONE,                  // 0
	MOVE_CMD_POS,                   // 1
	MOVE_CMD_MAX                    // 2
};

enum EThreatType
{
	THREAT_NONE,                    // 0
	THREAT_GRENADE,                 // 1
	THREAT_ROADKILL,                // 2
	THREAT_OUTAMYWAY,               // 3
	THREAT_MELEE,                   // 4
	THREAT_MAX                      // 5
};

enum EEventType
{
	HALO_EVENT_NONE,                // 0
	HALO_EVENT_DAMAGED,             // 1
	HALO_EVENT_DEATH,               // 2
	HALO_EVENT_ENTER_SLOW_TRAP,     // 3
	HALO_EVENT_EXIT_SLOW_TRAP,      // 4
	HALO_EVENT_ROOT_MOTION_COLLISION,// 5
	HALO_EVENT_MAX                  // 6
};

struct native CCSMoveCmdData
{
	var CCSBlackboard.CCSMoveCmd MoveCmd;
	var Vector Position;

	structdefaultproperties
	{
		MoveCmd=MOVE_CMD_NONE
		Position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
	}
};

// Export UCCSBlackboard::execGetHealth(FFrame&, void* const)
native function int GetHealth();

// Export UCCSBlackboard::execSetHealth(FFrame&, void* const)
native function SetHealth(int Health);

// Export UCCSBlackboard::execGetCovers(FFrame&, void* const)
native function GetCovers(out array<CCSCoverData> Covers);

// Export UCCSBlackboard::execGetCurrentTarget(FFrame&, void* const)
native function CCSTargetData GetCurrentTarget();

// Export UCCSBlackboard::execSetCurrentTether(FFrame&, void* const)
native function SetCurrentTether(Actor newTether);

// Export UCCSBlackboard::execGetCurrentTether(FFrame&, void* const)
native function Vector GetCurrentTether();

// Export UCCSBlackboard::execGetTargets(FFrame&, void* const)
native function GetTargets(out array<CCSTargetData> Targets);

// Export UCCSBlackboard::execGetMoveCommand(FFrame&, void* const)
native function CCSMoveCmdData GetMoveCommand();

// Export UCCSBlackboard::execClearMoveCommand(FFrame&, void* const)
native function ClearMoveCommand();

// Export UCCSBlackboard::execFlagThreatLocationAsUsed(FFrame&, void* const)
native function FlagThreatLocationAsUsed();

// Export UCCSBlackboard::execFlagThreatDirectionAsUsed(FFrame&, void* const)
native function FlagThreatDirectionAsUsed();

// Export UCCSBlackboard::execGetThreatLocation(FFrame&, void* const)
native function Vector GetThreatLocation();

// Export UCCSBlackboard::execGetThreatDirection(FFrame&, void* const)
native function Vector GetThreatDirection();

// Export UCCSBlackboard::execGetThreatType(FFrame&, void* const)
native function CCSBlackboard.EThreatType GetThreatType();

// Export UCCSBlackboard::execSetHeatGenerated(FFrame&, void* const)
native function SetHeatGenerated(float heat);

// Export UCCSBlackboard::execGetHeatGenerated(FFrame&, void* const)
native function float GetHeatGenerated();

// Export UCCSBlackboard::execFlagHeatGeneratedAsUsed(FFrame&, void* const)
native function FlagHeatGeneratedAsUsed();

// Export UCCSBlackboard::execGetClosestVisibleEnemy(FFrame&, void* const)
native function CCSTargetData GetClosestVisibleEnemy();

// Export UCCSBlackboard::execFlagHealthAsUsed(FFrame&, void* const)
native function FlagHealthAsUsed();

// Export UCCSBlackboard::execFlagCoversAsUsed(FFrame&, void* const)
native function FlagCoversAsUsed();

// Export UCCSBlackboard::execFlagTargetsAsUsed(FFrame&, void* const)
native function FlagTargetsAsUsed();

// Export UCCSBlackboard::execFlagTetherAsUsed(FFrame&, void* const)
native function FlagTetherAsUsed();

// Export UCCSBlackboard::execFlagClosestVisibleEnemyAsUsed(FFrame&, void* const)
native function FlagClosestVisibleEnemyAsUsed();
