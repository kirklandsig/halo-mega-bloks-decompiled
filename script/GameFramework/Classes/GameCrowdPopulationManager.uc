class GameCrowdPopulationManager extends CrowdPopulationManagerBase
	native
	implements(Interface_NavigationHandle)
	dependson(SeqAct_GameCrowdSpawner);

var private native const noexport Pointer VfTable_IInterface_NavigationHandle;
var CrowdSpawnInfoItem CloudSpawnInfo;
var array<CrowdSpawnInfoItem> ScriptedSpawnInfo;
var GameCrowdInfoVolume ActiveCrowdInfoVolume;
var array<GameCrowdDestination> GlobalPotentialSpawnPoints;
var float SplitScreenNumReduction;
var float PlayerPositionPredictionTime;
var float HeadVisibilityOffset;
var Class<NavigationHandle> NavigationHandleClass;
var NavigationHandle NavigationHandle;
var GameCrowdAgent QueryingAgent;
var array<CrowdSpawnerPlayerInfo> PlayerInfo;
var float LastPlayerInfoUpdateTime;
var bool bDebugSpawns;
var bool bPauseCrowd;

function PostBeginPlay()
{
	local GameCrowdDestination GCD;

	super(Actor).PostBeginPlay();
	// End:0x39
	if(!bDeleteMe)
	{
		WorldInfo.PopulationManager = self;
	}
	// End:0x60
	if(NavigationHandleClass != none)
	{
		NavigationHandle = new (self) NavigationHandleClass;
	}
	// End:0x8D
	foreach AllActors(Class'GameFramework.GameCrowdDestination', GCD)
	{
		AddSpawnPoint(GCD);		
	}	
	//return;	
}

event NotifyPathChanged()
{
	//return;	
}

function AddSpawnPoint(GameCrowdDestination GCD)
{
	// End:0x4C
	if((GCD.MyPopMgr != none) || !GCD.bAllowCloudSpawning)
	{
		return;
	}
	GCD.MyPopMgr = self;
	GlobalPotentialSpawnPoints[GlobalPotentialSpawnPoints.Length] = GCD;
	// End:0xDD
	if(ActiveCrowdInfoVolume == none)
	{
		CloudSpawnInfo.PotentialSpawnPoints[CloudSpawnInfo.PotentialSpawnPoints.Length] = GCD;
	}
	//return;	
}

function RemoveSpawnPoint(GameCrowdDestination GCD)
{
	local int Idx, AgentIdx;

	GCD.MyPopMgr = none;
	CloudSpawnInfo.PotentialSpawnPoints.RemoveItem(GCD);
	CloudSpawnInfo.PrioritizedSpawnPoints.RemoveItem(GCD);
	GlobalPotentialSpawnPoints.RemoveItem(GCD);
	AgentIdx = 0;
	J0x93:

	// End:0x14A [Loop If]
	if(AgentIdx < CloudSpawnInfo.ActiveAgents.Length)
	{
		// End:0x13C
		if(CloudSpawnInfo.ActiveAgents[AgentIdx].CurrentDestination == GCD)
		{
			CloudSpawnInfo.ActiveAgents[AgentIdx].Destroy();
		}
		AgentIdx++;
		// [Loop Continue]
		goto J0x93;
	}
	Idx = 0;
	J0x155:

	// End:0x2C1 [Loop If]
	if(Idx < ScriptedSpawnInfo.Length)
	{
		ScriptedSpawnInfo[Idx].PotentialSpawnPoints.RemoveItem(GCD);
		ScriptedSpawnInfo[Idx].PrioritizedSpawnPoints.RemoveItem(GCD);
		AgentIdx = 0;
		J0x1DE:

		// End:0x2B3 [Loop If]
		if(AgentIdx < ScriptedSpawnInfo[Idx].ActiveAgents.Length)
		{
			// End:0x2A5
			if(ScriptedSpawnInfo[Idx].ActiveAgents[AgentIdx].CurrentDestination == GCD)
			{
				ScriptedSpawnInfo[Idx].ActiveAgents[AgentIdx].Destroy();
			}
			AgentIdx++;
			// [Loop Continue]
			goto J0x1DE;
		}
		Idx++;
		// [Loop Continue]
		goto J0x155;
	}
	//return;	
}

