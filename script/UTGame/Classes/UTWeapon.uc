class UTWeapon extends UDKWeapon
	abstract
	config(Weapon)
	dependson(UTPlayerController);

enum EZoomState
{
	ZST_NotZoomed,                  // 0
	ZST_ZoomingOut,                 // 1
	ZST_ZoomingIn,                  // 2
	ZST_Zoomed,                     // 3
	ZST_MAX                         // 4
};

enum AmmoWidgetDisplayStyle
{
	EAWDS_Numeric,                  // 0
	EAWDS_BarGraph,                 // 1
	EAWDS_Both,                     // 2
	EAWDS_None,                     // 3
	EAWDS_MAX                       // 4
};

var bool bExportMenuData;
var bool bWasLocked;
var bool bShouldDrawCrosshairDropShadow;
var bool bCrosshairShouldHighlightOnValidTarget;
var bool bCrosshairIsOverValidTarget;
var config bool bUseCustomCoordinates;
var globalconfig bool bSmallWeapons;
var bool bSuperWeapon;
var bool bNeverForwardPendingFire;
var bool bSuppressSounds;
var bool bUsesOffhand;
var bool bPendingShow;
var bool bShowAltMuzzlePSCWhenWeaponHidden;
var bool bMuzzleFlashPSCLoops;
var bool bMuzzleFlashAttached;
var bool bSplashJump;
var bool bRecommendSplashDamage;
var bool bSniping;
var bool bFastRepeater;
var bool bLockedAimWhileFiring;
var bool bUsingAimingHelp;
var bool bAllowFiringWithoutController;
var config bool bTargetFrictionEnabled;
var config bool bTargetAdhesionEnabled;
var bool bForceHidden;
var bool bHasLocationSpeech;
var Class<UTAmmoPickupFactory> AmmoPickupClass;
var int LockerAmmoCount;
var int MaxAmmoCount;
var array<int> ShotCost;
var array<float> MinReloadPct;
var array<CameraAnim> FireCameraAnim;
var ForceFeedbackWaveform WeaponFireWaveForm;
var array<name> EffectSockets;
var int IconX;
var int IconY;
var int iconWidth;
var int iconHeight;
var float SwitchAbortTime;
var TextureCoordinates IconCoordinates;
var TextureCoordinates CrossHairCoordinates;
var TextureCoordinates SimpleCrossHairCoordinates;
var Texture2D CrosshairImage;
var TextureCoordinates LockedCrossHairCoordinates;
var float CurrentLockedScale;
var float StartLockedScale;
var float FinalLockedScale;
var float LockedScaleTime;
var float LockedStartTime;
var float LastHitEnemyTime;
var config Color CrosshairColor;
var string WeaponName;
var string HUDFrameName;
var float CrosshairScaling;
var config TextureCoordinates CustomCrosshairCoordinates;
var float DroppedPickupOffsetZ;
var array<byte> bZoomedFireMode;
var byte ZoomedFireModeNum;
var byte InventoryGroup;
var UTWeapon.AmmoWidgetDisplayStyle AmmoDisplayType;
var float ZoomedTargetFOV;
var float ZoomedRate;
var float ZoomFadeTime;
var SoundCue ZoomInSound;
var SoundCue ZoomOutSound;
var Class<UTWeaponAttachment> AttachmentClass;
var Vector PivotTranslation;
var float GroupWeight;
var float InventoryWeight;
var array<name> WeaponFireAnim;
var array<name> ArmFireAnim;
var AnimSet ArmsAnimSet;
var name WeaponPutDownAnim;
var name ArmsPutDownAnim;
var name WeaponEquipAnim;
var name ArmsEquipAnim;
var array<name> WeaponIdleAnims;
var array<name> ArmIdleAnims;
var array<SoundCue> WeaponFireSnd;
var SoundCue WeaponPutDownSnd;
var SoundCue WeaponEquipSnd;
var float BobDamping;
var float JumpDamping;
var float MaxPitchLag;
var float MaxYawLag;
var float LastRotUpdate;
var Rotator LastRotation;
var float OldLeadMag[2];
var int OldRotDiff[2];
var float OldMaxDiff[2];
var float RotChgSpeed;
var float ReturnChgSpeed;
var Color WeaponColor;
var float WeaponCanvasXPct;
var float WeaponCanvasYPct;
var name MuzzleFlashSocket;
var export editinline UTParticleSystemComponent MuzzleFlashPSC;
var ParticleSystem MuzzleFlashPSCTemplate;
var ParticleSystem MuzzleFlashAltPSCTemplate;
var Color MuzzleFlashColor;
var export editinline UDKExplosionLight MuzzleFlashLight;
var Class<UDKExplosionLight> MuzzleFlashLightClass;
var float MuzzleFlashDuration;
var Vector PlayerViewOffset;
var Vector SmallWeaponsOffset;
var float WideScreenOffsetScaling;
var Rotator WidescreenRotationOffset;
var Vector HiddenWeaponsOffset;
var float ProjectileSpawnOffset;
var Rotator LockerRotation;
var Vector LockerOffset;
var float CurrentRating;
var float aimerror;
var ObjectiveAnnouncementInfo NeedToPickUpAnnouncement;
var float AimingHelpRadius[2];
var config float ZoomedTurnSpeedScalePct;
var config float TargetFrictionDistanceMin;
var config float TargetFrictionDistancePeak;
var config float TargetFrictionDistanceMax;
var config InterpCurveFloat TargetFrictionDistanceCurve;
var config Vector2D TargetFrictionMultiplierRange;
var config float TargetFrictionPeakRadiusScale;
var config float TargetFrictionPeakHeightScale;
var config Vector TargetFrictionOffset;
var config float TargetFrictionZoomedBoostValue;
var config float TargetAdhesionTimeMax;
var config float TargetAdhesionDistanceMax;
var config float TargetAdhesionAimDistY;
var config float TargetAdhesionAimDistZ;
var config Vector2D TargetAdhesionScaleRange;
var config float TargetAdhesionScaleAmountMin;
var config float TargetAdhesionTargetVelocityMin;
var config float TargetAdhesionPlayerVelocityMin;
var config float TargetAdhesionZoomedBoostValue;
var array<SoundNodeWave> LocationSpeech;
var const localized string UseHintString;

reliable server function ServerStartFire(byte FireModeNum)
{
	// End:0x57
	if(((Instigator == none) || Instigator.Controller != none) || bAllowFiringWithoutController)
	{
		super(Weapon).ServerStartFire(FireModeNum);
	}
	//return;	
}

simulated function PostBeginPlay()
{
	local UTGameReplicationInfo GRI;

	super.PostBeginPlay();
	CalcInventoryWeight();
	GRI = UTGameReplicationInfo(WorldInfo.GRI);
	// End:0x82
	if((GRI != none) && GRI.bConsoleServer)
	{
		AdjustWeaponTimingForConsole();
	}
	// End:0xD0
	if(Mesh != none)
	{
		Mesh.CastShadow = Class'UTGame.UTPlayerController'.default.bFirstPersonWeaponsSelfShadow;
	}
	bConsiderProjectileAcceleration = bConsiderProjectileAcceleration && ((WeaponProjectiles[0] != none) && Class<UTProjectile>(WeaponProjectiles[0]).default.AccelRate > float(0)) || (WeaponProjectiles[1] != none) && Class<UTProjectile>(WeaponProjectiles[1]).default.AccelRate > float(0);
	bSmallWeapons = Class'UTGame.UTWeapon'.default.bSmallWeapons;
	// End:0x1BB
	if(bUseCustomCoordinates)
	{
		SimpleCrossHairCoordinates = CustomCrosshairCoordinates;
	}
	//return;	
}

simulated function AdjustWeaponTimingForConsole()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x5F [Loop If]
	if(I < FireInterval.Length)
	{
		FireInterval[I] = FireInterval[I] / 1.1000000;
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	EquipTime = EquipTime / 1.1000000;
	PutDownTime = PutDownTime / 1.1000000;
	//return;	
}

