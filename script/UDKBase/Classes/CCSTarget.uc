class CCSTarget extends Object
	native;

enum EAITargetType
{
	AITargetType_NONE,              // 0
	AITargetType_PassiveObjective,  // 1
	AITargetType_PassiveSecondary,  // 2
	AITargetType_AggressiveMobile,  // 3
	AITargetType_AggressiveStationary,// 4
	AITargetType_MAX                // 5
};

struct native CCSTargetData
{
	var Pawn Pawn;
	var Actor Actor;
	var CCSTarget.EAITargetType AITargetType;
	var Vector Position;
	var Vector LKP;
	var float LKPAge;
	var float Range2D;
	var bool CanShoot;
	var bool ClearOfFriendlies;
	var bool IsAware;
	var bool IsFiring;
	var bool IsVisible;

	structdefaultproperties
	{
		Pawn=none
		Actor=none
		AITargetType=EAITargetType.AITargetType_NONE
		Position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		LKP=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		LKPAge=0.0000000
		Range2D=0.0000000
		CanShoot=false
		ClearOfFriendlies=false
		IsAware=false
		IsFiring=false
		IsVisible=false
	}
};
