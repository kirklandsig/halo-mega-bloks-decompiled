class HaloAIFlightController extends AIController;

enum EAIFlightBehaviors
{
	FB_Idle,                        // 0
	FB_Active_Patrol,               // 1
	FB_Active_Chasing,              // 2
	FB_Active_BeingChased,          // 3
	FB_Active_Following,            // 4
	FB_BarrelRoll,                  // 5
	FB_MAX                          // 6
};

enum EAIFlightThreats
{
	FT_None,                        // 0
	FT_GunFire,                     // 1
	FT_Grenade,                     // 2
	FT_GrenadeStuck,                // 3
	FT_GunFireDamage,               // 4
	FT_GrenadeDamage,               // 5
	FT_MAX                          // 6
};

enum EAIFlightSplineType
{
	ST_Linear,                      // 0
	ST_Loop,                        // 1
	ST_PingPong,                    // 2
	ST_MAX                          // 3
};

var private HaloVehicleFactory_BansheeAI VehicleFactory;
var private UTAirVehicle Vehicle;
var private HaloAIFlightController.EAIFlightBehaviors CurrentBehavior;
var private HaloAIFlightController.EAIFlightBehaviors NextBehavior;
var private HaloAIFlightController.EAIFlightThreats CurrentThreat;
var private HaloAIFlightNode CurrentFlightNode;
var private HaloPawn TargetPawn;
var private float TargetAimOffset;
var private float TargetMaxDistance;
var private float TimeOnSpline;
var private float TimeSinceLastFire;
var private bool bAtEndOfPath;
var private Vector NewPos;
var private Vector PrevPos;
var private Vector NextPos;
var private Rotator CalcRot;
var private Vector CurrentTangent;
var private Vector NextTangent;
var private float DesiredRoll;
var private float TimeSinceLastThreatCheck;

simulated function PostBeginPlay()
{
	super(Controller).PostBeginPlay();
	TargetMaxDistance *= TargetMaxDistance;
	//return;	
}

simulated function ActiveNotify(bool IsActive)
{
	// End:0x1C
	if(IsActive)
	{
		NextBehavior = 1;		
	}
	else
	{
		NextBehavior = 0;
	}
	//return;	
}

function bool GetIsActive()
{
	return (IsInState('Initialize') == false) && IsInState('Idle') == false;
	//return ReturnValue;	
}

function UpdateVehicleBehavior()
{
	// End:0x1B0
	if(int(NextBehavior) != int(CurrentBehavior))
	{
		switch(NextBehavior)
		{
			// End:0x44
			case 0:
				GotoState('Idle');
				// End:0x19D
				break;
			// End:0x6A
			case 4:
				ScriptedRoute.RouteType = 1;
			// End:0x6F
			case 1:
			// End:0x74
			case 2:
			// End:0x121
			case 3:
				// End:0xB7
				if(GetUseSpline())
				{
					PushState('SplineMove');
					Vehicle.SetPhysics(0);					
				}
				else
				{
					PushState('ScriptedRouteMove');
					Vehicle.SetPhysics(4);
				}
				// End:0x113
				if(VehicleFactory != none)
				{
					VehicleFactory.PathStarted();
				}
				SetAtEndOfPath(false);
				// End:0x19D
				break;
			// End:0x13D
			case 5:
				PushState('BarrelRoll');
				// End:0x19D
				break;
			// End:0xFFFF
			default:
				WarnInternal("Invalid NextBehavior for Vehicle.  Defaulting to Idle" $ string(NextBehavior));
				PushState('Idle');
				// End:0x19D
				break;
				break;
		}
		CurrentBehavior = NextBehavior;
	}
	//return;	
}

function UpdateVehicleTarget(optional float DeltaTime = 0.0000000)
{
	local HaloPlayerPawnController PC;
	local float DistSq;

	// End:0xCB
	if(Vehicle != none)
	{
		// End:0xCA
		foreach LocalPlayerControllers(Class'MegaHaloGame.HaloPlayerPawnController', PC)
		{
			DistSq = VSizeSq(PC.Location - Vehicle.Location);
			// End:0xC9
			if(DistSq < TargetMaxDistance)
			{
				SetTargetPawn(HaloPawn(PC.Pawn));
			}			
		}		
	}
	//return;	
}