simulated function CreateOverlayMesh()
{
	local editinline SkeletalMeshComponent SKM_Source, SKM_Target;
	local editinline StaticMeshComponent STM;
	local UTPawn P;

	// End:0x516
	if(((OverlayMesh == none) && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && Mesh != none)
	{
		// End:0xC7
		if(int(WorldInfo.NetMode) != int(NM_Client))
		{
			P = UTPawn(Instigator);
			// End:0xC7
			if((P == none) || !P.bUpdateEyeheight)
			{
				return;
			}
		}
		OverlayMesh = new (Outer) Mesh.Class;
		// End:0x4D8
		if(OverlayMesh != none)
		{
			OverlayMesh.SetScale(1.0000000);
			OverlayMesh.SetOwnerNoSee(Mesh.bOwnerNoSee);
			OverlayMesh.SetOnlyOwnerSee(true);
			OverlayMesh.SetDepthPriorityGroup(2);
			OverlayMesh.CastShadow = false;
			SKM_Target = SkeletalMeshComponent(OverlayMesh);
			// End:0x365
			if(SKM_Target != none)
			{
				SKM_Source = SkeletalMeshComponent(Mesh);
				SKM_Target.SetSkeletalMesh(SKM_Source.SkeletalMesh);
				SKM_Target.AnimSets = SKM_Source.AnimSets;
				SKM_Target.SetParentAnimComponent(SKM_Source);
				SKM_Target.bUpdateSkelWhenNotRendered = false;
				SKM_Target.bIgnoreControllersWhenNotRendered = true;
				// End:0x362
				if(UDKSkeletalMeshComponent(SKM_Target) != none)
				{
					UDKSkeletalMeshComponent(SKM_Target).SetFOV(UDKSkeletalMeshComponent(SKM_Source).FOV);
				}				
			}
			else
			{
				// End:0x497
				if(StaticMeshComponent(OverlayMesh) != none)
				{
					STM = StaticMeshComponent(OverlayMesh);
					STM.SetStaticMesh(StaticMeshComponent(Mesh).StaticMesh);
					STM.SetScale3D(Mesh.Scale3D);
					STM.SetTranslation(Mesh.Translation);
					STM.SetRotation(Mesh.Rotation);
				}
			}
			OverlayMesh.SetHidden(Mesh.HiddenGame);			
		}
		else
		{
			WarnInternal(("Could not create Weapon Overlay mesh for" @ string(self)) @ string(Mesh));
		}
	}
	//return;	
}

simulated event ReplicatedEvent(name VarName)
{
	// End:0x33
	if(VarName == 'AmmoCount')
	{
		// End:0x30
		if(!HasAnyAmmo())
		{
			WeaponEmpty();
		}		
	}
	else
	{
		// End:0x75
		if(VarName == 'HitEnemy')
		{
			LastHitEnemyTime = WorldInfo.TimeSeconds;			
		}
		else
		{
			super(Actor).ReplicatedEvent(VarName);
		}
	}
	//return;	
}

simulated function CalcInventoryWeight()
{
	InventoryWeight = float((int(InventoryGroup) + int(1)) * 1000) + (GroupWeight * float(100));
	// End:0x59
	if(Priority < float(0))
	{
		Priority = InventoryWeight;
	}
	//return;	
}

simulated function bool ShouldSwitchTo(UTWeapon InWeapon)
{
	// End:0x52
	if((IsFiring()) || DenyClientWeaponSet())
	{
		UTInventoryManager(InvManager).RetrySwitchTo(InWeapon);
		return false;		
	}
	else
	{
		return true;
	}
	//return ReturnValue;	
}

simulated function SetSkin(Material NewMaterial)
{
	local int I, Cnt;

	// End:0x18A
	if(NewMaterial == none)
	{
		// End:0xE0
		if(default.Mesh.Materials.Length > 0)
		{
			Cnt = default.Mesh.Materials.Length;
			I = 0;
			J0x68:

			// End:0xDD [Loop If]
			if(I < Cnt)
			{
				Mesh.SetMaterial(I, default.Mesh.GetMaterial(I));
				I++;
				// [Loop Continue]
				goto J0x68;
			}			
		}
		else
		{
			// End:0x187
			if(Mesh.Materials.Length > 0)
			{
				Cnt = Mesh.Materials.Length;
				I = 0;
				J0x139:

				// End:0x187 [Loop If]
				if(I < Cnt)
				{
					Mesh.SetMaterial(I, none);
					I++;
					// [Loop Continue]
					goto J0x139;
				}
			}
		}		
	}
	else
	{
		// End:0x2A6
		if((default.Mesh.Materials.Length > 0) || Mesh.GetNumElements() > 0)
		{
			Cnt = ((default.Mesh.Materials.Length > 0) ? default.Mesh.Materials.Length : Mesh.GetNumElements());
			I = 0;
			J0x250:

			// End:0x2A6 [Loop If]
			if(I < Cnt)
			{
				Mesh.SetMaterial(I, NewMaterial);
				I++;
				// [Loop Continue]
				goto J0x250;
			}
		}
	}
	//return;	
}

simulated function ActiveRenderOverlays(HUD H)
{
	local UTPlayerController PC;

	PC = UTPlayerController(Instigator.Controller);
	// End:0xB9
	if((PC != none) && !PC.bNoCrosshair)
	{
		CrossHairCoordinates = ((PC.bSimpleCrosshair) ? SimpleCrossHairCoordinates : default.CrossHairCoordinates);
		DrawWeaponCrosshair(H);
	}
	//return;	
}

simulated function DrawWeaponCrosshair(HUD HUD)
{
	local Vector2D CrosshairSize;
	local float X, Y, PickupScale, ScreenX, ScreenY;

	local UTHUDBase H;
	local float TargetDist;

	H = UTHUDBase(HUD);
	// End:0x2D
	if(H == none)
	{
		return;
	}
	TargetDist = GetTargetDistance();
	// End:0x188
	if(H.LastPickupTime > (WorldInfo.TimeSeconds - 0.3000000))
	{
		// End:0x129
		if(H.LastPickupTime > (WorldInfo.TimeSeconds - 0.1500000))
		{
			PickupScale = 1.0000000 + (float(5) * (WorldInfo.TimeSeconds - H.LastPickupTime));			
		}
		else
		{
			PickupScale = 1.0000000 + (float(5) * ((H.LastPickupTime + 0.3000000) - WorldInfo.TimeSeconds));
		}		
	}
	else
	{
		PickupScale = 1.0000000;
	}
	CrosshairSize.Y = ((((H.ConfiguredCrosshairScaling * CrosshairScaling) * CrossHairCoordinates.VL) * PickupScale) * H.Canvas.ClipY) / float(720);
	CrosshairSize.X = CrosshairSize.Y * (CrossHairCoordinates.UL / CrossHairCoordinates.VL);
	X = H.Canvas.ClipX * 0.5000000;
	Y = H.Canvas.ClipY * 0.5000000;
	ScreenX = X - (CrosshairSize.X * 0.5000000);
	ScreenY = Y - (CrosshairSize.Y * 0.5000000);
	// End:0x7F6
	if(CrosshairImage != none)
	{
		// End:0x560
		if(bShouldDrawCrosshairDropShadow)
		{
			H.Canvas.DrawColor = H.BlackColor;
			H.Canvas.SetPos(ScreenX + float(1), ScreenY + float(1), TargetDist);
			H.Canvas.DrawTile(CrosshairImage, CrosshairSize.X, CrosshairSize.Y, CrossHairCoordinates.U, CrossHairCoordinates.V, CrossHairCoordinates.UL, CrossHairCoordinates.VL);
		}
		CrosshairColor = ((H.bGreenCrosshair) ? H.default.LightGreenColor : default.CrosshairColor);
		// End:0x62F
		if(bCrosshairShouldHighlightOnValidTarget)
		{
			H.Canvas.DrawColor = ((bCrosshairIsOverValidTarget) ? H.RedColor : CrosshairColor);			
		}
		else
		{
			H.Canvas.DrawColor = (((WorldInfo.TimeSeconds - LastHitEnemyTime) < 0.3000000) ? H.RedColor : CrosshairColor);
		}
		H.Canvas.SetPos(ScreenX, ScreenY, TargetDist);
		H.Canvas.DrawTile(CrosshairImage, CrosshairSize.X, CrosshairSize.Y, CrossHairCoordinates.U, CrossHairCoordinates.V, CrossHairCoordinates.UL, CrossHairCoordinates.VL);
	}
	//return;	
}

simulated function DrawLockedOn(HUD H)
{
	local Vector2D CrosshairSize;
	local float X, Y, ScreenX, ScreenY, LockedOnTime, TargetDist;

	TargetDist = GetTargetDistance();
	// End:0x6D
	if(!bWasLocked)
	{
		LockedStartTime = WorldInfo.TimeSeconds;
		CurrentLockedScale = StartLockedScale;
		bWasLocked = true;		
	}
	else
	{
		LockedOnTime = WorldInfo.TimeSeconds - LockedStartTime;
		CurrentLockedScale = ((LockedOnTime > LockedScaleTime) ? FinalLockedScale : ((StartLockedScale * (LockedScaleTime - LockedOnTime)) + (FinalLockedScale * LockedOnTime)) / LockedScaleTime);
	}
	CrosshairSize.Y = ((((UTHUDBase(H).ConfiguredCrosshairScaling * CurrentLockedScale) * CrosshairScaling) * LockedCrossHairCoordinates.VL) * H.Canvas.ClipY) / float(720);
	CrosshairSize.X = CrosshairSize.Y * (LockedCrossHairCoordinates.UL / LockedCrossHairCoordinates.VL);
	X = H.Canvas.ClipX * 0.5000000;
	Y = H.Canvas.ClipY * 0.5000000;
	ScreenX = X - (CrosshairSize.X * 0.5000000);
	ScreenY = Y - (CrosshairSize.Y * 0.5000000);
	// End:0x652
	if(CrosshairImage != none)
	{
		// End:0x4DE
		if(bShouldDrawCrosshairDropShadow)
		{
			H.Canvas.DrawColor = Class'UTGame.UTHUD'.default.BlackColor;
			H.Canvas.SetPos(ScreenX + float(1), ScreenY + float(1), TargetDist);
			H.Canvas.DrawTile(CrosshairImage, CrosshairSize.X, CrosshairSize.Y, LockedCrossHairCoordinates.U, LockedCrossHairCoordinates.V, LockedCrossHairCoordinates.UL, LockedCrossHairCoordinates.VL);
		}
		H.Canvas.DrawColor = CrosshairColor;
		H.Canvas.SetPos(ScreenX, ScreenY, TargetDist);
		H.Canvas.DrawTile(CrosshairImage, CrosshairSize.X, CrosshairSize.Y, LockedCrossHairCoordinates.U, LockedCrossHairCoordinates.V, LockedCrossHairCoordinates.UL, LockedCrossHairCoordinates.VL);
	}
	//return;	
}

simulated function int GetAmmoCount()
{
	return AmmoCount;
	//return ReturnValue;	
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	super(Weapon).DisplayDebug(HUD, out_YL, out_YPos);
	// End:0x196
	if(UTPawn(Instigator) != none)
	{
		HUD.Canvas.DrawText((((((((("Eyeheight " $ string(Instigator.EyeHeight)) $ " base ") $ string(Instigator.BaseEyeHeight)) $ " landbob ") $ string(UTPawn(Instigator).LandBob)) $ " just landed ") $ string(UTPawn(Instigator).bJustLanded)) $ " land recover ") $ string(UTPawn(Instigator).bLandRecovery), false);
		out_YPos += out_YL;
	}
	HUD.Canvas.SetPos(4.0000000, out_YPos);
	HUD.Canvas.DrawText((((("Zoom State:" @ string(GetZoomedState())) @ "ZoomedRate:") @ string(ZoomedRate)) @ "Target FOV:") @ string(ZoomedTargetFOV));
	out_YPos += out_YL;
	//return;	
}

simulated function float GetFireInterval(byte FireModeNum)
{
	return FireInterval[int(FireModeNum)] * ((UTPawn(Owner) != none) ? UTPawn(Owner).FireRateMultiplier : 1.0000000);
	//return ReturnValue;	
}

simulated function PlayArmAnimation(name Sequence, float fDesiredDuration, optional bool OffHand, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
	local UTPawn UTP;
	local editinline SkeletalMeshComponent ArmMeshComp;
	local AnimNodeSequence WeapNode;

	// End:0x65
	if(((int(WorldInfo.NetMode) == int(NM_DedicatedServer)) || Instigator == none) || !Instigator.IsFirstPerson())
	{
		return;
	}
	UTP = UTPawn(Instigator);
	// End:0x92
	if(UTP == none)
	{
		return;
	}
	// End:0x22E
	if(UTP.bArmsAttached)
	{
		// End:0xF0
		if(!OffHand)
		{
			ArmMeshComp = UTP.ArmsMesh[0];			
		}
		else
		{
			ArmMeshComp = UTP.ArmsMesh[1];
		}
		// End:0x14E
		if(((ArmMeshComp == none) || ArmsAnimSet == none) || (GetArmAnimNodeSeq()) == none)
		{
			return;
		}
		// End:0x1A2
		if(fDesiredDuration > 0.0000000)
		{
			ArmMeshComp.PlayAnim(Sequence, fDesiredDuration, bLoop);			
		}
		else
		{
			WeapNode = AnimNodeSequence(ArmMeshComp.Animations);
			WeapNode.SetAnim(Sequence);
			WeapNode.PlayAnim(bLoop, DefaultAnimSpeed);
		}
	}
	//return;	
}

simulated function PlayWeaponAnimation(name Sequence, float fDesiredDuration, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
	// End:0x64
	if((Mesh != none) && Mesh.bAttached)
	{
		super(Weapon).PlayWeaponAnimation(Sequence, fDesiredDuration, bLoop, SkelMesh);
	}
	//return;	
}

simulated function PlayFireEffects(byte FireModeNum, optional Vector HitLocation)
{
	// End:0x74
	if((int(FireModeNum) < WeaponFireAnim.Length) && WeaponFireAnim[int(FireModeNum)] != 'None')
	{
		PlayWeaponAnimation(WeaponFireAnim[int(FireModeNum)], GetFireInterval(FireModeNum));
	}
	// End:0xF9
	if(((int(FireModeNum) < ArmFireAnim.Length) && ArmFireAnim[int(FireModeNum)] != 'None') && ArmsAnimSet != none)
	{
		PlayArmAnimation(ArmFireAnim[int(FireModeNum)], GetFireInterval(FireModeNum));
	}
	CauseMuzzleFlash();
	ShakeView();
	//return;	
}

simulated function StopFireEffects(byte FireModeNum)
{
	StopMuzzleFlash();
	//return;	
}

simulated function ShakeView()
{
	local UTPlayerController PC;

	PC = UTPlayerController(Instigator.Controller);
	// End:0x13C
	if((((PC != none) && LocalPlayer(PC.Player) != none) && int(CurrentFireMode) < FireCameraAnim.Length) && FireCameraAnim[int(CurrentFireMode)] != none)
	{
		PC.PlayCameraAnim(FireCameraAnim[int(CurrentFireMode)], ((int(GetZoomedState()) > int(1)) ? PC.GetFOVAngle() / PC.DefaultFOV : 1.0000000));
	}
	// End:0x1C1
	if((PC != none) && LocalPlayer(PC.Player) != none)
	{
		UTPlayerController(Instigator.Controller).ClientPlayForceFeedbackWaveform(WeaponFireWaveForm);
	}
	//return;	
}

simulated function WeaponCalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot)
{
	//return;	
}

simulated function WeaponPlaySound(SoundCue Sound, optional float NoiseLoudness)
{
	// End:0x60
	if(((Sound != none) && Instigator != none) && !bSuppressSounds)
	{
		Instigator.PlaySound(Sound, false, true);
	}
	//return;	
}