function SetCrowdInfoVolume(GameCrowdInfoVolume Vol)
{
	// End:0xF8
	if(Vol != ActiveCrowdInfoVolume)
	{
		ActiveCrowdInfoVolume = Vol;
		// End:0x77
		if(Vol != none)
		{
			CloudSpawnInfo.PotentialSpawnPoints = Vol.PotentialSpawnPoints;			
		}
		else
		{
			CloudSpawnInfo.PotentialSpawnPoints = GlobalPotentialSpawnPoints;
		}
		CloudSpawnInfo.PrioritizedSpawnPoints.Length = 0;
		CloudSpawnInfo.PrioritizationIndex = 0;
		CloudSpawnInfo.PrioritizationUpdateIndex = 0;
	}
	//return;	
}

event int CreateSpawner(SeqAct_GameCrowdPopulationManagerToggle inAction)
{
	local int Idx;

	Idx = ScriptedSpawnInfo.Length;
	ScriptedSpawnInfo.Length = Idx + 1;
	ScriptedSpawnInfo[Idx].SeqSpawner = inAction;
	return Idx;
	//return ReturnValue;	
}

event FlushAgents(CrowdSpawnInfoItem Item)
{
	local int AgentIdx;

	AgentIdx = 0;
	J0x0B:

	// End:0x79 [Loop If]
	if(AgentIdx < Item.ActiveAgents.Length)
	{
		Item.ActiveAgents[AgentIdx].Destroy();
		AgentIdx++;
		// [Loop Continue]
		goto J0x0B;
	}
	Item.ActiveAgents.Length = 0;
	//return;	
}

event FlushAllAgents()
{
	local int Idx;

	FlushAgents(CloudSpawnInfo);
	Idx = 0;
	J0x1E:

	// End:0x61 [Loop If]
	if(Idx < ScriptedSpawnInfo.Length)
	{
		FlushAgents(ScriptedSpawnInfo[Idx]);
		Idx++;
		// [Loop Continue]
		goto J0x1E;
	}
	//return;	
}