function UpdateVehicleThreatDetection(optional float DeltaTime = 0.0000000)
{
	local HaloProjectile Projectile;
	local HaloProjectile_Grenade grenade;

	// End:0x45
	if(DeltaTime != 0.0000000)
	{
		TimeSinceLastThreatCheck += DeltaTime;
		// End:0x45
		if(TimeSinceLastThreatCheck < 1.0000000)
		{
			return;
		}
	}
	SetCurrentThreat(0);
	// End:0x123
	foreach VisibleActors(Class'MegaHaloGame.HaloProjectile', Projectile, 10000.0000000, Vehicle.Location)
	{
		grenade = HaloProjectile_Grenade(Projectile);
		// End:0x116
		if(grenade != none)
		{
			// End:0x107
			if(grenade.StickyTarget == Vehicle.Mesh)
			{
				SetCurrentThreat(3);				
			}
			else
			{
				SetCurrentThreat(2);
			}
			// End:0x122
			continue;
		}
		SetCurrentThreat(1);		
	}	
	TimeSinceLastThreatCheck = 0.0000000;
	//return;	
}

function bool SetCurrentThreat(HaloAIFlightController.EAIFlightThreats threat)
{
	local bool bThreatChanged;

	// End:0x45
	if((int(threat) == int(0)) && int(CurrentThreat) != int(0))
	{
		CurrentThreat = 0;
		bThreatChanged = true;		
	}
	else
	{
		// End:0x7F
		if(int(CurrentThreat) < int(threat))
		{
			CurrentThreat = threat;
			bThreatChanged = true;
		}
	}
	// End:0xC8
	if((bThreatChanged == true) && VehicleFactory != none)
	{
		VehicleFactory.ThreatTriggered(CurrentThreat);
	}
	return bThreatChanged;
	//return ReturnValue;	
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
	local Class<HaloDamageType> Type;

	// End:0x3F
	if((DamageType == Class'MegaHaloGame.HaloDamageType_Grenade') || DamageType == Class'MegaHaloGame.HaloDamageType_PlasmaGrenade')
	{
		SetCurrentThreat(5);		
	}
	else
	{
		Type = Class<HaloDamageType>(DamageType);
		// End:0x76
		if(Type != none)
		{
			SetCurrentThreat(4);
		}
	}
	super(Controller).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
	//return;	
}

function UpdateVehicleChaseBehavior(optional float DeltaTime = 0.0000000)
{
	local float DistSq;
	local bool bSpeedUp;
	local float interpScale;

	// End:0x173
	if(((int(CurrentBehavior) == int(2)) || int(CurrentBehavior) == int(3)) && TargetPawn != none)
	{
		// End:0x66
		if((GetChaseDistanceSq()) == 0.0000000)
		{
			NextBehavior = 1;
			return;
		}
		DistSq = GetTargetHorizontalDistanceSq();
		// End:0xC3
		if(int(CurrentBehavior) == int(2))
		{
			bSpeedUp = (DistSq > (GetChaseDistanceSq())) == true;
			interpScale = 10.0000000;			
		}
		else
		{
			bSpeedUp = (DistSq < (GetChaseDistanceSq())) == true;
			interpScale = 10.0000000;
		}
		Vehicle.AirSpeed = FInterpEaseInOut(Vehicle.AirSpeed, ((bSpeedUp) ? GetRouteFlightSpeed() : 0.0000000), DeltaTime * interpScale, 2.0000000);
	}
	//return;	
}

function UpdateVehicleFollowingBehavior(optional float DeltaTime = 0.0000000)
{
	local float DistSq, interpScale;

	// End:0x139
	if((int(CurrentBehavior) == int(4)) && TargetPawn != none)
	{
		// End:0x55
		if((GetFollowMaxDistanceSq()) <= (GetFollowMinDistanceSq()))
		{
			NextBehavior = 1;
			return;
		}
		DistSq = GetTargetHorizontalDistanceSq();
		// End:0x97
		if(DistSq < (GetFollowMinDistanceSq()))
		{
			HandleFollowMinDistance(DeltaTime);			
		}
		else
		{
			// End:0xC5
			if(DistSq > (GetFollowMaxDistanceSq()))
			{
				HandleFollowMaxDistance(DeltaTime);				
			}
			else
			{
				interpScale = 10.0000000;
				Vehicle.AirSpeed = FInterpEaseInOut(Vehicle.AirSpeed, 0.0000000, DeltaTime * interpScale, 2.0000000);
			}
		}
	}
	//return;	
}

