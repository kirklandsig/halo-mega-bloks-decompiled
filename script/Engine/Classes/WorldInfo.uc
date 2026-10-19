class WorldInfo extends ZoneInfo
	native
	nativereplication
	config(Game)
	notplaceable
	dependson(PostProcessEffect, MusicTrackDataStructures);

const MAX_BOOKMARK_NUMBER = 10;
const MAX_INSTANCES_PER_CLASS = 5;

enum ENetMode
{
	NM_Standalone,                  // 0
	NM_DedicatedServer,             // 1
	NM_ListenServer,                // 2
	NM_Client,                      // 3
	NM_MAX                          // 4
};

enum EConsoleType
{
	CONSOLE_Any,                    // 0
	CONSOLE_Xbox360,                // 1
	CONSOLE_PS3,                    // 2
	CONSOLE_Mobile,                 // 3
	CONSOLE_IPhone,                 // 4
	CONSOLE_Android,                // 5
	CONSOLE_WiiU,                   // 6
	CONSOLE_Flash,                  // 7
	CONSOLE_MAX                     // 8
};

enum EVisibilityAggressiveness
{
	VIS_LeastAggressive,            // 0
	VIS_ModeratelyAggressive,       // 1
	VIS_MostAggressive,             // 2
	VIS_Max                         // 3
};

enum EPreferredLightmapType
{
	EPLT_Default,                   // 0
	EPLT_Directional,               // 1
	EPLT_Simple,                    // 2
	EPLT_MAX                        // 3
};

enum EHostMigrationProgress
{
	HostMigration_None,             // 0
	HostMigration_FindingNewHost,   // 1
	HostMigration_MigratingAsHost,  // 2
	HostMigration_MigratingAsClient,// 3
	HostMigration_ClientTravel,     // 4
	HostMigration_HostReadyToTravel,// 5
	HostMigration_Failed,           // 6
	HostMigration_MAX               // 7
};

struct native NetViewer
{
	var PlayerController InViewer;
	var Actor Viewer;
	var Vector ViewLocation;
	var Vector ViewDir;

	structdefaultproperties
	{
		InViewer=none
		Viewer=none
		ViewLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		ViewDir=(X=0.0000000,Y=0.0000000,Z=0.0000000)
	}
};

struct native CompartmentRunList
{
	var bool RigidBody;
	var bool Fluid;
	var bool Cloth;
	var bool SoftBody;

	structdefaultproperties
	{
		RigidBody=true
		Fluid=true
		Cloth=true
		SoftBody=true
	}
};

struct native PhysXSimulationProperties
{
	var bool bUseHardware;
	var bool bFixedTimeStep;
	var float TimeStep;
	var int MaxSubSteps;

	structdefaultproperties
	{
		bUseHardware=false
		bFixedTimeStep=false
		TimeStep=0.0200000
		MaxSubSteps=5
	}
};

struct native PhysXSceneProperties
{
	var editinline PhysXSimulationProperties PrimaryScene;
	var editinline PhysXSimulationProperties CompartmentRigidBody;
	var editinline PhysXSimulationProperties CompartmentFluid;
	var editinline PhysXSimulationProperties CompartmentCloth;
	var editinline PhysXSimulationProperties CompartmentSoftBody;

	structdefaultproperties
	{
		PrimaryScene=(bUseHardware=false,bFixedTimeStep=false,TimeStep=0.0200000,MaxSubSteps=5)
		CompartmentRigidBody=(bUseHardware=false,bFixedTimeStep=false,TimeStep=0.0200000,MaxSubSteps=2)
		CompartmentFluid=(bUseHardware=true,bFixedTimeStep=false,TimeStep=0.0200000,MaxSubSteps=1)
		CompartmentCloth=(bUseHardware=true,bFixedTimeStep=true,TimeStep=0.0200000,MaxSubSteps=2)
		CompartmentSoftBody=(bUseHardware=true,bFixedTimeStep=true,TimeStep=0.0200000,MaxSubSteps=2)
	}
};

struct native ApexModuleDestructibleSettings
{
	var int MaxChunkIslandCount;
	var int MaxShapeCount;
	var int MaxRrbActorCount;
	var float MaxChunkSeparationLOD;
	var bool bOverrideMaxChunkSeparationLOD;

	structdefaultproperties
	{
		MaxChunkIslandCount=-1
		MaxShapeCount=-1
		MaxRrbActorCount=-1
		MaxChunkSeparationLOD=1.0000000
		bOverrideMaxChunkSeparationLOD=false
	}
};

struct native PhysXEmitterVerticalProperties
{
	var bool bDisableLod;
	var int ParticlesLodMin;
	var int ParticlesLodMax;
	var int PacketsPerPhysXParticleSystemMax;
	var bool bApplyCylindricalPacketCulling;
	var float SpawnLodVsFifoBias;

	structdefaultproperties
	{
		bDisableLod=true
		ParticlesLodMin=0
		ParticlesLodMax=15000
		PacketsPerPhysXParticleSystemMax=500
		bApplyCylindricalPacketCulling=true
		SpawnLodVsFifoBias=1.0000000
	}
};

struct native PhysXVerticalProperties
{
	var editinline PhysXEmitterVerticalProperties Emitters;