simulated function PlayFiringSound()
{
	// End:0x5E
	if(int(CurrentFireMode) < WeaponFireSnd.Length)
	{
		// End:0x5E
		if(WeaponFireSnd[int(CurrentFireMode)] != none)
		{
			MakeNoise(1.0000000);
			WeaponPlaySound(WeaponFireSnd[int(CurrentFireMode)]);
		}
	}
	//return;	
}

simulated event MuzzleFlashTimer()
{
	// End:0x3F
	if((MuzzleFlashPSC != none) && !bMuzzleFlashPSCLoops)
	{
		MuzzleFlashPSC.DeactivateSystem();
	}
	//return;	
}

simulated event CauseMuzzleFlashLight()
{
	// End:0x4C
	if(WorldInfo.bDropDetail && !WorldInfo.IsConsoleBuild(3))
	{
		return;
	}
	// End:0x7D
	if(MuzzleFlashLight != none)
	{
		MuzzleFlashLight.ResetLight();		
	}
	else
	{
		// End:0xE6
		if(MuzzleFlashLightClass != none)
		{
			MuzzleFlashLight = new (Outer) MuzzleFlashLightClass;
			SkeletalMeshComponent(Mesh).AttachComponentToSocket(MuzzleFlashLight, MuzzleFlashSocket);
		}
	}
	//return;	
}

simulated event CauseMuzzleFlash()
{
	local UTPawn P;
	local ParticleSystem MuzzleTemplate;

	// End:0x7C
	if(int(WorldInfo.NetMode) != int(NM_Client))
	{
		P = UTPawn(Instigator);
		// End:0x7C
		if((P == none) || !P.bUpdateEyeheight)
		{
			return;
		}
	}
	CauseMuzzleFlashLight();
	// End:0x2C2
	if((int(GetHand()) != int(3)) || ((bShowAltMuzzlePSCWhenWeaponHidden && Instigator != none) && int(Instigator.FiringMode) == int(1)) && MuzzleFlashAltPSCTemplate != none)
	{
		// End:0x110
		if(!bMuzzleFlashAttached)
		{
			AttachMuzzleFlash();
		}
		// End:0x2AB
		if(MuzzleFlashPSC != none)
		{
			// End:0x2AB
			if(!bMuzzleFlashPSCLoops || !MuzzleFlashPSC.bIsActive || MuzzleFlashPSC.bWasDeactivated)
			{
				// End:0x202
				if(((Instigator != none) && int(Instigator.FiringMode) == int(1)) && MuzzleFlashAltPSCTemplate != none)
				{
					MuzzleTemplate = MuzzleFlashAltPSCTemplate;
					MuzzleFlashPSC.SetIgnoreOwnerHidden(bShowAltMuzzlePSCWhenWeaponHidden);					
				}
				else
				{
					// End:0x224
					if(MuzzleFlashPSCTemplate != none)
					{
						MuzzleTemplate = MuzzleFlashPSCTemplate;
					}
				}
				// End:0x278
				if(MuzzleTemplate != MuzzleFlashPSC.Template)
				{
					MuzzleFlashPSC.SetTemplate(MuzzleTemplate);
				}
				SetMuzzleFlashParams(MuzzleFlashPSC);
				MuzzleFlashPSC.ActivateSystem();
			}
		}
		SetTimer(MuzzleFlashDuration, false, 'MuzzleFlashTimer');
	}
	//return;	
}

simulated event StopMuzzleFlash()
{
	ClearTimer('MuzzleFlashTimer');
	MuzzleFlashTimer();
	// End:0x4C
	if(MuzzleFlashPSC != none)
	{
		MuzzleFlashPSC.DeactivateSystem();
	}
	//return;	
}

simulated function TimeWeaponPutDown()
{
	// End:0x2C
	if(Instigator.IsFirstPerson())
	{
		PlayWeaponPutDown();
	}
	super(Weapon).TimeWeaponPutDown();
	//return;	
}

simulated function PlayWeaponPutDown()
{
	// End:0x35
	if(WeaponPutDownAnim != 'None')
	{
		PlayWeaponAnimation(WeaponPutDownAnim, PutDownTime);
	}
	// End:0x7C
	if((ArmsPutDownAnim != 'None') && ArmsAnimSet != none)
	{
		PlayArmAnimation(ArmsPutDownAnim, PutDownTime);
	}
	// End:0x9F
	if(WeaponPutDownSnd != none)
	{
		WeaponPlaySound(WeaponPutDownSnd);
	}
	//return;	
}

simulated function TimeWeaponEquipping()
{
	AttachWeaponTo(Instigator.Mesh);
	PlayWeaponEquip();
	SetTimer(GetEquipTime(), false, 'WeaponEquipped');
	//return;	
}

simulated function float GetEquipTime()
{
	local float ETime;

	ETime = ((EquipTime > float(0)) ? EquipTime : 0.0100000);
	// End:0x59
	if(PendingFire(0) || PendingFire(1))
	{
		ETime += 0.2500000;
	}
	return ETime;
	//return ReturnValue;	
}

simulated function PlayWeaponEquip()
{
	// End:0x35
	if(WeaponEquipAnim != 'None')
	{
		PlayWeaponAnimation(WeaponEquipAnim, EquipTime);
	}
	// End:0x7C
	if((ArmsEquipAnim != 'None') && ArmsAnimSet != none)
	{
		PlayArmAnimation(ArmsEquipAnim, EquipTime);
	}
	// End:0x9F
	if(WeaponEquipSnd != none)
	{
		WeaponPlaySound(WeaponEquipSnd);
	}
	//return;	
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
	local UTPawn UTP;

	UTP = UTPawn(Instigator);
	// End:0x136
	if(Instigator.IsFirstPerson())
	{
		AttachComponent(Mesh);
		EnsureWeaponOverlayComponentLast();
		SetHidden(true);
		bPendingShow = true;
		Mesh.SetLightEnvironment(UTP.LightEnvironment);
		// End:0x133
		if(int(GetHand()) == int(3))
		{
			UTP.ArmsMesh[0].SetHidden(true);
			UTP.ArmsMesh[1].SetHidden(true);
		}		
	}
	else
	{
		SetHidden(true);
		// End:0x1FB
		if(UTP != none)
		{
			Mesh.SetLightEnvironment(UTP.LightEnvironment);
			UTP.ArmsMesh[0].SetHidden(true);
			UTP.ArmsMesh[1].SetHidden(true);
		}
	}
	SetWeaponOverlayFlags(UTP);
	// End:0x31D
	if((int(Role) == int(ROLE_Authority)) && UTP != none)
	{
		UTP.CurrentWeaponAttachmentClass = AttachmentClass;
		// End:0x31D
		if(((int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_Standalone)) || (int(WorldInfo.NetMode) == int(NM_Client)) && Instigator.IsLocallyControlled())
		{
			UTP.WeaponAttachmentChanged();
		}
	}
	SetSkin(UTPawn(Instigator).ReplicatedBodyMaterial);
	//return;	
}

simulated function SetMuzzleFlashParams(ParticleSystemComponent PSC)
{
	PSC.SetColorParameter('MuzzleFlashColor', MuzzleFlashColor);
	PSC.SetVectorParameter('MFlashScale', vect(0.5000000, 0.5000000, 0.5000000));
	//return;	
}

simulated function AttachMuzzleFlash()
{
	local editinline SkeletalMeshComponent SKMesh;

	bMuzzleFlashAttached = true;
	SKMesh = SkeletalMeshComponent(Mesh);
	// End:0x130
	if(SKMesh != none)
	{
		// End:0x130
		if((MuzzleFlashPSCTemplate != none) || MuzzleFlashAltPSCTemplate != none)
		{
			MuzzleFlashPSC = new (Outer) Class'UTGame.UTParticleSystemComponent';
			MuzzleFlashPSC.bAutoActivate = false;
			MuzzleFlashPSC.SetDepthPriorityGroup(2);
			MuzzleFlashPSC.SetFOV(UDKSkeletalMeshComponent(SKMesh).FOV);
			SKMesh.AttachComponentToSocket(MuzzleFlashPSC, MuzzleFlashSocket);
		}
	}
	//return;	
}

simulated function DetachWeapon()
{
	local UTPawn P;

	DetachComponent(Mesh);
	// End:0x35
	if(OverlayMesh != none)
	{
		DetachComponent(OverlayMesh);
	}
	SetSkin(none);
	P = UTPawn(Instigator);
	// End:0x10E
	if(P != none)
	{
		// End:0x10E
		if((int(Role) == int(ROLE_Authority)) && P.CurrentWeaponAttachmentClass == AttachmentClass)
		{
			P.CurrentWeaponAttachmentClass = none;
			// End:0x10E
			if(Instigator.IsLocallyControlled())
			{
				P.WeaponAttachmentChanged();
			}
		}
	}
	SetBase(none);
	SetHidden(true);
	DetachMuzzleFlash();
	Mesh.SetLightEnvironment(none);
	//return;	
}

simulated function DetachMuzzleFlash()
{
	local editinline SkeletalMeshComponent SKMesh;

	bMuzzleFlashAttached = false;
	SKMesh = SkeletalMeshComponent(Mesh);
	// End:0x6E
	if(SKMesh != none)
	{
		// End:0x6E
		if(MuzzleFlashPSC != none)
		{
			SKMesh.DetachComponent(MuzzleFlashPSC);
		}
	}
	MuzzleFlashPSC = none;
	//return;	
}

simulated function ChangeVisibility(bool bIsVisible)
{
	local UTPawn UTP;
	local editinline SkeletalMeshComponent SkelMesh;
	local editinline PrimitiveComponent Primitive;

	// End:0x101
	if(Mesh != none)
	{
		// End:0x5F
		if(bIsVisible && !Mesh.bAttached)
		{
			AttachComponent(Mesh);
			EnsureWeaponOverlayComponentLast();
		}
		SetHidden(!bIsVisible);
		SkelMesh = SkeletalMeshComponent(Mesh);
		// End:0x101
		if(SkelMesh != none)
		{
			// End:0x100
			foreach SkelMesh.AttachedComponents(Class'Engine.PrimitiveComponent', Primitive)
			{
				Primitive.SetHidden(!bIsVisible);				
			}			
		}
	}
	// End:0x1BC
	if((ArmsAnimSet != none) && int(GetHand()) != int(3))
	{
		UTP = UTPawn(Instigator);
		// End:0x1BC
		if((UTP != none) && UTP.ArmsMesh[0] != none)
		{
			UTP.ArmsMesh[0].SetHidden(!bIsVisible);
		}
	}
	// End:0x20D
	if(OverlayMesh != none)
	{
		OverlayMesh.SetHidden(!bIsVisible || int(GetHand()) == int(3));
	}
	//return;	
}

simulated function PerformWeaponChange()
{
	// End:0x9D
	if(UTPawn(Instigator) != none)
	{
		// End:0x66
		if(Instigator.IsLocallyControlled())
		{
			UTPawn(Instigator).WeaponChanged(self);			
		}
		else
		{
			// End:0x9D
			if(Instigator.Controller == none)
			{
				SetTimer(0.0100000, false, 'PerformWeaponChange');
			}
		}
	}
	//return;	
}

simulated function GetViewAxes(out Vector XAxis, out Vector YAxis, out Vector ZAxis)
{
	// End:0x5F
	if(UTVehicle(Owner) != none)
	{
		UTVehicle(Owner).GetWeaponViewAxes(self, XAxis, YAxis, ZAxis);		
	}
	else
	{
		// End:0xC1
		if(Instigator.Controller == none)
		{
			GetAxes(Instigator.Rotation, XAxis, YAxis, ZAxis);			
		}
		else
		{
			GetAxes(Instigator.Controller.Rotation, XAxis, YAxis, ZAxis);
		}
	}
	//return;	
}

reliable server function ServerReselectWeapon()
{
	//return;	
}

