class UTWeap_RocketLauncher extends UTWeapon
	abstract
	config(Weapon);

enum ERocketFireMode1
{
	RFM_Spread,                     // 0
	RFM_Spiral,                     // 1
	RFM_Grenades,                   // 2
	RFM_Max                         // 3
};

var UTWeap_RocketLauncher.ERocketFireMode1 LoadedFireMode;
var Class<UTProjectile> SeekingRocketClass;
var Class<UTProjectile> LoadedRocketClass;
var Class<UTProjectile> GrenadeClass;
var int GrenadeSpreadDist;
var SoundCue AltFireModeChangeSound;
var SoundCue RocketLoadedSound;
var SoundCue GrenadeFireSound;
var export editinline UDKSkeletalMeshComponent SkeletonFirstPersonMesh;
var bool bIsAnyAmmoHidden;
var bool bLockedOnTarget;
var bool bTargetLockingActive;
var float LockCheckTime;
var float LockRange;
var float LockAcquireTime;
var float LockTolerance;
var Actor LockedTarget;
var PlayerReplicationInfo LockedTargetPRI;
var Actor PendingLockedTarget;
var float LastLockedOnTime;
var float PendingLockedTargetTime;
var float LastValidTargetTime;
var float LockAim;
var float ConsoleLockAim;
var SoundCue LockAcquiredSound;
var SoundCue LockLostSound;
var float LastTargetLockCheckTime;
var int LoadedShotCount;
var int MaxLoadCount;
var SoundCue WeaponLoadedSnd;
var array<float> AltFireQueueTimes;
var array<float> AltFireLaunchTimes;
var array<float> AltFireEndTimes;
var array<SoundCue> AltFireSndQue;
var array<name> MuzzleFlashSocketList;
var export editinline array<export editinline UTParticleSystemComponent> MuzzleFlashPSCList;
var int SpreadDist;
var float GracePeriod;
var float WaitToFirePct;
var const localized string GrenadeString;
var const localized string SpiralString;
var TextureCoordinates LoadedIconCoords[3];
var name LoadUpAnimList[3];
var name WeaponAltFireLaunch[3];
var name WeaponAltFireLaunchEnd[3];

replication
{
	// Pos:0x000
	if(int(Role) == int(ROLE_Authority))
		LockedTarget, bLockedOnTarget;
}

simulated function AdjustWeaponTimingForConsole()
{
	local int I;

	super.AdjustWeaponTimingForConsole();
	I = 0;
	J0x15:

	// End:0x69 [Loop If]
	if(I < AltFireQueueTimes.Length)
	{
		AltFireQueueTimes[I] = AltFireQueueTimes[I] / 1.1000000;
		I++;
		// [Loop Continue]
		goto J0x15;
	}
	I = 0;
	J0x74:

	// End:0xC8 [Loop If]
	if(I < AltFireEndTimes.Length)
	{
		AltFireEndTimes[I] = AltFireEndTimes[I] / 1.1000000;
		I++;
		// [Loop Continue]
		goto J0x74;
	}
	I = 0;
	J0xD3:

	// End:0x127 [Loop If]
	if(I < AltFireLaunchTimes.Length)
	{
		AltFireLaunchTimes[I] = AltFireLaunchTimes[I] / 1.1000000;
		I++;
		// [Loop Continue]
		goto J0xD3;
	}
	//return;	
}

simulated function float GetFireInterval(byte FireModeNum)
{
	// End:0x5E
	if(((int(FireModeNum) != int(1)) || UTPawn(Owner) == none) || LoadedShotCount == MaxLoadCount)
	{
		return super.GetFireInterval(FireModeNum);		
	}
	else
	{
		return AltFireQueueTimes[LoadedShotCount] * UTPawn(Owner).FireRateMultiplier;
	}
	//return ReturnValue;	
}

simulated function GetWeaponDebug(out array<string> DebugInfo)
{
	super(Weapon).GetWeaponDebug(DebugInfo);
	DebugInfo[DebugInfo.Length] = ((("Locked: " @ string(bLockedOnTarget)) @ string(LockedTarget)) @ string(LastLockedOnTime)) @ string(WorldInfo.TimeSeconds - LastLockedOnTime);
	DebugInfo[DebugInfo.Length] = (("Pending:" @ string(PendingLockedTarget)) @ string(PendingLockedTargetTime)) @ string(WorldInfo.TimeSeconds);
	//return;	
}

simulated function FireAmmunition()
{
	super.FireAmmunition();
	// End:0x61
	if(int(Role) == int(ROLE_Authority))
	{
		AdjustLockTarget(none);
		LastValidTargetTime = 0.0000000;
		PendingLockedTarget = none;
		LastLockedOnTime = 0.0000000;
		PendingLockedTargetTime = 0.0000000;
	}
	//return;	
}

function AdjustLockTarget(Actor NewLockTarget)
{
	// End:0x19
	if(LockedTarget == NewLockTarget)
	{
		return;
	}
	// End:0xDA
	if(NewLockTarget == none)
	{
		// End:0xD7
		if(bLockedOnTarget)
		{
			LockedTarget = none;
			bLockedOnTarget = false;
			// End:0xD7
			if(((LockLostSound != none) && Instigator != none) && Instigator.IsHumanControlled())
			{
				PlayerController(Instigator.Controller).ClientPlaySound(LockLostSound);
			}
		}		
	}
	else
	{
		bLockedOnTarget = true;
		LockedTarget = NewLockTarget;
		LockedTargetPRI = ((Pawn(NewLockTarget) != none) ? Pawn(NewLockTarget).PlayerReplicationInfo : none);
		// End:0x1D0
		if(((LockAcquiredSound != none) && Instigator != none) && Instigator.IsHumanControlled())
		{
			PlayerController(Instigator.Controller).ClientPlaySound(LockAcquiredSound);
		}
	}
	//return;	
}