function HandleFollowMinDistance(optional float DeltaTime = 0.0000000)
{
	local float toDistSq, fromDistSq, interpScale;
	local HaloAIFlightNode movingTo, movingAwayFrom;

	// End:0x17F
	if((Vehicle != none) && TargetPawn != none)
	{
		GetSurroundingFlightNodes(movingTo, movingAwayFrom);
		toDistSq = GetHorizontalDistanceSq(movingTo.Location, TargetPawn.Location);
		fromDistSq = GetHorizontalDistanceSq(movingAwayFrom.Location, TargetPawn.Location);
		// End:0x106
		if(fromDistSq > toDistSq)
		{
			ReverseFollowDirection();
		}
		interpScale = 10.0000000;
		Vehicle.AirSpeed = FInterpEaseInOut(Vehicle.AirSpeed, GetRouteFlightSpeed(), DeltaTime * interpScale, 2.0000000);
	}
	//return;	
}

function HandleFollowMaxDistance(optional float DeltaTime = 0.0000000)
{
	local float toDistSq, fromDistSq, interpScale;
	local HaloAIFlightNode movingTo, movingAwayFrom;

	// End:0x17F
	if((Vehicle != none) && TargetPawn != none)
	{
		GetSurroundingFlightNodes(movingTo, movingAwayFrom);
		toDistSq = GetHorizontalDistanceSq(movingTo.Location, TargetPawn.Location);
		fromDistSq = GetHorizontalDistanceSq(movingAwayFrom.Location, TargetPawn.Location);
		// End:0x106
		if(fromDistSq < toDistSq)
		{
			ReverseFollowDirection();
		}
		interpScale = 10.0000000;
		Vehicle.AirSpeed = FInterpEaseInOut(Vehicle.AirSpeed, GetRouteFlightSpeed(), DeltaTime * interpScale, 2.0000000);
	}
	//return;	
}

function ReverseFollowDirection()
{
	// End:0x4D
	if(bReverseScriptedRoute == true)
	{
		ScriptedRouteIndex = Min(ScriptedRouteIndex + 1, ScriptedRoute.RouteList.Length - 1);		
	}
	else
	{
		ScriptedRouteIndex = Max(ScriptedRouteIndex - 1, 0);
	}
	ScriptedMoveTarget = ScriptedRoute.RouteList[ScriptedRouteIndex].Actor;
	bReverseScriptedRoute = !bReverseScriptedRoute;
	//return;	
}

function GetSurroundingFlightNodes(out HaloAIFlightNode movingTo, out HaloAIFlightNode movingAwayFrom)
{
	local int awayFromIndex;

	// End:0x4D
	if(bReverseScriptedRoute == true)
	{
		awayFromIndex = Min(ScriptedRouteIndex + 1, ScriptedRoute.RouteList.Length - 1);		
	}
	else
	{
		awayFromIndex = Max(ScriptedRouteIndex - 1, 0);
	}
	movingTo = HaloAIFlightNode(ScriptedMoveTarget);
	movingAwayFrom = HaloAIFlightNode(ScriptedRoute.RouteList[awayFromIndex].Actor);
	//return;	
}

function FireVehicleWeapon(float DeltaTime)
{
	// End:0xCB
	if((GetFireRate()) > 0.0000000)
	{
		// End:0xB7
		if(TimeSinceLastFire >= (GetFireRate()))
		{
			// End:0xA5
			if(Vehicle != none)
			{
				// End:0xA5
				if(HaloVehicleWeapon(Vehicle.Weapon) != none)
				{
					HaloVehicleWeapon(Vehicle.Weapon).ProjectileFire();
				}
			}
			TimeSinceLastFire = 0.0000000;			
		}
		else
		{
			TimeSinceLastFire += DeltaTime;
		}
	}
	//return;	
}