simulated function bool CanThrow()
{
	return bCanThrow && HasAnyAmmo();
	//return ReturnValue;	
}

simulated function UTPlayerController.EWeaponHand GetHand()
{
	local UTPlayerController PC;

	// End:0x6E
	if(Instigator != none)
	{
		PC = UTPlayerController(Instigator.Controller);
		// End:0x6E
		if(PC != none)
		{
			return PC.WeaponHand;
		}
	}
	return 0;
	//return ReturnValue;	
}

simulated event SetPosition(UDKPawn Holder)
{
	local Vector DrawOffset, ViewOffset, FinalSmallWeaponsOffset, FinalLocation;
	local UTPlayerController.EWeaponHand CurrentHand;
	local Rotator NewRotation, FinalRotation, SpecRotation;
	local PlayerController PC;
	local Vector2D ViewportSize;
	local bool bIsWideScreen;
	local Vector SpecViewLoc;

	// End:0x26
	if(!Holder.IsFirstPerson())
	{
		return;
	}
	CurrentHand = GetHand();
	// End:0x16A
	if(bForceHidden || int(CurrentHand) == int(3))
	{
		Mesh.SetHidden(true);
		Holder.ArmsMesh[0].SetHidden(true);
		Holder.ArmsMesh[1].SetHidden(true);
		NewRotation = Holder.GetViewRotation();
		SetLocation(Instigator.GetPawnViewLocation() + (HiddenWeaponsOffset >> NewRotation));
		SetRotation(NewRotation);
		SetBase(Instigator);
		return;
	}
	// End:0x18E
	if(bPendingShow)
	{
		SetHidden(false);
		bPendingShow = false;
	}
	Mesh.SetHidden(false);
	// End:0x22C
	foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		LocalPlayer(PC.Player).ViewportClient.GetViewportSize(ViewportSize);
		// End:0x22C
		break;		
	}	
	bIsWideScreen = (ViewportSize.Y > 0.0000000) && (ViewportSize.X / ViewportSize.Y) > 1.7000000;
	ViewOffset = PlayerViewOffset;
	FinalSmallWeaponsOffset = SmallWeaponsOffset;
	// End:0x30B
	if(Class'Engine.Engine'.static.IsRealDStereoEnabled())
	{
		ViewOffset.X -= float(30);
	}
	switch(CurrentHand)
	{
		// End:0x50B
		case 1:
			Mesh.SetScale3D(default.Mesh.Scale3D * vect(1.0000000, -1.0000000, 1.0000000));
			Mesh.SetRotation(rot(0, 0, 0) - default.Mesh.Rotation);
			// End:0x4C2
			if(ArmsAnimSet != none)
			{
				Holder.ArmsMesh[0].SetScale3D(Holder.default.ArmsMesh[0].Scale3D * vect(1.0000000, -1.0000000, 1.0000000));
				Holder.ArmsMesh[1].SetScale3D(Holder.default.ArmsMesh[1].Scale3D * vect(1.0000000, -1.0000000, 1.0000000));
			}
			ViewOffset.Y *= -1.0000000;
			FinalSmallWeaponsOffset.Y *= -1.0000000;
			// End:0x6C4
			break;
		// End:0x557
		case 2:
			ViewOffset.Y = 0.0000000;
			FinalSmallWeaponsOffset.Y = 0.0000000;
			// End:0x6C4
			break;
		// End:0x6BE
		case 0:
			Mesh.SetScale3D(default.Mesh.Scale3D);
			Mesh.SetRotation(default.Mesh.Rotation);
			// End:0x6BB
			if(ArmsAnimSet != none)
			{
				Holder.ArmsMesh[0].SetScale3D(Holder.default.ArmsMesh[0].Scale3D);
				Holder.ArmsMesh[1].SetScale3D(Holder.default.ArmsMesh[1].Scale3D);
			}
			// End:0x6C4
			break;
		// End:0xFFFF
		default:
			// End:0x6C4
			break;
			break;
	}
	// End:0x71B
	if(bIsWideScreen)
	{
		ViewOffset += (WideScreenOffsetScaling * FinalSmallWeaponsOffset);
		// End:0x718
		if(bSmallWeapons)
		{
			ViewOffset += (0.7000000 * FinalSmallWeaponsOffset);
		}		
	}
	else
	{
		// End:0x73C
		if(bSmallWeapons)
		{
			ViewOffset += FinalSmallWeaponsOffset;
		}
	}
	// End:0xA13
	if(Holder.Controller == none)
	{
		// End:0x9A2
		if(DemoRecSpectator(PC) != none)
		{
			PC.GetPlayerViewPoint(SpecViewLoc, SpecRotation);
			DrawOffset = ViewOffset >> SpecRotation;
			DrawOffset += UTPawn(Holder).WeaponBob(BobDamping, JumpDamping);
			FinalLocation = SpecViewLoc + DrawOffset;
			SetLocation(FinalLocation);
			SetBase(Holder);
			SpecRotation.Yaw = LagRot(SpecRotation.Yaw & 65535, LastRotation.Yaw & 65535, MaxYawLag, 0);
			SpecRotation.Pitch = LagRot(SpecRotation.Pitch & 65535, LastRotation.Pitch & 65535, MaxPitchLag, 1);
			LastRotUpdate = WorldInfo.TimeSeconds;
			LastRotation = SpecRotation;
			// End:0x991
			if(bIsWideScreen)
			{
				SpecRotation += WidescreenRotationOffset;
			}
			SetRotation(SpecRotation);
			return;			
		}
		else
		{
			DrawOffset = (ViewOffset >> Holder.GetBaseAimRotation()) + (UTPawn(Holder).GetEyeHeight() * vect(0.0000000, 0.0000000, 1.0000000));
		}		
	}
	else
	{
		DrawOffset.Z = UTPawn(Holder).GetEyeHeight();
		DrawOffset += UTPawn(Holder).WeaponBob(BobDamping, JumpDamping);
		// End:0xB47
		if(UTPlayerController(Holder.Controller) != none)
		{
			DrawOffset += (UTPlayerController(Holder.Controller).ShakeOffset >> Holder.Controller.Rotation);
		}
		DrawOffset = DrawOffset + (ViewOffset >> Holder.Controller.Rotation);
	}
	FinalLocation = Holder.Location + DrawOffset;
	SetLocation(FinalLocation);
	SetBase(Holder);
	// End:0xC76
	if(ArmsAnimSet != none)
	{
		Holder.ArmsMesh[0].SetTranslation(DrawOffset);
		Holder.ArmsMesh[1].SetTranslation(DrawOffset);
	}
	NewRotation = ((Holder.Controller == none) ? Holder.GetBaseAimRotation() : Holder.Controller.Rotation);
	// End:0xE46
	if(Holder.Controller != none)
	{
		FinalRotation.Yaw = LagRot(NewRotation.Yaw & 65535, LastRotation.Yaw & 65535, MaxYawLag, 0);
		FinalRotation.Pitch = LagRot(NewRotation.Pitch & 65535, LastRotation.Pitch & 65535, MaxPitchLag, 1);
		FinalRotation.Roll = NewRotation.Roll;		
	}
	else
	{
		FinalRotation = NewRotation;
	}
	LastRotUpdate = WorldInfo.TimeSeconds;
	LastRotation = NewRotation;
	// End:0xEB6
	if(bIsWideScreen)
	{
		FinalRotation += WidescreenRotationOffset;
	}
	SetRotation(FinalRotation);
	// End:0xF4F
	if(ArmsAnimSet != none)
	{
		Holder.ArmsMesh[0].SetRotation(FinalRotation);
		Holder.ArmsMesh[1].SetRotation(FinalRotation);
	}
	//return;	
}

simulated function bool ShouldLagRot()
{
	return false;
	//return ReturnValue;	
}

simulated function int LagRot(int NewValue, int LastValue, float MaxDiff, int Index)
{
	local int RotDiff;
	local float LeadMag, DeltaTime;

	// End:0x49
	if(ClockwiseFrom_IntInt(NewValue, LastValue))
	{
		// End:0x46
		if(LastValue > NewValue)
		{
			LastValue -= 65536;
		}		
	}
	else
	{
		// End:0x70
		if(NewValue > LastValue)
		{
			NewValue -= 65536;
		}
	}
	DeltaTime = WorldInfo.TimeSeconds - LastRotUpdate;
	RotDiff = NewValue - LastValue;
	// End:0x162
	if((RotDiff == 0) || OldRotDiff[Index] == 0)
	{
		LeadMag = ((ShouldLagRot()) ? OldLeadMag[Index] : 0.0000000);
		// End:0x15F
		if((RotDiff == 0) && OldRotDiff[Index] == 0)
		{
			OldMaxDiff[Index] = 0.0000000;
		}		
	}
	else
	{
		// End:0x30F
		if((RotDiff > 0) == (OldRotDiff[Index] > 0))
		{
			// End:0x274
			if(ShouldLagRot())
			{
				MaxDiff = FMin(1.0000000, Abs(float(RotDiff)) / (float(12000) * DeltaTime)) * MaxDiff;
				// End:0x216
				if(OldMaxDiff[Index] != float(0))
				{
					MaxDiff = FMax(OldMaxDiff[Index], MaxDiff);
				}
				OldMaxDiff[Index] = MaxDiff;
				LeadMag = ((NewValue > LastValue) ? float(-1) * MaxDiff : MaxDiff);				
			}
			else
			{
				LeadMag = 0.0000000;
			}
			// End:0x2FD
			if(DeltaTime < (float(1) / RotChgSpeed))
			{
				LeadMag = ((1.0000000 - (RotChgSpeed * DeltaTime)) * OldLeadMag[Index]) + ((RotChgSpeed * DeltaTime) * LeadMag);				
			}
			else
			{
				LeadMag = 0.0000000;
			}			
		}
		else
		{
			LeadMag = 0.0000000;
			OldMaxDiff[Index] = 0.0000000;
			// End:0x3AE
			if(DeltaTime < (float(1) / ReturnChgSpeed))
			{
				LeadMag = ((1.0000000 - (ReturnChgSpeed * DeltaTime)) * OldLeadMag[Index]) + ((ReturnChgSpeed * DeltaTime) * LeadMag);
			}
		}
	}
	OldLeadMag[Index] = LeadMag;
	OldRotDiff[Index] = RotDiff;
	return int(float(NewValue) + LeadMag);
	//return ReturnValue;	
}

function AdjustPlayerDamage(out int Damage, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, Class<DamageType> DamageType)
{
	//return;	
}

function float RelativeStrengthVersus(Pawn P, float Dist)
{
	return 0.0000000;
	//return ReturnValue;	
}

simulated function float GetWeaponRating()
{
	// End:0x65
	if(((Instigator == none) || UTBot(Instigator.Controller) == none) || !HasAnyAmmo())
	{
		CurrentRating = Priority;		
	}
	else
	{
		CurrentRating = UTBot(Instigator.Controller).RateWeapon(self);
	}
	return CurrentRating;
	//return ReturnValue;	
}

