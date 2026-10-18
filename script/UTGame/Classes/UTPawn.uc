class UTPawn extends UDKPawn
	config(Game);

const MINTIMEBETWEENPAINSOUNDS = 0.35;

enum EWeapAnimType
{
	EWAT_Default,                   // 0
	EWAT_Pistol,                    // 1
	EWAT_DualPistols,               // 2
	EWAT_ShoulderRocket,            // 3
	EWAT_Stinger,                   // 4
	EWAT_MAX                        // 5
};

struct GibInfo
{
	var name BoneName;
	var Class<UTGib> GibClass;
	var bool bHighDetailOnly;

	structdefaultproperties
	{
		BoneName="None"
		GibClass=none
		bHighDetailOnly=false
	}
};

var bool bFixedView;
var bool bSpawnDone;
var bool bSpawnIn;
var bool bShieldAbsorb;
var bool bDodging;
var bool bStopOnDoubleLanding;
var bool bIsInvulnerable;
var bool bJustDroppedOrb;
var bool bForcedFeignDeath;
var globalconfig bool bWeaponBob;
var bool bJustLanded;
var bool bLandRecovery;
var bool bHasHoverboard;
var bool bStopDeathCamera;
var bool bWinnerCam;
var bool bGibbed;
var bool bHeadGibbed;
var bool bArmsAttached;
var bool bWeaponAttachmentVisible;
var bool bHideOnListenServer;
var bool bPostRenderTraceSucceeded;
var bool bReceivedValidTeam;
var bool bKillsAffectHead;
var bool bKilledByBio;
var repnotify Class<UTWeaponAttachment> CurrentWeaponAttachmentClass;
var int UnfeignFailedCount;
var export editinline DynamicLightEnvironmentComponent LightEnvironment;
var AnimNodeBlend FeignDeathBlend;
var AnimNodeSlot FullBodyAnimSlot;
var AnimNodeSlot TopHalfAnimSlot;
var float DeathHipLinSpring;
var float DeathHipLinDamp;
var float DeathHipAngSpring;
var float DeathHipAngDamp;
var float StartDeathAnimTime;
var Class<UTDamageType> DeathAnimDamageType;
var float TimeLastTookDeathAnimDamage;
var Vector FixedViewLoc;
var Rotator FixedViewRot;
var float CameraScale;
var float CurrentCameraScale;
var float CameraScaleMin;
var float CameraScaleMax;
var Vector OldCameraPosition;
var float CameraZOffset;
var float HeroCameraScale;
var int HeroCameraPitch;
var float DodgeSpeed;
var float DodgeSpeedZ;
var Actor.EDoubleClickDir CurrentDir;
var float DoubleJumpEyeHeight;
var float DoubleJumpThreshold;
var float DefaultAirControl;
var globalconfig float Bob;
var float LandBob;
var float JumpBob;
var float AppliedBob;
var float BobTime;
var Vector WalkBob;
var float FeignDeathBodyAtRestSpeed;
var float FeignDeathStartTime;
var float FeignDeathRecoveryStartTime;
var int SuperHealthMax;
var Class<UTPawnSoundGroup> SoundGroupClass;
var Class<UTFamilyInfo> CurrCharClassInfo;
var array<name> TakeHitPhysicsFixedBones;
var array<name> NoDriveBodies;
var ForceFeedbackWaveform FallingDamageWaveForm;
var float AccumulateDamage;
var float AccumulationTime;
var float LastHoverboardTime;
var float MinHoverboardInterval;
var UTAnimBlendByDriving DrivingNode;
var UTAnimBlendByVehicle VehicleNode;
var UTAnimBlendByHoverboarding HoverboardingNode;
var float ShieldBeltArmor;
var float VestArmor;
var float ThighpadArmor;
var UTWeaponAttachment CurrentWeaponAttachment;
var name WeaponSocket;
var name WeaponSocket2;
var name PawnEffectSockets[2];
var float HeadOffset;
var float HeadRadius;
var float HeadHeight;
var name HeadBone;
var name HipsBone;
var protected export editinline StaticMeshComponent HeadshotNeckAttachment;
var Class<Actor> TransInEffects[2];
var LinearColor TranslocateColor[2];
var CameraAnim TransCameraAnim[3];
var SoundCue ArmorHitSound;
var SoundCue SpawnSound;
var SoundCue TeleportSound;
var LinearColor SpawnProtectionColor;
var float TeamBeaconPlayerInfoMaxDist;
var Texture SpeakingBeaconTexture;
var float MapSize;
var TextureCoordinates IconCoords;
var float LastPainSound;
var float RagdollLifespan;
var UTProjectile AttachedProj;
var float MaxFootstepDistSq;
var float MaxJumpSoundDistSq;
var Class<UTVehicle> HoverboardClass;
var DrivenWeaponPawnInfo LastDrivenWeaponPawn;
var UTClientSideWeaponPawn ClientSideWeaponPawn;
var MaterialInterface ShieldBeltMaterialInstance;
var MaterialInterface ShieldBeltTeamMaterialInstances[4];
var int JumpBootCharge;
var float DefaultMeshScale;
var name TauntNames[6];
var float DesiredMeshScale;
var Vector CamOffset;
var export editinline ParticleSystemComponent BioBurnAway;
var float BioBurnAwayTime;
var name BioEffectName;
var float DeathTime;

replication
{
	// Pos:0x000
	if(bNetOwner && bNetDirty)
		ShieldBeltArmor, ThighpadArmor, 
		VestArmor, bHasHoverboard;

	// Pos:0x019
	if(bNetDirty)
		CurrentWeaponAttachmentClass;
}

simulated function AdjustPPEffects(UTPlayerController PC, bool bRemove)
{
	//return;	
}

function float AdjustedStrength()
{
	return 0.0000000;
	//return ReturnValue;	
}

simulated function UTPlayerReplicationInfo GetUTPlayerReplicationInfo()
{
	local UTPlayerReplicationInfo UTPRI;

	UTPRI = UTPlayerReplicationInfo(PlayerReplicationInfo);
	// End:0x6B
	if(UTPRI == none)
	{
		// End:0x6B
		if(DrivenVehicle != none)
		{
			UTPRI = UTPlayerReplicationInfo(DrivenVehicle.PlayerReplicationInfo);
		}
	}
	return UTPRI;
	//return ReturnValue;	
}

simulated event FellOutOfWorld(Class<DamageType> dmgType)
{
	super(Pawn).FellOutOfWorld(dmgType);
	bStopDeathCamera = true;
	//return;	
}

event HeadVolumeChange(PhysicsVolume newHeadVolume)
{
	// End:0x3C
	if((int(WorldInfo.NetMode) == int(NM_Client)) || Controller == none)
	{
		return;
	}
	// End:0xF8
	if((HeadVolume != none) && HeadVolume.bWaterVolume)
	{
		// End:0xF5
		if(newHeadVolume.bWaterVolume!)
		{
			// End:0xE6
			if((Controller.bIsPlayer && BreathTime > float(0)) && BreathTime < float(8))
			{
				Gasp();
			}
			BreathTime = -1.0000000;
		}		
	}
	else
	{
		// End:0x13E
		if((newHeadVolume != none) && newHeadVolume.bWaterVolume)
		{
			BreathTime = UnderWaterTime;
		}
	}
	//return;	
}

function bool PoweredUp()
{
	return ((DamageScaling > float(1)) || FireRateMultiplier < float(1)) || bIsInvulnerable;
	//return ReturnValue;	
}

function bool InCombat()
{
	return ((WorldInfo.TimeSeconds - LastPainSound) < float(1)) && PhysicsVolume.bPainCausing!;
	//return ReturnValue;	
}

simulated function RenderMapIcon(UTMapInfo MP, Canvas Canvas, UTPlayerController PlayerOwner, LinearColor FinalColor)
{
	MP.DrawRotatedTile(Canvas, Class'UTGame.UTHUD'.default.IconHudTexture, HUDLocation, Rotation.Yaw, MapSize, IconCoords, FinalColor);
	//return;	
}

event SetWalking(bool bNewIsWalking)
{
	//return;	
}

simulated function ClearBodyMatColor()
{
	RemainingBodyMatDuration = 0.0000000;
	ClientBodyMatDuration = 0.0000000;
	BodyMatFadeDuration = 0.0000000;
	//return;	
}

simulated function SetBodyMatColor(LinearColor NewBodyMatColor, float NewOverlayDuration)
{
	RemainingBodyMatDuration = NewOverlayDuration;
	ClientBodyMatDuration = RemainingBodyMatDuration;
	BodyMatFadeDuration = 0.5000000 * RemainingBodyMatDuration;
	BodyMatColor = NewBodyMatColor;
	CompressedBodyMatColor.Pitch = int(float(256) * BodyMatColor.R);
	CompressedBodyMatColor.Yaw = int(float(256) * BodyMatColor.G);
	CompressedBodyMatColor.Roll = int(float(256) * BodyMatColor.B);
	CurrentBodyMatColor = BodyMatColor;
	CurrentBodyMatColor.R += float(1);
	VerifyBodyMaterialInstance();
	//return;	
}

simulated function SetInvisible(bool bNowInvisible)
{
	bIsInvisible = bNowInvisible;
	// End:0xF0
	if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		// End:0x9A
		if(bIsInvisible)
		{
			Mesh.CastShadow = false;
			Mesh.bCastDynamicShadow = false;
			ReattachMesh();			
		}
		else
		{
			UpdateShadowSettings(Class'Engine.Engine'.static.IsSplitScreen()! && int(Class'UTGame.UTPlayerController'.default.PawnShadowMode) == int(2));
		}
	}
	//return;	
}

simulated function SetSkin(Material NewMaterial)
{
	local int I;

	ReplicatedBodyMaterial = NewMaterial;
	// End:0x1E7
	if(VerifyBodyMaterialInstance())
	{
		// End:0x57
		if(CurrentWeaponAttachment != none)
		{
			CurrentWeaponAttachment.SetSkin(NewMaterial);
		}
		// End:0xA0
		if(UTWeapon(Weapon) != none)
		{
			UTWeapon(Weapon).SetSkin(NewMaterial);
		}
		// End:0x148
		if(NewMaterial == none)
		{
			I = 0;
			J0xBA:

			// End:0x145 [Loop If]
			if(I < Mesh.SkeletalMesh.Materials.Length)
			{
				Mesh.SetMaterial(I, BodyMaterialInstances[I]);
				I++;
				// [Loop Continue]
				goto J0xBA;
			}			
		}
		else
		{
			I = 0;
			J0x153:

			// End:0x1D4 [Loop If]
			if(I < Mesh.SkeletalMesh.Materials.Length)
			{
				Mesh.SetMaterial(I, NewMaterial);
				I++;
				// [Loop Continue]
				goto J0x153;
			}
		}
		SetArmsSkin(NewMaterial);
	}
	//return;	
}

protected simulated function SetArmsSkin(MaterialInterface NewMaterial)
{
	local int I, Cnt;

	// End:0x44
	if(NewMaterial == none)
	{
		NewMaterial = CurrCharClassInfo.static.GetFirstPersonArmsMaterial(int(GetTeamNum()));
	}
	// End:0x3AA
	if(NewMaterial == none)
	{
		// End:0x1FD
		if((default.ArmsMesh[0] != none) && ArmsMesh[0] != none)
		{
			// End:0x150
			if(default.ArmsMesh[0].Materials.Length > 0)
			{
				Cnt = default.ArmsMesh[0].Materials.Length;
				I = 0;
				J0xD4:

				// End:0x14D [Loop If]
				if(I < Cnt)
				{
					ArmsMesh[0].SetMaterial(I, default.ArmsMesh[0].GetMaterial(I));
					I++;
					// [Loop Continue]
					goto J0xD4;
				}				
			}
			else
			{
				// End:0x1FD
				if(ArmsMesh[0].Materials.Length > 0)
				{
					Cnt = ArmsMesh[0].Materials.Length;
					I = 0;
					J0x1AD:

					// End:0x1FD [Loop If]
					if(I < Cnt)
					{
						ArmsMesh[0].SetMaterial(I, none);
						I++;
						// [Loop Continue]
						goto J0x1AD;
					}
				}
			}
		}
		// End:0x3A7
		if((default.ArmsMesh[1] != none) && ArmsMesh[1] != none)
		{
			// End:0x2FA
			if(default.ArmsMesh[1].Materials.Length > 0)
			{
				Cnt = default.ArmsMesh[1].Materials.Length;
				I = 0;
				J0x27E:

				// End:0x2F7 [Loop If]
				if(I < Cnt)
				{
					ArmsMesh[1].SetMaterial(I, default.ArmsMesh[1].GetMaterial(I));
					I++;
					// [Loop Continue]
					goto J0x27E;
				}				
			}
			else
			{
				// End:0x3A7
				if(ArmsMesh[1].Materials.Length > 0)
				{
					Cnt = ArmsMesh[1].Materials.Length;
					I = 0;
					J0x357:

					// End:0x3A7 [Loop If]
					if(I < Cnt)
					{
						ArmsMesh[1].SetMaterial(I, none);
						I++;
						// [Loop Continue]
						goto J0x357;
					}
				}
			}
		}		
	}
	else
	{
		// End:0x4F8
		if(((default.ArmsMesh[0] != none) && ArmsMesh[0] != none) && (default.ArmsMesh[0].Materials.Length > 0) || ArmsMesh[0].GetNumElements() > 0)
		{
			Cnt = ((default.ArmsMesh[0].Materials.Length > 0) ? default.ArmsMesh[0].Materials.Length : ArmsMesh[0].GetNumElements());
			I = 0;
			J0x4A0:

			// End:0x4F8 [Loop If]
			if(I < Cnt)
			{
				ArmsMesh[0].SetMaterial(I, NewMaterial);
				I++;
				// [Loop Continue]
				goto J0x4A0;
			}
		}
		// End:0x646
		if(((default.ArmsMesh[1] != none) && ArmsMesh[1] != none) && (default.ArmsMesh[1].Materials.Length > 0) || ArmsMesh[1].GetNumElements() > 0)
		{
			Cnt = ((default.ArmsMesh[1].Materials.Length > 0) ? default.ArmsMesh[1].Materials.Length : ArmsMesh[1].GetNumElements());
			I = 0;
			J0x5EE:

			// End:0x646 [Loop If]
			if(I < Cnt)
			{
				ArmsMesh[1].SetMaterial(I, NewMaterial);
				I++;
				// [Loop Continue]
				goto J0x5EE;
			}
		}
	}
	//return;	
}

simulated function bool VerifyBodyMaterialInstance()
{
	local int I;

	// End:0x11A
	if(((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && Mesh != none) && BodyMaterialInstances.Length < Mesh.GetNumElements())
	{
		BodyMaterialInstances.Length = Mesh.GetNumElements();
		I = 0;
		J0x9F:

		// End:0x11A [Loop If]
		if(I < BodyMaterialInstances.Length)
		{
			// End:0x10C
			if(BodyMaterialInstances[I] == none)
			{
				BodyMaterialInstances[I] = Mesh.CreateAndSetMaterialInstanceConstant(I);
			}
			I++;
			// [Loop Continue]
			goto J0x9F;
		}
	}
	return BodyMaterialInstances.Length > 0;
	//return ReturnValue;	
}

simulated function SetCharacterClassFromInfo(Class<UTFamilyInfo> Info)
{
	local UTPlayerReplicationInfo PRI;
	local int I, TeamNum;
	local MaterialInterface TeamMaterialHead, TeamMaterialBody, TeamMaterialArms;

	PRI = GetUTPlayerReplicationInfo();
	// End:0x697
	if(Info != CurrCharClassInfo)
	{
		CurrCharClassInfo = Info;
		TeamNum = int(GetTeamNum());
		Mesh.AnimSets = Info.default.AnimSets;
		// End:0xF4
		if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
		{
			Info.static.GetTeamMaterials(TeamNum, TeamMaterialHead, TeamMaterialBody);
		}
		SetCharacterMeshInfo(Info.default.CharacterMesh, TeamMaterialHead, TeamMaterialBody);
		// End:0x1DA
		if(((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && IsHumanControlled()) && IsLocallyControlled())
		{
			TeamMaterialArms = Info.static.GetFirstPersonArmsMaterial(TeamNum);
			SetFirstPersonArmsInfo(Info.static.GetFirstPersonArms(), TeamMaterialArms);
		}
		Mesh.SetPhysicsAsset(Info.default.PhysAsset, true);
		Mesh.bEnableFullAnimWeightBodies = false;
		I = 0;
		J0x244:

		// End:0x3AE [Loop If]
		if((I < Mesh.PhysicsAsset.BodySetup.Length) && Mesh.bEnableFullAnimWeightBodies!)
		{
			// End:0x3A0
			if(Mesh.PhysicsAsset.BodySetup[I].bAlwaysFullAnimWeight && Mesh.MatchRefBone(Mesh.PhysicsAsset.BodySetup[I].BoneName) != -1)
			{
				Mesh.bEnableFullAnimWeightBodies = true;
			}
			I++;
			// [Loop Continue]
			goto J0x244;
		}
		// End:0x3FB
		if(OverlayMesh != none)
		{
			OverlayMesh.SetSkeletalMesh(Info.default.CharacterMesh);
		}
		// End:0x541
		if(PRI != none)
		{
			PRI.bIsFemale = Info.default.bIsFemale;
			PRI.VoiceClass = Info.static.GetVoiceClass();
			PRI.CharPortrait = Info.static.GetCharPortrait(TeamNum);
			// End:0x518
			if(PRI.bIsFemale)
			{
				PRI.TTSSpeaker = byte(Rand(4));				
			}
			else
			{
				PRI.TTSSpeaker = byte(Rand(5) + 4);
			}
		}
		LeftFootBone = Info.default.LeftFootBone;
		RightFootBone = Info.default.RightFootBone;
		TakeHitPhysicsFixedBones = Info.default.TakeHitPhysicsFixedBones;
		SoundGroupClass = Info.default.SoundGroupClass;
		DefaultMeshScale = Info.default.DefaultMeshScale;
		Mesh.SetScale(DefaultMeshScale);
		BaseTranslationOffset = CurrCharClassInfo.default.BaseTranslationOffset;
		CrouchTranslationOffset = (BaseTranslationOffset + CylinderComponent.default.CollisionHeight) - CrouchHeight;
	}
	//return;	
}

simulated function SetCharacterMeshInfo(SkeletalMesh SkelMesh, MaterialInterface HeadMaterial, MaterialInterface BodyMaterial)
{
	Mesh.SetSkeletalMesh(SkelMesh);
	// End:0xF9
	if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		// End:0xC6
		if(VerifyBodyMaterialInstance())
		{
			BodyMaterialInstances[0].SetParent(HeadMaterial);
			// End:0xC3
			if(BodyMaterialInstances.Length > 1)
			{
				BodyMaterialInstances[1].SetParent(BodyMaterial);
			}			
		}
		else
		{
			LogInternal("VerifyBodyMaterialInstance failed on pawn" @ string(self));
		}
	}
	//return;	
}

simulated function SetPawnRBChannels(bool bRagdollMode)
{
	// End:0xDB
	if(bRagdollMode)
	{
		Mesh.SetRBChannel(2);
		Mesh.SetRBCollidesWithChannel(0, true);
		Mesh.SetRBCollidesWithChannel(2, true);
		Mesh.SetRBCollidesWithChannel(3, true);
		Mesh.SetRBCollidesWithChannel(9, false);
		Mesh.SetRBCollidesWithChannel(15, true);		
	}
	else
	{
		Mesh.SetRBChannel(9);
		Mesh.SetRBCollidesWithChannel(0, false);
		Mesh.SetRBCollidesWithChannel(2, false);
		Mesh.SetRBCollidesWithChannel(3, false);
		Mesh.SetRBCollidesWithChannel(9, true);
		Mesh.SetRBCollidesWithChannel(15, false);
	}
	//return;	
}

simulated function ResetCharPhysState()
{
	local UTVehicle UTV;

	// End:0x169
	if(Mesh.PhysicsAssetInstance != none)
	{
		// End:0x86
		if(int(Physics) == int(10))
		{
			Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
			SetPawnRBChannels(true);
			SetHandIKEnabled(false);			
		}
		else
		{
			Mesh.PhysicsAssetInstance.SetAllBodiesFixed(true);
			Mesh.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(false, Mesh);
			SetPawnRBChannels(false);
			SetHandIKEnabled(true);
			// End:0x169
			if(DrivenVehicle != none)
			{
				UTV = UTVehicle(DrivenVehicle);
				// End:0x169
				if(UTV != none)
				{
					UTV.OnDriverPhysicsAssetChanged(self);
				}
			}
		}
	}
	//return;	
}

simulated function NotifyTeamChanged()
{
	local UTPlayerReplicationInfo PRI;
	local int I;

	PRI = GetUTPlayerReplicationInfo();
	// End:0x227
	if(PRI != none)
	{
		SetCharacterClassFromInfo(GetFamilyInfo());
		// End:0xF5
		if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
		{
			// End:0xD3
			if(CurrentWeaponAttachmentClass != none)
			{
				// End:0xC9
				if(CurrentWeaponAttachment != none)
				{
					CurrentWeaponAttachment.DetachFrom(Mesh);
					CurrentWeaponAttachment.Destroy();
					CurrentWeaponAttachment = none;
				}
				WeaponAttachmentChanged();
			}
			// End:0xF5
			if(OverlayMaterialInstance != none)
			{
				SetOverlayMaterial(OverlayMaterialInstance);
			}
		}
		NoDriveBodies.Length = 0;
		I = 0;
		J0x10C:

		// End:0x211 [Loop If]
		if(I < Mesh.PhysicsAsset.BodySetup.Length)
		{
			// End:0x203
			if(Mesh.PhysicsAsset.BodySetup[I].bAlwaysFullAnimWeight)
			{
				NoDriveBodies.AddItem(Mesh.PhysicsAsset.BodySetup[I].BoneName);
			}
			I++;
			// [Loop Continue]
			goto J0x10C;
		}
		bIsHoverboardAnimPawn = false;
		ResetCharPhysState();
	}
	// End:0x258
	if(bReceivedValidTeam!)
	{
		SetTeamColor();
		bReceivedValidTeam = (GetTeam()) != none;
	}
	//return;	
}

simulated function SetFirstPersonArmsInfo(SkeletalMesh FirstPersonArmMesh, MaterialInterface ArmMaterial)
{
	ArmsMesh[0].SetSkeletalMesh(FirstPersonArmMesh);
	ArmsMesh[1].SetSkeletalMesh(FirstPersonArmMesh);
	SetArmsSkin(ArmMaterial);
	//return;	
}

simulated function SetTeamColor()
{
	local int I;
	local UTPlayerReplicationInfo PRI;
	local LinearColor LinColor;

	// End:0x2E
	if(PlayerReplicationInfo != none)
	{
		PRI = UTPlayerReplicationInfo(PlayerReplicationInfo);		
	}
	else
	{
		// End:0x6E
		if(DrivenVehicle != none)
		{
			PRI = UTPlayerReplicationInfo(DrivenVehicle.PlayerReplicationInfo);
		}
	}
	// End:0x7F
	if(PRI == none)
	{
		return;
	}
	LinColor.A = 1.0000000;
	// End:0x1BC
	if(PRI.Team == none)
	{
		// End:0x1B9
		if(VerifyBodyMaterialInstance())
		{
			LinColor.R = 2.0000000;
			LinColor.G = 2.0000000;
			I = 0;
			J0x121:

			// End:0x1B9 [Loop If]
			if(I < BodyMaterialInstances.Length)
			{
				BodyMaterialInstances[I].SetVectorParameterValue('Char_TeamColor', LinColor);
				BodyMaterialInstances[I].SetScalarParameterValue('Char_DistSaturateSwitch', 1.0000000);
				I++;
				// [Loop Continue]
				goto J0x121;
			}
		}		
	}
	else
	{
		// End:0x38F
		if(VerifyBodyMaterialInstance())
		{
			// End:0x2CA
			if(PRI.Team.TeamIndex == 0)
			{
				LinColor.R = 2.0000000;
				I = 0;
				J0x22F:

				// End:0x2C7 [Loop If]
				if(I < BodyMaterialInstances.Length)
				{
					BodyMaterialInstances[I].SetVectorParameterValue('Char_TeamColor', LinColor);
					BodyMaterialInstances[I].SetScalarParameterValue('Char_DistSaturateSwitch', 1.0000000);
					I++;
					// [Loop Continue]
					goto J0x22F;
				}				
			}
			else
			{
				LinColor.B = 2.0000000;
				I = 0;
				J0x2F7:

				// End:0x38F [Loop If]
				if(I < BodyMaterialInstances.Length)
				{
					BodyMaterialInstances[I].SetVectorParameterValue('Char_TeamColor', LinColor);
					BodyMaterialInstances[I].SetScalarParameterValue('Char_DistSaturateSwitch', 1.0000000);
					I++;
					// [Loop Continue]
					goto J0x2F7;
				}
			}
		}
	}
	//return;	
}

simulated function PostBeginPlay()
{
	local Rotator R;
	local PlayerController PC;

	StartedFallingTime = WorldInfo.TimeSeconds;
	super(Pawn).PostBeginPlay();
	// End:0x35C
	if(bDeleteMe!)
	{
		// End:0x119
		if(Mesh != none)
		{
			BaseTranslationOffset = Mesh.Translation.Z;
			CrouchTranslationOffset = (Mesh.Translation.Z + CylinderComponent.CollisionHeight) - CrouchHeight;
			OverlayMesh.SetParentAnimComponent(Mesh);
		}
		bCanDoubleJump = CanMultiJump();
		R.Yaw = Rotation.Yaw;
		SetRotation(R);
		// End:0x1EC
		foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
		{
			// End:0x1EB
			if(PC.myHUD != none)
			{
				PC.myHUD.AddPostRenderedActor(self);
			}			
		}		
		// End:0x246
		if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
		{
			UpdateShadowSettings(int(Class'UTGame.UTPlayerController'.default.PawnShadowMode) == int(2));
		}
		// End:0x35C
		if(WorldInfo.IsConsoleBuild(3))
		{
			BlobShadow = new (self) Class'Engine.StaticMeshComponent';
			BlobShadow.SetStaticMesh(StaticMesh'BlobShadow.ShadowMesh');
			BlobShadow.SetActorCollision(false, false);
			BlobShadow.SetScale(0.2000000);
			BlobShadow.SetRotation(rot(16384, 0, 0));
			BlobShadow.SetTranslation(vect(0.0000000, 0.0000000, -44.0000000));
			AttachComponent(BlobShadow);
		}
	}
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
	EnsureOverlayComponentLast();
	//return;	
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	// End:0x3C7
	if(SkelComp == Mesh)
	{
		LeftLegControl = SkelControlFootPlacement(Mesh.FindSkelControl(LeftFootControlName));
		RightLegControl = SkelControlFootPlacement(Mesh.FindSkelControl(RightFootControlName));
		FeignDeathBlend = AnimNodeBlend(Mesh.FindAnimNode('FeignDeathBlend'));
		FullBodyAnimSlot = AnimNodeSlot(Mesh.FindAnimNode('FullBodySlot'));
		TopHalfAnimSlot = AnimNodeSlot(Mesh.FindAnimNode('TopHalfSlot'));
		LeftHandIK = SkelControlLimb(Mesh.FindSkelControl('LeftHandIK'));
		RightHandIK = SkelControlLimb(Mesh.FindSkelControl('RightHandIK'));
		RootRotControl = SkelControlSingleBone(Mesh.FindSkelControl('RootRot'));
		AimNode = AnimNodeAimOffset(Mesh.FindAnimNode('AimNode'));
		GunRecoilNode = GameSkelCtrl_Recoil(Mesh.FindSkelControl('GunRecoilNode'));
		LeftRecoilNode = GameSkelCtrl_Recoil(Mesh.FindSkelControl('LeftRecoilNode'));
		RightRecoilNode = GameSkelCtrl_Recoil(Mesh.FindSkelControl('RightRecoilNode'));
		DrivingNode = UTAnimBlendByDriving(Mesh.FindAnimNode('DrivingNode'));
		VehicleNode = UTAnimBlendByVehicle(Mesh.FindAnimNode('VehicleNode'));
		HoverboardingNode = UTAnimBlendByHoverboarding(Mesh.FindAnimNode('Hoverboarding'));
		FlyingDirOffset = AnimNodeAimOffset(Mesh.FindAnimNode('FlyingDirOffset'));
	}
	//return;	
}

simulated function SetHandIKEnabled(bool bEnabled)
{
	// End:0x125
	if((((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && Mesh.Animations != none) && LeftHandIK != none) && RightHandIK != none)
	{
		// End:0xD3
		if(bEnabled)
		{
			LeftHandIK.SetSkelControlStrength(1.0000000, 0.0000000);
			RightHandIK.SetSkelControlStrength(1.0000000, 0.0000000);			
		}
		else
		{
			LeftHandIK.SetSkelControlStrength(0.0000000, 0.0000000);
			RightHandIK.SetSkelControlStrength(0.0000000, 0.0000000);
		}
	}
	//return;	
}

simulated function SetAnimRateScale(float RateScale)
{
	Mesh.GlobalAnimRateScale = RateScale;
	//return;	
}

simulated function SetWeapAnimType(UTPawn.EWeapAnimType AnimType)
{
	// End:0x115
	if(AimNode != none)
	{
		switch(AnimType)
		{
			// End:0x52
			case 0:
				AimNode.SetActiveProfileByName('Default');
				// End:0x115
				break;
			// End:0x82
			case 1:
				AimNode.SetActiveProfileByName('SinglePistol');
				// End:0x115
				break;
			// End:0xB2
			case 2:
				AimNode.SetActiveProfileByName('DualPistols');
				// End:0x115
				break;
			// End:0xE2
			case 3:
				AimNode.SetActiveProfileByName('ShoulderRocket');
				// End:0x115
				break;
			// End:0x112
			case 4:
				AimNode.SetActiveProfileByName('Stinger');
				// End:0x115
				break;
			// End:0xFFFF
			default:
				break;
		}
	}
	else
	{
		//return;		
	}
}

simulated function LeaveABloodSplatterDecal(Vector HitLoc, Vector HitNorm)
{
	local Actor TraceActor;
	local Vector out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent;

	local TraceHitInfo HitInfo;
	local MaterialInstanceTimeVarying MITV_Decal;

	TraceStart = HitLoc;
	HitNorm.Z = 0.0000000;
	TraceDest = HitLoc + (HitNorm * float(105));
	TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, false, TraceExtent, HitInfo, 2);
	// End:0x25B
	if((TraceActor != none) && Pawn(TraceActor) == none)
	{
		MITV_Decal = new (Outer) Class'Engine.MaterialInstanceTimeVarying';
		MITV_Decal.SetParent(static.GetFamilyInfo().default.BloodSplatterDecalMaterial);
		WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, out_HitLocation, Rotator(out_HitNormal-), 100.0000000, 100.0000000, 50.0000000, false,, HitInfo.HitComponent, true, false, HitInfo.BoneName, HitInfo.Item, HitInfo.LevelIndex);
		MITV_Decal.SetScalarStartTime(Class'UTGame.UTGib'.default.DecalDissolveParamName, Class'UTGame.UTGib'.default.DecalWaitTimeBeforeDissolve);
	}
	//return;	
}

