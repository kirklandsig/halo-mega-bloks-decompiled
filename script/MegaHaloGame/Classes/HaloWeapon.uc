class HaloWeapon extends UTWeapon
	config(Weapon);

var string HUDIcon;
var const localized string SwapToMessage;
var int zoomLevelCt;
var name ReloadPawnAnimName;
var float ReloadTime;
var float ReloadBlendInTime;
var float ReloadBlendOutTime;
var int ExtraAmmoCount;
var int MaxExtraAmmoCount;
var bool bInfiniteExtraAmmo;
var bool bIsEnergyPowered;
var bool bIsPlayingLoopFiringSound;
var bool bIsLocalPlayer;
var float OverheatPct;
var float CooldownPct;
var float HeatPerShot;
var float CooldownRate;
var name CooldownPawnAnimName;
var float CooldownPawnAnimTime;
var float AutoReloadDelay;
var float AutoReloadBusyDelay;
var float AutoReloadTime;
var array<AkEvent> FireSoundEvent;
var AkEvent MeleeSoundEvent;
var AkEvent ReloadSoundEvent;
var AkEvent SwitchToSoundEvent;
var AkEvent OverheatSoundEvent;
var AkEvent ZoomInSoundEvent;
var AkEvent ZoomOutSoundEvent;
var array<HaloAkEventActor> RicochetEventArray;
var int CurrentRicochetIndex;
var const int RicochetArraySize;
var AkEvent RicochetSoundEvent;
var AkEvent AmmoPickupSoundEvent;
var name akWeaponType;
var float SpreadMin;
var float SpreadMax;
var float SpreadIncWithEachShot;
var float SpreadDecRate;
var StaticMesh DroppedPickupMeshTemplate;
var name MeleeAnimName;
var float MeleeRange;
var float MaxMeleeAngle;
var int MeleeDamage;
var name ThrowGrenadePawnAnimName;
var name ReadyPawnAnimName;
var name FirePawnAnimName;
var name FireChargedPawnAnimName;
var name RelaxPawnAnimName;
var float DelayedWeaponFireBeginTime;
var ForceFeedbackWaveform FireWaveform;
var ForceFeedbackWaveform RemoveClipWaveform;
var ForceFeedbackWaveform InsertClipWaveform;
var ForceFeedbackWaveform MeleeWaveform;
var float FireFeedbackDelay;
var float RemoveClipFeedbackDelay;
var float InsertClipFeedbackDelay;
var float MeleeFeedbackDelay;
var CameraShake FireCameraShake;
var CameraShake MeleeCameraShake;
var float HorizontalRecoilRate;
var float VerticalRecoilRate;
var float DefaultRecoilSpread;
var int MergeLowAmmoPercent;
var float MergeRange;

simulated function PostBeginPlay()
{
	PopulateRicochetArray(RicochetArraySize, RicochetSoundEvent);
	super.PostBeginPlay();
	//return;	
}

simulated event Tick(float DeltaTime)
{
	super(Actor).Tick(DeltaTime);
	TickSpread(DeltaTime);
	TickOverheating(DeltaTime);
	//return;	
}

simulated function StartFire(byte FireModeNum)
{
	SetIsFiring(true);
	super(Weapon).StartFire(FireModeNum);
	//return;	
}

simulated function StopFire(byte FireModeNum)
{
	SetIsFiring(false);
	super(Weapon).StopFire(FireModeNum);
	//return;	
}

simulated function SetIsFiring(bool IsFiring)
{
	local HaloPawn myPawn;

	myPawn = HaloPawn(Instigator);
	// End:0x54
	if(myPawn != none)
	{
		myPawn.SetIsFiring(IsFiring);
	}
	//return;	
}

simulated function FireAmmunition()
{
	// End:0x3B
	if(AmmoCount > 0)
	{
		super.FireAmmunition();
		PlayHaloFireEffects();
		ApplySpreadFromShot();
		ApplyHeatFromShot();		
	}
	else
	{
		// End:0x98
		if((ExtraAmmoCount > 0) && AmmoCount <= 0)
		{
			// End:0x8D
			if(bIsPlayingLoopFiringSound)
			{
				PlayAkEvent(AkEvent'Weapons.Stop_Weapon_Fire_Loop');
				bIsPlayingLoopFiringSound = false;
			}
			ReloadAmmo();
		}
	}
	//return;	
}

simulated function bool StillFiring(byte FireMode)
{
	// End:0x4D
	if(CCSController(Instigator.Controller) != none)
	{
		return Instigator.IsFiring();
	}
	return super.StillFiring(FireMode);
	//return ReturnValue;	
}

simulated function Vector InstantFireStartTrace()
{
	local UTPawn UTInstigator;
	local HaloAIPawn AIInstigator;
	local Vector StartTrace;

	AIInstigator = HaloAIPawn(Instigator);
	// End:0x4C
	if(AIInstigator != none)
	{
		return AIInstigator.GetWeaponStartTraceLocation();
	}
	UTInstigator = UTPawn(Instigator);
	// End:0x19E
	if(UTInstigator != none)
	{
		StartTrace.X = Instigator.Location.X;
		StartTrace.Y = Instigator.Location.Y;
		StartTrace.Z = UTInstigator.CurrentWeaponAttachment.Mesh.Bounds.Origin.Z;
	}
	return StartTrace;
	//return ReturnValue;	
}

