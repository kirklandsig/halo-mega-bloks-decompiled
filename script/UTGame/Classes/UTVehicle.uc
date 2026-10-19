class UTVehicle extends UDKVehicle
	abstract
	config(GwNavEngine)
	dependson(UTPlayerController);

const UTVEHICLE_UNSET_TEAM = 128;

enum EAIVehiclePurpose
{
	AIP_Offensive,                  // 0
	AIP_Defensive,                  // 1
	AIP_Any,                        // 2
	AIP_MAX                         // 3
};

struct native MaterialList
{
	var array<MaterialInterface> Materials;

	structdefaultproperties
	{
		Materials=none
	}
};

struct native TimePosition
{
	var Vector Position;
	var float Time;

	structdefaultproperties
	{
		Position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		Time=0.0000000
	}
};

var bool bDriverHoldsFlag;
var bool bCanCarryFlag;
var bool bValidLinkTarget;
var bool bEnteringUnlocks;
var bool bHasCustomEntryRadius;
var repnotify bool bKeyVehicle;
var bool bMustBeUpright;
var bool bOverrideAVRiLLocks;
var bool bStickDeflectionThrottle;
var bool bShouldAutoCenterViewPitch;
var bool bHasWeaponBar;
var bool bNeverReset;
var bool bShouldLeaveForCombat;
var bool bDrawHealthOnHUD;
var bool bDriverCastsShadow;
var bool bHasBeenDriven;
var bool bDropDetailWhenDriving;
var bool bLookSteerOnNormalControls;
var bool bLookSteerOnSimpleControls;
var transient bool bUsingLookSteer;
var bool bFindGroundExit;
var bool bRequestedEntryWithFlag;
var bool bInitializedVehicleEffects;
var bool bRagdollDriverOnDarkwalkerHorn;
var bool bHasTurretExplosion;
var bool bPostRenderTraceSucceeded;
var repnotify bool bPlayingSpawnEffect;
var bool bReducedFallingCollisionDamage;
var bool bRotateCameraUnderVehicle;
var bool bNoZSmoothing;
var bool bLimitCameraZLookingUp;
var bool bNoFollowJumpZ;
var bool bFixedCamZ;
var bool bCameraNeverHidesVehicle;
var bool bStopDeathCamera;
var bool bIsConsoleTurning;
var bool bAcceptTurretJump;
var bool bShowDamageDebug;
var bool bStealthVehicle;
var bool bHasEnemyVehicleSound;
var bool bIsNecrisVehicle;
var bool bSpectatedView;
var SoundCue VehicleLockedSound;
var UTVehicle.EAIVehiclePurpose AIPurpose;
var protected repnotify byte LinkedToCount;
var Actor NoPassengerObjective;
var float DeflectionReverseThresh;
var transient PhysicalMaterial DrivingPhysicalMaterial;
var transient PhysicalMaterial DefaultPhysicalMaterial;
var export editinline DynamicLightEnvironmentComponent LightEnvironment;
var float VehicleLostTime;
var float PlayerStartTime;
var float RespawnTime;
var float InitialSpawnDelay;
var float LinkHealMult;
var export editinline AudioComponent LinkedToAudio;
var SoundCue LinkedToCue;
var SoundCue LinkedEndSound;
var float MaxDesireability;
var array<SoundCue> HornSounds;
var float HornAIRadius;
var float LastHornTime;
var int HornIndex;
var float LeftStickDirDeadZone;
var float LookSteerSensitivity;
var float LookSteerDamping;
var float LookSteerDeadZone;
var float ConsoleSteerScale;
var SoundCue LockedOnSound;
var Class<UTDamageType> RanOverDamageType;
var SoundCue RanOverSound;
var int StolenAnnouncementIndex;
var SoundCue StolenSound;
var UTVehicle NextVehicle;
var UTVehicleFactory ParentFactory;
var UTBot Reservation;
var const localized string VehiclePositionString;
var const localized string VehicleNameString;
var ObjectiveAnnouncementInfo NeedToPickUpAnnouncement;
var float TeamBeaconPlayerInfoMaxDist;
var float HUDExtent;
var Class<DamageType> VehicleDrowningDamType;
var Class<UDKExplosionLight> ExplosionLightClass;
var float MaxExplosionLightDistance;
var Emitter DeathExplosion;
var float TimeTilSecondaryVehicleExplosion;
var int ClientHealth;
var array<MaterialInterface> TeamMaterials;
var Class<UTGib_Vehicle> VehiclePieceClass;
var float DamageSmokeThreshold;
var Class<DamageType> ExplosionDamageType;
var float MaxImpactEffectDistance;
var float MaxFireEffectDistance;
var ParticleSystem ExplosionTemplate;
var array<DistanceBasedParticleTemplate> BigExplosionTemplates;
var ParticleSystem SecondaryExplosion;
var name BigExplosionSocket;
var float BurnOutTime;
var float DeadVehicleLifeSpan;
var int DelayedBurnoutCount;
var float ExplosionDamage;
var float ExplosionRadius;
var float ExplosionMomentum;
var float ExplosionInAirAngVel;
var CameraAnim DeathExplosionShake;
var float InnerExplosionShakeRadius;
var float OuterExplosionShakeRadius;
var name TurretScaleControlName;
var name TurretSocketName;
var array<DistanceBasedParticleTemplate> DistanceTurretExplosionTemplates;
var Vector TurretOffset;
var UTVehicleDeathPiece DestroyedTurret;
var StaticMesh DestroyedTurretTemplate;
var float TurretExplosiveForce;
var SoundCue ExplosionSound;
var name BurnTimeParameterName;
var float SpawnRadius;
var SoundCue SpawnInSound;
var SoundCue SpawnOutSound;
var SoundCue BoostPadSound;
var Vector FlagOffset;
var Rotator FlagRotation;
var name FlagBone;
var float MapSize;
var TextureCoordinates IconCoords;
var TextureCoordinates FlipToolTipIconCoords;
var TextureCoordinates EnterToolTipIconCoords;
var TextureCoordinates DropFlagIconCoords;
var TextureCoordinates DropOrbIconCoords;
var int LastHealth;
var float HealthPulseTime;
var Vector TeamBeaconOffset;
var PlayerReplicationInfo PassengerPRI;
var Vector PassengerTeamBeaconOffset;
var Texture2D HudIcons;
var TextureCoordinates HudCoords;
var array<ParticleSystem> SpawnInTemplates;
var array<MaterialList> SpawnMaterialLists;
var name SpawnMaterialParameterName;
var InterpCurveFloat SpawnMaterialParameterCurve;
var array<MaterialInterface> OriginalMaterials;
var float SpawnInTime;
var MaterialInterface BurnOutMaterial[2];
var float CollisionDamageMult;
var float LastCollisionDamageTime;
var float SeatCameraScale;
var float OldCamPosZ;
var float CameraSmoothingFactor;
var float DefaultFOV;
var array<TimePosition> OldPositions;
var float CameraLag;
var Vector CameraOffset;
var float LookForwardDist;
var float MinCameraDistSq;
var Vector OldCameraPosition;
var float DisabledTime;
var float TimeLastDisabled;
var ParticleSystem DisabledTemplate;
var export editinline ParticleSystemComponent DisabledEffectComponent;
var StaticMesh ReferenceMovementMesh;
var float LastEnemyWarningTime;
var array<SoundNodeWave> EnemyVehicleSound;
var array<SoundNodeWave> VehicleDestroyedSound;

replication
{
	// Pos:0x000
	if(bNetDirty)
		LinkedToCount, PassengerPRI, 
		bKeyVehicle, bPlayingSpawnEffect;
}

simulated function PostBeginPlay()
{
	local PlayerController PC;

	super(SVehicle).PostBeginPlay();
	ClientHealth = Health;
	LastHealth = Health;
	// End:0xCD
	if(int(Role) == int(ROLE_Authority))
	{
		// End:0xC0
		if(!bDeleteMe && UTGame(WorldInfo.Game) != none)
		{
			UTGame(WorldInfo.Game).RegisterVehicle(self);
		}
		InitializeSeats();		
	}
	else
	{
		// End:0xFD
		if(Seats.Length > 0)
		{
			Seats[0].SeatPawn = self;
		}
	}
	PreCacheSeatNames();
	InitializeTurrets();
	SetTimer(0.0100000, false, 'InitializeEffects');
	InitializeMorphs();
	// End:0x1A7
	foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		// End:0x1A6
		if(PC.myHUD != none)
		{
			PC.myHUD.AddPostRenderedActor(self);
		}		
	}	
	// End:0x1F4
	if(bKeyVehicle)
	{
		UTMapInfo(WorldInfo.GetMapInfo()).AddKeyVehicle(self);
	}
	// End:0x27D
	if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		UpdateShadowSettings(!Class'Engine.Engine'.static.IsSplitScreen() && int(Class'UTGame.UTPlayerController'.default.PawnShadowMode) == int(2));
		CreateDamageMaterialInstance();
	}
	VehicleEvent('Created');
	//return;	
}

simulated function UpdateShadowSettings(bool bWantShadow)
{
	local bool bNewCastShadow, bNewCastDynamicShadow;

	// End:0x191
	if(Mesh != none)
	{
		bNewCastShadow = default.Mesh.CastShadow && bWantShadow;
		bNewCastDynamicShadow = default.Mesh.bCastDynamicShadow && bWantShadow;
		// End:0x191
		if((bNewCastShadow != Mesh.CastShadow) || bNewCastDynamicShadow != Mesh.bCastDynamicShadow)
		{
			Mesh.CastShadow = bNewCastShadow;
			Mesh.bCastDynamicShadow = bNewCastDynamicShadow;
			// End:0x187
			if(LastRenderTime < (WorldInfo.TimeSeconds - 1.0000000))
			{
				SetTimer(0.1000000 + (FRand() * 0.5000000), false, 'ReattachMesh');				
			}
			else
			{
				ReattachMesh();
			}
		}
	}
	//return;	
}

simulated function ReattachMesh()
{
	DetachComponent(Mesh);
	AttachComponent(Mesh);
	//return;	
}

simulated function CreateDamageMaterialInstance()
{
	DamageMaterialInstance[0] = Mesh.CreateAndSetMaterialInstanceConstant(0);
	//return;	
}

simulated function UpdateLookSteerStatus()
{
	local UTPlayerController UTPC;

	UTPC = UTPlayerController(Controller);
	// End:0xDD
	if((((UTPC == none) || int(UTPC.VehicleControlType) == int(2)) || (int(UTPC.VehicleControlType) == int(1)) && !bLookSteerOnNormalControls) || (int(UTPC.VehicleControlType) == int(0)) && !bLookSteerOnSimpleControls)
	{
		bUsingLookSteer = false;		
	}
	else
	{
		bUsingLookSteer = true;
	}
	//return;	
}

simulated function SetInputs(float InForward, float InStrafe, float InUp)
{
	local bool bReverseThrottle;
	local UTConsolePlayerController ConsolePC;
	local Rotator SteerRot, VehicleRot;
	local Vector SteerDir, VehicleDir, AngVel;
	local float VehicleHeading, SteerHeading, DeltaTargetHeading, Deflection;

	Throttle = InForward;
	Steering = InStrafe;
	Rise = InUp;
	ConsolePC = UTConsolePlayerController(Controller);
	// End:0x4C2
	if((ConsolePC != none) || bLookSteerOnAllPlatforms)
	{
		Steering = FClamp(Steering * ConsoleSteerScale, -1.0000000, 1.0000000);
		UpdateLookSteerStatus();
		// End:0x3FC
		if(bUsingLookSteer && IsHumanControlled())
		{
			Deflection = Sqrt((Throttle * Throttle) + (Steering * Steering));
			// End:0x18A
			if(bStickDeflectionThrottle)
			{
				bReverseThrottle = (Throttle < DeflectionReverseThresh) || (Throttle < 0.0000000) && Abs(Steering) < -Throttle;
				Throttle = Deflection;
				// End:0x18A
				if(bReverseThrottle)
				{
					Throttle *= float(-1);
				}
			}
			VehicleRot.Yaw = Rotation.Yaw;
			VehicleDir = Vector(VehicleRot);
			SteerRot.Yaw = DriverViewYaw;
			SteerDir = Vector(SteerRot);
			VehicleHeading = GetHeadingAngle(VehicleDir);
			SteerHeading = GetHeadingAngle(SteerDir);
			DeltaTargetHeading = FindDeltaAngle(SteerHeading, VehicleHeading);
			// End:0x2BD
			if(DeltaTargetHeading > LookSteerDeadZone)
			{
				Steering = FMin((DeltaTargetHeading - LookSteerDeadZone) * LookSteerSensitivity, 1.0000000);				
			}
			else
			{
				// End:0x309
				if(DeltaTargetHeading < -LookSteerDeadZone)
				{
					Steering = FMax((DeltaTargetHeading + LookSteerDeadZone) * LookSteerSensitivity, -1.0000000);					
				}
				else
				{
					Steering = 0.0000000;
				}
			}
			AngVel = Mesh.BodyInstance.GetUnrealWorldAngularVelocity();
			// End:0x3B7
			if(Abs(DeltaTargetHeading) > LookSteerDeadZone)
			{
				Steering = FClamp(Steering + (AngVel.Z * LookSteerDamping), -1.0000000, 1.0000000);
			}
			// End:0x3F9
			if((Throttle < 0.0000000) && ForwardVel < 0.0000000)
			{
				Steering = -1.0000000 * Steering;
			}			
		}
		else
		{
			// End:0x4C2
			if(bStickDeflectionThrottle)
			{
				bReverseThrottle = (Throttle < DeflectionReverseThresh) || (Throttle < 0.0000000) && Abs(Steering) < -Throttle;
				Deflection = Sqrt((Throttle * Throttle) + (Steering * Steering));
				Throttle = Deflection;
				// End:0x4C2
				if(bReverseThrottle)
				{
					Throttle *= float(-1);
				}
			}
		}
	}
	//return;	
}

simulated event FellOutOfWorld(Class<DamageType> dmgType)
{
	super(Pawn).FellOutOfWorld(dmgType);
	bStopDeathCamera = true;
	//return;	
}

simulated function float GetChargePower()
{
	//return ReturnValue;	
}

simulated function PlaySpawnEffect()
{
	local MaterialInstanceTimeVarying SpawnMaterialInstance;
	local int I;

	// End:0x33B
	if(!IsTimerActive('StopSpawnEffect'))
	{
		bPlayingSpawnEffect = true;
		// End:0x324
		if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
		{
			// End:0xCA
			if(int(Team) < SpawnInTemplates.Length)
			{
				WorldInfo.MyEmitterPool.SpawnEmitter(SpawnInTemplates[int(Team)], Location, Rotation);				
			}
			else
			{
				// End:0x12F
				if(SpawnInTemplates.Length > 0)
				{
					WorldInfo.MyEmitterPool.SpawnEmitter(SpawnInTemplates[0], Location, Rotation);
				}
			}
			// End:0x2FC
			if(int(Team) < SpawnMaterialLists.Length)
			{
				I = 0;
				J0x154:

				// End:0x2FC [Loop If]
				if((I < Mesh.GetNumElements()) && I < SpawnMaterialLists[int(Team)].Materials.Length)
				{
					OriginalMaterials[I] = Mesh.GetMaterial(I);
					SpawnMaterialInstance = new (self) Class'Engine.MaterialInstanceTimeVarying';
					SpawnMaterialInstance.SetParent(SpawnMaterialLists[int(Team)].Materials[I]);
					SpawnMaterialInstance.SetScalarCurveParameterValue(SpawnMaterialParameterName, SpawnMaterialParameterCurve);
					Mesh.SetMaterial(I, SpawnMaterialInstance);
					SpawnMaterialInstance.SetScalarStartTime(SpawnMaterialParameterName, 0.0000000);
					I++;
					// [Loop Continue]
					goto J0x154;
				}
			}
			// End:0x324
			if(SpawnInSound != none)
			{
				PlaySound(SpawnInSound, true);
			}
		}
		SetTimer(SpawnInTime, false, 'StopSpawnEffect');
	}
	//return;	
}

simulated function StopSpawnEffect()
{
	local int I;

	bPlayingSpawnEffect = false;
	I = 0;
	J0x17:

	// End:0x78 [Loop If]
	if(I < OriginalMaterials.Length)
	{
		Mesh.SetMaterial(I, OriginalMaterials[I]);
		I++;
		// [Loop Continue]
		goto J0x17;
	}
	ClearTimer('StopSpawnEffect');
	//return;	
}

function EjectSeat(int SeatIdx)
{
	local UDKVehicleBase VB;

	bShouldEject = true;
	// End:0x29
	if(SeatIdx == 0)
	{
		DriverLeave(true);		
	}
	else
	{
		VB = UDKVehicleBase(Seats[SeatIdx].SeatPawn);
		// End:0xB2
		if(VB != none)
		{
			VB.bShouldEject = true;
			VB.DriverLeave(true);
		}
	}
	//return;	
}

function Class<DamageType> GetRanOverDamageType()
{
	return RanOverDamageType;
	//return ReturnValue;	
}

function DisplayWeaponBar(Canvas Canvas, UTHUD HUD)
{
	//return;	
}

static simulated function DrawKillIcon(Canvas Canvas, float ScreenX, float ScreenY, float HUDScaleX, float HUDScaleY)
{
	local Color CanvasColor;

	LogInternal("### DrawKillIcon");
	CanvasColor = Canvas.DrawColor;
	Canvas.DrawColor = Class'UTGame.UTHUD'.default.BlackColor;
	Canvas.DrawColor.A = CanvasColor.A;
	Canvas.SetPos(ScreenX - float(2), ScreenY - float(2));
	Canvas.DrawTile(Class'UTGame.UTHUD'.default.IconHudTexture, 4.0000000 + (HUDScaleX * float(96)), 4.0000000 + (HUDScaleY * float(64)), default.IconCoords.U, default.IconCoords.V, default.IconCoords.UL, default.IconCoords.VL);
	Canvas.DrawColor = Class'UTGame.UTHUD'.default.WhiteColor;
	Canvas.DrawColor.A = CanvasColor.A;
	Canvas.SetPos(ScreenX, ScreenY);
	Canvas.DrawTile(Class'UTGame.UTHUD'.default.IconHudTexture, HUDScaleX * float(96), HUDScaleY * float(64), default.IconCoords.U, default.IconCoords.V, default.IconCoords.UL, default.IconCoords.VL);
	Canvas.DrawColor = CanvasColor;
	//return;	
}

simulated function RenderMapIcon(UTMapInfo MP, Canvas Canvas, UTPlayerController PlayerOwner, LinearColor FinalColor)
{
	local LinearColor DrawColor;

	DrawColor = MakeLinearColor(0.0000000, 0.0000000, 0.0000000, 0.6000000);
	MP.DrawRotatedTile(Canvas, Class'UTGame.UTHUD'.default.IconHudTexture, HUDLocation, Rotation.Yaw + 16384, MapSize * 1.0500000, IconCoords, DrawColor);
	FinalColor.A = 0.6000000;
	MP.DrawRotatedTile(Canvas, Class'UTGame.UTHUD'.default.IconHudTexture, HUDLocation, Rotation.Yaw + 16384, MapSize, IconCoords, FinalColor);
	//return;	
}

function float AdjustedStrength()
{
	return 0.0000000;
	//return ReturnValue;	
}

event bool ContinueOnFoot()
{
	local UTBot B;

	B = UTBot(Controller);
	// End:0x39
	if(B == none)
	{
		return super(Vehicle).ContinueOnFoot();		
	}
	else
	{
		// End:0x1B9
		if((B.Squad == none) || UTSquadAI(B.Squad).AllowContinueOnFoot(B, self))
		{
			B.NoVehicleGoal = B.RouteGoal;
			// End:0x194
			if((B.RouteCache.Length > 0) && B.RouteCache[0] != none)
			{
				B.DirectionHint = Normal(B.RouteCache[0].Location - Location);
			}
			B.LeaveVehicle(false);
			return true;			
		}
		else
		{
			return false;
		}
	}
	//return ReturnValue;	
}

function bool IsDriverSeat(Vehicle TestSeatPawn)
{
	return Seats[0].SeatPawn == TestSeatPawn;
	//return ReturnValue;	
}

function bool RecommendCharge(UTBot B, Pawn Enemy)
{
	return false;
	//return ReturnValue;	
}

function bool CriticalChargeAttack(UTBot B)
{
	return false;
	//return ReturnValue;	
}

simulated function CreateVehicleEffect(int EffectIndex)
{
	VehicleEffects[EffectIndex].EffectRef = new (self) Class'UTGame.UTParticleSystemComponent';
	// End:0xA7
	if(VehicleEffects[EffectIndex].EffectStartTag != 'BeginPlay')
	{
		VehicleEffects[EffectIndex].EffectRef.bAutoActivate = false;
	}
	// End:0x14F
	if((VehicleEffects[EffectIndex].EffectTemplate_Blue != none) && int(GetTeamNum()) == int(1))
	{
		VehicleEffects[EffectIndex].EffectRef.SetTemplate(VehicleEffects[EffectIndex].EffectTemplate_Blue);		
	}
	else
	{
		VehicleEffects[EffectIndex].EffectRef.SetTemplate(VehicleEffects[EffectIndex].EffectTemplate);
	}
	Mesh.AttachComponentToSocket(VehicleEffects[EffectIndex].EffectRef, VehicleEffects[EffectIndex].EffectSocket);
	//return;	
}

simulated function InitializeEffects()
{
	// End:0x59
	if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && !bInitializedVehicleEffects)
	{
		bInitializedVehicleEffects = true;
		TriggerVehicleEffect('BeginPlay');
	}
	//return;	
}

simulated function SetVehicleEffectParms(name TriggerName, ParticleSystemComponent PSC)
{
	local float Pct;

	// End:0xE5
	if(TriggerName == 'DamageSmoke')
	{
		Pct = float(Health) / float(HealthMax);
		PSC.SetFloatParameter('smokeamount', ((Pct < DamageSmokeThreshold) ? 1.0000000 - Pct : 0.0000000));
		PSC.SetFloatParameter('fireamount', ((Pct < FireDamageThreshold) ? 1.0000000 - Pct : 0.0000000));
	}
	//return;	
}

simulated function TriggerVehicleEffect(name EventTag)
{
	local int I;

	// End:0x323
	if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		I = 0;
		J0x34:

		// End:0x323 [Loop If]
		if(I < VehicleEffects.Length)
		{
			// End:0x277
			if(VehicleEffects[I].EffectStartTag == EventTag)
			{
				// End:0x274
				if(!VehicleEffects[I].bHighDetailOnly || int(WorldInfo.GetDetailMode()) == int(2))
				{
					// End:0x117
					if(VehicleEffects[I].EffectRef == none)
					{
						CreateVehicleEffect(I);
					}
					// End:0x1BD
					if(VehicleEffects[I].bRestartRunning)
					{
						VehicleEffects[I].EffectRef.KillParticlesForced();
						VehicleEffects[I].EffectRef.ActivateSystem();						
					}
					else
					{
						// End:0x23B
						if(!VehicleEffects[I].EffectRef.bIsActive)
						{
							VehicleEffects[I].EffectRef.ActivateSystem();
						}
					}
					SetVehicleEffectParms(EventTag, VehicleEffects[I].EffectRef);
				}				
			}
			else
			{
				// End:0x315
				if((VehicleEffects[I].EffectRef != none) && VehicleEffects[I].EffectEndTag == EventTag)
				{
					VehicleEffects[I].EffectRef.DeactivateSystem();
				}
			}
			I++;
			// [Loop Continue]
			goto J0x34;
		}
	}
	//return;	
}