function SetTargetPawn(HaloPawn P)
{
	TargetPawn = P;
	// End:0x36
	if(GetIfTrackTarget())
	{
		ScriptedFocus = TargetPawn;		
	}
	else
	{
		ScriptedFocus = none;
	}
	//return;	
}

function bool GetUseSpline()
{
	return ((VehicleFactory != none) ? VehicleFactory.bUseSpline : false);
	//return ReturnValue;	
}

function bool GetIfTrackTarget()
{
	// End:0x2F
	if(CurrentFlightNode != none)
	{
		return CurrentFlightNode.bTrackTarget;
	}
	WarnInternal("Attempting to retrieve Track Target when there is currently no flight node");
	return false;
	//return ReturnValue;	
}

function float GetFireRate()
{
	return ((CurrentFlightNode != none) ? CurrentFlightNode.FireRate : 2.0000000);
	//return ReturnValue;	
}

function float GetFireOffset()
{
	// End:0x2E
	if(CurrentFlightNode != none)
	{
		return CurrentFlightNode.FireOffset;
	}
	WarnInternal("Attempting to retreive FireOffset when there is no Current Flight Node");
	return 0.0000000;
	//return ReturnValue;	
}

function float GetSplineTime()
{
	// End:0x91
	if((GetUseSpline()) == true)
	{
		// End:0x3E
		if(CurrentFlightNode != none)
		{
			return CurrentFlightNode.SplineTime;
		}
		WarnInternal("Attempting to retrieve Spline Time when there is currently no flight node");
		return 9999.9902344;
	}
	WarnInternal("Attempting to retrieve Spline Time when not currently using a spline to path" @ string(CurrentFlightNode.Name));
	return 9999.9902344;
	//return ReturnValue;	
}

function float GetSplineLength()
{
	// End:0x59
	if(CurrentFlightNode != none)
	{
		return CurrentFlightNode.Connections[0].SplineComponent.GetSplineLength();
	}
	WarnInternal("Attempted to retrieve Spline Length when there is no Current Flight Node.");
	return 0.0000000;
	//return ReturnValue;	
}

function float GetRouteFlightSpeed()
{
	// End:0x98
	if((GetUseSpline()) == false)
	{
		// End:0x3E
		if(CurrentFlightNode != none)
		{
			return CurrentFlightNode.RouteFlightSpeed;
		}
		WarnInternal("Attempting to retrieve Route Flight Speed when there is currently no flight node");
		return 0.0000000;
	}
	WarnInternal("Attempting to retrieve Route Flight Speed when not currently using a route to path" @ string(CurrentFlightNode.Name));
	return 0.0000000;
	//return ReturnValue;	
}

function float GetChaseDistanceSq()
{
	// End:0x4E
	if(CurrentFlightNode != none)
	{
		return CurrentFlightNode.ChaseDistance * CurrentFlightNode.ChaseDistance;
	}
	WarnInternal("Attempting to retrieve Chase Distance when there is no Current Flight Node.");
	return 0.0000000;
	//return ReturnValue;	
}

function float GetFollowMinDistanceSq()
{
	// End:0x4E
	if(CurrentFlightNode != none)
	{
		return CurrentFlightNode.FollowMinDistance * CurrentFlightNode.FollowMinDistance;
	}
	WarnInternal("Attempting to retrieve Follow Min Distance when there is no Current Flight Node.");
	return 0.0000000;
	//return ReturnValue;	
}

function float GetFollowMaxDistanceSq()
{
	// End:0x4E
	if(CurrentFlightNode != none)
	{
		return CurrentFlightNode.FollowMaxDistance * CurrentFlightNode.FollowMaxDistance;
	}
	WarnInternal("Attempting to retrieve Follow Max Distance when there is no Current Flight Node.");
	return 0.0000000;
	//return ReturnValue;	
}

function float GetConstantSplineSpeed()
{
	// End:0x2E
	if(VehicleFactory != none)
	{
		return VehicleFactory.ConstantSplineSpeed;
	}
	WarnInternal("Attempting to retreive Constant Spline Speed when there is no Current Flight Node.");
	return 0.0000000;
	//return ReturnValue;	
}