function AgentDestroyed(GameCrowdAgent Agent)
{
	local int SpawnerIdx, I;

	SpawnerIdx = ScriptedSpawnInfo.Find('SeqSpawner', SeqAct_GameCrowdPopulationManagerToggle(Agent.MySpawner));
	// End:0x190
	if(SpawnerIdx >= 0)
	{
		I = 0;
		J0x63:

		// End:0x15A [Loop If]
		if(I < ScriptedSpawnInfo[SpawnerIdx].AgentArchetypes.Length)
		{
			// End:0x14C
			if(GameCrowdAgent(ScriptedSpawnInfo[SpawnerIdx].AgentArchetypes[I].AgentArchetype) == Agent.MyArchetype)
			{
				ScriptedSpawnInfo[SpawnerIdx].AgentArchetypes[I].CurrSpawned--;
			}
			I++;
			// [Loop Continue]
			goto J0x63;
		}
		ScriptedSpawnInfo[SpawnerIdx].ActiveAgents.RemoveItem(Agent);		
	}
	else
	{
		// End:0x2D2
		if(NotEqual_InterfaceInterface(Agent.MySpawner, GameCrowdSpawnerInterface(none)))
		{
			I = 0;
			J0x1D0:

			// End:0x2A9 [Loop If]
			if(I < CloudSpawnInfo.AgentArchetypes.Length)
			{
				// End:0x29B
				if(GameCrowdAgent(CloudSpawnInfo.AgentArchetypes[I].AgentArchetype) == Agent.MyArchetype)
				{
					CloudSpawnInfo.AgentArchetypes[I].CurrSpawned--;
				}
				I++;
				// [Loop Continue]
				goto J0x1D0;
			}
			CloudSpawnInfo.ActiveAgents.RemoveItem(Agent);
		}
	}
	//return;	
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local Canvas Canvas;
	local int RenderedNum, LOSNum, SimNum, ActualCount, DistanceBucket[20], I,
		RVONum;

	local Actor HitActor;
	local Vector HitNormal, HitLocation;
	local GameCrowdAgent GCA;
	local float Dist;
	local array<GameCrowdAgent> AgentList;
	local int PlayerIdx, SpawnIdx;
	local bool bHasLOS;
	local float BucketSize;

	Canvas = HUD.Canvas;
	Canvas.SetDrawColor(255, 255, 255);
	Canvas.SetPos(4.0000000, out_YPos);
	Canvas.DrawText("---- GameCrowdPopulationManager ---");
	out_YPos += out_YL;
	// End:0xE9
	if(!GetPlayerInfo())
	{
		return;
	}
	// End:0x145
	foreach DynamicActors(Class'GameFramework.GameCrowdAgent', GCA)
	{
		// End:0x144
		if(!GCA.bDeleteMe)
		{
			AgentList[AgentList.Length] = GCA;
		}		
	}	
	BucketSize = (2.0000000 * CloudSpawnInfo.MaxSpawnDist) / float(20);
	// End:0x47D
	foreach AgentList(GCA)
	{
		ActualCount++;
		// End:0x3B9
		if(GCA.Health > 0)
		{
			// End:0x1EC
			if(GCA.bSimulateThisTick)
			{
				SimNum++;
			}
			// End:0x291
			if(((WorldInfo.TimeSeconds - GCA.LastRenderTime) < 1.0000000) && GCA.LastRenderTime != GCA.InitialLastRenderTime)
			{
				bHasLOS = true;
				RenderedNum++;				
			}
			else
			{
				bHasLOS = false;
				PlayerIdx = 0;
				J0x2A8:

				// End:0x353 [Loop If]
				if(PlayerIdx < PlayerInfo.Length)
				{
					HitActor = Trace(HitLocation, HitNormal, GCA.Location, PlayerInfo[PlayerIdx].ViewLocation, false);
					// End:0x345
					if(HitActor == none)
					{
						bHasLOS = true;
						// [Explicit Break]
						goto J0x353;
					}
					PlayerIdx++;
					// [Loop Continue]
					goto J0x2A8;
				}
			}
			J0x353:

			// End:0x398
			if(bHasLOS)
			{
				LOSNum++;
				// End:0x398
				if(GCA.bSimulateThisTick)
				{
					RVONum++;
				}
			}
			GCA.bSimulateThisTick = false;
		}
		Dist = 999999.0000000;
		PlayerIdx = 0;
		J0x3D3:

		// End:0x456 [Loop If]
		if(PlayerIdx < PlayerInfo.Length)
		{
			Dist = FMin(VSize(PlayerInfo[PlayerIdx].ViewLocation - GCA.Location), Dist);
			PlayerIdx++;
			// [Loop Continue]
			goto J0x3D3;
		}
		DistanceBucket[Min(19, int(Dist / BucketSize))]++;		
	}	
	Canvas.DrawText("TotalCount: " $ string(ActualCount));
	out_YPos += out_YL;
	Canvas.SetPos(4.0000000, out_YPos);
	Canvas.DrawText((("Cloud:" @ string(CloudSpawnInfo.ActiveAgents.Length)) @ "Active:") @ string(CloudSpawnInfo.bSpawningActive));
	out_YPos += out_YL;
	Canvas.SetPos(4.0000000, out_YPos);
	SpawnIdx = 0;
	J0x5C3:

	// End:0x6E5 [Loop If]
	if(SpawnIdx < ScriptedSpawnInfo.Length)
	{
		Canvas.DrawText(((("Scripted: " $ string(ScriptedSpawnInfo[SpawnIdx].ActiveAgents.Length)) @ string(ScriptedSpawnInfo[SpawnIdx].SeqSpawner)) @ "Active:") @ string(ScriptedSpawnInfo[SpawnIdx].bSpawningActive));
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
		SpawnIdx++;
		// [Loop Continue]
		goto J0x5C3;
	}
	Canvas.DrawText("Agents Rendered:" @ string(RenderedNum));
	out_YPos += out_YL;
	Canvas.SetPos(4.0000000, out_YPos);
	Canvas.DrawText("Agents LOS:" @ string(LOSNum));
	out_YPos += out_YL;
	Canvas.SetPos(4.0000000, out_YPos);
	Canvas.DrawText("Agents Simulated:" @ string(SimNum));
	out_YPos += out_YL;
	Canvas.SetPos(4.0000000, out_YPos);
	Canvas.DrawText("Agents RVO:" @ string(RVONum));
	out_YPos += out_YL;
	Canvas.SetPos(4.0000000, out_YPos);
	Canvas.DrawText("Distance Buckets");
	out_YPos += out_YL;
	Canvas.SetPos(4.0000000, out_YPos);
	I = 0;
	J0x96E:

	// End:0xA48 [Loop If]
	if(I < 19)
	{
		// End:0xA3A
		if(DistanceBucket[I] > 0)
		{
			Canvas.DrawText(((" (<" $ string(BucketSize * float(I + 1))) $ ")") $ string(DistanceBucket[I]));
			out_YPos += out_YL;
			Canvas.SetPos(4.0000000, out_YPos);
		}
		I++;
		// [Loop Continue]
		goto J0x96E;
	}
	//return;	
}