function bool CanAttack(Actor Other)
{
	local float Dist, CheckDist, OtherHeight;
	local Vector HitLocation, HitNormal, projStart, TargetLoc;
	local Actor HitActor, TestActor;
	local Class<Projectile> projClass;
	local int I;
	local UTBot B;

	// End:0x37
	if((Instigator == none) || Instigator.Controller == none)
	{
		return false;
	}
	Dist = VSize(Instigator.Location - Other.Location);
	// End:0x9B
	if(Dist > (MaxRange()))
	{
		return false;
	}
	projStart = ((bInstantHit) ? InstantFireStartTrace() : GetPhysicalFireStartLoc());
	B = UTBot(Instigator.Controller);
	// End:0x19E
	if(Instigator.Controller.LineOfSightTo(Other, projStart))
	{
		// End:0x19B
		if((B != none) && B.Focus == Other)
		{
			B.bTargetAlternateLoc = false;
		}		
	}
	else
	{
		// End:0x20B
		if(!Other.bHasAlternateTargetLocation && !Instigator.Controller.LineOfSightTo(Other, projStart, true))
		{
			return false;
		}
		// End:0x269
		if((B != none) && B.Focus == Other)
		{
			B.bTargetAlternateLoc = true;
		}
	}
	// End:0x3D1
	if(!bInstantHit)
	{
		projClass = GetProjectileClass();
		// End:0x2FB
		if(projClass == none)
		{
			I = 0;
			J0x2A6:

			// End:0x2FB [Loop If]
			if(I < WeaponProjectiles.Length)
			{
				projClass = WeaponProjectiles[I];
				// End:0x2ED
				if(projClass != none)
				{
					// [Explicit Break]
					goto J0x2FB;
				}
				I++;
				// [Loop Continue]
				goto J0x2A6;
			}
		}
		J0x2FB:

		// End:0x33D
		if(projClass == none)
		{
			WarnInternal("No projectile class for " $ string(self));
			CheckDist = 300.0000000;			
		}
		else
		{
			CheckDist = FMax(CheckDist, 0.5000000 * projClass.default.Speed);
			CheckDist = FMax(CheckDist, 300.0000000);
			CheckDist = FMin(CheckDist, VSize(Other.Location - Location));
		}
	}
	TargetLoc = Other.GetTargetLocation(Instigator);
	// End:0x47C
	if(Pawn(Other) != none)
	{
		OtherHeight = Pawn(Other).GetCollisionHeight();
		TargetLoc.Z += (0.9000000 * OtherHeight);
	}
	// End:0x4D7
	if(bInstantHit)
	{
		HitActor = GetTraceOwner().Trace(HitLocation, HitNormal, TargetLoc, projStart, true,,, 1);		
	}
	else
	{
		// End:0x5D3
		foreach GetTraceOwner().TraceActors(Class'Engine.Actor', TestActor, HitLocation, HitNormal, TargetLoc, projStart,,, 1)
		{
			// End:0x5D2
			if((TestActor.bBlockActors || TestActor.bProjTarget) && (VSize(HitLocation - projStart) <= CheckDist) || TestActor.IsStationary())
			{
				HitActor = TestActor;
				// End:0x5D3
				break;
			}			
		}		
	}
	// End:0x699
	if((((HitActor == none) || HitActor == Other) || !HitActor.IsA('Pawn') && !HitActor.IsA('UTGameObjective')) || !WorldInfo.GRI.OnSameTeam(Instigator, HitActor))
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

static function float BotDesireability(Actor PickupHolder, Pawn P, Controller C)
{
	local UTWeapon AlreadyHas;
	local float desire;
	local UTBot Bot;

	Bot = UTBot(C);
	// End:0x31
	if(Bot == none)
	{
		return 0.0000000;
	}
	// End:0x84
	if(UTWeaponLocker(PickupHolder) != none)
	{
		return UTWeaponLocker(PickupHolder).BotDesireability(P, C);
	}
	desire = default.MaxDesireability;
	// End:0xD4
	if(ClassIsChildOf(default.Class, Bot.FavoriteWeapon))
	{
		desire *= 1.5000000;
	}
	AlreadyHas = UTWeapon(P.FindInventoryType(default.Class));
	// End:0x299
	if(AlreadyHas != none)
	{
		// End:0x147
		if(Bot.bHuntPlayer)
		{
			return 0.0000000;
		}
		// End:0x19D
		if((UTWeaponPickupFactory(PickupHolder) != none) && !UTWeaponPickupFactory(PickupHolder).AllowPickup(Bot))
		{
			return 0.0000000;
		}
		// End:0x1D1
		if(AlreadyHas.AmmoMaxed(0))
		{
			return 0.2500000 * desire;
		}
		// End:0x293
		if(AlreadyHas.AmmoCount > 0)
		{
			// End:0x20D
			if(default.AmmoPickupClass == none)
			{
				return 0.0500000;				
			}
			else
			{
				return FMax(0.2500000 * desire, default.AmmoPickupClass.default.MaxDesireability * FMin(1.0000000, (0.1500000 * float(AlreadyHas.MaxAmmoCount)) / float(AlreadyHas.AmmoCount)));
			}			
		}
		else
		{
			return 0.0500000;
		}
	}
	// End:0x312
	if(Bot.bHuntPlayer && (desire * 0.8330000) < (P.Weapon.AIRating - 0.1000000))
	{
		return 0.0000000;
	}
	// End:0x386
	if((P.Weapon == none) || P.Weapon.AIRating < 0.5000000)
	{
		return 2.0000000 * desire;
	}
	return desire;
	//return ReturnValue;	
}

function float GetDamageRadius()
{
	local Class<Projectile> CurrentProjectileClass;

	CurrentProjectileClass = GetProjectileClass();
	// End:0x29
	if(CurrentProjectileClass == none)
	{
		return 0.0000000;
	}
	return CurrentProjectileClass.default.DamageRadius;
	//return ReturnValue;	
}

function bool CanHeal(Actor Other)
{
	return false;
	//return ReturnValue;	
}

function float GetOptimalRangeFor(Actor Target)
{
	return MaxRange();
	//return ReturnValue;	
}

function bool FireOnRelease()
{
	return int(ShouldFireOnRelease[int(CurrentFireMode)]) != int(0);
	//return ReturnValue;	
}

function bool FocusOnLeader(bool bLeaderFiring)
{
	return false;
	//return ReturnValue;	
}

function bool RecommendRangedAttack()
{
	return false;
	//return ReturnValue;	
}

function float SuggestAttackStyle()
{
	return 0.0000000;
	//return ReturnValue;	
}

function float SuggestDefenseStyle()
{
	return 0.0000000;
	//return ReturnValue;	
}

function float RangedAttackTime()
{
	return 0.0000000;
	//return ReturnValue;	
}

function bool SplashJump()
{
	return bSplashJump;
	//return ReturnValue;	
}

function bool ShouldFireWithoutTarget()
{
	return false;
	//return ReturnValue;	
}

function byte BestMode()
{
	local byte Best;

	// End:0x17
	if(IsFiring())
	{
		return CurrentFireMode;
	}
	// End:0x2F
	if(FRand() < 0.5000000)
	{
		Best = 1;
	}
	// End:0x71
	if((int(Best) < bZoomedFireMode.Length) && int(bZoomedFireMode[int(Best)]) != int(0))
	{
		return 0;		
	}
	else
	{
		return Best;
	}
	//return ReturnValue;	
}

function bool IsFullyCharged()
{
	return false;
	//return ReturnValue;	
}

simulated function bool ReadyToFire(bool bFinished)
{
	return false;
	//return ReturnValue;	
}

simulated function bool StillFiring(byte FireMode)
{
	// End:0x81
	if(UTBot(Instigator.Controller) != none)
	{
		ClearPendingFire(0);
		ClearPendingFire(1);
		UTBot(Instigator.Controller).WeaponFireAgain(true);
	}
	return super(Weapon).StillFiring(FireMode);
	//return ReturnValue;	
}

function ConsumeAmmo(byte FireModeNum)
{
	AddAmmo(-ShotCost[int(FireModeNum)]);
	//return;	
}

function int AddAmmo(int Amount)
{
	AmmoCount = Clamp(AmmoCount + Amount, 0, MaxAmmoCount);
	// End:0x93
	if((AmmoCount <= 0) && (UTInventoryManager(InvManager) == none) || UTInventoryManager(InvManager).bInfiniteAmmo)
	{
		AmmoCount = MaxAmmoCount;
	}
	return AmmoCount;
	//return ReturnValue;	
}

simulated function bool AmmoMaxed(int Mode)
{
	return AmmoCount >= MaxAmmoCount;
	//return ReturnValue;	
}

simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
	// End:0x34
	if(Amount == 0)
	{
		return AmmoCount >= ShotCost[int(FireModeNum)];		
	}
	else
	{
		return AmmoCount >= Amount;
	}
	//return ReturnValue;	
}

simulated function bool HasAnyAmmo()
{
	return (AmmoCount > 0) || (ShotCost[0] == 0) && ShotCost[1] == 0;
	//return ReturnValue;	
}

simulated function float DesireAmmo(bool bDetour)
{
	return 1.0000000 - (float(AmmoCount) / float(MaxAmmoCount));
	//return ReturnValue;	
}

simulated function bool NeedAmmo()
{
	return AmmoCount < default.AmmoCount;
	//return ReturnValue;	
}

simulated function Loaded(optional bool bUseWeaponMax)
{
	// End:0x24
	if(bUseWeaponMax)
	{
		AmmoCount = MaxAmmoCount;		
	}
	else
	{
		AmmoCount = 999;
	}
	//return;	
}

