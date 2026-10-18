class GameCrowdDestination extends GameCrowdInteractionPoint
	native
	placeable
	implements(GameCrowdSpawnInterface,EditorLinkSelectionInterface);

var private native const noexport Pointer VfTable_IEditorLinkSelectionInterface;
var bool bKillWhenReached;
var bool bAllowAsPreviousDestination;
var bool bAvoidWhenPanicked;
var bool bSkipBehaviorIfPanicked;
var bool bFleeDestination;
var bool bMustReachExactly;
var bool bHasRestrictions;
var bool bAllowsSpawning;
var bool bAllowCloudSpawning;
var bool bAllowVisibleSpawning;
var bool bLineSpawner;
var bool bSpawnAtEdge;
var bool bSoftPerimeter;
var bool bIsVisible;
var bool bWillBeVisible;
var bool bCanSpawnHereNow;
var bool bIsBeyondSpawnDistance;
var bool bAdjacentToVisibleNode;
var bool bHasNavigationMesh;
var duplicatetransient array<GameCrowdDestination> NextDestinations;
var duplicatetransient GameCrowdDestinationQueuePoint QueueHead;
var int Capacity;
var float Frequency;
var private int CustomerCount;
var array< Class<GameCrowdAgent> > SupportedAgentClasses;
var array<Object> SupportedArchetypes;
var array< Class<GameCrowdAgent> > RestrictedAgentClasses;
var array<Object> RestrictedArchetypes;
var float ExactReachTolerance;
var name InteractionTag;
var float InteractionDelay;
var array<BehaviorEntry> ReachedBehaviors;
var GameCrowdAgent AgentEnRoute;
var float Priority;
var float LastSpawnTime;
var transient GameCrowdPopulationManager MyPopMgr;

// Export UGameCrowdDestination::execReachedByAgent(FFrame&, void* const)
native simulated function bool ReachedByAgent(GameCrowdAgent Agent, Vector TestPosition, bool bTestExactly);

simulated function PostBeginPlay()
{
	local int I;
	local GameCrowdPopulationManager PopMgr;

	super(Actor).PostBeginPlay();
	bHasRestrictions = (((SupportedAgentClasses.Length > 0) || SupportedArchetypes.Length > 0) || RestrictedAgentClasses.Length > 0) || RestrictedArchetypes.Length > 0;
	// End:0x82
	if((QueueHead != none) || bKillWhenReached)
	{
		bAllowsSpawning = false;
	}
	I = 0;
	J0x8D:

	// End:0x143 [Loop If]
	if(I < ReachedBehaviors.Length)
	{
		// End:0x135
		if(ReachedBehaviors[I].BehaviorArchetype == none)
		{
			WarnInternal((string(self) $ " missing BehaviorArchetype at ReachedBehavior ") $ string(I));
			ReachedBehaviors.Remove(I, 1);
			I--;
		}
		I++;
		// [Loop Continue]
		goto J0x8D;
	}
	PopMgr = GameCrowdPopulationManager(WorldInfo.PopulationManager);
	// End:0x1A3
	if(PopMgr != none)
	{
		PopMgr.AddSpawnPoint(self);
	}
	//return;	
}

simulated function Destroyed()
{
	super(Actor).Destroyed();
	// End:0x39
	if(MyPopMgr != none)
	{
		MyPopMgr.RemoveSpawnPoint(self);
	}
	//return;	
}