function bool IsSpawningActive()
{
	local int SpawnerIdx;

	// End:0x22
	if(CloudSpawnInfo.bSpawningActive)
	{
		return true;
	}
	SpawnerIdx = 0;
	J0x2D:

	// End:0x7F [Loop If]
	if(SpawnerIdx < ScriptedSpawnInfo.Length)
	{
		// End:0x71
		if(ScriptedSpawnInfo[SpawnerIdx].bSpawningActive)
		{
			return true;
		}
		SpawnerIdx++;
		// [Loop Continue]
		goto J0x2D;
	}
	return false;
	//return ReturnValue;	
}

simulated function bool ShouldDebugDestinations()
{
	return bDebugSpawns;
	//return ReturnValue;	
}

function Tick(float DeltaTime)
{
	local GameCrowdDestination PickedSpawnPoint;
	local int Idx, PlayerIdx;

	// End:0x395
	if((ShouldDebugDestinations()) && GetPlayerInfo())
	{
		PlayerIdx = 0;
		J0x27:

		// End:0x162 [Loop If]
		if(PlayerIdx < PlayerInfo.Length)
		{
			DrawDebugBox(PlayerInfo[PlayerIdx].PredictLocation, vect(20.0000000, 20.0000000, 20.0000000), 255, 0, 0);
			DrawDebugBox(PlayerInfo[PlayerIdx].ViewLocation, vect(10.0000000, 10.0000000, 10.0000000), 255, 255, 255);
			DrawDebugLine(PlayerInfo[PlayerIdx].ViewLocation, PlayerInfo[PlayerIdx].ViewLocation + (Vector(PlayerInfo[PlayerIdx].ViewRotation) * float(64)), 255, 255, 255);
			PlayerIdx++;
			// [Loop Continue]
			goto J0x27;
		}
		Idx = 0;
		J0x16D:

		// End:0x395 [Loop If]
		if(Idx < CloudSpawnInfo.PotentialSpawnPoints.Length)
		{
			PickedSpawnPoint = CloudSpawnInfo.PotentialSpawnPoints[Idx];
			// End:0x1DA
			if(PickedSpawnPoint == none)
			{				
			}
			else
			{
				PickedSpawnPoint.AnalyzeSpawnPoint(PlayerInfo, CloudSpawnInfo.MaxSpawnDistSq, CloudSpawnInfo.bForceNavMeshPathing, NavigationHandle);
				PickedSpawnPoint.PrioritizeSpawnPoint(PlayerInfo, CloudSpawnInfo.MaxSpawnDist);
				PickedSpawnPoint.DrawDebug(PlayerInfo);
				// End:0x387
				if(!ValidateSpawnAt(CloudSpawnInfo, PickedSpawnPoint))
				{
					DrawDebugCylinder(PickedSpawnPoint.Location, PickedSpawnPoint.Location, PickedSpawnPoint.CylinderComponent.CollisionRadius, int(PickedSpawnPoint.CylinderComponent.CollisionHeight), 255, 0, 0);
				}
			}
			Idx++;
			// [Loop Continue]
			goto J0x16D;
		}
	}
	// End:0x3C6
	if(!bPauseCrowd && IsSpawningActive())
	{
		UpdateAllSpawners(DeltaTime);
	}
	//return;	
}

// Export UGameCrowdPopulationManager::execUpdateAllSpawners(FFrame&, void* const)
native function UpdateAllSpawners(float DeltaTime);