function PerformEmoteCommand(EmoteInfo EInfo, int PlayerID)
{
	local array<UTPlayerReplicationInfo> PRIs;
	local UTBot Bot;
	local int I;
	local bool bShouldAck;
	local Controller Sender;

	Sender = Controller;
	// End:0x5B
	if((Sender == none) && DrivenVehicle != none)
	{
		Sender = DrivenVehicle.Controller;
	}
	// End:0x455
	if(Sender != none)
	{
		// End:0x2D1
		if(EInfo.bRequiresPlayer || EInfo.CategoryName == 'Order')
		{
			I = 0;
			J0xC1:

			// End:0x2BC [Loop If]
			if(I < WorldInfo.GRI.PRIArray.Length)
			{
				// End:0x2AE
				if((PlayerID == 255) || WorldInfo.GRI.PRIArray[I].PlayerID == PlayerID)
				{
					// End:0x2AE
					if(UTBot(WorldInfo.GRI.PRIArray[I].Owner) != none)
					{
						// End:0x2AE
						if(WorldInfo.GRI.OnSameTeam(WorldInfo.GRI.PRIArray[I], Sender))
						{
							PRIs[PRIs.Length] = UTPlayerReplicationInfo(WorldInfo.GRI.PRIArray[I]);
						}
					}
				}
				I++;
				// [Loop Continue]
				goto J0xC1;
			}
			// End:0x2CE
			if(PRIs.Length == 0)
			{
				return;
			}			
		}
		else
		{
			PRIs[0] = UTPlayerReplicationInfo(PlayerReplicationInfo);
		}
		// End:0x455
		if(EInfo.Command != 'None')
		{
			bShouldAck = true;
			I = 0;
			J0x330:

			// End:0x455 [Loop If]
			if(I < PRIs.Length)
			{
				// End:0x447
				if((PlayerID == 255) || PRIs[I].PlayerID == PlayerID)
				{
					Bot = UTBot(PRIs[I].Owner);
					// End:0x447
					if(Bot != none)
					{
						Bot.SetBotOrders(EInfo.Command, Sender, bShouldAck);
						bShouldAck = false;
						// End:0x447
						if(PlayerID != 255)
						{
							// [Explicit Break]
							goto J0x455;
						}
					}
				}
				I++;
				// [Loop Continue]
				goto J0x330;
			}
		}
	}
	J0x455:

	//return;	
}

simulated function DoPlayEmote(name InEmoteTag, int InPlayerID)
{
	local UTPlayerReplicationInfo UTPRI;
	local Class<UTFamilyInfo> FamilyInfo;
	local int EmoteIndex;
	local EmoteInfo EInfo;

	UTPRI = UTPlayerReplicationInfo(PlayerReplicationInfo);
	// End:0x6D
	if((UTPRI == none) && DrivenVehicle != none)
	{
		UTPRI = UTPlayerReplicationInfo(DrivenVehicle.PlayerReplicationInfo);
	}
	// End:0x2D8
	if(UTPRI != none)
	{
		FamilyInfo = GetFamilyInfo();
		EmoteIndex = FamilyInfo.static.GetEmoteIndex(InEmoteTag);
		// End:0x2D8
		if(EmoteIndex != -1)
		{
			EInfo = FamilyInfo.default.FamilyEmotes[EmoteIndex];
			// End:0x161
			if(int(Role) == int(ROLE_Authority))
			{
				// End:0x161
				if(EInfo.Command != 'None')
				{
					PerformEmoteCommand(EInfo, InPlayerID);
				}
			}
			// End:0x2D8
			if((((Health > 0) && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && UTPRI != none) && IsInState('FeigningDeath')!)
			{
				// End:0x2D8
				if(EInfo.EmoteAnim != 'None')
				{
					// End:0x27B
					if(EInfo.bTopHalfEmote || DrivenVehicle != none)
					{
						// End:0x278
						if(TopHalfAnimSlot != none)
						{
							TopHalfAnimSlot.PlayCustomAnim(EInfo.EmoteAnim, 1.0000000, 0.2000000, 0.2000000, false, true);
						}						
					}
					else
					{
						// End:0x2D8
						if(FullBodyAnimSlot != none)
						{
							FullBodyAnimSlot.PlayCustomAnim(EInfo.EmoteAnim, 1.0000000, 0.2000000, 0.2000000, false, true);
						}
					}
				}
			}
		}
	}
	//return;	
}

reliable server function ServerPlayEmote(name InEmoteTag, int InPlayerID)
{
	EmoteRepInfo.EmoteTag = InEmoteTag;
	EmoteRepInfo.bNewData = EmoteRepInfo.bNewData!;
	DoPlayEmote(InEmoteTag, InPlayerID);
	LastEmoteTime = WorldInfo.TimeSeconds;
	//return;	
}

simulated exec function PlayEmote(name InEmoteTag, int InPlayerID)
{
	// End:0x7B
	if((WorldInfo.TimeSeconds - LastEmoteTime) > MinTimeBetweenEmotes)
	{
		ServerPlayEmote(InEmoteTag, InPlayerID);
		LastEmoteTime = WorldInfo.TimeSeconds;
	}
	//return;	
}

function OnPlayAnim(UTSeqAct_PlayAnim inAction)
{
	// End:0x7D
	if(FullBodyAnimSlot != none)
	{
		FullBodyAnimSlot.PlayCustomAnim(inAction.AnimName, 1.0000000, 0.2000000, 0.2000000, inAction.bLooping, true);
	}
	//return;	
}

function SpawnDefaultController()
{
	local UTGame Game;
	local UTBot Bot;
	local CharacterInfo EmptyBotInfo;

	super(Pawn).SpawnDefaultController();
	Game = UTGame(WorldInfo.Game);
	Bot = UTBot(Controller);
	// End:0xCA
	if((Game != none) && Bot != none)
	{
		Game.InitializeBot(Bot, Game.GetBotTeam(), EmptyBotInfo);
	}
	//return;	
}

simulated function Vector WeaponBob(float BobDamping, float JumpDamping)
{
	local Vector WBob;

	WBob = BobDamping * WalkBob;
	WBob.Z = (0.4500000 + (0.5500000 * BobDamping)) * WalkBob.Z;
	// End:0x8F
	if(bWeaponBob!)
	{
		WBob *= 2.5000000;
	}
	WBob.Z += (JumpDamping * (LandBob - JumpBob));
	return WBob;
	//return ReturnValue;	
}

simulated function TurnOff()
{
	super(Pawn).TurnOff();
	PawnAmbientSound.Stop();
	ClearTimer('FeignDeathDelayTimer');
	//return;	
}

event bool EncroachingOn(Actor Other)
{
	// End:0x50
	if(((Vehicle(Other) != none) && Weapon != none) && Weapon.IsA('UTTranslauncher'))
	{
		return true;
	}
	return super(Pawn).EncroachingOn(Other);
	//return ReturnValue;	
}

event EncroachedBy(Actor Other)
{
	local UTPawn P;

	P = UTPawn(Other);
	// End:0x92
	if((P == none) || P.IsInState('FeigningDeath')! && int(P.Physics) != int(10))
	{
		super(Pawn).EncroachedBy(Other);
	}
	//return;	
}

function gibbedBy(Actor Other)
{
	local Pawn P;

	// End:0x16
	if(int(Role) < int(ROLE_Authority))
	{
		return;
	}
	P = Pawn(Other);
	// End:0x87
	if(P != none)
	{
		Died(Pawn(Other).Controller, Class'UTGame.UTDmgType_Encroached', Location);		
	}
	else
	{
		Died(none, Class'UTGame.UTDmgType_Encroached', Location);
	}
	//return;	
}

function JumpOffPawn()
{
	super(Pawn).JumpOffPawn();
	bNoJumpAdjust = true;
	// End:0x56
	if(UTBot(Controller) != none)
	{
		UTBot(Controller).SetFall();
	}
	//return;	
}

event StuckOnPawn(Pawn OtherPawn)
{
	// End:0x50
	if(UTPawn(OtherPawn) != none)
	{
		TakeDamage(10, none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Crushed');
		ForceRagdoll();
	}
	//return;	
}

event Falling()
{
	// End:0x40
	if(UTBot(Controller) != none)
	{
		UTBot(Controller).SetFall();
	}
	//return;	
}

function AddVelocity(Vector NewVelocity, Vector HitLocation, Class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
	local bool bRagdoll;

	// End:0x159
	if(bIgnoreForces! && IsZero(NewVelocity)!)
	{
		// End:0x83
		if((int(Physics) == int(2)) && UTBot(Controller) != none)
		{
			UTBot(Controller).ImpactVelocity += NewVelocity;
		}
		// End:0x114
		if(((((int(Role) == int(ROLE_Authority)) && int(Physics) == int(1)) && DrivenVehicle == none) && Vehicle(Base) != none) && VSize(Base.Velocity) > GroundSpeed)
		{
			bRagdoll = true;
		}
		super(Pawn).AddVelocity(NewVelocity, HitLocation, DamageType, HitInfo);
		// End:0x159
		if(bRagdoll)
		{
			ForceRagdoll();
		}
	}
	//return;	
}

function bool Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
	// End:0xDA
	if(super(Pawn).Died(Killer, DamageType, HitLocation))
	{
		StartFallImpactTime = WorldInfo.TimeSeconds;
		bCanPlayFallingImpacts = true;
		// End:0x8F
		if(ArmsMesh[0] != none)
		{
			ArmsMesh[0].SetHidden(true);
		}
		// End:0xC2
		if(ArmsMesh[1] != none)
		{
			ArmsMesh[1].SetHidden(true);
		}
		SetPawnAmbientSound(none);
		SetWeaponAmbientSound(none);
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function StartFire(byte FireModeNum)
{
	// End:0x1A
	if(bFeigningDeath)
	{
		FeignDeath();		
	}
	else
	{
		super(Pawn).StartFire(FireModeNum);
	}
	//return;	
}

function bool StopFiring()
{
	return StopWeaponFiring();
	//return ReturnValue;	
}

function bool BotFire(bool bFinished)
{
	local UTWeapon Weap;
	local UTBot Bot;

	Weap = UTWeapon(Weapon);
	// End:0x83
	if((Weap == none) || Weap.ReadyToFire(bFinished)! && Weap.IsFiring()!)
	{
		return false;
	}
	Bot = UTBot(Controller);
	// End:0x104
	if((Bot != none) && int(Bot.ScriptedFireMode) != int(255))
	{
		StartFire(Bot.ScriptedFireMode);		
	}
	else
	{
		StartFire(ChooseFireMode());
	}
	return true;
	//return ReturnValue;	
}

function bool StopWeaponFiring()
{
	local int I;
	local bool bResult;
	local UTWeapon UTWeap;

	UTWeap = UTWeapon(Weapon);
	// End:0xBB
	if(UTWeap != none)
	{
		UTWeap.ClientEndFire(0);
		UTWeap.ClientEndFire(1);
		UTWeap.ServerStopFire(0);
		UTWeap.ServerStopFire(1);
		bResult = true;
	}
	// End:0x18A
	if(InvManager != none)
	{
		I = 0;
		J0xD5:

		// End:0x18A [Loop If]
		if(I < InvManager.GetPendingFireLength(Weapon))
		{
			// End:0x17C
			if(InvManager.IsPendingFire(Weapon, I))
			{
				bResult = true;
				InvManager.ClearPendingFire(Weapon, I);
			}
			I++;
			// [Loop Continue]
			goto J0xD5;
		}
	}
	return bResult;
	//return ReturnValue;	
}

function byte ChooseFireMode()
{
	// End:0x41
	if(UTWeapon(Weapon) != none)
	{
		return UTWeapon(Weapon).BestMode();
	}
	return 0;
	//return ReturnValue;	
}

function bool RecommendLongRangedAttack()
{
	// End:0x41
	if(UTWeapon(Weapon) != none)
	{
		return UTWeapon(Weapon).RecommendLongRangedAttack();
	}
	return false;
	//return ReturnValue;	
}

function float RangedAttackTime()
{
	// End:0x41
	if(UTWeapon(Weapon) != none)
	{
		return UTWeapon(Weapon).RangedAttackTime();
	}
	return 0.0000000;
	//return ReturnValue;	
}

simulated function float GetEyeHeight()
{
	// End:0x1C
	if(IsLocallyControlled()!)
	{
		return BaseEyeHeight;		
	}
	else
	{
		return EyeHeight;
	}
	//return ReturnValue;	
}

function PlayVictoryAnimation()
{
	ServerPlayEmote(TauntNames[Rand(6)], -1);
	//return;	
}

simulated function OnModifyHealth(SeqAct_ModifyHealth Action)
{
	// End:0x58
	if(Action.bHeal)
	{
		GiveHealth(int(Action.Amount), HealthMax);		
	}
	else
	{
		super(Actor).OnModifyHealth(Action);
	}
	//return;	
}

simulated function string GetScreenName()
{
	return PlayerReplicationInfo.PlayerName;
	//return ReturnValue;	
}

simulated event PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
	local float TextXL, XL, YL, Dist;
	local Vector ScreenLoc;
	local LinearColor TeamColor;
	local Color TextColor;
	local string ScreenName;
	local UTWeapon Weap;
	local UTPlayerReplicationInfo PRI;
	local UTHUDBase HUD;

	ScreenLoc = Canvas.Project(Location + ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.0000000)));
	// End:0x11B
	if((((ScreenLoc.X < float(0)) || ScreenLoc.X >= Canvas.ClipX) || ScreenLoc.Y < float(0)) || ScreenLoc.Y >= Canvas.ClipY)
	{
		return;
	}
	PRI = UTPlayerReplicationInfo(PlayerReplicationInfo);
	// End:0x3D7
	if(WorldInfo.GRI.OnSameTeam(self, PC)!)
	{
		// End:0x3D5
		if((WorldInfo.TimeSeconds - LastPostRenderTraceTime) > 0.5000000)
		{
			// End:0x3A2
			if((UTPlayerController(PC).AlreadyInActionMusic()! && VSize(CameraPosition - Location) < VSize(PC.ViewTarget.Location - Location)) && IsInvisible()!)
			{
				// End:0x3A2
				if((Abs(ScreenLoc.X - (0.5000000 * Canvas.ClipX)) < (0.1000000 * Canvas.ClipX)) && Abs(ScreenLoc.Y - (0.5000000 * Canvas.ClipY)) < (0.1000000 * Canvas.ClipY))
				{
					// End:0x3A2
					if(FastTrace(Location, CameraPosition,, true) || FastTrace(Location + ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.0000000)), CameraPosition,, true))
					{
						UTPlayerController(PC).ClientMusicEvent(0);
					}
				}
			}
			LastPostRenderTraceTime = WorldInfo.TimeSeconds + (0.2000000 * FRand());
		}
		return;
	}
	// End:0x49D
	if(UTPawn(PC.Pawn) != none)
	{
		Weap = UTWeapon(UTPawn(PC.Pawn).Weapon);
		// End:0x49A
		if((Weap != none) && Weap.CoversScreenSpace(ScreenLoc, Canvas))
		{
			return;
		}		
	}
	else
	{
		// End:0x520
		if((UTVehicle_Hoverboard(PC.Pawn) != none) && UTVehicle_Hoverboard(PC.Pawn).CoversScreenSpace(ScreenLoc, Canvas))
		{
			return;
		}
	}
	// End:0x5DF
	if((WorldInfo.TimeSeconds - LastPostRenderTraceTime) > 0.5000000)
	{
		LastPostRenderTraceTime = WorldInfo.TimeSeconds + (0.2000000 * FRand());
		bPostRenderTraceSucceeded = FastTrace(Location, CameraPosition) || FastTrace(Location + ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.0000000)), CameraPosition);
	}
	// End:0x5F0
	if(bPostRenderTraceSucceeded!)
	{
		return;
	}
	Class'UTGame.UTHUD'.static.GetTeamColor(int(GetTeamNum()), TeamColor, TextColor);
	Dist = VSize(CameraPosition - Location);
	// End:0x72B
	if(Dist < TeamBeaconPlayerInfoMaxDist)
	{
		ScreenName = GetScreenName();
		Canvas.StrLen(ScreenName, TextXL, YL);
		XL = float(Max(int(TextXL), int(((float(24) * Canvas.ClipX) / float(1024)) * (float(1) + (float(2) * Square((TeamBeaconPlayerInfoMaxDist - Dist) / TeamBeaconPlayerInfoMaxDist))))));		
	}
	else
	{
		XL = ((Canvas.ClipX * float(16)) * TeamBeaconPlayerInfoMaxDist) / (Dist * float(1024));
		YL = 0.0000000;
	}
	Class'UTGame.UTHUD'.static.DrawBackground(ScreenLoc.X - (0.7000000 * XL), ScreenLoc.Y - (1.8000000 * YL), 1.4000000 * XL, 1.9000000 * YL, TeamColor, Canvas);
	// End:0x949
	if((PRI != none) && Dist < TeamBeaconPlayerInfoMaxDist)
	{
		Canvas.DrawColor = TextColor;
		Canvas.SetPos(ScreenLoc.X - (0.5000000 * TextXL), ScreenLoc.Y - (1.2000000 * YL));
		Canvas.DrawText(ScreenName, true,,, Class'UTGame.UTHUD'.default.TextRenderInfo);
	}
	HUD = UTHUDBase(PC.myHUD);
	// End:0xB1C
	if((((HUD != none) && HUD.bCrosshairOnFriendly!) && Abs(ScreenLoc.X - (0.5000000 * Canvas.ClipX)) < (0.1000000 * Canvas.ClipX)) && ScreenLoc.Y <= (0.5000000 * Canvas.ClipY))
	{
		ScreenLoc = Canvas.Project(Location - ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.0000000)));
		// End:0xB1C
		if(ScreenLoc.Y >= (0.5000000 * Canvas.ClipY))
		{
			HUD.bCrosshairOnFriendly = true;
		}
	}
	//return;	
}