function bool DenyPickupQuery(Class<Inventory> ItemClass, Actor Pickup)
{
	local DroppedPickup DP;

	// End:0x165
	if(ItemClass == Class)
	{
		DP = DroppedPickup(Pickup);
		// End:0xF4
		if(DP != none)
		{
			// End:0x70
			if(DP.Instigator == Instigator)
			{
				return true;
			}
			AddAmmo(UTWeapon(DP.Inventory).AmmoCount);
			DP.PickedUpBy(Instigator);
			AnnouncePickup(Instigator);			
		}
		else
		{
			AddAmmo(default.AmmoCount);
			// End:0x150
			if(PickupFactory(Pickup) != none)
			{
				PickupFactory(Pickup).PickedUpBy(Instigator);
			}
			AnnouncePickup(Instigator);
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function WeaponEmpty()
{
	// End:0x1B
	if(IsFiring())
	{
		GotoState('Active');
	}
	// End:0x83
	if((Instigator != none) && Instigator.IsLocallyControlled())
	{
		Instigator.InvManager.SwitchToBestWeapon(true);
	}
	//return;	
}

simulated function bool bReadyToFire()
{
	return true;
	//return ReturnValue;	
}

simulated function Vector InstantFireStartTrace()
{
	return Instigator.GetWeaponStartTraceLocation();
	//return ReturnValue;	
}

simulated function Vector InstantFireEndTrace(Vector StartTrace)
{
	return StartTrace + (Vector(GetAdjustedAim(StartTrace)) * (GetTraceRange()));
	//return ReturnValue;	
}

simulated function InstantFire()
{
	local Vector StartTrace, EndTrace;
	local array<ImpactInfo> ImpactList;
	local ImpactInfo RealImpact, NearImpact;
	local int I, FinalImpactIndex;

	StartTrace = InstantFireStartTrace();
	EndTrace = InstantFireEndTrace(StartTrace);
	bUsingAimingHelp = false;
	RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);
	FinalImpactIndex = ImpactList.Length - 1;
	// End:0x17E
	if((FinalImpactIndex >= 0) && (ImpactList[FinalImpactIndex].HitActor == none) || !ImpactList[FinalImpactIndex].HitActor.bProjTarget)
	{
		NearImpact = InstantAimHelp(StartTrace, EndTrace, RealImpact);
		// End:0x17E
		if(NearImpact.HitActor != none)
		{
			bUsingAimingHelp = true;
			ImpactList[FinalImpactIndex] = NearImpact;
		}
	}
	I = 0;
	J0x189:

	// End:0x1D6 [Loop If]
	if(I < ImpactList.Length)
	{
		ProcessInstantHit(CurrentFireMode, ImpactList[I]);
		I++;
		// [Loop Continue]
		goto J0x189;
	}
	// End:0x25B
	if(int(Role) == int(ROLE_Authority))
	{
		// End:0x235
		if(NearImpact.HitActor != none)
		{
			SetFlashLocation(NearImpact.HitLocation);			
		}
		else
		{
			SetFlashLocation(RealImpact.HitLocation);
		}
	}
	//return;	
}

simulated function ImpactInfo InstantAimHelp(Vector StartTrace, Vector EndTrace, ImpactInfo RealImpact)
{
	local ImpactInfo NearImpact;
	local Pawn ShotTarget;
	local UTPlayerController UTPC;
	local float AimHelpDist;
	local Vector ClosestPoint;

	NearImpact.HitActor = none;
	UTPC = ((Instigator != none) ? UTPlayerController(Instigator.Controller) : none);
	// End:0x427
	if((((UTPC != none) && UTPC.ShotTarget != none) && UTPC.AimingHelp(true)) && AimingHelpRadius[Min(int(CurrentFireMode), 1)] > 0.0000000)
	{
		ShotTarget = UTPC.ShotTarget;
		// End:0x14F
		if(RealImpact.HitActor != none)
		{
			EndTrace = RealImpact.HitLocation;
		}
		// End:0x427
		if(((EndTrace - ShotTarget.Location) Dot (ShotTarget.Location - StartTrace)) > float(0))
		{
			PointDistToLine(ShotTarget.Location, EndTrace - StartTrace, StartTrace, ClosestPoint);
			AimHelpDist = (UTPC.AimHelpModifier() * AimingHelpRadius[Min(int(CurrentFireMode), 1)]) * Class'UTGame.UTProjectile'.default.GlobalCheckRadiusTweak;
			// End:0x29C
			if(ShotTarget.Velocity == vect(0.0000000, 0.0000000, 0.0000000))
			{
				AimHelpDist *= 0.5000000;
			}
			// End:0x427
			if((Abs(ClosestPoint.Z - ShotTarget.Location.Z) < (ShotTarget.CylinderComponent.CollisionHeight + AimHelpDist)) && VSize2D(ClosestPoint - ShotTarget.Location) < (ShotTarget.CylinderComponent.CollisionRadius + AimHelpDist))
			{
				NearImpact.HitActor = ShotTarget;
				NearImpact.HitLocation = ClosestPoint;
				NearImpact.HitNormal = Normal(EndTrace - StartTrace);
			}
		}
	}
	return NearImpact;
	//return ReturnValue;	
}

simulated function Projectile ProjectileFire()
{
	local Vector RealStartLoc;
	local Projectile SpawnedProjectile;

	IncrementFlashCount();
	// End:0xD3
	if(int(Role) == int(ROLE_Authority))
	{
		RealStartLoc = GetPhysicalFireStartLoc();
		SpawnedProjectile = Spawn(GetProjectileClass(),,, RealStartLoc);
		// End:0xC9
		if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
		{
			SpawnedProjectile.Init(Vector(GetAdjustedAim(RealStartLoc)));
		}
		return SpawnedProjectile;
	}
	return none;
	//return ReturnValue;	
}

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
	local bool bFixMomentum;
	local KActorFromStatic NewKActor;
	local editinline StaticMeshComponent HitStaticMesh;

	// End:0x3C9
	if(Impact.HitActor != none)
	{
		// End:0x134
		if(Impact.HitActor.bWorldGeometry)
		{
			HitStaticMesh = StaticMeshComponent(Impact.HitInfo.HitComponent);
			// End:0x134
			if((HitStaticMesh != none) && HitStaticMesh.CanBecomeDynamic())
			{
				NewKActor = Class'Engine.KActorFromStatic'.static.MakeDynamic(HitStaticMesh);
				// End:0x134
				if(NewKActor != none)
				{
					Impact.HitActor = NewKActor;
				}
			}
		}
		// End:0x3C9
		if(!Impact.HitActor.bStatic && Impact.HitActor != Instigator)
		{
			// End:0x30B
			if(((((int(Impact.HitActor.Role) == int(ROLE_Authority)) && Impact.HitActor.bProjTarget) && !WorldInfo.GRI.OnSameTeam(Instigator, Impact.HitActor)) && Impact.HitActor.Instigator != Instigator) && PhysicsVolume(Impact.HitActor) == none)
			{
				HitEnemy++;
				LastHitEnemyTime = WorldInfo.TimeSeconds;
			}
			// End:0x37C
			if((UTPawn(Impact.HitActor) == none) && InstantHitMomentum[int(FiringMode)] == float(0))
			{
				InstantHitMomentum[int(FiringMode)] = 1.0000000;
				bFixMomentum = true;
			}
			super(Weapon).ProcessInstantHit(FiringMode, Impact, NumHits);
			// End:0x3C9
			if(bFixMomentum)
			{
				InstantHitMomentum[int(FiringMode)] = 0.0000000;
			}
		}
	}
	//return;	
}

simulated function UTWeapon.EZoomState GetZoomedState()
{
	local PlayerController PC;

	PC = PlayerController(Instigator.Controller);
	// End:0x112
	if((PC != none) && PC.GetFOVAngle() != PC.DefaultFOV)
	{
		// End:0xC9
		if(PC.GetFOVAngle() == PC.DesiredFOV)
		{
			return 3;
		}
		return ((PC.GetFOVAngle() < PC.DesiredFOV) ? 1 : 2);
	}
	return 0;
	//return ReturnValue;	
}

simulated function bool CheckZoom(byte FireModeNum)
{
	local UTPlayerController PC;

	PC = UTPlayerController(Instigator.Controller);
	// End:0x128
	if((((PC != none) && LocalPlayer(PC.Player) != none) && int(FireModeNum) < bZoomedFireMode.Length) && int(bZoomedFireMode[int(FireModeNum)]) != int(0))
	{
		// End:0xED
		if(int(GetZoomedState()) == int(3))
		{
			EndZoom(PC);
			EndFire(FireModeNum);
			return true;			
		}
		else
		{
			// End:0x128
			if(int(GetZoomedState()) == int(0))
			{
				StartZoom(PC);
				ZoomedFireModeNum = FireModeNum;
			}
		}
	}
	return false;
	//return ReturnValue;	
}

simulated function StartZoom(UTPlayerController PC)
{
	PC.StartZoom(ZoomedTargetFOV, ZoomedRate);
	PlaySound(ZoomInSound, true);
	//return;	
}

simulated function EndZoom(UTPlayerController PC)
{
	PC.EndZoom();
	PlaySound(ZoomOutSound, true);
	//return;	
}

reliable client simulated function ClientEndFire(byte FireModeNum)
{
	// End:0x3C
	if(int(Role) != int(ROLE_Authority))
	{
		ClearPendingFire(int(FireModeNum));
		EndFire(FireModeNum);
	}
	//return;	
}

simulated function EndFire(byte FireModeNum)
{
	local UTPlayerController PC;

	// End:0x106
	if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && Instigator != none)
	{
		PC = UTPlayerController(Instigator.Controller);
		// End:0x106
		if((((PC != none) && LocalPlayer(PC.Player) != none) && int(FireModeNum) < bZoomedFireMode.Length) && int(bZoomedFireMode[int(FireModeNum)]) != int(0))
		{
			PC.StopZoom();
		}
	}
	super(Weapon).EndFire(FireModeNum);
	//return;	
}

simulated function SendToFiringState(byte FireModeNum)
{
	// End:0x3E
	if((int(FireModeNum) < bZoomedFireMode.Length) && int(bZoomedFireMode[int(FireModeNum)]) != int(0))
	{
		return;
	}
	super(Weapon).SendToFiringState(FireModeNum);
	//return;	
}

reliable client simulated function ClientWeaponSet(bool bOptionalSet, optional bool bDoNotActivate)
{
	local PlayerController PC;

	// End:0xBC
	if(Instigator != none)
	{
		PC = PlayerController(Instigator.Controller);
		// End:0xBC
		if((PC != none) && LocalPlayer(PC.Player) != none)
		{
			PC.SetFOV(PC.DefaultFOV);
		}
	}
	super(Weapon).ClientWeaponSet(bOptionalSet, bDoNotActivate);
	//return;	
}

simulated function FireAmmunition()
{
	// End:0xB7
	if((int(CurrentFireMode) >= bZoomedFireMode.Length) || int(bZoomedFireMode[int(CurrentFireMode)]) == int(0))
	{
		super(Weapon).FireAmmunition();
		// End:0x86
		if(UTPawn(Instigator) != none)
		{
			UTPawn(Instigator).DeactivateSpawnProtection();
		}
		UTInventoryManager(InvManager).OwnerEvent('FiredWeapon');
	}
	//return;	
}

simulated function PreloadTextures(bool bForcePreload)
{
	// End:0x6E
	if(UDKSkeletalMeshComponent(Mesh) != none)
	{
		UDKSkeletalMeshComponent(Mesh).PreloadTextures(bForcePreload, WorldInfo.TimeSeconds + float(2));
	}
	//return;	
}

simulated function bool AllowSwitchTo(Weapon NewWeapon)
{
	return true;
	//return ReturnValue;	
}

simulated function bool TryPutDown()
{
	local float MinTimerTarget, TimerCount;

	bWeaponPutDown = true;
	// End:0x32
	if(!IsTimerActive('RefireCheckTimer'))
	{
		PutDownWeapon();		
	}
	else
	{
		MinTimerTarget = GetTimerRate('RefireCheckTimer') * MinReloadPct[int(CurrentFireMode)];
		TimerCount = GetTimerCount('RefireCheckTimer');
		// End:0xA9
		if(TimerCount >= MinTimerTarget)
		{
			PutDownWeapon();			
		}
		else
		{
			SetTimer(MinTimerTarget - TimerCount, false, 'FiringPutDownWeapon');
		}
	}
	return true;
	//return ReturnValue;	
}

simulated function FiringPutDownWeapon()
{
	// End:0x17
	if(bWeaponPutDown)
	{
		PutDownWeapon();
	}
	//return;	
}

simulated function Vector GetPhysicalFireStartLoc(optional Vector AimDir)
{
	local UTPlayerController PC;
	local Vector FireStartLoc, HitLocation, HitNormal, FireDir, FireEnd, ProjBox;

	local Actor HitActor;
	local Rotator FireRot;
	local Class<Projectile> FiredProjectileClass;
	local int TraceFlags;

	// End:0x662
	if(Instigator != none)
	{
		PC = UTPlayerController(Instigator.Controller);
		FireRot = Instigator.GetViewRotation();
		FireDir = Vector(FireRot);
		// End:0x15D
		if((((PC == none) || PC.bCenteredWeaponFire) || int(PC.WeaponHand) == int(2)) || int(PC.WeaponHand) == int(3))
		{
			FireStartLoc = Instigator.GetPawnViewLocation() + (FireDir * FireOffset.X);			
		}
		else
		{
			// End:0x1D9
			if(int(PC.WeaponHand) == int(1))
			{
				FireStartLoc = Instigator.GetPawnViewLocation() + ((FireOffset * vect(1.0000000, -1.0000000, 1.0000000)) >> FireRot);				
			}
			else
			{
				FireStartLoc = Instigator.GetPawnViewLocation() + (FireOffset >> FireRot);
			}
		}
		// End:0x658
		if((PC != none) || CustomTimeDilation < 1.0000000)
		{
			FiredProjectileClass = GetProjectileClass();
			// End:0x658
			if(FiredProjectileClass != none)
			{
				FireEnd = FireStartLoc + (FireDir * ProjectileSpawnOffset);
				TraceFlags = ((bCollideComplex) ? 1 : 0);
				// End:0x5DA
				if(FiredProjectileClass.default.CylinderComponent.CollisionRadius > float(0))
				{
					FireEnd += (FireDir * FiredProjectileClass.default.CylinderComponent.Translation.X);
					ProjBox = FiredProjectileClass.default.CylinderComponent.CollisionRadius * vect(1.0000000, 1.0000000, 0.0000000);
					ProjBox.Z = FiredProjectileClass.default.CylinderComponent.CollisionHeight;
					HitActor = Trace(HitLocation, HitNormal, FireEnd, Instigator.Location, true, ProjBox,, TraceFlags);
					// End:0x488
					if(HitActor == none)
					{
						HitActor = Trace(HitLocation, HitNormal, FireEnd, FireStartLoc, true, ProjBox,, TraceFlags);						
					}
					else
					{
						FireStartLoc = Instigator.Location - (FireDir * FiredProjectileClass.default.CylinderComponent.Translation.X);
						FireStartLoc.Z = FireStartLoc.Z + FMin(Instigator.EyeHeight, (Instigator.CylinderComponent.CollisionHeight - FiredProjectileClass.default.CylinderComponent.CollisionHeight) - 1.0000000);
						return FireStartLoc;
					}					
				}
				else
				{
					HitActor = Trace(HitLocation, HitNormal, FireEnd, FireStartLoc, true, vect(0.0000000, 0.0000000, 0.0000000),, TraceFlags);
				}
				return ((HitActor == none) ? FireEnd : HitLocation - (float(3) * FireDir));
			}
		}
		return FireStartLoc;
	}
	return Location;
	//return ReturnValue;	
}

