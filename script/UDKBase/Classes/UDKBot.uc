class UDKBot extends GwNavAIController
	native;

struct native EnemyPosition
{
	var Vector Position;
	var Vector Velocity;
	var float Time;

	structdefaultproperties
	{
		Position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		Velocity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		Time=0.0000000
	}
};

var UDKSquadAI Squad;
var export editinline UDKAIDecisionComponent DecisionComponent;
var Actor TemporaryFocus;
var bool bExecutingWhatToDoNext;
var bool bScriptSpecialJumpCost;
var bool bForceRefreshRoute;
var bool bTargetAlternateLoc;
var bool bEnemyInfoValid;
var bool bEnemyIsVisible;
var bool bLeadTarget;
var bool bJumpOverWall;
var bool bPlannedJump;
var bool bInDodgeMove;
var bool bEnemyAcquired;
var bool bNeedDelayedLeaveVehicle;
var bool bAllowRouteReuse;
var bool bUsingSquadRoute;
var bool bUsePreviousSquadRoute;
var byte ScriptedFireMode;
var float EnemyVisibilityTime;
var Pawn VisibleEnemy;
var Vehicle LastBlockingVehicle;
var Pawn CurrentlyTrackedEnemy;
var array<EnemyPosition> SavedPositions;
var Vector ImpactVelocity;
var int AcquisitionYawRate;
var float HearingThreshold;
var float RespawnPredictionTime;
var float WarningDelay;
var Projectile WarningProjectile;
var Vector MonitorStartLoc;
var Pawn MonitoredPawn;
var float MonitorMaxDistSq;
var Vector LastSeenPos;
var Vector LastSeeingPos;
var float LastSeenTime;
var float TrackingReactionTime;
var float BaseTrackingReactionTime;
var Vector TrackedVelocity;
var NavigationPoint SquadRouteGoal;
var Pawn BlockedAimTarget;
var float LastIterativeCheck;
var float AimUpdateFrequency;
var float LastAimUpdateTime;
var float ErrorUpdateFrequency;
var float LastErrorUpdateTime;
var float CurrentAimError;
var float DodgeLandZ;
var Actor FearSpots[2];
var float DodgeToGoalPct;
var float MultiJumpZ;

function Actor FaceActor(float StrafingModifier)
{
	//return ReturnValue;	
}

protected event ExecuteWhatToDoNext()
{
	//return;	
}

event ReceiveRunOverWarning(UDKVehicle V, float projSpeed, Vector VehicleDir)
{
	//return;	
}

// Export UUDKBot::execWaitToSeeEnemy(FFrame&, void* const)
native final latent function WaitToSeeEnemy();

// Export UUDKBot::execLatentWhatToDoNext(FFrame&, void* const)
native final latent function LatentWhatToDoNext();

// Export UUDKBot::execCanMakePathTo(FFrame&, void* const)
native final function bool CanMakePathTo(Actor A);

// Export UUDKBot::execFindBestInventoryPath(FFrame&, void* const)
native final function Actor FindBestInventoryPath(out float MinWeight);

// Export UUDKBot::execFindPathToSquadRoute(FFrame&, void* const)
native final function Actor FindPathToSquadRoute(optional bool bWeightDetours);

// Export UUDKBot::execBuildSquadRoute(FFrame&, void* const)
native final function BuildSquadRoute();

// Export UUDKBot::execFindBestSuperPickup(FFrame&, void* const)
native function Actor FindBestSuperPickup(float MaxDist);

event WhatToDoNext()
{
	//return;	
}

event MonitoredPawnAlert()
{
	//return;	
}

event TimeDJReset()
{
	//return;	
}

event MayDodgeToMoveTarget()
{
	//return;	
}

event bool SpecialJumpCost(float RequiredJumpZ, out float Cost)
{
	//return ReturnValue;	
}

event float SuperDesireability(PickupFactory P)
{
	//return ReturnValue;	
}

event float AdjustAimError(float TargetDist, bool bInstantProj)
{
	//return ReturnValue;	
}

event MissedDodge()
{
	//return;	
}

event DelayedWarning()
{
	//return;	
}

event DelayedLeaveVehicle()
{
	//return;	
}

defaultproperties
{
	// Reference: UDKAIDecisionComponent'UDKBase.Default__UDKBot.TheDecider'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'TheDecider'
	begin object name="TheDecider" class=UDKBase.UDKAIDecisionComponent
	end object
	DecisionComponent=TheDecider
	bLeadTarget=true
	bAllowRouteReuse=true
	bUsingSquadRoute=true
	AcquisitionYawRate=20000
	HearingThreshold=2800.0000000
	TrackingReactionTime=0.2500000
	BaseTrackingReactionTime=0.2500000
	LastIterativeCheck=1.0000000
	AimUpdateFrequency=0.2000000
	ErrorUpdateFrequency=0.4500000
	Components[0]=TheDecider
}