simulated function FaceRotation(Rotator NewRotation, float DeltaTime)
{
	// End:0x3F
	if(int(Physics) == int(9))
	{
		NewRotation = OnLadder.WallDir;		
	}
	else
	{
		// End:0x87
		if((int(Physics) == int(1)) || int(Physics) == int(2))
		{
			NewRotation.Pitch = 0;
		}
	}
	NewRotation.Roll = Rotation.Roll;
	SetRotation(NewRotation);
	//return;	
}

event UpdateEyeHeight(float DeltaTime)
{
	local float smooth, MaxEyeHeight, OldEyeHeight, Speed2D, OldBobTime;

	local Actor HitActor;
	local Vector HitLocation, HitNormal, X, Y, Z;

	local int M, N;

	// End:0x2E
	if(bTearOff)
	{
		EyeHeight = default.BaseEyeHeight;
		bUpdateEyeheight = false;
		return;
	}
	// End:0x78
	if(Abs(Location.Z - OldZ) > float(15))
	{
		bJustLanded = false;
		bLandRecovery = false;
	}
	// End:0x1F8
	if(bJustLanded!)
	{
		smooth = FMin(0.9000000, (10.0000000 * DeltaTime) / CustomTimeDilation);
		LandBob *= (float(1) - smooth);
		// End:0x1BC
		if(((int(Physics) == int(1)) || int(Physics) == int(8)) || Controller.IsInState('PlayerSwimming'))
		{
			OldEyeHeight = EyeHeight;
			EyeHeight = FMax((((EyeHeight - Location.Z) + OldZ) * (float(1) - smooth)) + (BaseEyeHeight * smooth), -0.5000000 * CylinderComponent.CollisionHeight);			
		}
		else
		{
			EyeHeight = (EyeHeight * (float(1) - smooth)) + (BaseEyeHeight * smooth);
		}		
	}
	else
	{
		// End:0x32F
		if(bLandRecovery)
		{
			smooth = FMin(0.9000000, 9.0000000 * DeltaTime);
			OldEyeHeight = EyeHeight;
			LandBob *= (float(1) - smooth);
			// End:0x2A3
			if(EyeHeight > (0.9000000 * BaseEyeHeight))
			{
				EyeHeight = EyeHeight + ((0.1500000 * BaseEyeHeight) * smooth);				
			}
			else
			{
				EyeHeight = (EyeHeight * (float(1) - (0.6000000 * smooth))) + ((BaseEyeHeight * 0.6000000) * smooth);
			}
			// End:0x32C
			if(EyeHeight >= BaseEyeHeight)
			{
				bJustLanded = false;
				bLandRecovery = false;
				EyeHeight = BaseEyeHeight;
			}			
		}
		else
		{
			smooth = FMin(0.6500000, 8.0000000 * DeltaTime);
			OldEyeHeight = EyeHeight;
			EyeHeight = EyeHeight * (float(1) - (1.5000000 * smooth));
			LandBob += (0.0800000 * (OldEyeHeight - EyeHeight));
			// End:0x416
			if((EyeHeight < ((0.2500000 * BaseEyeHeight) + float(1))) || LandBob > 2.4000001)
			{
				bLandRecovery = true;
				EyeHeight = (0.2500000 * BaseEyeHeight) + float(1);
			}
		}
	}
	// End:0x45D
	if(bJustLanded || bUpdateEyeheight!)
	{
		BobTime = 0.0000000;
		WalkBob = vect(0.0000000, 0.0000000, 0.0000000);		
	}
	else
	{
		// End:0x4D5
		if(Velocity.Z > float(0))
		{
			JumpBob = FMax(-1.5000000, JumpBob - ((0.0300000 * DeltaTime) * FMin(Velocity.Z, 300.0000000)));			
		}
		else
		{
			JumpBob *= (float(1) - FMin(1.0000000, 8.0000000 * DeltaTime));
		}
		OldBobTime = BobTime;
		Bob = FClamp(Bob, -0.0500000, 0.0500000);
		// End:0x6F8
		if(int(Physics) == int(1))
		{
			GetAxes(Rotation, X, Y, Z);
			Speed2D = VSize(Velocity);
			// End:0x5AD
			if(Speed2D < float(10))
			{
				BobTime += (0.2000000 * DeltaTime);				
			}
			else
			{
				BobTime += (DeltaTime * (0.3000000 + ((0.7000000 * Speed2D) / GroundSpeed)));
			}
			WalkBob = ((Y * Bob) * Speed2D) * Sin(8.0000000 * BobTime);
			AppliedBob = AppliedBob * (float(1) - FMin(1.0000000, 16.0000000 * DeltaTime));
			WalkBob.Z = AppliedBob;
			// End:0x6F5
			if(Speed2D > float(10))
			{
				WalkBob.Z = WalkBob.Z + (((0.7500000 * Bob) * Speed2D) * Sin(16.0000000 * BobTime));
			}			
		}
		else
		{
			// End:0x85B
			if(int(Physics) == int(3))
			{
				GetAxes(Rotation, X, Y, Z);
				BobTime += DeltaTime;
				Speed2D = Sqrt((Velocity.X * Velocity.X) + (Velocity.Y * Velocity.Y));
				WalkBob = (((Y * Bob) * 0.5000000) * Speed2D) * Sin(4.0000000 * BobTime);
				WalkBob.Z = ((Bob * 1.5000000) * Speed2D) * Sin(8.0000000 * BobTime);				
			}
			else
			{
				BobTime = 0.0000000;
				WalkBob = WalkBob * (float(1) - FMin(1.0000000, 8.0000000 * DeltaTime));
			}
		}
		// End:0x97A
		if(((int(Physics) == int(1)) && VSizeSq(Velocity) > float(100)) && IsFirstPerson())
		{
			M = int((0.5000000 * 3.1415927) + ((9.0000000 * OldBobTime) / 3.1415927));
			N = int((0.5000000 * 3.1415927) + ((9.0000000 * BobTime) / 3.1415927));
			// End:0x97A
			if(((M != N) && bIsWalking!) && bIsCrouched!)
			{
				ActuallyPlayFootstepSound(0);
			}
		}
		// End:0x999
		if(bWeaponBob!)
		{
			WalkBob *= 0.1000000;
		}
	}
	// End:0xB15
	if(((CylinderComponent.CollisionHeight - EyeHeight) < float(12)) && IsFirstPerson())
	{
		// End:0xB15
		if(bCollideWorld)
		{
			HitActor = Trace(HitLocation, HitNormal, (Location + WalkBob) + ((MaxStepHeight + CylinderComponent.CollisionHeight) * vect(0.0000000, 0.0000000, 1.0000000)), Location + WalkBob, true, vect(12.0000000, 12.0000000, 12.0000000),, 8);
			MaxEyeHeight = ((HitActor == none) ? CylinderComponent.CollisionHeight + MaxStepHeight : HitLocation.Z - Location.Z);
			EyeHeight = FMin(EyeHeight, MaxEyeHeight);
		}
	}
	//return;	
}

simulated function Vector GetPawnViewLocation()
{
	// End:0x3F
	if(bUpdateEyeheight)
	{
		return (Location + (EyeHeight * vect(0.0000000, 0.0000000, 1.0000000))) + WalkBob;		
	}
	else
	{
		return Location + (BaseEyeHeight * vect(0.0000000, 0.0000000, 1.0000000));
	}
	//return ReturnValue;	
}

simulated event BecomeViewTarget(PlayerController PC)
{
	local UTPlayerController UTPC;
	local UTWeapon UTWeap;

	super(Pawn).BecomeViewTarget(PC);
	// End:0x173
	if(LocalPlayer(PC.Player) != none)
	{
		PawnAmbientSound.bAllowSpatialization = false;
		WeaponAmbientSound.bAllowSpatialization = false;
		bArmsAttached = true;
		AttachComponent(ArmsMesh[0]);
		UTWeap = UTWeapon(Weapon);
		// End:0x105
		if(UTWeap != none)
		{
			// End:0x105
			if(UTWeap.bUsesOffhand)
			{
				AttachComponent(ArmsMesh[1]);
			}
		}
		UTPC = UTPlayerController(PC);
		// End:0x15C
		if(UTPC != none)
		{
			SetMeshVisibility(UTPC.bBehindView);			
		}
		else
		{
			SetMeshVisibility(true);
		}
		bUpdateEyeheight = true;
	}
	//return;	
}

simulated event EndViewTarget(PlayerController PC)
{
	PawnAmbientSound.bAllowSpatialization = true;
	WeaponAmbientSound.bAllowSpatialization = true;
	// End:0xB0
	if(LocalPlayer(PC.Player) != none)
	{
		SetMeshVisibility(true);
		bArmsAttached = false;
		DetachComponent(ArmsMesh[0]);
		DetachComponent(ArmsMesh[1]);
	}
	//return;	
}

simulated function SetWeaponVisibility(bool bWeaponVisible)
{
	local UTWeapon Weap;
	local AnimNodeSequence WeaponAnimNode, ArmAnimNode;
	local int I;

	Weap = UTWeapon(Weapon);
	// End:0x1E2
	if(Weap != none)
	{
		Weap.ChangeVisibility(bWeaponVisible);
		WeaponAnimNode = Weap.GetWeaponAnimNodeSeq();
		// End:0x1E2
		if(WeaponAnimNode != none)
		{
			I = 0;
			J0x97:

			// End:0x1E2 [Loop If]
			if(I < 2)
			{
				// End:0x1D4
				if(ArmsMesh[I].bAttached)
				{
					ArmAnimNode = AnimNodeSequence(ArmsMesh[I].Animations);
					// End:0x1D4
					if(ArmAnimNode != none)
					{
						ArmAnimNode.SetAnim(WeaponAnimNode.AnimSeqName);
						ArmAnimNode.PlayAnim(WeaponAnimNode.bLooping, WeaponAnimNode.Rate, WeaponAnimNode.CurrentTime);
					}
				}
				I++;
				// [Loop Continue]
				goto J0x97;
			}
		}
	}
	//return;	
}

simulated function SetWeaponAttachmentVisibility(bool bAttachmentVisible)
{
	bWeaponAttachmentVisible = bAttachmentVisible;
	// End:0x4D
	if(CurrentWeaponAttachment != none)
	{
		CurrentWeaponAttachment.ChangeVisibility(bAttachmentVisible);
	}
	//return;	
}

simulated function SetMeshVisibility(bool bVisible)
{
	local UTCarriedObject Flag;

	// End:0x3A
	if(Mesh != none)
	{
		Mesh.SetOwnerNoSee(bVisible!);
	}
	SetOverlayVisibility(bVisible);
	SetWeaponVisibility(bVisible!);
	// End:0x90
	foreach BasedActors(Class'UTGame.UTCarriedObject', Flag)
	{
		HoldGameObject(Flag);		
	}	
	//return;	
}

exec function FixedView(string VisibleMeshes)
{
	local bool bVisibleMeshes;
	local float FOV;

	// End:0x12C
	if(int(WorldInfo.NetMode) == int(NM_Standalone))
	{
		// End:0xBF
		if(VisibleMeshes != "")
		{
			bVisibleMeshes = ((VisibleMeshes ComplementEqual "yes") || VisibleMeshes ComplementEqual "true") || VisibleMeshes ComplementEqual "1";
			// End:0xAB
			if(VisibleMeshes ComplementEqual "default")
			{
				bVisibleMeshes = IsFirstPerson()!;
			}
			SetMeshVisibility(bVisibleMeshes);
		}
		// End:0xF8
		if(bFixedView!)
		{
			CalcCamera(0.0000000, FixedViewLoc, FixedViewRot, FOV);
		}
		bFixedView = bFixedView!;
		LogInternal("FixedView:" @ string(bFixedView));
	}
	//return;	
}

function DeactivateSpawnProtection()
{
	// End:0x16
	if(int(Role) < int(ROLE_Authority))
	{
		return;
	}
	// End:0x149
	if(bSpawnDone!)
	{
		bSpawnDone = true;
		// End:0x13A
		if((WorldInfo.TimeSeconds - SpawnTime) < UTGame(WorldInfo.Game).SpawnProtectionTime)
		{
			bSpawnIn = true;
			// End:0xCF
			if(BodyMatColor == SpawnProtectionColor)
			{
				ClearBodyMatColor();
			}
			SpawnTime = (WorldInfo.TimeSeconds - UTGame(WorldInfo.Game).SpawnProtectionTime) - float(1);
		}
		SpawnTime = -100000.0000000;
	}
	//return;	
}

function PlayTeleportEffect(bool bOut, bool bSound)
{
	local int TeamNum, TransCamIndx;
	local UTPlayerController PC;

	// End:0x72
	if((PlayerReplicationInfo != none) && PlayerReplicationInfo.Team != none)
	{
		TeamNum = PlayerReplicationInfo.Team.TeamIndex;
	}
	// End:0x184
	if(bSpawnIn! && (WorldInfo.TimeSeconds - SpawnTime) < UTGame(WorldInfo.Game).SpawnProtectionTime)
	{
		bSpawnIn = true;
		SetBodyMatColor(SpawnProtectionColor, UTGame(WorldInfo.Game).SpawnProtectionTime);
		SpawnTransEffect(TeamNum);
		// End:0x181
		if(bSound)
		{
			PlaySound(SpawnSound);
		}		
	}
	else
	{
		SetBodyMatColor(TranslocateColor[TeamNum], 1.0000000);
		SpawnTransEffect(TeamNum);
		// End:0x1DF
		if(bSound)
		{
			PlaySound(TeleportSound);
		}
	}
	// End:0x322
	if(bOut)
	{
		PC = UTPlayerController(Controller);
		// End:0x322
		if(PC != none)
		{
			// End:0x2D1
			if(((WorldInfo.Game.bTeamGame! || PlayerReplicationInfo == none) || PlayerReplicationInfo.Team == none) || PlayerReplicationInfo.Team.TeamIndex > 1)
			{
				TransCamIndx = 2;				
			}
			else
			{
				TransCamIndx = TeamNum;
			}
			PC.ClientPlayCameraAnim(TransCameraAnim[TransCamIndx], 1.0000000);
		}
	}
	super(Pawn).PlayTeleportEffect(bOut, bSound);
	//return;	
}

function SpawnTransEffect(int TeamNum)
{
	// End:0x58
	if(TransInEffects[0] != none)
	{
		Spawn(TransInEffects[TeamNum], self,, Location + ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 0.7500000)));
	}
	//return;	
}

simulated event StartDriving(Vehicle V)
{
	local UTWeaponPawn WeaponPawn;
	local UTWeapon UTWeap;
	local UDKVehicleBase VBase;

	super(Pawn).StartDriving(V);
	DeactivateSpawnProtection();
	UTWeap = UTWeapon(Weapon);
	// End:0x71
	if(UTWeap != none)
	{
		StopWeaponFiring();
		UTWeap.HolderEnteredVehicle();
	}
	SetWeaponVisibility(false);
	SetWeaponAmbientSound(none);
	SetTeamColor();
	// End:0x1BE
	if(int(Role) == int(ROLE_Authority))
	{
		WeaponPawn = UTWeaponPawn(V);
		// End:0x1BE
		if(((WeaponPawn != none) && WeaponPawn.MyVehicle != none) && WeaponPawn.MySeatIndex != -1)
		{
			DrivenWeaponPawn.BaseVehicle = WeaponPawn.MyVehicle;
			DrivenWeaponPawn.SeatIndex = byte(WeaponPawn.MySeatIndex);
			DrivenWeaponPawn.PRI = PlayerReplicationInfo;
		}
	}
	// End:0x253
	if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && int(WeaponOverlayFlags) > int(0))
	{
		VBase = UDKVehicleBase(V);
		// End:0x253
		if(VBase != none)
		{
			VBase.ApplyWeaponEffects(int(WeaponOverlayFlags));
		}
	}
	// End:0x29F
	if(CurrCharClassInfo != none)
	{
		Mesh.SetScale(CurrCharClassInfo.default.DrivingDrawScale);
	}
	//return;	
}

simulated event StopDriving(Vehicle V)
{
	local DrivenWeaponPawnInfo EmptyWeaponPawnInfo;
	local UDKVehicleBase VBase;

	Mesh.SetLightEnvironment(LightEnvironment);
	Mesh.SetScale(DefaultMeshScale);
	// End:0xAF
	if(((int(Role) < int(ROLE_Authority)) && DrivenWeaponPawn.BaseVehicle != none) && IsLocallyControlled()!)
	{
		DrivenVehicle = ClientSideWeaponPawn;		
	}
	else
	{
		// End:0x143
		if(((int(Role) == int(ROLE_Authority)) && PlayerController(Controller) != none) && UTVehicle(V) != none)
		{
			UTVehicle(V).PlayerStartTime = WorldInfo.TimeSeconds + float(12);
		}
		super(Pawn).StopDriving(V);
		MultiJumpRemaining = 0;
		SetWeaponVisibility(IsFirstPerson());
		bIgnoreForces = ((UTGame(WorldInfo.Game) != none) && UTGame(WorldInfo.Game).bDemoMode) && PlayerController(Controller) != none;
		// End:0x22D
		if(int(Role) == int(ROLE_Authority))
		{
			DrivenWeaponPawn = EmptyWeaponPawnInfo;
		}
	}
	// End:0x2A2
	if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		VBase = UDKVehicleBase(V);
		// End:0x2A2
		if(VBase != none)
		{
			VBase.ApplyWeaponEffects(0);
		}
	}
	//return;	
}

simulated function ClientRestart()
{
	local Rotator AdjustedRotation;

	super(Pawn).ClientRestart();
	// End:0x80
	if(Controller != none)
	{
		AdjustedRotation = Controller.Rotation;
		AdjustedRotation.Roll = 0;
		Controller.SetRotation(AdjustedRotation);
	}
	//return;	
}

function int GetShieldStrength()
{
	return int((ShieldBeltArmor + VestArmor) + ThighpadArmor);
	//return ReturnValue;	
}

function int AbsorbDamage(out int Damage, int CurrentShieldStrength, float AbsorptionRate)
{
	local int MaxAbsorbedDamage;

	MaxAbsorbedDamage = Min(int(float(Damage) * AbsorptionRate), CurrentShieldStrength);
	Damage -= MaxAbsorbedDamage;
	return CurrentShieldStrength - MaxAbsorbedDamage;
	//return ReturnValue;	
}

function int ShieldAbsorb(int Damage)
{
	// End:0x19
	if(Health <= 0)
	{
		return Damage;
	}
	// End:0xC3
	if(ShieldBeltArmor > float(0))
	{
		bShieldAbsorb = true;
		ShieldBeltArmor = float(AbsorbDamage(Damage, int(ShieldBeltArmor), 1.0000000));
		// End:0x81
		if(ShieldBeltArmor == float(0))
		{
			SetOverlayMaterial(none);
		}
		// End:0xC3
		if(Damage == 0)
		{
			SetBodyMatColor(SpawnProtectionColor, 1.0000000);
			PlaySound(ArmorHitSound);
			return 0;
		}
	}
	// End:0x120
	if(VestArmor > float(0))
	{
		bShieldAbsorb = true;
		VestArmor = float(AbsorbDamage(Damage, int(VestArmor), 0.7500000));
		// End:0x120
		if(Damage == 0)
		{
			return 0;
		}
	}
	// End:0x17D
	if(ThighpadArmor > float(0))
	{
		bShieldAbsorb = true;
		ThighpadArmor = float(AbsorbDamage(Damage, int(ThighpadArmor), 0.5000000));
		// End:0x17D
		if(Damage == 0)
		{
			return 0;
		}
	}
	return Damage;
	//return ReturnValue;	
}