simulated function PlayVehicleSound(name SoundTag)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x29D [Loop If]
	if(I < VehicleSounds.Length)
	{
		// End:0xE7
		if(VehicleSounds[I].SoundEndTag == SoundTag)
		{
			// End:0xE7
			if(VehicleSounds[I].SoundRef != none)
			{
				VehicleSounds[I].SoundRef.Stop();
				VehicleSounds[I].SoundRef = none;
			}
		}
		// End:0x28F
		if(VehicleSounds[I].SoundStartTag == SoundTag)
		{
			// End:0x1A3
			if(VehicleSounds[I].SoundRef == none)
			{
				VehicleSounds[I].SoundRef = CreateAudioComponent(VehicleSounds[I].SoundTemplate, false, true);
			}
			// End:0x28F
			if((VehicleSounds[I].SoundRef != none) && !VehicleSounds[I].SoundRef.bWasPlaying || VehicleSounds[I].SoundRef.bFinished)
			{
				VehicleSounds[I].SoundRef.Play();
			}
		}
		++I;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

simulated function PlayVehicleAnimation(name EventTag)
{
	local int I;
	local UTAnimNodeSequence Player;

	// End:0x1BA
	if(((Mesh != none) && Mesh.Animations != none) && VehicleAnims.Length > 0)
	{
		I = 0;
		J0x52:

		// End:0x1BA [Loop If]
		if(I < VehicleAnims.Length)
		{
			// End:0x1AC
			if(VehicleAnims[I].AnimTag == EventTag)
			{
				Player = UTAnimNodeSequence(Mesh.Animations.FindAnimNode(VehicleAnims[I].AnimPlayerName));
				// End:0x1AC
				if(Player != none)
				{
					Player.PlayAnimationSet(VehicleAnims[I].AnimSeqs, VehicleAnims[I].AnimRate, VehicleAnims[I].bAnimLoopLastSeq);
				}
			}
			I++;
			// [Loop Continue]
			goto J0x52;
		}
	}
	//return;	
}

simulated function VehicleEvent(name EventTag)
{
	TriggerVehicleEffect(EventTag);
	PlayVehicleAnimation(EventTag);
	PlayVehicleSound(EventTag);
	//return;	
}

simulated function EntryAnnouncement(Controller C)
{
	super(Vehicle).EntryAnnouncement(C);
	// End:0x29
	if(int(Role) < int(ROLE_Authority))
	{
		return;
	}
	// End:0x1CE
	if((C != none) && WorldInfo.Game.bTeamGame)
	{
		// End:0x1CE
		if(int(Team) != int(C.GetTeamNum()))
		{
			// End:0x17B
			if((int(Team) != int(255)) && PlayerController(C) != none)
			{
				PlayerController(C).ReceiveLocalizedMessage(Class'UTGame.UTVehicleMessage', StolenAnnouncementIndex);
				UTPlayerReplicationInfo(C.PlayerReplicationInfo).IncrementEventStat('EVENT_HIJACKED');
				// End:0x17B
				if(StolenSound != none)
				{
					PlaySound(StolenSound);
				}
			}
			// End:0x1CE
			if(int(C.GetTeamNum()) != int(255))
			{
				SetTeamNum(C.GetTeamNum());
			}
		}
	}
	//return;	
}

function Rotator ExitRotation()
{
	return Rotation;
	//return ReturnValue;	
}

function bool FindAutoExit(Pawn ExitingDriver)
{
	local Vector X, Y, Z, DirectionHint;
	local float PlaceDist;

	GetAxes(ExitRotation(), X, Y, Z);
	Y *= float(-1);
	// End:0x99
	if(ExitRadius == float(0))
	{
		ExitRadius = CylinderComponent.CollisionRadius + (float(2) * ExitingDriver.GetCollisionRadius());
	}
	PlaceDist = ExitRadius + ExitingDriver.GetCollisionRadius();
	// End:0x41D
	if(Controller != none)
	{
		// End:0x3D8
		if(UTBot(ExitingDriver.Controller) != none)
		{
			DirectionHint = UTBot(ExitingDriver.Controller).GetDirectionHint();
			// End:0x375
			if(IsZero(DirectionHint))
			{
				// End:0x202
				if(ExitingDriver.Controller.MoveTarget != Anchor)
				{
					DirectionHint = Normal(ExitingDriver.Controller.MoveTarget.Location - Location);					
				}
				else
				{
					// End:0x2DD
					if((ExitingDriver.Controller.RouteCache.Length > 1) && ExitingDriver.Controller.RouteCache[1] != none)
					{
						DirectionHint = Normal(ExitingDriver.Controller.RouteCache[1].Location - Location);						
					}
					else
					{
						// End:0x375
						if(ExitingDriver.Controller.RouteGoal != none)
						{
							DirectionHint = Normal(ExitingDriver.Controller.RouteGoal.Location - Location);
						}
					}
				}
			}
			// End:0x3A5
			if((DirectionHint Dot Y) < 0.0000000)
			{
				Y *= float(-1);
			}
			// End:0x3D5
			if((DirectionHint Dot X) < 0.0000000)
			{
				X *= float(-1);
			}			
		}
		else
		{
			// End:0x41D
			if((Y Dot Vector(Controller.Rotation)) < float(0))
			{
				Y *= float(-1);
			}
		}
	}
	// End:0x498
	if(VSize(Velocity) > MinCrushSpeed)
	{
		// End:0x464
		if((Velocity Dot X) < float(0))
		{
			X *= float(-1);
		}
		// End:0x498
		if((Velocity Dot Y) > MinCrushSpeed)
		{
			Y *= float(-1);
		}
	}
	// End:0x4F3
	if(TryExitPos(ExitingDriver, ((GetTargetLocation()) + (ExitOffset >> Rotation)) + (PlaceDist * Y), bFindGroundExit))
	{
		return true;
	}
	// End:0x54E
	if(TryExitPos(ExitingDriver, ((GetTargetLocation()) + (ExitOffset >> Rotation)) - (PlaceDist * Y), bFindGroundExit))
	{
		return true;
	}
	// End:0x5A0
	if(TryExitPos(ExitingDriver, ((GetTargetLocation()) + (ExitOffset >> Rotation)) - (PlaceDist * X), false))
	{
		return true;
	}
	// End:0x5F2
	if(TryExitPos(ExitingDriver, ((GetTargetLocation()) + (ExitOffset >> Rotation)) + (PlaceDist * X), false))
	{
		return true;
	}
	// End:0x603
	if(!bFindGroundExit)
	{
		return false;
	}
	// End:0x655
	if(TryExitPos(ExitingDriver, ((GetTargetLocation()) + (ExitOffset >> Rotation)) + (PlaceDist * Y), false))
	{
		return true;
	}
	// End:0x6A7
	if(TryExitPos(ExitingDriver, ((GetTargetLocation()) + (ExitOffset >> Rotation)) - (PlaceDist * Y), false))
	{
		return true;
	}
	// End:0x6F9
	if(TryExitPos(ExitingDriver, ((GetTargetLocation()) + (ExitOffset >> Rotation)) + (PlaceDist * Z), false))
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

event RanInto(Actor Other)
{
	local Vector Momentum;
	local float Speed;
	local Class<UDKEmitCameraEffect> CameraEffect;

	// End:0x9F
	if((((Pawn(Other) == none) || (Vehicle(Other) != none) && !Other.IsA('UTVehicle_Hoverboard')) || Other == Instigator) || int(Other.Role) != int(ROLE_Authority))
	{
		return;
	}
	Speed = VSize(Velocity);
	// End:0x309
	if(Speed > MinRunOverSpeed)
	{
		Momentum = (Velocity * 0.2500000) * Pawn(Other).Mass;
		// End:0x136
		if(RanOverSound != none)
		{
			PlaySound(RanOverSound);
		}
		// End:0x1DA
		if(WorldInfo.GRI.OnSameTeam(self, Other))
		{
			Momentum += (((Speed * 0.2500000) * Pawn(Other).Mass) * Normal(Velocity Cross vect(0.0000000, 0.0000000, 1.0000000)));			
		}
		else
		{
			Other.TakeDamage(int(Speed * 0.0750000), GetCollisionDamageInstigator(), Other.Location, Momentum, RanOverDamageType);
			// End:0x309
			if((Pawn(Other).Health <= 0) && UTPlayerController(Controller) != none)
			{
				CameraEffect = RanOverDamageType.static.GetDeathCameraEffectInstigator(UTPawn(Other));
				// End:0x309
				if(CameraEffect != none)
				{
					UTPlayerController(Controller).ClientSpawnCameraEffect(CameraEffect);
				}
			}
		}
	}
	//return;	
}

function PancakeOther(Pawn Other)
{
	Other.TakeDamage(10000, GetCollisionDamageInstigator(), Other.Location, Velocity * Other.Mass, CrushedDamageType);
	//return;	
}

event TakeWaterDamage()
{
	local int ImpartedWaterDamage;

	ImpartedWaterDamage = int(AccumulatedWaterDamage);
	AccumulatedWaterDamage -= float(ImpartedWaterDamage);
	TakeDamage(ImpartedWaterDamage, Controller, Location, vect(0.0000000, 0.0000000, 0.0000000), VehicleDrowningDamType);
	//return;	
}

function DriverRadiusDamage(float DamageAmount, float DamageRadius, Controller EventInstigator, Class<DamageType> DamageType, float Momentum, Vector HitLocation, Actor DamageCauser, optional float DamageFalloffExponent = 1.0000000)
{
	local int I;
	local Vehicle V;

	// End:0x68
	if(bDriverIsVisible)
	{
		super(Vehicle).DriverRadiusDamage(DamageAmount, DamageRadius, EventInstigator, DamageType, Momentum, HitLocation, DamageCauser, DamageFalloffExponent);
	}
	I = 1;
	J0x73:

	// End:0x163 [Loop If]
	if(I < Seats.Length)
	{
		V = Seats[I].SeatPawn;
		// End:0x155
		if((V != none) && V.bDriverIsVisible)
		{
			V.DriverRadiusDamage(DamageAmount, DamageRadius, EventInstigator, DamageType, Momentum, HitLocation, DamageCauser, DamageFalloffExponent);
		}
		I++;
		// [Loop Continue]
		goto J0x73;
	}
	//return;	
}

simulated function Destroyed()
{
	local UTVehicle V, Prev;
	local int I;
	local PlayerController PC;

	I = 1;
	J0x0B:

	// End:0x1E2 [Loop If]
	if(I < Seats.Length)
	{
		// End:0x193
		if(Seats[I].SeatPawn != none)
		{
			// End:0x15E
			if(Seats[I].SeatPawn.Controller != none)
			{
				WarnInternal(((((string(self) @ "destroying seat") @ string(I)) @ "still controlled by") @ string(Seats[I].SeatPawn.Controller)) @ Seats[I].SeatPawn.Controller.GetHumanReadableName());
			}
			Seats[I].SeatPawn.Destroy();
		}
		// End:0x1D4
		if(Seats[I].SeatMovementEffect != none)
		{
			SetMovementEffect(I, false);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	// End:0x211
	if(ParentFactory != none)
	{
		ParentFactory.VehicleDestroyed(self);
	}
	// End:0x403
	if(UTGame(WorldInfo.Game) != none)
	{
		// End:0x2C9
		if(UTGame(WorldInfo.Game).VehicleList == self)
		{
			UTGame(WorldInfo.Game).VehicleList = NextVehicle;			
		}
		else
		{
			Prev = UTGame(WorldInfo.Game).VehicleList;
			// End:0x403
			if(Prev != none)
			{
				V = UTGame(WorldInfo.Game).VehicleList.NextVehicle;
				J0x379:

				// End:0x403 [Loop If]
				if(V != none)
				{
					// End:0x3C5
					if(V == self)
					{
						Prev.NextVehicle = NextVehicle;
						// [Explicit Break]
						goto J0x403;						
					}
					else
					{
						Prev = V;
					}
					V = V.NextVehicle;
					// [Loop Continue]
					goto J0x379;
				}
			}
		}
	}
	J0x403:

	SetTexturesToBeResident(false);
	super(SVehicle).Destroyed();
	// End:0x491
	foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		// End:0x490
		if(PC.myHUD != none)
		{
			PC.myHUD.RemovePostRenderedActor(self);
		}		
	}	
	//return;	
}

simulated function SetTexturesToBeResident(bool bActive)
{
	local int I, NumElems;
	local MaterialInterface Material;

	NumElems = Mesh.GetNumElements();
	I = 0;
	J0x34:

	// End:0xCA [Loop If]
	if(I < NumElems)
	{
		Material = Mesh.GetMaterial(I);
		// End:0xBC
		if(Material != none)
		{
			Material.SetForceMipLevelsToBeResident(true, bActive, -1.0000000);
		}
		I++;
		// [Loop Continue]
		goto J0x34;
	}
	//return;	
}

simulated function bool DisableVehicle()
{
	local int SeatIdx;

	// End:0x1E4
	if(Occupied())
	{
		bIsDisabled = true;
		// End:0x137
		if(int(Role) == int(ROLE_Authority))
		{
			SetTimer(DisabledTime, false, 'EnableVehicle');
			// End:0x5C
			if(bDriving)
			{
				DriverLeave(true);
			}
			SeatIdx = 0;
			J0x67:

			// End:0x137 [Loop If]
			if(SeatIdx < Seats.Length)
			{
				// End:0x129
				if((Seats[SeatIdx].SeatPawn != none) && Seats[SeatIdx].SeatPawn.bDriving)
				{
					Seats[SeatIdx].SeatPawn.DriverLeave(true);
				}
				++SeatIdx;
				// [Loop Continue]
				goto J0x67;
			}
		}
		// End:0x1E2
		if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
		{
			// End:0x1C2
			if(DisabledEffectComponent == none)
			{
				DisabledEffectComponent = new (self) Class'Engine.ParticleSystemComponent';
				DisabledEffectComponent.SetTemplate(DisabledTemplate);
				AttachComponent(DisabledEffectComponent);
			}
			DisabledEffectComponent.ActivateSystem();
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function EnableVehicle()
{
	bIsDisabled = false;
	// End:0x64
	if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && DisabledEffectComponent != none)
	{
		DetachComponent(DisabledEffectComponent);
		DisabledEffectComponent = none;
	}
	//return;	
}

event TakeFireDamage()
{
	local int CurrentDamage;

	CurrentDamage = int(AccruedFireDamage);
	AccruedFireDamage -= float(CurrentDamage);
	TakeDamage(CurrentDamage, Controller, Location, vect(0.0000000, 0.0000000, 0.0000000), ExplosionDamageType);
	//return;	
}

simulated function int GetSeatIndexFromPrefix(string Prefix)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x6F [Loop If]
	if(I < Seats.Length)
	{
		// End:0x61
		if(Seats[I].TurretVarPrefix ~= Prefix)
		{
			return I;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return -1;
	//return ReturnValue;	
}

reliable server function ServerSetConsoleTurning(bool bNewConsoleTurning)
{
	bIsConsoleTurning = bNewConsoleTurning;
	//return;	
}

simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
	local int I, MaxDelta;
	local float MaxDeltaDegrees;

	// End:0x3E2
	if(WorldInfo.bUseConsoleInput)
	{
		// End:0x3E2
		if(!bSeparateTurretFocus && ShouldClamp())
		{
			// End:0xC3
			if(out_DeltaRot.Yaw == 0)
			{
				// End:0xC0
				if(bIsConsoleTurning)
				{
					out_ViewRotation.Yaw = GetClampedViewRotation().Yaw;
					bIsConsoleTurning = false;
					ServerSetConsoleTurning(false);
				}				
			}
			else
			{
				// End:0x15D
				if(!bIsConsoleTurning)
				{
					// End:0x13F
					if(GetClampedViewRotation().Yaw == Controller.Rotation.Yaw)
					{
						bIsConsoleTurning = true;
						ServerSetConsoleTurning(true);						
					}
					else
					{
						out_DeltaRot.Yaw = 0;
					}
				}
			}
			I = 0;
			J0x168:

			// End:0x1F5 [Loop If]
			if(I < Seats[0].TurretControllers.Length)
			{
				MaxDeltaDegrees = FMax(MaxDeltaDegrees, Seats[0].TurretControllers[I].LagDegreesPerSecond);
				I++;
				// [Loop Continue]
				goto J0x168;
			}
			// End:0x3E2
			if(MaxDeltaDegrees > 0.0000000)
			{
				MaxDelta = int((MaxDeltaDegrees * 182.0444031) * DeltaTime);
				out_DeltaRot.Pitch = ((out_DeltaRot.Pitch >= 0) ? Min(out_DeltaRot.Pitch, MaxDelta) : Max(out_DeltaRot.Pitch, -MaxDelta));
				out_DeltaRot.Yaw = ((out_DeltaRot.Yaw >= 0) ? Min(out_DeltaRot.Yaw, MaxDelta) : Max(out_DeltaRot.Yaw, -MaxDelta));
				out_DeltaRot.Roll = ((out_DeltaRot.Roll >= 0) ? Min(out_DeltaRot.Roll, MaxDelta) : Max(out_DeltaRot.Roll, -MaxDelta));
			}
		}
	}
	super(Pawn).ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
	//return;	
}

simulated function Rotator GetClampedViewRotation()
{
	local Rotator ViewRotation, ControlRotation, MaxDelta;
	local UTVehicleWeapon VWeap;

	VWeap = UTVehicleWeapon(Weapon);
	// End:0x307
	if((VWeap != none) && ShouldClamp())
	{
		ViewRotation.Yaw = Controller.Rotation.Yaw;
		MaxDelta.Yaw = int(((Acos(VWeap.GetMaxFinalAimAdjustment()) * 180.0000000) / 3.1415927) * 182.0444031);
		// End:0x25E
		if(!ClampRotation(ViewRotation, Rotation, MaxDelta, MaxDelta))
		{
			ControlRotation.Yaw = Controller.Rotation.Yaw;
			// End:0x25E
			if(!ClampRotation(ControlRotation, ViewRotation, rot(0, 16384, 0), rot(0, 16384, 0)))
			{
				ControlRotation.Pitch = Controller.Rotation.Pitch;
				ControlRotation.Roll = Controller.Rotation.Roll;
				Controller.SetRotation(ControlRotation);
			}
		}
		ViewRotation.Pitch = Controller.Rotation.Pitch;
		ViewRotation.Roll = Controller.Rotation.Roll;
		return ViewRotation;		
	}
	else
	{
		return GetViewRotation();
	}
	//return ReturnValue;	
}

simulated function bool ShouldClamp()
{
	return true;
	//return ReturnValue;	
}

simulated event Rotator GetViewRotation()
{
	// End:0x46
	if((bIsConsoleTurning && !bSeparateTurretFocus) && PlayerController(Controller) != none)
	{
		return GetClampedViewRotation();		
	}
	else
	{
		return super(Pawn).GetViewRotation();
	}
	//return ReturnValue;	
}

simulated function WeaponRotationChanged(int SeatIndex)
{
	local int I;

	// End:0xB8
	if(SeatIndex >= 0)
	{
		I = 0;
		J0x1A:

		// End:0xB8 [Loop If]
		if(I < Seats[SeatIndex].TurretControllers.Length)
		{
			Seats[SeatIndex].TurretControllers[I].DesiredBoneRotation = SeatWeaponRotation(SeatIndex,, true);
			I++;
			// [Loop Continue]
			goto J0x1A;
		}
	}
	//return;	
}

simulated event ReplicatedEvent(name VarName)
{
	local string VarString;
	local int SeatIndex;

	// End:0x50
	if(VarName == 'bPlayingSpawnEffect')
	{
		// End:0x43
		if(bPlayingSpawnEffect)
		{
			// End:0x40
			if(int(Team) != 128)
			{
				PlaySpawnEffect();
			}			
		}
		else
		{
			StopSpawnEffect();
		}		
	}
	else
	{
		// End:0x8B
		if(VarName == 'Team')
		{
			TeamChanged();
			// End:0x88
			if(bPlayingSpawnEffect)
			{
				PlaySpawnEffect();
			}			
		}
		else
		{
			// End:0xAF
			if(VarName == 'bDeadVehicle')
			{
				BlowupVehicle();				
			}
			else
			{
				// End:0xED
				if(VarName == 'bIsDisabled')
				{
					// End:0xE0
					if(bIsDisabled)
					{
						DisableVehicle();						
					}
					else
					{
						EnableVehicle();
					}					
				}
				else
				{
					// End:0x132
					if(VarName == 'LinkedToCount')
					{
						// End:0x125
						if(int(LinkedToCount) > int(0))
						{
							StartLinkedEffect();							
						}
						else
						{
							StopLinkedEffect();
						}						
					}
					else
					{
						// End:0x198
						if(VarName == 'bKeyVehicle')
						{
							// End:0x195
							if(bKeyVehicle)
							{
								UTMapInfo(WorldInfo.GetMapInfo()).AddKeyVehicle(self);
							}							
						}
						else
						{
							VarString = "" $ string(VarName);
							// End:0x226
							if(Right(VarString, 14) ~= "weaponrotation")
							{
								SeatIndex = GetSeatIndexFromPrefix(Left(VarString, Len(VarString) - 14));
								// End:0x223
								if(SeatIndex >= 0)
								{
									WeaponRotationChanged(SeatIndex);
								}								
							}
							else
							{
								// End:0x304
								if(Right(VarString, 10) ~= "flashcount")
								{
									SeatIndex = GetSeatIndexFromPrefix(Left(VarString, Len(VarString) - 10));
									// End:0x301
									if(SeatIndex >= 0)
									{
										Seats[SeatIndex].BarrelIndex++;
										// End:0x2ED
										if(int(SeatFlashCount(SeatIndex,, true)) > int(0))
										{
											VehicleWeaponFired(true, vect(0.0000000, 0.0000000, 0.0000000), SeatIndex);											
										}
										else
										{
											VehicleWeaponStoppedFiring(true, SeatIndex);
										}
									}									
								}
								else
								{
									// End:0x3EA
									if(Right(VarString, 13) ~= "flashlocation")
									{
										SeatIndex = GetSeatIndexFromPrefix(Left(VarString, Len(VarString) - 13));
										// End:0x3E7
										if(SeatIndex >= 0)
										{
											Seats[SeatIndex].BarrelIndex++;
											// End:0x3D3
											if(!IsZero(SeatFlashLocation(SeatIndex,, true)))
											{
												VehicleWeaponFired(true, SeatFlashLocation(SeatIndex,, true), SeatIndex);												
											}
											else
											{
												VehicleWeaponStoppedFiring(true, SeatIndex);
											}
										}										
									}
									else
									{
										super(Vehicle).ReplicatedEvent(VarName);
									}
								}
							}
						}
					}
				}
			}
		}
	}
	//return;	
}

event SetKeyVehicle()
{
	bKeyVehicle = true;
	UTMapInfo(WorldInfo.GetMapInfo()).AddKeyVehicle(self);
	//return;	
}

simulated function DrivingStatusChanged()
{
	bUpdateWheelShapes = true;
	// End:0x53
	if(bDriving)
	{
		// End:0x50
		if(DrivingPhysicalMaterial != none)
		{
			Mesh.SetPhysMaterialOverride(DrivingPhysicalMaterial);
		}		
	}
	else
	{
		// End:0x8A
		if(DefaultPhysicalMaterial != none)
		{
			Mesh.SetPhysMaterialOverride(DefaultPhysicalMaterial);
		}
	}
	// End:0xB5
	if(bDriving && !bIsDisabled)
	{
		VehiclePlayEnterSound();		
	}
	else
	{
		// End:0xCE
		if(Health > 0)
		{
			VehiclePlayExitSound();
		}
	}
	bBlocksNavigation = !bDriving;
	// End:0x116
	if(!bDriving)
	{
		StopFiringWeapon();
		SetMovementEffect(0, false);
		SetTexturesToBeResident(false);
	}
	VehicleEvent(((bDriving) ? 'EngineStart' : 'EngineStop'));
	//return;	
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	super(Actor).OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
	// End:0x45
	if(bDriving)
	{
		VehicleEvent('Idle');
	}
	//return;	
}

function bool SeatAvailable(int SeatIndex)
{
	return (Seats[SeatIndex].SeatPawn == none) || Seats[SeatIndex].SeatPawn.Controller == none;
	//return ReturnValue;	
}

function bool AnySeatAvailable()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0xA2 [Loop If]
	if(I < Seats.Length)
	{
		// End:0x94
		if((Seats[I].SeatPawn != none) && Seats[I].SeatPawn.Controller == none)
		{
			return true;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return false;
	//return ReturnValue;	
}

simulated function int GetSeatIndexForController(Controller ControllerToMove)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0xC7 [Loop If]
	if(I < Seats.Length)
	{
		// End:0xB9
		if((Seats[I].SeatPawn.Controller != none) && Seats[I].SeatPawn.Controller == ControllerToMove)
		{
			return I;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return -1;
	//return ReturnValue;	
}

function Controller GetControllerForSeatIndex(int SeatIndex)
{
	return Seats[SeatIndex].SeatPawn.Controller;
	//return ReturnValue;	
}

reliable server function ServerAdjacentSeat(int Direction, Controller C)
{
	local int CurrentSeat, NewSeat;

	CurrentSeat = GetSeatIndexForController(C);
	// End:0x1B1
	if(CurrentSeat != -1)
	{
		NewSeat = CurrentSeat;
		J0x43:

		NewSeat += Direction;
		// End:0x80
		if(NewSeat < 0)
		{
			NewSeat = Seats.Length - 1;			
		}
		else
		{
			// End:0xA3
			if(NewSeat == Seats.Length)
			{
				NewSeat = 0;
			}
		}
		// End:0x105
		if(NewSeat == CurrentSeat)
		{
			// End:0x103
			if(PlayerController(C) != none)
			{
				PlayerController(C).ClientPlaySound(VehicleLockedSound);
			}
			return;
		}
		// End:0x43
		if(!((SeatAvailable(NewSeat)) || (Seats[NewSeat].SeatPawn != none) && UTBot(Seats[NewSeat].SeatPawn.Controller) != none))
			goto J0x43;
		ChangeSeat(C, NewSeat);
	}
	//return;	
}

reliable server function ServerChangeSeat(int RequestedSeat)
{
	// End:0x21
	if(RequestedSeat == -1)
	{
		DriverLeave(false);		
	}
	else
	{
		ChangeSeat(Controller, RequestedSeat);
	}
	//return;	
}

function bool HasPriority(Controller first, Controller second)
{
	// End:0x50
	if(((first != second) && PlayerController(first) != none) && PlayerController(second) == none)
	{
		return true;		
	}
	else
	{
		return false;
	}
	//return ReturnValue;	
}

function bool ChangeSeat(Controller ControllerToMove, int RequestedSeat)
{
	local int OldSeatIndex;
	local Pawn OldPawn, BumpPawn;
	local Controller BumpController;

	// End:0x2B
	if((RequestedSeat >= Seats.Length) || RequestedSeat < 0)
	{
		return false;
	}
	OldSeatIndex = GetSeatIndexForController(ControllerToMove);
	// End:0xCB
	if(OldSeatIndex == -1)
	{
		WarnInternal(((("[Vehicles] Attempted to switch" @ string(ControllerToMove)) @ "to a seat in") @ string(self)) @ " when he is not already in the vehicle");
		return false;
	}
	// End:0x322
	if(!SeatAvailable(RequestedSeat))
	{
		BumpController = GetControllerForSeatIndex(RequestedSeat);
		// End:0x1A3
		if(BumpController == none)
		{
			WarnInternal(((((("[Vehicles]" @ string(ControllerToMove)) @ "Attempted to bump a phantom Controller in seat in") @ string(RequestedSeat)) @ " (") $ string(Seats[RequestedSeat].SeatPawn)) $ ")");
			return false;
		}
		// End:0x20F
		if(!HasPriority(ControllerToMove, BumpController))
		{
			// End:0x20D
			if(PlayerController(ControllerToMove) != none)
			{
				PlayerController(ControllerToMove).ClientPlaySound(VehicleLockedSound);
			}
			return false;
		}
		// End:0x322
		if(BumpController != none)
		{
			BumpPawn = Seats[RequestedSeat].StoragePawn;
			Seats[RequestedSeat].SeatPawn.DriverLeave(true);
			// End:0x322
			if(RequestedSeat == 0)
			{
				// End:0x2DE
				if(BumpController.RouteGoal == self)
				{
					BumpController.RouteGoal = none;
				}
				// End:0x322
				if(BumpController.MoveTarget == self)
				{
					BumpController.MoveTarget = none;
				}
			}
		}
	}
	OldPawn = Seats[OldSeatIndex].StoragePawn;
	Seats[OldSeatIndex].SeatPawn.DriverLeave(true);
	// End:0x426
	if(OldSeatIndex == 0)
	{
		// End:0x3E2
		if(ControllerToMove.RouteGoal == self)
		{
			ControllerToMove.RouteGoal = none;
		}
		// End:0x426
		if(ControllerToMove.MoveTarget == self)
		{
			ControllerToMove.MoveTarget = none;
		}
	}
	// End:0x44B
	if(RequestedSeat == 0)
	{
		DriverEnter(OldPawn);		
	}
	else
	{
		PassengerEnter(OldPawn, RequestedSeat);
	}
	// End:0x4B7
	if(BumpPawn != none)
	{
		// End:0x49B
		if(OldSeatIndex == 0)
		{
			DriverEnter(BumpPawn);			
		}
		else
		{
			PassengerEnter(BumpPawn, OldSeatIndex);
		}
	}
	return true;
	//return ReturnValue;	
}

simulated event TornOff()
{
	WarnInternal(string(self) @ "Torn off");
	//return;	
}

function Controller GetCollisionDamageInstigator()
{
	return ((KillerController != none) ? KillerController : super(Vehicle).GetCollisionDamageInstigator());
	//return ReturnValue;	
}

function bool Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
	local UTCarriedObject Flag;
	local UTPawn UTP;
	local UTPlayerReplicationInfo UTPRI;
	local int I;

	I = 0;
	J0x0B:

	// End:0x152 [Loop If]
	if(I < Seats.Length)
	{
		// End:0x144
		if((Seats[I].SeatPawn != none) || Seats[I].StoragePawn != none)
		{
			UTP = UTPawn(Seats[I].StoragePawn);
			// End:0x144
			if((UTP != none) && UTP.ShieldBeltArmor > float(0))
			{
				UTP.ShieldBeltArmor = 0.0000000;
				UTP.SetOverlayMaterial(none);
				EjectSeat(I);
			}
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	// End:0x48C
	if(super(Vehicle).Died(Killer, DamageType, HitLocation))
	{
		// End:0x204
		if((VehicleDestroyedSound.Length > 0) && UTBot(Killer) != none)
		{
			UTBot(Killer).KilledVehicleClass = Class;
			Killer.SendMessage(none, 'VEHICLEKILL', 10.0000000);
		}
		KillerController = Killer;
		HitDamageType = DamageType;
		TakeHitLocation = HitLocation;
		UTPRI = UTPlayerReplicationInfo(PlayerReplicationInfo);
		// End:0x291
		if(UTPRI != none)
		{
			UTPRI.StopDrivingStat(GetVehicleDrivingStatName());
		}
		BlowupVehicle();
		HandleDeadVehicleDriver();
		I = 1;
		J0x2B0:

		// End:0x41A [Loop If]
		if(I < Seats.Length)
		{
			// End:0x40C
			if(Seats[I].SeatPawn != none)
			{
				UTPRI = UTPlayerReplicationInfo(Seats[I].SeatPawn.PlayerReplicationInfo);
				// End:0x3B5
				if(UTPRI != none)
				{
					UTPRI.StopDrivingStat(UDKVehicleBase(Seats[I].SeatPawn).GetVehicleDrivingStatName());
				}
				Seats[I].SeatPawn.Died(Killer, DamageType, HitLocation);
			}
			I++;
			// [Loop Continue]
			goto J0x2B0;
		}
		// End:0x44F
		foreach BasedActors(Class'UTGame.UTCarriedObject', Flag)
		{
			Flag.SetBase(none);			
		}		
		// End:0x48A
		if(ParentFactory != none)
		{
			ParentFactory.VehicleDestroyed(self);
			ParentFactory = none;
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function BlowupVehicle()
{
	local int I;

	// End:0x20
	if(bDriving)
	{
		VehicleEvent('EngineStop');
	}
	bCanBeBaseForPawns = false;
	LinkHealMult = 0.0000000;
	GotoState('DyingVehicle');
	AddVelocity(TearOffMomentum, TakeHitLocation, HitDamageType);
	bDeadVehicle = true;
	bStayUpright = false;
	// End:0xB5
	if(StayUprightConstraintInstance != none)
	{
		StayUprightConstraintInstance.TermConstraint();
	}
	I = 0;
	J0xC0:

	// End:0x153 [Loop If]
	if(I < Wheels.Length)
	{
		// End:0x145
		if((UDKVehicleWheel(Wheels[I]) != none) && UDKVehicleWheel(Wheels[I]).bDisableWheelOnDeath)
		{
			SetWheelCollision(I, false);
		}
		I++;
		// [Loop Continue]
		goto J0xC0;
	}
	CustomGravityScaling = 1.0000000;
	// End:0x1A4
	if(UDKVehicleSimHover(SimObj) != none)
	{
		UDKVehicleSimHover(SimObj).bDisableWheelsWhenOff = true;
	}
	//return;	
}

function bool InCustomEntryRadius(Pawn P)
{
	return false;
	//return ReturnValue;	
}

simulated function PlayerReplicationInfo GetSeatPRI(int SeatNum)
{
	// End:0x53
	if(int(Role) == int(ROLE_Authority))
	{
		return Seats[SeatNum].SeatPawn.PlayerReplicationInfo;		
	}
	else
	{
		return ((SeatNum == 0) ? PlayerReplicationInfo : PassengerPRI);
	}
	//return ReturnValue;	
}

simulated function bool CanEnterVehicle(Pawn P)
{
	local int I;
	local bool bSeatAvailable, bIsHuman;
	local PlayerReplicationInfo SeatPRI;

	// End:0xCB
	if(((((P.bIsCrouched || P.DrivenVehicle != none) || P.Controller == none) || !P.Controller.bIsPlayer) || Health <= 0) || bDeleteMe)
	{
		return false;
	}
	bIsHuman = P.IsHumanControlled();
	bSeatAvailable = true;
	I = 0;
	J0x10D:

	// End:0x1AB [Loop If]
	if(I < Seats.Length)
	{
		SeatPRI = GetSeatPRI(I);
		// End:0x160
		if(SeatPRI == none)
		{
			bSeatAvailable = true;			
		}
		else
		{
			// End:0x19D
			if(bIsHuman && SeatPRI.bBot)
			{
				bSeatAvailable = true;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x10D;
	}
	return bSeatAvailable;
	//return ReturnValue;	
}

function bool TryToDrive(Pawn P)
{
	local Vector X, Y, Z;
	local bool bFreedSeat, bEnteredVehicle;

	// End:0x0F
	if(bPlayingSpawnEffect)
	{
		return false;
	}
	// End:0x100
	if(((bIsInverted && bMustBeUpright) && !bVehicleOnGround) && VSize(Velocity) <= 5.0000000)
	{
		// End:0xFE
		if(bCanFlip)
		{
			bIsUprighting = true;
			UprightStartTime = WorldInfo.TimeSeconds;
			GetAxes(Rotation, X, Y, Z);
			bFlipRight = ((P.Location - Location) Dot Y) > float(0);
		}
		return false;
	}
	// End:0x134
	if(!CanEnterVehicle(P) || Vehicle(P) != none)
	{
		return false;
	}
	// End:0x313
	if(!bIsDisabled && (((int(Team) == 128) || !bTeamLocked) || !WorldInfo.Game.bTeamGame) || WorldInfo.GRI.OnSameTeam(self, P))
	{
		// End:0x22D
		if(bEnteringUnlocks)
		{
			bTeamLocked = false;
			// End:0x22D
			if(ParentFactory != none)
			{
				ParentFactory.VehicleTaken();
			}
		}
		// End:0x2A4
		if(!AnySeatAvailable())
		{
			// End:0x293
			if(WorldInfo.GRI.OnSameTeam(self, P))
			{
				bFreedSeat = KickOutBot();
			}
			// End:0x2A4
			if(!bFreedSeat)
			{
				return false;
			}
		}
		bEnteredVehicle = ((Driver == none) ? DriverEnter(P) : PassengerEnter(P, GetFirstAvailableSeat()));
		// End:0x308
		if(bEnteredVehicle)
		{
			SetTexturesToBeResident(true);
		}
		return bEnteredVehicle;
	}
	VehicleLocked(P);
	return false;
	//return ReturnValue;	
}

function bool KickOutBot(optional int SeatIndex = -2)
{
	local int I;
	local UTBot B;

	// End:0x119
	if(SeatIndex == -2)
	{
		I = 0;
		J0x27:

		// End:0x116 [Loop If]
		if(I < Seats.Length)
		{
			B = UTBot(Seats[I].SeatPawn.Controller);
			// End:0x108
			if((B != none) && Seats[I].SeatPawn.DriverLeave(false))
			{
				B.SetTimer(0.0100000, false, 'WhatToDoNext');
				return true;
			}
			I++;
			// [Loop Continue]
			goto J0x27;
		}		
	}
	else
	{
		// End:0x1FA
		if(SeatIndex < Seats.Length)
		{
			B = UTBot(Seats[SeatIndex].SeatPawn.Controller);
			// End:0x1FA
			if((B != none) && Seats[SeatIndex].SeatPawn.DriverLeave(false))
			{
				B.SetTimer(0.0100000, false, 'WhatToDoNext');
				return true;
			}
		}
	}
	return false;
	//return ReturnValue;	
}

function VehicleLocked(Pawn P)
{
	local PlayerController PC;

	PC = PlayerController(P.Controller);
	// End:0x94
	if(PC != none)
	{
		PC.ClientPlaySound(VehicleLockedSound);
		PC.ReceiveLocalizedMessage(Class'UTGame.UTVehicleMessage', 1);
	}
	//return;	
}

simulated function bool ShouldShowUseable(PlayerController PC, float Dist)
{
	local UTPlayerController UTPC;

	UTPC = UTPlayerController(PC);
	return ((InUseableRange(UTPC, Dist)) && CanEnterVehicle(PC.Pawn)) && (UTPC.CheckVehicleToDrive(false) == self) || (bRequestedEntryWithFlag && UTPC.bJustFoundVehicle) && UTPlayerReplicationInfo(PC.PlayerReplicationInfo).bHasFlag;
	//return ReturnValue;	
}

simulated event PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
	local float TextXL, XL, YL, Dist, HealthX, HealthY,
		XScale, MaxOffset;

	local Vector ScreenLoc, HitNormal, HitLocation, CrossDir;
	local Actor HitActor;
	local LinearColor TeamColor;
	local Color TextColor;
	local string ScreenName;
	local bool bShowUseable;
	local UTWeapon Weap;
	local UTHUDBase HUD;

	HUD = UTHUDBase(PC.myHUD);
	Dist = VSize(CameraPosition - Location);
	// End:0x437
	if(WorldInfo.GRI.GameClass.default.bTeamGame && !WorldInfo.GRI.OnSameTeam(self, PC))
	{
		// End:0x119
		if(IsInvisible())
		{
			LastPostRenderTraceTime = WorldInfo.TimeSeconds;
			return;
		}
		// End:0x437
		if(!bShowLocked && !PC.PlayerReplicationInfo.bOnlySpectator)
		{
			// End:0x3FF
			if((PlayerReplicationInfo != none) && (WorldInfo.TimeSeconds - LastPostRenderTraceTime) > 0.5000000)
			{
				// End:0x3CC
				if((!UTPlayerController(PC).AlreadyInActionMusic() && (Dist * Dist) < VSizeSq(PC.ViewTarget.Location - Location)) && !IsInvisible())
				{
					ScreenLoc = Canvas.Project(Location);
					// End:0x3CC
					if((Abs(ScreenLoc.X - (0.5000000 * Canvas.ClipX)) < (0.1000000 * Canvas.ClipX)) && Abs(ScreenLoc.Y - (0.5000000 * Canvas.ClipY)) < (0.1000000 * Canvas.ClipY))
					{
						// End:0x3CC
						if(FastTrace(Location, CameraPosition,, true) || FastTrace(Location + ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.0000000)), CameraPosition,, true))
						{
							UTPlayerController(PC).ClientMusicEvent(0);
						}
					}
				}
				LastPostRenderTraceTime = WorldInfo.TimeSeconds + (0.2000000 * FRand());
			}
			bShowUseable = ShouldShowUseable(PC, Dist);
			// End:0x437
			if(!bShowUseable)
			{
				return;
			}
		}
	}
	ScreenLoc = ((bShowLocked) ? Canvas.Project(Location) : Canvas.Project(Location + TeamBeaconOffset));
	// End:0x63E
	if((((ScreenLoc.X < float(0)) || ScreenLoc.X >= Canvas.ClipX) || ScreenLoc.Y < float(0)) || ScreenLoc.Y >= Canvas.ClipY)
	{
		// End:0x62D
		if(((!bShowLocked && !bShowUseable) && !bPlayingSpawnEffect) && (UTPawn(PC.Pawn) != none) || UTVehicle_Hoverboard(PC.Pawn) != none)
		{
			bShowUseable = ShouldShowUseable(PC, Dist);
		}
		// End:0x63E
		if(!bShowUseable)
		{
			return;
		}
	}
	// End:0x704
	if(UTPawn(PC.Pawn) != none)
	{
		Weap = UTWeapon(UTPawn(PC.Pawn).Weapon);
		// End:0x701
		if((Weap != none) && Weap.CoversScreenSpace(ScreenLoc, Canvas))
		{
			return;
		}		
	}
	else
	{
		// End:0x787
		if((UTVehicle_Hoverboard(PC.Pawn) != none) && UTVehicle_Hoverboard(PC.Pawn).CoversScreenSpace(ScreenLoc, Canvas))
		{
			return;
		}
	}
	// End:0x972
	if((WorldInfo.TimeSeconds - LastPostRenderTraceTime) > 0.5000000)
	{
		LastPostRenderTraceTime = WorldInfo.TimeSeconds + (0.2000000 * FRand());
		bPostRenderTraceSucceeded = FastTrace(Location, CameraPosition);
		// End:0x972
		if(!bPostRenderTraceSucceeded)
		{
			// End:0x82D
			if(bShowLocked)
			{
				return;
			}
			bPostRenderTraceSucceeded = FastTrace(Location + ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.0000000)), CameraPosition);
			// End:0x972
			if(!bPostRenderTraceSucceeded)
			{
				CrossDir = Normal(vect(0.0000000, 0.0000000, 1.0000000) Cross (Location - CameraPosition));
				bPostRenderTraceSucceeded = FastTrace((Location + ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.0000000))) + (CylinderComponent.CollisionRadius * CrossDir), CameraPosition) || FastTrace((Location + ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.0000000))) - (CylinderComponent.CollisionRadius * CrossDir), CameraPosition);
			}
		}
	}
	// End:0x983
	if(!bPostRenderTraceSucceeded)
	{
		return;
	}
	// End:0xB8A
	if(bShowLocked)
	{
		HitActor = Trace(HitLocation, HitNormal, Location, CameraPosition, true,,, 8);
		// End:0x9E0
		if(UTVehicle(HitActor) != none)
		{
			return;
		}
		XScale = FClamp(((2.0000000 * TeamBeaconPlayerInfoMaxDist) - Dist) / (float(2) * TeamBeaconPlayerInfoMaxDist), 0.5500000, 1.0000000);
		XScale = XScale * XScale;
		Canvas.SetPos(ScreenLoc.X - (float(16) * XScale), ScreenLoc.Y - (float(16) * XScale));
		Canvas.DrawColor = Class'UTGame.UTHUD'.default.WhiteColor;
		Canvas.DrawTile(Class'UTGame.UTHUD'.default.AltHudTexture, 30.0000000 * XScale, 30.0000000 * XScale, 599.0000000, 208.0000000, 15.0000000, 21.0000000, MakeLinearColor(4.0000000, 2.0000000, 0.5000000, 1.0000000));
		return;
	}
	// End:0xBDC
	if(Dist > TeamBeaconPlayerInfoMaxDist)
	{
		HealthY = (8.0000000 * Canvas.ClipX) / float(1024);		
	}
	else
	{
		// End:0xC54
		if(PlayerReplicationInfo == none)
		{
			HealthY = ((8.0000000 * Canvas.ClipX) / float(1024)) * (float(1) + (float(2) * Square((TeamBeaconPlayerInfoMaxDist - Dist) / TeamBeaconPlayerInfoMaxDist)));			
		}
		else
		{
			HealthY = ((16.0000000 * Canvas.ClipX) / float(1024)) * (float(1) + (float(2) * Square((TeamBeaconPlayerInfoMaxDist - Dist) / TeamBeaconPlayerInfoMaxDist)));
		}
	}
	Class'UTGame.UTHUD'.static.GetTeamColor(int(GetTeamNum()), TeamColor, TextColor);
	// End:0xD2B
	if(Dist > TeamBeaconPlayerInfoMaxDist)
	{
		XL = 2.0000000 * HealthY;		
	}
	else
	{
		// End:0xDD9
		if(PlayerReplicationInfo != none)
		{
			ScreenName = PlayerReplicationInfo.PlayerName;
			Canvas.StrLen(ScreenName, TextXL, YL);
			XL = float(Max(int(TextXL), int(float(2) * HealthY)));
			HealthY *= 0.5000000;			
		}
		else
		{
			XL = 2.0000000 * HealthY;
		}
	}
	// End:0x12FB
	if(!bPlayingSpawnEffect && (UTPawn(PC.Pawn) != none) || UTVehicle_Hoverboard(PC.Pawn) != none)
	{
		// End:0x1265
		if(bShowUseable || ShouldShowUseable(PC, Dist))
		{
			bShowUseable = true;
			// End:0x1009
			if(bRequestedEntryWithFlag && UTPlayerReplicationInfo(PC.PlayerReplicationInfo).bHasFlag)
			{
				HUD.DrawToolTip(Canvas, PC, "GBA_Use", Canvas.ClipX * 0.5000000, Canvas.ClipY * 0.6000000, DropFlagIconCoords.U, DropFlagIconCoords.V, DropFlagIconCoords.UL, DropFlagIconCoords.VL, Canvas.ClipY / float(720));				
			}
			else
			{
				// End:0x1145
				if(bIsInverted && bCanFlip)
				{
					HUD.DrawToolTip(Canvas, PC, "GBA_Use", Canvas.ClipX * 0.5000000, Canvas.ClipY * 0.6000000, FlipToolTipIconCoords.U, FlipToolTipIconCoords.V, FlipToolTipIconCoords.UL, FlipToolTipIconCoords.VL, Canvas.ClipY / float(720));					
				}
				else
				{
					HUD.DrawToolTip(Canvas, PC, "GBA_Use", Canvas.ClipX * 0.5000000, Canvas.ClipY * 0.6000000, EnterToolTipIconCoords.U, EnterToolTipIconCoords.V, EnterToolTipIconCoords.UL, EnterToolTipIconCoords.VL, Canvas.ClipY / float(720));
				}
			}			
		}
		else
		{
			// End:0x12B5
			if(!WorldInfo.GRI.GameClass.default.bTeamGame)
			{
				return;
			}
			// End:0x12EC
			if(bRequestedEntryWithFlag)
			{
				UTPlayerController(PC).bJustFoundVehicle = false;
			}
			bRequestedEntryWithFlag = false;
		}		
	}
	else
	{
		// End:0x134B
		if(!WorldInfo.GRI.GameClass.default.bTeamGame)
		{
			return;
		}
		// End:0x1382
		if(bRequestedEntryWithFlag)
		{
			UTPlayerController(PC).bJustFoundVehicle = false;
		}
		bRequestedEntryWithFlag = false;
	}
	Class'UTGame.UTHUD'.static.DrawBackground(ScreenLoc.X - (0.7000000 * XL), (ScreenLoc.Y - (1.8000000 * YL)) - (1.8000000 * HealthY), 1.4000000 * XL, (1.8000000 * YL) + (1.9000000 * HealthY), TeamColor, Canvas);
	// End:0x156E
	if(ScreenName != "")
	{
		Canvas.DrawColor = TextColor;
		Canvas.SetPos(ScreenLoc.X - (0.5000000 * TextXL), (ScreenLoc.Y - (1.2000000 * YL)) - (1.4000000 * HealthY));
		Canvas.DrawText(ScreenName, true,,, Class'UTGame.UTHUD'.default.TextRenderInfo);
	}
	HealthX = XL * FMin(1.0000000, (GetDisplayedHealth()) / float(HealthMax));
	// End:0x167E
	if((PlayerReplicationInfo != none) && Dist < TeamBeaconPlayerInfoMaxDist)
	{
		Class'UTGame.UTHUD'.static.DrawHealth(ScreenLoc.X - (0.5000000 * XL), (ScreenLoc.Y - (0.2000000 * YL)) - (1.8000000 * HealthY), HealthX, XL, HealthY, Canvas);		
	}
	else
	{
		Class'UTGame.UTHUD'.static.DrawHealth(ScreenLoc.X - (0.5000000 * XL), (ScreenLoc.Y - (0.1000000 * YL)) - (1.4000000 * HealthY), HealthX, XL, HealthY, Canvas);
	}
	// End:0x177E
	if(Dist < TeamBeaconPlayerInfoMaxDist)
	{
		RenderPassengerBeacons(PC, Canvas, TeamColor, TextColor, Weap);
	}
	// End:0x190C
	if((HUD != none) && !HUD.bCrosshairOnFriendly)
	{
		ScreenLoc = Canvas.Project(Location);
		MaxOffset = HUDExtent / Dist;
		// End:0x190C
		if((Abs(ScreenLoc.X - (0.5000000 * Canvas.ClipX)) < (MaxOffset * Canvas.ClipX)) && Abs(ScreenLoc.Y - (0.5000000 * Canvas.ClipY)) < (MaxOffset * Canvas.ClipY))
		{
			HUD.bCrosshairOnFriendly = true;
		}
	}
	//return;	
}

simulated function float GetDisplayedHealth()
{
	return float(Health);
	//return ReturnValue;	
}

simulated function RenderPassengerBeacons(PlayerController PC, Canvas Canvas, LinearColor TeamColor, Color TextColor, UTWeapon Weap)
{
	// End:0x58
	if(PassengerPRI != none)
	{
		PostRenderPassengerBeacon(PC, Canvas, TeamColor, TextColor, Weap, PassengerPRI, PassengerTeamBeaconOffset);
	}
	//return;	
}

simulated function PostRenderPassengerBeacon(PlayerController PC, Canvas Canvas, LinearColor TeamColor, Color TextColor, UTWeapon Weap, PlayerReplicationInfo InPassengerPRI, Vector InPassengerTeamBeaconOffset)
{
	local float TextXL, XL, YL;
	local Vector ScreenLoc, X, Y, Z;

	GetAxes(Rotation, X, Y, Z);
	ScreenLoc = Canvas.Project(((Location + (InPassengerTeamBeaconOffset.X * X)) + (InPassengerTeamBeaconOffset.Y * Y)) + (InPassengerTeamBeaconOffset.Z * Z));
	// End:0x1A1
	if((((ScreenLoc.X < float(0)) || ScreenLoc.X >= Canvas.ClipX) || ScreenLoc.Y < float(0)) || ScreenLoc.Y >= Canvas.ClipY)
	{
		return;
	}
	// End:0x1EB
	if((Weap != none) && Weap.CoversScreenSpace(ScreenLoc, Canvas))
	{
		return;		
	}
	else
	{
		// End:0x26E
		if((UTVehicle_Hoverboard(PC.Pawn) != none) && UTVehicle_Hoverboard(PC.Pawn).CoversScreenSpace(ScreenLoc, Canvas))
		{
			return;
		}
	}
	Canvas.StrLen(InPassengerPRI.PlayerName, TextXL, YL);
	XL = FMax(TextXL, (64.0000000 * Canvas.ClipX) / float(1024));
	Class'UTGame.UTHUD'.static.DrawBackground(ScreenLoc.X - (0.7000000 * XL), ScreenLoc.Y - (1.8000000 * YL), 1.4000000 * XL, 1.8000000 * YL, TeamColor, Canvas);
	Canvas.DrawColor = TextColor;
	Canvas.SetPos(ScreenLoc.X - (0.5000000 * TextXL), ScreenLoc.Y - (1.4000000 * YL));
	Canvas.DrawText(InPassengerPRI.PlayerName, true,,, Class'UTGame.UTHUD'.default.TextRenderInfo);
	//return;	
}

simulated event ScriptSetTeamNum(byte T)
{
	// End:0x38
	if(int(T) != int(Team))
	{
		Team = T;
		TeamChanged();
	}
	//return;	
}

simulated function TeamChanged()
{
	local MaterialInterface NewMaterial;

	// End:0x144
	if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		// End:0x82
		if((int(Team) < TeamMaterials.Length) && TeamMaterials[int(Team)] != none)
		{
			NewMaterial = TeamMaterials[int(Team)];			
		}
		else
		{
			// End:0xBA
			if((TeamMaterials.Length > 0) && TeamMaterials[0] != none)
			{
				NewMaterial = TeamMaterials[0];
			}
		}
		// End:0x130
		if(NewMaterial != none)
		{
			// End:0x107
			if(DamageMaterialInstance[0] != none)
			{
				DamageMaterialInstance[0].SetParent(NewMaterial);				
			}
			else
			{
				Mesh.SetMaterial(0, NewMaterial);
			}
		}
		TeamChanged_VehicleEffects();
		UpdateDamageMaterial();
	}
	//return;	
}

simulated function TeamChanged_VehicleEffects()
{
	local int Len, TeamNum, VehicleEffectIndex;
	local ParticleSystem NewTemplate;

	InitializeEffects();
	TeamNum = int(GetTeamNum());
	Len = VehicleEffects.Length;
	VehicleEffectIndex = 0;
	J0x3F:

	// End:0x1B3 [Loop If]
	if(VehicleEffectIndex < Len)
	{
		// End:0x1A5
		if((VehicleEffects[VehicleEffectIndex].EffectTemplate_Blue != none) && VehicleEffects[VehicleEffectIndex].EffectRef != none)
		{
			NewTemplate = ((TeamNum == 1) ? VehicleEffects[VehicleEffectIndex].EffectTemplate_Blue : VehicleEffects[VehicleEffectIndex].EffectTemplate);
			// End:0x1A5
			if(VehicleEffects[VehicleEffectIndex].EffectRef.Template != NewTemplate)
			{
				VehicleEffects[VehicleEffectIndex].EffectRef.SetTemplate(NewTemplate);
			}
		}
		++VehicleEffectIndex;
		// [Loop Continue]
		goto J0x3F;
	}
	//return;	
}

function bool Dodge(Actor.EDoubleClickDir DoubleClickMove)
{
	//return ReturnValue;	
}

event IncomingMissile(Projectile P)
{
	local AIController C;

	C = AIController(Controller);
	// End:0xCD
	if(((C != none) && C.Skill >= 5.0000000) && (C.Enemy == none) || !C.LineOfSightTo(C.Enemy))
	{
		ShootMissile(P);
	}
	//return;	
}

function ShootMissile(Projectile P)
{
	Controller.Focus = P;
	Controller.FireWeaponAt(P);
	//return;	
}

simulated function SendLockOnMessage(int Switch)
{
	local int I;
	local Pawn P;

	I = 0;
	J0x0B:

	// End:0x19E [Loop If]
	if(I < Seats.Length)
	{
		P = Seats[I].SeatPawn;
		// End:0x190
		if((((P != none) && PlayerController(P.Controller) != none) && P.IsLocallyControlled()) && P.Controller.Pawn == P)
		{
			PlayerController(P.Controller).ReceiveLocalizedMessage(Class'UTGame.UTLockWarningMessage', Switch);
			PlayerController(P.Controller).ClientPlaySound(LockedOnSound);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

simulated event LockOnWarning(UDKProjectile IncomingMissile)
{
	SendLockOnMessage(1);
	//return;	
}

function bool TooCloseToAttack(Actor Other)
{
	local int NeededPitch, I;
	local bool bControlledWeaponPawn;

	// End:0x37
	if(VSize(Location - Other.Location) > 2500.0000000)
	{
		return false;
	}
	// End:0x15C
	if(Weapon == none)
	{
		// End:0x59
		if(Seats.Length < 2)
		{
			return false;
		}
		I = 0;
		J0x64:

		// End:0x151 [Loop If]
		if(I < Seats.Length)
		{
			// End:0x143
			if((Seats[I].SeatPawn != none) && Seats[I].SeatPawn.Controller != none)
			{
				bControlledWeaponPawn = true;
				// End:0x143
				if(!Seats[I].SeatPawn.TooCloseToAttack(Other))
				{
					return false;
				}
			}
			I++;
			// [Loop Continue]
			goto J0x64;
		}
		return bControlledWeaponPawn;
	}
	NeededPitch = Rotator(Other.GetTargetLocation(self) - Weapon.GetPhysicalFireStartLoc()).Pitch & 65535;
	return CheckTurretPitchLimit(NeededPitch, 0);
	//return ReturnValue;	
}

function bool CheckTurretPitchLimit(int NeededPitch, int SeatIndex)
{
	local int I;

	// End:0x19D
	if(SeatIndex >= 0)
	{
		// End:0xEE
		if(Seats[SeatIndex].TurretControllers.Length > 0)
		{
			I = 0;
			J0x47:

			// End:0xE9 [Loop If]
			if(I < Seats[SeatIndex].TurretControllers.Length)
			{
				// End:0xDB
				if(!Seats[SeatIndex].TurretControllers[I].WouldConstrainPitch(NeededPitch, Mesh))
				{
					return false;
				}
				I++;
				// [Loop Continue]
				goto J0x47;
			}
			return true;			
		}
		else
		{
			// End:0x19D
			if(Seats[SeatIndex].Gun != none)
			{
				return Cos(Abs(float(NeededPitch - (Rotation.Pitch & 65535))) / 182.0444031) > UTVehicleWeapon(Seats[SeatIndex].Gun).GetMaxFinalAimAdjustment();
			}
		}
	}
	return false;
	//return ReturnValue;	
}

function PlayHorn()
{
	local int I, NumPositions;
	local Pawn P;
	local UTPawn UTP;
	local UTVehicle V;

	// End:0xA9
	if((((WorldInfo.TimeSeconds - LastHornTime) > 1.0000000) && HornIndex >= 0) && HornIndex < HornSounds.Length)
	{
		PlaySound(HornSounds[HornIndex]);
		LastHornTime = WorldInfo.TimeSeconds;
	}
	// End:0x347
	if(PlayerController(Controller) != none)
	{
		I = 0;
		J0xCC:

		// End:0x13E [Loop If]
		if(I < Seats.Length)
		{
			// End:0x130
			if(Seats[I].SeatPawn.Controller == none)
			{
				NumPositions++;
			}
			I++;
			// [Loop Continue]
			goto J0xCC;
		}
		// End:0x347
		if(NumPositions > 0)
		{
			// End:0x346
			foreach VisibleCollidingActors(Class'Engine.Pawn', P, HornAIRadius)
			{
				// End:0x345
				if((UTBot(P.Controller) != none) && WorldInfo.GRI.OnSameTeam(P, self))
				{
					V = UTVehicle(P);
					// End:0x2CA
					if(V != none)
					{
						UTP = UTPawn(V.Driver);
						// End:0x2CA
						if(((UTP != none) && UTP.HoverboardClass == V.Class) && V.DriverLeave(false))
						{
							P = UTP;
						}
					}
					// End:0x345
					if(Vehicle(P) == none)
					{
						UTBot(P.Controller).SetTemporaryOrders('Follow', Controller);
						// End:0x345
						if(--NumPositions == 0)
						{
							// End:0x346
							break;
						}
					}
				}				
			}			
		}
	}
	//return;	
}

function UpdateControllerOnPossess(bool bVehicleTransition)
{
	//return;	
}

simulated function int NumPassengers()
{
	local int I, Num;

	I = 0;
	J0x0B:

	// End:0xAB [Loop If]
	if(I < Seats.Length)
	{
		// End:0x9D
		if((Seats[I].SeatPawn != none) && Seats[I].SeatPawn.Controller != none)
		{
			Num++;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return Num;
	//return ReturnValue;	
}

function UTVehicle GetMoveTargetFor(Pawn P)
{
	return self;
	//return ReturnValue;	
}

function HandleEnteringFlag(UTPlayerReplicationInfo EnteringPRI)
{
	// End:0xAB
	if(EnteringPRI.bHasFlag)
	{
		// End:0x6A
		if(!bCanCarryFlag)
		{
			EnteringPRI.GetFlag().Drop();			
		}
		else
		{
			// End:0xAB
			if(!bDriverHoldsFlag)
			{
				AttachFlag(EnteringPRI.GetFlag(), Driver);
			}
		}
	}
	//return;	
}

function bool DriverEnter(Pawn P)
{
	local UTPlayerController PC;

	P.StopFiring();
	// End:0x80
	if(Seats[0].Gun != none)
	{
		InvManager.SetCurrentWeapon(Seats[0].Gun);
	}
	Instigator = self;
	// End:0xA5
	if(!super(UDKVehicleBase).DriverEnter(P))
	{
		return false;
	}
	HandleEnteringFlag(UTPlayerReplicationInfo(PlayerReplicationInfo));
	SetSeatStoragePawn(0, P);
	// End:0x111
	if(ParentFactory != none)
	{
		ParentFactory.TriggerEventClass(Class'UTGame.UTSeqEvent_VehicleFactory', none, 3);
	}
	// End:0x138
	if(PlayerController(Controller) != none)
	{
		VehicleLostTime = 0.0000000;
	}
	StuckCount = 0;
	ResetTime = WorldInfo.TimeSeconds - float(1);
	bHasBeenDriven = true;
	// End:0x204
	if(bKeyVehicle)
	{
		// End:0x203
		foreach WorldInfo.AllControllers(Class'UTGame.UTPlayerController', PC)
		{
			// End:0x202
			if(PC.LastAutoObjective == self)
			{
				PC.CheckAutoObjective(true);
			}			
		}		
	}
	return true;
	//return ReturnValue;	
}

simulated event HoldGameObject(UDKCarriedObject GameObj)
{
	local UTPawn P;
	local UTCarriedObject UTGameObj;

	UTGameObj = UTCarriedObject(GameObj);
	UTGameObj.SetHardAttach(UTGameObj.default.bHardAttach);
	UTGameObj.bIgnoreBaseRotation = UTGameObj.default.bIgnoreBaseRotation;
	// End:0xFC
	if(bDriverHoldsFlag)
	{
		P = UTPawn(Driver);
		// End:0xF9
		if(P != none)
		{
			P.HoldGameObject(UTGameObj);
		}		
	}
	else
	{
		AttachFlag(UTGameObj, Driver);
	}
	//return;	
}

simulated function AttachFlag(UTCarriedObject FlagActor, Pawn NewDriver)
{
	// End:0x109
	if(FlagActor != none)
	{
		// End:0x8D
		if(FlagBone == 'None')
		{
			FlagActor.BaseBoneName = 'None';
			FlagActor.BaseSkelComponent = none;
			FlagActor.SetBase(self);			
		}
		else
		{
			FlagActor.SetBase(self,, Mesh, FlagBone);
		}
		FlagActor.SetRelativeRotation(FlagRotation);
		FlagActor.SetRelativeLocation(FlagOffset);
	}
	//return;	
}

exec function FixedView(string VisibleMeshes)
{
	local int SeatIdx;
	local UTPawn P;

	SeatIdx = 0;
	J0x0B:

	// End:0xB6 [Loop If]
	if(SeatIdx < Seats.Length)
	{
		P = UTPawn(Seats[SeatIdx].SeatPawn.Driver);
		// End:0xA8
		if(P != none)
		{
			P.FixedView(VisibleMeshes);
		}
		++SeatIdx;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function DriverLeft()
{
	local float Dist;
	local UTPlayerReplicationInfo DriverPRI;

	DriverPRI = UTPlayerReplicationInfo(Driver.PlayerReplicationInfo);
	// End:0xC5
	if(((DriverPRI != none) && DriverPRI.bHasFlag) && UDKPawn(Driver) != none)
	{
		UDKPawn(Driver).HoldGameObject(DriverPRI.GetFlag());
	}
	super(UDKVehicleBase).DriverLeft();
	// End:0xFE
	if((bNeverReset || ParentFactory == none) || Occupied())
	{
		return;
	}
	Dist = VSize(Location - ParentFactory.Location);
	// End:0x1D5
	if((Dist >= float(2000)) && (Dist > float(5000)) || !FastTrace(ParentFactory.Location, Location))
	{
		ResetTime = WorldInfo.TimeSeconds + ((bKeyVehicle) ? 15.0000000 : 30.0000000);
	}
	//return;	
}

function int GetFirstAvailableSeat()
{
	local int I;

	I = 1;
	J0x0B:

	// End:0x51 [Loop If]
	if(I < Seats.Length)
	{
		// End:0x43
		if(SeatAvailable(I))
		{
			return I;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return -1;
	//return ReturnValue;	
}

function bool PassengerEnter(Pawn P, int SeatIndex)
{
	// End:0x7E
	if(WorldInfo.Game.bTeamGame && !WorldInfo.GRI.OnSameTeam(P, self))
	{
		return false;
	}
	// End:0xF4
	if((SeatIndex <= 0) || SeatIndex >= Seats.Length)
	{
		WarnInternal("Attempted to add a passenger to unavailable passenger seat" @ string(SeatIndex));
		return false;
	}
	// End:0x140
	if(!Seats[SeatIndex].SeatPawn.DriverEnter(P))
	{
		return false;
	}
	HandleEnteringFlag(UTPlayerReplicationInfo(Seats[SeatIndex].SeatPawn.PlayerReplicationInfo));
	SetSeatStoragePawn(SeatIndex, P);
	bHasBeenDriven = true;
	return true;
	//return ReturnValue;	
}

event bool DriverLeave(bool bForceLeave)
{
	local bool bResult;
	local Pawn OldDriver;

	// End:0x22
	if(!bForceLeave && !bAllowedExit)
	{
		return false;
	}
	OldDriver = Driver;
	bResult = super(Vehicle).DriverLeave(bForceLeave);
	// End:0xBC
	if(bResult)
	{
		SetSeatStoragePawn(0, none);
		Instigator = OldDriver;
		// End:0xBC
		if(ParentFactory != none)
		{
			ParentFactory.TriggerEventClass(Class'UTGame.UTSeqEvent_VehicleFactory', none, 4);
		}
	}
	return bResult;
	//return ReturnValue;	
}

function PassengerLeave(int SeatIndex)
{
	SetSeatStoragePawn(SeatIndex, none);
	//return;	
}

event CheckReset()
{
	local Pawn P;
	local Controller C;

	// End:0x3C
	if(Occupied())
	{
		ResetTime = WorldInfo.TimeSeconds - float(1);
		return;
	}
	// End:0x26B
	foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
	{
		P = C.Pawn;
		// End:0x26A
		if(((P != none) && WorldInfo.GRI.OnSameTeam(P, self)) && VSize(Location - P.Location) < 2500.0000000)
		{
			// End:0x215
			if((PlayerController(C) != none) || Instigator == C.Pawn)
			{
				// End:0x212
				if(FastTrace(P.Location + (P.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000)), Location + ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.0000000))))
				{
					ResetTime = WorldInfo.TimeSeconds + float(10);					
					return;
				}
				// End:0x26A
				continue;
			}
			// End:0x26A
			if(C.RouteGoal == self)
			{
				ResetTime = WorldInfo.TimeSeconds + float(10);				
				return;
			}
		}		
	}	
	// End:0x2B6
	if(bKeyVehicle && Health < (HealthMax / 2))
	{
		Died(none, Class'Engine.DamageType', Location);		
	}
	else
	{
		// End:0x30F
		if(ParentFactory != none)
		{
			ParentFactory.ChildVehicle = none;
			ParentFactory.SpawnVehicle();
			ParentFactory = none;
		}
		Destroy();
	}
	//return;	
}

function bool Occupied()
{
	local int I;

	// End:0x11
	if(Controller != none)
	{
		return true;
	}
	I = 0;
	J0x1C:

	// End:0x5C [Loop If]
	if(I < Seats.Length)
	{
		// End:0x4E
		if(!SeatAvailable(I))
		{
			return true;
		}
		I++;
		// [Loop Continue]
		goto J0x1C;
	}
	return false;
	//return ReturnValue;	
}

function bool OpenPositionFor(Pawn P)
{
	local int I;

	// End:0x18D
	if(((((UTGame(WorldInfo.Game).JustStarted(20.0000000) && Reservation != none) && Reservation != P.Controller) && Reservation.RouteGoal == self) && Reservation.Pawn != none) && VSize(Reservation.Pawn.Location - Location) <= VSize(P.Location - Location))
	{
		I = 0;
		J0x14D:

		// End:0x18B [Loop If]
		if(I < Seats.Length)
		{
			// End:0x17D
			if(SeatAvailable(I))
			{
				return true;
			}
			I++;
			// [Loop Continue]
			goto J0x14D;
		}
		return false;
	}
	// End:0x19E
	if(Controller == none)
	{
		return true;
	}
	// End:0x1EB
	if(!WorldInfo.GRI.OnSameTeam(Controller, P))
	{
		return false;
	}
	I = 0;
	J0x1F6:

	// End:0x234 [Loop If]
	if(I < Seats.Length)
	{
		// End:0x226
		if(SeatAvailable(I))
		{
			return true;
		}
		I++;
		// [Loop Continue]
		goto J0x1F6;
	}
	return false;
	//return ReturnValue;	
}

function float BotDesireability(UTSquadAI S, int TeamIndex, Actor Objective)
{
	local bool bSameTeam;
	local PlayerController P;

	bSameTeam = (int(Team) == TeamIndex) || int(Team) == 128;
	// End:0x10D
	if(bSameTeam)
	{
		// End:0x10D
		if(!bKeyVehicle && WorldInfo.TimeSeconds < PlayerStartTime)
		{
			// End:0xA2
			foreach LocalPlayerControllers(Class'Engine.PlayerController', P)
			{
				// End:0xA2
				break;				
			}			
			// End:0x10D
			if((P == none) || (P.Pawn != none) && Vehicle(P.Pawn) == none)
			{
				return 0.0000000;
			}
		}
	}
	// End:0x164
	if((!bKeyVehicle && !bStationary) && WorldInfo.TimeSeconds < VehicleLostTime)
	{
		return 0.0000000;		
	}
	else
	{
		// End:0x1B7
		if((((Health <= 0) || bIsDisabled) || bTeamLocked && !bSameTeam) || Occupied())
		{
			return 0.0000000;
		}
	}
	// End:0x1CA
	if(bKeyVehicle)
	{
		return 100.0000000;
	}
	return (MaxDesireability * 0.5000000) + ((MaxDesireability * 0.5000000) * (float(Health) / float(HealthMax)));
	//return ReturnValue;	
}

function float ReservationCostMultiplier(Pawn P)
{
	// End:0x32
	if(Reservation == P.Controller)
	{
		return 1.0000000;
	}
	// End:0x126
	if(((UTGame(WorldInfo.Game).JustStarted(20.0000000) && Reservation != none) && Reservation.Pawn != none) && VSize(Reservation.Pawn.Location - Location) <= VSize(P.Location - Location))
	{
		return 0.0000000;
	}
	// End:0x161
	if((Reservation == none) || Reservation.Pawn == none)
	{
		return 1.0000000;
	}
	// End:0x1C9
	if((Reservation.MoveTarget == self) && Reservation.InLatentExecution(Reservation.503))
	{
		return 0.0000000;
	}
	return 0.2500000;
	//return ReturnValue;	
}

function bool SpokenFor(Controller C)
{
	local UTBot B;

	// End:0x11
	if(Reservation == none)
	{
		return false;
	}
	// End:0x71
	if((Reservation.Pawn == none) || Vehicle(Reservation.Pawn) != none)
	{
		Reservation = none;
		return false;
	}
	// End:0x147
	if((((Reservation.RouteGoal != self) && (Reservation.RouteGoal != LastAnchor) || LastAnchor == none) && Reservation.MoveTarget != self) || !Reservation.InLatentExecution(Reservation.503))
	{
		Reservation = none;
		return false;
	}
	// End:0x194
	if(!WorldInfo.GRI.OnSameTeam(Reservation, C))
	{
		return false;
	}
	B = UTBot(C);
	// End:0x1C1
	if(B == none)
	{
		return true;
	}
	// End:0x210
	if(Seats.Length > 0)
	{
		return B.Squad != Reservation.Squad;
	}
	// End:0x2DC
	if(UTGame(WorldInfo.Game).JustStarted(20.0000000))
	{
		// End:0x2DC
		if(VSize(Reservation.Pawn.Location - Location) > VSize(C.Pawn.Location - Location))
		{
			return false;
		}
	}
	return true;
	//return ReturnValue;	
}

simulated function bool StopsProjectile(Projectile P)
{
	// End:0x26
	if(P.Instigator == self)
	{
		return false;
	}
	return ((P.Instigator == none) || P.Instigator.Base != self) || !P.Instigator.IsA('UTWeaponPawn');
	//return ReturnValue;	
}

function SetReservation(Controller C)
{
	// End:0x34
	if(!SpokenFor(C))
	{
		Reservation = UTBot(C);
	}
	//return;	
}

function bool TeamLink(int TeamNum)
{
	return ((LinkHealMult > float(0)) && int(Team) == TeamNum) && Health > 0;
	//return ReturnValue;	
}

simulated function bool AllowLinkThroughOwnedActor(Actor OwnedActor)
{
	//return ReturnValue;	
}

function bool HealDamage(int Amount, Controller Healer, Class<DamageType> DamageType)
{
	// End:0x46
	if(PlayerController(Healer) != none)
	{
		PlayerStartTime = WorldInfo.TimeSeconds + float(3);
	}
	// End:0x81
	if(((Health <= 0) || Health >= HealthMax) || Amount <= 0)
	{
		return false;
	}
	Amount = Min(int(float(Amount) * LinkHealMult), HealthMax - Health);
	Health += Amount;
	// End:0x10E
	if((Health >= HealthMax) && SpawnInSound != none)
	{
		PlaySound(SpawnInSound);
	}
	bForceNetUpdate = true;
	ApplyMorphHeal(Amount);
	// End:0x18F
	if((ResetTime - WorldInfo.TimeSeconds) < 10.0000000)
	{
		ResetTime = WorldInfo.TimeSeconds + 10.0000000;
	}
	CheckDamageSmoke();
	return true;
	//return ReturnValue;	
}

function IncrementLinkedToCount()
{
	// End:0x20
	if(int(LinkedToCount++) == int(0))
	{
		StartLinkedEffect();
	}
	//return;	
}

function DecrementLinkedToCount()
{
	// End:0x2C
	if(int(--LinkedToCount) <= int(0))
	{
		LinkedToCount = 0;
		StopLinkedEffect();
	}
	//return;	
}

protected simulated function StartLinkedEffect()
{
	local MaterialInstanceConstant MIC;
	local LinearColor Red, Blue;
	local int I;

	Red = MakeLinearColor(4.0000000, 0.1000000, 0.0000000, 1.0000000);
	Blue = MakeLinearColor(0.0000000, 1.0000000, 4.0000000, 1.0000000);
	I = 0;
	J0x5B:

	// End:0x2A4 [Loop If]
	if((I < Mesh.Materials.Length) || I < Mesh.SkeletalMesh.Materials.Length)
	{
		// End:0x134
		if(I < Mesh.Materials.Length)
		{
			MIC = MaterialInstanceConstant(Mesh.Materials[I]);
		}
		// End:0x237
		if(MIC == none)
		{
			// End:0x205
			if((I >= Mesh.Materials.Length) || Mesh.Materials[I] == none)
			{
				Mesh.SetMaterial(I, Mesh.SkeletalMesh.Materials[I]);
			}
			MIC = Mesh.CreateAndSetMaterialInstanceConstant(I);
		}
		// End:0x296
		if(MIC != none)
		{
			MIC.SetVectorParameterValue('Veh_OverlayColor', ((int(Team) == int(1)) ? Blue : Red));
		}
		I++;
		// [Loop Continue]
		goto J0x5B;
	}
	// End:0x2D5
	if(LinkedToAudio == none)
	{
		LinkedToAudio = CreateAudioComponent(LinkedToCue, false, true);
	}
	// End:0x30D
	if(LinkedToAudio != none)
	{
		LinkedToAudio.FadeIn(0.2000000, 1.0000000);
	}
	//return;	
}

protected simulated function StopLinkedEffect()
{
	local MaterialInstanceConstant MIC;
	local LinearColor Black;
	local int I;

	I = 0;
	J0x0B:

	// End:0xC1 [Loop If]
	if(I < Mesh.Materials.Length)
	{
		MIC = MaterialInstanceConstant(Mesh.Materials[I]);
		// End:0xB3
		if(MIC != none)
		{
			MIC.SetVectorParameterValue('Veh_OverlayColor', Black);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	PlaySound(LinkedEndSound, true);
	// End:0x11D
	if(LinkedToAudio != none)
	{
		LinkedToAudio.FadeOut(0.1000000, 0.0000000);
		LinkedToAudio = none;
	}
	//return;	
}

function PlayHit(float Damage, Controller InstigatedBy, Vector HitLocation, Class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo)
{
	local UTPlayerController Hearer;
	local Class<UTDamageType> UTDamage;

	// End:0xA2
	if(((InstigatedBy != none) && Class<UTDamageType>(DamageType) != none) && Class<UTDamageType>(DamageType).default.bDirectDamage)
	{
		Hearer = UTPlayerController(InstigatedBy);
		// End:0xA2
		if(Hearer != none)
		{
			Hearer.bAcuteHearing = true;
		}
	}
	super(Pawn).PlayHit(Damage, InstigatedBy, HitLocation, DamageType, Momentum, HitInfo);
	// End:0x112
	if(Hearer != none)
	{
		Hearer.bAcuteHearing = false;
	}
	// End:0x30E
	if((Damage > float(0)) || (Controller != none) && Controller.bGodMode)
	{
		CheckHitInfo(HitInfo, Mesh, Normal(Momentum), HitLocation);
		LastTakeHitInfo.Damage = int(Damage);
		LastTakeHitInfo.HitLocation = HitLocation;
		LastTakeHitInfo.Momentum = Momentum;
		LastTakeHitInfo.DamageType = DamageType;
		LastTakeHitInfo.HitBone = HitInfo.BoneName;
		UTDamage = Class<UTDamageType>(DamageType);
		LastTakeHitTimeout = WorldInfo.TimeSeconds + ((UTDamage != none) ? UTDamage.static.GetHitEffectDuration(self, Damage) : Class'UTGame.UTDamageType'.static.GetHitEffectDuration(self, Damage));
		PlayTakeHitEffects();
	}
	//return;	
}

simulated event PlayTakeHitEffects()
{
	local Class<UTDamageType> UTDamage;

	// End:0xE9
	if(EffectIsRelevant(Location, false))
	{
		UTDamage = Class<UTDamageType>(LastTakeHitInfo.DamageType);
		// End:0xE9
		if(UTDamage != none)
		{
			UTDamage.static.SpawnHitEffect(self, float(LastTakeHitInfo.Damage), LastTakeHitInfo.Momentum, LastTakeHitInfo.HitBone, LastTakeHitInfo.HitLocation);
		}
	}
	ApplyMorphDamage(LastTakeHitInfo.HitLocation, LastTakeHitInfo.Damage, LastTakeHitInfo.Momentum);
	ClientHealth -= LastTakeHitInfo.Damage;
	//return;	
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum, Actor DamageCauser)
{
	local int I;

	super(Pawn).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum, DamageCauser);
	I = 1;
	J0x4B:

	// End:0x10F [Loop If]
	if(I < Seats.Length)
	{
		// End:0x101
		if(Seats[I].SeatPawn != none)
		{
			Seats[I].SeatPawn.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum, DamageCauser);
		}
		I++;
		// [Loop Continue]
		goto J0x4B;
	}
	//return;	
}

simulated event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	// End:0xA8
	if(int(Role) == int(ROLE_Authority))
	{
		// End:0x69
		if((UTPawn(Driver) != none) && UTPawn(Driver).bIsInvulnerable)
		{
			Damage = 0;			
		}
		else
		{
			// End:0xA8
			if(DamageType == Class'UTGame.UTDmgType_ScorpionSelfDestruct')
			{
				Damage = Class'UTGame.UTDmgType_ScorpionSelfDestruct'.default.DamageGivenForSelfDestruct;
			}
		}
	}
	super(Vehicle).TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	// End:0x10F
	if(int(Role) == int(ROLE_Authority))
	{
		CheckDamageSmoke();
	}
	//return;	
}

event Actor GetHomingTarget(UTProjectile Seeker, Controller InstigatedBy)
{
	return self;
	//return ReturnValue;	
}

function bool ImportantVehicle()
{
	return false;
	//return ReturnValue;	
}

function InitializeSeats()
{
	local int I;

	// End:0x5E
	if(Seats.Length == 0)
	{
		LogInternal(("WARNING: Vehicle (" $ string(self)) $ ") **MUST** have at least one seat defined");
		Destroy();
		return;
	}
	I = 0;
	J0x69:

	// End:0x7B0 [Loop If]
	if(I < Seats.Length)
	{
		// End:0x545
		if(I > 0)
		{
			Seats[I].SeatPawn = Spawn(Class'UTGame.UTWeaponPawn');
			Seats[I].SeatPawn.SetBase(self);
			Seats[I].Gun = UTVehicleWeapon(Seats[I].SeatPawn.InvManager.CreateInventory(Seats[I].GunClass));
			Seats[I].Gun.SetBase(self);
			Seats[I].SeatPawn.EyeHeight = Seats[I].SeatPawn.BaseEyeHeight;
			UTWeaponPawn(Seats[I].SeatPawn).MyVehicleWeapon = UTVehicleWeapon(Seats[I].Gun);
			UTWeaponPawn(Seats[I].SeatPawn).MyVehicle = self;
			UTWeaponPawn(Seats[I].SeatPawn).MySeatIndex = I;
			// End:0x408
			if(Seats[I].ViewPitchMin != 0.0000000)
			{
				UTWeaponPawn(Seats[I].SeatPawn).ViewPitchMin = Seats[I].ViewPitchMin;				
			}
			else
			{
				UTWeaponPawn(Seats[I].SeatPawn).ViewPitchMin = ViewPitchMin;
			}
			// End:0x4F4
			if(Seats[I].ViewPitchMax != 0.0000000)
			{
				UTWeaponPawn(Seats[I].SeatPawn).ViewPitchMax = Seats[I].ViewPitchMax;				
			}
			else
			{
				UTWeaponPawn(Seats[I].SeatPawn).ViewPitchMax = ViewPitchMax;
			}			
		}
		else
		{
			Seats[I].SeatPawn = self;
			Seats[I].Gun = UTVehicleWeapon(InvManager.CreateInventory(Seats[I].GunClass));
			Seats[I].Gun.SetBase(self);
		}
		Seats[I].SeatPawn.DriverDamageMult = Seats[I].DriverDamageMult;
		Seats[I].SeatPawn.bDriverIsVisible = Seats[I].bSeatVisible;
		// End:0x7A2
		if(Seats[I].Gun != none)
		{
			UTVehicleWeapon(Seats[I].Gun).SeatIndex = I;
			UTVehicleWeapon(Seats[I].Gun).MyVehicle = self;
		}
		I++;
		// [Loop Continue]
		goto J0x69;
	}
	//return;	
}

simulated function PreCacheSeatNames()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x1AC [Loop If]
	if(I < Seats.Length)
	{
		Seats[I].WeaponRotationName = name(Seats[I].TurretVarPrefix $ "WeaponRotation");
		Seats[I].FlashLocationName = name(Seats[I].TurretVarPrefix $ "FlashLocation");
		Seats[I].FlashCountName = name(Seats[I].TurretVarPrefix $ "FlashCount");
		Seats[I].FiringModeName = name(Seats[I].TurretVarPrefix $ "FiringMode");
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

simulated function InitializeTurrets()
{
	local int Seat, I;
	local UTSkelControl_TurretConstrained Turret;
	local Vector PivotLoc, MuzzleLoc;

	// End:0x26
	if(Mesh == none)
	{
		WarnInternal("No Mesh for" @ string(self));		
	}
	else
	{
		Seat = 0;
		J0x31:

		// End:0x32E [Loop If]
		if(Seat < Seats.Length)
		{
			I = 0;
			J0x54:

			// End:0x254 [Loop If]
			if(I < Seats[Seat].TurretControls.Length)
			{
				Turret = UTSkelControl_TurretConstrained(Mesh.FindSkelControl(Seats[Seat].TurretControls[I]));
				// End:0x190
				if(Turret != none)
				{
					Turret.AssociatedSeatIndex = Seat;
					Seats[Seat].TurretControllers[I] = Turret;
					Turret.InitTurret(Rotation, Mesh);					
				}
				else
				{
					WarnInternal((((((("Failed to find skeletal controller named" @ string(Seats[Seat].TurretControls[I])) @ "(Seat ") $ string(Seat)) $ ") for") @ string(self)) @ "in AnimTree") @ string(Mesh.AnimTreeTemplate));
				}
				I++;
				// [Loop Continue]
				goto J0x54;
			}
			// End:0x285
			if(int(Role) == int(ROLE_Authority))
			{
				SeatWeaponRotation(Seat, Rotation, false);
			}
			PivotLoc = GetSeatPivotPoint(Seat);
			GetBarrelLocationAndRotation(Seat, MuzzleLoc);
			Seats[Seat].PivotFireOffsetZ = MuzzleLoc.Z - PivotLoc.Z;
			Seat++;
			// [Loop Continue]
			goto J0x31;
		}
	}
	//return;	
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	super(Vehicle).PossessedBy(C, bVehicleTransition);
	// End:0x77
	if(Seats[0].Gun != none)
	{
		Seats[0].Gun.ClientWeaponSet(false);
	}
	//return;	
}

simulated function SetFiringMode(Weapon Weap, byte FiringModeNum)
{
	SeatFiringMode(0, FiringModeNum, false);
	//return;	
}

simulated function ClearFlashCount(Weapon Who)
{
	local UTVehicleWeapon VWeap;

	VWeap = UTVehicleWeapon(Who);
	// End:0x7E
	if(VWeap != none)
	{
		VehicleAdjustFlashCount(VWeap.SeatIndex, SeatFiringMode(VWeap.SeatIndex,, true), true);
	}
	//return;	
}

simulated function IncrementFlashCount(Weapon Who, byte FireModeNum)
{
	local UTVehicleWeapon VWeap;

	VWeap = UTVehicleWeapon(Who);
	// End:0x5D
	if(VWeap != none)
	{
		VehicleAdjustFlashCount(VWeap.SeatIndex, FireModeNum, false);
	}
	//return;	
}

simulated function SetFlashLocation(Weapon Who, byte FireModeNum, Vector NewLoc)
{
	local UTVehicleWeapon VWeap;

	VWeap = UTVehicleWeapon(Who);
	// End:0x66
	if(VWeap != none)
	{
		VehicleAdjustFlashLocation(VWeap.SeatIndex, FireModeNum, NewLoc, false);
	}
	//return;	
}

function ClearFlashLocation(Weapon Who)
{
	local UTVehicleWeapon VWeap;

	VWeap = UTVehicleWeapon(Who);
	// End:0x8B
	if(VWeap != none)
	{
		VehicleAdjustFlashLocation(VWeap.SeatIndex, SeatFiringMode(VWeap.SeatIndex,, true), vect(0.0000000, 0.0000000, 0.0000000), true);
	}
	//return;	
}

simulated event GetBarrelLocationAndRotation(int SeatIndex, out Vector SocketLocation, optional out Rotator SocketRotation)
{
	// End:0x9D
	if(Seats[SeatIndex].GunSocket.Length > 0)
	{
		Mesh.GetSocketWorldLocationAndRotation(Seats[SeatIndex].GunSocket[GetBarrelIndex(SeatIndex)], SocketLocation, SocketRotation);		
	}
	else
	{
		SocketLocation = Location;
		SocketRotation = Rotation;
	}
	//return;	
}

simulated function Vector GetEffectLocation(int SeatIndex)
{
	local Vector SocketLocation;

	// End:0x37
	if(Seats[SeatIndex].GunSocket.Length == 0)
	{
		return Location;
	}
	GetBarrelLocationAndRotation(SeatIndex, SocketLocation);
	return SocketLocation;
	//return ReturnValue;	
}

simulated function Vector GetPhysicalFireStartLoc(UTWeapon ForWeapon)
{
	local UTVehicleWeapon VWeap;

	VWeap = UTVehicleWeapon(ForWeapon);
	// End:0x57
	if(VWeap != none)
	{
		return GetEffectLocation(VWeap.SeatIndex);		
	}
	else
	{
		return Location;
	}
	//return ReturnValue;	
}

function Rotator GetWeaponAim(UTVehicleWeapon VWeapon)
{
	local Vector SocketLocation, CameraLocation, RealAimPoint, DesiredAimPoint, HitLocation, HitRotation,
		DirA, DirB;

	local Rotator CameraRotation, SocketRotation, ControllerAim, AdjustedAim;
	local float DiffAngle, MaxAdjust;
	local Controller C;
	local PlayerController PC;
	local Quat Q;

	// End:0x53B
	if(VWeapon != none)
	{
		C = Seats[VWeapon.SeatIndex].SeatPawn.Controller;
		PC = PlayerController(C);
		// End:0x14D
		if(PC != none)
		{
			PC.GetPlayerViewPoint(CameraLocation, CameraRotation);
			DesiredAimPoint = CameraLocation + (Vector(CameraRotation) * VWeapon.GetTraceRange());
			// End:0x14A
			if(Trace(HitLocation, HitRotation, DesiredAimPoint, CameraLocation) != none)
			{
				DesiredAimPoint = HitLocation;
			}			
		}
		else
		{
			// End:0x185
			if(C != none)
			{
				DesiredAimPoint = C.GetFocalPoint();
			}
		}
		// End:0x2D4
		if(Seats[VWeapon.SeatIndex].GunSocket.Length > 0)
		{
			GetBarrelLocationAndRotation(VWeapon.SeatIndex, SocketLocation, SocketRotation);
			// End:0x2D1
			if(VWeapon.bIgnoreSocketPitchRotation || ((DesiredAimPoint.Z - Location.Z) < float(0)) && VWeapon.bIgnoreDownwardPitch)
			{
				SocketRotation.Pitch = Rotator(DesiredAimPoint - Location).Pitch;
			}			
		}
		else
		{
			SocketLocation = Location;
			SocketRotation = Rotator(DesiredAimPoint - Location);
		}
		RealAimPoint = SocketLocation + (Vector(SocketRotation) * VWeapon.GetTraceRange());
		DirA = Normal(DesiredAimPoint - SocketLocation);
		DirB = Normal(RealAimPoint - SocketLocation);
		DiffAngle = DirA Dot DirB;
		MaxAdjust = VWeapon.GetMaxFinalAimAdjustment();
		// End:0x4DC
		if(DiffAngle >= MaxAdjust)
		{
			ControllerAim = ((C != none) ? C.Rotation : Rotation);
			AdjustedAim = VWeapon.GetAdjustedAim(SocketLocation);
			// End:0x4CF
			if((AdjustedAim == VWeapon.Instigator.GetBaseAimRotation()) || AdjustedAim == ControllerAim)
			{
				return Rotator(DesiredAimPoint - SocketLocation);				
			}
			else
			{
				return AdjustedAim;
			}			
		}
		else
		{
			Q = QuatFromAxisAndAngle(Normal(DirB Cross DirA), Acos(MaxAdjust));
			return Rotator(QuatRotateVector(Q, DirB));
		}		
	}
	else
	{
		return Rotation;
	}
	//return ReturnValue;	
}

simulated function bool OverrideBeginFire(byte FireModeNum)
{
	//return ReturnValue;	
}

simulated function bool OverrideEndFire(byte FireModeNum)
{
	//return ReturnValue;	
}

simulated function GetWeaponViewAxes(UTWeapon WhichWeapon, out Vector XAxis, out Vector YAxis, out Vector ZAxis)
{
	GetAxes(Controller.Rotation, XAxis, YAxis, ZAxis);
	//return;	
}

simulated function CauseMuzzleFlashLight(int SeatIndex)
{
	// End:0x3E
	if((Seats[SeatIndex].GunSocket.Length == 0) || bDeadVehicle)
	{
		return;
	}
	// End:0x2FE
	if(!WorldInfo.bDropDetail || ((Seats[SeatIndex].SeatPawn != none) && PlayerController(Seats[SeatIndex].SeatPawn.Controller) != none) && Seats[SeatIndex].SeatPawn.IsLocallyControlled())
	{
		// End:0x1D2
		if(Seats[SeatIndex].MuzzleFlashLight == none)
		{
			// End:0x1CF
			if(Seats[SeatIndex].MuzzleFlashLightClass != none)
			{
				Seats[SeatIndex].MuzzleFlashLight = new (Outer) Seats[SeatIndex].MuzzleFlashLightClass;
			}			
		}
		else
		{
			Seats[SeatIndex].MuzzleFlashLight.ResetLight();
		}
		// End:0x2FE
		if(Seats[SeatIndex].MuzzleFlashLight != none)
		{
			Mesh.DetachComponent(Seats[SeatIndex].MuzzleFlashLight);
			Mesh.AttachComponentToSocket(Seats[SeatIndex].MuzzleFlashLight, Seats[SeatIndex].GunSocket[GetBarrelIndex(SeatIndex)]);
		}
	}
	//return;	
}

simulated function WeaponFired(Weapon InWeapon, bool bViaReplication, optional Vector HitLocation)
{
	VehicleWeaponFired(bViaReplication, HitLocation, 0);
	//return;	
}

simulated function VehicleWeaponFired(bool bViaReplication, Vector HitLocation, int SeatIndex)
{
	// End:0x171
	if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		VehicleWeaponFireEffects(HitLocation, SeatIndex);
		// End:0x84
		if((int(Role) == int(ROLE_Authority)) || bViaReplication)
		{
			VehicleWeaponImpactEffects(HitLocation, SeatIndex);
		}
		// End:0xCC
		if(SeatIndex == 0)
		{
			Seats[SeatIndex].Gun = UTVehicleWeapon(Weapon);
		}
		// End:0x13D
		if(Seats[SeatIndex].Gun != none)
		{
			UTVehicleWeapon(Seats[SeatIndex].Gun).ShakeView();
		}
		// End:0x171
		if(EffectIsRelevant(Location, false, MaxFireEffectDistance))
		{
			CauseMuzzleFlashLight(SeatIndex);
		}
	}
	//return;	
}

simulated function WeaponStoppedFiring(Weapon InWeapon, bool bViaReplication)
{
	VehicleWeaponStoppedFiring(bViaReplication, 0);
	//return;	
}

simulated function VehicleWeaponStoppedFiring(bool bViaReplication, int SeatIndex)
{
	local name StopName;

	// End:0xE5
	if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		// End:0xE5
		if((int(Role) == int(ROLE_Authority)) || bViaReplication)
		{
			StopName = name("STOP_" $ string(Class<UTVehicleWeapon>(Seats[SeatIndex].GunClass).static.GetFireTriggerTag(GetBarrelIndex(SeatIndex), int(SeatFiringMode(SeatIndex,, true)))));
			VehicleEvent(StopName);
		}
	}
	//return;	
}

simulated function VehicleWeaponFireEffects(Vector HitLocation, int SeatIndex)
{
	VehicleEvent(Class<UTVehicleWeapon>(Seats[SeatIndex].GunClass).static.GetFireTriggerTag(GetBarrelIndex(SeatIndex), int(SeatFiringMode(SeatIndex,, true))));
	//return;	
}

simulated function Actor FindWeaponHitNormal(out Vector HitLocation, out Vector HitNormal, Vector End, Vector Start, out TraceHitInfo HitInfo)
{
	return Trace(HitLocation, HitNormal, End, Start, true,, HitInfo, 1);
	//return ReturnValue;	
}

simulated function VehicleWeaponImpactEffects(Vector HitLocation, int SeatIndex)
{
	local Vector NewHitLoc, HitNormal, LightLoc;
	local Actor HitActor;
	local TraceHitInfo HitInfo;
	local MaterialImpactEffect ImpactEffect;
	local MaterialInterface MI;
	local MaterialInstanceTimeVarying MITV_Decal;
	local int DecalMaterialsLength;
	local Vehicle V;
	local Pawn EffectInstigator;
	local UTPlayerController PC;

	HitNormal = Normal(Location - HitLocation);
	HitActor = FindWeaponHitNormal(NewHitLoc, HitNormal, HitLocation - (HitNormal * float(32)), HitLocation + (HitNormal * float(32)), HitInfo);
	// End:0xB8
	if((HitActor == none) && VSize(Location - HitLocation) > float(10000))
	{
		return;
	}
	// End:0x11E
	if(Pawn(HitActor) != none)
	{
		CheckHitInfo(HitInfo, Pawn(HitActor).Mesh, -HitNormal, NewHitLoc);
	}
	ImpactEffect = Class<UTVehicleWeapon>(Seats[SeatIndex].GunClass).static.GetImpactEffect(HitActor, HitInfo.PhysMaterial, SeatFiringMode(SeatIndex,, true));
	// End:0x42C
	if(ImpactEffect.Sound != none)
	{
		V = Vehicle(HitActor);
		// End:0x299
		if(((V != none) && V.IsLocallyControlled()) && V.IsHumanControlled())
		{
			PlayerController(V.Controller).ClientPlaySound(ImpactEffect.Sound);			
		}
		else
		{
			// End:0x3F8
			if((Class<UTVehicleWeapon>(Seats[SeatIndex].GunClass).default.BulletWhip != none) && WorldInfo.GRI != none)
			{
				// End:0x3F7
				foreach LocalPlayerControllers(Class'UTGame.UTPlayerController', PC)
				{
					// End:0x3F6
					if(!WorldInfo.GRI.OnSameTeam(self, PC))
					{
						PC.CheckBulletWhip(Class<UTVehicleWeapon>(Seats[SeatIndex].GunClass).default.BulletWhip, Location, Normal(HitLocation - Location), HitLocation);
					}					
				}				
			}
			PlaySound(ImpactEffect.Sound, true,,, HitLocation);
		}
	}
	EffectInstigator = Seats[SeatIndex].SeatPawn;
	// End:0x476
	if(EffectInstigator == none)
	{
		EffectInstigator = self;
	}
	// End:0xB0B
	if(EffectInstigator.EffectIsRelevant(HitLocation, false, MaxImpactEffectDistance))
	{
		// End:0xB0B
		if((HitActor != none) && (Pawn(HitActor) == none) || Vehicle(HitActor) != none)
		{
			// End:0x866
			if(!WorldInfo.bDropDetail && Pawn(HitActor) == none)
			{
				DecalMaterialsLength = ImpactEffect.DecalMaterials.Length;
				// End:0x866
				if(DecalMaterialsLength > 0)
				{
					MI = ImpactEffect.DecalMaterials[Rand(DecalMaterialsLength)];
					// End:0x866
					if(MI != none)
					{
						// End:0x75E
						if(MaterialInstanceTimeVarying(MI) != none)
						{
							MITV_Decal = new (self) Class'Engine.MaterialInstanceTimeVarying';
							MITV_Decal.SetParent(MI);
							WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, HitLocation, Rotator(-HitNormal), ImpactEffect.DecalWidth, ImpactEffect.DecalHeight, 10.0000000, false,, HitInfo.HitComponent, true, false, HitInfo.BoneName, HitInfo.Item, HitInfo.LevelIndex);
							MITV_Decal.SetScalarStartTime(ImpactEffect.DecalDissolveParamName, ImpactEffect.DurationOfDecal);							
						}
						else
						{
							WorldInfo.MyDecalManager.SpawnDecal(MI, HitLocation, Rotator(-HitNormal), ImpactEffect.DecalWidth, ImpactEffect.DecalHeight, 10.0000000, false,, HitInfo.HitComponent, true, false, HitInfo.BoneName, HitInfo.Item, HitInfo.LevelIndex);
						}
					}
				}
			}
			// End:0xB0B
			if(ImpactEffect.ParticleTemplate != none)
			{
				SpawnImpactEmitter(HitLocation, HitNormal, ImpactEffect, SeatIndex);
				// End:0xB0B
				if((((Seats[SeatIndex].ImpactFlashLightClass != none) && int(WorldInfo.GetDetailMode()) != int(0)) && !Class'Engine.Engine'.static.IsSplitScreen()) && !WorldInfo.bDropDetail || ((Seats[SeatIndex].SeatPawn != none) && PlayerController(Seats[SeatIndex].SeatPawn.Controller) != none) && Seats[SeatIndex].SeatPawn.IsLocallyControlled())
				{
					LightLoc = HitLocation + (((0.5000000 * Seats[SeatIndex].ImpactFlashLightClass.default.TimeShift[0].Radius) * vect(1.0000000, 0.0000000, 0.0000000)) >> Rotator(HitNormal));
					UDKEmitterPool(WorldInfo.MyEmitterPool).SpawnExplosionLight(Seats[SeatIndex].ImpactFlashLightClass, LightLoc);
				}
			}
		}
	}
	//return;	
}

simulated function SpawnImpactEmitter(Vector HitLocation, Vector HitNormal, const out MaterialImpactEffect ImpactEffect, int SeatIndex)
{
	WorldInfo.MyEmitterPool.SpawnEmitter(ImpactEffect.ParticleTemplate, HitLocation, Rotator(HitNormal));
	//return;	
}

simulated function VehicleAdjustFlashCount(int SeatIndex, byte FireModeNum, optional bool bClear)
{
	// End:0x3B
	if(bClear)
	{
		SeatFlashCount(SeatIndex, 0);
		VehicleWeaponStoppedFiring(false, SeatIndex);		
	}
	else
	{
		SeatFiringMode(SeatIndex, FireModeNum);
		SeatFlashCount(SeatIndex, byte(int(SeatFlashCount(SeatIndex,, true)) + int(1)));
		VehicleWeaponFired(false, vect(0.0000000, 0.0000000, 0.0000000), SeatIndex);
		Seats[SeatIndex].BarrelIndex++;
	}
	bForceNetUpdate = true;
	//return;	
}

simulated function VehicleAdjustFlashLocation(int SeatIndex, byte FireModeNum, Vector NewLocation, optional bool bClear)
{
	// End:0x46
	if(bClear)
	{
		SeatFlashLocation(SeatIndex, vect(0.0000000, 0.0000000, 0.0000000));
		VehicleWeaponStoppedFiring(false, SeatIndex);		
	}
	else
	{
		// End:0x81
		if(NewLocation == (SeatFlashLocation(SeatIndex,, true)))
		{
			NewLocation += vect(0.0000000, 0.0000000, 1.0000000);
		}
		// End:0xB3
		if(NewLocation == vect(0.0000000, 0.0000000, 0.0000000))
		{
			NewLocation = vect(0.0000000, 0.0000000, 1.0000000);
		}
		SeatFiringMode(SeatIndex, FireModeNum);
		SeatFlashLocation(SeatIndex, NewLocation);
		VehicleWeaponFired(false, NewLocation, SeatIndex);
		Seats[SeatIndex].BarrelIndex++;
	}
	bForceNetUpdate = true;
	//return;	
}

simulated function FindGoodEndView(PlayerController PC, out Rotator GoodRotation)
{
	local Vector CameraLoc;
	local Rotator CameraRot, ViewRotation;
	local int tries;
	local float bestDist, newdist, FOVAngle;

	ViewRotation = GoodRotation;
	ViewRotation.Pitch = 56000;
	tries = 0;
	bestDist = 0.0000000;
	tries = 0;
	J0x5A:

	// End:0x148 [Loop If]
	if(tries < 16)
	{
		CameraLoc = Location;
		CameraRot = ViewRotation;
		CalcCamera(0.0000000, CameraLoc, CameraRot, FOVAngle);
		newdist = VSize(CameraLoc - Location);
		// End:0x117
		if(newdist > bestDist)
		{
			bestDist = newdist;
			GoodRotation = CameraRot;
		}
		ViewRotation.Yaw += 4096;
		tries++;
		// [Loop Continue]
		goto J0x5A;
	}
	//return;	
}

simulated function bool CalcCamera(float DeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
	local Vector out_CamStart;

	VehicleCalcCamera(DeltaTime, 0, out_CamLoc, out_CamRot, out_CamStart);
	return true;
	//return ReturnValue;	
}

simulated function Vector GetCameraFocus(int SeatIndex)
{
	local Vector CamStart, HitLocation, HitNormal;
	local Actor HitActor;

	// End:0xFB
	if(!bDeadVehicle && Seats[SeatIndex].CameraTag != 'None')
	{
		Mesh.GetSocketWorldLocationAndRotation(Seats[SeatIndex].CameraTag, CamStart);
		HitActor = Trace(HitLocation, HitNormal, CamStart, Location, false, vect(12.0000000, 12.0000000, 12.0000000));
		// End:0xF8
		if(HitActor != none)
		{
			CamStart = HitLocation;
		}		
	}
	else
	{
		CamStart = Location;
	}
	CamStart += (Seats[SeatIndex].CameraBaseOffset >> Rotation);
	return CamStart;
	//return ReturnValue;	
}

simulated function Vector GetCameraStart(int SeatIndex)
{
	local int I, Len, Obsolete;
	local Vector CamStart;
	local float OriginalCamZ;
	local TimePosition NewPos, PrevPos;
	local float DeltaTime;

	Len = OldPositions.Length;
	// End:0x97
	if(((Len > 0) && SeatIndex == 0) && OldPositions[Len - 1].Time == WorldInfo.TimeSeconds)
	{
		return CameraOffset + Location;
	}
	CamStart = GetCameraFocus(SeatIndex);
	OriginalCamZ = CamStart.Z;
	// End:0x118
	if(((CameraLag == float(0)) || SeatIndex != 0) || !IsHumanControlled())
	{
		return CamStart;
	}
	NewPos.Time = WorldInfo.TimeSeconds;
	NewPos.Position = CamStart;
	OldPositions[Len] = NewPos;
	// End:0x1CD
	if(Len == 0)
	{
		CameraOffset = CamStart - Location;
		return CamStart;
	}
	DeltaTime = ((Len > 1) ? WorldInfo.TimeSeconds - OldPositions[Len - 2].Time : 0.0000000);
	Len = OldPositions.Length;
	Obsolete = 0;
	I = 0;
	J0x261:

	// End:0x673 [Loop If]
	if(I < Len)
	{
		// End:0x2F7
		if(OldPositions[I].Time < (WorldInfo.TimeSeconds - CameraLag))
		{
			PrevPos = OldPositions[I];
			Obsolete++;			
		}
		else
		{
			// End:0x4BD
			if(Obsolete > 0)
			{
				// End:0x398
				if((I == 0) || (OldPositions[I].Time - PrevPos.Time) > 0.2000000)
				{
					CamStart = OldPositions[I].Position;					
				}
				else
				{
					CamStart = PrevPos.Position + (((OldPositions[I].Position - PrevPos.Position) * ((WorldInfo.TimeSeconds - CameraLag) - PrevPos.Time)) / (OldPositions[I].Time - PrevPos.Time));
				}
				// End:0x4BA
				if(Obsolete > 1)
				{
					OldPositions.Remove(0, Obsolete - 1);
				}				
			}
			else
			{
				CamStart = OldPositions[I].Position;
			}
			// End:0x5BD
			if(DeltaTime > float(0))
			{
				DeltaTime *= CameraSmoothingFactor;
				CameraOffset = ((CamStart - Location) * DeltaTime) + (CameraOffset * (float(1) - DeltaTime));
				// End:0x5BA
				if(bNoZSmoothing)
				{
					CameraOffset.Z = CamStart.Z - Location.Z;
				}				
			}
			else
			{
				CameraOffset = CamStart - Location;
			}
			CamStart = CameraOffset + Location;
			// End:0x65B
			if(bLimitCameraZLookingUp)
			{
				CamStart.Z = LimitCameraZ(CamStart.Z, OriginalCamZ, SeatIndex);
			}
			return CamStart;
		}
		I++;
		// [Loop Continue]
		goto J0x261;
	}
	CamStart = OldPositions[Len - 1].Position;
	// End:0x708
	if(bLimitCameraZLookingUp)
	{
		CamStart.Z = LimitCameraZ(CamStart.Z, OriginalCamZ, SeatIndex);
	}
	return CamStart;
	//return ReturnValue;	
}

simulated function float LimitCameraZ(float CurrentCamZ, float OriginalCamZ, int SeatIndex)
{
	local Rotator CamRot;
	local float Pct;

	CamRot = Seats[SeatIndex].SeatPawn.GetViewRotation();
	CamRot.Pitch = CamRot.Pitch & 65535;
	// End:0x122
	if(CamRot.Pitch < 32768)
	{
		Pct = FClamp(float(CamRot.Pitch) * 0.0002500, 0.0000000, 1.0000000);
		CurrentCamZ = (OriginalCamZ * Pct) + (CurrentCamZ * (1.0000000 - Pct));
	}
	return CurrentCamZ;
	//return ReturnValue;	
}

simulated function VehicleCalcCamera(float DeltaTime, int SeatIndex, out Vector out_CamLoc, out Rotator out_CamRot, out Vector CamStart, optional bool bPivotOnly)
{
	local Vector CamPos, CamDir, HitLocation, FirstHitLocation, HitNormal, CamRotX,
		CamRotY, CamRotZ, SafeLocation, X, Y,
		Z;

	local Actor HitActor;
	local float NewCamStartZ;
	local UTPawn P;
	local bool bObstructed, bInsideVehicle;
	local TraceHitInfo obstructionInfo;

	Mesh.SetOwnerNoSee(false);
	// End:0xC1
	if(((UTPawn(Driver) != none) && !Driver.bHidden) && Driver.Mesh.bOwnerNoSee)
	{
		UTPawn(Driver).SetMeshVisibility(true);
	}
	P = UTPawn(Seats[SeatIndex].SeatPawn.Driver);
	// End:0x194
	if((P != none) && P.bFixedView)
	{
		out_CamLoc = P.FixedViewLoc;
		out_CamRot = P.FixedViewRot;
		return;
	}
	CamStart = GetCameraStart(SeatIndex);
	// End:0x249
	if((Seats[SeatIndex].SeatPawn.Controller != none) && !bSpectatedView)
	{
		out_CamRot = Seats[SeatIndex].SeatPawn.GetViewRotation();
	}
	// End:0x280
	if(P != none)
	{
		P.ModifyRotForDebugFreeCam(out_CamRot);
	}
	GetAxes(out_CamRot, CamRotX, CamRotY, CamRotZ);
	CamStart += ((Seats[SeatIndex].SeatPawn.EyeHeight + (LookForwardDist * FMax(0.0000000, 1.0000000 - CamRotZ.Z))) * CamRotZ);
	// End:0x662
	if(bNoFollowJumpZ)
	{
		NewCamStartZ = CamStart.Z;
		// End:0x4B0
		if(((Velocity.Z > float(0)) && !HasWheelsOnGround()) && OldCamPosZ != float(0))
		{
			bFixedCamZ = true;
			// End:0x42B
			if(OldPositions.Length > 0)
			{
				OldPositions[OldPositions.Length - 1].Position.Z += (OldCamPosZ - CamStart.Z);
			}
			CamStart.Z = OldCamPosZ;
			// End:0x4AD
			if((NewCamStartZ - CamStart.Z) > float(64))
			{
				CamStart.Z = NewCamStartZ - float(64);
			}			
		}
		else
		{
			// End:0x662
			if(bFixedCamZ)
			{
				// End:0x5C6
				if((HasWheelsOnGround()) || CamStart.Z <= OldCamPosZ)
				{
					// End:0x518
					if(DeltaTime >= 0.1000000)
					{
						bFixedCamZ = false;						
					}
					else
					{
						CamStart.Z = ((10.0000000 * DeltaTime) * CamStart.Z) + ((float(1) - (float(10) * DeltaTime)) * OldCamPosZ);
						// End:0x5C3
						if(Abs(NewCamStartZ - CamStart.Z) < 1.0000000)
						{
							bFixedCamZ = false;
						}
					}					
				}
				else
				{
					// End:0x63C
					if(OldPositions.Length > 0)
					{
						OldPositions[OldPositions.Length - 1].Position.Z += (OldCamPosZ - CamStart.Z);
					}
					CamStart.Z = OldCamPosZ;
				}
			}
		}
	}
	// End:0x6B0
	if(Seats[SeatIndex].CameraSafeOffset == vect(0.0000000, 0.0000000, 0.0000000))
	{
		SafeLocation = Location;		
	}
	else
	{
		GetAxes(Rotation, X, Y, Z);
		SafeLocation = ((Location + (Seats[SeatIndex].CameraSafeOffset.X * X)) + (Seats[SeatIndex].CameraSafeOffset.Y * Y)) + (Seats[SeatIndex].CameraSafeOffset.Z * Z);
	}
	HitActor = Trace(HitLocation, HitNormal, CamStart, SafeLocation, false, vect(12.0000000, 12.0000000, 12.0000000), obstructionInfo);
	// End:0x88D
	if((HitActor != none) && (obstructionInfo.HitComponent == none) || obstructionInfo.HitComponent.CanBlockCamera)
	{
		bObstructed = true;
		CamStart = HitLocation;
	}
	OldCamPosZ = CamStart.Z;
	// End:0x8D5
	if(bPivotOnly)
	{
		out_CamLoc = CamStart;
		return;
	}
	CamDir = (CamRotX * Seats[SeatIndex].CameraOffset) * SeatCameraScale;
	// End:0x9B3
	if(!bRotateCameraUnderVehicle && CamDir.Z < float(0))
	{
		CamDir *= ((VSize(CamDir) - Abs(CamDir.Z)) / (VSize(CamDir) + Abs(CamDir.Z)));
	}
	CamPos = CamStart + CamDir;
	HitActor = Trace(HitLocation, HitNormal, CamPos, CamStart, false, vect(12.0000000, 12.0000000, 12.0000000), obstructionInfo);
	// End:0xAA6
	if((HitActor != none) && (obstructionInfo.HitComponent == none) || obstructionInfo.HitComponent.CanBlockCamera)
	{
		out_CamLoc = HitLocation;
		bObstructed = true;		
	}
	else
	{
		out_CamLoc = CamPos;
	}
	// End:0xBAF
	if((!bRotateCameraUnderVehicle && CamDir.Z < float(0)) && TraceComponent(FirstHitLocation, HitNormal, CollisionComponent, out_CamLoc, CamStart, vect(0.0000000, 0.0000000, 0.0000000)))
	{
		// End:0xBAF
		if(!TraceComponent(HitLocation, HitNormal, CollisionComponent, CamStart, out_CamLoc, vect(0.0000000, 0.0000000, 0.0000000)))
		{
			out_CamLoc = FirstHitLocation;
			bObstructed = true;
			bInsideVehicle = true;
		}
	}
	// End:0xD69
	if(!bCameraNeverHidesVehicle && bObstructed)
	{
		bInsideVehicle = (bInsideVehicle || !TraceComponent(HitLocation, HitNormal, CollisionComponent, SafeLocation, out_CamLoc, vect(0.0000000, 0.0000000, 0.0000000))) || VSizeSq(HitLocation - out_CamLoc) < MinCameraDistSq;
		Mesh.SetOwnerNoSee(bInsideVehicle);
		// End:0xD69
		if(((UTPawn(Driver) != none) && !Driver.bHidden) && Driver.Mesh.bOwnerNoSee != Mesh.bOwnerNoSee)
		{
			Driver.Mesh.SetOwnerNoSee(Mesh.bOwnerNoSee);
		}
	}
	//return;	
}

simulated function AdjustCameraScale(bool bMoveCameraIn)
{
	//return;	
}

simulated function StartBurnOut()
{
	local int I, NumBurnOutMaterials;

	// End:0x66
	if(Velocity.Z < -100.0000000)
	{
		DelayedBurnoutCount++;
		// End:0x66
		if(DelayedBurnoutCount < 6)
		{
			SetTimer(1.0000000, false, 'StartBurnOut');
			LifeSpan += 1.0000000;
			return;
		}
	}
	// End:0x8E
	if(SpawnOutSound != none)
	{
		PlaySound(SpawnOutSound, true);
	}
	bIsBurning = true;
	SetTimer(0.5000000, false, 'DisableCollision');
	DisableDamageSmoke();
	StopVehicleSounds();
	NumBurnOutMaterials = BurnOutMaterialInstances.Length;
	I = 0;
	J0xE0:

	// End:0x17B [Loop If]
	if(I < NumBurnOutMaterials)
	{
		// End:0x16D
		if(BurnOutMaterialInstances[I].MITV != none)
		{
			BurnOutMaterialInstances[I].MITV.SetScalarStartTime('BurnTime', 0.0000000);
		}
		++I;
		// [Loop Continue]
		goto J0xE0;
	}
	VehicleEvent('NoDamageSmoke');
	// End:0x1D1
	if(DeathExplosion != none)
	{
		DeathExplosion.ParticleSystemComponent.DeactivateSystem();
	}
	SetTimer(0.5000000, false, 'TurnOffShadows');
	//return;	
}

simulated function TurnOffShadows()
{
	UpdateShadowSettings(false);
	//return;	
}

simulated function DisableDamageSmoke()
{
	VehicleEvent('NoDamageSmoke');
	//return;	
}

simulated function DisableCollision()
{
	SetCollision(false);
	Mesh.SetBlockRigidBody(false);
	//return;	
}

simulated function SetBurnOut()
{
	local int I, NumElements, TeamNum;
	local BurnOutDatum BOD;
	local UTCarriedObject Flag;

	// End:0x13
	if(LifeSpan != float(0))
	{
		return;
	}
	TeamNum = int(GetTeamNum());
	// End:0x43
	if(TeamNum > 1)
	{
		TeamNum = 0;
	}
	// End:0x79
	foreach TouchingActors(Class'UTGame.UTCarriedObject', Flag)
	{
		DeadVehicleLifeSpan = BurnOutTime + 0.0100000;
		// End:0x79
		break;		
	}	
	LifeSpan = DeadVehicleLifeSpan;
	// End:0x130
	if(BurnOutMaterial[TeamNum] != none)
	{
		Mesh.SetMaterial(0, BurnOutMaterial[TeamNum]);
		// End:0x130
		if(DestroyedTurret != none)
		{
			DestroyedTurret.GibMeshComp.SetMaterial(0, BurnOutMaterial[TeamNum]);
		}
	}
	NumElements = Mesh.GetNumElements();
	I = 0;
	J0x164:

	// End:0x2AD [Loop If]
	if(I < NumElements)
	{
		BOD.MITV = Mesh.CreateAndSetMaterialInstanceTimeVarying(I);
		BurnOutMaterialInstances[BurnOutMaterialInstances.Length] = BOD;
		// End:0x250
		if(DestroyedTurret != none)
		{
			DestroyedTurret.GibMeshComp.SetMaterial(I, BurnOutMaterialInstances[I].MITV);
		}
		BOD.MITV.SetScalarStartTime('BurnTime', LifeSpan - BurnOutTime);
		I++;
		// [Loop Continue]
		goto J0x164;
	}
	RemainingBurn = BurnOutTime;
	SetTimer(LifeSpan - BurnOutTime, false, 'StartBurnOut');
	//return;	
}

simulated function bool ShouldSpawnExplosionLight(Vector HitLocation, Vector HitNormal)
{
	local PlayerController P;
	local float Dist;

	// End:0x14A
	foreach LocalPlayerControllers(Class'Engine.PlayerController', P)
	{
		Dist = VSize(P.ViewTarget.Location - Location);
		// End:0x149
		if(((P.Pawn == Instigator) || Dist < ExplosionLightClass.default.Radius) || (Dist < MaxExplosionLightDistance) && (Vector(P.Rotation) Dot (Location - P.ViewTarget.Location)) > float(0))
		{			
			return true;
		}		
	}	
	return false;
	//return ReturnValue;	
}

event RBPenetrationDestroy()
{
	// End:0x49
	if(Health > 0)
	{
		TakeDamage(10000, GetCollisionDamageInstigator(), Location, vect(0.0000000, 0.0000000, 0.0000000), Class'UTGame.UTDmgType_VehicleCollision');
	}
	//return;	
}

simulated function TurretExplosion()
{
	local Vector SpawnLoc;
	local Rotator SpawnRot;
	local SkelControlBase SK;
	local Vector Force;

	Mesh.GetSocketWorldLocationAndRotation(TurretSocketName, SpawnLoc, SpawnRot);
	WorldInfo.MyEmitterPool.SpawnEmitter(Class'UTGame.UTEmitter'.static.GetTemplateForDistance(DistanceTurretExplosionTemplates, SpawnLoc, WorldInfo), Location, Rotation);
	DestroyedTurret = Spawn(Class'UTGame.UTVehicleDeathPiece', self,, SpawnLoc + TurretOffset, SpawnRot,, true);
	// End:0x462
	if(DestroyedTurret != none)
	{
		StaticMeshComponent(DestroyedTurret.GibMeshComp).SetStaticMesh(DestroyedTurretTemplate);
		DestroyedTurret.GibMeshComp.SetBlockRigidBody(false);
		DestroyedTurret.GibMeshComp.SetRBChannel(1);
		DestroyedTurret.GibMeshComp.SetRBCollidesWithChannel(0, false);
		DestroyedTurret.GibMeshComp.SetRBCollidesWithChannel(2, false);
		DestroyedTurret.GibMeshComp.SetRBCollidesWithChannel(3, false);
		DestroyedTurret.GibMeshComp.SetRBCollidesWithChannel(5, false);
		DestroyedTurret.GibMeshComp.SetRBCollidesWithChannel(6, false);
		DestroyedTurret.SetTimer(0.1000000, false, 'TurnOnCollision');
		SK = Mesh.FindSkelControl(TurretScaleControlName);
		// End:0x35F
		if(SK != none)
		{
			SK.BoneScale = 0.0000000;
		}
		Force = vect(0.0000000, 0.0000000, 1.0000000);
		Force *= TurretExplosiveForce;
		Force.X = (FRand() * 1000.0000000) + 400.0000000;
		Force.Y = (FRand() * 1000.0000000) + 400.0000000;
		DestroyedTurret.GibMeshComp.AddImpulse(Force);
		DestroyedTurret.GibMeshComp.SetRBAngularVelocity(VRand() * 500.0000000);
	}
	//return;	
}

simulated function StopVehicleSounds()
{
	local int SeatIdx;

	super(SVehicle).StopVehicleSounds();
	SeatIdx = 0;
	J0x15:

	// End:0xA3 [Loop If]
	if(SeatIdx < Seats.Length)
	{
		// End:0x95
		if(Seats[SeatIdx].SeatMotionAudio != none)
		{
			Seats[SeatIdx].SeatMotionAudio.Stop();
		}
		++SeatIdx;
		// [Loop Continue]
		goto J0x15;
	}
	//return;	
}

simulated function CheckDamageSmoke()
{
	// End:0x6D
	if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		VehicleEvent((((float(Health) / float(HealthMax)) < DamageSmokeThreshold) ? 'DamageSmoke' : 'NoDamageSmoke'));
	}
	//return;	
}

simulated function AttachDriver(Pawn P)
{
	local UTPawn UTP;

	OldPositions.Remove(0, OldPositions.Length);
	EyeHeight = BaseEyeHeight;
	UTP = UTPawn(P);
	// End:0x168
	if(UTP != none)
	{
		UTP.SetWeaponAttachmentVisibility(false);
		UTP.SetHandIKEnabled(false);
		// End:0x168
		if(bAttachDriver)
		{
			UTP.SetCollision(false, false);
			UTP.bCollideWorld = false;
			UTP.SetBase(none);
			UTP.SetHardAttach(true);
			UTP.SetLocation(Location);
			UTP.SetPhysics(0);
			SitDriver(UTP, 0);
		}
	}
	//return;	
}

simulated function SitDriver(UTPawn UTP, int SeatIndex)
{
	// End:0x80
	if(Seats[SeatIndex].SeatBone != 'None')
	{
		UTP.SetBase(self,, Mesh, Seats[SeatIndex].SeatBone);		
	}
	else
	{
		UTP.SetBase(self);
	}
	SetMovementEffect(SeatIndex, true, UTP);
	// End:0x13C
	if(UTP.Mesh.PhysicsAssetInstance != none)
	{
		UTP.Mesh.PhysicsAssetInstance.SetAllBodiesFixed(true);
	}
	UTP.Mesh.bUpdateKinematicBonesFromAnimation = false;
	UTP.Mesh.PhysicsWeight = 0.0000000;
	// End:0x404
	if(Seats[SeatIndex].bSeatVisible)
	{
		// End:0x284
		if((UTP.Mesh != none) && Mesh != none)
		{
			UTP.Mesh.SetShadowParent(Mesh);
			UTP.Mesh.SetLightEnvironment(LightEnvironment);
		}
		UTP.SetMeshVisibility(true);
		UTP.SetRelativeLocation(Seats[SeatIndex].SeatOffset);
		UTP.SetRelativeRotation(Seats[SeatIndex].SeatRotation);
		UTP.Mesh.SetCullDistance(Mesh.CachedMaxDrawDistance);
		UTP.Mesh.SetTranslation(vect(0.0000000, 0.0000000, 1.0000000) * UTP.BaseTranslationOffset);
		UTP.SetHidden(false);		
	}
	else
	{
		UTP.SetHidden(true);
	}
	//return;	
}

simulated function OnDriverPhysicsAssetChanged(UTPawn UTP)
{
	//return;	
}

simulated function string GetHumanReadableName()
{
	// End:0x23
	if(VehicleNameString == "")
	{
		return "" $ string(Class);		
	}
	else
	{
		return VehicleNameString;
	}
	//return ReturnValue;	
}

event OnPropertyChange(name PropName)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x11F [Loop If]
	if(I < Seats.Length)
	{
		// End:0x111
		if(Seats[I].bSeatVisible)
		{
			Seats[I].StoragePawn.SetRelativeLocation(Seats[I].SeatOffset);
			Seats[I].StoragePawn.SetRelativeRotation(Seats[I].SeatRotation);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

simulated function int GetHealth(int SeatIndex)
{
	return Health;
	//return ReturnValue;	
}

function float GetCollisionDamageModifier(const out array<RigidBodyContactInfo> ContactInfos)
{
	local float Angle;
	local Vector X, Y, Z;

	// End:0xA7
	if(bReducedFallingCollisionDamage)
	{
		GetAxes(Rotation, X, Y, Z);
		Angle = ContactInfos[0].ContactNormal Dot Z;
		return ((Angle < 0.0000000) ? Square(CollisionDamageMult * (1.0000000 + Angle)) : Square(CollisionDamageMult));		
	}
	else
	{
		return Square(CollisionDamageMult);
	}
	//return ReturnValue;	
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData Collision, int ContactIndex)
{
	local int Damage;
	local UTVehicle V;
	local Controller InstigatorController;

	// End:0x2B3
	if(LastCollisionDamageTime != WorldInfo.TimeSeconds)
	{
		super(SVehicle).RigidBodyCollision(HitComponent, OtherComponent, Collision, ContactIndex);
		// End:0x103
		if(((OtherComponent != none) && UTPawn(OtherComponent.Owner) != none) && int(OtherComponent.Owner.Physics) == int(10))
		{
			RanInto(OtherComponent.Owner);			
		}
		else
		{
			// End:0x2B3
			if(Mesh != none)
			{
				Damage = int(VSizeSq(Mesh.GetRootBodyInstance().PreviousVelocity) * (GetCollisionDamageModifier(Collision.ContactInfos)));
				// End:0x2B3
				if(Damage > 1)
				{
					// End:0x203
					if(OtherComponent != none)
					{
						V = UTVehicle(OtherComponent.Owner);
						// End:0x203
						if(V != none)
						{
							InstigatorController = V.GetCollisionDamageInstigator();
						}
					}
					// End:0x226
					if(InstigatorController == none)
					{
						InstigatorController = GetCollisionDamageInstigator();
					}
					TakeDamage(Damage, InstigatorController, Collision.ContactInfos[0].ContactPosition, vect(0.0000000, 0.0000000, 0.0000000), Class'UTGame.UTDmgType_VehicleCollision');
					LastCollisionDamageTime = WorldInfo.TimeSeconds;
				}
			}
		}
	}
	//return;	
}

simulated function InitializeMorphs()
{
	local int I, J;

	I = 0;
	J0x0B:

	// End:0x22D [Loop If]
	if(I < DamageMorphTargets.Length)
	{
		// End:0x16D
		if(DamageMorphTargets[I].MorphNodeName != 'None')
		{
			DamageMorphTargets[I].MorphNode = MorphNodeWeight(Mesh.FindMorphNode(DamageMorphTargets[I].MorphNodeName));
			// End:0x16D
			if(DamageMorphTargets[I].MorphNode == none)
			{
				WarnInternal((("Failed to find Morph node named" @ string(DamageMorphTargets[I].MorphNodeName)) @ "in") @ string(Mesh.SkeletalMesh));
			}
		}
		J = 0;
		J0x178:

		// End:0x21F [Loop If]
		if(J < DamageMorphTargets.Length)
		{
			// End:0x211
			if(DamageMorphTargets[J].LinkedMorphNodeName == DamageMorphTargets[I].MorphNodeName)
			{
				DamageMorphTargets[J].LinkedMorphNodeIndex = I;
			}
			J++;
			// [Loop Continue]
			goto J0x178;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	InitDamageSkel();
	//return;	
}

simulated event ReceivedHealthChange()
{
	local int Diff;

	Diff = Health - ClientHealth;
	// End:0x43
	if(Diff > 0)
	{
		ApplyMorphHeal(Diff);		
	}
	else
	{
		ApplyRandomMorphDamage(Diff);
	}
	ClientHealth = Health;
	CheckDamageSmoke();
	//return;	
}

simulated event ApplyMorphHeal(int Amount)
{
	local int Individual, Total, Remaining, I;
	local float Weight;

	// End:0x15F
	if(Health >= HealthMax)
	{
		I = 0;
		J0x22:

		// End:0x102 [Loop If]
		if(I < DamageMorphTargets.Length)
		{
			DamageMorphTargets[I].Health = default.DamageMorphTargets[I].Health;
			// End:0xF4
			if(DamageMorphTargets[I].MorphNode != none)
			{
				DamageMorphTargets[I].MorphNode.SetNodeWeight(0.0000000);
			}
			I++;
			// [Loop Continue]
			goto J0x22;
		}
		I = 0;
		J0x10D:

		// End:0x15C [Loop If]
		if(I < DamageSkelControls.Length)
		{
			DamageSkelControls[I].RestorePart();
			I++;
			// [Loop Continue]
			goto J0x10D;
		}		
	}
	else
	{
		I = 0;
		J0x16A:

		// End:0x212 [Loop If]
		if(I < DamageMorphTargets.Length)
		{
			// End:0x204
			if(DamageMorphTargets[I].Health < default.DamageMorphTargets[I].Health)
			{
				Total += default.DamageMorphTargets[I].Health;
			}
			I++;
			// [Loop Continue]
			goto J0x16A;
		}
		// End:0x515
		if((Amount > 0) && Total > 0)
		{
			Remaining = Amount;
			I = 0;
			J0x250:

			// End:0x359 [Loop If]
			if(I < DamageMorphTargets.Length)
			{
				Individual = Min(default.DamageMorphTargets[I].Health - DamageMorphTargets[I].Health, int((float(Amount) * float(default.DamageMorphTargets[I].Health)) / float(Total)));
				DamageMorphTargets[I].Health += Individual;
				Remaining -= Individual;
				I++;
				// [Loop Continue]
				goto J0x250;
			}
			I = 0;
			J0x364:

			// End:0x515 [Loop If]
			if(I < DamageMorphTargets.Length)
			{
				// End:0x433
				if(Remaining > 0)
				{
					Individual = Min(Remaining, default.DamageMorphTargets[I].Health - DamageMorphTargets[I].Health);
					DamageMorphTargets[I].Health += Individual;
					Remaining -= Individual;
				}
				Weight = 1.0000000 - (float(DamageMorphTargets[I].Health) / float(default.DamageMorphTargets[I].Health));
				// End:0x507
				if(DamageMorphTargets[I].MorphNode != none)
				{
					DamageMorphTargets[I].MorphNode.SetNodeWeight(Weight);
				}
				I++;
				// [Loop Continue]
				goto J0x364;
			}
		}
		Total = 0;
		I = 0;
		J0x52B:

		// End:0x6AD [Loop If]
		if(I < DamageSkelControls.Length)
		{
			// End:0x69C
			if(Total < Amount)
			{
				Total += int((float(1) - DamageSkelControls[I].HealthPerc) * float(DamageSkelControls[I].DamageMax));
				DamageSkelControls[I].HealthPerc = ((Total < Amount) ? DamageSkelControls[I].RestorePart() : DamageSkelControls[I].HealthPerc + ((float(Amount) - float(Total)) / float(DamageSkelControls[I].DamageMax)));				
			}
			else
			{
				// [Explicit Break]
				goto J0x6AD;
			}
			I++;
			// [Loop Continue]
			goto J0x52B;
		}
	}
	J0x6AD:

	UpdateDamageMaterial();
	//return;	
}

simulated function ApplyRandomMorphDamage(int Amount)
{
	local int Min, minindex, I;
	local float MinAmt, Weight;

	I = 0;
	J0x0B:

	// End:0x11A [Loop If]
	if(I < DamageSkelControls.Length)
	{
		// End:0x10C
		if((DamageSkelControls[I].HealthPerc > float(0)) && minindex < 0)
		{
			MinAmt = FMin(float(Amount / (DamageSkelControls[I].DamageMax * DamageSkelControls.Length)), DamageSkelControls[I].HealthPerc);
			DamageSkelControls[I].HealthPerc -= MinAmt;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	J0x11A:

	// End:0x3AC [Loop If]
	if(Amount > 0)
	{
		minindex = -1;
		minindex = -1;
		I = 0;
		J0x152:

		// End:0x22E [Loop If]
		if(I < DamageMorphTargets.Length)
		{
			// End:0x220
			if((DamageMorphTargets[I].Health > 0) && (minindex < 0) || DamageMorphTargets[I].Health < Min)
			{
				Min = DamageMorphTargets[I].Health;
				minindex = I;
			}
			I++;
			// [Loop Continue]
			goto J0x152;
		}
		// End:0x3A6
		if(minindex >= 0)
		{
			// End:0x293
			if(Min < Amount)
			{
				DamageMorphTargets[minindex].Health = 0;
				Amount -= Min;				
			}
			else
			{
				DamageMorphTargets[minindex].Health -= Amount;
				Amount = 0;
			}
			Weight = 1.0000000 - (float(DamageMorphTargets[minindex].Health) / float(default.DamageMorphTargets[minindex].Health));
			// End:0x3A3
			if(DamageMorphTargets[minindex].MorphNode != none)
			{
				DamageMorphTargets[minindex].MorphNode.SetNodeWeight(Weight);
			}			
		}
		else
		{
			// [Explicit Break]
			goto J0x3AC;
		}
		// [Loop Continue]
		goto J0x11A;
	}
	J0x3AC:

	UpdateDamageMaterial();
	//return;	
}

simulated function UTGib SpawnGibVehicle(Vector SpawnLocation, Rotator SpawnRotation, StaticMesh TheMesh, Vector HitLocation, bool bSpinGib, Vector ImpulseDirection, ParticleSystem PS_OnBreak, ParticleSystem PS_Trail)
{
	local UTGib_Vehicle Gib;
	local float GibPerterbation;
	local Rotator VelRotation;
	local Vector X, Y, Z;

	Gib = Spawn(VehiclePieceClass, self,, SpawnLocation, SpawnRotation,, true);
	// End:0x657
	if(Gib != none)
	{
		Gib.SetGibStaticMesh(TheMesh);
		Gib.GibMeshComp.SetBlockRigidBody(false);
		Gib.GibMeshComp.SetRBChannel(1);
		Gib.GibMeshComp.SetRBCollidesWithChannel(0, false);
		Gib.GibMeshComp.SetRBCollidesWithChannel(2, false);
		Gib.GibMeshComp.SetRBCollidesWithChannel(3, false);
		Gib.GibMeshComp.SetRBCollidesWithChannel(5, false);
		Gib.GibMeshComp.SetRBCollidesWithChannel(6, false);
		Gib.SetTimer(0.1000000, false, 'TurnOnCollision');
		GibPerterbation = 30000.0000000;
		VelRotation = Rotator(Gib.Location - HitLocation);
		VelRotation.Pitch += int(((FRand() * 2.0000000) * GibPerterbation) - GibPerterbation);
		VelRotation.Yaw += int(((FRand() * 2.0000000) * GibPerterbation) - GibPerterbation);
		VelRotation.Roll += int(((FRand() * 2.0000000) * GibPerterbation) - GibPerterbation);
		GetAxes(VelRotation, X, Y, Z);
		// End:0x383
		if(VSize(ImpulseDirection) > 100.0000000)
		{
			Gib.Velocity = Velocity + ImpulseDirection;			
		}
		else
		{
			// End:0x3E7
			if(VSize(Velocity) > 10.0000000)
			{
				Gib.Velocity = (Velocity + (Z * (FRand() * float(100)))) + vect(0.0000000, 0.0000000, 1000.0000000);				
			}
			else
			{
				Gib.Velocity = (((vect(1.0000000, 0.0000000, 0.0000000) * (FRand() * float(400))) + (vect(0.0000000, 1.0000000, 0.0000000) * (FRand() * float(400)))) + (Z * (FRand() * float(300)))) + vect(0.0000000, 0.0000000, 1000.0000000);
			}
		}
		Gib.GibMeshComp.WakeRigidBody();
		Gib.GibMeshComp.SetRBLinearVelocity(Gib.Velocity, false);
		// End:0x538
		if(bSpinGib)
		{
			Gib.GibMeshComp.SetRBAngularVelocity(VRand() * float(500), false);
		}
		Gib.LifeSpan = Gib.LifeSpan + (2.0000000 * FRand());
		Gib.OwningClass = Class;
		// End:0x5DF
		if(PS_OnBreak != none)
		{
			Gib.PS_GibExplosionEffect = PS_OnBreak;
		}
		// End:0x616
		if(PS_Trail != none)
		{
			Gib.PS_GibTrailEffect = PS_Trail;
		}
		Gib.SetTimer(Class'UTGame.UTGib_Vehicle'.default.TimeBeforeGibExplosionEffect, false, 'ActivateGibExplosionEffect');
	}
	return Gib;
	//return ReturnValue;	
}

simulated function GetSVehicleDebug(out array<string> DebugInfo)
{
	local int I;

	super(SVehicle).GetSVehicleDebug(DebugInfo);
	DebugInfo[DebugInfo.Length] = "";
	DebugInfo[DebugInfo.Length] = "----Seats----: ";
	I = 0;
	J0x5B:

	// End:0x1F5 [Loop If]
	if(I < Seats.Length)
	{
		DebugInfo[DebugInfo.Length] = (((((((("Seat" @ string(I)) $ ":") @ string(Seats[I].Gun)) @ "Rotation") @ string(SeatWeaponRotation(I,, true))) @ "FiringMode") @ string(SeatFiringMode(I,, true))) @ "Barrel") @ string(Seats[I].BarrelIndex);
		// End:0x1E7
		if(Seats[I].Gun != none)
		{			
			DebugInfo[DebugInfo.Length - 1] @= ("IsAimCorrect" @ string(Seats[I].Gun.IsAimCorrect()));
		}
		I++;
		// [Loop Continue]
		goto J0x5B;
	}
	//return;	
}

function OnExitVehicle(UTSeqAct_ExitVehicle Action)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0xDD [Loop If]
	if(I < Seats.Length)
	{
		// End:0xCF
		if((Seats[I].SeatPawn != none) && Seats[I].SeatPawn.Driver != none)
		{
			Seats[I].SeatPawn.DriverLeave(true);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function SetShieldActive(int SeatIndex, bool bActive)
{
	//return;	
}

function SetSeatStoragePawn(int SeatIndex, Pawn PawnToSit)
{
	local int Mask;

	Seats[SeatIndex].StoragePawn = PawnToSit;
	// End:0xAC
	if((SeatIndex == 1) && int(Role) == int(ROLE_Authority))
	{
		PassengerPRI = ((PawnToSit == none) ? none : Seats[SeatIndex].SeatPawn.PlayerReplicationInfo);
	}
	Mask = 1 << SeatIndex;
	// End:0xF2
	if(PawnToSit != none)
	{
		SeatMask = SeatMask | Mask;		
	}
	else
	{
		// End:0x12A
		if((SeatMask & Mask) > 0)
		{
			SeatMask = SeatMask ^ Mask;
		}
	}
	//return;	
}

simulated function SetMovementEffect(int SeatIndex, bool bSetActive, optional UTPawn UTP)
{
	local bool bIsLocal;

	// End:0x236
	if(bSetActive && ReferenceMovementMesh != none)
	{
		bIsLocal = ((UTP == none) ? IsLocallyControlled() : UTP.IsLocallyControlled());
		// End:0x233
		if(bIsLocal && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
		{
			// End:0xFD
			if(Seats[SeatIndex].SeatMovementEffect != none)
			{
				Seats[SeatIndex].SeatMovementEffect.Destroy();
			}
			Seats[SeatIndex].SeatMovementEffect = Spawn(Class'UTGame.VehicleMovementEffect', Seats[SeatIndex].SeatPawn,, Location, Rotation);
			// End:0x233
			if(Seats[SeatIndex].SeatMovementEffect != none)
			{
				Seats[SeatIndex].SeatMovementEffect.SetBase(self);
				Seats[SeatIndex].SeatMovementEffect.AirEffect.SetStaticMesh(ReferenceMovementMesh);
			}
		}		
	}
	else
	{
		// End:0x297
		if(Seats[SeatIndex].SeatMovementEffect != none)
		{
			Seats[SeatIndex].SeatMovementEffect.Destroy();
		}
	}
	//return;	
}

simulated function DetachDriver(Pawn P)
{
	super(UDKVehicleBase).DetachDriver(P);
	SetMovementEffect(0, false);
	//return;	
}

function bool CanAttack(Actor Other)
{
	local float MaxRange;
	local Weapon W;

	// End:0x18D
	if(((((bShouldLeaveForCombat && Driver != none) && Driver.InvManager != none) && Controller != none) && !WorldInfo.GRI.OnSameTeam(self, Other)) && !IsHumanControlled())
	{
		// End:0x12A
		foreach Driver.InvManager.InventoryActors(Class'Engine.Weapon', W)
		{
			MaxRange = FMax(MaxRange, W.MaxRange());			
		}		
		return (VSize(Location - Other.Location) <= MaxRange) && Controller.LineOfSightTo(Other);		
	}
	else
	{
		return super(Pawn).CanAttack(Other);
	}
	//return ReturnValue;	
}

function name GetVehicleKillStatName()
{
	local name VehicleKillStatName;

	VehicleKillStatName = name(string('VEHICLEKILL_') $ string(Class.Name));
	return VehicleKillStatName;
	//return ReturnValue;	
}

simulated function DisplayHud(UTHUD HUD, Canvas Canvas, Vector2D HudPOS, optional int SeatIndex)
{
	local Vector2D pos;
	local float W, H, PercValue, PosX, PosY, BarWidth,
		BarHeight;

	local int VHealth;
	local LinearColor MissingHealthColor;

	W = Abs(HudCoords.UL) * HUD.ResolutionScale;
	H = Abs(HudCoords.VL) * HUD.ResolutionScale;
	PosX = Canvas.ClipX - W;
	PosY = (Canvas.ClipY - H) - (float(3) * HUD.ResolutionScale);
	VHealth = Max(0, Health);
	PercValue = FClamp(float(VHealth) / float(HealthMax), 0.0000000, 1.0000000);
	Canvas.SetPos(PosX, PosY);
	// End:0x318
	if(PercValue < 1.0000000)
	{
		MissingHealthColor = HUD.WhiteLinearColor;
		MissingHealthColor.A = 0.3000000;
		Canvas.DrawTile(HudIcons, W, H * (1.0000000 - PercValue), HudCoords.U, HudCoords.V, HudCoords.UL, HudCoords.VL * (1.0000000 - PercValue), MissingHealthColor);
		Canvas.SetPos(PosX, PosY + (H * (1.0000000 - PercValue)));
	}
	Canvas.DrawTile(HudIcons, W, H * PercValue, HudCoords.U, HudCoords.V + (HudCoords.VL * (1.0000000 - PercValue)), HudCoords.UL, HudCoords.VL * PercValue, HUD.TeamHUDColor);
	DisplaySeats(HUD, Canvas, PosX, PosY, W, H, SeatIndex);
	// End:0x7D1
	if(HUD.bShowVehicleArmorCount)
	{
		PosX = PosX - (float(140) * HUD.ResolutionScale);
		PosY = Canvas.ClipY - (float(47) * HUD.ResolutionScale);
		Canvas.SetPos(PosX, PosY);
		Canvas.DrawTile(HUD.AltHudTexture, 140.0000000 * HUD.ResolutionScale, 44.0000000 * HUD.ResolutionScale, 4.0000000, 346.0000000, 112.0000000, 35.0000000, HUD.TeamHUDColor);
		// End:0x646
		if(Health > LastHealth)
		{
			HealthPulseTime = WorldInfo.TimeSeconds;
		}
		LastHealth = Health;
		HUD.DrawGlowText(string(VHealth), PosX + (float(130) * HUD.ResolutionScale), PosY + (float(-9) * HUD.ResolutionScale), 53.0000000 * HUD.ResolutionScale, HealthPulseTime, true);
		W += (float(140) * HUD.ResolutionScale);
		pos.X = PosX;
		pos.Y = PosY;
		DisplayExtraHud(HUD, Canvas, pos, W, H, SeatIndex);		
	}
	else
	{
		PosY = Canvas.ClipY - (float(5) * HUD.ResolutionScale);
	}
	// End:0xA25
	if((Seats[SeatIndex].Gun != none) && int(UTVehicleWeapon(Seats[SeatIndex].Gun).AmmoDisplayType) != int(0))
	{
		PercValue = UTVehicleWeapon(Seats[SeatIndex].Gun).GetPowerPerc();
		BarHeight = 70.0000000 * HUD.ResolutionScale;
		BarWidth = 16.0000000 * HUD.ResolutionScale;
		PosX = (Canvas.ClipX - (Abs(HudCoords.UL) * HUD.ResolutionScale)) - BarWidth;
		PosY = PosY - BarHeight;
		DrawBarGraph(PosX, PosY, BarHeight * PercValue, BarHeight, BarWidth, Canvas);
	}
	//return;	
}

simulated function DrawBarGraph(float X, float Y, float Width, float MaxWidth, float Height, Canvas DrawCanvas)
{
	DrawCanvas.DrawColor = Class'UTGame.UTHUD'.default.WhiteColor;
	DrawCanvas.SetPos(X, Y);
	DrawCanvas.DrawTile(Class'UTGame.UTHUD'.default.AltHudTexture, Height, MaxWidth, 376.0000000, 458.0000000, 88.0000000, 14.0000000);
	DrawCanvas.DrawColor = Class'UTGame.UTHUD'.default.WhiteColor;
	DrawCanvas.DrawColor.B = 16;
	DrawCanvas.SetPos(X, (Y + MaxWidth) - Width);
	DrawCanvas.DrawTile(Class'UTGame.UTHUD'.default.AltHudTexture, Height, Width, 202.0000000, 238.0000000, 37.0000000, 9.0000000);
	//return;	
}

simulated function DisplayExtraHud(UTHUD HUD, Canvas Canvas, Vector2D pos, float Width, float Height, int SIndex)
{
	//return;	
}

simulated function DisplaySeats(UTHUD HUD, Canvas Canvas, float PosX, float PosY, float Width, float Height, int SIndex)
{
	local int I;
	local float X, Y;

	I = 0;
	J0x0B:

	// End:0x217 [Loop If]
	if(I < Seats.Length)
	{
		X = PosX + (Width * (Seats[I].SeatIconPOS.X + HUD.TX));
		Y = PosY + (Height * (Seats[I].SeatIconPOS.Y + HUD.TY));
		Canvas.SetPos(X, Y);
		HUD.DrawTileCentered(HUD.AltHudTexture, 18.0000000 * HUD.ResolutionScale, 18.0000000 * HUD.ResolutionScale, 267.0000000, 1.0000000, 20.0000000, 20.0000000, GetSeatColor(I, I == SIndex));
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

simulated function LinearColor GetSeatColor(int SeatIndex, bool bIsPlayersSeat)
{
	local byte TestMask;

	// End:0x8A
	if(!bIsPlayersSeat)
	{
		TestMask = byte(int(1) << SeatIndex);
		// End:0x68
		if((SeatMask & int(TestMask)) > 0)
		{
			return Class'UTGame.UTHUD'.default.WhiteLinearColor;			
		}
		else
		{
			return MakeLinearColor(0.5000000, 0.5000000, 0.5000000, 1.0000000);
		}		
	}
	else
	{
		return Class'UTGame.UTHUD'.default.GoldLinearColor;
	}
	//return ReturnValue;	
}

simulated function ApplyWeaponEffects(int OverlayFlags, optional int SeatIndex)
{
	local int I, OverlayIndex;
	local UTGameReplicationInfo GRI;

	OverlayIndex = -1;
	GRI = UTGameReplicationInfo(WorldInfo.GRI);
	// End:0x10B
	if(GRI != none)
	{
		I = 0;
		J0x5B:

		// End:0x10B [Loop If]
		if(I < GRI.VehicleWeaponEffects.Length)
		{
			// End:0xFD
			if((GRI.VehicleWeaponEffects[I].Mesh != none) && bool(OverlayFlags & (1 << I)))
			{
				OverlayIndex = I;
				// [Explicit Break]
				goto J0x10B;
			}
			I++;
			// [Loop Continue]
			goto J0x5B;
		}
	}
	J0x10B:

	// End:0x278
	if(OverlayIndex == -1)
	{
		I = 0;
		J0x129:

		// End:0x275 [Loop If]
		if(I < Seats[SeatIndex].WeaponEffects.Length)
		{
			// End:0x267
			if((Seats[SeatIndex].WeaponEffects[I].Effect != none) && Seats[SeatIndex].WeaponEffects[I].Effect.bAttached)
			{
				Mesh.DetachComponent(Seats[SeatIndex].WeaponEffects[I].Effect);
			}
			I++;
			// [Loop Continue]
			goto J0x129;
		}		
	}
	else
	{
		I = 0;
		J0x283:

		// End:0x6E7 [Loop If]
		if(I < Seats[SeatIndex].WeaponEffects.Length)
		{
			// End:0x4AC
			if(Seats[SeatIndex].WeaponEffects[I].Effect == none)
			{
				Seats[SeatIndex].WeaponEffects[I].Effect = new (self, (string(self) $ "_WeaponEffect_") $ string(I)) Class'Engine.StaticMeshComponent';
				Seats[SeatIndex].WeaponEffects[I].Effect.SetTranslation(Seats[SeatIndex].WeaponEffects[I].Offset);
				Seats[SeatIndex].WeaponEffects[I].Effect.SetScale3D(Seats[SeatIndex].WeaponEffects[I].Scale3D);
			}
			Seats[SeatIndex].WeaponEffects[I].Effect.SetStaticMesh(GRI.VehicleWeaponEffects[OverlayIndex].Mesh);
			Seats[SeatIndex].WeaponEffects[I].Effect.SetMaterial(0, GRI.VehicleWeaponEffects[OverlayIndex].Material);
			// End:0x6D9
			if(!Seats[SeatIndex].WeaponEffects[I].Effect.bAttached)
			{
				Mesh.AttachComponentToSocket(Seats[SeatIndex].WeaponEffects[I].Effect, Seats[SeatIndex].WeaponEffects[I].SocketName);
			}
			I++;
			// [Loop Continue]
			goto J0x283;
		}
	}
	//return;	
}

function bool ShouldLeaveForCombat(UTBot B)
{
	return bShouldLeaveForCombat;
	//return ReturnValue;	
}

simulated state DyingVehicle
{
	ignores CheckDamageSmoke, BlowupVehicle, PostRenderFor, Died, Landed, BaseChange, 
		PlayNextAnimation, PlayWeaponSwitch, FellOutOfWorld, BreathTimer, Falling, 
		PhysicsVolumeChange, HeadVolumeChange, HitWall, Bump;

	simulated function DoVehicleExplosion(bool bDoingSecondaryExplosion)
	{
		local UTPlayerController UTPC;
		local float Dist, ShakeScale, MINVIEWDIST;
		local ParticleSystem Template;
		local SkelControlListHead LH;
		local SkelControlBase NextSkelControl;
		local UTSkelControl_Damage DamSkelControl;
		local Vector BoneLocation;
		local bool bIsVisible;

		// End:0x4BA
		if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
		{
			// End:0x45
			if(bDoingSecondaryExplosion)
			{
				bIsVisible = true;				
			}
			else
			{
				MINVIEWDIST = 10000.0000000;
				// End:0x1D2
				foreach LocalPlayerControllers(Class'UTGame.UTPlayerController', UTPC)
				{
					Dist = VSize(Location - UTPC.ViewTarget.Location);
					// End:0xF0
					if(UTPC == KillerController)
					{
						bIsVisible = true;
						Dist *= 0.2500000;
					}
					MINVIEWDIST = FMin(Dist, MINVIEWDIST);
					// End:0x1D1
					if(Dist < OuterExplosionShakeRadius)
					{
						bIsVisible = true;
						// End:0x1D1
						if(DeathExplosionShake != none)
						{
							ShakeScale = 1.0000000;
							// End:0x19B
							if(Dist > InnerExplosionShakeRadius)
							{
								ShakeScale -= ((Dist - InnerExplosionShakeRadius) / (OuterExplosionShakeRadius - InnerExplosionShakeRadius));
							}
							UTPC.PlayCameraAnim(DeathExplosionShake, ShakeScale);
						}
					}					
				}				
				bIsVisible = bIsVisible || (WorldInfo.TimeSeconds - LastRenderTime) < 3.0000000;
			}
			// End:0x2C2
			if(bIsVisible)
			{
				// End:0x290
				if(!bDoingSecondaryExplosion)
				{
					// End:0x28D
					if(BigExplosionTemplates.Length > 0)
					{
						Template = Class'UTGame.UTEmitter'.static.GetTemplateForDistance(BigExplosionTemplates, Location, WorldInfo);
					}					
				}
				else
				{
					Template = SecondaryExplosion;
				}
				PlayVehicleExplosionEffect(Template, !bDoingSecondaryExplosion);
			}
			// End:0x2EA
			if(ExplosionSound != none)
			{
				PlaySound(ExplosionSound, true);
			}
			// End:0x4BA
			if(((MINVIEWDIST < 6000.0000000) && Mesh != none) && AnimTree(Mesh.Animations) != none)
			{
				// End:0x4B9
				foreach AnimTree(Mesh.Animations).SkelControlLists(LH)
				{
					NextSkelControl = LH.ControlHead;
					J0x3AD:

					// End:0x4B8 [Loop If]
					if(NextSkelControl != none)
					{
						DamSkelControl = UTSkelControl_Damage(NextSkelControl);
						// End:0x48D
						if(DamSkelControl != none)
						{
							// End:0x48D
							if(DamSkelControl.bOnDeathUseForSecondaryExplosion == bDoingSecondaryExplosion)
							{
								BoneLocation = Mesh.GetBoneLocation(LH.BoneName);
								DamSkelControl.BreakApartOnDeath(BoneLocation, bIsVisible);
							}
						}
						NextSkelControl = NextSkelControl.NextControl;
						// [Loop Continue]
						goto J0x3AD;
					}					
				}				
			}
		}
		HurtRadius(ExplosionDamage, ExplosionRadius, Class'UTGame.UTDmgType_VehicleExplosion', ExplosionMomentum, Location,, GetCollisionDamageInstigator());
		AddVelocity((ExplosionMomentum / Mass) * vect(0.0000000, 0.0000000, 1.0000000), Location, Class'UTGame.UTDmgType_VehicleExplosion');
		// End:0x58F
		if((int(Role) == int(ROLE_Authority)) && !bVehicleOnGround)
		{
			Mesh.SetRBAngularVelocity(VRand() * ExplosionInAirAngVel, true);
		}
		//return;		
	}

	simulated function PlayVehicleExplosionEffect(ParticleSystem TheExplosionTemplate, bool bSpawnLight)
	{
		local editinline UDKExplosionLight L;

		// End:0x1BD
		if(TheExplosionTemplate != none)
		{
			DeathExplosion = Spawn(Class'UTGame.UTEmitter', self);
			// End:0x76
			if(BigExplosionSocket != 'None')
			{
				DeathExplosion.SetBase(self,, Mesh, BigExplosionSocket);
			}
			DeathExplosion.SetTemplate(TheExplosionTemplate, true);
			DeathExplosion.ParticleSystemComponent.SetFloatParameter('Velocity', ((GroundSpeed > 0.0100000) ? VSize(Velocity) / GroundSpeed : 0.0000000));
			// End:0x1BD
			if(((bSpawnLight && ExplosionLightClass != none) && !WorldInfo.bDropDetail) && ShouldSpawnExplosionLight(Location, vect(0.0000000, 0.0000000, 1.0000000)))
			{
				L = new (DeathExplosion) ExplosionLightClass;
				DeathExplosion.AttachComponent(L);
			}
		}
		//return;		
	}

	simulated function SecondaryVehicleExplosion()
	{
		// End:0x4B
		if(Velocity.Z < -100.0000000)
		{
			SetTimer(1.0000000, false, 'SecondaryVehicleExplosion');
			LifeSpan += 1.0000000;
			return;
		}
		//return;		
	}

	simulated function PerformSecondaryVehicleExplosion()
	{
		local UTPlayerController UTPC;
		local bool bIsVisible;

		Mesh.SetNotifyRigidBodyCollision(false);
		// End:0x106
		if((WorldInfo.TimeSeconds - LastRenderTime) < 0.1000000)
		{
			// End:0x105
			foreach LocalPlayerControllers(Class'UTGame.UTPlayerController', UTPC)
			{
				// End:0x104
				if(UTPC.ViewTarget != none)
				{
					bIsVisible = (UTPC == KillerController) || VSizeSq(UTPC.ViewTarget.Location - Location) < 25000000.0000000;
					// End:0x105
					break;
				}				
			}			
		}
		// End:0x11E
		if(bIsVisible)
		{
			DoVehicleExplosion(true);
		}
		//return;		
	}

	simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData Collision, int ContactIndex)
	{
		super(UTVehicle).RigidBodyCollision(HitComponent, OtherComponent, Collision, ContactIndex);
		// End:0x63
		if(IsTimerActive('SecondaryVehicleExplosion'))
		{
			ClearTimer('SecondaryVehicleExplosion');
			PerformSecondaryVehicleExplosion();
		}
		//return;		
	}

	simulated event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
	{
		// End:0x12F
		if(DamageType != none)
		{
			Damage *= DamageType.static.VehicleDamageScalingFor(self);
			Health -= Damage;
			AddVelocity(Momentum, HitLocation, DamageType, HitInfo);
			// End:0x12F
			if(DamageType == Class'UTGame.UTDmgType_VehicleCollision')
			{
				// End:0x107
				if(EffectIsRelevant(Location, false))
				{
					WorldInfo.MyEmitterPool.SpawnEmitter(ExplosionTemplate, HitLocation, Rotator(vect(0.0000000, 0.0000000, 1.0000000)));
				}
				// End:0x12F
				if(ExplosionSound != none)
				{
					PlaySound(ExplosionSound, true);
				}
			}
		}
		//return;		
	}

	simulated function VehicleCalcCamera(float fDeltaTime, int SeatIndex, out Vector out_CamLoc, out Rotator out_CamRot, out Vector CamStart, optional bool bPivotOnly)
	{
		global.VehicleCalcCamera(fDeltaTime, SeatIndex, out_CamLoc, out_CamRot, CamStart, bPivotOnly);
		bStopDeathCamera = bStopDeathCamera || out_CamLoc.Z < WorldInfo.KillZ;
		// End:0xF5
		if(bStopDeathCamera && OldCameraPosition != vect(0.0000000, 0.0000000, 0.0000000))
		{
			out_CamLoc = OldCameraPosition;
			out_CamRot = Rotator(CamStart - out_CamLoc);
		}
		OldCameraPosition = out_CamLoc;
		//return;		
	}

	simulated function BeginState(name PreviousStateName)
	{
		local int I;

		StopVehicleSounds();
		DamageSmokeThreshold = 0.0000000;
		CheckDamageSmoke();
		I = 0;
		J0x2E:

		// End:0xE9 [Loop If]
		if(I < DamageMorphTargets.Length)
		{
			DamageMorphTargets[I].Health = 0;
			// End:0xDB
			if(DamageMorphTargets[I].MorphNode != none)
			{
				DamageMorphTargets[I].MorphNode.SetNodeWeight(1.0000000);
			}
			I++;
			// [Loop Continue]
			goto J0x2E;
		}
		UpdateDamageMaterial();
		ClientHealth = Min(ClientHealth, 0);
		LastCollisionSoundTime = WorldInfo.TimeSeconds;
		DoVehicleExplosion(false);
		// End:0x166
		if(TimeTilSecondaryVehicleExplosion > 0.0000000)
		{
			SetTimer(TimeTilSecondaryVehicleExplosion, false, 'SecondaryVehicleExplosion');
		}
		I = 0;
		J0x171:

		// End:0x1C5 [Loop If]
		if(I < DamageSkelControls.Length)
		{
			DamageSkelControls[I].HealthPerc = 0.0000000;
			I++;
			// [Loop Continue]
			goto J0x171;
		}
		// End:0x1F8
		if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
		{
			PerformDeathEffects();
		}
		SetBurnOut();
		// End:0x259
		if(Controller != none)
		{
			// End:0x241
			if(Controller.bIsPlayer)
			{
				DetachFromController();				
			}
			else
			{
				Controller.Destroy();
			}
		}
		I = 0;
		J0x264:

		// End:0x2CC [Loop If]
		if(I < Attached.Length)
		{
			// End:0x2BE
			if(Attached[I] != none)
			{
				Attached[I].PawnBaseDied();
			}
			I++;
			// [Loop Continue]
			goto J0x264;
		}
		//return;		
	}

	simulated function PerformDeathEffects()
	{
		// End:0x17
		if(bHasTurretExplosion)
		{
			TurretExplosion();
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	bValidLinkTarget=true
	bEnteringUnlocks=true
	bMustBeUpright=true
	bShouldAutoCenterViewPitch=true
	bDrawHealthOnHUD=true
	bFindGroundExit=true
	bNoZSmoothing=true
	// Reference: DynamicLightEnvironmentComponent'UTGame.Default__UTVehicle.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	begin object name="MyLightEnvironment" class=Engine.DynamicLightEnvironmentComponent
		bUseBooleanEnvironmentShadowing=false
		bSynthesizeSHLight=true
	end object
	LightEnvironment=MyLightEnvironment
	RespawnTime=30.0000000
	LinkHealMult=1.0000000
	MaxDesireability=0.5000000
	HornAIRadius=800.0000000
	LookSteerSensitivity=2.0000000
	ConsoleSteerScale=1.5000000
	RanOverDamageType=Class'UTGame.UTDmgType_RanOver'
	StolenAnnouncementIndex=4
	VehiclePositionString="in a vehicle"
	VehicleNameString="Vehicle"
	NeedToPickUpAnnouncement=(AnnouncementSound=none,AnnouncementText="Man the Key Vehicle!")
	TeamBeaconPlayerInfoMaxDist=3000.0000000
	HUDExtent=100.0000000
	VehicleDrowningDamType=Class'UTGame.UTDmgType_Drowned'
	ExplosionLightClass=Class'UTGame.UTRocketExplosionLight'
	MaxExplosionLightDistance=4000.0000000
	TimeTilSecondaryVehicleExplosion=2.0000000
	VehiclePieceClass=Class'UTGame.UTGib_VehiclePiece'
	DamageSmokeThreshold=0.6500000
	ExplosionDamageType=Class'UTGame.UTDmgType_VehicleExplosion'
	MaxImpactEffectDistance=6000.0000000
	MaxFireEffectDistance=7000.0000000
	ExplosionTemplate=ParticleSystem'FX_VehicleExplosions.Effects.P_FX_GeneralExplosion'
	BigExplosionTemplates[0]=(Template=ParticleSystem'FX_VehicleExplosions.Effects.P_FX_VehicleDeathExplosion',MinDistance=0.0000000)
	SecondaryExplosion=ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_Dust_Secondary'
	BurnOutTime=2.5000000
	DeadVehicleLifeSpan=9.0000000
	ExplosionDamage=100.0000000
	ExplosionRadius=300.0000000
	ExplosionMomentum=60000.0000000
	ExplosionInAirAngVel=1.5000000
	DeathExplosionShake=CameraAnim'Envy_Effects.Camera_Shakes.C_VH_Death_Shake'
	InnerExplosionShakeRadius=400.0000000
	OuterExplosionShakeRadius=1000.0000000
	TurretScaleControlName="TurretScale"
	TurretSocketName="VH_Death"
	DistanceTurretExplosionTemplates[0]=(Template=ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_SpecialCase_1_Base_Near',MinDistance=1500.0000000)
	DistanceTurretExplosionTemplates[1]=(Template=ParticleSystem'Envy_Effects.VH_Deaths.P_VH_Death_SpecialCase_1_Base_Far',MinDistance=0.0000000)
	TurretOffset=(X=200.0000000,Y=0.0000000,Z=0.0000000)
	TurretExplosiveForce=10000.0000000
	BurnTimeParameterName="BurnTime"
	SpawnRadius=320.0000000
	FlagOffset=(X=120.0000000,Y=0.0000000,Z=0.0000000)
	FlagRotation=(Pitch=0,Yaw=32768,Roll=0)
	MapSize=0.7500000
	IconCoords=(U=831.0000000,V=21.0000000,UL=38.0000000,VL=30.0000000)
	FlipToolTipIconCoords=(U=2.0000000,V=766.0000000,UL=79.0000000,VL=71.0000000)
	EnterToolTipIconCoords=(U=96.0000000,V=249.0000000,UL=77.0000000,VL=64.0000000)
	DropFlagIconCoords=(U=85.0000000,V=767.0000000,UL=66.0000000,VL=48.0000000)
	DropOrbIconCoords=(U=109.0000000,V=815.0000000,UL=55.0000000,VL=38.0000000)
	TeamBeaconOffset=(X=100.0000000,Y=0.0000000,Z=0.0000000)
	PassengerTeamBeaconOffset=(X=100.0000000,Y=0.0000000,Z=0.0000000)
	HudIcons=Texture2D'UI_HUD.HUD.UI_HUD_BaseB'
	SpawnInTemplates[0]=ParticleSystem'VH_All.Effects.P_VH_All_Spawn_Red'
	SpawnInTemplates[1]=ParticleSystem'VH_All.Effects.P_VH_All_Spawn_Blue'
	SpawnMaterialParameterName="ResInAmount"
	SpawnMaterialParameterCurve=(Points=((InVal=0.0000000,OutVal=0.0000000,ArriveTangent=0.0000000,LeaveTangent=0.0000000,InterpMode=CIM_Linear),(InVal=4.0000000,OutVal=2.5000000,ArriveTangent=0.0000000,LeaveTangent=0.0000000,InterpMode=CIM_Linear)),InterpMethod=IMT_UseFixedTangentEvalAndNewAutoTangents)
	SpawnInTime=4.0000000
	CollisionDamageMult=0.0020000
	SeatCameraScale=1.0000000
	CameraSmoothingFactor=2.0000000
	DefaultFOV=75.0000000
	CameraLag=0.1200000
	MinCameraDistSq=1.0000000
	DisabledTime=20.0000000
	DisabledTemplate=ParticleSystem'Pickups.Deployables.Effects.P_Deployables_EMP_Mine_VehicleDisabled'
	LastEnemyWarningTime=-100.0000000
	Team=128
	bEjectPassengersWhenFlipped=true
	bTakeWaterDamageWhileDriving=true
	bTeamLocked=true
	FireDamageThreshold=0.4000000
	FireDamagePerSec=2.0000000
	UpsideDownDamagePerSec=500.0000000
	OccupiedUpsideDownDamagePerSec=200.0000000
	WaterDamage=20.0000000
	DrivingAnim="Manta_Idle_Sitting"
	DestroyOnPenetrationThreshold=50.0000000
	DestroyOnPenetrationDuration=1.0000000
	WaterEffectType="Water"
	MinRunOverSpeed=250.0000000
	MinRunOverWarningAim=0.8800000
	// Reference: GwNavBotHandle'UTGame.Default__UTVehicle.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'UDKBase.Default__UDKVehicle.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	bCanFlip=false
	// Reference: RB_StayUprightSetup'UTGame.Default__UTVehicle.MyStayUprightSetup'
	// Archetype: RB_StayUprightSetup'UDKBase.Default__UDKVehicle.MyStayUprightSetup'
	begin object name="MyStayUprightSetup"
	end object
	StayUprightConstraintSetup=MyStayUprightSetup
	// Reference: RB_ConstraintInstance'UTGame.Default__UTVehicle.MyStayUprightConstraintInstance'
	// Archetype: RB_ConstraintInstance'UDKBase.Default__UDKVehicle.MyStayUprightConstraintInstance'
	begin object name="MyStayUprightConstraintInstance"
	end object
	StayUprightConstraintInstance=MyStayUprightConstraintInstance
	MomentumMult=2.0000000
	CrushedDamageType=Class'UTGame.UTDmgType_Pancake'
	MinCrushSpeed=100.0000000
	BaseEyeHeight=30.0000000
	EyeHeight=30.0000000
	// Reference: SkeletalMeshComponent'UTGame.Default__UTVehicle.SVehicleMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SVehicleMesh'
	// Archetype: SkeletalMeshComponent'UDKBase.Default__UDKVehicle.SVehicleMesh'
	begin object name="SVehicleMesh"
		bPerBoneMotionBlur=true
		bOverrideAttachmentOwnerVisibility=true
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'UTGame.Default__UTVehicle.MyLightEnvironment'
	end object
	Mesh=SVehicleMesh
	// Reference: CylinderComponent'UTGame.Default__UTVehicle.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'UDKBase.Default__UDKVehicle.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
	end object
	CylinderComponent=CollisionCylinder
	ViewPitchMin=-15000.0000000
	InventoryManagerClass=Class'UTGame.UTInventoryManager'
	Components[0]=CollisionCylinder
	Components[1]=SVehicleMesh
	Components[2]=myGwNavBotHandle
	Components[3]=MyLightEnvironment
	bPushedByEncroachers=false
	bAlwaysRelevant=true
	CollisionComponent=SVehicleMesh
}