simulated function bool CanLockOnTo(Actor TA)
{
	// End:0xBD
	if((((((TA == none) || !TA.bProjTarget) || TA.bDeleteMe) || Pawn(TA) == none) || TA == Instigator) || Pawn(TA).Health <= 0)
	{
		return false;
	}
	return (((WorldInfo.Game == none) || !WorldInfo.Game.bTeamGame) || WorldInfo.GRI == none) || !WorldInfo.GRI.OnSameTeam(Instigator, TA);
	//return ReturnValue;	
}

event Tick(float DeltaTime)
{
	// End:0x78
	if(bTargetLockingActive && WorldInfo.TimeSeconds > (LastTargetLockCheckTime + LockCheckTime))
	{
		LastTargetLockCheckTime = WorldInfo.TimeSeconds;
		CheckTargetLock();
	}
	//return;	
}

function CheckTargetLock()
{
	local Pawn P, LockedPawn;
	local Actor BestTarget, HitActor, TA;
	local UDKBot BotController;
	local Vector StartTrace, EndTrace, Aim, HitLocation, HitNormal;

	local Rotator AimRot;
	local float bestAim, bestDist;

	// End:0x5D
	if(((Instigator == none) || Instigator.Controller == none) || self != Instigator.Weapon)
	{
		return;
	}
	// End:0xAD
	if(Instigator.bNoWeaponFiring || int(LoadedFireMode) == int(2))
	{
		AdjustLockTarget(none);
		PendingLockedTarget = none;
		return;
	}
	// End:0x259
	if(LockedTarget != none)
	{
		// End:0x1D7
		if(LockedTarget.bDeleteMe)
		{
			// End:0x1C9
			if((LockedTargetPRI != none) && UTVehicle_Hoverboard(LockedTarget) != none)
			{
				P = WorldInfo.PawnList;
				J0x12F:

				// End:0x1C6 [Loop If]
				if(P != none)
				{
					// End:0x19B
					if(P.PlayerReplicationInfo == LockedTargetPRI)
					{
						AdjustLockTarget(((Vehicle(P) != none) ? none : P));
						// [Explicit Break]
						goto J0x1C6;
					}
					P = P.NextPawn;
					// [Loop Continue]
					goto J0x12F;
				}
				J0x1C6:
				
			}
			else
			{
				AdjustLockTarget(none);
			}			
		}
		else
		{
			LockedPawn = Pawn(LockedTarget);
			// End:0x259
			if((LockedPawn != none) && LockedPawn.DrivenVehicle != none)
			{
				AdjustLockTarget(UTVehicle_Hoverboard(LockedPawn.DrivenVehicle));
			}
		}
	}
	BestTarget = none;
	BotController = UDKBot(Instigator.Controller);
	// End:0x45B
	if(BotController != none)
	{
		// End:0x458
		if((BotController.Focus != none) && CanLockOnTo(BotController.Focus))
		{
			BotController.GetPlayerViewPoint(StartTrace, AimRot);
			Aim = Vector(AimRot);
			// End:0x458
			if((Aim Dot Normal(BotController.Focus.Location - StartTrace)) > LockAim)
			{
				HitActor = Trace(HitLocation, HitNormal, BotController.Focus.Location, StartTrace, true,,, 1);
				// End:0x458
				if((HitActor == none) || HitActor == BotController.Focus)
				{
					BestTarget = BotController.Focus;
				}
			}
		}		
	}
	else
	{
		Instigator.Controller.GetPlayerViewPoint(StartTrace, AimRot);
		Aim = Vector(AimRot);
		EndTrace = StartTrace + (Aim * LockRange);
		HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true,,, 1);
		// End:0x683
		if((HitActor == none) || !CanLockOnTo(HitActor))
		{
			bestAim = (((UDKPlayerController(Instigator.Controller) != none) && UDKPlayerController(Instigator.Controller).bConsolePlayer) ? ConsoleLockAim : LockAim);
			bestDist = 0.0000000;
			TA = Instigator.Controller.PickTarget(Class'Engine.Pawn', bestAim, bestDist, Aim, StartTrace, LockRange);
			// End:0x680
			if((TA != none) && CanLockOnTo(TA))
			{
				BestTarget = TA;
			}			
		}
		else
		{
			BestTarget = HitActor;
		}
	}
	// End:0x934
	if(BestTarget != none)
	{
		LastValidTargetTime = WorldInfo.TimeSeconds;
		// End:0x70F
		if(BestTarget == LockedTarget)
		{
			LastLockedOnTime = WorldInfo.TimeSeconds;			
		}
		else
		{
			// End:0x77C
			if((LockedTarget != none) && ((WorldInfo.TimeSeconds - LastLockedOnTime) > LockTolerance) || !CanLockOnTo(LockedTarget))
			{
				AdjustLockTarget(none);
			}
			// End:0x897
			if(PendingLockedTarget != BestTarget)
			{
				PendingLockedTarget = BestTarget;
				PendingLockedTargetTime = ((((Vehicle(PendingLockedTarget) != none) && UDKPlayerController(Instigator.Controller) != none) && UDKPlayerController(Instigator.Controller).bConsolePlayer) ? WorldInfo.TimeSeconds + (0.5000000 * LockAcquireTime) : WorldInfo.TimeSeconds + LockAcquireTime);				
			}
			else
			{
				// End:0x931
				if((PendingLockedTarget == BestTarget) && WorldInfo.TimeSeconds >= PendingLockedTargetTime)
				{
					AdjustLockTarget(PendingLockedTarget);
					LastLockedOnTime = WorldInfo.TimeSeconds;
					PendingLockedTarget = none;
					PendingLockedTargetTime = 0.0000000;
				}
			}
		}		
	}
	else
	{
		// End:0x9A1
		if((LockedTarget != none) && ((WorldInfo.TimeSeconds - LastLockedOnTime) > LockTolerance) || !CanLockOnTo(LockedTarget))
		{
			AdjustLockTarget(none);
		}
		// End:0xA0E
		if((PendingLockedTarget != none) && ((WorldInfo.TimeSeconds - LastValidTargetTime) > LockTolerance) || !CanLockOnTo(PendingLockedTarget))
		{
			PendingLockedTarget = none;
		}
	}
	//return;	
}