	structdefaultproperties
	{
		Emitters=(bDisableLod=true,ParticlesLodMin=0,ParticlesLodMax=15000,PacketsPerPhysXParticleSystemMax=500,bApplyCylindricalPacketCulling=true,SpawnLodVsFifoBias=1.0000000)
	}
};

struct native WorldFractureSettings
{
	var float ChanceOfPhysicsChunkOverride;
	var bool bEnableChanceOfPhysicsChunkOverride;
	var bool bLimitExplosionChunkSize;
	var float MaxExplosionChunkSize;
	var bool bLimitDamageChunkSize;
	var float MaxDamageChunkSize;
	var int MaxNumFacturedChunksToSpawnInAFrame;
	var float FractureExplosionVelScale;

	structdefaultproperties
	{
		ChanceOfPhysicsChunkOverride=0.0000000
		bEnableChanceOfPhysicsChunkOverride=false
		bLimitExplosionChunkSize=false
		MaxExplosionChunkSize=0.0000000
		bLimitDamageChunkSize=false
		MaxDamageChunkSize=0.0000000
		MaxNumFacturedChunksToSpawnInAFrame=0
		FractureExplosionVelScale=0.0000000
	}
};

struct native transient ScreenMessageString
{
	var init transient QWord Key;
	var init transient string ScreenMessage;
	var init transient Color DisplayColor;
	var init transient float TimeToDisplay;
	var init transient float CurrentTimeDisplayed;

	structdefaultproperties
	{
		Key=()
		ScreenMessage=""
		DisplayColor=(R=0,G=0,B=0,A=0)
		TimeToDisplay=0.0000000
		CurrentTimeDisplayed=0.0000000
	}
};

struct native LightmassWorldInfoSettings
{
	var float StaticLightingLevelScale;
	var int NumIndirectLightingBounces;
	var Color EnvironmentColor;
	var float EnvironmentIntensity;
	var bool bEnableAdvancedEnvironmentColor;
	var Color EnvironmentSunColor;
	var float EnvironmentSunIntensity;
	var float EnvironmentLightTerminatorAngle;
	var Vector EnvironmentLightDirection;
	var float EmissiveBoost;
	var float DiffuseBoost;
	var float SpecularBoost;
	var float IndirectNormalInfluenceBoost;
	var bool bUseAmbientOcclusion;
	var bool bEnableImageReflectionShadowing;
	var float DirectIlluminationOcclusionFraction;
	var float IndirectIlluminationOcclusionFraction;
	var float OcclusionExponent;
	var float FullyOccludedSamplesFraction;
	var float MaxOcclusionDistance;
	var bool bVisualizeMaterialDiffuse;
	var bool bVisualizeAmbientOcclusion;
	var bool bCompressShadowmap;

	structdefaultproperties
	{
		StaticLightingLevelScale=1.0000000
		NumIndirectLightingBounces=3
		EnvironmentColor=(R=0,G=0,B=0,A=0)
		EnvironmentIntensity=1.0000000
		bEnableAdvancedEnvironmentColor=false
		EnvironmentSunColor=(R=0,G=0,B=0,A=0)
		EnvironmentSunIntensity=1.0000000
		EnvironmentLightTerminatorAngle=90.0000000
		EnvironmentLightDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		EmissiveBoost=1.0000000
		DiffuseBoost=5.0000000
		SpecularBoost=1.0000000
		IndirectNormalInfluenceBoost=0.3000000
		bUseAmbientOcclusion=false
		bEnableImageReflectionShadowing=false
		DirectIlluminationOcclusionFraction=0.5000000
		IndirectIlluminationOcclusionFraction=1.0000000
		OcclusionExponent=1.0000000
		FullyOccludedSamplesFraction=1.0000000
		MaxOcclusionDistance=200.0000000
		bVisualizeMaterialDiffuse=false
		bVisualizeAmbientOcclusion=false
		bCompressShadowmap=false
	}
};

struct native NavMeshPathConstraintCacheDatum
{
	var int ListIdx;
	var NavMeshPathConstraint List[5];

	structdefaultproperties
	{
		ListIdx=0
		List[0]=none
		List[1]=none
		List[2]=none
		List[3]=none
		List[4]=none
	}
};

struct native NavMeshPathGoalEvaluatorCacheDatum
{
	var int ListIdx;
	var NavMeshPathGoalEvaluator List[5];

	structdefaultproperties
	{
		ListIdx=0
		List[0]=none
		List[1]=none
		List[2]=none
		List[3]=none
		List[4]=none
	}
};

struct native HostMigrationState
{
	var WorldInfo.EHostMigrationProgress HostMigrationProgress;
	var float HostMigrationElapsedTime;
	var float HostMigrationTravelCountdown;
	var string HostMigrationTravelURL;
	var bool bHostMigrationEnabled;

	structdefaultproperties
	{
		HostMigrationProgress=HostMigration_None
		HostMigrationElapsedTime=0.0000000
		HostMigrationTravelCountdown=0.0000000
		HostMigrationTravelURL=""
		bHostMigrationEnabled=false
	}
};