simulated function InstantFire()
{
	local Vector StartTrace, EndTrace;
	local array<ImpactInfo> ImpactList;
	local ImpactInfo RealImpact, NearImpact;
	local int I, FinalImpactIndex;
	local bool bDoingRicochet;

	StartTrace = InstantFireStartTrace();
	EndTrace = InstantFireEndTrace(StartTrace);
	bUsingAimingHelp = false;
	RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);
	FinalImpactIndex = ImpactList.Length - 1;
	// End:0x17E
	if((FinalImpactIndex >= 0) && (ImpactList[FinalImpactIndex].HitActor == none) || ImpactList[FinalImpactIndex].HitActor.bProjTarget!)
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
	// End:0x221
	if(Instigator.IsA('HaloPawn'))
	{
		HaloPawn(Instigator).OnWeaponFire();
	}
	// End:0x377
	if(ImpactList.Length > 0)
	{
		bDoingRicochet = false;
		// End:0x377
		if(bDoingRicochet)
		{
			StartTrace = RealImpact.HitLocation;
			EndTrace -= StartTrace;
			EndTrace -= ((2.0000000 * (EndTrace Dot RealImpact.HitNormal)) * RealImpact.HitNormal);
			EndTrace += StartTrace;
			RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);
			I = 0;
			J0x32A:

			// End:0x377 [Loop If]
			if(I < ImpactList.Length)
			{
				ProcessInstantHit(CurrentFireMode, ImpactList[I]);
				I++;
				// [Loop Continue]
				goto J0x32A;
			}
		}
	}
	// End:0x3FC
	if(int(Role) == int(ROLE_Authority))
	{
		// End:0x3D6
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

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
	local Class<HaloDamageType> HaloDamageClass;
	local float DamageScaler, NormalDamage;
	local HaloWeaponAttachment Attachment;
	local HaloAIPawn ownerAIPawn;

	DamageScaler = 1.0000000;
	// End:0xD0
	if(OwnerIsAI())
	{
		HaloDamageClass = Class<HaloDamageType>(InstantHitDamageTypes[int(FiringMode)]);
		// End:0x7C
		if(HaloDamageClass != none)
		{
			DamageScaler = HaloDamageClass.default.FromAIScaler;
		}
		ownerAIPawn = HaloAIPawn(Owner);
		// End:0xD0
		if(ownerAIPawn != none)
		{
			DamageScaler *= ownerAIPawn.DamageScale;
		}
	}
	// End:0x169
	if(DamageScaler != 1.0000000)
	{
		NormalDamage = InstantHitDamage[int(FiringMode)];
		InstantHitDamage[int(FiringMode)] *= DamageScaler;
		super.ProcessInstantHit(FiringMode, Impact, NumHits);
		InstantHitDamage[int(FiringMode)] = NormalDamage;		
	}
	else
	{
		super.ProcessInstantHit(FiringMode, Impact, NumHits);
	}
	PlayRicochetSound(Impact.HitLocation);
	Attachment = HaloWeaponAttachment(GetCurrentWeaponAttachment());
	// End:0x21A
	if(Attachment != none)
	{
		Attachment.ProcessInstantHit(FiringMode, Impact, NumHits);
	}
	//return;	
}

function Projectile SpawnProjectile(Class<Projectile> ProjectileClass, Vector ProjectileStart, Vector ProjectileDir)
{
	local Actor Spawner;
	local HaloGameDefault Game;
	local Projectile Proj;
	local HaloProjectile haloProj;
	local Actor HitActor;
	local Vector HitLocation, HitNormal;

	Spawner = ((Instigator != none) ? Instigator : self);
	Game = HaloGameDefault(WorldInfo.Game);
	// End:0x11B
	if(Game != none)
	{
		Proj = Projectile(Game.TheRAM.RequestActor(ProjectileClass, self));
		haloProj = HaloProjectile(Proj);
		// End:0x11B
		if(haloProj != none)
		{
			haloProj.BeginReplay(Pawn(Spawner), ProjectileStart);
		}
	}
	// End:0x187
	if(Proj == none)
	{
		Proj = Spawner.Spawn(ProjectileClass,,, ProjectileStart);
		haloProj = HaloProjectile(Proj);
	}
	// End:0x1BC
	if((Proj == none) || Proj.bDeleteMe)
	{
		return none;
	}
	// End:0x207
	if(Instigator.IsA('HaloPawn'))
	{
		HaloPawn(Instigator).OnWeaponFire();
	}
	// End:0x24B
	if(OwnerIsAI())
	{
		// End:0x24B
		if(haloProj != none)
		{
			haloProj.InitForAI(Owner);
		}
	}
	Proj.Init(ProjectileDir);
	HitActor = Trace(HitLocation, HitNormal, ProjectileStart, Instigator.Location, true);
	// End:0x437
	if(HitActor != none)
	{
		// End:0x437
		if((HaloDestructibleActor(HitActor) == none) || HaloDestructibleActor(HitActor).bPassShotsFromWithin!)
		{
			Proj.SetLocation(HitLocation);
			Proj.Explode(HitLocation, ProjectileDir-);
			HitActor.TakeDamage(int(Proj.Damage), Proj.InstigatorController, HitLocation, Proj.MomentumTransfer * Normal(Proj.Velocity), Proj.MyDamageType,, Proj);
			return none;
		}
	}
	return Proj;
	//return ReturnValue;	
}