simulated event Destroyed()
{
	AdjustLockTarget(none);
	super.Destroyed();
	//return;	
}

simulated function ActiveRenderOverlays(HUD H)
{
	local UTPlayerController PC;

	PC = UTPlayerController(Instigator.Controller);
	// End:0x42
	if(PC == none)
	{
		return;
	}
	// End:0x66
	if(PC.bNoCrosshair)
	{
		return;
	}
	// End:0xB1
	if(PC.bSimpleCrosshair)
	{
		CrossHairCoordinates = SimpleCrossHairCoordinates;
		DrawWeaponCrosshair(H);		
	}
	else
	{
		CrossHairCoordinates = default.CrossHairCoordinates;
		DrawWeaponCrosshair(H);
	}
	// End:0x166
	if((bLockedOnTarget && LockedTarget != none) && Instigator != none)
	{
		// End:0x150
		if((WorldInfo.TimeSeconds - LockedTarget.LastRenderTime) > 0.1000000)
		{
			return;
		}
		DrawLockedOn(H);		
	}
	else
	{
		bWasLocked = false;
	}
	//return;	
}

simulated event MuzzleFlashTimer()
{
	local int I, Length;

	// End:0x21
	if(int(CurrentFireMode) != int(1))
	{
		super.MuzzleFlashTimer();		
	}
	else
	{
		Length = MuzzleFlashPSCList.Length;
		I = 0;
		J0x40:

		// End:0xA7 [Loop If]
		if(I < Length)
		{
			// End:0x99
			if(MuzzleFlashPSCList[I] != none)
			{
				MuzzleFlashPSCList[I].DeactivateSystem();
			}
			I++;
			// [Loop Continue]
			goto J0x40;
		}
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

simulated event CauseMuzzleFlashLight()
{
	local editinline UDKExplosionLight NewMuzzleFlashLight;

	super.CauseMuzzleFlashLight();
	// End:0x2E
	if(WorldInfo.bDropDetail)
	{
		return;
	}
	// End:0x9B
	if(LoadedShotCount == 3)
	{
		NewMuzzleFlashLight = new (Outer) MuzzleFlashLightClass;
		SkeletalMeshComponent(Mesh).AttachComponentToSocket(NewMuzzleFlashLight, MuzzleFlashSocketList[2]);
	}
	//return;	
}

simulated function AttachMuzzleFlash()
{
	local editinline UDKSkeletalMeshComponent SKMesh;
	local int I;

	bMuzzleFlashAttached = true;
	SKMesh = UDKSkeletalMeshComponent(Mesh);
	// End:0x227
	if(SKMesh != none)
	{
		// End:0x227
		if(MuzzleFlashPSCTemplate != none)
		{
			I = 0;
			J0x51:

			// End:0x227 [Loop If]
			if(I < 3)
			{
				MuzzleFlashPSCList[I] = new (Outer) Class'UTGame.UTParticleSystemComponent';
				MuzzleFlashPSCList[I].bAutoActivate = false;
				MuzzleFlashPSCList[I].SetTemplate(MuzzleFlashPSCTemplate);
				MuzzleFlashPSCList[I].SetDepthPriorityGroup(2);
				MuzzleFlashPSCList[I].SetColorParameter('MuzzleFlashColor', MuzzleFlashColor);
				MuzzleFlashPSCList[I].SetVectorParameter('MFlashScale', vect(0.5000000, 0.5000000, 0.5000000));
				MuzzleFlashPSCList[I].SetFOV(SKMesh.FOV);
				SKMesh.AttachComponentToSocket(MuzzleFlashPSCList[I], MuzzleFlashSocketList[I]);
				I++;
				// [Loop Continue]
				goto J0x51;
			}
		}
	}
	//return;	
}

simulated function DetachMuzzleFlash()
{
	local editinline SkeletalMeshComponent SKMesh;
	local int I;

	bMuzzleFlashAttached = false;
	SKMesh = SkeletalMeshComponent(Mesh);
	// End:0x114
	if(SKMesh != none)
	{
		// End:0x79
		if(MuzzleFlashPSC != none)
		{
			SKMesh.DetachComponent(MuzzleFlashPSC);
			MuzzleFlashPSC = none;
		}
		// End:0x8B
		if(MuzzleFlashPSCList.Length == 0)
		{
			return;
		}
		I = 0;
		J0x96:

		// End:0x114 [Loop If]
		if(I < 3)
		{
			// End:0x106
			if(MuzzleFlashPSCList[I] != none)
			{
				SKMesh.DetachComponent(MuzzleFlashPSCList[I]);
				MuzzleFlashPSCList[I] = none;
			}
			I++;
			// [Loop Continue]
			goto J0x96;
		}
	}
	//return;	
}

simulated event CauseMuzzleFlash()
{
	local int I;
	local UTPawn P;

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
	// End:0xA8
	if((int(CurrentFireMode) == int(1)) && int(LoadedFireMode) == int(2))
	{
		return;
	}
	// End:0xC1
	if(!bMuzzleFlashAttached)
	{
		AttachMuzzleFlash();
	}
	CauseMuzzleFlashLight();
	// End:0x127
	if(int(CurrentFireMode) != int(1))
	{
		// End:0x124
		if((MuzzleFlashPSCList.Length > 0) && MuzzleFlashPSCList[0] != none)
		{
			MuzzleFlashPSCList[0].ActivateSystem();
		}		
	}
	else
	{
		I = 0;
		J0x132:

		// End:0x1B4 [Loop If]
		if((I < LoadedShotCount) && I < MuzzleFlashPSCList.Length)
		{
			// End:0x1A6
			if(MuzzleFlashPSCList[I] != none)
			{
				MuzzleFlashPSCList[I].ActivateSystem();
			}
			I++;
			// [Loop Continue]
			goto J0x132;
		}
	}
	SetTimer(MuzzleFlashDuration, false, 'MuzzleFlashTimer');
	//return;	
}

simulated function DrawLFMData(HUD HUD)
{
	local string S;
	local Vector2D CrosshairSize;
	local float XL, YL, X, Y, PickupScale, ScreenX,
		ScreenY;

	local UTHUDBase H;
	local int DrawLoaded;
	local Rotator CrosshairRotation;
	local float TimeRemaining, TargetDist;

	// End:0x24
	if(LoadedShotCount == 0)
	{
		global.DrawWeaponCrosshair(HUD);
		return;
	}
	H = UTHUDBase(HUD);
	// End:0x51
	if(H == none)
	{
		return;
	}
	TargetDist = GetTargetDistance();
	// End:0x1AC
	if(H.LastPickupTime > (WorldInfo.TimeSeconds - 0.3000000))
	{
		// End:0x14D
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
	DrawLoaded = Min(LoadedShotCount - 1, 3);
	CrosshairSize.Y = ((((H.ConfiguredCrosshairScaling * CrosshairScaling) * LoadedIconCoords[DrawLoaded].VL) * PickupScale) * H.Canvas.ClipY) / float(720);
	CrosshairSize.X = (CrosshairSize.Y * LoadedIconCoords[DrawLoaded].UL) / LoadedIconCoords[DrawLoaded].VL;
	X = H.Canvas.ClipX * 0.5000000;
	Y = H.Canvas.ClipY * 0.5000000;
	ScreenX = X - (CrosshairSize.X * 0.5000000);
	ScreenY = Y - (CrosshairSize.Y * 0.5000000);
	TimeRemaining = GetTimerCount('RefireCheckTimer');
	// End:0x49A
	if(LoadedShotCount < 3)
	{
		CrosshairRotation.Yaw = int(21845.3339844 * ((float(LoadedShotCount) - 1.0000000) + FMin(1.0000000, (2.0000000 * TimeRemaining) / (GetFireInterval(1)))));
	}
	H.Canvas.DrawColor = H.BlackColor;
	H.Canvas.SetPos(ScreenX, ScreenY, TargetDist);
	H.Canvas.DrawRotatedTile(CrosshairImage, CrosshairRotation, CrosshairSize.X, CrosshairSize.Y, LoadedIconCoords[DrawLoaded].U, LoadedIconCoords[DrawLoaded].V, LoadedIconCoords[DrawLoaded].UL, LoadedIconCoords[DrawLoaded].VL);
	H.Canvas.DrawColor = ((H.bGreenCrosshair) ? H.default.LightGreenColor : default.CrosshairColor);
	H.Canvas.SetPos(ScreenX, ScreenY, TargetDist);
	H.Canvas.DrawRotatedTile(CrosshairImage, CrosshairRotation, CrosshairSize.X, CrosshairSize.Y, LoadedIconCoords[DrawLoaded].U, LoadedIconCoords[DrawLoaded].V, LoadedIconCoords[DrawLoaded].UL, LoadedIconCoords[DrawLoaded].VL);
	// End:0xA4B
	if(int(LoadedFireMode) != int(0))
	{
		S = ((int(LoadedFireMode) == int(1)) ? SpiralString : GrenadeString);
		H.Canvas.Font = Class'UTGame.UTHUD'.static.GetFontSizeIndex(0);
		H.Canvas.StrLen(S, XL, YL);
		H.Canvas.SetPos((0.5000000 * H.Canvas.ClipX) - (0.5000000 * XL), (0.5000000 * H.Canvas.ClipY) + (0.7100000 * CrosshairSize.Y), TargetDist);
		H.Canvas.DrawText(S);
	}
	//return;	
}

function float SuggestAttackStyle()
{
	local float enemyDist;

	// End:0x102
	if(Instigator.Controller.Enemy != none)
	{
		enemyDist = VSize(Instigator.Controller.Enemy.Location - Owner.Location);
		// End:0xE7
		if(enemyDist < float(750))
		{
			return ((enemyDist < float(500)) ? -1.5000000 : -0.7000000);			
		}
		else
		{
			// End:0x102
			if(enemyDist > float(1600))
			{
				return 0.5000000;
			}
		}
	}
	return -0.1000000;
	//return ReturnValue;	
}

function float GetAIRating()
{
	local UTBot B;
	local float enemyDist, Rating, ZDiff;
	local Vector enemyDir;

	B = UTBot(Instigator.Controller);
	// End:0x70
	if((B == none) || B.Enemy == none)
	{
		return AIRating;
	}
	// End:0x10C
	if(((Instigator.Base != none) && Instigator.Base.Velocity != vect(0.0000000, 0.0000000, 0.0000000)) && !B.CheckFutureSight(0.1000000))
	{
		return 0.1000000;
	}
	enemyDir = B.Enemy.Location - Instigator.Location;
	enemyDist = VSize(enemyDir);
	Rating = AIRating;
	// End:0x281
	if(enemyDist < float(360))
	{
		// End:0x269
		if(Instigator.Weapon == self)
		{
			// End:0x269
			if((enemyDist > float(250)) || (Instigator.Health < 50) && Instigator.Health < (B.Enemy.Health - 30))
			{
				return Rating;
			}
		}
		return 0.0500000 + (enemyDist * 0.0010000);
	}
	ZDiff = Instigator.Location.Z - B.Enemy.Location.Z;
	// End:0x329
	if(ZDiff > float(120))
	{
		Rating += 0.2500000;		
	}
	else
	{
		// End:0x351
		if(ZDiff < float(-160))
		{
			Rating -= 0.3500000;			
		}
		else
		{
			// End:0x376
			if(ZDiff < float(-80))
			{
				Rating -= 0.0500000;
			}
		}
	}
	// End:0x424
	if(((B.Enemy.Weapon != none) && B.Enemy.Weapon.bMeleeWeapon) && enemyDist < float(2500))
	{
		Rating += 0.2500000;
	}
	return Rating;
	//return ReturnValue;	
}

function byte BestMode()
{
	local UTBot B;

	// End:0x17
	if(IsFiring())
	{
		return CurrentFireMode;
	}
	B = UTBot(Instigator.Controller);
	// End:0x80
	if((B == none) || B.Enemy == none)
	{
		return 0;
	}
	return ((((FRand() < 0.3000000) && !B.IsStrafing()) && int(Instigator.Physics) != int(2)) ? 1 : 0);
	//return ReturnValue;	
}

simulated function int GetSpreadDist()
{
	// End:0x21
	if(int(LoadedFireMode) == int(2))
	{
		return GrenadeSpreadDist;		
	}
	else
	{
		return SpreadDist;
	}
	//return ReturnValue;	
}

simulated function WeaponFireLoad()
{
	SetCurrentFireMode(1);
	IncrementFlashCount();
	// End:0x34
	if(int(Role) == int(ROLE_Authority))
	{
		FireLoad();
	}
	PlayFiringSound();
	UTInventoryManager(InvManager).OwnerEvent('FiredWeapon');
	GotoState('WeaponPlayingFire');
	// End:0xF5
	if(((AmmoCount == 0) && Instigator.IsHumanControlled()) && Instigator.IsLocallyControlled())
	{
		HideRocket('MackRocketScale', true);
		bIsAnyAmmoHidden = true;
	}
	//return;	
}

function FireLoad()
{
	local int I, J, K;
	local Vector SpreadVector;
	local Rotator Aim;
	local float theta;
	local Vector FireLocation, RealStartLoc, X, Y, Z;

	local Projectile SpawnedProjectile;
	local UTProj_LoadedRocket FiredRockets[4];
	local bool bCurl;
	local byte FlockIndex;

	// End:0x4C
	if((LoadedShotCount == 1) && int(CurrentFireMode) == int(1))
	{
		RealStartLoc = (GetPhysicalFireStartLoc()) + vect(0.0000000, 0.0000000, 3.0000000);		
	}
	else
	{
		RealStartLoc = GetPhysicalFireStartLoc();
	}
	Aim = GetAdjustedAim(RealStartLoc);
	GetViewAxes(X, Y, Z);
	I = 0;
	J0xAE:

	// End:0x437 [Loop If]
	if(I < LoadedShotCount)
	{
		// End:0x27D
		if((int(LoadedFireMode) == int(2)) || int(LoadedFireMode) == int(0))
		{
			theta = ((float(GetSpreadDist()) * 3.1415927) / 32768.0000000) * (float(I) - (float(LoadedShotCount - 1) / 2.0000000));
			SpreadVector.X = Cos(theta);
			SpreadVector.Y = Sin(theta);
			SpreadVector.Z = 0.0000000;
			SpawnedProjectile = Spawn(GetProjectileClass(),,, RealStartLoc, Rotator(SpreadVector >> Aim));
			// End:0x27A
			if(SpawnedProjectile != none)
			{
				// End:0x246
				if(int(LoadedFireMode) == int(2))
				{
					UTProjectile(SpawnedProjectile).TossZ += ((FRand() * float(200)) - float(100));
				}
				SpawnedProjectile.Init(SpreadVector >> Aim);
			}			
		}
		else
		{
			FireLocation = (RealStartLoc - (float(2) * ((((Sin((float(I * 2) * 3.1415927) / float(MaxLoadCount)) * float(8)) - float(7)) * Y) - (((Cos((float(I * 2) * 3.1415927) / float(MaxLoadCount)) * float(8)) - float(7)) * Z)))) - ((X * float(8)) * FRand());
			SpawnedProjectile = Spawn(GetProjectileClass(),,, FireLocation, Aim);
			// End:0x3BB
			if(SpawnedProjectile != none)
			{
				SpawnedProjectile.Init(Vector(Aim));
				FiredRockets[I] = UTProj_LoadedRocket(SpawnedProjectile);
			}
		}
		// End:0x429
		if(((int(LoadedFireMode) != int(2)) && bLockedOnTarget) && UTProj_SeekingRocket(SpawnedProjectile) != none)
		{
			UTProj_SeekingRocket(SpawnedProjectile).SeekTarget = LockedTarget;
		}
		I++;
		// [Loop Continue]
		goto J0xAE;
	}
	// End:0x652
	if(!bLockedOnTarget && int(LoadedFireMode) == int(1))
	{
		FlockIndex++;
		bCurl = false;
		I = 0;
		J0x47E:

		// End:0x652 [Loop If]
		if(I < LoadedShotCount)
		{
			// End:0x644
			if(FiredRockets[I] != none)
			{
				FiredRockets[I].bCurl = bCurl;
				FiredRockets[I].FlockIndex = FlockIndex;
				J = 0;
				K = 0;
				J0x52A:

				// End:0x5D2 [Loop If]
				if(K < LoadedShotCount)
				{
					// End:0x5C4
					if((I != K) && FiredRockets[K] != none)
					{
						FiredRockets[I].Flock[J] = FiredRockets[K];
						J++;
					}
					K++;
					// [Loop Continue]
					goto J0x52A;
				}
				bCurl = !bCurl;
				// End:0x644
				if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
				{
					FiredRockets[I].SetTimer(0.1000000, true, 'FlockTimer');
				}
			}
			I++;
			// [Loop Continue]
			goto J0x47E;
		}
	}
	//return;	
}

simulated function Projectile ProjectileFire()
{
	local Projectile SpawnedProjectile;

	SpawnedProjectile = super.ProjectileFire();
	// End:0x6C
	if(bLockedOnTarget && UTProj_SeekingRocket(SpawnedProjectile) != none)
	{
		UTProj_SeekingRocket(SpawnedProjectile).SeekTarget = LockedTarget;
	}
	return SpawnedProjectile;
	//return ReturnValue;	
}

function Class<Projectile> GetProjectileClass()
{
	// End:0x37
	if((int(CurrentFireMode) == int(1)) && int(LoadedFireMode) == int(2))
	{
		return GrenadeClass;		
	}
	else
	{
		// End:0x51
		if(bLockedOnTarget)
		{
			return SeekingRocketClass;			
		}
		else
		{
			// End:0x6D
			if(LoadedShotCount > 1)
			{
				return LoadedRocketClass;				
			}
			else
			{
				return WeaponProjectiles[int(CurrentFireMode)];
			}
		}
	}
	//return ReturnValue;	
}

simulated function PlayFiringSound()
{
	// End:0x4A
	if((int(CurrentFireMode) == int(1)) && int(LoadedFireMode) == int(2))
	{
		MakeNoise(1.0000000);
		WeaponPlaySound(GrenadeFireSound);		
	}
	else
	{
		super.PlayFiringSound();
	}
	//return;	
}

simulated function HideRocketAmmo()
{
	HideRocket('RocketAmmoScale', true);
	//return;	
}

simulated function HideRocket(name RocketName, bool ShouldHide)
{
	local SkelControlSingleBone SkelControl;

	SkelControl = SkelControlSingleBone(SkeletonFirstPersonMesh.FindSkelControl(RocketName));
	// End:0x87
	if(SkelControl != none)
	{
		SkelControl.SetSkelControlStrength(((ShouldHide) ? 1.0000000 : 0.0000000), 0.0000000);
	}
	//return;	
}

simulated function UpdateAmmoVisibility()
{
	// End:0x294
	if(Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
	{
		// End:0xD7
		if(AmmoCount > 2)
		{
			ClearTimer('HideRocketAmmo');
			HideRocket('RocketAmmoScale', false);
			// End:0xD4
			if(bIsAnyAmmoHidden)
			{
				HideRocket('SpikeRocketScale', false);
				HideRocket('BerthaRocketScale', false);
				HideRocket('MackRocketScale', false);
				bIsAnyAmmoHidden = false;
			}			
		}
		else
		{
			// End:0x16A
			if(int(CurrentFireMode) == int(0))
			{
				// End:0x110
				if(AmmoCount == 1)
				{
					SetTimer(0.4800000, false, 'HideRocketAmmo');					
				}
				else
				{
					// End:0x167
					if(AmmoCount == 0)
					{
						HideRocket('SpikeRocketScale', true);
						HideRocket('BerthaRocketScale', true);
						HideRocket('MackRocketScale', true);
						bIsAnyAmmoHidden = true;
					}
				}				
			}
			else
			{
				// End:0x294
				if(!bIsAnyAmmoHidden)
				{
					// End:0x1A3
					if((LoadedShotCount + AmmoCount) == 3)
					{
						bIsAnyAmmoHidden = true;						
					}
					else
					{
						// End:0x1E1
						if((LoadedShotCount + AmmoCount) == 2)
						{
							HideRocket('SpikeRocketScale', true);
							bIsAnyAmmoHidden = true;							
						}
						else
						{
							// End:0x232
							if((LoadedShotCount + AmmoCount) == 1)
							{
								HideRocket('SpikeRocketScale', true);
								HideRocket('BerthaRocketScale', true);
								bIsAnyAmmoHidden = true;								
							}
							else
							{
								// End:0x294
								if((LoadedShotCount + AmmoCount) == 0)
								{
									HideRocket('SpikeRocketScale', true);
									HideRocket('BerthaRocketScale', true);
									HideRocket('MackRocketScale', true);
									bIsAnyAmmoHidden = true;
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

function int AddAmmo(int Amount)
{
	local int NewAmmoCount;

	NewAmmoCount = super.AddAmmo(Amount);
	UpdateAmmoVisibility();
	return NewAmmoCount;
	//return ReturnValue;	
}

simulated event ReplicatedEvent(name VarName)
{
	// End:0x21
	if(VarName == 'AmmoCount')
	{
		UpdateAmmoVisibility();
	}
	super.ReplicatedEvent(VarName);
	//return;	
}

auto simulated state Inactive
{
	ignores Tick;

	simulated function BeginState(name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		// End:0x3E
		if(int(Role) == int(ROLE_Authority))
		{
			bTargetLockingActive = false;
			AdjustLockTarget(none);
		}
		//return;		
	}

	simulated function EndState(name NextStateName)
	{
		super(Object).EndState(NextStateName);
		// End:0x33
		if(int(Role) == int(ROLE_Authority))
		{
			bTargetLockingActive = true;
		}
		//return;		
	}
	stop;	
}

simulated state WeaponLoadAmmo
{
	function int AddAmmo(int Amount)
	{
		return super(UTWeap_RocketLauncher).AddAmmo(Amount);
		//return ReturnValue;		
	}

	simulated function BeginFire(byte FireModeNum)
	{
		// End:0x46
		if(int(FireModeNum) == int(0))
		{
			LoadedFireMode = byte((int(LoadedFireMode) + 1) % 3);
			WeaponPlaySound(AltFireModeChangeSound);
		}
		global.BeginFire(FireModeNum);
		//return;		
	}

	simulated function TimeWeaponFiring(byte FireModeNum)
	{
		SetTimer(GetFireInterval(1), false, 'RefireCheckTimer');
		//return;		
	}

	simulated function WeaponEmpty()
	{
		// End:0x3D
		if(Instigator.IsLocallyControlled())
		{
			StopWeaponAnimation();
			GotoState('WeaponWaitingForFire');			
		}
		else
		{
			global.WeaponEmpty();
		}
		//return;		
	}

	simulated function AddProjectile()
	{
		WeaponPlaySound(AltFireSndQue[Clamp(LoadedShotCount, 0, AltFireSndQue.Length - 1)]);
		// End:0x94
		if(Instigator.IsFirstPerson() && LoadedShotCount < 3)
		{
			PlayWeaponAnimation(LoadUpAnimList[LoadedShotCount], AltFireQueueTimes[LoadedShotCount]);
		}
		TimeWeaponFiring(1);
		//return;		
	}

	simulated function RefireCheckTimer()
	{
		local UTBot B;

		B = UTBot(Instigator.Controller);
		// End:0x14D
		if((B != none) && B.Enemy != none)
		{
			// End:0xBE
			if(B.IsRetreating() || B.IsInState('StakeOut'))
			{
				LoadedFireMode = 2;				
			}
			else
			{
				// End:0x141
				if(VSize(B.Pawn.Location - B.Enemy.Location) < 1000.0000000)
				{
					LoadedFireMode = 1;					
				}
				else
				{
					LoadedFireMode = 0;
				}
			}
		}
		// End:0x1BA
		if(((AmmoCount == 2) && Instigator.IsHumanControlled()) && Instigator.IsLocallyControlled())
		{
			HideRocket('RocketAmmoScale', true);
		}
		// End:0x232
		if((HasAmmo(CurrentFireMode)) && LoadedShotCount < 3)
		{
			MakeNoise(0.1000000);
			WeaponPlaySound(WeaponLoadedSnd);
			WeaponPlaySound(RocketLoadedSound);
			LoadedShotCount++;
			ConsumeAmmo(CurrentFireMode);
		}
		// End:0x280
		if(!StillFiring(1))
		{
			// End:0x26F
			if(LoadedShotCount > 0)
			{
				// End:0x26C
				if(IsInState('WeaponLoadAmmo'))
				{
					WeaponFireLoad();
				}				
			}
			else
			{
				GotoState('Active');
			}			
		}
		else
		{
			// End:0x2C3
			if(!HasAmmo(CurrentFireMode) || LoadedShotCount >= MaxLoadCount)
			{
				GotoState('WeaponWaitingForFire');				
			}
			else
			{
				AddProjectile();
			}
		}
		//return;		
	}

	simulated function EndFire(byte FireModeNum)
	{
		local float MinTimerTarget, TimerCount;

		global.EndFire(FireModeNum);
		// End:0xA0
		if((int(FireModeNum) == int(1)) && LoadedShotCount > 0)
		{
			MinTimerTarget = GetTimerRate('RefireCheckTimer') * WaitToFirePct;
			TimerCount = GetTimerCount('RefireCheckTimer');
			// End:0xA0
			if(TimerCount < MinTimerTarget)
			{
				WeaponFireLoad();
			}
		}
		//return;		
	}

	simulated function EndState(name NextStateName)
	{
		ClearTimer('RefireCheckTimer');
		super(Object).EndState(NextStateName);
		//return;		
	}

	simulated function bool IsFiring()
	{
		return true;
		//return ReturnValue;		
	}

	simulated function bool TryPutDown()
	{
		bWeaponPutDown = true;
		return true;
		//return ReturnValue;		
	}

	simulated function DrawWeaponCrosshair(HUD HUD)
	{
		DrawLFMData(HUD);
		//return;		
	}

	simulated function BeginState(name PreviousStateName)
	{
		LoadedFireMode = 0;
		UpdateAmmoVisibility();
		super(Object).BeginState(PreviousStateName);
		//return;		
	}

	simulated function bool CanViewAccelerationWhenFiring()
	{
		return true;
		//return ReturnValue;		
	}
Begin:

	AddProjectile();
	stop;		
}

simulated state WeaponWaitingForFire
{
	ignores WeaponEmpty;

	simulated function DrawWeaponCrosshair(HUD HUD)
	{
		DrawLFMData(HUD);
		//return;		
	}

	simulated function BeginFire(byte FireModeNum)
	{
		// End:0x46
		if(int(FireModeNum) == int(0))
		{
			LoadedFireMode = byte((int(LoadedFireMode) + 1) % 3);
			WeaponPlaySound(AltFireModeChangeSound);
		}
		global.BeginFire(FireModeNum);
		//return;		
	}

	simulated function EndState(name NextStateName)
	{
		ClearTimer('ForceFireTimer');
		super(Object).EndState(NextStateName);
		//return;		
	}

	simulated function BeginState(name PrevStateName)
	{
		SetTimer(GracePeriod, false, 'ForceFireTimer');
		super(Object).BeginState(PrevStateName);
		//return;		
	}

	simulated function EndFire(byte FireModeNum)
	{
		// End:0x2F
		if((int(FireModeNum) == int(1)) && LoadedShotCount > 0)
		{
			WeaponFireLoad();
		}
		global.EndFire(FireModeNum);
		//return;		
	}

	simulated function ForceFireTimer()
	{
		WeaponFireLoad();
		//return;		
	}

	simulated function bool IsFiring()
	{
		return true;
		//return ReturnValue;		
	}

	simulated function bool TryPutDown()
	{
		bWeaponPutDown = true;
		return true;
		//return ReturnValue;		
	}
	stop;	
}

simulated state WeaponPlayingFire
{
	simulated function PlayFiringAnim()
	{
		local int Index;

		Index = Max(LoadedShotCount, 1);
		PlayWeaponAnimation(WeaponAltFireLaunch[Index - 1], AltFireLaunchTimes[Index - 1]);
		SetTimer(AltFireLaunchTimes[Index - 1], false, 'FireAnimDone');
		//return;		
	}

	simulated function PlayFiringEndAnim()
	{
		local int Index;

		Index = Max(LoadedShotCount, 1);
		PlayWeaponAnimation(WeaponAltFireLaunchEnd[Index - 1], AltFireEndTimes[Index - 1]);
		SetTimer(AltFireEndTimes[Index - 1], false, 'FireAnimEnded');
		//return;		
	}

	simulated function FireAnimDone()
	{
		PlayFiringEndAnim();
		//return;		
	}

	simulated function FireAnimEnded()
	{
		// End:0x19
		if(bWeaponPutDown)
		{
			PutDownWeapon();
			return;
		}
		// End:0x35
		if(!HasAnyAmmo())
		{
			WeaponEmpty();			
		}
		else
		{
			GotoState('Active');
		}
		//return;		
	}

	simulated function EndState(name NextStateName)
	{
		LoadedShotCount = 0;
		ClearFlashCount();
		ClearFlashLocation();
		ClearTimer('FireAnimDone');
		ClearTimer('FireAnimEnded');
		LoadedFireMode = 0;
		//return;		
	}

	simulated function bool IsFiring()
	{
		return true;
		//return ReturnValue;		
	}
Begin:

	WeaponPlaySound(WeaponLoadedSnd);
	PlayFiringAnim();
	stop;		
}

simulated state WeaponFiring
{
	simulated event ReplicatedEvent(name VarName)
	{
		// End:0x32
		if((VarName == 'AmmoCount') && !HasAnyAmmo())
		{
			UpdateAmmoVisibility();
		}
		super.ReplicatedEvent(VarName);
		//return;		
	}
	stop;	
}

simulated state Active
{
	simulated event BeginState(name PreviousStateName)
	{
		// End:0x31
		if(Instigator != none)
		{
			Instigator.SetFiringMode(self, 0);
		}
		super.BeginState(PreviousStateName);
		//return;		
	}
	stop;	
}

defaultproperties
{
	GrenadeString="[Grenades]"
	SpiralString="[Spiral]"
	// Reference: ForceFeedbackWaveform'UTGame.Default__UTWeap_RocketLauncher.ForceFeedbackWaveformShooting1'
	// Archetype: ForceFeedbackWaveform'UTGame.Default__UTWeapon.ForceFeedbackWaveformShooting1'
	begin object name="ForceFeedbackWaveformShooting1"
	end object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	InventoryGroup=8
	UseHintString="As with any weapon with splash damage, it's best to aim for the ground near your enemy than trying to go for a direct hit. Combine loading up multiple rockets with aiming for the ground for maximum effect!"
	// Reference: UDKSkeletalMeshComponent'UTGame.Default__UTWeap_RocketLauncher.FirstPersonMesh'
	// Archetype: UDKSkeletalMeshComponent'UTGame.Default__UTWeapon.FirstPersonMesh'
	begin object name="FirstPersonMesh"
		ReplacementPrimitive=none
	end object
	Mesh=FirstPersonMesh
	Priority=10.1000004
	ItemName="Rocket Launcher"
	PickupMessage="Rocket Launcher"
	// Reference: SkeletalMeshComponent'UTGame.Default__UTWeap_RocketLauncher.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	// Archetype: SkeletalMeshComponent'UTGame.Default__UTWeapon.PickupMesh'
	begin object name="PickupMesh"
		ReplacementPrimitive=none
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
}