function AdjustDamage(out int InDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, Class<DamageType> DamageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
	local int PreDamage;

	// End:0x18
	if(bIsInvulnerable)
	{
		InDamage = 0;
	}
	// End:0x85
	if(UTWeapon(Weapon) != none)
	{
		UTWeapon(Weapon).AdjustPlayerDamage(InDamage, InstigatedBy, HitLocation, Momentum, DamageType);
	}
	// End:0x158
	if(DamageType.default.bArmorStops && InDamage > 0)
	{
		PreDamage = InDamage;
		InDamage = ShieldAbsorb(InDamage);
		// End:0x158
		if((InDamage == 0) && Controller != none)
		{
			Controller.NotifyTakeHit(InstigatedBy, HitLocation, Min(PreDamage, 10), DamageType, Momentum);
		}
	}
	//return;	
}

function DropFlag()
{
	local UTPlayerReplicationInfo UTPRI;

	UTPRI = UTPlayerReplicationInfo(PlayerReplicationInfo);
	// End:0x53
	if((UTPRI == none) || UTPRI.bHasFlag!)
	{
		return;
	}
	UTPRI.GetFlag().Drop();
	bJustDroppedOrb = true;
	//return;	
}

function EnableInventoryPickup()
{
	bCanPickupInventory = true;
	//return;	
}

simulated event HoldGameObject(UDKCarriedObject GameObj)
{
	local UTCarriedObject UTGameObj;

	UTGameObj = UTCarriedObject(GameObj);
	UTGameObj.SetHardAttach(UTGameObj.default.bHardAttach);
	UTGameObj.bIgnoreBaseRotation = UTGameObj.default.bIgnoreBaseRotation;
	// End:0x1C4
	if(Class'Engine.Engine'.static.IsSplitScreen())
	{
		// End:0x12B
		if(UTGameObj.GameObjBone3P != 'None')
		{
			UTGameObj.SetBase(self,, Mesh, UTGameObj.GameObjBone3P);			
		}
		else
		{
			UTGameObj.SetBase(self);
		}
		UTGameObj.SetRelativeRotation(UTGameObj.GameObjRot3P);
		UTGameObj.SetRelativeLocation(UTGameObj.GameObjOffset3P);		
	}
	else
	{
		// End:0x26A
		if(IsFirstPerson())
		{
			UTGameObj.SetBase(self);
			UTGameObj.SetRelativeRotation(UTGameObj.GameObjRot1P);
			UTGameObj.SetRelativeLocation(UTGameObj.GameObjOffset1P);			
		}
		else
		{
			// End:0x2DA
			if(UTGameObj.GameObjBone3P != 'None')
			{
				UTGameObj.SetBase(self,, Mesh, UTGameObj.GameObjBone3P);				
			}
			else
			{
				UTGameObj.SetBase(self);
			}
			UTGameObj.SetRelativeRotation(UTGameObj.GameObjRot3P);
			UTGameObj.SetRelativeLocation(UTGameObj.GameObjOffset3P);
		}
	}
	//return;	
}

function bool GiveHealth(int HealAmount, int HealMax)
{
	// End:0x42
	if(Health < HealMax)
	{
		Health = Min(HealMax, Health + HealAmount);
		return true;
	}
	return false;
	//return ReturnValue;	
}

function string GetDebugName()
{
	// End:0x12
	if(PlayerReplicationInfo != none)
	{
		return "";
	}
	return GetItemName(string(self));
	//return ReturnValue;	
}

simulated event PlayFootStepSound(int FootDown)
{
	local PlayerController PC;

	// End:0xBA
	if(IsFirstPerson()!)
	{
		// End:0xB9
		foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
		{
			// End:0xB8
			if((PC.ViewTarget != none) && VSizeSq(PC.ViewTarget.Location - Location) < MaxFootstepDistSq)
			{
				ActuallyPlayFootstepSound(FootDown);				
				return;
			}			
		}		
	}
	//return;	
}

simulated function ActuallyPlayFootstepSound(int FootDown)
{
	local SoundCue FootSound;

	FootSound = SoundGroupClass.static.GetFootstepSound(FootDown, GetMaterialBelowFeet());
	// End:0x64
	if(FootSound != none)
	{
		PlaySound(FootSound, false, true,,, true);
	}
	//return;	
}

simulated function name GetMaterialBelowFeet()
{
	local Vector HitLocation, HitNormal;
	local TraceHitInfo HitInfo;
	local UTPhysicalMaterialProperty PhysicalProperty;
	local Actor HitActor;
	local float TraceDist;

	TraceDist = 1.5000000 * (GetCollisionHeight());
	HitActor = Trace(HitLocation, HitNormal, Location - (TraceDist * vect(0.0000000, 0.0000000, 1.0000000)), Location, false,, HitInfo, 2);
	// End:0xEF
	if(WaterVolume(HitActor) != none)
	{
		return (((Location.Z - HitLocation.Z) < (0.3300000 * TraceDist)) ? 'Water' : 'ShallowWater');
	}
	// End:0x18D
	if(HitInfo.PhysMaterial != none)
	{
		PhysicalProperty = UTPhysicalMaterialProperty(HitInfo.PhysMaterial.GetPhysicalMaterialProperty(Class'UTGame.UTPhysicalMaterialProperty'));
		// End:0x18D
		if(PhysicalProperty != none)
		{
			return PhysicalProperty.MaterialType;
		}
	}
	return 'None';
	//return ReturnValue;	
}

function PlayLandingSound()
{
	local PlayerController PC;

	// End:0xD0
	foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		// End:0xCF
		if((PC.ViewTarget != none) && VSizeSq(PC.ViewTarget.Location - Location) < MaxJumpSoundDistSq)
		{
			PlaySound(SoundGroupClass.static.GetLandSound(GetMaterialBelowFeet()));			
			return;
		}		
	}	
	//return;	
}

function PlayJumpingSound()
{
	local PlayerController PC;

	// End:0xD0
	foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		// End:0xCF
		if((PC.ViewTarget != none) && VSizeSq(PC.ViewTarget.Location - Location) < MaxJumpSoundDistSq)
		{
			PlaySound(SoundGroupClass.static.GetJumpSound(GetMaterialBelowFeet()));			
			return;
		}		
	}	
	//return;	
}

simulated function bool ShouldGib(Class<UTDamageType> UTDamageType)
{
	return (Mesh != none) && bTearOffGibs || UTDamageType.static.ShouldGib(self);
	//return ReturnValue;	
}

simulated function SpawnHeadGib(Class<UTDamageType> UTDamageType, Vector HitLocation)
{
	local UTGib Gib;
	local UTPlayerController PC;
	local Class<UDKEmitCameraEffect> CameraEffect;
	local Vector ViewLocation;
	local Rotator ViewRotation;
	local PlayerReplicationInfo OldRealViewTarget;
	local Class<UTFamilyInfo> FamilyInfo;

	// End:0x39
	if(Class'UTGame.UTGame'.static.UseLowGore(WorldInfo))
	{
		bHeadGibbed = true;
		return;
	}
	// End:0x45B
	if(bHeadGibbed!)
	{
		// End:0x7F
		if(HitLocation == Location)
		{
			HitLocation = Location + Vector(Rotation);
		}
		FamilyInfo = CurrCharClassInfo;
		Gib = SpawnGib(CurrCharClassInfo.default.HeadGib.GibClass, FamilyInfo.default.HeadGib.BoneName, UTDamageType, HitLocation, false);
		// End:0x45B
		if(Gib != none)
		{
			Gib.SetRotation(Rotation);
			Gib.SetTexturesToBeResident(Gib.LifeSpan);
			SetHeadScale(0.0000000);
			WorldInfo.MyEmitterPool.SpawnEmitter(FamilyInfo.default.HeadShotEffect, Gib.Location, Rotator(vect(0.0000000, 0.0000000, 1.0000000)), Gib);
			// End:0x44E
			foreach LocalPlayerControllers(Class'UTGame.UTPlayerController', PC)
			{
				// End:0x44D
				if(PC.ViewTarget == self)
				{
					OldRealViewTarget = PC.RealViewTarget;
					// End:0x389
					if(UTDamageType.default.bHeadGibCamera && PC.UsingFirstPersonCamera() || PC.IsInState('BaseSpectating')!)
					{
						PC.SetViewTarget(Gib);
						CameraEffect = UTDamageType.static.GetDeathCameraEffectVictim(self);
						// End:0x386
						if(CameraEffect != none)
						{
							PC.ClientSpawnCameraEffect(CameraEffect);
						}						
					}
					else
					{
						PC.GetPlayerViewPoint(ViewLocation, ViewRotation);
						PC.SetViewTarget(PC);
						PC.SetLocation(ViewLocation);
						PC.SetRotation(ViewRotation);
					}
					PC.RealViewTarget = OldRealViewTarget;
				}				
			}			
			bHeadGibbed = true;
		}
	}
	//return;	
}

simulated function UTGib SpawnGib(Class<UTGib> GibClass, name BoneName, Class<UTDamageType> UTDamageType, Vector HitLocation, bool bSpinGib)
{
	local UTGib Gib;
	local Rotator SpawnRot;
	local int SavedPitch;
	local float GibPerterbation;
	local Rotator VelRotation;
	local Vector X, Y, Z;

	SpawnRot = QuatToRotator(Mesh.GetBoneQuaternion(BoneName));
	SavedPitch = SpawnRot.Pitch;
	SpawnRot.Pitch = SpawnRot.Yaw;
	SpawnRot.Yaw = SavedPitch;
	Gib = Spawn(GibClass, self,, Mesh.GetBoneLocation(BoneName), SpawnRot);
	// End:0x51B
	if(Gib != none)
	{
		GibPerterbation = UTDamageType.default.GibPerterbation * 32768.0000000;
		VelRotation = Rotator(Gib.Location - HitLocation);
		VelRotation.Pitch += int(((FRand() * 2.0000000) * GibPerterbation) - GibPerterbation);
		VelRotation.Yaw += int(((FRand() * 2.0000000) * GibPerterbation) - GibPerterbation);
		VelRotation.Roll += int(((FRand() * 2.0000000) * GibPerterbation) - GibPerterbation);
		GetAxes(VelRotation, X, Y, Z);
		// End:0x39B
		if(Gib.bUseUnrealPhysics)
		{
			Gib.Velocity = Velocity + (Z * ((FRand() * 400.0000000) + 400.0000000));
			Gib.SetPhysics(2);
			Gib.RotationRate.Yaw = Rand(100000);
			Gib.RotationRate.Pitch = Rand(100000);
			Gib.RotationRate.Roll = Rand(100000);			
		}
		else
		{
			Gib.Velocity = Velocity + (Z * (FRand() * 50.0000000));
			Gib.GibMeshComp.WakeRigidBody();
			Gib.GibMeshComp.SetRBLinearVelocity(Gib.Velocity, false);
			// End:0x4AB
			if(bSpinGib)
			{
				Gib.GibMeshComp.SetRBAngularVelocity(VRand() * float(50), false);
			}
		}
		UTDamageType.static.SpawnGibEffects(Gib);
		Gib.LifeSpan = Gib.LifeSpan + (2.0000000 * FRand());
	}
	return Gib;
	//return ReturnValue;	
}

simulated function SpawnGibs(Class<UTDamageType> UTDamageType, Vector HitLocation)
{
	local int I;
	local bool bSpawnHighDetail;
	local GibInfo MyGibInfo;

	bTearOffGibs = true;
	// End:0x421
	if(bGibbed!)
	{
		// End:0x52
		if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
		{
			bGibbed = true;
			return;
		}
		// End:0xA5
		if((WorldInfo.TimeSeconds - DeathTime) < 0.3500000)
		{
			SoundGroupClass.static.PlayGibSound(self);
		}
		SoundGroupClass.static.PlayBodyExplosion(self);
		SpawnHeadGib(UTDamageType, HitLocation);
		// End:0x110
		if(HeadshotNeckAttachment != none)
		{
			HeadshotNeckAttachment.SetHidden(true);
		}
		// End:0x31A
		if((static.GetFamilyInfo().default.GibExplosionTemplate != none) && EffectIsRelevant(Location, false, 7000.0000000))
		{
			WorldInfo.MyEmitterPool.SpawnEmitter(static.GetFamilyInfo().default.GibExplosionTemplate, Location, Rotation);
			bSpawnHighDetail = WorldInfo.bDropDetail! && (WorldInfo.TimeSeconds - LastRenderTime) < float(1);
			I = 0;
			J0x227:

			// End:0x31A [Loop If]
			if(I < CurrCharClassInfo.default.Gibs.Length)
			{
				MyGibInfo = CurrCharClassInfo.default.Gibs[I];
				// End:0x30C
				if(bSpawnHighDetail || MyGibInfo.bHighDetailOnly!)
				{
					SpawnGib(MyGibInfo.GibClass, MyGibInfo.BoneName, UTDamageType, HitLocation, true);
				}
				I++;
				// [Loop Continue]
				goto J0x227;
			}
		}
		// End:0x40B
		if(((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && WorldInfo.IsRecordingDemo()!) && (int(WorldInfo.NetMode) != int(NM_ListenServer)) || (WorldInfo.Game.NumPlayers + WorldInfo.Game.NumSpectators) < 2)
		{
			Destroy();			
		}
		else
		{
			TurnOffPawn();
		}
		bGibbed = true;
	}
	//return;	
}

simulated function TurnOffPawn()
{
	// End:0x5E
	if(int(Physics) == int(10))
	{
		Mesh.SetHasPhysicsAssetInstance(false);
		Mesh.PhysicsWeight = 0.0000000;
		SetPhysics(0);
	}
	// End:0x7E
	if(IsInState('Dying')!)
	{
		GotoState('Dying');
	}
	SetPhysics(0);
	SetCollision(false, false);
	Mesh.SetHidden(true);
	// End:0xD8
	if(OverlayMesh != none)
	{
		OverlayMesh.SetHidden(true);
	}
	//return;	
}

simulated function PlayDying(Class<DamageType> DamageType, Vector HitLoc, optional Controller Killer)
{
	local Vector ApplyImpulse, ShotDir;
	local TraceHitInfo HitInfo;
	local PlayerController PC;
	local bool bPlayersRagdoll, bUseHipSpring;
	local Class<UTDamageType> UTDamageType;
	local RB_BodyInstance HipBodyInst;
	local int HipBoneIndex;
	local Matrix HipMatrix;
	local Class<UDKEmitCameraEffect> CameraEffect;
	local name HeadShotSocketName;
	local SkeletalMeshSocket SMS;

	bCanTeleport = false;
	bReplicateMovement = false;
	bTearOff = true;
	bPlayedDeath = true;
	bForcedFeignDeath = false;
	bPlayingFeignDeathRecovery = false;
	HitDamageType = DamageType;
	TakeHitLocation = HitLoc;
	CurrentWeaponAttachmentClass = none;
	WeaponAttachmentChanged();
	// End:0x12C
	if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
	{
		UTDamageType = Class<UTDamageType>(DamageType);
		bTearOffGibs = (UTDamageType != none) && ShouldGib(UTDamageType);
		bGibbed = bGibbed || bTearOffGibs;
		GotoState('Dying');
		return;
	}
	// End:0x1FD
	foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		// End:0x1FC
		if(PC.ViewTarget == self)
		{
			// End:0x1ED
			if(UTHUD(PC.myHUD) != none)
			{
				UTHUD(PC.myHUD).DisplayHit(HitLoc, 100, DamageType);
			}
			bPlayersRagdoll = true;
			// End:0x1FD
			break;
		}		
	}	
	// End:0x3A3
	if(((WorldInfo.TimeSeconds - LastRenderTime) > float(3)) && bPlayersRagdoll!)
	{
		// End:0x39E
		if((int(WorldInfo.NetMode) == int(NM_ListenServer)) || WorldInfo.IsRecordingDemo())
		{
			// End:0x328
			if(((WorldInfo.Game.NumPlayers + WorldInfo.Game.NumSpectators) < 2) && WorldInfo.IsRecordingDemo()!)
			{
				Destroy();
				return;
			}
			bHideOnListenServer = true;
			UTDamageType = Class<UTDamageType>(DamageType);
			// End:0x38F
			if((UTDamageType != none) && ShouldGib(UTDamageType))
			{
				bTearOffGibs = true;
				bGibbed = true;
			}
			TurnOffPawn();
			return;			
		}
		else
		{
			Destroy();
			return;
		}
	}
	UTDamageType = Class<UTDamageType>(DamageType);
	// End:0x434
	if(((UTDamageType != none) && Class'UTGame.UTGame'.static.UseLowGore(WorldInfo)!) && ShouldGib(UTDamageType))
	{
		SpawnGibs(UTDamageType, HitLoc);		
	}
	else
	{
		CheckHitInfo(HitInfo, Mesh, Normal(TearOffMomentum), TakeHitLocation);
		// End:0x552
		if(UTDamageType != none)
		{
			// End:0x4D0
			if(UTDamageType.default.bUseDamageBasedDeathEffects)
			{
				UTDamageType.static.DoCustomDamageEffects(self, UTDamageType, HitInfo, TakeHitLocation);
			}
			// End:0x552
			if(UTPlayerController(PC) != none)
			{
				CameraEffect = UTDamageType.static.GetDeathCameraEffectVictim(self);
				// End:0x552
				if(CameraEffect != none)
				{
					UTPlayerController(PC).ClientSpawnCameraEffect(CameraEffect);
				}
			}
		}
		bBlendOutTakeHitPhysics = false;
		SetHandIKEnabled(false);
		// End:0x582
		if(int(Physics) == int(10))
		{
			SetPhysics(2);
		}
		PreRagdollCollisionComponent = CollisionComponent;
		CollisionComponent = Mesh;
		Mesh.MinDistFactorForKinematicUpdate = 0.0000000;
		// End:0x62E
		if(Mesh.bNotUpdatingKinematicDueToDistance)
		{
			Mesh.ForceSkelUpdate();
			Mesh.UpdateRBBonesFromSpaceBases(true, true);
		}
		Mesh.PhysicsWeight = 1.0000000;
		// End:0xA66
		if(((UTDamageType != none) && UTDamageType.default.DeathAnim != 'None') && FRand() > 0.5000000)
		{
			// End:0x6E9
			if((int(Physics) == int(1)) && UTDamageType.default.bAnimateHipsForDeathAnim)
			{
				SetPhysics(0);
				bUseHipSpring = true;				
			}
			else
			{
				SetPhysics(10);
				SetPawnRBChannels(true);
			}
			Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
			Mesh.bUpdateJointsFromAnimation = true;
			Mesh.PhysicsAssetInstance.SetNamedMotorsAngularPositionDrive(false, false, NoDriveBodies, Mesh, true);
			Mesh.PhysicsAssetInstance.SetAngularDriveScale(1.0000000, 1.0000000, 0.0000000);
			// End:0x984
			if(bUseHipSpring)
			{
				HipBodyInst = Mesh.PhysicsAssetInstance.FindBodyInstance(HipsBone, Mesh.PhysicsAsset);
				HipBoneIndex = Mesh.MatchRefBone(HipsBone);
				HipMatrix = Mesh.GetBoneMatrix(HipBoneIndex);
				HipBodyInst.SetBoneSpringParams(DeathHipLinSpring, DeathHipLinDamp, DeathHipAngSpring, DeathHipAngDamp);
				HipBodyInst.bMakeSpringToBaseCollisionComponent = false;
				HipBodyInst.EnableBoneSpring(true, true, HipMatrix);
				HipBodyInst.bDisableOnOverextension = true;
				HipBodyInst.OverextensionThreshold = 100.0000000;
			}
			FullBodyAnimSlot.PlayCustomAnim(UTDamageType.default.DeathAnim, UTDamageType.default.DeathAnimRate, 0.0500000, -1.0000000, false, false);
			SetTimer(0.1000000, true, 'DoingDeathAnim');
			StartDeathAnimTime = WorldInfo.TimeSeconds;
			TimeLastTookDeathAnimDamage = WorldInfo.TimeSeconds;
			DeathAnimDamageType = UTDamageType;			
		}
		else
		{
			SetPhysics(10);
			Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
			SetPawnRBChannels(true);
			// End:0xBBC
			if(TearOffMomentum != vect(0.0000000, 0.0000000, 0.0000000))
			{
				ShotDir = Normal(TearOffMomentum);
				ApplyImpulse = ShotDir * DamageType.default.KDamageImpulse;
				// End:0xB6E
				if(Velocity.Z > float(-10))
				{
					ApplyImpulse += (vect(0.0000000, 0.0000000, 1.0000000) * DamageType.default.KDeathUpKick);
				}
				Mesh.AddImpulse(ApplyImpulse, TakeHitLocation, HitInfo.BoneName, true);
			}
		}
		GotoState('Dying');
		// End:0xDDE
		if((((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && UTDamageType != none) && UTDamageType.default.bSeversHead) && bDeleteMe!)
		{
			SpawnHeadGib(UTDamageType, HitLoc);
			// End:0xDDE
			if(Class'UTGame.UTGame'.static.UseLowGore(WorldInfo)!)
			{
				HeadShotSocketName = static.GetFamilyInfo().default.HeadShotGoreSocketName;
				SMS = Mesh.GetSocketByName(HeadShotSocketName);
				// End:0xDDE
				if(SMS != none)
				{
					HeadshotNeckAttachment = new (self) Class'Engine.StaticMeshComponent';
					HeadshotNeckAttachment.SetActorCollision(false, false);
					HeadshotNeckAttachment.SetBlockRigidBody(false);
					Mesh.AttachComponentToSocket(HeadshotNeckAttachment, HeadShotSocketName);
					HeadshotNeckAttachment.SetStaticMesh(static.GetFamilyInfo().default.HeadShotNeckGoreAttachment);
					HeadshotNeckAttachment.SetLightEnvironment(LightEnvironment);
				}
			}
		}
	}
	//return;	
}

simulated function DoingDeathAnim()
{
	local RB_BodyInstance HipBodyInst;
	local Matrix DummyMatrix;
	local AnimNodeSequence SlotSeqNode;
	local float TimeSinceDeathAnimStart, MotorScale;
	local bool bStopAnim;

	// End:0x102
	if(DeathAnimDamageType.default.MotorDecayTime != 0.0000000)
	{
		TimeSinceDeathAnimStart = WorldInfo.TimeSeconds - StartDeathAnimTime;
		MotorScale = 1.0000000 - (TimeSinceDeathAnimStart / DeathAnimDamageType.default.MotorDecayTime);
		// End:0xB7
		if(MotorScale <= 0.0000000)
		{
			bStopAnim = true;			
		}
		else
		{
			Mesh.PhysicsAssetInstance.SetAngularDriveScale(MotorScale, MotorScale, 0.0000000);
		}
	}
	// End:0x195
	if(((DeathAnimDamageType != none) && DeathAnimDamageType.default.StopAnimAfterDamageInterval != 0.0000000) && (WorldInfo.TimeSeconds - TimeLastTookDeathAnimDamage) > DeathAnimDamageType.default.StopAnimAfterDamageInterval)
	{
		bStopAnim = true;
	}
	SlotSeqNode = AnimNodeSequence(FullBodyAnimSlot.Children[1].Anim);
	// End:0x304
	if(SlotSeqNode.bPlaying! || bStopAnim)
	{
		SetPhysics(10);
		Mesh.PhysicsAssetInstance.SetAllMotorsAngularPositionDrive(false, false);
		HipBodyInst = Mesh.PhysicsAssetInstance.FindBodyInstance(HipsBone, Mesh.PhysicsAsset);
		HipBodyInst.EnableBoneSpring(false, false, DummyMatrix);
		SetPawnRBChannels(true);
		ClearTimer('DoingDeathAnim');
		DeathAnimDamageType = none;
	}
	//return;	
}

simulated event Destroyed()
{
	local PlayerController PC;
	local Actor A;

	super(Pawn).Destroyed();
	// End:0x42
	foreach BasedActors(Class'Engine.Actor', A)
	{
		A.PawnBaseDied();		
	}	
	// End:0xBC
	foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		// End:0xBB
		if(PC.myHUD != none)
		{
			PC.myHUD.RemovePostRenderedActor(self);
		}		
	}	
	// End:0x10C
	if(CurrentWeaponAttachment != none)
	{
		CurrentWeaponAttachment.DetachFrom(Mesh);
		CurrentWeaponAttachment.Destroy();
	}
	//return;	
}