var config PostProcessSettings DefaultPostProcessSettings;
var PostProcessChain WorldPostProcessChain;
var config bool bPersistPostProcessToNextLevel;
var bool bFogEnabled;
var bool bBumpOffsetEnabled;
var bool bUseGammaCorrection;
var bool bMapNeedsLightingFullyRebuilt;
var bool bMapHasMultipleDominantLightsAffectingOnePrimitive;
var bool bMapHasPathingErrors;
var bool bRequestedBlockOnAsyncLoading;
var bool bBegunPlay;
var bool bPlayersOnly;
var bool bPlayersOnlyPending;
var bool bSuspendAI;
var transient bool bDropDetail;
var transient bool bAggressiveLOD;
var bool bStartup;
var bool bPathsRebuilt;
var bool bHasPathNodes;
var const transient bool bIsMenuLevel;
var editoronly const transient bool bDebugPauseExecution;
var editoronly const transient bool bDebugStepExecution;
var transient bool bUseConsoleInput;
var bool bMinimizeBSPSections;
var bool bNoDefaultInventoryForPlayer;
var bool bNoPathWarnings;
var config bool bNoMobileMapWarnings;
var bool bHighPriorityLoading;
var bool bHighPriorityLoadingLocal;
var bool bUseProcBuildingRulesetOverride;
var bool bSupportDoubleBufferedPhysics;
var bool bPhysicsIgnoreDeltaTime;
var private config bool bEnableChanceOfPhysicsChunkOverride;
var private config bool bLimitExplosionChunkSize;
var private config bool bLimitDamageChunkSize;
var bool bPrecomputeVisibility;
var bool bPlaceCellsOnSurfaces;
var globalconfig bool bAllowTemporalAA;
var editoronly bool bUseGlobalIllumination;
var bool bForceNoPrecomputedLighting;
var bool bHaveActiveCrowd;
var config bool bAllowHostMigration;
var bool bGameplayFramePause;
var config float SquintModeKernelSize;
var noimport const transient PostProcessVolume HighestPriorityPostProcessVolume;
var config ReverbSettings DefaultReverbSettings;
var config InteriorSettings DefaultAmbientZoneSettings;
var float FogStart;
var float FogEnd;
var Color FogColor;
var float BumpEnd;
var noimport const transient ReverbVolume HighestPriorityReverbVolume;
var noimport const transient array<MassiveLODOverrideVolume> MassiveLODOverrideVolumes;
var noimport const transient array<PortalVolume> PortalVolumes;
var noimport const transient array<EnvironmentVolume> EnvironmentVolumes;
var const editconst editinline array<editconst editinline LevelStreaming> StreamingLevels;
var transient Double LastTimeUnbuiltLightingWasEncountered;
var float TimeDilation;
var float DemoPlayTimeDilation;
var transient float TimeSeconds;
var transient float RealTimeSeconds;
var transient float AudioTimeSeconds;
var const transient float DeltaSeconds;
var transient float PauseDelay;
var transient float RealTimeToUnPause;
var PlayerReplicationInfo Pauser;
var Texture2D DefaultTexture;
var Texture2D WireframeTexture;
var Texture2D WhiteSquareTexture;
var Texture2D LargeVertex;
var Texture2D BSPVertex;
var array<string> DeferredExecs;
var transient GameReplicationInfo GRI;
var WorldInfo.ENetMode NetMode;
var Actor.ETravelType NextTravelType;
var WorldInfo.EVisibilityAggressiveness VisibilityAggressiveness;
var WorldInfo.EPreferredLightmapType PreferredLightmapType;
var editconst EngineTypes.ELightingBuildQuality LevelLightingQuality;
var string ComputerName;
var string EngineVersion;
var string MinNetVersion;
var GameInfo Game;
var float StallZ;
var transient float WorldGravityZ;
var const globalconfig float DefaultGravityZ;
var float GlobalGravityZ;
var globalconfig float RBPhysicsGravityScaling;
var private const transient NavigationPoint NavigationPointList;
var private const Controller ControllerList;
var const Pawn PawnList;
var const Actor VehicleList;
var const transient CoverLink CoverList;
var private const transient Pylon PylonList;
var float MoveRepSize;
var const array<NetViewer> ReplicationViewers;
var string NextURL;
var float NextSwitchCountdown;
var int PackedLightAndShadowMapTextureSize;
var Vector DefaultColorScale;
var Class<GameInfo> DefaultGameType;
var array< Class<GameInfo> > GameTypesSupportedOnThisMap;
var const editconst array<editconst Object> ClientDestroyedActorContent;
var const transient array<name> PreparingLevelNames;
var const transient name CommittedPersistentLevelName;
var ObjectReferencer PersistentMapForcedObjects;
var export editinline transient AudioComponent MusicComp;
var transient MusicTrackStruct CurrentMusicTrack;
var repnotify transient MusicTrackStruct ReplicatedMusicTrack;
var const localized string Title;
var string Author;
var protected export editinline MapInfo MyMapInfo;
var globalconfig string EmitterPoolClassPath;
var transient EmitterPool MyEmitterPool;
var globalconfig string DecalManagerClassPath;
var transient DecalManager MyDecalManager;
var globalconfig string FractureManagerClassPath;
var transient FractureManager MyFractureManager;
var globalconfig string ParticleEventManagerClassPath;
var transient ParticleEventManager MyParticleEventManager;
var ProcBuildingRuleset ProcBuildingRulesetOverride;
var float MaxPhysicsDeltaTime;
var config int MaxPhysicsSubsteps;
var editinline PhysXSceneProperties PhysicsProperties;
var array<CompartmentRunList> CompartmentRunFrames;
var float DefaultSkinWidth;
var float ApexLODResourceBudget;
var float ApexDestructionLODResourceValue;
var float ApexClothingLODResourceValue;
var ApexModuleDestructibleSettings DestructibleSettings;
var PhysicsLODVerticalEmitter EmitterVertical;
var editinline PhysXVerticalProperties VerticalProperties;
var private native array<Pointer> WorldAttractors;
var private config float ChanceOfPhysicsChunkOverride;
var private config float MaxExplosionChunkSize;
var private config float MaxDamageChunkSize;
var private config float FractureExplosionVelScale;
var private int MaxNumFacturedChunksToSpawnInAFrame;
var transient int NumFacturedChunksSpawnedThisFrame;
var config float FracturedMeshWeaponDamage;
var int VisibilityCellSize;
var float CharacterLitIndirectBrightness;
var float CharacterLitIndirectContrastFactor;
var float CharacterShadowedIndirectBrightness;
var float CharacterShadowedIndirectContrastFactor;
var float CharacterLightingContrastFactor;
var Texture2D ImageReflectionEnvironmentTexture;
var LinearColor ImageReflectionEnvironmentColor;
var float ImageReflectionEnvironmentRotation;
var native transient Map_Mirror ScreenMessages;
var native transient array<ScreenMessageString> PriorityScreenMessages;
var LightmassWorldInfoSettings LightmassSettings;
var native map{VOID,VOID} NavMeshPathConstraintCache;
var native map{VOID,VOID} NavMeshPathGoalEvaluatorCache;
var CrowdPopulationManagerBase PopulationManager;
var const transient HostMigrationState PeerHostMigration;
var config float HostMigrationTimeout;
var transient PhysicsVolume FirstPhysicsVolume;
var globalconfig string GwNavDefaultWorldPath;
var editinlineuse Object GwNavWorldObject;