function float GetTargetHorizontalDistanceSq()
{
	local float DistSq;
	local Vector flattenVec;

	// End:0xCB
	if((Vehicle != none) && TargetPawn != none)
	{
		flattenVec = Vehicle.Location;
		flattenVec.Z = TargetPawn.Location.Z;
		DistSq = VSizeSq(TargetPawn.Location - flattenVec);
	}
	return DistSq;
	//return ReturnValue;	
}

function float GetTargetVerticalDistanceSq()
{
	local float DistSq;
	local Vector flattenVec;

	// End:0x119
	if((Vehicle != none) && TargetPawn != none)
	{
		flattenVec = Vehicle.Location;
		flattenVec.X = TargetPawn.Location.X;
		flattenVec.Y = TargetPawn.Location.Y;
		DistSq = VSizeSq(TargetPawn.Location - flattenVec);
	}
	return DistSq;
	//return ReturnValue;	
}

function float GetTargetDistanceSq()
{
	local float DistSq;

	// End:0x6A
	if((Vehicle != none) && TargetPawn != none)
	{
		DistSq = VSizeSq(TargetPawn.Location - Vehicle.Location);
	}
	return DistSq;
	//return ReturnValue;	
}

function float GetHorizontalDistanceSq(Vector Pos1, Vector Pos2)
{
	Pos1.Z = Pos2.Z;
	return VSizeSq(Pos1 - Pos2);
	//return ReturnValue;	
}

function Pawn GetTargetPawn()
{
	return TargetPawn;
	//return ReturnValue;	
}

function SetCurrentFlightNode()
{
	local int Index;

	// End:0x16D
	if(VehicleFactory != none)
	{
		// End:0xFC
		if((GetUseSpline()) == true)
		{
			CurrentFlightNode = HaloAIFlightNode(CurrentFlightNode.Connections[0].ConnectTo);
			// End:0xEF
			if(CurrentFlightNode == none)
			{
				switch(VehicleFactory.SplineType)
				{
					// End:0xA1
					case 2:
					// End:0xBE
					case 0:
						SetAtEndOfPath(true);
						PopState();
						return;
					// End:0xEC
					case 1:
						CurrentBehavior = 0;
						NextBehavior = 1;
						GotoState('Initialize');
						// End:0xEF
						break;
					// End:0xFFFF
					default:
						break;
				}
			}
			SetCurrentSplineDetails();
		}
		else
		{
			Index = Max(ScriptedRouteIndex - 1, 0);
			CurrentFlightNode = HaloAIFlightNode(ScriptedRoute.RouteList[Index].Actor);
			SetCurrentRouteDetails();
		}
		//return;
	}
}

function SetCurrentSplineDetails()
{
	SetTargetPawn(none);
	UpdateVehicleTarget();
	//return;	
}

function SetCurrentRouteDetails()
{
	// End:0x87
	if((Vehicle != none) && CurrentFlightNode != none)
	{
		Vehicle.AirSpeed = GetRouteFlightSpeed();
		SetTargetPawn(none);
		UpdateVehicleTarget();
		NextBehavior = CurrentFlightNode.Behavior;
	}
	//return;	
}

function SetAtEndOfPath(bool atEnd)
{
	// End:0x4D
	if(atEnd && bAtEndOfPath == false)
	{
		// End:0x4D
		if(VehicleFactory != none)
		{
			VehicleFactory.PathFinished();
		}
	}
	bAtEndOfPath = atEnd;
	//return;	
}

function bool GetAtEndOfPath()
{
	return bAtEndOfPath;
	//return ReturnValue;	
}

function StartNewFlightPath()
{
	CurrentBehavior = 0;
	NextBehavior = 1;
	GotoState('Initialize');
	//return;	
}