function AddDefaultInventory()
{
	// End:0x2F
	if(Controller != none)
	{
		Controller.ClientSwitchToBestWeapon();
	}
	//return;	
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
	// End:0x36
	if(bFixedView)
	{
		out_CamLoc = FixedViewLoc;
		out_CamRot = FixedViewRot;		
	}
	else
	{
		// End:0x76
		if(IsFirstPerson()!)
		{
			CalcThirdPersonCam(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);			
		}
		else
		{
			GetActorEyesViewPoint(out_CamLoc, out_CamRot);
		}
		// End:0xED
		if(UTWeapon(Weapon) != none)
		{
			UTWeapon(Weapon).WeaponCalcCamera(fDeltaTime, out_CamLoc, out_CamRot);
		}
	}
	return true;
	//return ReturnValue;	
}

simulated function SetThirdPersonCamera(bool bNewBehindView)
{
	// End:0x63
	if(bNewBehindView)
	{
		CurrentCameraScale = 1.0000000;
		CameraZOffset = (GetCollisionHeight()) + Mesh.Translation.Z;
	}
	SetMeshVisibility(bNewBehindView);
	//return;	
}

simulated function FindGoodEndView(PlayerController InPC, out Rotator GoodRotation)
{
	local Rotator ViewRotation;
	local int tries;
	local float bestDist, newdist;
	local UTPlayerController PC;

	PC = UTPlayerController(InPC);
	bWinnerCam = true;
	SetHeroCam(GoodRotation);
	GoodRotation.Pitch = HeroCameraPitch;
	ViewRotation = GoodRotation;
	ViewRotation.Yaw = (Rotation.Yaw + 32768) + 8192;
	// End:0xF8
	if(TryNewCamRot(PC, ViewRotation, newdist))
	{
		GoodRotation = ViewRotation;
		return;
	}
	ViewRotation = GoodRotation;
	ViewRotation.Yaw = (Rotation.Yaw + 32768) - 8192;
	// End:0x18F
	if(TryNewCamRot(PC, ViewRotation, newdist))
	{
		GoodRotation = ViewRotation;
		return;
	}
	ViewRotation.Pitch = 56000;
	tries = 0;
	bestDist = 0.0000000;
	CameraScale = default.CameraScale;
	CurrentCameraScale = default.CameraScale;
	tries = 0;
	J0x1FC:

	// End:0x2B7 [Loop If]
	if(tries < 16)
	{
		// End:0x249
		if(TryNewCamRot(PC, ViewRotation, newdist))
		{
			GoodRotation = ViewRotation;
			return;
		}
		// End:0x286
		if(newdist > bestDist)
		{
			bestDist = newdist;
			GoodRotation = ViewRotation;
		}
		ViewRotation.Yaw += 4096;
		tries++;
		// [Loop Continue]
		goto J0x1FC;
	}
	//return;	
}

simulated function bool TryNewCamRot(UTPlayerController PC, Rotator ViewRotation, out float CamDist)
{
	local Vector CameraLoc;
	local Rotator CameraRot;
	local float FOVAngle;

	CameraLoc = Location;
	CameraRot = ViewRotation;
	// End:0x8F
	if(CalcThirdPersonCam(0.0000000, CameraLoc, CameraRot, FOVAngle))
	{
		CamDist = VSize((CameraLoc - Location) - (vect(0.0000000, 0.0000000, 1.0000000) * CameraZOffset));
		return true;
	}
	CamDist = VSize((CameraLoc - Location) - (vect(0.0000000, 0.0000000, 1.0000000) * CameraZOffset));
	return false;
	//return ReturnValue;	
}

simulated function SetHeroCam(out Rotator out_CamRot)
{
	CameraZOffset = 0.0000000;
	CameraScale = HeroCameraScale;
	CurrentCameraScale = HeroCameraScale;
	//return;	
}

simulated function bool CalcThirdPersonCam(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
	local Vector CamStart, HitLocation, HitNormal, CamDirX, CamDirY, CamDirZ,
		CurrentCamOffset;

	local float DesiredCameraZOffset;

	ModifyRotForDebugFreeCam(out_CamRot);
	CamStart = Location;
	CurrentCamOffset = CamOffset;
	// End:0x9A
	if(bWinnerCam)
	{
		SetHeroCam(out_CamRot);
		CurrentCamOffset = vect(0.0000000, 0.0000000, 0.0000000);
		CurrentCamOffset.X = GetCollisionRadius();		
	}
	else
	{
		DesiredCameraZOffset = ((Health > 0) ? (1.2000000 * (GetCollisionHeight())) + Mesh.Translation.Z : 0.0000000);
		CameraZOffset = ((fDeltaTime < 0.2000000) ? ((DesiredCameraZOffset * float(5)) * fDeltaTime) + ((float(1) - (float(5) * fDeltaTime)) * CameraZOffset) : DesiredCameraZOffset);
		// End:0x1AE
		if(Health <= 0)
		{
			CurrentCamOffset = vect(0.0000000, 0.0000000, 0.0000000);
			CurrentCamOffset.X = GetCollisionRadius();
		}
	}
	CamStart.Z += CameraZOffset;
	GetAxes(out_CamRot, CamDirX, CamDirY, CamDirZ);
	CamDirX *= CurrentCameraScale;
	// End:0x24A
	if((Health <= 0) || bFeigningDeath)
	{
		FindSpot(GetCollisionExtent(), CamStart);
	}
	// End:0x2B0
	if(CurrentCameraScale < CameraScale)
	{
		CurrentCameraScale = FMin(CameraScale, CurrentCameraScale + ((float(5) * FMax(CameraScale - CurrentCameraScale, 0.3000000)) * fDeltaTime));		
	}
	else
	{
		// End:0x313
		if(CurrentCameraScale > CameraScale)
		{
			CurrentCameraScale = FMax(CameraScale, CurrentCameraScale - ((float(5) * FMax(CameraScale - CurrentCameraScale, 0.3000000)) * fDeltaTime));
		}
	}
	// End:0x372
	if(CamDirX.Z > (GetCollisionHeight()))
	{
		CamDirX *= Square(Cos(float(out_CamRot.Pitch) * 0.0000959));
	}
	out_CamLoc = ((CamStart - (CamDirX * CurrentCamOffset.X)) + (CurrentCamOffset.Y * CamDirY)) + (CurrentCamOffset.Z * CamDirZ);
	// End:0x452
	if(Trace(HitLocation, HitNormal, out_CamLoc, CamStart, false, vect(12.0000000, 12.0000000, 12.0000000)) != none)
	{
		out_CamLoc = HitLocation;
		return false;
	}
	return true;
	//return ReturnValue;	
}

simulated function Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
	return GetPawnViewLocation();
	//return ReturnValue;	
}

function bool Dodge(Actor.EDoubleClickDir DoubleClickMove)
{
	local Vector X, Y, Z, TraceStart, TraceEnd, Dir,
		Cross, HitLocation, HitNormal;

	local Actor HitActor;
	local Rotator TurnRot;

	// End:0x4A
	if((bIsCrouched || bWantsToCrouch) || (int(Physics) != int(1)) && int(Physics) != int(2))
	{
		return false;
	}
	TurnRot.Yaw = Rotation.Yaw;
	GetAxes(TurnRot, X, Y, Z);
	// End:0x2FC
	if(int(Physics) == int(2))
	{
		// End:0xE9
		if(int(DoubleClickMove) == int(3))
		{
			TraceEnd = X-;			
		}
		else
		{
			// End:0x113
			if(int(DoubleClickMove) == int(4))
			{
				TraceEnd = X;				
			}
			else
			{
				// End:0x13D
				if(int(DoubleClickMove) == int(1))
				{
					TraceEnd = Y;					
				}
				else
				{
					// End:0x166
					if(int(DoubleClickMove) == int(2))
					{
						TraceEnd = Y-;
					}
				}
			}
		}
		TraceStart = (Location - ((CylinderComponent.CollisionHeight - float(16)) * vect(0.0000000, 0.0000000, 1.0000000))) + (TraceEnd * (CylinderComponent.CollisionRadius - float(16)));
		TraceEnd = TraceStart + (TraceEnd * 40.0000000);
		HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, false, vect(16.0000000, 16.0000000, 16.0000000));
		// End:0x27E
		if((HitActor == none) || HitNormal.Z < -0.1000000)
		{
			return false;
		}
		// End:0x2FC
		if(HitActor.bWorldGeometry!)
		{
			// End:0x2C8
			if(HitActor.bBlockActors!)
			{
				return false;
			}
			// End:0x2FC
			if((Pawn(HitActor) != none) && Vehicle(HitActor) == none)
			{
				return false;
			}
		}
	}
	// End:0x339
	if(int(DoubleClickMove) == int(3))
	{
		Dir = X;
		Cross = Y;		
	}
	else
	{
		// End:0x37F
		if(int(DoubleClickMove) == int(4))
		{
			Dir = float(-1) * X;
			Cross = Y;			
		}
		else
		{
			// End:0x3C5
			if(int(DoubleClickMove) == int(1))
			{
				Dir = float(-1) * Y;
				Cross = X;				
			}
			else
			{
				// End:0x3FF
				if(int(DoubleClickMove) == int(2))
				{
					Dir = Y;
					Cross = X;
				}
			}
		}
	}
	// End:0x42E
	if(AIController(Controller) != none)
	{
		Cross = vect(0.0000000, 0.0000000, 0.0000000);
	}
	return PerformDodge(DoubleClickMove, Dir, Cross);
	//return ReturnValue;	
}

function Vector BotDodge(Vector Dir)
{
	local Vector Vel;

	Vel = DodgeSpeed * Dir;
	Vel.Z = DodgeSpeedZ;
	return Vel;
	//return ReturnValue;	
}

function bool PerformDodge(Actor.EDoubleClickDir DoubleClickMove, Vector Dir, Vector Cross)
{
	local float VelocityZ;

	// End:0x1E
	if(int(Physics) == int(2))
	{
		TakeFallingDamage();
	}
	bDodging = true;
	bReadyToDoubleJump = JumpBootCharge > 0;
	VelocityZ = Velocity.Z;
	Velocity = (DodgeSpeed * Dir) + ((Velocity Dot Cross) * Cross);
	// End:0xEF
	if(VelocityZ < float(-200))
	{
		Velocity.Z = VelocityZ + DodgeSpeedZ;		
	}
	else
	{
		Velocity.Z = DodgeSpeedZ;
	}
	CurrentDir = DoubleClickMove;
	SetPhysics(2);
	SoundGroupClass.static.PlayDodgeSound(self);
	return true;
	//return ReturnValue;	
}

function DoDoubleJump(bool bUpdating)
{
	// End:0x100
	if(bIsCrouched! && bWantsToCrouch!)
	{
		// End:0x55
		if(IsLocallyControlled()! || AIController(Controller) != none)
		{
			MultiJumpRemaining -= 1;
		}
		Velocity.Z = JumpZ + float(MultiJumpBoost);
		UTInventoryManager(InvManager).OwnerEvent('MultiJump');
		SetPhysics(2);
		BaseEyeHeight = DoubleJumpEyeHeight;
		// End:0x100
		if(bUpdating!)
		{
			SoundGroupClass.static.PlayDoubleJumpSound(self);
		}
	}
	//return;	
}

function Gasp()
{
	SoundGroupClass.static.PlayGaspSound(self);
	//return;	
}

simulated function StartFlying()
{
	//return;	
}

simulated function StopFlying()
{
	//return;	
}