replication
{
	// Pos:0x000
	if(bNetDirty && Role == ROLE_Authority)
		Pauser, ReplicatedMusicTrack, 
		TimeDilation, WorldGravityZ, 
		bHighPriorityLoading;
}

// Export UWorldInfo::execReleaseCachedConstraintsAndEvaluators(FFrame&, void* const)
native function ReleaseCachedConstraintsAndEvaluators();

// Export UWorldInfo::execGetNavMeshPathConstraintFromCache(FFrame&, void* const)
native function NavMeshPathConstraint GetNavMeshPathConstraintFromCache(Class<NavMeshPathConstraint> ConstraintClass, NavigationHandle Requestor);

// Export UWorldInfo::execGetNavMeshPathGoalEvaluatorFromCache(FFrame&, void* const)
native function NavMeshPathGoalEvaluator GetNavMeshPathGoalEvaluatorFromCache(Class<NavMeshPathGoalEvaluator> GoalEvalClass, NavigationHandle Requestor);

simulated event ReplicatedEvent(name VarName)
{
	// End:0x2A
	if(VarName == 'ReplicatedMusicTrack')
	{
		UpdateMusicTrack(ReplicatedMusicTrack);
	}
	super(Actor).ReplicatedEvent(VarName);
	//return;	
}

// Export UWorldInfo::execAddOnScreenDebugMessage(FFrame&, void* const)
native final function AddOnScreenDebugMessage(int Key, float TimeToDisplay, Color DisplayColor, string DebugMessage);

// Export UWorldInfo::execIsMenuLevel(FFrame&, void* const)
native static final function bool IsMenuLevel(optional string MapName);

// Export UWorldInfo::execUpdateMusicTrack(FFrame&, void* const)
native final function UpdateMusicTrack(MusicTrackStruct NewMusicTrack);

// Export UWorldInfo::execGetGravityZ(FFrame&, void* const)
native function float GetGravityZ();

// Export UWorldInfo::execGetGameSequence(FFrame&, void* const)
native final simulated function Sequence GetGameSequence();

// Export UWorldInfo::execGetAllRootSequences(FFrame&, void* const)
native final simulated function array<Sequence> GetAllRootSequences();

// Export UWorldInfo::execSetLevelRBGravity(FFrame&, void* const)
native final function SetLevelRBGravity(Vector NewGrav);

// Export UWorldInfo::execGetLocalURL(FFrame&, void* const)
native simulated function string GetLocalURL();

// Export UWorldInfo::execIsDemoBuild(FFrame&, void* const)
native static final simulated function bool IsDemoBuild();

// Export UWorldInfo::execIsConsoleBuild(FFrame&, void* const)
native static final simulated function bool IsConsoleBuild(optional WorldInfo.EConsoleType ConsoleType = 0);

// Export UWorldInfo::execIsWithGFx(FFrame&, void* const)
native static final simulated function bool IsWithGFx();

// Export UWorldInfo::execIsPlayInEditor(FFrame&, void* const)
native static final simulated function bool IsPlayInEditor();

// Export UWorldInfo::execIsPlayInPreview(FFrame&, void* const)
native static final simulated function bool IsPlayInPreview();

// Export UWorldInfo::execIsPlayInMobilePreview(FFrame&, void* const)
native static final simulated function bool IsPlayInMobilePreview();