auto state Initialize
{
	ignores ExitState;

	event EndState(name NextStateName)
	{
		ExitState();
		//return;		
	}

	function EnterState()
	{
		Vehicle = UTAirVehicle(Pawn);
		// End:0xD1
		if(Vehicle != none)
		{
			VehicleFactory = HaloVehicleFactory_BansheeAI(Vehicle.ParentFactory);
			// End:0x95
			if(VehicleFactory != none)
			{
				// End:0x88
				if((GetUseSpline()) == false)
				{
					InitRoute();					
				}
				else
				{
					InitSpline();
				}				
			}
			else
			{
				WarnInternal("This vehicle was not created from a VehicleAI factory");
			}			
		}
		else
		{
			WarnInternal("The pawn this controller is possessing is not a UTAirVehicle" $ string(Pawn));
		}
		//return;		
	}

	function bool InitRoute()
	{
		ScriptedRoute = VehicleFactory.AIRoute;
		bReverseScriptedRoute = false;
		ScriptedRouteIndex = 0;
		ScriptedFocus = none;
		ScriptedMoveTarget = none;
		SetAtEndOfPath(false);
		return true;
		//return ReturnValue;		
	}

	function bool InitSpline()
	{
		local HaloAIFlightNode Node;

		CurrentFlightNode = HaloAIFlightNode(VehicleFactory.SplineStart);
		// End:0x8C
		if(CurrentFlightNode == none)
		{
			WarnInternal("Attempting to use spline, but Spline Start in the factory is not valid");
			return false;
		}
		SetAtEndOfPath(false);
		// End:0x1F2
		if((GetConstantSplineSpeed()) != 0.0000000)
		{
			CurrentFlightNode.SplineTime = (GetSplineLength()) / (GetConstantSplineSpeed());
			Node = HaloAIFlightNode(CurrentFlightNode.Connections[0].ConnectTo);
			J0x126:

			// End:0x1F2 [Loop If]
			if(Node != none)
			{
				Node.SplineTime = Node.Connections[0].SplineComponent.GetSplineLength() / (GetConstantSplineSpeed());
				Node = HaloAIFlightNode(Node.Connections[0].ConnectTo);
				// [Loop Continue]
				goto J0x126;
			}
		}
		return true;
		//return ReturnValue;		
	}
Begin:

	EnterState();
	GotoState('Idle');
	stop;				
}

state Idle
{
	ignores EnterState;
Begin:

	EnterState();
	goto 'Waiting';
Waiting:


	UpdateVehicleBehavior();
	UpdateVehicleThreatDetection();
	Sleep(1.0000000);
	goto 'Waiting';
	stop;					
}

state ScriptedRouteMove
{
	event PoppedState()
	{
		SetAtEndOfPath(true);
		//return;		
	}
	stop;	
}

state ScriptedMove
{
	ignores EnterState;

	function Tick(float DeltaTime)
	{
		// End:0x12A
		if((GetIfTrackTarget()) == true)
		{
			NewPos = ScriptedFocus.Location - Vehicle.Location;
			CalcRot = Rotator(NewPos);
			CalcRot.Yaw = Vehicle.Rotation.Yaw;
			CalcRot.Roll = Vehicle.Rotation.Roll;
			Vehicle.SetRotation(CalcRot);
		}
		FireVehicleWeapon(DeltaTime);
		UpdateVehicleThreatDetection(DeltaTime);
		UpdateVehicleChaseBehavior(DeltaTime);
		UpdateVehicleFollowingBehavior(DeltaTime);
		UpdateVehicleBehavior();
		//return;		
	}
Begin:

	EnterState();
	SetCurrentFlightNode();
	J0x14:

	// End:0x7E [Loop If]
	if(((Pawn != none) && ScriptedMoveTarget != none) && !Pawn.ReachedDestination(ScriptedMoveTarget))
	{
		MoveToward(ScriptedMoveTarget, ScriptedFocus);
		// [Loop Continue]
		goto J0x14;
	}
	PopState();
	stop;			
}