event bool UpdateSpawner(out CrowdSpawnInfoItem Item, float DeltaTime)
{
	local GameCrowdDestination PickedSpawnPoint;
	local GameCrowdAgent A;
	local int NumSpawned;

	// End:0x64
	if(!Item.bSpawningActive || Item.ActiveAgents.Length >= Item.SpawnNum)
	{
		return false;
	}
	// End:0xBA
	if(Item.SeqSpawner != none)
	{
		Item.SeqSpawner.LastSpawnedList.Length = 0;
	}
	Item.Remainder += (FMin(DeltaTime, 0.0500000) * Item.SpawnRate);
	// End:0x302
	if(Item.Remainder > 1.0000000)
	{
		PrioritizeSpawnPoints(Item, DeltaTime);
		J0x148:

		// End:0x302 [Loop If]
		if((Item.Remainder > 1.0000000) && Item.ActiveAgents.Length < Item.SpawnNum)
		{
			PickedSpawnPoint = PickSpawnPoint(Item);
			// End:0x2DD
			if(PickedSpawnPoint != none)
			{
				PickedSpawnPoint.LastSpawnTime = WorldInfo.TimeSeconds;
				A = SpawnAgent(Item, PickedSpawnPoint);
				// End:0x2B7
				if(A != none)
				{
					NumSpawned++;
					// End:0x2B7
					if(Item.SeqSpawner != none)
					{
						Item.SeqSpawner.LastSpawnedList.AddItem(A);
					}
				}
				Item.Remainder -= 1.0000000;				
			}
			else
			{
				Item.Remainder = 0.0000000;
			}
			// [Loop Continue]
			goto J0x148;
		}
	}
	return NumSpawned > 0;
	//return ReturnValue;	
}

event GameCrowdDestination PickSpawnPoint(out CrowdSpawnInfoItem Item)
{
	local int StartingIndex, SpawnIdx;
	local GameCrowdDestination Candidate;

	StartingIndex = Min(Item.PrioritizationIndex, Item.PrioritizedSpawnPoints.Length);
	SpawnIdx = 0;
	J0x50:

	// End:0x145 [Loop If]
	if(SpawnIdx < Item.PrioritizedSpawnPoints.Length)
	{
		Item.PrioritizationIndex = (StartingIndex + SpawnIdx) % Item.PrioritizedSpawnPoints.Length;
		Candidate = Item.PrioritizedSpawnPoints[Item.PrioritizationIndex];
		// End:0x137
		if(ValidateSpawnAt(Item, Candidate))
		{
			return Candidate;
		}
		SpawnIdx++;
		// [Loop Continue]
		goto J0x50;
	}
	return none;
	//return ReturnValue;	
}

// Export UGameCrowdPopulationManager::execGetPlayerInfo(FFrame&, void* const)
native simulated function bool GetPlayerInfo();

// Export UGameCrowdPopulationManager::execStaticGetPlayerInfo(FFrame&, void* const)
native static simulated function bool StaticGetPlayerInfo(out array<CrowdSpawnerPlayerInfo> out_PlayerInfo);

event PrioritizeSpawnPoints(out CrowdSpawnInfoItem Item, float DeltaTime)
{
	local int UpdateNum;

	// End:0x36
	if((Item.PotentialSpawnPoints.Length == 0) || !GetPlayerInfo())
	{
		return;
	}
	UpdateNum = Max(1, int((DeltaTime * float(Item.PotentialSpawnPoints.Length)) / Item.SpawnPrioritizationInterval));
	AnalyzeSpawnPoints(Item, Item.PrioritizationUpdateIndex, UpdateNum);
	Item.PrioritizationUpdateIndex = (Item.PrioritizationUpdateIndex + UpdateNum) % Item.PotentialSpawnPoints.Length;
	//return;	
}

function AnalyzeSpawnPoints(out CrowdSpawnInfoItem Item, int StartIndex, int NumToUpdate)
{
	local int UpdateIdx, Idx, NumUpdated;
	local GameCrowdDestination GCD;

	// End:0x3E
	if((StartIndex >= Item.PotentialSpawnPoints.Length) || !GetPlayerInfo())
	{
		return;
	}
	NumUpdated = 0;
	UpdateIdx = 0;
	J0x54:

	// End:0x22E [Loop If]
	if((NumUpdated < NumToUpdate) && UpdateIdx < Item.PotentialSpawnPoints.Length)
	{
		Idx = (StartIndex + UpdateIdx) % Item.PotentialSpawnPoints.Length;
		GCD = Item.PotentialSpawnPoints[Idx];
		// End:0x141
		if(GCD == none)
		{
			Item.PotentialSpawnPoints.Remove(UpdateIdx--, 1);			
		}
		else
		{
			Item.PrioritizedSpawnPoints.RemoveItem(GCD);
			// End:0x220
			if(GCD.AnalyzeSpawnPoint(PlayerInfo, Item.MaxSpawnDistSq, Item.bForceNavMeshPathing, NavigationHandle))
			{
				NumUpdated++;
				// End:0x220
				if(GCD.bCanSpawnHereNow)
				{
					AddPrioritizedSpawnPoint(Item, GCD);
				}
			}
		}
		UpdateIdx++;
		// [Loop Continue]
		goto J0x54;
	}
	//return;	
}