// Export UWorldInfo::execForceGarbageCollection(FFrame&, void* const)
native final simulated function ForceGarbageCollection(optional bool bFullPurge);

// Export UWorldInfo::execVerifyNavList(FFrame&, void* const)
native final simulated function VerifyNavList();

// Export UWorldInfo::execGetAddressURL(FFrame&, void* const)
native simulated function string GetAddressURL();

simulated function Class<GameInfo> GetGameClass()
{
	// End:0x58
	if(WorldInfo.Game != none)
	{
		return WorldInfo.Game.Class;
	}
	// End:0xAC
	if((GRI != none) && GRI.GameClass != none)
	{
		return GRI.GameClass;
	}
	return none;
	//return ReturnValue;	
}

simulated event ServerTravel(string URL, optional bool bAbsolute, optional bool bShouldSkipGameNotify)
{
	// End:0x43
	if(InStr(URL, "%") >= 0)
	{
		LogInternal("URL Contains illegal character '%'.");
		return;
	}
	// End:0x9E
	if(((InStr(URL, ":") >= 0) || InStr(URL, "/") >= 0) || InStr(URL, "\\") >= 0)
	{
		LogInternal("URL blocked");
		return;
	}
	// End:0xFE
	if((Game != none) && Game.bHasNetworkError)
	{
		LogInternal("Not traveling because of network error");
		return;
	}
	NextTravelType = ((bAbsolute) ? 0 : 2);
	// End:0x1C0
	if((NextURL == "") && !IsInSeamlessTravel() || bShouldSkipGameNotify)
	{
		NextURL = URL;
		// End:0x1B1
		if(Game != none)
		{
			// End:0x1AE
			if(!bShouldSkipGameNotify)
			{
				Game.ProcessServerTravel(URL, bAbsolute);
			}			
		}
		else
		{
			NextSwitchCountdown = 0.0000000;
		}
	}
	//return;	
}

function ThisIsNeverExecuted(DefaultPhysicsVolume P)
{
	P = none;
	//return;	
}