simulated function Projectile ProjectileFire()
{
	local HaloPlayerPawnController Controller;
	local Rotator traceDir;
	local Vector TraceStart, TraceEnd, HitLocation, HitNormal;
	local Actor HitActor;
	local Vector ProjectileStart, ProjectileDir;

	IncrementFlashCount();
	// End:0x207
	if(int(Role) == int(ROLE_Authority))
	{
		TraceStart = InstantFireStartTrace();
		Controller = HaloPlayerPawnController(Instigator.Controller);
		// End:0xB1
		if(Controller != none)
		{
			HitLocation = Controller.GetAimLocationFor(self, TraceStart, HitActor);			
		}
		else
		{
			// End:0xF3
			if(Instigator != none)
			{
				traceDir = Instigator.GetAdjustedAimFor(self, TraceStart);
			}
			TraceEnd = TraceStart + (Vector(traceDir) * (GetTraceRange()));
			HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true);
			// End:0x176
			if(HitActor == none)
			{
				HitLocation = TraceEnd;
			}
		}
		ProjectileStart = GetMuzzleFlashLocation();
		ProjectileDir = Normal(HitLocation - ProjectileStart);
		// End:0x1E0
		if(VSizeSq(ProjectileDir) > 0.0100000)
		{
			ProjectileDir = Vector(AddSpread(Rotator(ProjectileDir)));
		}
		return SpawnProjectile(GetProjectileClass(), ProjectileStart, ProjectileDir);
	}
	return none;
	//return ReturnValue;	
}

simulated function SendToFiringState(byte FireModeNum)
{
	super.SendToFiringState(FireModeNum);
	AutoReloadTime = 0.0000000;
	//return;	
}

simulated function TryToSwapWeaponsIfOutOfAmmo()
{
	local HaloPlayerPawnController C;

	// End:0x7E
	if(HasAnyAmmo()!)
	{
		// End:0x7E
		if(Instigator != none)
		{
			C = HaloPlayerPawnController(Instigator.Controller);
			// End:0x7E
			if(C != none)
			{
				C.SwapWeapons(true);
			}
		}
	}
	//return;	
}

simulated function HandleFinishedFiring()
{
	super(Weapon).HandleFinishedFiring();
	// End:0x3C
	if(bIsPlayingLoopFiringSound)
	{
		PlayAkEvent(AkEvent'Weapons.Stop_Weapon_Fire_Loop');
		bIsPlayingLoopFiringSound = false;
	}
	//return;	
}

simulated function float PlayTopHalfAnim(name AnimName, optional float ForceDuration = 0.0000000, optional float failedDuration = 1.5000000, optional float BlendInTime = 0.0000000, optional float BlendOutTime = 0.0000000, optional bool Loop = false)
{
	return PlayPawnAnim(AnimName, false, ForceDuration, failedDuration, BlendInTime, BlendOutTime, Loop);
	//return ReturnValue;	
}

simulated function float PlayPawnAnim(name AnimName, bool bIsFullBodyAnim, optional float ForceDuration = 0.0000000, optional float failedDuration = 1.5000000, optional float BlendInTime = 0.0000000, optional float BlendOutTime = 0.0000000, optional bool Loop = false)
{
	local HaloPawn aPawn;

	aPawn = HaloPawn(Instigator);
	// End:0xB6
	if(aPawn != none)
	{
		return aPawn.PlayCustomAnimation(AnimName, bIsFullBodyAnim, Loop, ForceDuration, failedDuration, BlendInTime, BlendOutTime);
	}
	return ((ForceDuration > 0.0000000) ? ForceDuration : failedDuration);
	//return ReturnValue;	
}

function UTWeaponAttachment GetCurrentWeaponAttachment()
{
	local UTPawn UTOwner;

	UTOwner = UTPawn(Owner);
	// End:0x4A
	if(UTOwner != none)
	{
		return UTOwner.CurrentWeaponAttachment;
	}
	//return ReturnValue;	
}

function Vector GetMuzzleFlashLocation()
{
	local Vector MuzzleFlashLoc;
	local UTWeaponAttachment Attachment;

	Attachment = GetCurrentWeaponAttachment();
	// End:0x83
	if(Attachment != none)
	{
		// End:0x83
		if(Attachment.Mesh.GetSocketWorldLocationAndRotation(Attachment.MuzzleFlashSocket, MuzzleFlashLoc))
		{
		}
	}
	return MuzzleFlashLoc;
	//return ReturnValue;	
}

function AddToSpread(float S, optional int I = 0)
{
	Spread[I] = FClamp(Spread[I] + S, SpreadMin, SpreadMax);
	//return;	
}

function ApplySpreadFromShot()
{
	AddToSpread(SpreadIncWithEachShot);
	//return;	
}

function TickSpread(float DeltaTime)
{
	local float ScaleRange, CurScale;

	// End:0x2E
	if(IsFiring()!)
	{
		AddToSpread(SpreadDecRate * DeltaTime);
	}
	// End:0xBC
	if(false)
	{
		ScaleRange = Abs(SpreadMax - SpreadMin);
		CurScale = Abs(Spread[0] - SpreadMin);
		// End:0xAD
		if(ScaleRange != float(0))
		{
			CrosshairScaling = (CurScale / ScaleRange) + 1.0000000;			
		}
		else
		{
			CrosshairScaling = 1.0000000;
		}
	}
	//return;	
}

function ConsumeAmmo(byte FireModeNum)
{
	// End:0x3A
	if(OwnerIsPlayer())
	{
		AmmoCount = Max(0, AmmoCount - ShotCost[int(FireModeNum)]);
	}
	//return;	
}

function int AddAmmo(int Amount)
{
	// End:0x39
	if((AmmoCount + Amount) < MaxAmmoCount)
	{
		AmmoCount += Amount;		
	}
	else
	{
		ExtraAmmoCount += Amount;
		ExtraAmmoCount += (AmmoCount - MaxAmmoCount);
		AmmoCount = MaxAmmoCount;
		ExtraAmmoCount = Min(ExtraAmmoCount, MaxExtraAmmoCount);
	}
	// End:0x106
	if((AmmoCount <= 0) && (UTInventoryManager(InvManager) == none) || UTInventoryManager(InvManager).bInfiniteAmmo)
	{
		AmmoCount = MaxAmmoCount;
	}
	return AmmoCount;
	//return ReturnValue;	
}

simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
	// End:0x20
	if(int(FireModeNum) == int(0))
	{
		return HasAnyAmmo();
	}
	return false;
	//return ReturnValue;	
}

simulated function bool HasAnyAmmo()
{
	return (AmmoCount + ExtraAmmoCount) > 0;
	//return ReturnValue;	
}

simulated function WeaponEmpty()
{
	// End:0x1B
	if(IsFiring())
	{
		GotoState('Active');
	}
	//return;	
}

simulated function bool CanReloadAmmo()
{
	// End:0x33
	if(AmmoCount < MaxAmmoCount)
	{
		return (ExtraAmmoCount > 0) || bInfiniteExtraAmmo;
	}
	return false;
	//return ReturnValue;	
}

simulated exec function bool ReloadAmmo(optional bool abortGrenadeThrows = true)
{
	// End:0x49
	if(CanReloadAmmo())
	{
		// End:0x49
		if(DoReload(abortGrenadeThrows))
		{
			// End:0x47
			if(int(Role) < int(ROLE_Authority))
			{
				ServerDoReload();
			}
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

reliable server function ServerDoReload()
{
	DoReload(true);
	//return;	
}

simulated function bool DoReload(optional bool abortGrenadeThrows)
{
	local HaloPawn P;

	P = HaloPawn(Instigator);
	// End:0x93
	if(P != none)
	{
		// End:0x61
		if(abortGrenadeThrows! && P.IsThrowingGrenade())
		{
			return false;
		}
		// End:0x93
		if(P.WaitForWeaponReload())
		{
			GotoState('ReloadingAmmo');
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function OwnerStoppedWaitingForReload()
{
	//return;	
}

simulated function ReloadNow()
{
	// End:0x23
	if(bInfiniteExtraAmmo)
	{
		AmmoCount = MaxAmmoCount;		
	}
	else
	{
		ExtraAmmoCount += AmmoCount;
		AmmoCount = Min(ExtraAmmoCount, MaxAmmoCount);
		ExtraAmmoCount -= AmmoCount;
	}
	//return;	
}

function TickAutoReload(float DeltaTime)
{
	local HaloPawn P;

	// End:0x19C
	if(CanReloadAmmo())
	{
		// End:0x54
		if(AutoReloadTime <= float(0))
		{
			AutoReloadTime = WorldInfo.TimeSeconds + AutoReloadDelay;			
		}
		else
		{
			// End:0x9D
			if(AutoReloadTime <= WorldInfo.TimeSeconds)
			{
				AutoReloadTime = 0.0000000;
				ReloadAmmo();				
			}
			else
			{
				// End:0x19C
				if(AutoReloadTime < (WorldInfo.TimeSeconds + AutoReloadBusyDelay))
				{
					P = HaloPawn(Instigator);
					// End:0x19C
					if(P != none)
					{
						// End:0x19C
						if((P.IsBusy() || P.IsGrabbingLedge()) || P.IsThrowingGrenade())
						{
							AutoReloadTime = WorldInfo.TimeSeconds + AutoReloadBusyDelay;
						}
					}
				}
			}
		}
	}
	//return;	
}

function int GiveAmmo(int Amount, bool bJustExtra)
{
	// End:0x4D
	if(bJustExtra)
	{
		Amount = Min(Amount, MaxExtraAmmoCount - ExtraAmmoCount);
		ExtraAmmoCount += Amount;		
	}
	else
	{
		Amount = Min(Amount, (MaxAmmoCount + MaxExtraAmmoCount) - (AmmoCount + ExtraAmmoCount));
		AmmoCount += Amount;
		// End:0xE9
		if(AmmoCount > MaxAmmoCount)
		{
			ExtraAmmoCount += (AmmoCount - MaxAmmoCount);
			AmmoCount = MaxAmmoCount;
		}
	}
	return Amount;
	//return ReturnValue;	
}

function GiveAmmoTo(HaloWeapon toWeap, bool bJustExtra)
{
	// End:0xB7
	if((toWeap != none) && toWeap.Class == Class)
	{
		ExtraAmmoCount -= toWeap.GiveAmmo(ExtraAmmoCount, bJustExtra);
		AmmoCount -= toWeap.GiveAmmo(AmmoCount, bJustExtra);
	}
	//return;	
}

function bool ShouldTickOverheating()
{
	return IsFiring()!;
	//return ReturnValue;	
}

function TickOverheating(float DeltaTime)
{
	// End:0x4E
	if(ShouldTickOverheating())
	{
		OverheatPct -= (CooldownRate * DeltaTime);
		// End:0x4E
		if(OverheatPct < 0.0000000)
		{
			OverheatPct = 0.0000000;
		}
	}
	//return;	
}

function ApplyHeat(float heat)
{
	OverheatPct += heat;
	// End:0x62
	if(OverheatPct >= 1.0000000)
	{
		OverheatPct = 1.0000000;
		GotoState('Overheated');
		// End:0x62
		if(int(Role) == int(ROLE_Authority))
		{
			ClientOverheat();
		}
	}
	//return;	
}

function ApplyHeatFromShot()
{
	ApplyHeat(HeatPerShot);
	//return;	
}

reliable client simulated function ClientOverheat()
{
	GotoState('Overheated');
	//return;	
}

simulated function float PlayOverheatAnimation()
{
	return PlayTopHalfAnim(CooldownPawnAnimName, CooldownPawnAnimTime);
	//return ReturnValue;	
}

simulated function TimeWeaponPutDown()
{
	local name AnimName;
	local HaloWeapon PendingWeapon;
	local UTPawn.EWeapAnimType NextWeapAnimType;
	local HaloPawn P;

	// End:0xC7
	if((Instigator != none) && Instigator.InvManager != none)
	{
		PendingWeapon = HaloWeapon(Instigator.InvManager.PendingWeapon);
		// End:0xC7
		if(PendingWeapon != none)
		{
			NextWeapAnimType = PendingWeapon.AttachmentClass.default.WeapAnimType;
		}
	}
	AnimName = GetSwapWeaponAnimName(AttachmentClass.default.WeapAnimType, NextWeapAnimType);
	P = HaloPawn(Owner);
	// End:0x15A
	if(P != none)
	{
		// End:0x15A
		if(P.PlayWeaponSwapAnim(AnimName))
		{
			return;
		}
	}
	super.TimeWeaponPutDown();
	//return;	
}

function name GetSwapWeaponAnimName(UTPawn.EWeapAnimType CurAnimType, UTPawn.EWeapAnimType NextAnimType)
{
	switch(CurAnimType)
	{
		// End:0x18
		case 1:
		// End:0x31
		case 4:
			return GetSwapWeaponAnimNameFromPistol(NextAnimType);
		// End:0x4A
		case 2:
			return GetSwapWeaponAnimNameFromDualPistols(NextAnimType);
		// End:0xFFFF
		default:
			return GetSwapWeaponAnimNameFromRifle(NextAnimType);
			break;
	}
	//return ReturnValue;	
}

function name GetSwapWeaponAnimNameFromPistol(UTPawn.EWeapAnimType NextAnimType)
{
	switch(NextAnimType)
	{
		// End:0x22
		case 1:
			return 'Spartan_Swap_RifPist';
		// End:0x31
		case 2:
			return 'Spartan_Swap_PistTargDes';
		// End:0x40
		case 4:
			return 'Sword_Equip';
		// End:0xFFFF
		default:
			return 'Spartan_Swap_PistRif';
			break;
	}
	//return ReturnValue;	
}

function name GetSwapWeaponAnimNameFromDualPistols(UTPawn.EWeapAnimType NextAnimType)
{
	switch(NextAnimType)
	{
		// End:0x22
		case 1:
			return 'Spartan_Swap_TargDesPist';
		// End:0x31
		case 2:
			return 'Spartan_Swap_RifTargDes';
		// End:0x40
		case 4:
			return 'Sword_Equip';
		// End:0xFFFF
		default:
			return 'Spartan_Swap_TargDesRif';
			break;
	}
	//return ReturnValue;	
}

function name GetSwapWeaponAnimNameFromRifle(UTPawn.EWeapAnimType NextAnimType)
{
	switch(NextAnimType)
	{
		// End:0x22
		case 1:
			return 'Spartan_Swap_RifPist';
		// End:0x31
		case 2:
			return 'Spartan_Swap_RifTargDes';
		// End:0x40
		case 4:
			return 'Sword_Equip';
		// End:0xFFFF
		default:
			return 'Spartan_Swap_RifRif';
			break;
	}
	//return ReturnValue;	
}

function DropFrom(Vector StartLocation, Vector StartVelocity)
{
	local HaloDroppedPickup P;
	local bool throwForward;
	local HaloDroppedPickup pickupInRange;
	local TraceHitInfo HitInfo;
	local Vector fromPickup;

	// End:0xF3
	if(Instigator != none)
	{
		// End:0x61
		if(Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
		{
			PreloadTextures(false);
		}
		// End:0xBA
		if(Instigator.InvManager != none)
		{
			Instigator.InvManager.RemoveFromInventory(self);
		}
		StartLocation += (vect(40.0000000, 10.0000000, 0.0000000) >> Instigator.Rotation);
	}
	// End:0x107
	if(HasAnyAmmo()!)
	{
		Destroy();
		return;
	}
	// End:0x11F
	if(TryToMergeWithDroppedWeapons(StartLocation))
	{
		return;
	}
	P = Spawn(Class'MegaHaloGame.HaloDroppedPickup', self,, StartLocation);
	// End:0x15F
	if(P == none)
	{
		Destroy();
		return;
	}
	P.Inventory = self;
	P.Instigator = Instigator;
	P.SetStaticMesh(DroppedPickupMeshTemplate);
	P.AddToGlobalList();
	StartVelocity = vect(0.0000000, 0.0000000, 0.0000000);
	throwForward = true;
	// End:0x2FE
	foreach P.CollidingActors(Class'MegaHaloGame.HaloDroppedPickup', pickupInRange, 1000.0000000, StartLocation, true,, HitInfo)
	{
		// End:0x275
		if(pickupInRange == P)
		{
			continue;			
		}
		fromPickup = StartLocation - pickupInRange.Location;
		fromPickup.Z = 0.0000000;
		// End:0x2F1
		if(IsZero(fromPickup)!)
		{
			StartVelocity += Normal(fromPickup);
		}
		throwForward = false;		
	}	
	// End:0x339
	if(throwForward)
	{
		StartVelocity = Vector(Instigator.Rotation);		
	}
	else
	{
		// End:0x384
		if(VSizeSq2D(StartVelocity) < 0.0001000)
		{
			StartVelocity = VRand();
			StartVelocity.Z = 0.0000000;
		}
	}
	StartVelocity = 250.0000000 * Normal(StartVelocity);
	StartVelocity.Z = 250.0000000;
	P.Velocity = StartVelocity;
	Instigator = none;
	GotoState('None');
	//return;	
}

function MergeWithDroppedWeapons(Vector SearchLocation)
{
	local HaloGameDefault Game;
	local array<HaloDroppedPickupWithDistSq> pickupList;
	local HaloDroppedPickupWithDistSq iter;
	local HaloWeapon pickupWeap;

	// End:0x0F
	if(bInfiniteExtraAmmo)
	{
		return;
	}
	Game = HaloGameDefault(WorldInfo.Game);
	// End:0x77
	if((Game == none) || Game.ThePickupManager == none)
	{
		return;
	}
	Game.ThePickupManager.FindPickupsInRange(pickupList, SearchLocation, -1.0000000, Class);
	// End:0x14A
	foreach pickupList(iter)
	{
		pickupWeap = HaloWeapon(iter.Pickup.Inventory);
		// End:0x149
		if(pickupWeap != self)
		{
			GiveAmmoTo(pickupWeap, false);
		}		
	}	
	//return;	
}

function bool TryToMergeWithDroppedWeapons(Vector StartLocation)
{
	local int totalAmmo, maxAmmo;
	local HaloGameDefault Game;
	local array<HaloDroppedPickupWithDistSq> pickupList;
	local HaloDroppedPickupWithDistSq iter;
	local HaloWeapon pickupWeap;
	local int maxRecvAmmo;

	// End:0x0F
	if(bInfiniteExtraAmmo)
	{
		return false;
	}
	totalAmmo = AmmoCount + ExtraAmmoCount;
	maxAmmo = MaxAmmoCount + MaxExtraAmmoCount;
	// End:0x2C2
	if(((100 * totalAmmo) / maxAmmo) <= MergeLowAmmoPercent)
	{
		Game = HaloGameDefault(WorldInfo.Game);
		// End:0xD9
		if((Game == none) || Game.ThePickupManager == none)
		{
			return false;
		}
		Game.ThePickupManager.FindPickupsInRange(pickupList, StartLocation, MergeRange, Class);
		// End:0x143
		if(pickupList.Length <= 0)
		{
			return false;
		}
		// End:0x231
		foreach pickupList(iter)
		{
			pickupWeap = HaloWeapon(iter.Pickup.Inventory);
			maxRecvAmmo += (pickupWeap.MaxAmmoCount - pickupWeap.AmmoCount);
			maxRecvAmmo += (pickupWeap.MaxExtraAmmoCount - pickupWeap.ExtraAmmoCount);			
		}		
		// End:0x2C2
		if(totalAmmo <= maxRecvAmmo)
		{
			// End:0x2B9
			foreach pickupList(iter)
			{
				pickupWeap = HaloWeapon(iter.Pickup.Inventory);
				GiveAmmoTo(pickupWeap, false);				
			}			
			Destroy();
			return true;			
		}
	}
	return false;
	//return ReturnValue;	
}

simulated function DetachWeapon()
{
	// End:0x40
	if(HaloPawn(Instigator) != none)
	{
		HaloPawn(Instigator).OnWeaponDetach();
	}
	super.DetachWeapon();
	OverheatPct = 0.0000000;
	CooldownPct = 1.0000000;
	//return;	
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
	super.AttachWeaponTo(MeshCpnt, SocketName);
	// End:0x5D
	if(HaloPawn(Instigator) != none)
	{
		HaloPawn(Instigator).OnWeaponAttach();
	}
	//return;	
}

simulated function PlayHaloFireEffects(optional float magnitude = 1.0000000)
{
	PlayFiringSound();
	PlayFireCameraShake(magnitude);
	InitiateFireFeedback();
	//return;	
}

simulated function PlayHaloMeleeEffects(optional float magnitude = 1.0000000)
{
	PlayMeleeSound();
	PlayMeleeCameraShake(magnitude);
	InitiateMeleeFeedback();
	//return;	
}

simulated function PlayFiringSound()
{
	SetLocation(GetMuzzleFlashLocation());
	// End:0x159
	if(int(CurrentFireMode) < FireSoundEvent.Length)
	{
		// End:0x159
		if(FireSoundEvent[int(CurrentFireMode)] != none)
		{
			// End:0x159
			if((FireSoundEvent[int(CurrentFireMode)] != AkEvent'Weapons.Play_Weapon_Fire_Loop') || bIsPlayingLoopFiringSound!)
			{
				bIsLocalPlayer = Instigator.Controller.IsLocalPlayerController();
				SetSwitch('Local_Player', ((bIsLocalPlayer) ? 'Yes' : 'No'));
				SetSwitch('Weapon_Type', akWeaponType);
				PlayAkEvent(FireSoundEvent[int(CurrentFireMode)],,,,,, 1.0000000);
				bIsPlayingLoopFiringSound = FireSoundEvent[int(CurrentFireMode)] == AkEvent'Weapons.Play_Weapon_Fire_Loop';
			}
		}
	}
	//return;	
}

simulated function PlayMeleeSound()
{
	// End:0x7E
	if(MeleeSoundEvent != none)
	{
		SetSwitch('Weapon_Type', akWeaponType);
		SetSwitch('Character_Type', HaloPawn(Instigator).AkCharacterType);
		PlayAkEvent(MeleeSoundEvent);
	}
	//return;	
}

simulated function PlayReloadSound()
{
	// End:0xB2
	if(ReloadSoundEvent != none)
	{
		SetSwitch('Weapon_Type', akWeaponType);
		SetSwitch('Character_Type', HaloPawn(Instigator).AkCharacterType);
		SetSwitch('Local_Player', ((bIsLocalPlayer) ? 'Yes' : 'No'));
		PlayAkEvent(ReloadSoundEvent);
	}
	//return;	
}

simulated function PlayOverheatSound()
{
	// End:0x7E
	if(OverheatSoundEvent != none)
	{
		SetSwitch('Weapon_Type', akWeaponType);
		SetSwitch('Character_Type', HaloPawn(Instigator).AkCharacterType);
		PlayAkEvent(OverheatSoundEvent);
	}
	//return;	
}

simulated function PlaySwitchToSound()
{
	// End:0xB2
	if(SwitchToSoundEvent != none)
	{
		SetSwitch('Weapon_Type', akWeaponType);
		SetSwitch('Character_Type', HaloPawn(Instigator).AkCharacterType);
		SetSwitch('Local_Player', ((bIsLocalPlayer) ? 'Yes' : 'No'));
		PlayAkEvent(SwitchToSoundEvent);
	}
	//return;	
}

simulated function PopulateRicochetArray(int Size, AkEvent E)
{
	local int I;
	local HaloAkEventActor AkActor;

	I = 0;
	J0x0B:

	// End:0xF4 [Loop If]
	if(I < Size)
	{
		AkActor = Spawn(Class'MegaHaloGame.HaloAkEventActor');
		AkActor.SetPlayEvent(E);
		AkActor.SetSwitch('Weapon_Type', akWeaponType);
		AkActor.SetSwitch('Surface', 'Concrete');
		RicochetEventArray.AddItem(AkActor);
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

simulated function PlayRicochetSound(Vector HitLocation)
{
	// End:0x65
	if(RicochetArraySize > 0)
	{
		// End:0x33
		if(CurrentRicochetIndex++ >= RicochetArraySize)
		{
			CurrentRicochetIndex = 0;
		}
		RicochetEventArray[CurrentRicochetIndex].SetLocationAndPlay(HitLocation);
	}
	//return;	
}

simulated function PlayFireCameraShake(optional float magnitude = 1.0000000)
{
	local PlayerController PC;

	PC = PlayerController(Instigator.Controller);
	// End:0x16A
	if((FireCameraShake != none) && PC != none)
	{
		FireCameraShake.RotOscillation.Pitch.Amplitude = float(int((CurrentRecoilSpread()) * HorizontalRecoilRate));
		FireCameraShake.RotOscillation.Yaw.Amplitude = float(int(((CurrentRecoilSpread()) * (RandomFloatSpread())) * VerticalRecoilRate));
		PC.PlayerCamera.PlayCameraShake(FireCameraShake, magnitude);
	}
	//return;	
}

simulated function PlayMeleeCameraShake(optional float magnitude = 1.0000000)
{
	local PlayerController PC;

	PC = PlayerController(Instigator.Controller);
	// End:0xA2
	if((MeleeCameraShake != none) && PC != none)
	{
		PC.PlayerCamera.PlayCameraShake(MeleeCameraShake, magnitude);
	}
	//return;	
}

simulated function InitiateFireFeedback()
{
	((FireFeedbackDelay == 0.0000000) ? PlayFireForceFeedback() : SetTimer(FireFeedbackDelay, false, 'PlayFireForceFeedback'));
	//return;	
}

simulated function InitiateReloadFeedback()
{
	((RemoveClipFeedbackDelay == 0.0000000) ? PlayRemoveClipForceFeedback() : SetTimer(RemoveClipFeedbackDelay, false, 'PlayRemoveClipForceFeedback'));
	((InsertClipFeedbackDelay == 0.0000000) ? PlayInsertClipForceFeedback() : SetTimer(InsertClipFeedbackDelay, false, 'PlayInsertClipForceFeedback'));
	//return;	
}

simulated function InitiateMeleeFeedback()
{
	((MeleeFeedbackDelay == 0.0000000) ? PlayMeleeForceFeedback() : SetTimer(MeleeFeedbackDelay, false, 'PlayMeleeForceFeedback'));
	//return;	
}

simulated function PlayFireForceFeedback()
{
	local UTPlayerController PC;

	PC = UTPlayerController(Instigator.Controller);
	// End:0xA9
	if(((PC != none) && LocalPlayer(PC.Player) != none) && FireWaveform != none)
	{
		PC.ClientPlayForceFeedbackWaveform(FireWaveform);
	}
	//return;	
}

simulated function PlayRemoveClipForceFeedback()
{
	local UTPlayerController PC;

	PC = UTPlayerController(Instigator.Controller);
	// End:0xA9
	if(((PC != none) && LocalPlayer(PC.Player) != none) && RemoveClipWaveform != none)
	{
		PC.ClientPlayForceFeedbackWaveform(RemoveClipWaveform);
	}
	//return;	
}

simulated function PlayInsertClipForceFeedback()
{
	local UTPlayerController PC;

	PC = UTPlayerController(Instigator.Controller);
	// End:0xA9
	if(((PC != none) && LocalPlayer(PC.Player) != none) && InsertClipWaveform != none)
	{
		PC.ClientPlayForceFeedbackWaveform(InsertClipWaveform);
	}
	//return;	
}

simulated function PlayMeleeForceFeedback()
{
	local UTPlayerController PC;

	PC = UTPlayerController(Instigator.Controller);
	// End:0xA9
	if(((PC != none) && LocalPlayer(PC.Player) != none) && MeleeWaveform != none)
	{
		PC.ClientPlayForceFeedbackWaveform(MeleeWaveform);
	}
	//return;	
}

function float CurrentRecoilSpread()
{
	return Spread[int(CurrentFireMode)] + DefaultRecoilSpread;
	//return ReturnValue;	
}

function float RandomFloatSpread()
{
	return (FRand() - 0.5000000) * 2.0000000;
	//return ReturnValue;	
}

function bool OwnerIsPlayer()
{
	return HaloAIPawn(Instigator) == none;
	//return ReturnValue;	
}

function bool OwnerIsAI()
{
	return HaloAIPawn(Instigator) != none;
	//return ReturnValue;	
}

state DelayedWeaponFiring
{
	simulated function bool IsFiring()
	{
		return true;
		//return ReturnValue;		
	}

	simulated event BeginState(name PrevStateName)
	{
		SetTimer(WorldInfo.DeltaSeconds * 2.0000000, false, 'GotoWeaponFiringState');
		//return;		
	}

	simulated function GotoWeaponFiringState()
	{
		GotoState('WeaponFiring');
		//return;		
	}
	stop;	
}

simulated state Active
{
	simulated event BeginState(name PrevStateName)
	{
		super.BeginState(PrevStateName);
		// End:0x4B
		if(AmmoCount <= 0)
		{
			// End:0x4B
			if(bInfiniteExtraAmmo || ExtraAmmoCount > 0)
			{
				ReloadAmmo();
			}
		}
		//return;		
	}

	simulated event Tick(float DeltaTime)
	{
		global.Tick(DeltaTime);
		TickAutoReload(DeltaTime);
		//return;		
	}
	stop;	
}

simulated state ReloadingAmmo
{
	simulated event BeginState(name PrevStateName)
	{
		local float Duration;

		super(Object).BeginState(PrevStateName);
		Duration = PlayTopHalfAnim(ReloadPawnAnimName, ReloadTime, 0.0000000, ReloadBlendInTime, ReloadBlendOutTime);
		// End:0x7E
		if(Duration > 0.0000000)
		{
			SetTimer(Duration, false, 'OnAnimDone');			
		}
		else
		{
			OnAnimDone();
		}
		PlayReloadSound();
		InitiateReloadFeedback();
		//return;		
	}

	simulated event EndState(name NextStateName)
	{
		local HaloPawn P;

		P = HaloPawn(Instigator);
		// End:0x4A
		if(P != none)
		{
			P.OnWeaponReloadDone();
		}
		super(Object).EndState(NextStateName);
		//return;		
	}

	simulated function OnAnimDone()
	{
		local HaloPawn P;

		ReloadNow();
		P = HaloPawn(Instigator);
		// End:0x5B
		if(P != none)
		{
			P.GotoState('None');			
		}
		else
		{
			GotoState('Active');
		}
		//return;		
	}

	simulated function OwnerStoppedWaitingForReload()
	{
		local HaloPawn P;

		P = HaloPawn(Instigator);
		// End:0x72
		if(P != none)
		{
			// End:0x72
			if(P.IsPlayingCustomAnimation())
			{
				P.StopCustomAnimation(false, 0.1500000);
			}
		}
		// End:0xB2
		if(CanReloadAmmo())
		{
			AutoReloadTime = WorldInfo.TimeSeconds + AutoReloadBusyDelay;
		}
		GotoState('Active');
		//return;		
	}
	stop;	
}

simulated state Overheated
{
	ignores EndState;

	simulated function BeginState(name PreviousStateName)
	{
		local float AnimTime;
		local HaloWeaponAttachment HaloWeapAttach;

		PlayOverheatSound();
		HaloWeapAttach = HaloWeaponAttachment(GetCurrentWeaponAttachment());
		// End:0x55
		if(HaloWeapAttach != none)
		{
			HaloWeapAttach.SpawnOverheatFX();
		}
		AnimTime = PlayOverheatAnimation();
		CooldownPct = 0.0000000;
		SetTimer(AnimTime, false, 'OnOverheatAnimDone');
		//return;		
	}

	simulated event OnOverheatAnimDone()
	{
		OverheatPct = 0.0000000;
		CooldownPct = 1.0000000;
		GotoState('Active');
		//return;		
	}

	function TickOverheating(float DeltaTime)
	{
		// End:0x4E
		if(IsTimerActive('OnOverheatAnimDone'))
		{
			CooldownPct = GetTimerCount('OnOverheatAnimDone') / GetTimerRate('OnOverheatAnimDone');			
		}
		else
		{
			CooldownPct = 1.0000000;
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	SwapToMessage="Press [MainHUD.InlineInputIcons.inputIcon_y] To Switch Weapon"
	zoomLevelCt=1
	ReloadPawnAnimName="Reload_Rifle"
	ReloadTime=1.5000000
	ReloadBlendInTime=0.1500000
	ReloadBlendOutTime=0.1500000
	CooldownPct=1.0000000
	CooldownRate=1.0000000
	CooldownPawnAnimName="Overheat_Rifle"
	AutoReloadDelay=10.0000000
	AutoReloadBusyDelay=0.5000000
	AmmoPickupSoundEvent=AkEvent'Weapons.Play_Weapon_Pickup'
	SpreadMax=0.1100000
	SpreadIncWithEachShot=0.0600000
	SpreadDecRate=-0.2000000
	MeleeAnimName="Melee_Rifle"
	MeleeRange=200.0000000
	MaxMeleeAngle=90.0000000
	MeleeDamage=100
	ThrowGrenadePawnAnimName="ThrowGrenade_Rifle"
	MergeLowAmmoPercent=100
	MergeRange=1000.0000000
	bCrosshairShouldHighlightOnValidTarget=true
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon.ForceFeedbackWaveformShooting1'
	// Archetype: ForceFeedbackWaveform'UTGame.Default__UTWeapon.ForceFeedbackWaveformShooting1'
	begin object name="ForceFeedbackWaveformShooting1"
	end object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	InstantHitDamageTypes[0]=Class'MegaHaloGame.HaloDamageType'
	InstantHitDamageTypes[1]=Class'Engine.DamageType'
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon.FirstPersonMesh'
	// Archetype: UDKSkeletalMeshComponent'UTGame.Default__UTWeapon.FirstPersonMesh'
	begin object name="FirstPersonMesh"
		ReplacementPrimitive=none
	end object
	Mesh=FirstPersonMesh
	PickupMessage="Hold [MainHUD.InlineInputIcons.inputIcon_y] To Pick Up Weapon"
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	// Archetype: SkeletalMeshComponent'UTGame.Default__UTWeapon.PickupMesh'
	begin object name="PickupMesh"
		ReplacementPrimitive=none
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
}