function AddPrioritizedSpawnPoint(out CrowdSpawnInfoItem Item, GameCrowdDestination GCD)
{
	local int SpawnIdx, StartingIndex;

	GCD.PrioritizeSpawnPoint(PlayerInfo, Item.MaxSpawnDist);
	StartingIndex = Min(Item.PrioritizationIndex, Item.PrioritizedSpawnPoints.Length);
	SpawnIdx = 0;
	J0x94:

	// End:0x20E [Loop If]
	if(SpawnIdx < Item.PrioritizedSpawnPoints.Length)
	{
		Item.PrioritizationIndex = (StartingIndex + SpawnIdx) % Item.PrioritizedSpawnPoints.Length;
		// End:0x200
		if(Item.PrioritizedSpawnPoints[Item.PrioritizationIndex].Priority < GCD.Priority)
		{
			Item.PrioritizedSpawnPoints.Insert(Item.PrioritizationIndex, 1);
			Item.PrioritizedSpawnPoints[Item.PrioritizationIndex] = GCD;
			return;
		}
		SpawnIdx++;
		// [Loop Continue]
		goto J0x94;
	}
	Item.PrioritizedSpawnPoints.Insert(StartingIndex, 1);
	Item.PrioritizedSpawnPoints[StartingIndex] = GCD;
	Item.PrioritizationIndex = (StartingIndex + 1) % Item.PrioritizedSpawnPoints.Length;
	//return;	
}