function bool DoJump(bool bUpdating)
{
	// End:0xBF
	if(((bUpdating! && CanDoubleJump()) && Abs(Velocity.Z) < DoubleJumpThreshold) && IsLocallyControlled())
	{
		// End:0x9D
		if(PlayerController(Controller) != none)
		{
			PlayerController(Controller).bDoubleJump = true;
		}
		DoDoubleJump(bUpdating);
		MultiJumpRemaining -= 1;
		return true;
	}
	// End:0x3E3
	if(((bJumpCapable && bIsCrouched!) && bWantsToCrouch!) && ((int(Physics) == int(1)) || int(Physics) == int(9)) || int(Physics) == int(8))
	{
		// End:0x165
		if(int(Physics) == int(8))
		{
			Velocity = JumpZ * Floor;			
		}
		else
		{
			// End:0x19E
			if(int(Physics) == int(9))
			{
				Velocity.Z = 0.0000000;				
			}
			else
			{
				// End:0x1D4
				if(bIsWalking)
				{
					Velocity.Z = default.JumpZ;					
				}
				else
				{
					Velocity.Z = JumpZ;
				}
			}
		}
		// End:0x3AB
		if(((Base != none) && Base.bWorldGeometry!) && Base.Velocity.Z > 0.0000000)
		{
			// End:0x35C
			if((WorldInfo.WorldGravityZ != WorldInfo.DefaultGravityZ) && (GetGravityZ()) == WorldInfo.WorldGravityZ)
			{
				Velocity.Z += (Base.Velocity.Z * Sqrt((GetGravityZ()) / WorldInfo.DefaultGravityZ));				
			}
			else
			{
				Velocity.Z += Base.Velocity.Z;
			}
		}
		SetPhysics(2);
		bReadyToDoubleJump = true;
		bDodging = false;
		// End:0x3E1
		if(bUpdating!)
		{
			PlayJumpingSound();
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

event Landed(Vector HitNormal, Actor FloorActor)
{
	local Vector Impulse;

	super(Pawn).Landed(HitNormal, FloorActor);
	Impulse.Z = Velocity.Z * 4.0000000;
	// End:0xC8
	if(UTVehicle(FloorActor) != none)
	{
		UTVehicle(FloorActor).Mesh.AddImpulse(Impulse, Location);		
	}
	else
	{
		// End:0x131
		if(DynamicSMActor(FloorActor) != none)
		{
			DynamicSMActor(FloorActor).StaticMeshComponent.AddImpulse(Impulse, Location);
		}
	}
	// End:0x1C9
	if(Velocity.Z < float(-200))
	{
		OldZ = Location.Z;
		bJustLanded = (bUpdateEyeheight && Controller != none) && Controller.LandingShake();
	}
	// End:0x212
	if(UTInventoryManager(InvManager) != none)
	{
		UTInventoryManager(InvManager).OwnerEvent('Landed');
	}
	// End:0x2C2
	if((((MultiJumpRemaining < MaxMultiJump) && bStopOnDoubleLanding) || bDodging) || Velocity.Z < (float(-2) * JumpZ))
	{
		Velocity.X *= 0.1000000;
		Velocity.Y *= 0.1000000;
	}
	AirControl = DefaultAirControl;
	MultiJumpRemaining = MaxMultiJump;
	bDodging = false;
	bReadyToDoubleJump = false;
	// End:0x34D
	if(UTBot(Controller) != none)
	{
		UTBot(Controller).ImpactVelocity = vect(0.0000000, 0.0000000, 0.0000000);
	}
	SetBaseEyeheight();
	//return;	
}

function JumpOutOfWater(Vector JumpDir)
{
	bReadyToDoubleJump = true;
	bDodging = false;
	Falling();
	Velocity = JumpDir * WaterSpeed;
	Acceleration = JumpDir * AccelRate;
	Velocity.Z = OutofWaterZ;
	bUpAndOut = true;
	//return;	
}

function bool CanDoubleJump()
{
	return ((MultiJumpRemaining > 0) && int(Physics) == int(2)) && bReadyToDoubleJump || UTBot(Controller) != none;
	//return ReturnValue;	
}

function bool CanMultiJump()
{
	return MaxMultiJump > 0;
	//return ReturnValue;	
}

function PlayDyingSound()
{
	SoundGroupClass.static.PlayDyingSound(self);
	//return;	
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local int I, J;
	local editinline PrimitiveComponent P;
	local string S;
	local float XL, YL;

	super(Pawn).DisplayDebug(HUD, out_YL, out_YPos);
	// End:0x1A2
	if(HUD.ShouldDisplayDebug('twist'))
	{
		HUD.Canvas.SetDrawColor(255, 255, 200);
		HUD.Canvas.SetPos(4.0000000, out_YPos);
		HUD.Canvas.DrawText(((((((("" $ string(self)) $ " - ") @ string(Rotation)) @ " RootYaw:") @ string(RootYaw)) @ " CurrentSkelAim") @ string(CurrentSkelAim.X)) @ string(CurrentSkelAim.Y));
		out_YPos += out_YL;
	}
	// End:0x1D1
	if(HUD.ShouldDisplayDebug('Component')!)
	{
		return;
	}
	HUD.Canvas.SetDrawColor(255, 255, 128, 255);
	I = 0;
	J0x218:

	// End:0x84F [Loop If]
	if(I < Mesh.Attachments.Length)
	{
		HUD.Canvas.SetPos(4.0000000, out_YPos);
		S = "" $ string(Mesh.Attachments[I].Component);
		HUD.Canvas.StrLen(S, XL, YL);
		J = Len(S);
		J0x337:

		// End:0x40C [Loop If]
		if((XL > (HUD.Canvas.ClipX * 0.5000000)) && J > 10)
		{
			J--;
			S = Right(S, J);
			HUD.Canvas.StrLen(S, XL, YL);
			// [Loop Continue]
			goto J0x337;
		}
		HUD.Canvas.DrawText(((("Attachment" @ string(I)) @ " = ") @ string(Mesh.Attachments[I].BoneName)) @ S);
		out_YPos += out_YL;
		P = PrimitiveComponent(Mesh.Attachments[I].Component);
		// End:0x841
		if(P != none)
		{
			HUD.Canvas.SetPos(24.0000000, out_YPos);
			HUD.Canvas.DrawText(((("Component = " @ string(P.Owner)) @ string(P.HiddenGame)) @ string(P.bOnlyOwnerSee)) @ string(P.bOwnerNoSee));
			out_YPos += out_YL;
			S = "" $ string(P);
			HUD.Canvas.StrLen(S, XL, YL);
			J = Len(S);
			J0x6C4:

			// End:0x799 [Loop If]
			if((XL > (HUD.Canvas.ClipX * 0.5000000)) && J > 10)
			{
				J--;
				S = Right(S, J);
				HUD.Canvas.StrLen(S, XL, YL);
				// [Loop Continue]
				goto J0x6C4;
			}
			HUD.Canvas.SetPos(24.0000000, out_YPos);
			HUD.Canvas.DrawText("Component = " @ S);
			out_YPos += out_YL;
		}
		I++;
		// [Loop Continue]
		goto J0x218;
	}
	out_YPos += (out_YL * float(2));
	HUD.Canvas.SetPos(24.0000000, out_YPos);
	HUD.Canvas.DrawText("Driven Vehicle = " @ string(DrivenVehicle));
	out_YPos += out_YL;
	//return;	
}

simulated function SetPawnAmbientSound(SoundCue NewAmbientSound)
{
	// End:0xB4
	if(NewAmbientSound != PawnAmbientSound.SoundCue)
	{
		PawnAmbientSoundCue = NewAmbientSound;
		PawnAmbientSound.Stop();
		PawnAmbientSound.SoundCue = NewAmbientSound;
		// End:0xB4
		if(NewAmbientSound != none)
		{
			PawnAmbientSound.Play();
		}
	}
	//return;	
}

simulated function SoundCue GetPawnAmbientSound()
{
	return PawnAmbientSoundCue;
	//return ReturnValue;	
}

simulated function SetWeaponAmbientSound(SoundCue NewAmbientSound)
{
	// End:0xB4
	if(NewAmbientSound != WeaponAmbientSound.SoundCue)
	{
		WeaponAmbientSoundCue = NewAmbientSound;
		WeaponAmbientSound.Stop();
		WeaponAmbientSound.SoundCue = NewAmbientSound;
		// End:0xB4
		if(NewAmbientSound != none)
		{
			WeaponAmbientSound.Play();
		}
	}
	//return;	
}

simulated function SoundCue GetWeaponAmbientSound()
{
	return WeaponAmbientSoundCue;
	//return ReturnValue;	
}

simulated function SetOverlaySkeletalMesh(SkeletalMesh NewSkelMesh)
{
	// End:0x38
	if(OverlayMesh != none)
	{
		OverlayMesh.SetSkeletalMesh(NewSkelMesh);
	}
	//return;	
}

simulated function SetOverlayMaterial(MaterialInterface NewOverlay)
{
	local int I;

	// End:0x27
	if(int(Role) == int(ROLE_Authority))
	{
		OverlayMaterialInstance = NewOverlay;
	}
	// End:0x1B1
	if(Mesh.SkeletalMesh != none)
	{
		// End:0x120
		if(NewOverlay != none)
		{
			I = 0;
			J0x65:

			// End:0xE6 [Loop If]
			if(I < OverlayMesh.SkeletalMesh.Materials.Length)
			{
				OverlayMesh.SetMaterial(I, OverlayMaterialInstance);
				I++;
				// [Loop Continue]
				goto J0x65;
			}
			// End:0x11D
			if(OverlayMesh.bAttached!)
			{
				AttachComponent(OverlayMesh);
			}			
		}
		else
		{
			// End:0x1B1
			if(OverlayMesh.bAttached)
			{
				// End:0x19E
				if(ShieldBeltArmor > float(0))
				{
					SetOverlayMaterial(GetShieldMaterialInstance(WorldInfo.Game.bTeamGame));					
				}
				else
				{
					DetachComponent(OverlayMesh);
				}
			}
		}
	}
	//return;	
}

simulated function MaterialInterface GetShieldMaterialInstance(bool bTeamGame)
{
	return ((bTeamGame) ? default.ShieldBeltTeamMaterialInstances[int(GetTeamNum())] : default.ShieldBeltMaterialInstance);
	//return ReturnValue;	
}

simulated function MaterialInterface GetOverlayMaterial()
{
	return OverlayMaterialInstance;
	//return ReturnValue;	
}

function SetWeaponOverlayFlag(byte FlagToSet)
{
	ApplyWeaponOverlayFlags(byte(int(WeaponOverlayFlags) | (1 << int(FlagToSet))));
	//return;	
}

function ClearWeaponOverlayFlag(byte FlagToClear)
{
	ApplyWeaponOverlayFlags(byte(int(WeaponOverlayFlags) & (255 ^ (1 << int(FlagToClear)))));
	//return;	
}

simulated function ApplyWeaponOverlayFlags(byte NewFlags)
{
	local UTWeapon Weap;
	local UDKVehicleBase VBase;

	// End:0x27
	if(int(Role) == int(ROLE_Authority))
	{
		WeaponOverlayFlags = NewFlags;
	}
	// End:0x120
	if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		Weap = UTWeapon(Weapon);
		// End:0x9B
		if(Weap != none)
		{
			Weap.SetWeaponOverlayFlags(self);
		}
		// End:0xCA
		if(CurrentWeaponAttachment != none)
		{
			CurrentWeaponAttachment.SetWeaponOverlayFlags(self);
		}
		VBase = UDKVehicleBase(DrivenVehicle);
		// End:0x120
		if(VBase != none)
		{
			VBase.ApplyWeaponEffects(int(WeaponOverlayFlags));
		}
	}
	//return;	
}

simulated event StartFeignDeathRecoveryAnim()
{
	local UTWeapon UTWeap;

	RestorePreRagdollCollisionComponent();
	Mesh.PhysicsWeight = 0.0000000;
	Mesh.MinDistFactorForKinematicUpdate = default.Mesh.MinDistFactorForKinematicUpdate;
	Mesh.PhysicsAssetInstance.SetAllBodiesFixed(true);
	Mesh.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(false, Mesh);
	SetPawnRBChannels(false);
	Mesh.bUpdateKinematicBonesFromAnimation = true;
	CylinderComponent.SetActorCollision(true, true);
	Mesh.SetActorCollision(false, false);
	Mesh.SetTraceBlocking(false, false);
	Mesh.SetTickGroup(0);
	// End:0x1A9
	if(int(Physics) == int(10))
	{
		SetPhysics(2);
	}
	UTWeap = UTWeapon(Weapon);
	// End:0x1F3
	if(UTWeap != none)
	{
		UTWeap.PlayWeaponEquip();
	}
	// End:0x290
	if((FeignDeathBlend != none) && FeignDeathBlend.Children[1].Anim != none)
	{
		FeignDeathBlend.Children[1].Anim.PlayAnim(false, 1.1000000);		
	}
	else
	{
		bNoWeaponFiring = default.bNoWeaponFiring;
		GotoState('Auto');
	}
	//return;	
}

function FeignDeathDelayTimer()
{
	// End:0xEA
	if(((WorldInfo.TimeSeconds - FeignDeathStartTime) > 1.0000000) && PhysicsVolume.bWaterVolume || VSize(Velocity) < ((4.0000000 * FeignDeathBodyAtRestSpeed) * (WorldInfo.TimeSeconds - FeignDeathStartTime)))
	{
		ClearTimer('FeignDeathDelayTimer');
		// End:0xEA
		if(bFeigningDeath && bForcedFeignDeath)
		{
			bFeigningDeath = false;
			PlayFeignDeath();
		}
	}
	//return;	
}

simulated function PlayFeignDeath()
{
	local Vector FeignLocation, HitLocation, HitNormal, TraceEnd, Impulse;

	local Rotator NewRotation;
	local UTWeapon UTWeap;
	local UTVehicle V;
	local Controller Killer;
	local float UnFeignZAdjust;
	local Vector hipsLoc, headLoc;

	// End:0x34A
	if(bFeigningDeath)
	{
		StartFallImpactTime = WorldInfo.TimeSeconds;
		bCanPlayFallingImpacts = true;
		GotoState('FeigningDeath');
		// End:0x68
		if(int(Physics) == int(10))
		{
			SetPhysics(2);
		}
		Mesh.MinDistFactorForKinematicUpdate = 0.0000000;
		SetPawnRBChannels(true);
		Mesh.ForceSkelUpdate();
		Mesh.SetTickGroup(2);
		bBlendOutTakeHitPhysics = false;
		PreRagdollCollisionComponent = CollisionComponent;
		CollisionComponent = Mesh;
		CylinderComponent.SetActorCollision(false, false);
		Mesh.SetActorCollision(true, true);
		Mesh.SetTraceBlocking(true, true);
		SetPhysics(10);
		Mesh.PhysicsWeight = 1.0000000;
		// End:0x1DA
		if(Mesh.bNotUpdatingKinematicDueToDistance)
		{
			Mesh.UpdateRBBonesFromSpaceBases(true, true);
		}
		Mesh.PhysicsAssetInstance.SetAllBodiesFixed(false);
		Mesh.bUpdateKinematicBonesFromAnimation = false;
		Mesh.SetRBLinearVelocity(Velocity, false);
		FeignDeathStartTime = WorldInfo.TimeSeconds;
		Mesh.SetTranslation(vect(0.0000000, 0.0000000, 1.0000000) * BaseTranslationOffset);
		Mesh.ScriptRigidBodyCollisionThreshold = MaxFallSpeed;
		Mesh.SetNotifyRigidBodyCollision(true);
		Mesh.WakeRigidBody();
		// End:0x347
		if(int(Role) == int(ROLE_Authority))
		{
			SetTimer(0.1500000, true, 'FeignDeathDelayTimer');
		}		
	}
	else
	{
		FeignLocation = Location;
		CollisionComponent = PreRagdollCollisionComponent;
		TraceEnd = Location + (vect(0.0000000, 0.0000000, 1.0000000) * (GetCollisionHeight()));
		// End:0x3EB
		if(Trace(HitLocation, HitNormal, TraceEnd, Location, true, GetCollisionExtent()) == none)
		{
			HitLocation = TraceEnd;
		}
		// End:0x4C6
		if(SetFeignEndLocation(HitLocation, FeignLocation)!)
		{
			CollisionComponent = Mesh;
			SetLocation(FeignLocation);
			bFeigningDeath = true;
			Impulse = VRand();
			Impulse.Z = 0.5000000;
			Mesh.AddImpulse(800.0000000 * Impulse, Location);
			UnfeignFailedCount++;
			// End:0x4C4
			if(UnfeignFailedCount > 4)
			{
				Suicide();
			}
			return;
		}
		UnFeignZAdjust = Location.Z - FeignLocation.Z;
		// End:0x538
		if(UnFeignZAdjust > 0.0000000)
		{
			MoveSmooth(vect(0.0000000, 0.0000000, -1.0000000) * UnFeignZAdjust);
		}
		UnfeignFailedCount = 0;
		CollisionComponent = Mesh;
		bPlayingFeignDeathRecovery = true;
		FeignDeathRecoveryStartTime = WorldInfo.TimeSeconds;
		Mesh.SetNotifyRigidBodyCollision(false);
		SetPhysics(0);
		// End:0x7E4
		if(int(Role) == int(ROLE_Authority))
		{
			CollisionComponent = PreRagdollCollisionComponent;
			// End:0x7D0
			foreach CollidingActors(Class'UTGame.UTVehicle', V, GetCollisionRadius(),, true)
			{
				// End:0x7CF
				if(IsOverlapping(V))
				{
					// End:0x6CF
					if(V.Class == HoverboardClass)
					{
						Impulse = VRand() * V.GroundSpeed;
						Impulse.Z = 500.0000000;
						V.Mesh.AddImpulse(Impulse,,, true);
						// End:0x7CF
						continue;
					}
					CollisionComponent = Mesh;
					// End:0x731
					if(V.Controller != none)
					{
						Killer = V.Controller;						
					}
					else
					{
						// End:0x792
						if(V.Instigator != none)
						{
							Killer = V.Instigator.Controller;
						}
					}
					Died(Killer, V.RanOverDamageType, Location);					
					return;
				}				
			}			
			CollisionComponent = Mesh;
		}
		// End:0x9DD
		if((FeignDeathBlend != none) && bIsCrouched!)
		{
			Mesh.PhysicsWeight = 1.0000000;
			FeignDeathBlend.SetBlendTarget(1.0000000, 0.0000000);
			headLoc = Mesh.GetBoneLocation(HeadBone);
			hipsLoc = Mesh.GetBoneLocation(HipsBone);
			NewRotation = Rotator(headLoc - hipsLoc);
			NewRotation.Pitch = 0;
			NewRotation.Roll = 0;
			// End:0x97D
			if(Mesh.GetBoneAxis(HipsBone, 2).Z < 0.0000000)
			{
				NewRotation.Yaw += 32768;
			}
			SetRotation(NewRotation);
			Controller.SetRotation(NewRotation);
			SetDesiredRotation(NewRotation);
			// End:0x9DA
			if(int(Physics) == int(10))
			{
				SetPhysics(2);
			}			
		}
		else
		{
			RestorePreRagdollCollisionComponent();
			Mesh.PhysicsWeight = 0.0000000;
			Mesh.PhysicsAssetInstance.SetAllBodiesFixed(true);
			Mesh.bUpdateKinematicBonesFromAnimation = true;
			Mesh.MinDistFactorForKinematicUpdate = default.Mesh.MinDistFactorForKinematicUpdate;
			SetPawnRBChannels(false);
			// End:0xAC2
			if(int(Physics) == int(10))
			{
				SetPhysics(2);
			}
			UTWeap = UTWeapon(Weapon);
			// End:0xB0C
			if(UTWeap != none)
			{
				UTWeap.PlayWeaponEquip();
			}
			GotoState('Auto');
		}
	}
	//return;	
}

simulated function bool SetFeignEndLocation(Vector HitLocation, Vector FeignLocation)
{
	local Vector NewDest;

	// End:0x29
	if(SetLocation(HitLocation) && CheckValidLocation(FeignLocation))
	{
		return true;
	}
	ForceCrouch();
	// End:0x5C
	if(SetLocation(HitLocation) && CheckValidLocation(FeignLocation))
	{
		return true;
	}
	NewDest = HitLocation + ((GetCollisionRadius()) * vect(1.0000000, 1.0000000, 0.0000000));
	// End:0xB3
	if(SetLocation(NewDest) && CheckValidLocation(FeignLocation))
	{
		return true;
	}
	NewDest = HitLocation + ((GetCollisionRadius()) * vect(1.0000000, -1.0000000, 0.0000000));
	// End:0x10A
	if(SetLocation(NewDest) && CheckValidLocation(FeignLocation))
	{
		return true;
	}
	NewDest = HitLocation + ((GetCollisionRadius()) * vect(-1.0000000, 1.0000000, 0.0000000));
	// End:0x161
	if(SetLocation(NewDest) && CheckValidLocation(FeignLocation))
	{
		return true;
	}
	NewDest = HitLocation + ((GetCollisionRadius()) * vect(-1.0000000, -1.0000000, 0.0000000));
	// End:0x1B8
	if(SetLocation(NewDest) && CheckValidLocation(FeignLocation))
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function bool CheckValidLocation(Vector FeignLocation)
{
	local Vector HitLocation, HitNormal, DestFinalZ;

	// End:0x3F
	if(Trace(HitLocation, HitNormal, Location, FeignLocation, false, vect(10.0000000, 10.0000000, 10.0000000),, 1) == none)
	{
		return true;
	}
	DestFinalZ = FeignLocation;
	FeignLocation.Z = Location.Z;
	// End:0x109
	if((Trace(HitLocation, HitNormal, DestFinalZ, FeignLocation, false, vect(10.0000000, 10.0000000, 10.0000000)) == none) && Trace(HitLocation, HitNormal, Location, DestFinalZ, false, vect(10.0000000, 10.0000000, 10.0000000),, 1) == none)
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

reliable server function ServerFeignDeath()
{
	// End:0x9B
	if(((((int(Role) == int(ROLE_Authority)) && WorldInfo.Game.IsInState('MatchOver')!) && DrivenVehicle == none) && Controller != none) && bFeigningDeath!)
	{
		bFeigningDeath = true;
		PlayFeignDeath();
	}
	//return;	
}

simulated exec function FeignDeath()
{
	ServerFeignDeath();
	//return;	
}

function ForceRagdoll()
{
	bFeigningDeath = true;
	bForcedFeignDeath = true;
	PlayFeignDeath();
	//return;	
}

simulated function FiringModeUpdated(Weapon InWeapon, byte InFiringMode, bool bViaReplication)
{
	super(Pawn).FiringModeUpdated(InWeapon, InFiringMode, bViaReplication);
	// End:0x67
	if(CurrentWeaponAttachment != none)
	{
		CurrentWeaponAttachment.FireModeUpdated(InFiringMode, bViaReplication);
	}
	//return;	
}

function SetBigHead()
{
	bKillsAffectHead = true;
	// End:0x7E
	if(PlayerReplicationInfo != none)
	{
		SetHeadScale(FClamp((5.0000000 + float(PlayerReplicationInfo.Kills)) / float(5 + PlayerReplicationInfo.Deaths), 0.7500000, 2.0000000));
	}
	//return;	
}

simulated function FireRateChanged()
{
	// End:0xA3
	if((Weapon != none) && Weapon.IsTimerActive('RefireCheckTimer'))
	{
		Weapon.ClearTimer('RefireCheckTimer');
		Weapon.TimeWeaponFiring(Weapon.CurrentFireMode);
	}
	// End:0x1C0
	if(((DrivenVehicle != none) && DrivenVehicle.Weapon != none) && DrivenVehicle.Weapon.IsTimerActive('RefireCheckTimer'))
	{
		DrivenVehicle.Weapon.ClearTimer('RefireCheckTimer');
		DrivenVehicle.Weapon.TimeWeaponFiring(DrivenVehicle.Weapon.CurrentFireMode);
	}
	//return;	
}

simulated event ReplicatedEvent(name VarName)
{
	// End:0xDA
	if((VarName == 'Controller') && Controller != none)
	{
		// End:0xD7
		if(UTWeapon(Weapon) != none)
		{
			UTWeapon(Weapon).ClientEndFire(0);
			UTWeapon(Weapon).ClientEndFire(1);
			// End:0xD7
			if(Weapon.HasAnyAmmo()!)
			{
				Weapon.WeaponEmpty();
			}
		}		
	}
	else
	{
		// End:0x100
		if(VarName == 'CurrentWeaponAttachmentClass')
		{
			WeaponAttachmentChanged();
			return;			
		}
		else
		{
			// End:0x1E0
			if(VarName == 'CompressedBodyMatColor')
			{
				BodyMatColor.R = float(CompressedBodyMatColor.Pitch) / 256.0000000;
				BodyMatColor.G = float(CompressedBodyMatColor.Yaw) / 256.0000000;
				BodyMatColor.B = float(CompressedBodyMatColor.Roll) / 256.0000000;				
			}
			else
			{
				// End:0x216
				if(VarName == 'ClientBodyMatDuration')
				{
					SetBodyMatColor(BodyMatColor, ClientBodyMatDuration);					
				}
				else
				{
					// End:0x243
					if(VarName == 'HeadScale')
					{
						SetHeadScale(HeadScale);						
					}
					else
					{
						// End:0x270
						if(VarName == 'PawnAmbientSoundCue')
						{
							SetPawnAmbientSound(PawnAmbientSoundCue);							
						}
						else
						{
							// End:0x29D
							if(VarName == 'WeaponAmbientSoundCue')
							{
								SetWeaponAmbientSound(WeaponAmbientSoundCue);								
							}
							else
							{
								// End:0x2CA
								if(VarName == 'ReplicatedBodyMaterial')
								{
									SetSkin(ReplicatedBodyMaterial);									
								}
								else
								{
									// End:0x2F7
									if(VarName == 'OverlayMaterialInstance')
									{
										SetOverlayMaterial(OverlayMaterialInstance);										
									}
									else
									{
										// End:0x31B
										if(VarName == 'bFeigningDeath')
										{
											PlayFeignDeath();											
										}
										else
										{
											// End:0x348
											if(VarName == 'WeaponOverlayFlags')
											{
												ApplyWeaponOverlayFlags(WeaponOverlayFlags);												
											}
											else
											{
												// End:0x36C
												if(VarName == 'LastTakeHitInfo')
												{
													PlayTakeHitEffects();													
												}
												else
												{
													// End:0x642
													if(VarName == 'DrivenWeaponPawn')
													{
														// End:0x569
														if((DrivenWeaponPawn.BaseVehicle != LastDrivenWeaponPawn.BaseVehicle) || int(DrivenWeaponPawn.SeatIndex) != int(LastDrivenWeaponPawn.SeatIndex))
														{
															// End:0x52E
															if(DrivenWeaponPawn.BaseVehicle != none)
															{
																// End:0x497
																if((ClientSideWeaponPawn == none) || ClientSideWeaponPawn.bDeleteMe)
																{
																	ClientSideWeaponPawn = Spawn(Class'UTGame.UTClientSideWeaponPawn', DrivenWeaponPawn.BaseVehicle);
																}
																ClientSideWeaponPawn.MyVehicle = UTVehicle(DrivenWeaponPawn.BaseVehicle);
																ClientSideWeaponPawn.MySeatIndex = int(DrivenWeaponPawn.SeatIndex);
																StartDriving(ClientSideWeaponPawn);																
															}
															else
															{
																// End:0x569
																if((ClientSideWeaponPawn != none) && ClientSideWeaponPawn == DrivenVehicle)
																{
																	StopDriving(ClientSideWeaponPawn);
																}
															}
														}
														// End:0x62C
														if(((ClientSideWeaponPawn != none) && ClientSideWeaponPawn == DrivenVehicle) && ClientSideWeaponPawn.PlayerReplicationInfo != DrivenWeaponPawn.PRI)
														{
															ClientSideWeaponPawn.PlayerReplicationInfo = DrivenWeaponPawn.PRI;
															ClientSideWeaponPawn.NotifyTeamChanged();
														}
														LastDrivenWeaponPawn = DrivenWeaponPawn;														
													}
													else
													{
														// End:0x670
														if(VarName == 'bPuttingDownWeapon')
														{
															SetPuttingDownWeapon(bPuttingDownWeapon);															
														}
														else
														{
															// End:0x6CC
															if(VarName == 'EmoteRepInfo')
															{
																DoPlayEmote(EmoteRepInfo.EmoteTag, EmoteRepInfo.EmoteID);																
															}
															else
															{
																// End:0x6FA
																if(VarName == 'bIsInvisible')
																{
																	SetInvisible(bIsInvisible);																	
																}
																else
																{
																	// End:0x71E
																	if(VarName == 'BigTeleportCount')
																	{
																		PostBigTeleport();																		
																	}
																	else
																	{
																		// End:0x742
																		if(VarName == 'FireRateMultiplier')
																		{
																			FireRateChanged();																			
																		}
																		else
																		{
																			super(Pawn).ReplicatedEvent(VarName);
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
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

simulated function SetHeadScale(float NewScale)
{
	local SkelControlBase SkelControl;

	HeadScale = NewScale;
	SkelControl = Mesh.FindSkelControl('HeadControl');
	// End:0xA0
	if(SkelControl != none)
	{
		SkelControl.BoneScale = NewScale;
		SkelControl.IgnoreAtOrAboveLOD = 1000;
	}
	SkelControl = Mesh.FindSkelControl('NeckControl');
	// End:0x139
	if(SkelControl != none)
	{
		SkelControl.BoneScale = FClamp(NewScale, 0.0000000, 1.0000000);
		SkelControl.IgnoreAtOrAboveLOD = 1000;
	}
	//return;	
}

simulated function SetPuttingDownWeapon(bool bNowPuttingDownWeapon)
{
	// End:0x7C
	if((bPuttingDownWeapon != bNowPuttingDownWeapon) || int(Role) < int(ROLE_Authority))
	{
		bPuttingDownWeapon = bNowPuttingDownWeapon;
		// End:0x7C
		if(CurrentWeaponAttachment != none)
		{
			CurrentWeaponAttachment.SetPuttingDownWeapon(bPuttingDownWeapon);
		}
	}
	//return;	
}

simulated function bool GetPuttingDownWeapon()
{
	return bPuttingDownWeapon;
	//return ReturnValue;	
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local int OldHealth;

	// End:0x85
	if(((AttachedProj != none) && AttachedProj.bDeleteMe!) && AttachedProj.InstigatorController != none)
	{
		EventInstigator = AttachedProj.InstigatorController;
	}
	// End:0xAC
	if(EventInstigator == Controller)
	{
		Momentum *= 0.6000000;
	}
	// End:0x10F
	if(AccumulationTime != WorldInfo.TimeSeconds)
	{
		AccumulateDamage = 0.0000000;
		AccumulationTime = WorldInfo.TimeSeconds;
	}
	OldHealth = Health;
	AccumulateDamage += float(Damage);
	super(Pawn).TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	AccumulateDamage = ((AccumulateDamage + float(OldHealth)) - float(Health)) - float(Damage);
	//return;	
}

simulated function WeaponFired(Weapon InWeapon, bool bViaReplication, optional Vector HitLocation)
{
	// End:0x1C6
	if(CurrentWeaponAttachment != none)
	{
		// End:0x4A
		if(IsFirstPerson()!)
		{
			CurrentWeaponAttachment.ThirdPersonFireEffects(HitLocation);			
		}
		else
		{
			CurrentWeaponAttachment.FirstPersonFireEffects(Weapon, HitLocation);
			// End:0x11E
			if(Class'Engine.Engine'.static.IsSplitScreen() && CurrentWeaponAttachment.EffectIsRelevant(CurrentWeaponAttachment.Location, false, CurrentWeaponAttachment.MaxFireEffectDistance))
			{
				CurrentWeaponAttachment.CauseMuzzleFlash();
			}
		}
		// End:0x1C6
		if((HitLocation != vect(0.0000000, 0.0000000, 0.0000000)) && ((int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_Standalone)) || bViaReplication)
		{
			CurrentWeaponAttachment.PlayImpactEffects(HitLocation);
		}
	}
	//return;	
}

simulated function WeaponStoppedFiring(Weapon InWeapon, bool bViaReplication)
{
	// End:0x56
	if(CurrentWeaponAttachment != none)
	{
		CurrentWeaponAttachment.StopThirdPersonFireEffects();
		CurrentWeaponAttachment.StopFirstPersonFireEffects(Weapon);
	}
	//return;	
}

simulated function WeaponChanged(UTWeapon NewWeapon)
{
	local editinline UDKSkeletalMeshComponent UTSkel;

	// End:0x1BF
	if(NewWeapon.Mesh != none)
	{
		NewWeapon.Mesh.SetHidden(IsFirstPerson()!);
		UTSkel = UDKSkeletalMeshComponent(NewWeapon.Mesh);
		// End:0x1BF
		if(UTSkel != none)
		{
			ArmsMesh[0].SetFOV(UTSkel.FOV);
			ArmsMesh[1].SetFOV(UTSkel.FOV);
			ArmsMesh[0].SetScale(UTSkel.Scale);
			ArmsMesh[1].SetScale(UTSkel.Scale);
			NewWeapon.PlayWeaponEquip();
		}
	}
	//return;	
}

simulated function WeaponAttachmentChanged()
{
	// End:0x193
	if(((CurrentWeaponAttachment == none) || CurrentWeaponAttachment.Class != CurrentWeaponAttachmentClass) && Mesh.SkeletalMesh != none)
	{
		// End:0xB2
		if(CurrentWeaponAttachment != none)
		{
			CurrentWeaponAttachment.DetachFrom(Mesh);
			CurrentWeaponAttachment.Destroy();
		}
		// End:0x108
		if(CurrentWeaponAttachmentClass != none)
		{
			CurrentWeaponAttachment = Spawn(CurrentWeaponAttachmentClass, self);
			CurrentWeaponAttachment.Instigator = self;			
		}
		else
		{
			CurrentWeaponAttachment = none;
		}
		// End:0x193
		if(CurrentWeaponAttachment != none)
		{
			CurrentWeaponAttachment.AttachTo(self);
			CurrentWeaponAttachment.SetSkin(ReplicatedBodyMaterial);
			CurrentWeaponAttachment.ChangeVisibility(bWeaponAttachmentVisible);
		}
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
	// End:0x184
	if((WorldInfo.TimeSeconds - LastPainSound) >= 0.3500000)
	{
		LastPainSound = WorldInfo.TimeSeconds;
		// End:0x184
		if((Damage > float(0)) && Health > 0)
		{
			// End:0x159
			if(DamageType == Class'UTGame.UTDmgType_Drowned')
			{
				SoundGroupClass.static.PlayDrownSound(self);				
			}
			else
			{
				SoundGroupClass.static.PlayTakeHitSound(self, int(Damage));
			}
		}
	}
	// End:0x238
	if((((Health <= 0) && PhysicsVolume.bDestructive) && WaterVolume(PhysicsVolume) != none) && WaterVolume(PhysicsVolume).ExitActor != none)
	{
		Spawn(WaterVolume(PhysicsVolume).ExitActor);
	}
	super(Pawn).PlayHit(Damage, InstigatedBy, HitLocation, DamageType, Momentum, HitInfo);
	// End:0x2A8
	if(Hearer != none)
	{
		Hearer.bAcuteHearing = false;
	}
	UTDamage = Class<UTDamageType>(DamageType);
	// End:0x59C
	if((Damage > float(0)) || (Controller != none) && Controller.bGodMode)
	{
		CheckHitInfo(HitInfo, Mesh, Normal(Momentum), HitLocation);
		// End:0x389
		if(bShieldAbsorb)
		{
			SetBodyMatColor(SpawnProtectionColor, 1.0000000);
			PlaySound(ArmorHitSound);
			bShieldAbsorb = false;
			return;			
		}
		else
		{
			// End:0x432
			if(((UTDamage != none) && UTDamage.default.DamageOverlayTime > 0.0000000) && UTDamage.default.XRayEffectTime <= 0.0000000)
			{
				SetBodyMatColor(UTDamage.default.DamageBodyMatColor, UTDamage.default.DamageOverlayTime);
			}
		}
		LastTakeHitInfo.Damage = int(Damage);
		LastTakeHitInfo.HitLocation = HitLocation;
		LastTakeHitInfo.Momentum = Momentum;
		LastTakeHitInfo.DamageType = DamageType;
		LastTakeHitInfo.HitBone = HitInfo.BoneName;
		LastTakeHitTimeout = WorldInfo.TimeSeconds + ((UTDamage != none) ? UTDamage.static.GetHitEffectDuration(self, Damage) : Class'UTGame.UTDamageType'.static.GetHitEffectDuration(self, Damage));
		PlayTakeHitEffects();
	}
	//return;	
}

simulated function PlayTakeHitEffects()
{
	local Class<UTDamageType> UTDamage;
	local Vector BloodMomentum;
	local UTEmit_HitEffect HitEffect;
	local ParticleSystem BloodTemplate;

	// End:0x63D
	if(EffectIsRelevant(Location, false))
	{
		UTDamage = Class<UTDamageType>(LastTakeHitInfo.DamageType);
		// End:0x63D
		if(UTDamage != none)
		{
			// End:0x110
			if((UTDamage.default.bCausesBloodSplatterDecals && IsZero(LastTakeHitInfo.Momentum)!) && Class'UTGame.UTGame'.static.UseLowGore(WorldInfo)!)
			{
				LeaveABloodSplatterDecal(LastTakeHitInfo.HitLocation, LastTakeHitInfo.Momentum);
			}
			// End:0x63D
			if(IsFirstPerson()! || Class'Engine.Engine'.static.IsSplitScreen())
			{
				// End:0x30E
				if(UTDamage.default.bCausesBlood && Class'UTGame.UTGame'.static.UseLowGore(WorldInfo)!)
				{
					BloodTemplate = Class'UTGame.UTEmitter'.static.GetTemplateForDistance(static.GetFamilyInfo().default.BloodEffects, LastTakeHitInfo.HitLocation, WorldInfo);
					// End:0x30E
					if(BloodTemplate != none)
					{
						BloodMomentum = Normal(-1.0000000 * LastTakeHitInfo.Momentum) + (0.5000000 * VRand());
						HitEffect = Spawn(static.GetFamilyInfo().default.BloodEmitterClass, self,, LastTakeHitInfo.HitLocation, Rotator(BloodMomentum));
						HitEffect.SetTemplate(BloodTemplate, true);
						HitEffect.AttachTo(self, LastTakeHitInfo.HitBone);
					}
				}
				// End:0x63D
				if(Mesh.bNotUpdatingKinematicDueToDistance!)
				{
					// End:0x63D
					if(UTDamage != none)
					{
						// End:0x5AB
						if((((Class'Engine.Engine'.static.IsSplitScreen()! && Health > 0) && DrivenVehicle == none) && int(Physics) != int(10)) && VSize(LastTakeHitInfo.Momentum) > UTDamage.default.PhysicsTakeHitMomentumThreshold)
						{
							// End:0x491
							if(Mesh.PhysicsAssetInstance != none)
							{
								Mesh.AddImpulse(LastTakeHitInfo.Momentum, LastTakeHitInfo.HitLocation);
								// End:0x48E
								if(bBlendOutTakeHitPhysics)
								{
									Mesh.PhysicsWeight = 0.5000000;
								}								
							}
							else
							{
								// End:0x5AB
								if(Mesh.PhysicsAsset != none)
								{
									Mesh.PhysicsWeight = 0.5000000;
									// End:0x546
									if(Mesh.PhysicsAssetInstance != none)
									{
										Mesh.PhysicsAssetInstance.SetNamedBodiesFixed(true, TakeHitPhysicsFixedBones, Mesh, true);
									}
									Mesh.AddImpulse(LastTakeHitInfo.Momentum, LastTakeHitInfo.HitLocation);
									bBlendOutTakeHitPhysics = true;
								}
							}
						}
						UTDamage.static.SpawnHitEffect(self, float(LastTakeHitInfo.Damage), LastTakeHitInfo.Momentum, LastTakeHitInfo.HitBone, LastTakeHitInfo.HitLocation);
					}
				}
			}
		}
	}
	//return;	
}

simulated event TakeHitBlendedOut()
{
	Mesh.PhysicsWeight = 0.0000000;
	Mesh.PhysicsAssetInstance.SetAllBodiesFixed(true);
	//return;	
}

reliable server function ServerHoverboard()
{
	local UTVehicle Board;
	local Vector Start, End, HitLoc, HitNorm;
	local Actor HitActor;
	local TraceHitInfo HitInfo;
	local bool bInDeepWater;

	Start = Location;
	End = Location - vect(0.0000000, 0.0000000, 15.0000000);
	HitActor = Trace(HitLoc, HitNorm, End, Start, false, vect(0.0000000, 0.0000000, 0.0000000), HitInfo, 2);
	// End:0xB4
	if((HitActor != none) && WaterVolume(HitActor) != none)
	{
		bInDeepWater = true;
	}
	// End:0x26F
	if((((((bHasHoverboard && bIsCrouched!) && DrivenVehicle == none) && PhysicsVolume.bWaterVolume!) && (WorldInfo.TimeSeconds - LastHoverboardTime) > MinHoverboardInterval) && int(Physics) != int(3)) && bInDeepWater!)
	{
		LastHoverboardTime = WorldInfo.TimeSeconds;
		SetCollision(false, false);
		Board = Spawn(HoverboardClass);
		// End:0x269
		if((Board != none) && Board.bDeleteMe!)
		{
			// End:0x266
			if(FastTrace(Board.Location, Location)! || Board.TryToDrive(self)!)
			{
				Board.Destroy();
				SetCollision(true, true);
			}			
		}
		else
		{
			SetCollision(true, true);
		}
	}
	//return;	
}

function OnUseHoverboard(UTSeqAct_UseHoverboard Action)
{
	bHasHoverboard = true;
	ServerHoverboard();
	Action.Hoverboard = UTVehicle(DrivenVehicle);
	//return;	
}

simulated function SwitchWeapon(byte NewGroup)
{
	// End:0x9F
	if(((int(NewGroup) == int(0)) && bHasHoverboard) && DrivenVehicle == none)
	{
		// End:0x9D
		if((WorldInfo.TimeSeconds - LastHoverboardTime) > MinHoverboardInterval)
		{
			ServerHoverboard();
			LastHoverboardTime = WorldInfo.TimeSeconds;
		}
		return;
	}
	// End:0xE8
	if(UTInventoryManager(InvManager) != none)
	{
		UTInventoryManager(InvManager).SwitchWeapon(NewGroup);
	}
	//return;	
}

function TakeDrowningDamage()
{
	TakeDamage(5, none, (Location + ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 0.5000000))) + ((0.7000000 * (GetCollisionRadius())) * Vector(Controller.Rotation)), vect(0.0000000, 0.0000000, 0.0000000), Class'UTGame.UTDmgType_Drowned');
	//return;	
}

function bool IsLocationOnHead(const out ImpactInfo Impact, float AdditionalScale)
{
	local Vector HeadLocation;
	local float Distance;

	// End:0x19
	if(HeadBone == 'None')
	{
		return false;
	}
	Mesh.ForceSkelUpdate();
	HeadLocation = Mesh.GetBoneLocation(HeadBone) + (vect(0.0000000, 0.0000000, 1.0000000) * HeadHeight);
	Distance = PointDistToLine(HeadLocation, Impact.RayDir, Impact.HitLocation);
	return Distance < ((HeadRadius * HeadScale) * AdditionalScale);
	//return ReturnValue;	
}

simulated function ModifyRotForDebugFreeCam(out Rotator out_CamRot)
{
	local UTPlayerController UPC;

	UPC = UTPlayerController(Controller);
	// End:0x6D
	if((UPC == none) && DrivenVehicle != none)
	{
		UPC = UTPlayerController(DrivenVehicle.Controller);
	}
	// End:0xC6
	if(UPC != none)
	{
		// End:0xC6
		if(UPC.bDebugFreeCam)
		{
			out_CamRot = UPC.DebugFreeCamRot;
		}
	}
	//return;	
}

simulated function bool IsFirstPerson()
{
	local PlayerController PC;

	// End:0x6B
	foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		// End:0x6A
		if((PC.ViewTarget == self) && PC.UsingFirstPersonCamera())
		{			
			return true;
		}		
	}	
	return false;
	//return ReturnValue;	
}

simulated function AdjustCameraScale(bool bMoveCameraIn)
{
	// End:0x51
	if(IsFirstPerson()!)
	{
		CameraScale = FClamp(CameraScale + ((bMoveCameraIn) ? -1.0000000 : 1.0000000), CameraScaleMin, CameraScaleMax);
	}
	//return;	
}

simulated event Rotator GetViewRotation()
{
	local Rotator Result;

	// End:0xA9
	if(UTBot(Controller) != none)
	{
		Result = Controller.Rotation;
		Result.Pitch = Rotator(Controller.GetFocalPoint() - Location).Pitch;
		return Result;		
	}
	else
	{
		return super(Pawn).GetViewRotation();
	}
	//return ReturnValue;	
}

simulated event TornOff()
{
	local Class<UTDamageType> UTDamage;

	super(Pawn).TornOff();
	SetPawnAmbientSound(none);
	SetWeaponAmbientSound(none);
	UTDamage = Class<UTDamageType>(HitDamageType);
	// End:0xD7
	if(UTDamage != none)
	{
		// End:0xB7
		if(UTDamage.default.DamageOverlayTime > float(0))
		{
			SetBodyMatColor(UTDamage.default.DamageBodyMatColor, UTDamage.default.DamageOverlayTime);
		}
		UTDamage.static.PawnTornOff(self);
	}
	//return;	
}

simulated function SetOverlayVisibility(bool bVisible)
{
	OverlayMesh.SetOwnerNoSee(bVisible!);
	//return;	
}

simulated function TakeFallingDamage()
{
	local UTPlayerController UTPC;

	super(Pawn).TakeFallingDamage();
	// End:0xBE
	if(Velocity.Z < (-0.5000000 * MaxFallSpeed))
	{
		UTPC = UTPlayerController(Controller);
		// End:0xBE
		if((UTPC != none) && LocalPlayer(UTPC.Player) != none)
		{
			UTPC.ClientPlayForceFeedbackWaveform(FallingDamageWaveForm);
		}
	}
	//return;	
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
	// End:0x15F
	if(Abs(RigidCollisionData.ContactInfos[0].ContactNormal.Z) > 0.5000000)
	{
		Velocity = Mesh.GetRootBodyInstance().PreviousVelocity;
		TakeFallingDamage();
		Velocity.Z = 0.0000000;
		Mesh.SetRBLinearVelocity(Velocity, false);
		Mesh.GetRootBodyInstance().PreviousVelocity = Velocity;
		Mesh.GetRootBodyInstance().Velocity = Velocity;
	}
	//return;	
}

event OnRanOver(SVehicle Vehicle, PrimitiveComponent RunOverComponent, int WheelIndex)
{
	local UTVehicle UTV;

	// End:0xAA
	if(int(Role) == int(ROLE_Authority))
	{
		UTV = UTVehicle(Vehicle);
		// End:0xAA
		if(UTV != none)
		{
			TakeDamage(10000, UTV.Controller, Location, vect(0.0000000, 0.0000000, 0.0000000), UTV.RanOverDamageType,, Vehicle);
		}
	}
	//return;	
}

event StuckFalling()
{
	// End:0x25
	if(AIController(Controller) != none)
	{
		Suicide();		
	}
	else
	{
		StartedFallingTime = WorldInfo.TimeSeconds;
	}
	//return;	
}

function OnExitVehicle(UTSeqAct_ExitVehicle Action)
{
	// End:0x2F
	if(DrivenVehicle != none)
	{
		DrivenVehicle.DriverLeave(true);
	}
	//return;	
}

function OnInfiniteAmmo(UTSeqAct_InfiniteAmmo Action)
{
	local UTInventoryManager UTInvManager;

	UTInvManager = UTInventoryManager(InvManager);
	// End:0x6A
	if(UTInvManager != none)
	{
		UTInvManager.bInfiniteAmmo = Action.bInfiniteAmmo;
	}
	//return;	
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	super(Pawn).PossessedBy(C, bVehicleTransition);
	NotifyTeamChanged();
	//return;	
}

function bool NeedToTurn(Vector targ)
{
	local Vector LookDir, AimDir;
	local UTBot B;
	local float RequiredAim;

	LookDir = Vector(Rotation);
	LookDir.Z = 0.0000000;
	LookDir = Normal(LookDir);
	AimDir = targ - Location;
	AimDir.Z = 0.0000000;
	AimDir = Normal(AimDir);
	RequiredAim = 0.9300000;
	B = UTBot(Controller);
	// End:0x117
	if(B != none)
	{
		RequiredAim += (0.0085000 * FClamp(B.Skill, 0.0000000, 7.0000000));
	}
	return (LookDir Dot AimDir) < RequiredAim;
	//return ReturnValue;	
}

simulated function Class<UTFamilyInfo> GetFamilyInfo()
{
	local UTPlayerReplicationInfo UTPRI;

	UTPRI = GetUTPlayerReplicationInfo();
	// End:0x42
	if(UTPRI != none)
	{
		return UTPRI.CharClassInfo;
	}
	return CurrCharClassInfo;
	//return ReturnValue;	
}

simulated function PostTeleport(Teleporter OutTeleporter)
{
	super(Actor).PostTeleport(OutTeleporter);
	BigTeleportCount++;
	PostBigTeleport();
	//return;	
}

simulated function PostBigTeleport()
{
	ForceUpdateComponents();
	Mesh.UpdateRBBonesFromSpaceBases(true, true);
	//return;	
}

exec function BackSpring(float LinSpring)
{
	local RB_BodyInstance BodyInst;
	local RB_BodySetup BodySetup;
	local int I;

	I = 0;
	J0x0B:

	// End:0x189 [Loop If]
	if(I < Mesh.PhysicsAsset.BodySetup.Length)
	{
		BodyInst = Mesh.PhysicsAssetInstance.Bodies[I];
		BodySetup = Mesh.PhysicsAsset.BodySetup[I];
		// End:0x17B
		if(BodySetup.BoneName == 'b_Spine2')
		{
			BodyInst.SetBoneSpringParams(LinSpring, BodyInst.BoneLinearDamping, 0.1000000 * LinSpring, BodyInst.BoneAngularDamping);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

exec function BackDamp(float LinDamp)
{
	local RB_BodyInstance BodyInst;
	local RB_BodySetup BodySetup;
	local int I;

	I = 0;
	J0x0B:

	// End:0x182 [Loop If]
	if(I < Mesh.PhysicsAsset.BodySetup.Length)
	{
		BodyInst = Mesh.PhysicsAssetInstance.Bodies[I];
		BodySetup = Mesh.PhysicsAsset.BodySetup[I];
		// End:0x174
		if(BodySetup.BoneName == 'b_Spine2')
		{
			BodyInst.SetBoneSpringParams(BodyInst.BoneLinearSpring, LinDamp, BodyInst.BoneAngularDamping, LinDamp);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

exec function HandSpring(float LinSpring)
{
	local RB_BodyInstance BodyInst;
	local RB_BodySetup BodySetup;
	local int I;

	I = 0;
	J0x0B:

	// End:0x1B7 [Loop If]
	if(I < Mesh.PhysicsAsset.BodySetup.Length)
	{
		BodyInst = Mesh.PhysicsAssetInstance.Bodies[I];
		BodySetup = Mesh.PhysicsAsset.BodySetup[I];
		// End:0x1A9
		if((BodySetup.BoneName == 'b_RightHand') || BodySetup.BoneName == 'b_LeftHand')
		{
			BodyInst.SetBoneSpringParams(LinSpring, BodyInst.BoneLinearDamping, 0.1000000 * LinSpring, BodyInst.BoneAngularDamping);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

exec function HandDamp(float LinDamp)
{
	local RB_BodyInstance BodyInst;
	local RB_BodySetup BodySetup;
	local int I;

	I = 0;
	J0x0B:

	// End:0x1B0 [Loop If]
	if(I < Mesh.PhysicsAsset.BodySetup.Length)
	{
		BodyInst = Mesh.PhysicsAssetInstance.Bodies[I];
		BodySetup = Mesh.PhysicsAsset.BodySetup[I];
		// End:0x1A2
		if((BodySetup.BoneName == 'b_RightHand') || BodySetup.BoneName == 'b_LeftHand')
		{
			BodyInst.SetBoneSpringParams(BodyInst.BoneLinearSpring, LinDamp, BodyInst.BoneAngularDamping, LinDamp);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

state FeigningDeath
{
	ignores SetMovementPhysics, AdjustCameraScale, ForceRagdoll, FaceRotation, SwitchWeapon, ServerHoverboard;

	simulated exec function FeignDeath()
	{
		// End:0x17
		if(bFeigningDeath)
		{
			global.FeignDeath();
		}
		//return;		
	}

	reliable server function ServerFeignDeath()
	{
		// End:0x8F
		if((((int(Role) == int(ROLE_Authority)) && WorldInfo.GRI.bMatchIsOver!) && IsTimerActive('FeignDeathDelayTimer')!) && bFeigningDeath)
		{
			bFeigningDeath = false;
			PlayFeignDeath();
		}
		//return;		
	}

	event bool EncroachingOn(Actor Other)
	{
		// End:0xA9
		if(ForcedDirVolume(Other) != none)
		{
			// End:0xA9
			if(ForcedDirVolume(Other).bBlockPawns && Other.ContainsPoint(Location))
			{
				TakeDamage(10000, Controller, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Crushed');
			}
		}
		return false;
		//return ReturnValue;		
	}

	simulated function bool CanThrowWeapon()
	{
		return false;
		//return ReturnValue;		
	}

	simulated function Tick(float DeltaTime)
	{
		local Rotator NewRotation;

		// End:0x10D
		if(bPlayingFeignDeathRecovery && PlayerController(Controller) != none)
		{
			NewRotation = Controller.Rotation;
			NewRotation.Yaw = RInterpTo(NewRotation, Rotation, DeltaTime, 2.0000000).Yaw;
			Controller.SetRotation(NewRotation);
			// End:0x10D
			if((WorldInfo.TimeSeconds - FeignDeathRecoveryStartTime) > 0.8000000)
			{
				CameraScale = 1.0000000;
			}
		}
		//return;		
	}

	simulated function bool CalcThirdPersonCam(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
	{
		local Vector CamStart, HitLocation, HitNormal, CamDir;
		local RB_BodyInstance RootBodyInst;
		local Matrix RootBodyTM;

		// End:0x66
		if(CurrentCameraScale < CameraScale)
		{
			CurrentCameraScale = FMin(CameraScale, CurrentCameraScale + ((float(5) * FMax(CameraScale - CurrentCameraScale, 0.3000000)) * fDeltaTime));			
		}
		else
		{
			// End:0xC9
			if(CurrentCameraScale > CameraScale)
			{
				CurrentCameraScale = FMax(CameraScale, CurrentCameraScale - ((float(5) * FMax(CameraScale - CurrentCameraScale, 0.3000000)) * fDeltaTime));
			}
		}
		CamStart = Mesh.GetPosition();
		// End:0x2B6
		if(Mesh.PhysicsAssetInstance != none)
		{
			RootBodyInst = Mesh.PhysicsAssetInstance.Bodies[Mesh.PhysicsAssetInstance.RootBodyIndex];
			// End:0x2B6
			if(RootBodyInst.IsValidBodyInstance())
			{
				RootBodyTM = RootBodyInst.GetUnrealWorldTM();
				CamStart.X = RootBodyTM.WPlane.X;
				CamStart.Y = RootBodyTM.WPlane.Y;
				CamStart.Z = RootBodyTM.WPlane.Z;
			}
		}
		CamStart += (vect(0.0000000, 0.0000000, 1.0000000) * BaseEyeHeight);
		CamDir = (Vector(out_CamRot) * (GetCollisionRadius())) * CurrentCameraScale;
		// End:0x364
		if(CamDir.Z > (GetCollisionHeight()))
		{
			CamDir *= Square(Cos(float(out_CamRot.Pitch) * 0.0000959));
		}
		out_CamLoc = CamStart - CamDir;
		// End:0x3D2
		if(Trace(HitLocation, HitNormal, out_CamLoc, CamStart, false, vect(12.0000000, 12.0000000, 12.0000000)) != none)
		{
			out_CamLoc = HitLocation;
		}
		return true;
		//return ReturnValue;		
	}

	simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
		// End:0x6B
		if((int(Physics) != int(10)) && bPlayingFeignDeathRecovery!)
		{
			// End:0x5D
			if(FeignDeathBlend != none)
			{
				FeignDeathBlend.SetBlendTarget(0.0000000, 0.5000000);
			}
			GotoState('Auto');
		}
		//return;		
	}

	simulated event BeginState(name PreviousStateName)
	{
		local UTPlayerController PC;
		local UTWeapon UTWeap;

		PC = UTPlayerController(Controller);
		bCanPickupInventory = false;
		StopFiring();
		bNoWeaponFiring = true;
		UTWeap = UTWeapon(Weapon);
		// End:0x88
		if(UTWeap != none)
		{
			UTWeap.PlayWeaponPutDown();
		}
		// End:0xC7
		if((UTWeap != none) && PC != none)
		{
			PC.EndZoom();
		}
		// End:0x114
		if(PC != none)
		{
			PC.SetBehindView(true);
			CurrentCameraScale = 1.5000000;
			CameraScale = 2.2500000;
		}
		DropFlag();
		//return;		
	}

	simulated function EndState(name NextStateName)
	{
		local UTPlayerController PC;
		local UTPawn P;
		local Actor A;

		// End:0x213
		if(NextStateName != 'Dying')
		{
			bNoWeaponFiring = default.bNoWeaponFiring;
			bCanPickupInventory = default.bCanPickupInventory;
			// End:0x118
			foreach TouchingActors(Class'Engine.Actor', A)
			{
				// End:0x117
				if(((DroppedPickup(A) != none) || PickupFactory(A) != none) || UTCarriedObject(A) != none)
				{
					A.Touch(self, CylinderComponent, A.Location, Normal(Location - A.Location));
				}				
			}			
			global.SetMovementPhysics();
			PC = UTPlayerController(Controller);
			// End:0x18C
			if(PC != none)
			{
				PC.SetBehindView(PC.default.bBehindView);
			}
			CurrentCameraScale = default.CurrentCameraScale;
			CameraScale = default.CameraScale;
			bForcedFeignDeath = false;
			bPlayingFeignDeathRecovery = false;
			// End:0x212
			foreach TouchingActors(Class'UTGame.UTPawn', P)
			{
				// End:0x211
				if(P.IsInState('FeigningDeath'))
				{
					JumpOffPawn();
				}				
			}			
		}
		//return;		
	}
	stop;	
}

simulated state Dying
{
	ignores ServerFeignDeath, FeignDeath, FellOutOfWorld, ForceRagdoll, StartFeignDeathRecoveryAnim, BreathTimer, 
		Falling, PhysicsVolumeChange, HeadVolumeChange, HitWall, Bump, 
		OnAnimEnd;

	event bool EncroachingOn(Actor Other)
	{
		return false;
		//return ReturnValue;		
	}

	event Timer()
	{
		local PlayerController PC;
		local bool bBehindAllPlayers;
		local Vector ViewLocation;
		local Rotator ViewRotation;

		// End:0x6E
		if((WorldInfo.GRI != none) && WorldInfo.GRI.bMatchIsOver)
		{
			LifeSpan = 0.0000000;
			return;
		}
		// End:0x7C
		if(PlayerCanSeeMe()!)
		{
			Destroy();
			return;
		}
		bBehindAllPlayers = true;
		// End:0x193
		foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
		{
			// End:0x129
			if((PC.ViewTarget == self) || PC.ViewTarget == Base)
			{
				// End:0x11B
				if(LifeSpan < 3.5000000)
				{
					LifeSpan = 3.5000000;
				}
				SetTimer(2.0000000, false);				
				return;
			}
			PC.GetPlayerViewPoint(ViewLocation, ViewRotation);
			// End:0x192
			if(((Location - ViewLocation) Dot Vector(ViewRotation)) > float(0))
			{
				bBehindAllPlayers = false;
				// End:0x193
				break;
			}			
		}		
		// End:0x1A6
		if(bBehindAllPlayers)
		{
			Destroy();
			return;
		}
		SetTimer(2.0000000, false);
		//return;		
	}

	simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
	{
		local Vector LookAt;
		local Class<UTDamageType> UTDamage;

		UTDamage = Class<UTDamageType>(HitDamageType);
		// End:0x1C7
		if((UTDamage == none) || UTDamage.default.bSpecialDeathCamera!)
		{
			CalcThirdPersonCam(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);
			bStopDeathCamera = bStopDeathCamera || out_CamLoc.Z < WorldInfo.KillZ;
			// End:0x1AF
			if(bStopDeathCamera && OldCameraPosition != vect(0.0000000, 0.0000000, 0.0000000))
			{
				out_CamLoc = OldCameraPosition;
				LookAt = Location;
				CameraZOffset = ((fDeltaTime < 0.2000000) ? (float(1) - (float(5) * fDeltaTime)) * CameraZOffset : 0.0000000);
				LookAt.Z += CameraZOffset;
				out_CamRot = Rotator(LookAt - out_CamLoc);
			}
			OldCameraPosition = out_CamLoc;
			return true;			
		}
		else
		{
			UTDamage.static.CalcDeathCamera(self, fDeltaTime, out_CamLoc, out_CamRot, out_FOV);
			return true;
		}
		//return ReturnValue;		
	}

	simulated event Landed(Vector HitNormal, Actor FloorActor)
	{
		local Vector BounceDir;

		// End:0xC3
		if(Velocity.Z < float(-500))
		{
			BounceDir = 0.5000000 * (Velocity - ((2.0000000 * HitNormal) * (Velocity Dot HitNormal)));
			TakeDamage(int(float(1) - (Velocity.Z / float(30))), Controller, Location, BounceDir, Class'Engine.DmgType_Crushed');
		}
		//return;		
	}

	simulated event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
	{
		local Vector ShotDir, ApplyImpulse, BloodMomentum;
		local Class<UTDamageType> UTDamage;
		local UTEmit_HitEffect HitEffect;

		// End:0x99
		if(Class'UTGame.UTGame'.static.UseLowGore(WorldInfo))
		{
			// End:0x97
			if(bGibbed!)
			{
				UTDamage = Class<UTDamageType>(DamageType);
				// End:0x97
				if((UTDamage != none) && ShouldGib(UTDamage))
				{
					bTearOffGibs = true;
					bGibbed = true;
				}
			}
			return;
		}
		// End:0xE7
		if(DeathAnimDamageType != none)
		{
			// End:0xE7
			if(DamageType == DeathAnimDamageType)
			{
				TimeLastTookDeathAnimDamage = WorldInfo.TimeSeconds;
			}
		}
		// End:0x6EF
		if(bGibbed! && (InstigatedBy != none) || EffectIsRelevant(Location, true, 0.0000000))
		{
			UTDamage = Class<UTDamageType>(DamageType);
			// End:0x1A5
			if(AccumulationTime != WorldInfo.TimeSeconds)
			{
				AccumulateDamage = 0.0000000;
				AccumulationTime = WorldInfo.TimeSeconds;
			}
			AccumulateDamage += float(Damage);
			Health -= Damage;
			// End:0x6EF
			if(UTDamage != none)
			{
				// End:0x265
				if(ShouldGib(UTDamage))
				{
					// End:0x246
					if(bHideOnListenServer || int(WorldInfo.NetMode) == int(NM_DedicatedServer))
					{
						bTearOffGibs = true;
						bGibbed = true;
						return;
					}
					SpawnGibs(UTDamage, HitLocation);					
				}
				else
				{
					// End:0x6EF
					if(bHideOnListenServer! && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
					{
						CheckHitInfo(HitInfo, Mesh, Normal(Momentum), HitLocation);
						UTDamage.static.SpawnHitEffect(self, float(Damage), Momentum, HitInfo.BoneName, HitLocation);
						// End:0x4A0
						if((UTDamage.default.bCausesBlood && Class'UTGame.UTGame'.static.UseLowGore(WorldInfo)!) && (PlayerController(Controller) == none) || int(WorldInfo.NetMode) != int(NM_Standalone))
						{
							BloodMomentum = Momentum;
							// End:0x418
							if(BloodMomentum.Z > float(0))
							{
								BloodMomentum.Z *= 0.5000000;
							}
							HitEffect = Spawn(static.GetFamilyInfo().default.BloodEmitterClass, self,, HitLocation, Rotator(BloodMomentum));
							HitEffect.AttachTo(self, HitInfo.BoneName);
						}
						// End:0x556
						if((UTDamage.default.DamageOverlayTime > float(0)) && UTDamage.default.DamageBodyMatColor != Class'UTGame.UTDamageType'.default.DamageBodyMatColor)
						{
							SetBodyMatColor(UTDamage.default.DamageBodyMatColor, UTDamage.default.DamageOverlayTime);
						}
						// End:0x5B5
						if(((int(Physics) != int(10)) || Momentum == vect(0.0000000, 0.0000000, 0.0000000)) || HitInfo.BoneName == 'None')
						{
							return;
						}
						ShotDir = Normal(Momentum);
						ApplyImpulse = DamageType.default.KDamageImpulse * ShotDir;
						// End:0x681
						if(UTDamage.default.bThrowRagdoll && Velocity.Z > float(-10))
						{
							ApplyImpulse += (vect(0.0000000, 0.0000000, 1.0000000) * DamageType.default.KDeathUpKick);
						}
						Mesh.WakeRigidBody();
						Mesh.AddImpulse(ApplyImpulse, HitLocation, HitInfo.BoneName, true);
					}
				}
			}
		}
		//return;		
	}

	simulated event Tick(float DeltaSeconds)
	{
		local float BurnLevel;
		local int I;
		local MaterialInstanceConstant MyMIC;

		// End:0x2E
		if(bKilledByBio! || Mesh == none)
		{
			Disable('Tick');			
		}
		else
		{
			BurnLevel = FMin(((WorldInfo.TimeSeconds - DeathTime) / BioBurnAwayTime) * 10.0000000, 9.8999996);
			I = 0;
			J0x85:

			// End:0x13B [Loop If]
			if(I < Mesh.Materials.Length)
			{
				MyMIC = MaterialInstanceConstant(Mesh.Materials[I]);
				// End:0x12D
				if(MyMIC != none)
				{
					MyMIC.SetScalarParameterValue(BioEffectName, BurnLevel);
				}
				I++;
				// [Loop Continue]
				goto J0x85;
			}
			// End:0x184
			if(BurnLevel >= 9.8999996)
			{
				BioBurnAway.DeactivateSystem();
				bKilledByBio = false;
				Disable('Tick');
			}
		}
		//return;		
	}

	simulated function BeginState(name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		CustomGravityScaling = 1.0000000;
		DeathTime = WorldInfo.TimeSeconds;
		CylinderComponent.SetActorCollision(false, false);
		// End:0xC5
		if(bTearOff && bHideOnListenServer || int(WorldInfo.NetMode) == int(NM_DedicatedServer))
		{
			LifeSpan = 1.0000000;			
		}
		else
		{
			// End:0x138
			if(Mesh != none)
			{
				Mesh.SetTraceBlocking(true, true);
				Mesh.SetActorCollision(true, false);
				Mesh.SetTickGroup(2);
			}
			SetTimer(2.0000000, false);
			LifeSpan = RagdollLifespan;
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	bStopOnDoubleLanding=true
	bWeaponBob=true
	bWeaponAttachmentVisible=true
	// Reference: DynamicLightEnvironmentComponent'UTGame.Default__UTPawn.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	begin object name="MyLightEnvironment" class=Engine.DynamicLightEnvironmentComponent
		InvisibleUpdateTime=1.0000000
		MinTimeBetweenFullUpdates=0.2000000
		bUseBooleanEnvironmentShadowing=false
		bSynthesizeSHLight=true
		bIsCharacterLightEnvironment=true
	end object
	LightEnvironment=MyLightEnvironment
	DeathHipLinSpring=10000.0000000
	DeathHipLinDamp=500.0000000
	DeathHipAngSpring=10000.0000000
	DeathHipAngDamp=500.0000000
	CameraScale=9.0000000
	CurrentCameraScale=1.0000000
	CameraScaleMin=3.0000000
	CameraScaleMax=40.0000000
	HeroCameraScale=6.0000000
	HeroCameraPitch=6000
	DodgeSpeed=600.0000000
	DodgeSpeedZ=295.0000000
	DoubleJumpEyeHeight=43.0000000
	DoubleJumpThreshold=160.0000000
	DefaultAirControl=0.3500000
	Bob=0.0100000
	FeignDeathBodyAtRestSpeed=12.0000000
	SuperHealthMax=199
	SoundGroupClass=Class'UTGame.UTPawnSoundGroup'
	// Reference: ForceFeedbackWaveform'UTGame.Default__UTPawn.ForceFeedbackWaveformFall'
	begin object name="ForceFeedbackWaveformFall" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=50,RightAmplitude=40,LeftFunction=EWaveformFunction.WF_Sin90to180,RightFunction=EWaveformFunction.WF_Sin90to180,Duration=0.2000000)
	end object
	FallingDamageWaveForm=ForceFeedbackWaveformFall
	MinHoverboardInterval=0.7000000
	WeaponSocket="WeaponPoint"
	WeaponSocket2="DualWeaponPoint"
	PawnEffectSockets[0]="L_JB"
	PawnEffectSockets[1]="R_JB"
	HeadOffset=32.0000000
	HeadRadius=9.0000000
	HeadHeight=5.0000000
	HeadBone="b_head"
	HipsBone="b_Hips"
	TransInEffects[0]=Class'UTGame.UTEmit_TransLocateOutRed'
	TransInEffects[1]=Class'UTGame.UTEmit_TransLocateOut'
	TranslocateColor[0]=(R=1.0000000,G=0.0000000,B=0.0000000,A=20.0000000)
	TranslocateColor[1]=(R=1.0000000,G=20.0000000,B=0.0000000,A=0.0000000)
	TransCameraAnim[0]=CameraAnim'Envy_Effects.Camera_Shakes.C_Res_IN_Red'
	TransCameraAnim[1]=CameraAnim'Envy_Effects.Camera_Shakes.C_Res_IN_Blue'
	TransCameraAnim[2]=CameraAnim'Envy_Effects.Camera_Shakes.C_Res_IN'
	SpawnProtectionColor=(R=1.0000000,G=0.0000000,B=40.0000000,A=40.0000000)
	TeamBeaconPlayerInfoMaxDist=3000.0000000
	MapSize=1.0000000
	IconCoords=(U=657.0000000,V=129.0000000,UL=68.0000000,VL=58.0000000)
	LastPainSound=-1000.0000000
	RagdollLifespan=18.0000000
	MaxFootstepDistSq=9000000.0000000
	MaxJumpSoundDistSq=16000000.0000000
	HoverboardClass=Class'UTGame.UTVehicle_Hoverboard'
	ShieldBeltMaterialInstance=Material'Pickups.Armor_ShieldBelt.M_ShieldBelt_Overlay'
	ShieldBeltTeamMaterialInstances[0]=Material'Pickups.Armor_ShieldBelt.M_ShieldBelt_Red'
	ShieldBeltTeamMaterialInstances[1]=Material'Pickups.Armor_ShieldBelt.M_ShieldBelt_Blue'
	ShieldBeltTeamMaterialInstances[2]=Material'Pickups.Armor_ShieldBelt.M_ShieldBelt_Red'
	ShieldBeltTeamMaterialInstances[3]=Material'Pickups.Armor_ShieldBelt.M_ShieldBelt_Blue'
	DefaultMeshScale=1.0750000
	TauntNames[0]="TauntA"
	TauntNames[1]="TauntB"
	TauntNames[2]="TauntC"
	TauntNames[3]="TauntD"
	TauntNames[4]="TauntE"
	TauntNames[5]="TauntF"
	CamOffset=(X=-13.0000000,Y=16.0000000,Z=4.0000000)
	bCanDoubleJump=true
	bEnableFootPlacement=true
	MaxDoubleJumpHeight=87.0000000
	MultiJumpRemaining=1
	MaxMultiJump=1
	MultiJumpBoost=-45
	MinTimeBetweenEmotes=1.0000000
	FireRateMultiplier=1.0000000
	HeadScale=1.0000000
	// Reference: UTAmbientSoundComponent'UTGame.Default__UTPawn.AmbientSoundComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'AmbientSoundComponent'
	begin object name="AmbientSoundComponent" class=UTGame.UTAmbientSoundComponent
	end object
	PawnAmbientSound=AmbientSoundComponent
	// Reference: UTAmbientSoundComponent'UTGame.Default__UTPawn.AmbientSoundComponent2'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'AmbientSoundComponent2'
	begin object name="AmbientSoundComponent2" class=UTGame.UTAmbientSoundComponent
	end object
	WeaponAmbientSound=AmbientSoundComponent2
	TorsoBoneName="b_Spine2"
	FallSpeedThreshold=125.0000000
	// Reference: SkeletalMeshComponent'UTGame.Default__UTPawn.OverlayMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'OverlayMeshComponent0'
	begin object name="OverlayMeshComponent0" class=Engine.SkeletalMeshComponent
		bUpdateSkelWhenNotRendered=false
		bPerBoneMotionBlur=true
		bOverrideAttachmentOwnerVisibility=true
		ReplacementPrimitive=none
		bOwnerNoSee=true
		CastShadow=false
		Scale=1.0150000
		TickGroup=ETickingGroup.TG_PostAsyncWork
	end object
	OverlayMesh=OverlayMeshComponent0
	LeftFootControlName="LeftFootControl"
	RightFootControlName="RightFootControl"
	BaseTranslationOffset=6.0000000
	MaxFootPlacementDistSquared=56250000.0000000
	DamageParameterName="DamageOverlay"
	SaturationParameterName="Char_DistSatRangeMultiplier"
	TeamBeaconMaxDist=3000.0000000
	SlopeBoostFriction=0.2000000
	MaxLeanRoll=2048
	FeignDeathPhysicsBlendOutSpeed=2.0000000
	SwimmingZOffset=-30.0000000
	SwimmingZOffsetSpeed=45.0000000
	TakeHitPhysicsBlendOutSpeed=0.5000000
	// Refer[0]ence: UDKSkeletalMeshComponent'UTGame.Default__UTPawn.FirstPersonArms'
	begin object name="FirstPersonArms" class=UDKBase.UDKSkeletalMeshComponent
		FOV=55.0000000
		Animations=AnimNodeSequence'UTGame.Default__UTPawn.MeshSequenceA'
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=true
		bSyncActorLocationToRootRigidBody=false
		bOverrideAttachmentOwnerVisibility=true
		ReplacementPrimitive=none
		DepthPriorityGroup=ESceneDepthPriorityGroup.SDPG_Foreground
		bOnlyOwnerSee=true
		CastShadow=false
		AbsoluteRotation=true
		AbsoluteScale=true
		TickGroup=ETickingGroup.TG_DuringAsyncWork
	end object
	ArmsMesh=FirstPersonArms
	// Reference: UDKSkeletalMeshComponent'UTGame.Default__UTPawn.FirstPersonArms2'
	begin object name="FirstPersonArms2" class=UDKBase.UDKSkeletalMeshComponent
		FOV=55.0000000
		Animations=AnimNodeSequence'UTGame.Default__UTPawn.MeshSequenceB'
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=true
		bSyncActorLocationToRootRigidBody=false
		bOverrideAttachmentOwnerVisibility=true
		ReplacementPrimitive=none
		DepthPriorityGroup=ESceneDepthPriorityGroup.SDPG_Foreground
		HiddenGame=true
		bOnlyOwnerSee=true
		CastShadow=false
		AbsoluteRotation=true
		AbsoluteScale=true
		Scale3D=(X=1.0000000,Y=-1.0000000,Z=1.0000000)
		TickGroup=ETickingGroup.TG_DuringAsyncWork
	end object
	ArmsMesh=FirstPersonArms2
	// Reference: GwNavBotHandle'UTGame.Default__UTPawn.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'UDKBase.Default__UDKPawn.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	MaxStepHeight=26.0000000
	MaxJumpHeight=49.0000000
	WalkableFloorZ=0.7800000
	bCanCrouch=true
	bCanSwim=true
	bCanClimbLadders=true
	bCanStrafe=true
	bCanPickupInventory=true
	bMuffledHearing=true
	bRunPhysicsWithNoController=true
	CrouchHeight=29.0000000
	CrouchRadius=21.0000000
	AwareRadius=12000.0000000
	SightRadius=12000.0000000
	Buoyancy=0.9900000
	MeleeRange=20.0000000
	GroundSpeed=440.0000000
	WaterSpeed=220.0000000
	AirSpeed=440.0000000
	JumpZ=322.0000000
	AirControl=0.3500000
	WalkingPct=0.4000000
	CrouchedPct=0.4000000
	MaxFallSpeed=1250.0000000
	AIMaxFallSpeedFactor=1.1000000
	BaseEyeHeight=38.0000000
	EyeHeight=38.0000000
	UnderWaterTime=20.0000000
	ControllerClass=Class'UTGame.UTBot'
	// Reference: SkeletalMeshComponent'UTGame.Default__UTPawn.WPawnSkeletalMeshComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'WPawnSkeletalMeshComponent'
	begin object name="WPawnSkeletalMeshComponent" class=Engine.SkeletalMeshComponent
		MinDistFactorForKinematicUpdate=0.2000000
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=true
		bHasPhysicsAssetInstance=true
		bPerBoneMotionBlur=true
		bOverrideAttachmentOwnerVisibility=true
		bChartDistanceFactor=true
		bCacheAnimSequenceNodes=false
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'UTGame.Default__UTPawn.MyLightEnvironment'
		RBChannel=ERBCollisionChannel.RBCC_Untitled3
		RBDominanceGroup=20
		bOwnerNoSee=true
		bUseOnePassLightingOnTranslucency=true
		BlockRigidBody=true
		RBCollideWithChannels=(Untitled3=true)
		Translation=(X=8.0000000,Y=0.0000000,Z=0.0000000)
		Scale=1.0750000
	end object
	Mesh=WPawnSkeletalMeshComponent
	// Reference: CylinderComponent'UTGame.Default__UTPawn.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'UDKBase.Default__UDKPawn.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=44.0000000
		CollisionRadius=21.0000000
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	AlwaysRelevantDistanceSquared=1960000.0000000
	ViewPitchMin=-18000.0000000
	ViewPitchMax=18000.0000000
	InventoryManagerClass=Class'UTGame.UTInventoryManager'
	Components[0]=CollisionCylinder
	Components[1]=none
	Components[2]=myGwNavBotHandle
	Components[3]=MyLightEnvironment
	Components[4]=WPawnSkeletalMeshComponent
	Components[5]=AmbientSoundComponent
	Components[6]=AmbientSoundComponent2
	bReplicateRigidBodyLocation=true
	bPhysRigidBodyOutOfWorldCheck=true
	CollisionComponent=CollisionCylinder
}