simulated function Vector GetEffectLocation()
{
	local Vector SocketLocation;

	// End:0x40
	if(int(GetHand()) == int(3))
	{
		SocketLocation = Instigator.Location;		
	}
	else
	{
		// End:0xE0
		if((SkeletalMeshComponent(Mesh) != none) && EffectSockets[int(CurrentFireMode)] != 'None')
		{
			// End:0xDD
			if(!SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation(EffectSockets[int(CurrentFireMode)], SocketLocation))
			{
				SocketLocation = Location;
			}			
		}
		else
		{
			// End:0x148
			if(Mesh != none)
			{
				SocketLocation = Mesh.Bounds.Origin + (vect(45.0000000, 0.0000000, 0.0000000) >> Rotation);				
			}
			else
			{
				SocketLocation = Location;
			}
		}
	}
	return SocketLocation;
	//return ReturnValue;	
}

simulated function RefireCheckTimer()
{
	//return;	
}

simulated function SetupArmsAnim()
{
	local UTPawn UTP;

	UTP = UTPawn(Instigator);
	// End:0x1AD
	if(UTP != none)
	{
		UTP.ArmsMesh[0].StopAnim();
		// End:0x13F
		if(ArmsAnimSet != none)
		{
			UTP.ArmsMesh[0].AnimSets[1] = ArmsAnimSet;
			UTP.ArmsMesh[0].SetHidden(false);
			UTP.ArmsMesh[0].SetLightEnvironment(UTP.LightEnvironment);			
		}
		else
		{
			UTP.ArmsMesh[0].SetHidden(true);
			UTP.ArmsMesh[1].SetHidden(true);
		}
	}
	//return;	
}

simulated function AnimNodeSequence GetArmAnimNodeSeq()
{
	local UTPawn P;

	P = UTPawn(Instigator);
	// End:0x92
	if((P != none) && P.ArmsMesh[0] != none)
	{
		return AnimNodeSequence(P.ArmsMesh[0].Animations);
	}
	return none;
	//return ReturnValue;	
}

simulated event Destroyed()
{
	// End:0x63
	if(((Instigator != none) && Instigator.IsHumanControlled()) && Instigator.IsLocallyControlled())
	{
		PreloadTextures(false);
	}
	super(Weapon).Destroyed();
	//return;	
}

simulated function SetWeaponOverlayFlags(UTPawn OwnerPawn)
{
	local MaterialInterface InstanceToUse;
	local byte Flags;
	local int I;
	local UTGameReplicationInfo GRI;

	// End:0x2BB
	if(OwnerPawn != none)
	{
		GRI = UTGameReplicationInfo(WorldInfo.GRI);
		// End:0x140
		if(GRI != none)
		{
			Flags = OwnerPawn.WeaponOverlayFlags;
			I = 0;
			J0x82:

			// End:0x140 [Loop If]
			if(I < GRI.WeaponOverlays.Length)
			{
				// End:0x132
				if((GRI.WeaponOverlays[I] != none) && bool(int(Flags) & (1 << I)))
				{
					InstanceToUse = GRI.WeaponOverlays[I];
					// [Explicit Break]
					goto J0x140;
				}
				I++;
				// [Loop Continue]
				goto J0x82;
			}
		}
		J0x140:

		// End:0x159
		if(InstanceToUse != none)
		{
			CreateOverlayMesh();
		}
		// End:0x2BB
		if(OverlayMesh != none)
		{
			// End:0x266
			if(InstanceToUse != none)
			{
				I = 0;
				J0x182:

				// End:0x1EE [Loop If]
				if(I < OverlayMesh.GetNumElements())
				{
					OverlayMesh.SetMaterial(I, InstanceToUse);
					I++;
					// [Loop Continue]
					goto J0x182;
				}
				// End:0x263
				if(!OverlayMesh.bAttached)
				{
					OverlayMesh.SetHidden(Mesh.HiddenGame);
					AttachComponent(OverlayMesh);
				}				
			}
			else
			{
				// End:0x2BB
				if(OverlayMesh.bAttached)
				{
					DetachComponent(OverlayMesh);
					OverlayMesh.SetHidden(true);
				}
			}
		}
	}
	//return;	
}

static function float DetourWeight(Pawn Other, float PathWeight)
{
	local UTBot B;

	B = UTBot(Other.Controller);
	// End:0x144
	if(((B != none) && (B.NeedWeapon() || B.FavoriteWeapon == default.Class) || (B.DefensePoint != none) && B.DefensePoint.WeaponPreference == default.Class) && Other.FindInventoryType(default.Class) == none)
	{
		return default.MaxDesireability / PathWeight;		
	}
	else
	{
		return 0.0000000;
	}
	//return ReturnValue;	
}

function bool RecommendLongRangedAttack()
{
	return false;
	//return ReturnValue;	
}

simulated function ThrottleLook(out float aTurn, out float aLookUp)
{
	//return;	
}

simulated function Activate()
{
	SetupArmsAnim();
	super(Weapon).Activate();
	//return;	
}

simulated event float GetPowerPerc()
{
	return 0.0000000;
	//return ReturnValue;	
}

function DropFrom(Vector StartLocation, Vector StartVelocity)
{
	// End:0x63
	if(((Instigator != none) && Instigator.IsHumanControlled()) && Instigator.IsLocallyControlled())
	{
		PreloadTextures(false);
	}
	super(Weapon).DropFrom(StartLocation, StartVelocity);
	//return;	
}

reliable client simulated function ClientWeaponThrown()
{
	// End:0x7B
	if((Instigator != none) && UTPlayerController(Instigator.Controller) != none)
	{
		UTPlayerController(Instigator.Controller).EndZoom();
	}
	super(Weapon).ClientWeaponThrown();
	//return;	
}

simulated function bool CanViewAccelerationWhenFiring()
{
	return false;
	//return ReturnValue;	
}

simulated function HolderEnteredVehicle()
{
	//return;	
}

simulated function bool CoversScreenSpace(Vector ScreenLoc, Canvas Canvas)
{
	return (ScreenLoc.X > ((float(1) - WeaponCanvasXPct) * Canvas.ClipX)) && ScreenLoc.Y > ((float(1) - WeaponCanvasYPct) * Canvas.ClipY);
	//return ReturnValue;	
}

static simulated function DrawKillIcon(Canvas Canvas, float ScreenX, float ScreenY, float HUDScaleX, float HUDScaleY)
{
	local Color CanvasColor;

	CanvasColor = Canvas.DrawColor;
	Canvas.DrawColor = Class'UTGame.UTHUD'.default.BlackColor;
	Canvas.DrawColor.A = CanvasColor.A;
	Canvas.SetPos(ScreenX - float(2), ScreenY - float(2));
	Canvas.DrawTile(Class'UTGame.UTHUD'.default.AltHudTexture, 4.0000000 + (HUDScaleX * float(96)), 4.0000000 + (HUDScaleY * float(64)), default.IconCoordinates.U, default.IconCoordinates.V, default.IconCoordinates.UL, default.IconCoordinates.VL);
	Canvas.DrawColor = Class'UTGame.UTHUD'.default.WhiteColor;
	Canvas.DrawColor.A = CanvasColor.A;
	Canvas.SetPos(ScreenX, ScreenY);
	Canvas.DrawTile(Class'UTGame.UTHUD'.default.AltHudTexture, HUDScaleX * float(96), HUDScaleY * float(64), default.IconCoordinates.U, default.IconCoordinates.V, default.IconCoordinates.UL, default.IconCoordinates.VL);
	Canvas.DrawColor = CanvasColor;
	//return;	
}

simulated function bool EnableFriendlyWarningCrosshair()
{
	return true;
	//return ReturnValue;	
}

auto simulated state Inactive
{
	simulated function BeginState(name PreviousStateName)
	{
		local PlayerController PC;

		// End:0xBB
		if(Instigator != none)
		{
			PC = PlayerController(Instigator.Controller);
			// End:0xBB
			if((PC != none) && LocalPlayer(PC.Player) != none)
			{
				PC.SetFOV(PC.DefaultFOV);
			}
		}
		super.BeginState(PreviousStateName);
		//return;		
	}

	simulated function bool bReadyToFire()
	{
		return false;
		//return ReturnValue;		
	}
	stop;	
}

simulated state WeaponFiring
{
	simulated event ReplicatedEvent(name VarName)
	{
		// End:0x2A
		if((VarName == 'AmmoCount') && !HasAnyAmmo())
		{
			return;
		}
		global.ReplicatedEvent(VarName);
		//return;		
	}

	simulated function BeginFire(byte FireModeNum)
	{
		// End:0x18
		if(CheckZoom(FireModeNum))
		{
			return;
		}
		global.BeginFire(FireModeNum);
		// End:0x50
		if(!HasAmmo(FireModeNum))
		{
			WeaponEmpty();
			return;
		}
		//return;		
	}

	simulated function bool DenyClientWeaponSet()
	{
		return true;
		//return ReturnValue;		
	}
	stop;	
}

simulated state WeaponEquipping
{
	simulated function BeginState(name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		PerformWeaponChange();
		//return;		
	}

	simulated function bool TryPutDown()
	{
		SwitchAbortTime = (PutDownTime * GetTimerCount('WeaponEquipped')) / GetTimerRate('WeaponEquipped');
		GotoState('WeaponAbortEquip');
		return true;
		//return ReturnValue;		
	}

	simulated function EndState(name NextStateName)
	{
		// End:0x6E
		if((SkeletalMeshComponent(Mesh) == none) || WeaponEquipAnim == 'None')
		{
			Mesh.SetRotation(default.Mesh.Rotation);
		}
		ClearTimer('WeaponEquipped');
		//return;		
	}
	stop;	
}

simulated state WeaponAbortEquip
{
	simulated function BeginState(name PrevStateName)
	{
		local AnimNodeSequence AnimNode;
		local float Rate;

		SetTimer(FMax(SwitchAbortTime, 0.0100000),, 'WeaponEquipAborted');
		// End:0x2ED
		if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
		{
			// End:0x189
			if(WeaponEquipAnim != 'None')
			{
				AnimNode = GetWeaponAnimNodeSeq();
				// End:0x189
				if((AnimNode != none) && AnimNode.AnimSeq != none)
				{
					AnimNode.SetAnim(WeaponPutDownAnim);
					Rate = AnimNode.AnimSeq.SequenceLength / PutDownTime;
					AnimNode.PlayAnim(false, Rate, AnimNode.AnimSeq.SequenceLength - (SwitchAbortTime * Rate));
				}
			}
			// End:0x2ED
			if(((ArmsEquipAnim != 'None') && ArmsAnimSet != none) && Instigator != none)
			{
				AnimNode = GetArmAnimNodeSeq();
				// End:0x2ED
				if((AnimNode != none) && AnimNode.AnimSeq != none)
				{
					AnimNode.SetAnim(ArmsPutDownAnim);
					Rate = AnimNode.AnimSeq.SequenceLength / PutDownTime;
					AnimNode.PlayAnim(false, Rate, AnimNode.AnimSeq.SequenceLength - (SwitchAbortTime * Rate));
				}
			}
		}
		//return;		
	}

	simulated function WeaponEquipAborted()
	{
		DetachWeapon();
		GotoState('Inactive');
		InvManager.ChangedWeapon();
		//return;		
	}

	simulated function EndState(name NextStateName)
	{
		ClearTimer('WeaponEquipAborted');
		super(Object).EndState(NextStateName);
		//return;		
	}
	stop;	
}