function bool ValidateSpawnAt(out CrowdSpawnInfoItem Item, GameCrowdDestination Candidate)
{
	local Actor HitActor;
	local Vector HitLocation, HitNormal;
	local float DistSq, MinDistFromViewSq, DestDotView;
	local int PlayerIdx;

	// End:0x71
	if((!Candidate.bIsEnabled || !Candidate.bAllowsSpawning) || Candidate.AtCapacity())
	{
		return false;
	}
	// End:0x95
	if(Candidate.bAllowVisibleSpawning)
	{
		return true;
	}
	// End:0x2F5
	if(GetPlayerInfo())
	{
		MinDistFromViewSq = 2147483648.0000000;
		PlayerIdx = 0;
		J0xBC:

		// End:0x2C9 [Loop If]
		if(PlayerIdx < PlayerInfo.Length)
		{
			DistSq = VSizeSq(Candidate.Location - PlayerInfo[PlayerIdx].ViewLocation);
			MinDistFromViewSq = FMin(DistSq, MinDistFromViewSq);
			// End:0x2BB
			if(DistSq < Item.MaxSpawnDistSq)
			{
				DestDotView = Normal(Candidate.Location - PlayerInfo[PlayerIdx].ViewLocation) Dot Vector(PlayerInfo[PlayerIdx].ViewRotation);
				// End:0x2BB
				if((DistSq < Item.MinBehindSpawnDistSq) || DestDotView > 0.7000000)
				{
					HitActor = Trace(HitLocation, HitNormal, Candidate.Location + (HeadVisibilityOffset * vect(0.0000000, 0.0000000, 1.0000000)), PlayerInfo[PlayerIdx].ViewLocation, false,,, 1);
					// End:0x2BB
					if(HitActor == none)
					{
						return false;
					}
				}
			}
			PlayerIdx++;
			// [Loop Continue]
			goto J0xBC;
		}
		// End:0x2F5
		if(MinDistFromViewSq < Item.MaxSpawnDistSq)
		{
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

// Export UGameCrowdPopulationManager::execSpawnAgentByIdx(FFrame&, void* const)
native function GameCrowdAgent SpawnAgentByIdx(int SpawnerIdx, GameCrowdDestination SpawnLoc);

// Export UGameCrowdPopulationManager::execSpawnAgent(FFrame&, void* const)
native function GameCrowdAgent SpawnAgent(out CrowdSpawnInfoItem Item, GameCrowdDestination SpawnLoc);

// Export UGameCrowdPopulationManager::execWarmup(FFrame&, void* const)
native function bool Warmup(out CrowdSpawnInfoItem Item, int WarmupNum);

event GameCrowdAgent CreateNewAgent(out CrowdSpawnInfoItem Item, GameCrowdDestination SpawnLoc, GameCrowdAgent AgentTemplate, GameCrowdGroup NewGroup)
{
	local GameCrowdAgent Agent;
	local Rotator SpawnRot;
	local Vector SpawnPos;
	local int I;

	GameCrowdSpawnInterface(SpawnLoc).GetSpawnPosition(none, SpawnPos, SpawnRot);
	// End:0x4D
	if(!GetPlayerInfo())
	{
		return none;
	}
	Agent = Spawn(AgentTemplate.Class,,, SpawnPos, SpawnRot, AgentTemplate);
	Agent.SetLighting(Item.bEnableCrowdLightEnvironment, Item.AgentLightingChannel, Item.bCastShadows);
	// End:0x154
	if(Item.bForceObstacleChecking)
	{
		Agent.bCheckForObstacles = true;
	}
	// End:0x195
	if(Item.bForceNavMeshPathing)
	{
		Agent.bUseNavMeshPathing = true;
	}
	// End:0x1F6
	if(SpawnLoc.bWillBeVisible)
	{
		Agent.bPreferVisibleDestinationOnSpawn = Agent.bPreferVisibleDestination;
	}
	Agent.MySpawner = GameCrowdSpawnerInterface(Item.SeqSpawner);
	Item.ActiveAgents[Item.ActiveAgents.Length] = Agent;
	Agent.InitializeAgent(SpawnLoc, PlayerInfo, AgentTemplate, NewGroup, (Item.AgentWarmupTime * 2.0000000) * FRand(), Item.AgentWarmupTime > 0.0000000, true);
	I = 0;
	J0x317:

	// End:0x3F0 [Loop If]
	if(I < Item.AgentArchetypes.Length)
	{
		// End:0x3E2
		if(GameCrowdAgent(Item.AgentArchetypes[I].AgentArchetype) == Agent.MyArchetype)
		{
			Item.AgentArchetypes[I].CurrSpawned++;
		}
		I++;
		// [Loop Continue]
		goto J0x317;
	}
	return Agent;
	//return ReturnValue;	
}

defaultproperties
{
	CloudSpawnInfo=(SeqSpawner=none,bSpawningActive=false,SpawnRate=0.0000000,SpawnNum=0,Remainder=0.0000000,ActiveAgents=none,AgentArchetypes=none,AgentFrequencySum=0.0000000,MaxSpawnDist=0.0000000,MaxSpawnDistSq=0.0000000,MinBehindSpawnDist=0.0000000,MinBehindSpawnDistSq=0.0000000,AgentWarmupTime=3.0000000,bForceObstacleChecking=false,bForceNavMeshPathing=false,bEnableCrowdLightEnvironment=false,bCastShadows=false,AgentLightingChannel=(bInitialized=false,BSP=false,Static=false,Dynamic=false,CompositeDynamic=false,Skybox=false,Unnamed_1=false,Unnamed_2=false,Unnamed_3=false,Unnamed_4=false,Unnamed_5=false,Unnamed_6=false,Cinematic_1=false,Cinematic_2=false,Cinematic_3=false,Cinematic_4=false,Cinematic_5=false,Cinematic_6=false,Cinematic_7=false,Cinematic_8=false,Cinematic_9=false,Cinematic_10=false,Gameplay_1=false,Gameplay_2=false,Gameplay_3=false,Gameplay_4=false,Crowd=false),NumAgentsToTickPerFrame=0,LastAgentTickedIndex=0,PotentialSpawnPoints=none,SpawnPrioritizationInterval=0.4000000,PrioritizationIndex=0,PrioritizationUpdateIndex=0,PrioritizedSpawnPoints=none,PlayerPositionPredictionTime=0.0000000)
	SplitScreenNumReduction=0.5000000
	PlayerPositionPredictionTime=5.0000000
	HeadVisibilityOffset=40.0000000
	NavigationHandleClass=Class'Engine.NavigationHandle'
	bHidden=true
	bSkipActorPropertyReplication=true
	bOnlyDirtyReplication=true
	NetUpdateFrequency=10.0000000
}