state SplineMove
{
	ignores EnterState;

	function Tick(float DeltaTime)
	{
		local Vector LookAt;
		local float splineDist, splinePreCogDist, Roll, DotP;
		local Vector rightVec, upVec;
		local bool bNextSpline;
		local float timeOver;
		local HaloAIFlightNode nextNode;

		upVec.X = 0.0000000;
		upVec.Y = 0.0000000;
		upVec.Z = 1.0000000;
		super(Actor).Tick(DeltaTime);
		TimeOnSpline += DeltaTime;
		// End:0x9AC
		if(CurrentFlightNode != none)
		{
			splineDist = (TimeOnSpline / (GetSplineTime())) * (GetSplineLength());
			splinePreCogDist = TimeOnSpline + ((GetSplineTime()) * 0.1300000);
			bNextSpline = (splinePreCogDist > (GetSplineTime())) == true;
			timeOver = splinePreCogDist - (GetSplineTime());
			splinePreCogDist = splinePreCogDist / (GetSplineTime());
			splinePreCogDist = splinePreCogDist * (GetSplineLength());
			// End:0x262
			if(bNextSpline && timeOver > 0.0000000)
			{
				nextNode = HaloAIFlightNode(CurrentFlightNode.Connections[0].ConnectTo);
				// End:0x262
				if(nextNode != none)
				{
					splinePreCogDist = (timeOver / nextNode.SplineTime) * nextNode.Connections[0].SplineComponent.GetSplineLength();
				}
			}
			NewPos = CurrentFlightNode.Connections[0].SplineComponent.GetLocationAtDistanceAlongSpline(splineDist);
			// End:0x33B
			if(bNextSpline && nextNode != none)
			{
				NextPos = nextNode.Connections[0].SplineComponent.GetLocationAtDistanceAlongSpline(splinePreCogDist);				
			}
			else
			{
				NextPos = CurrentFlightNode.Connections[0].SplineComponent.GetLocationAtDistanceAlongSpline(splinePreCogDist);
			}
			SetLocation(NewPos);
			Vehicle.SetLocation(NewPos);
			// End:0x407
			if(TimeOnSpline >= (GetSplineTime()))
			{
				TimeOnSpline = TimeOnSpline - (GetSplineTime());
				SetCurrentFlightNode();
				return;
			}
			// End:0x623
			if((GetIfTrackTarget()) == true)
			{
				LookAt = TargetPawn.Location - Vehicle.Location;
				CalcRot = RInterpTo(Vehicle.Rotation, Rotator(LookAt), DeltaTime, 3.0000000);
				Vehicle.SetRotation(CalcRot);
				SetRotation(CalcRot);
				DotP = Normal(LookAt) Dot Normal(NextPos - NewPos);
				DesiredRoll = DotP * 4800.0000000;
				Roll = FInterpTo(float(Vehicle.Rotation.Roll), DesiredRoll, DeltaTime, Abs(55.0000000 * DotP) + 25.0000000);
				Vehicle.SetRotation(MakeRotator(Vehicle.Rotation.Pitch, Vehicle.Rotation.Yaw, int(Roll)));				
			}
			else
			{
				LookAt = NextPos - NewPos;
				Vehicle.SetRotation(RInterpTo(Vehicle.Rotation, Rotator(LookAt), DeltaTime, 3.0000000));
				CurrentTangent = CurrentFlightNode.Connections[0].SplineComponent.GetTangentAtDistanceAlongSpline(splineDist);
				// End:0x774
				if(bNextSpline && nextNode != none)
				{
					NextTangent = nextNode.Connections[0].SplineComponent.GetTangentAtDistanceAlongSpline(splinePreCogDist);					
				}
				else
				{
					NextTangent = CurrentFlightNode.Connections[0].SplineComponent.GetTangentAtDistanceAlongSpline(splinePreCogDist);
				}
				CurrentTangent.Z = 0.0000000;
				NextTangent.Z = 0.0000000;
				CurrentTangent = Normal(CurrentTangent);
				NextTangent = Normal(NextTangent);
				rightVec = upVec Cross CurrentTangent;
				rightVec = Normal(rightVec);
				DotP = rightVec Dot NextTangent;
				DesiredRoll = DotP * float(15000);
				Roll = FInterpTo(float(Vehicle.Rotation.Roll), DesiredRoll, DeltaTime, Abs(55.0000000 * DotP) + 25.0000000);
				Vehicle.SetRotation(MakeRotator(Vehicle.Rotation.Pitch, Vehicle.Rotation.Yaw, int(Roll)));
			}
		}
		FireVehicleWeapon(DeltaTime);
		UpdateVehicleThreatDetection(DeltaTime);
		UpdateVehicleBehavior();
		//return;		
	}
Begin:

	EnterState();
	stop;		
}

state BarrelRoll
{
	ignores EnterState;
Begin:

	EnterState();
	PopState();
	stop;			
}

defaultproperties
{
	TargetMaxDistance=50000.0000000
	bForceMaxMoveTowardPawnTargetTime=true
	MaxMoveTowardPawnTargetTime=0.1000000
}