simulated state WeaponPuttingDown
{
	ignores Activate;

	simulated function BeginState(name PreviousStateName)
	{
		local UTPlayerController PC;

		// End:0x9D
		if(Instigator != none)
		{
			PC = UTPlayerController(Instigator.Controller);
			// End:0x9D
			if((PC != none) && LocalPlayer(PC.Player) != none)
			{
				PC.EndZoom();
			}
		}
		TimeWeaponPutDown();
		bWeaponPutDown = false;
		//return;		
	}

	simulated function EndState(name NextStateName)
	{
		super.EndState(NextStateName);
		// End:0x81
		if((SkeletalMeshComponent(Mesh) == none) || WeaponEquipAnim == 'None')
		{
			Mesh.SetRotation(default.Mesh.Rotation);
		}
		//return;		
	}

	simulated function bool bReadyToFire()
	{
		return false;
		//return ReturnValue;		
	}
	stop;	
}

simulated state Active
{
	simulated function BeginFire(byte FireModeNum)
	{
		// End:0x41
		if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
		{
			// End:0x41
			if(CheckZoom(FireModeNum))
			{
				return;
			}
		}
		super.BeginFire(FireModeNum);
		//return;		
	}

	simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
		local int IdleIndex;

		// End:0xC3
		if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && WeaponIdleAnims.Length > 0)
		{
			IdleIndex = Rand(WeaponIdleAnims.Length);
			PlayWeaponAnimation(WeaponIdleAnims[IdleIndex], 0.0000000, true);
			// End:0xC3
			if((ArmIdleAnims.Length > IdleIndex) && ArmsAnimSet != none)
			{
				PlayArmAnimation(ArmIdleAnims[IdleIndex], 0.0000000,, true);
			}
		}
		//return;		
	}

	simulated function PlayWeaponAnimation(name Sequence, float fDesiredDuration, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
	{
		global.PlayWeaponAnimation(Sequence, fDesiredDuration, bLoop, SkelMesh);
		ClearTimer('OnAnimEnd');
		// End:0x6B
		if(!bLoop)
		{
			SetTimer(fDesiredDuration, false, 'OnAnimEnd');
		}
		//return;		
	}

	simulated function ChangeVisibility(bool bIsVisible)
	{
		local bool bNeedToPlayAnim;

		bNeedToPlayAnim = !Mesh.bAttached;
		global.ChangeVisibility(bIsVisible);
		// End:0x62
		if(bNeedToPlayAnim)
		{
			OnAnimEnd(none, 0.0000000, 0.0000000);
		}
		//return;		
	}

	simulated function bool ShouldLagRot()
	{
		return true;
		//return ReturnValue;		
	}

	reliable server function ServerStartFire(byte FireModeNum)
	{
		// End:0x1DA
		if((Instigator != none) && Instigator.Weapon != self)
		{
			LogInternal(("########## WARNING: Server Received ServerStartFire on " $ string(self)) $ " while in the active state but not current weapon.  Attempting Realignment");
			LogInternal("##########        : " $ Instigator.PlayerReplicationInfo.PlayerName);
			LogInternal(("##########        : " $ string(Instigator.Weapon)) @ string(Instigator.Weapon.GetStateName()));
			UTInventoryManager(InvManager).ClientSyncWeapon(Instigator.Weapon);
			global.ServerStartFire(FireModeNum);			
		}
		else
		{
			global.ServerStartFire(FireModeNum);
		}
		//return;		
	}

	simulated function BeginState(name PreviousStateName)
	{
		OnAnimEnd(none, 0.0000000, 0.0000000);
		// End:0x88
		if(Instigator != none)
		{
			// End:0x88
			if(UTBot(Instigator.Controller) != none)
			{
				// End:0x6E
				if(PendingFire(0))
				{
					StillFiring(0);					
				}
				else
				{
					// End:0x88
					if(PendingFire(1))
					{
						StillFiring(1);
					}
				}
			}
		}
		super.BeginState(PreviousStateName);
		// End:0x14A
		if((InvManager != none) && InvManager.LastAttemptedSwitchToWeapon != none)
		{
			// End:0x12A
			if(InvManager.LastAttemptedSwitchToWeapon != self)
			{
				InvManager.LastAttemptedSwitchToWeapon.ClientWeaponSet(true);
			}
			InvManager.LastAttemptedSwitchToWeapon = none;
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	bExportMenuData=true
	bShouldDrawCrosshairDropShadow=true
	MaxAmmoCount=1
	ShotCost[0]=1
	ShotCost[1]=1
	MinReloadPct[0]=0.6000000
	MinReloadPct[1]=0.6000000
	// Reference: ForceFeedbackWaveform'UTGame.Default__UTWeapon.ForceFeedbackWaveformShooting1'
	begin object name="ForceFeedbackWaveformShooting1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=30,RightAmplitude=20,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.1000000)
	end object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	EffectSockets[0]="MuzzleFlashSocket"
	EffectSockets[1]="MuzzleFlashSocket"
	IconX=458
	IconY=83
	iconWidth=31
	iconHeight=45
	IconCoordinates=(U=600.0000000,V=341.0000000,UL=111.0000000,VL=58.0000000)
	CrossHairCoordinates=(U=192.0000000,V=64.0000000,UL=64.0000000,VL=64.0000000)
	SimpleCrossHairCoordinates=(U=276.0000000,V=84.0000000,UL=22.0000000,VL=25.0000000)
	CrosshairImage=Texture2D'UI_HUD.HUD.UTCrossHairs'
	LockedCrossHairCoordinates=(U=406.0000000,V=320.0000000,UL=76.0000000,VL=77.0000000)
	CurrentLockedScale=1.0000000
	StartLockedScale=2.0000000
	FinalLockedScale=1.0000000
	LockedScaleTime=0.1500000
	LastHitEnemyTime=-1000.0000000
	CrosshairColor=(R=204,G=0,B=255,A=255)
	CrosshairScaling=1.0000000
	PivotTranslation=(X=0.0000000,Y=-25.0000000,Z=0.0000000)
	WeaponFireAnim[0]="WeaponFire"
	WeaponFireAnim[1]="WeaponFire"
	ArmFireAnim[0]="WeaponFire"
	ArmFireAnim[1]="WeaponFire"
	WeaponPutDownAnim="WeaponPutDown"
	ArmsPutDownAnim="WeaponPutDown"
	WeaponEquipAnim="WeaponEquip"
	ArmsEquipAnim="WeaponEquip"
	WeaponIdleAnims[0]="WeaponIdle"
	ArmIdleAnims[0]="WeaponIdle"
	WeaponFireSnd[0]=none
	WeaponFireSnd[1]=none
	BobDamping=0.8500000
	JumpDamping=1.0000000
	MaxPitchLag=600.0000000
	MaxYawLag=800.0000000
	RotChgSpeed=3.0000000
	ReturnChgSpeed=3.0000000
	WeaponColor=(R=255,G=255,B=255,A=255)
	WeaponCanvasXPct=0.3500000
	WeaponCanvasYPct=0.3500000
	MuzzleFlashSocket="MuzzleFlashSocket"
	MuzzleFlashDuration=0.3300000
	SmallWeaponsOffset=(X=-6.0000000,Y=6.0000000,Z=16.0000000)
	WideScreenOffsetScaling=0.8000000
	WidescreenRotationOffset=(Pitch=0,Yaw=0,Roll=900)
	HiddenWeaponsOffset=(X=-50.0000000,Y=-50.0000000,Z=0.0000000)
	ProjectileSpawnOffset=20.0000000
	LockerRotation=(Pitch=0,Yaw=0,Roll=16384)
	LockerOffset=(X=-15.0000000,Y=0.0000000,Z=0.0000000)
	CurrentRating=0.5000000
	aimerror=525.0000000
	NeedToPickUpAnnouncement=(AnnouncementSound=none,AnnouncementText="Grab the Super Weapon!")
	AimingHelpRadius[0]=20.0000000
	AimingHelpRadius[1]=20.0000000
	ZoomedTurnSpeedScalePct=0.8500000
	TargetFrictionDistanceMin=320.0000000
	TargetFrictionDistancePeak=1500.0000000
	TargetFrictionDistanceMax=3000.0000000
	TargetFrictionDistanceCurve=(Points=((InVal=0.0000000,OutVal=0.0000000,ArriveTangent=0.0000000,LeaveTangent=0.0000000,InterpMode=CIM_Linear),(InVal=320.0000000,OutVal=0.0000000,ArriveTangent=0.0000000,LeaveTangent=0.0000000,InterpMode=CIM_Linear),(InVal=1500.0000000,OutVal=1.0000000,ArriveTangent=0.0000000,LeaveTangent=0.0000000,InterpMode=CIM_Linear),(InVal=3000.0000000,OutVal=0.3000000,ArriveTangent=0.0000000,LeaveTangent=0.0000000,InterpMode=CIM_Linear),(InVal=7000.0000000,OutVal=0.0000000,ArriveTangent=0.0000000,LeaveTangent=0.0000000,InterpMode=CIM_Linear)),InterpMethod=IMT_UseFixedTangentEvalAndNewAutoTangents)
	TargetFrictionMultiplierRange=(X=0.4000000,Y=0.3000000)
	TargetFrictionPeakRadiusScale=1.0000000
	TargetFrictionPeakHeightScale=0.2000000
	TargetFrictionOffset=(X=32.0000000,Y=0.0000000,Z=0.0000000)
	TargetFrictionZoomedBoostValue=0.2500000
	TargetAdhesionDistanceMax=2000.0000000
	TargetAdhesionAimDistY=128.0000000
	TargetAdhesionAimDistZ=96.0000000
	TargetAdhesionScaleRange=(X=2.8499999,Y=0.3000000)
	TargetAdhesionZoomedBoostValue=0.2500000
	FiringStatesArray[0]="WeaponFiring"
	FiringStatesArray[1]="WeaponFiring"
	WeaponFireTypes[0]=0
	WeaponFireTypes[1]=0
	WeaponProjectiles[0]=none
	WeaponProjectiles[1]=none
	FireInterval[0]=1.0000000
	FireInterval[1]=1.0000000
	Spread[0]=0.0000000
	Spread[1]=0.0000000
	InstantHitDamage[0]=0.0000000
	InstantHitDamage[1]=0.0000000
	InstantHitMomentum[0]=0.0000000
	InstantHitMomentum[1]=0.0000000
	InstantHitDamageTypes[0]=Class'Engine.DamageType'
	InstantHitDamageTypes[1]=Class'Engine.DamageType'
	EquipTime=0.4500000
	WeaponRange=22000.0000000
	// Reference: UDKSkeletalMeshComponent'UTGame.Default__UTWeapon.FirstPersonMesh'
	begin object name="FirstPersonMesh" class=UDKBase.UDKSkeletalMeshComponent
		bOverrideAttachmentOwnerVisibility=true
		ReplacementPrimitive=none
		DepthPriorityGroup=SDPG_Foreground
		bOnlyOwnerSee=true
	end object
	Mesh=FirstPersonMesh
	DefaultAnimSpeed=0.9000000
	ShouldFireOnRelease[0]=0
	ShouldFireOnRelease[1]=0
	MaxDesireability=0.5000000
	DroppedPickupClass=Class'UTGame.UTDroppedPickup'
	// Reference: SkeletalMeshComponent'UTGame.Default__UTWeapon.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	begin object name="PickupMesh" class=Engine.SkeletalMeshComponent
		bForceRefpose=1
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=true
		ReplacementPrimitive=none
		MaxDrawDistance=6000.0000000
		CachedMaxDrawDistance=6000.0000000
		CastShadow=false
		bForceDirectLightMap=true
		bCastDynamicShadow=false
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
	MessageClass=Class'UTGame.UTPickupMessage'
}