simulated function PreBeginPlay()
{
	local Class<EmitterPool> PoolClass;
	local Class<DecalManager> DecalManagerClass;
	local Class<FractureManager> FractureManagerClass;
	local Class<ParticleEventManager> ParticleEventManagerClass;

	super(Actor).PreBeginPlay();
	// End:0x26F
	if((WorldInfo.NetMode != NM_DedicatedServer) && IsInPersistentLevel())
	{
		// End:0xCE
		if(EmitterPoolClassPath != "")
		{
			PoolClass = Class<EmitterPool>(DynamicLoadObject(EmitterPoolClassPath, Class'Core.Class'));
			// End:0xCE
			if(PoolClass != none)
			{
				MyEmitterPool = Spawn(PoolClass, self,, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
			}
		}
		// End:0x159
		if(DecalManagerClassPath != "")
		{
			DecalManagerClass = Class<DecalManager>(DynamicLoadObject(DecalManagerClassPath, Class'Core.Class'));
			// End:0x159
			if(DecalManagerClass != none)
			{
				MyDecalManager = Spawn(DecalManagerClass, self,, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
			}
		}
		// End:0x1E4
		if(FractureManagerClassPath != "")
		{
			FractureManagerClass = Class<FractureManager>(DynamicLoadObject(FractureManagerClassPath, Class'Core.Class'));
			// End:0x1E4
			if(FractureManagerClass != none)
			{
				MyFractureManager = Spawn(FractureManagerClass, self,, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
			}
		}
		// End:0x26F
		if(ParticleEventManagerClassPath != "")
		{
			ParticleEventManagerClass = Class<ParticleEventManager>(DynamicLoadObject(ParticleEventManagerClassPath, Class'Core.Class'));
			// End:0x26F
			if(ParticleEventManagerClass != none)
			{
				MyParticleEventManager = Spawn(ParticleEventManagerClass, self,, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0));
			}
		}
	}
	//return;	
}

simulated function PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	// End:0x24
	if(IsConsoleBuild())
	{
		bUseConsoleInput = true;
	}
	//return;	
}

function Reset()
{
	super(Actor).Reset();
	//return;	
}

// Export UWorldInfo::execAllNavigationPoints(FFrame&, void* const)
native final iterator function AllNavigationPoints(Class<NavigationPoint> BaseClass, out NavigationPoint N);

// Export UWorldInfo::execRadiusNavigationPoints(FFrame&, void* const)
native final iterator function RadiusNavigationPoints(Class<NavigationPoint> BaseClass, out NavigationPoint N, Vector Point, float Radius);

// Export UWorldInfo::execNavigationPointCheck(FFrame&, void* const)
native final function NavigationPointCheck(Vector Point, Vector Extent, optional out array<NavigationPoint> Navs, optional out array<ReachSpec> Specs);

// Export UWorldInfo::execAllControllers(FFrame&, void* const)
native final iterator function AllControllers(Class<Controller> BaseClass, out Controller C);

// Export UWorldInfo::execAllPawns(FFrame&, void* const)
native final iterator function AllPawns(Class<Pawn> BaseClass, out Pawn P, optional Vector TestLocation, optional float TestRadius);

// Export UWorldInfo::execAllClientConnections(FFrame&, void* const)
native final iterator function AllClientConnections(out Player ClientConnection, out int ClientIP, out int ClientPort);

// Export UWorldInfo::execNotifyMatchStarted(FFrame&, void* const)
native final function NotifyMatchStarted(optional bool bShouldActivateLevelStartupEvents = true, optional bool bShouldActivateLevelBeginningEvents = true, optional bool bShouldActivateLevelLoadedEvents = false);

// Export UWorldInfo::execPrepareMapChange(FFrame&, void* const)
native final function PrepareMapChange(const out array<name> LevelNames);

// Export UWorldInfo::execIsPreparingMapChange(FFrame&, void* const)
native final function bool IsPreparingMapChange();

// Export UWorldInfo::execIsMapChangeReady(FFrame&, void* const)
native final function bool IsMapChangeReady();

// Export UWorldInfo::execCancelPendingMapChange(FFrame&, void* const)
native final function CancelPendingMapChange();

// Export UWorldInfo::execCommitMapChange(FFrame&, void* const)
native final function CommitMapChange();

// Export UWorldInfo::execSeamlessTravel(FFrame&, void* const)
native final function SeamlessTravel(string URL, optional bool bAbsolute, init optional Guid MapPackageGuid);

// Export UWorldInfo::execIsInSeamlessTravel(FFrame&, void* const)
native final function bool IsInSeamlessTravel();

// Export UWorldInfo::execSetSeamlessTravelMidpointPause(FFrame&, void* const)
native final function SetSeamlessTravelMidpointPause(bool bNowPaused);

// Export UWorldInfo::execGetMapInfo(FFrame&, void* const)
native final function MapInfo GetMapInfo();

// Export UWorldInfo::execSetMapInfo(FFrame&, void* const)
native final function SetMapInfo(MapInfo NewMapInfo);

// Export UWorldInfo::execGetMapName(FFrame&, void* const)
native final function string GetMapName(optional bool bIncludePrefix);

// Export UWorldInfo::execGetDetailMode(FFrame&, void* const)
native final function Scene.EDetailMode GetDetailMode();

// Export UWorldInfo::execIsRecordingDemo(FFrame&, void* const)
native final function bool IsRecordingDemo();

// Export UWorldInfo::execIsPlayingDemo(FFrame&, void* const)
native final function bool IsPlayingDemo();

// Export UWorldInfo::execGetDemoFrameInfo(FFrame&, void* const)
native final function GetDemoFrameInfo(optional out int CurrentFrame, optional out int TotalFrames);

// Export UWorldInfo::execGetDemoRewindPoints(FFrame&, void* const)
native final function bool GetDemoRewindPoints(out array<int> OutRewindPoints);

// Export UWorldInfo::execDoMemoryTracking(FFrame&, void* const)
native final function DoMemoryTracking();

// Export UWorldInfo::execGetWorldFractureSettings(FFrame&, void* const)
native final function WorldFractureSettings GetWorldFractureSettings();

// Export UWorldInfo::execGetWorldInfo(FFrame&, void* const)
native static final function WorldInfo GetWorldInfo();

// Export UWorldInfo::execFindEnvironmentVolume(FFrame&, void* const)
native final function EnvironmentVolume FindEnvironmentVolume(Vector TestLocation);

simulated event bool CanBeginHostMigration()
{
	local PlayerController PC;

	// End:0x90
	foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		// End:0x8F
		if(PC.IsPrimaryPlayer())
		{
			// End:0x8F
			if(!PC.CanAllPlayersPlayOnline() || PC.BestNextHostPeers.Length == 0)
			{				
				return false;
			}
		}		
	}	
	return true;
	//return ReturnValue;	
}

// Export UWorldInfo::execBeginHostMigration(FFrame&, void* const)
native function bool BeginHostMigration();

simulated event NotifyHostMigrationStateChanged(WorldInfo.EHostMigrationProgress NewState, WorldInfo.EHostMigrationProgress OldState)
{
	local PlayerController PC;

	// End:0x8F
	if((int(OldState) == 0) && int(NewState) != 0)
	{
		// End:0x8E
		foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
		{
			// End:0x8D
			if(PC.IsPrimaryPlayer())
			{
				PC.NotifyHostMigrationStarted();
				// End:0x8E
				break;
			}			
		}		
	}
	//return;	
}

// Export UWorldInfo::execToggleHostMigration(FFrame&, void* const)
native function ToggleHostMigration(bool bEnabled);

// Export UWorldInfo::execClearObjectPools(FFrame&, void* const)
native final function ClearObjectPools();