simulated event ReachedDestination(GameCrowdAgent Agent)
{
	local int I, J;
	local SeqEvent_CrowdAgentReachedDestination ReachedEvent;
	local bool bEventActivated;

	I = 0;
	J0x0B:

	// End:0x154 [Loop If]
	if(I < GeneratedEvents.Length)
	{
		ReachedEvent = SeqEvent_CrowdAgentReachedDestination(GeneratedEvents[I]);
		J = 0;
		J0x54:

		// End:0x10C [Loop If]
		if(J < ReachedEvent.OutputLinks[0].Links.Length)
		{
			ReachedEvent.OutputLinks[0].Links[J].LinkedOp.bActive = false;
			J++;
			// [Loop Continue]
			goto J0x54;
		}
		bEventActivated = ReachedEvent.CheckActivate(self, Agent);
		// [Explicit Break]
		goto J0x154;
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	J0x154:

	// End:0x1B5
	if(bKillWhenReached)
	{
		DecrementCustomerCount(Agent);
		Agent.CurrentDestination = none;
		Agent.KillAgent();
		return;
	}
	// End:0x2B4
	if(InteractionTag != 'None')
	{
		I = Agent.RecentInteractions.Add(1);
		Agent.RecentInteractions[I].InteractionTag = InteractionTag;
		// End:0x2B4
		if(InteractionDelay > 0.0000000)
		{
			Agent.RecentInteractions[I].InteractionDelay = WorldInfo.TimeSeconds + InteractionDelay;
		}
	}
	// End:0x3A0
	if((Agent.BehaviorDestination != self) && (Agent.CurrentBehavior == none) || Agent.CurrentBehavior.AllowBehaviorAt(self))
	{
		// End:0x371
		if(ReachedBehaviors.Length > 0)
		{
			Agent.PickBehaviorFrom(ReachedBehaviors);
		}
		// End:0x3A0
		if(ReachedEvent != none)
		{
			Agent.BehaviorDestination = self;
		}
	}
	// End:0x4BA
	if(bEventActivated! && NextDestinations.Length > 0)
	{
		PickNewDestinationFor(Agent, false);
		// End:0x4BA
		if(Agent.CurrentDestination == none)
		{
			// End:0x4A6
			if((Agent.NotVisibleLifeSpan > 0.0000000) && (WorldInfo.TimeSeconds - Agent.LastRenderTime) > Agent.NotVisibleLifeSpan)
			{
				Agent.KillAgent();				
			}
			else
			{
				PickNewDestinationFor(Agent, true);
			}
		}
	}
	// End:0x530
	if(Agent.MyGroup != none)
	{
		Agent.MyGroup.UpdateDestinations(Agent.CurrentDestination);
	}
	//return;	
}

simulated function PickNewDestinationFor(GameCrowdAgent Agent, bool bIgnoreRestrictions)
{
	local int I;
	local float DestinationFrequencySum, DestinationPickValue;
	local array<GameCrowdDestination> DestOptions;

	DecrementCustomerCount(Agent);
	Agent.CurrentDestination = none;
	Agent.BehaviorDestination = none;
	I = 0;
	J0x5E:

	// End:0x201 [Loop If]
	if(I < NextDestinations.Length)
	{
		// End:0x1F3
		if(((NextDestinations[I] != none) && NextDestinations[I].bHasNavigationMesh) && bIgnoreRestrictions || NextDestinations[I].AllowableDestinationFor(Agent))
		{
			DestinationFrequencySum += (NextDestinations[I].Frequency * (((bIsVisible! && Agent.bPreferVisibleDestination) && NextDestinations[I].bIsVisible || NextDestinations[I].bWillBeVisible) ? 2.0000000 : 1.0000000));
			DestOptions.AddItem(NextDestinations[I]);
		}
		I++;
		// [Loop Continue]
		goto J0x5E;
	}
	DestinationPickValue = DestinationFrequencySum * FRand();
	DestinationFrequencySum = 0.0000000;
	I = 0;
	J0x232:

	// End:0x3FB [Loop If]
	if(I < DestOptions.Length)
	{
		// End:0x3ED
		if((DestOptions[I] != none) && DestOptions[I].bHasNavigationMesh)
		{
			DestinationFrequencySum += (DestOptions[I].Frequency * (((bIsVisible! && Agent.bPreferVisibleDestination) && DestOptions[I].bIsVisible || DestOptions[I].bWillBeVisible) ? 2.0000000 : 1.0000000));
			// End:0x3ED
			if(DestinationPickValue < DestinationFrequencySum)
			{
				Agent.SetCurrentDestination(DestOptions[I]);
				Agent.PreviousDestination = self;
				Agent.UpdateIntermediatePoint();
				// [Explicit Break]
				goto J0x3FB;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x232;
	}
	J0x3FB:

	Agent.PreviousDestination = self;
	//return;	
}

simulated event DecrementCustomerCount(GameCrowdAgent DepartingAgent)
{
	local GameCrowdDestinationQueuePoint QP;
	local bool bIsInQueue;

	// End:0x141
	if(DepartingAgent.CurrentDestination == self)
	{
		QP = QueueHead;
		J0x37:

		// End:0xD4 [Loop If]
		if(QP != none)
		{
			// End:0xA9
			if(QP.QueuedAgent == DepartingAgent)
			{
				bIsInQueue = true;
				QP.ClearQueue(DepartingAgent);
				// [Explicit Break]
				goto J0xD4;
			}
			QP = QP.NextQueuePosition;
			// [Loop Continue]
			goto J0x37;
		}
		J0xD4:

		// End:0x141
		if(bIsInQueue!)
		{
			CustomerCount--;
			// End:0x141
			if((QueueHead != none) && QueueHead.HasCustomer())
			{
				QueueHead.AdvanceCustomerTo(self);
			}
		}
	}
	//return;	
}

simulated event IncrementCustomerCount(GameCrowdAgent ArrivingAgent)
{
	// End:0x211
	if((AtCapacity()) || (QueueHead != none) && QueueHead.bPendingAdvance)
	{
		// End:0x1AC
		if((QueueHead != none) && QueueHead.HasSpace())
		{
			// End:0x180
			if((((AgentEnRoute != none) && AgentEnRoute.CurrentBehavior == none) && ReachedByAgent(AgentEnRoute, AgentEnRoute.Location, false)!) && VSizeSq(ArrivingAgent.Location - Location) < VSizeSq(AgentEnRoute.Location - Location))
			{
				QueueHead.AddCustomer(AgentEnRoute, self);
				AgentEnRoute = ArrivingAgent;				
			}
			else
			{
				QueueHead.AddCustomer(ArrivingAgent, self);
			}			
		}
		else
		{
			// End:0x20E
			if(QueueHead != none)
			{
				WarnInternal((((string(self) $ " added customer ") $ string(ArrivingAgent)) $ " beyond capacity with queue ") $ string(QueueHead));
			}
		}		
	}
	else
	{
		AgentEnRoute = ArrivingAgent;
		CustomerCount++;
	}
	//return;	
}

simulated function bool AtCapacity(optional byte CheckCnt)
{
	return (CustomerCount + int(CheckCnt)) >= Capacity;
	//return ReturnValue;	
}

simulated event bool AllowableDestinationFor(GameCrowdAgent Agent)
{
	local int I;
	local bool bSupported;

	// End:0x22
	if(bHasNavigationMesh! || bIsEnabled!)
	{
		return false;
	}
	// End:0x31
	if(bIsBeyondSpawnDistance)
	{
		return false;
	}
	// End:0x68
	if(bAllowAsPreviousDestination! && Agent.PreviousDestination == self)
	{
		return false;
	}
	// End:0xCA
	if((Agent.CurrentBehavior != none) && Agent.CurrentBehavior.AllowThisDestination(self)!)
	{
		return false;
	}
	// End:0x17F
	if((((Agent.MyGroup != none) && AtCapacity(byte(Agent.MyGroup.Members.Length - 1))) || AtCapacity()) || (QueueHead != none) && QueueHead.HasSpace()!)
	{
		return false;
	}
	// End:0x2D0
	if(InteractionTag != 'None')
	{
		I = Agent.RecentInteractions.Find('InteractionTag', InteractionTag);
		// End:0x293
		if((I != -1) && (Agent.RecentInteractions[I].InteractionDelay == 0.0000000) || WorldInfo.TimeSeconds < Agent.RecentInteractions[I].InteractionDelay)
		{
			return false;			
		}
		else
		{
			// End:0x2D0
			if(I != -1)
			{
				Agent.RecentInteractions.Remove(I, 1);
			}
		}
	}
	// End:0x4EB
	if(bHasRestrictions)
	{
		// End:0x418
		if((SupportedAgentClasses.Length > 0) || SupportedArchetypes.Length > 0)
		{
			bSupported = false;
			I = 0;
			J0x316:

			// End:0x382 [Loop If]
			if(I < SupportedAgentClasses.Length)
			{
				// End:0x374
				if(ClassIsChildOf(Agent.Class, SupportedAgentClasses[I]))
				{
					bSupported = true;
					// [Explicit Break]
					goto J0x382;
				}
				I++;
				// [Loop Continue]
				goto J0x316;
			}
			J0x382:

			// End:0x407
			if(bSupported!)
			{
				I = 0;
				J0x39C:

				// End:0x407 [Loop If]
				if(I < SupportedArchetypes.Length)
				{
					// End:0x3F9
					if(SupportedArchetypes[I] == Agent.MyArchetype)
					{
						bSupported = true;
						// [Explicit Break]
						goto J0x407;
					}
					I++;
					// [Loop Continue]
					goto J0x39C;
				}
			}
			J0x407:

			// End:0x418
			if(bSupported!)
			{
				return false;
			}
		}
		I = 0;
		J0x423:

		// End:0x482 [Loop If]
		if(I < RestrictedAgentClasses.Length)
		{
			// End:0x474
			if(ClassIsChildOf(Agent.Class, RestrictedAgentClasses[I]))
			{
				return false;
			}
			I++;
			// [Loop Continue]
			goto J0x423;
		}
		I = 0;
		J0x48D:

		// End:0x4EB [Loop If]
		if(I < RestrictedArchetypes.Length)
		{
			// End:0x4DD
			if(RestrictedArchetypes[I] == Agent.MyArchetype)
			{
				return false;
			}
			I++;
			// [Loop Continue]
			goto J0x48D;
		}
	}
	return true;
	//return ReturnValue;	
}

simulated function float GetSpawnRadius()
{
	return CylinderComponent.CollisionRadius;
	//return ReturnValue;	
}

simulated function GetSpawnPosition(SeqAct_GameCrowdSpawner Spawner, out Vector SpawnPos, out Rotator SpawnRot)
{
	local Vector SpawnLine;
	local float RandScale;

	// End:0xBB
	if(bLineSpawner)
	{
		RandScale = -1.0000000 + (2.0000000 * FRand());
		SpawnLine = vect(0.0000000, 1.0000000, 0.0000000) >> Rotation;
		SpawnPos = Location + ((RandScale * SpawnLine) * (GetSpawnRadius()));
		SpawnRot.Yaw = Rotation.Yaw;		
	}
	else
	{
		SpawnRot = RotRand(false);
		SpawnRot.Pitch = 0;
		// End:0x131
		if(bSpawnAtEdge)
		{
			SpawnPos = Location + ((vect(1.0000000, 0.0000000, 0.0000000) * (GetSpawnRadius())) >> SpawnRot);			
		}
		else
		{
			SpawnPos = Location + (((vect(1.0000000, 0.0000000, 0.0000000) * FRand()) * (GetSpawnRadius())) >> SpawnRot);
		}
	}
	//return;	
}

simulated function bool AnalyzeSpawnPoint(const out array<CrowdSpawnerPlayerInfo> PlayerInfo, float MaxSpawnDistSq, bool bForceNavMeshPathing, NavigationHandle NavHandle)
{
	local Actor HitActor;
	local Vector HitLocation, HitNormal;
	local int NextIdx, PlayerIdx;
	local GameCrowdDestination NextGCD;
	local float DistFromView, DistFromPred;

	bIsVisible = true;
	bAdjacentToVisibleNode = false;
	bWillBeVisible = false;
	Priority = 0.0000000;
	bCanSpawnHereNow = false;
	bHasNavigationMesh = true;
	bIsBeyondSpawnDistance = true;
	PlayerIdx = 0;
	J0x62:

	// End:0x133 [Loop If]
	if(PlayerIdx < PlayerInfo.Length)
	{
		DistFromView = VSizeSq(PlayerInfo[PlayerIdx].ViewLocation - Location);
		DistFromPred = VSizeSq(PlayerInfo[PlayerIdx].PredictLocation - Location);
		// End:0x125
		if(FMin(DistFromView, DistFromPred) < MaxSpawnDistSq)
		{
			bIsBeyondSpawnDistance = false;
			// [Explicit Break]
			goto J0x133;
		}
		PlayerIdx++;
		// [Loop Continue]
		goto J0x62;
	}
	J0x133:

	// End:0x456
	if(bIsEnabled && bAllowsSpawning)
	{
		// End:0x1DF
		if(bForceNavMeshPathing && NavHandle.LineCheck(Location, Location - (vect(0.0000000, 0.0000000, 3.0000000) * CylinderComponent.CollisionHeight), vect(0.0000000, 0.0000000, 0.0000000)))
		{
			bHasNavigationMesh = false;			
		}
		else
		{
			// End:0x357
			if(bIsBeyondSpawnDistance!)
			{
				bCanSpawnHereNow = true;
				bIsVisible = false;
				PlayerIdx = 0;
				J0x211:

				// End:0x2A7 [Loop If]
				if(PlayerIdx < PlayerInfo.Length)
				{
					HitActor = Trace(HitLocation, HitNormal, Location, PlayerInfo[PlayerIdx].ViewLocation, false);
					// End:0x299
					if(HitActor == none)
					{
						bIsVisible = true;
						// [Explicit Break]
						goto J0x2A7;
					}
					PlayerIdx++;
					// [Loop Continue]
					goto J0x211;
				}
				J0x2A7:

				// End:0x357
				if(bIsVisible!)
				{
					PlayerIdx = 0;
					J0x2C1:

					// End:0x357 [Loop If]
					if(PlayerIdx < PlayerInfo.Length)
					{
						HitActor = Trace(HitLocation, HitNormal, Location, PlayerInfo[PlayerIdx].PredictLocation, false);
						// End:0x349
						if(HitActor == none)
						{
							bWillBeVisible = true;
							// [Explicit Break]
							goto J0x357;
						}
						PlayerIdx++;
						// [Loop Continue]
						goto J0x2C1;
					}
				}
			}
			J0x357:

			// End:0x454
			if(bIsVisible)
			{
				NextIdx = 0;
				J0x36F:

				// End:0x454 [Loop If]
				if(NextIdx < NextDestinations.Length)
				{
					NextGCD = NextDestinations[NextIdx];
					// End:0x446
					if((((NextGCD != none) && NextGCD.bIsVisible) && NextGCD.bCanSpawnHereNow) && NextGCD.bIsBeyondSpawnDistance!)
					{
						bAdjacentToVisibleNode = true;
						// End:0x446
						if(bIsBeyondSpawnDistance)
						{
							bCanSpawnHereNow = true;
						}
					}
					NextIdx++;
					// [Loop Continue]
					goto J0x36F;
				}
			}
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function PrioritizeSpawnPoint(const out array<CrowdSpawnerPlayerInfo> PlayerInfo, float MaxSpawnDist)
{
	local float DistToSpawn;
	local int PlayerIdx;

	DistToSpawn = 999999.0000000;
	PlayerIdx = 0;
	J0x1A:

	// End:0x88 [Loop If]
	if(PlayerIdx < PlayerInfo.Length)
	{
		DistToSpawn = FMin(DistToSpawn, VSize(Location - PlayerInfo[PlayerIdx].ViewLocation));
		PlayerIdx++;
		// [Loop Continue]
		goto J0x1A;
	}
	Priority = 1.0000000 - ((MaxSpawnDist - DistToSpawn) / MaxSpawnDist);
	// End:0xD8
	if(bWillBeVisible)
	{
		Priority *= 10.0000000;		
	}
	else
	{
		// End:0xF5
		if(bAdjacentToVisibleNode)
		{
			Priority *= 5.0000000;
		}
	}
	Priority *= FMin(WorldInfo.TimeSeconds - LastSpawnTime, 10.0000000);
	//return;	
}

function float GetDestinationRadius()
{
	return CylinderComponent.CollisionRadius;
	//return ReturnValue;	
}

simulated function DrawDebug(const out array<CrowdSpawnerPlayerInfo> PlayerInfo, optional bool bPresistent)
{
	local int PlayerIdx;
	local Vector Extent;

	Extent.X = CylinderComponent.CollisionRadius;
	Extent.Y = CylinderComponent.CollisionRadius;
	Extent.Z = CylinderComponent.CollisionHeight * 2.0000000;
	PlayerIdx = 0;
	J0xC4:

	// End:0x339 [Loop If]
	if(PlayerIdx < PlayerInfo.Length)
	{
		// End:0x16E
		if(bIsBeyondSpawnDistance)
		{
			DrawDebugLine(Location, PlayerInfo[PlayerIdx].ViewLocation, 255, 0, 0, bPresistent);
			// End:0x16B
			if(PlayerIdx == 0)
			{
				DrawDebugSphere(Location, 20.0000000, 20, 255, 0, 0, bPresistent);
			}			
		}
		else
		{
			// End:0x213
			if(bIsEnabled! || bAllowsSpawning!)
			{
				// End:0x1E6
				if(PlayerIdx == 0)
				{
					DrawDebugLine(Location, PlayerInfo[PlayerIdx].ViewLocation, 128, 0, 0, bPresistent);
				}
				DrawDebugSphere(Location, 20.0000000, 20, 128, 0, 0, bPresistent);				
			}
			else
			{
				// End:0x2A7
				if(bIsVisible)
				{
					// End:0x278
					if(PlayerIdx == 0)
					{
						DrawDebugLine(Location, PlayerInfo[PlayerIdx].ViewLocation, 255, 0, 0, bPresistent);
					}
					DrawDebugBox(Location, Extent, 255, 0, 0, bPresistent);					
				}
				else
				{
					// End:0x2FF
					if(PlayerIdx == 0)
					{
						DrawDebugLine(Location, PlayerInfo[PlayerIdx].ViewLocation, 0, 255, 0, bPresistent);
					}
					DrawDebugBox(Location, Extent, 0, 255, 0, bPresistent);
				}
			}
		}
		PlayerIdx++;
		// [Loop Continue]
		goto J0xC4;
	}
	// End:0x36E
	if(bAdjacentToVisibleNode)
	{
		DrawDebugStar(Location, 8.0000000, 0, 255, 0, bPresistent);
	}
	// End:0x3B2
	if(bWillBeVisible)
	{
		DrawDebugStar(Location + vect(0.0000000, 0.0000000, 8.0000000), 8.0000000, 0, 0, 255, bPresistent);
	}
	// End:0x3F6
	if(bCanSpawnHereNow)
	{
		DrawDebugStar(Location + vect(0.0000000, 0.0000000, 16.0000000), 8.0000000, 255, 255, 255, bPresistent);
	}
	//return;	
}

defaultproperties
{
	bSkipBehaviorIfPanicked=true
	bAllowsSpawning=true
	bAllowCloudSpawning=true
	bSoftPerimeter=true
	bHasNavigationMesh=true
	Capacity=1000
	Frequency=1.0000000
	ExactReachTolerance=3.0000000
	// Reference: CylinderComponent'GameFramework.Default__GameCrowdDestination.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'GameFramework.Default__GameCrowdInteractionPoint.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	Components[1]=none
	Components[2]=none
	bStatic=true
	bForceAllowKismetModification=true
	CollisionComponent=CollisionCylinder
	SupportedEvents=/* ERROR: System.IO.EndOfStreamException */
}