defaultproperties
{
	DefaultPostProcessSettings=(bOverride_EnableBloom=true,bOverride_EnableDOF=true,bOverride_EnableMotionBlur=true,bOverride_EnableSceneEffect=true,bOverride_AllowAmbientOcclusion=true,bOverride_OverrideRimShaderColor=true,bOverride_Bloom_Scale=true,bOverride_Bloom_Threshold=true,bOverride_Bloom_Tint=true,bOverride_Bloom_ScreenBlendThreshold=true,bOverride_Bloom_InterpolationDuration=true,bOverride_DOF_FalloffExponent=true,bOverride_DOF_BlurKernelSize=true,bOverride_DOF_BlurBloomKernelSize=true,bOverride_DOF_MaxNearBlurAmount=true,bOverride_DOF_MinBlurAmount=false,bOverride_DOF_MaxFarBlurAmount=true,bOverride_DOF_FocusType=true,bOverride_DOF_FocusInnerRadius=true,bOverride_DOF_FocusDistance=true,bOverride_DOF_FocusPosition=true,bOverride_DOF_InterpolationDuration=true,bOverride_DOF_BokehTexture=false,bOverride_MotionBlur_MaxVelocity=false,bOverride_MotionBlur_Amount=false,bOverride_MotionBlur_FullMotionBlur=false,bOverride_MotionBlur_CameraRotationThreshold=false,bOverride_MotionBlur_CameraTranslationThreshold=false,bOverride_MotionBlur_InterpolationDuration=false,bOverride_Scene_Desaturation=true,bOverride_Scene_Colorize=false,bOverride_Scene_TonemapperScale=false,bOverride_Scene_ImageGrainScale=false,bOverride_Scene_HighLights=true,bOverride_Scene_MidTones=true,bOverride_Scene_Shadows=true,bOverride_Scene_InterpolationDuration=true,bOverride_Scene_ColorGradingLUT=false,bOverride_RimShader_Color=true,bOverride_RimShader_InterpolationDuration=true,bOverride_MobileColorGrading=false,bEnableBloom=true,bEnableDOF=false,bEnableMotionBlur=true,bEnableSceneEffect=true,bAllowAmbientOcclusion=true,bOverrideRimShaderColor=false,Bloom_Scale=0.2000000,Bloom_Threshold=1.0000000,Bloom_Tint=(R=255,G=255,B=0,A=255),Bloom_ScreenBlendThreshold=10.0000000,Bloom_InterpolationDuration=1.0000000,DOF_BlurBloomKernelSize=16.0000000,DOF_FalloffExponent=4.0000000,DOF_BlurKernelSize=12.0000000,DOF_MaxNearBlurAmount=0.0000000,DOF_MinBlurAmount=0.0000000,DOF_MaxFarBlurAmount=1.0000000,DOF_FocusType=FOCUS_Distance,DOF_FocusInnerRadius=2000.0000000,DOF_FocusDistance=0.0000000,DOF_FocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),DOF_InterpolationDuration=1.0000000,DOF_BokehTexture=none,MotionBlur_MaxVelocity=1.0000000,MotionBlur_Amount=0.5000000,MotionBlur_FullMotionBlur=true,MotionBlur_CameraRotationThreshold=45.0000000,MotionBlur_CameraTranslationThreshold=10000.0000000,MotionBlur_InterpolationDuration=1.0000000,Scene_Desaturation=0.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_TonemapperScale=1.0000000,Scene_ImageGrainScale=0.0000000,Scene_HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Scene_InterpolationDuration=1.0000000,RimShader_Color=(R=1.0000000,G=0.8277260,B=0.5859730,A=0.4704400),RimShader_InterpolationDuration=1.0000000,ColorGrading_LookupTable=none,ColorGradingLUT=(LUTTextures=none,LUTWeights=none),MobileColorGrading=(TransitionTime=1.0000000,Blend=0.0000000,Desaturation=0.0000000,HighLights=(R=1.0000000,G=0.7000000,B=0.7000000,A=0.7000000),MidTones=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000),Shadows=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000)),MobilePostProcess=(bOverride_Mobile_BlurAmount=false,bOverride_Mobile_TransitionTime=false,bOverride_Mobile_Bloom_Scale=false,bOverride_Mobile_Bloom_Threshold=false,bOverride_Mobile_Bloom_Tint=false,bOverride_Mobile_DOF_Distance=false,bOverride_Mobile_DOF_MinRange=false,bOverride_Mobile_DOF_MaxRange=false,bOverride_Mobile_DOF_NearBlurFactor=false,bOverride_Mobile_DOF_FarBlurFactor=false,Mobile_BlurAmount=16.0000000,Mobile_TransitionTime=1.0000000,Mobile_Bloom_Scale=6.0000000,Mobile_Bloom_Threshold=0.5000000,Mobile_Bloom_Tint=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000),Mobile_DOF_Distance=1500.0000000,Mobile_DOF_MinRange=600.0000000,Mobile_DOF_MaxRange=1200.0000000,Mobile_DOF_NearBlurFactor=1.0000000,Mobile_DOF_FarBlurFactor=1.0000000))
	bPersistPostProcessToNextLevel=true
	bBumpOffsetEnabled=true
	bPlaceCellsOnSurfaces=true
	bAllowTemporalAA=true
	SquintModeKernelSize=128.0000000
	DefaultReverbSettings=(bApplyReverb=true,ReverbType=REVERB_Default,Volume=0.5000000,FadeTime=2.0000000)
	DefaultAmbientZoneSettings=(bIsWorldInfo=true,ExteriorVolume=1.0000000,ExteriorTime=0.5000000,ExteriorLPF=1.0000000,ExteriorLPFTime=0.5000000,InteriorVolume=1.0000000,InteriorTime=0.5000000,InteriorLPF=1.0000000,InteriorLPFTime=0.5000000)
	FogStart=400.0000000
	FogEnd=4000.0000000
	FogColor=(R=128,G=128,B=192,A=255)
	BumpEnd=1000.0000000
	TimeDilation=1.0000000
	DemoPlayTimeDilation=1.0000000
	DefaultTexture=Texture2D'EngineResources.DefaultTexture'
	WhiteSquareTexture=Texture2D'EngineResources.WhiteSquareTexture'
	NextTravelType=TRAVEL_Relative
	LevelLightingQuality=None
	StallZ=1000000.0000000
	DefaultGravityZ=-520.0000000
	RBPhysicsGravityScaling=2.0000000
	MoveRepSize=42.0000000
	PackedLightAndShadowMapTextureSize=1024
	DefaultColorScale=(X=1.0000000,Y=1.0000000,Z=1.0000000)
	CurrentMusicTrack=(TheSoundCue=none,bAutoPlay=false,bPersistentAcrossLevels=false,FadeInTime=5.0000000,FadeInVolumeLevel=1.0000000,FadeOutTime=5.0000000,FadeOutVolumeLevel=0.0000000,MP3Filename="")
	ReplicatedMusicTrack=(TheSoundCue=none,bAutoPlay=false,bPersistentAcrossLevels=false,FadeInTime=5.0000000,FadeInVolumeLevel=1.0000000,FadeOutTime=5.0000000,FadeOutVolumeLevel=0.0000000,MP3Filename="")
	EmitterPoolClassPath="UDKBase.UDKEmitterPool"
	DecalManagerClassPath="UTGame.UTDecalManager"
	FractureManagerClassPath="Engine.FractureManager"
	MaxPhysicsDeltaTime=0.3333333
	MaxPhysicsSubsteps=5
	PhysicsProperties=(PrimaryScene=(bUseHardware=false,bFixedTimeStep=false,TimeStep=0.0200000,MaxSubSteps=5),CompartmentRigidBody=(bUseHardware=false,bFixedTimeStep=false,TimeStep=0.0200000,MaxSubSteps=2),CompartmentFluid=(bUseHardware=true,bFixedTimeStep=false,TimeStep=0.0200000,MaxSubSteps=1),CompartmentCloth=(bUseHardware=true,bFixedTimeStep=true,TimeStep=0.0200000,MaxSubSteps=2),CompartmentSoftBody=(bUseHardware=true,bFixedTimeStep=true,TimeStep=0.0200000,MaxSubSteps=2))
	DefaultSkinWidth=0.0250000
	ApexLODResourceBudget=-1.0000000
	ApexDestructionLODResourceValue=1000.0000000
	ApexClothingLODResourceValue=1000.0000000
	DestructibleSettings=(MaxChunkIslandCount=-1,MaxShapeCount=-1,MaxRrbActorCount=-1,MaxChunkSeparationLOD=1.0000000,bOverrideMaxChunkSeparationLOD=false)
	// Reference: PhysicsLODVerticalEmitter'Engine.Default__WorldInfo.PhysicsLODVerticalEmitter0'
	begin object name="PhysicsLODVerticalEmitter0" class=Engine.PhysicsLODVerticalEmitter
	end object
	EmitterVertical=PhysicsLODVerticalEmitter0
	VerticalProperties=(Emitters=(bDisableLod=true,ParticlesLodMin=0,ParticlesLodMax=15000,PacketsPerPhysXParticleSystemMax=500,bApplyCylindricalPacketCulling=true,SpawnLodVsFifoBias=1.0000000))
	ChanceOfPhysicsChunkOverride=1.0000000
	FractureExplosionVelScale=1.0000000
	MaxNumFacturedChunksToSpawnInAFrame=12
	FracturedMeshWeaponDamage=5.0000000
	VisibilityCellSize=200
	CharacterLitIndirectBrightness=1.0000000
	CharacterLitIndirectContrastFactor=1.0000000
	CharacterShadowedIndirectBrightness=1.0000000
	CharacterShadowedIndirectContrastFactor=1.0000000
	CharacterLightingContrastFactor=1.5000000
	ImageReflectionEnvironmentColor=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000)
	LightmassSettings=(StaticLightingLevelScale=1.0000000,NumIndirectLightingBounces=3,EnvironmentColor=(R=0,G=0,B=0,A=0),EnvironmentIntensity=1.0000000,bEnableAdvancedEnvironmentColor=false,EnvironmentSunColor=(R=0,G=0,B=0,A=0),EnvironmentSunIntensity=1.0000000,EnvironmentLightTerminatorAngle=90.0000000,EnvironmentLightDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000),EmissiveBoost=1.0000000,DiffuseBoost=5.0000000,SpecularBoost=1.0000000,IndirectNormalInfluenceBoost=0.3000000,bUseAmbientOcclusion=false,bEnableImageReflectionShadowing=false,DirectIlluminationOcclusionFraction=0.5000000,IndirectIlluminationOcclusionFraction=1.0000000,OcclusionExponent=1.0000000,FullyOccludedSamplesFraction=1.0000000,MaxOcclusionDistance=200.0000000,bVisualizeMaterialDiffuse=false,bVisualizeAmbientOcclusion=false,bCompressShadowmap=false)
	HostMigrationTimeout=15.0000000
	Components=none
	RemoteRole=ROLE_SimulatedProxy
	bWorldGeometry=true
	bAlwaysRelevant=true
	bMovable=false
	bBlockActors=true
	bHiddenEd=true
}