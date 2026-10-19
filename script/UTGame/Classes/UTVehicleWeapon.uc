class UTVehicleWeapon extends UTWeapon
	abstract
	config(Weapon);

var int SeatIndex;
var repnotify UTVehicle MyVehicle;
var array<name> FireTriggerTags;
var array<name> AltFireTriggerTags;
var array<MaterialImpactEffect> ImpactEffects;
var array<MaterialImpactEffect> AltImpactEffects;
var MaterialImpactEffect DefaultImpactEffect;
var MaterialImpactEffect DefaultAltImpactEffect;
var SoundCue BulletWhip;
var float LastCorrectAimTime;
var float LastInCorrectAimTime;
var bool bShouldAimAffectCrosshair;
var bool bPlaySoundFromSocket;
var bool bCurrentlyZoomed;
var bool bIgnoreSocketPitchRotation;
var bool bIgnoreDownwardPitch;
var bool bDebugTurret;
var float CurrentCrosshairScaling;
var float MaxFinalAimAdjustment;
var Class<UTVehicle> VehicleClass;

replication
{
	// Pos:0x000
	if(bNetInitial && bNetOwner)
		MyVehicle, SeatIndex;
}

simulated function bool CanHitDesiredTarget(Vector SocketLocation, Rotator SocketRotation, Vector DesiredAimPoint, Actor TargetActor, out Vector RealAimPoint)
{
	local int I;
	local array<Actor> IgnoredActors;
	local Actor HitActor;
	local Vector HitLocation, HitNormal;
	local bool bResult;

	// End:0x1F9
	if((Normal(DesiredAimPoint - SocketLocation) Dot Normal(RealAimPoint - SocketLocation)) >= (GetMaxFinalAimAdjustment()))
	{
		I = 0;
		J0x48:

		// End:0x108 [Loop If]
		if(I < AimingTraceIgnoredActors.Length)
		{
			// End:0xFA
			if((AimingTraceIgnoredActors[I] != none) && AimingTraceIgnoredActors[I].bProjTarget)
			{
				AimingTraceIgnoredActors[I].bProjTarget = false;
				IgnoredActors[IgnoredActors.Length] = AimingTraceIgnoredActors[I];
			}
			I++;
			// [Loop Continue]
			goto J0x48;
		}
		HitActor = GetTraceOwner().Trace(HitLocation, HitNormal, DesiredAimPoint, SocketLocation, true,,, 1);
		// End:0x18A
		if((HitActor == none) || HitActor == TargetActor)
		{
			bResult = true;			
		}
		else
		{
			RealAimPoint = HitLocation;
		}
		I = 0;
		J0x1A8:

		// End:0x1F9 [Loop If]
		if(I < IgnoredActors.Length)
		{
			IgnoredActors[I].bProjTarget = true;
			I++;
			// [Loop Continue]
			goto J0x1A8;
		}
	}
	return bResult;
	//return ReturnValue;	
}

static simulated function DrawKillIcon(Canvas Canvas, float ScreenX, float ScreenY, float HUDScaleX, float HUDScaleY)
{
	// End:0x5B
	if(default.VehicleClass != none)
	{
		default.VehicleClass.static.DrawKillIcon(Canvas, ScreenX, ScreenY, HUDScaleX, HUDScaleY);
	}
	//return;	
}

simulated function GetCrosshairScaling(HUD HUD)
{
	// End:0x21
	if(!bShouldAimAffectCrosshair)
	{
		CrosshairScaling = 1.0000000;		
	}
	else
	{
		// End:0x87
		if(LastCorrectAimTime > LastInCorrectAimTime)
		{
			CrosshairScaling = FMax(CurrentCrosshairScaling - (0.6000000 * (WorldInfo.TimeSeconds - LastInCorrectAimTime)), 1.0000000);			
		}
		else
		{
			CrosshairScaling = FMin(CurrentCrosshairScaling + (0.6000000 * (WorldInfo.TimeSeconds - LastCorrectAimTime)), 2.0000000);
		}
	}
	//return;	
}

simulated function DrawWeaponCrosshair(HUD HUD)
{
	local Vector SocketLocation, DesiredAimPoint, RealAimPoint;
	local Rotator SocketRotation;
	local Actor TargetActor;
	local bool bAimIsCorrect;
	local float CenterSize;
	local UTPlayerController PC;

	PC = UTPlayerController(Instigator.Controller);
	// End:0x79
	if((PC != none) && PC.bSimpleCrosshair)
	{
		super.DrawWeaponCrosshair(HUD);
		return;
	}
	DesiredAimPoint = GetDesiredAimPoint(TargetActor);
	GetFireStartLocationAndRotation(SocketLocation, SocketRotation);
	RealAimPoint = SocketLocation + (Vector(SocketRotation) * (GetTraceRange()));
	bAimIsCorrect = CanHitDesiredTarget(SocketLocation, SocketRotation, DesiredAimPoint, TargetActor, RealAimPoint);
	GetCrosshairScaling(HUD);
	CurrentCrosshairScaling = CrosshairScaling;
	CrosshairColor.A = byte(255.0000000 - (127.0000000 * (CrosshairScaling - 1.0000000)));
	super.DrawWeaponCrosshair(HUD);
	// End:0x743
	if(bShouldAimAffectCrosshair)
	{
		// End:0x376
		if(bAimIsCorrect)
		{
			CenterSize = ((UTHUDBase(HUD).ConfiguredCrosshairScaling * 24.0000000) * HUD.Canvas.ClipX) / float(1280);
			HUD.Canvas.SetPos(0.5000000 * (HUD.Canvas.ClipX - CenterSize), 0.5000000 * (HUD.Canvas.ClipY - CenterSize));
			HUD.Canvas.DrawTile(Texture2D'UI_HUD.HUD.UTCrossHairs', CenterSize, CenterSize, 380.0000000, 320.0000000, 26.0000000, 26.0000000);
			LastCorrectAimTime = WorldInfo.TimeSeconds;			
		}
		else
		{
			LastInCorrectAimTime = WorldInfo.TimeSeconds;
			// End:0x743
			if(bDebugTurret)
			{
				RealAimPoint = HUD.Canvas.Project(RealAimPoint);
				// End:0x4EF
				if((RealAimPoint.X < float(12)) || RealAimPoint.X > (HUD.Canvas.ClipX - float(12)))
				{
					RealAimPoint.X = float(Clamp(int(RealAimPoint.X), 12, int(HUD.Canvas.ClipX - float(12))));
				}
				// End:0x5EC
				if((RealAimPoint.Y < float(12)) || RealAimPoint.Y > (HUD.Canvas.ClipY - float(12)))
				{
					RealAimPoint.Y = float(Clamp(int(RealAimPoint.Y), 12, int(HUD.Canvas.ClipY - float(12))));
				}
				HUD.Canvas.SetPos(RealAimPoint.X - 10.0000000, RealAimPoint.Y - 10.0000000);
				CenterSize = ((UTHUDBase(HUD).ConfiguredCrosshairScaling * 25.0000000) * HUD.Canvas.ClipX) / float(1280);
				HUD.Canvas.DrawTile(Texture2D'UI_HUD.HUD.UTCrossHairs', CenterSize, CenterSize, 380.0000000, 320.0000000, 26.0000000, 26.0000000);
			}
		}
	}
	//return;	
}

simulated event Vector GetDesiredAimPoint(optional out Actor TargetActor)
{
	local Vector CameraLocation, HitLocation, HitNormal, DesiredAimPoint;
	local Rotator CameraRotation;
	local Controller C;
	local PlayerController PC;

	C = ((MyVehicle != none) ? MyVehicle.Seats[SeatIndex].SeatPawn.Controller : none);
	PC = PlayerController(C);
	// End:0x165
	if(PC != none)
	{
		PC.GetPlayerViewPoint(CameraLocation, CameraRotation);
		DesiredAimPoint = CameraLocation + (Vector(CameraRotation) * (GetTraceRange()));
		TargetActor = GetTraceOwner().Trace(HitLocation, HitNormal, DesiredAimPoint, CameraLocation);
		// End:0x162
		if(TargetActor != none)
		{
			DesiredAimPoint = HitLocation;
		}		
	}
	else
	{
		// End:0x1C5
		if(C != none)
		{
			DesiredAimPoint = C.GetFocalPoint();
			TargetActor = C.Focus;
		}
	}
	return DesiredAimPoint;
	//return ReturnValue;	
}

simulated function GetFireStartLocationAndRotation(out Vector StartLocation, out Rotator StartRotation)
{
	// End:0x11
	if(MyVehicle == none)
	{
		return;
	}
	// End:0x90
	if(MyVehicle.Seats[SeatIndex].GunSocket.Length > 0)
	{
		MyVehicle.GetBarrelLocationAndRotation(SeatIndex, StartLocation, StartRotation);		
	}
	else
	{
		StartLocation = MyVehicle.Location;
		StartRotation = MyVehicle.Rotation;
	}
	//return;	
}

simulated event bool IsAimCorrect()
{
	local Vector SocketLocation, DesiredAimPoint, RealAimPoint, DesiredNorm, RealNorm;

	local Rotator SocketRotation;
	local float DesiredDotReal;

	DesiredAimPoint = GetDesiredAimPoint();
	GetFireStartLocationAndRotation(SocketLocation, SocketRotation);
	RealAimPoint = SocketLocation + (Vector(SocketRotation) * (GetTraceRange()));
	DesiredNorm = Normal(DesiredAimPoint - SocketLocation);
	RealNorm = Normal(RealAimPoint - SocketLocation);
	DesiredDotReal = DesiredNorm Dot RealNorm;
	return DesiredDotReal >= (GetMaxFinalAimAdjustment());
	//return ReturnValue;	
}

static simulated function name GetFireTriggerTag(int BarrelIndex, int FireMode)
{
	// End:0x3E
	if(FireMode == 0)
	{
		// End:0x3B
		if(default.FireTriggerTags.Length > BarrelIndex)
		{
			return default.FireTriggerTags[BarrelIndex];
		}		
	}
	else
	{
		// End:0x6A
		if(default.AltFireTriggerTags.Length > BarrelIndex)
		{
			return default.AltFireTriggerTags[BarrelIndex];
		}
	}
	return 'None';
	//return ReturnValue;	
}

simulated function float GetFireInterval(byte FireModeNum)
{
	local UTPawn UTP;

	// End:0x97
	if(Vehicle(Owner) != none)
	{
		UTP = UTPawn(Vehicle(Owner).Driver);
		// End:0x97
		if(UTP != none)
		{
			return FireInterval[int(FireModeNum)] * UTP.FireRateMultiplier;
		}
	}
	return super.GetFireInterval(FireModeNum);
	//return ReturnValue;	
}

static simulated function MaterialImpactEffect GetImpactEffect(Actor HitActor, PhysicalMaterial HitMaterial, byte FireModeNum)
{
	local int I;
	local UTPhysicalMaterialProperty PhysicalProperty;

	// End:0x4A
	if(HitMaterial != none)
	{
		PhysicalProperty = UTPhysicalMaterialProperty(HitMaterial.GetPhysicalMaterialProperty(Class'UTGame.UTPhysicalMaterialProperty'));
	}
	// End:0x10D
	if(int(FireModeNum) > int(0))
	{
		// End:0x100
		if((PhysicalProperty != none) && PhysicalProperty.MaterialType != 'None')
		{
			I = default.AltImpactEffects.Find('MaterialType', PhysicalProperty.MaterialType);
			// End:0x100
			if(I != -1)
			{
				return default.AltImpactEffects[I];
			}
		}
		return default.DefaultAltImpactEffect;		
	}
	else
	{
		// End:0x1AF
		if((PhysicalProperty != none) && PhysicalProperty.MaterialType != 'None')
		{
			I = default.ImpactEffects.Find('MaterialType', PhysicalProperty.MaterialType);
			// End:0x1AF
			if(I != -1)
			{
				return default.ImpactEffects[I];
			}
		}
		return default.DefaultImpactEffect;
	}
	//return ReturnValue;	
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
	//return;	
}

simulated function DetachWeapon()
{
	//return;	
}

simulated function Activate()
{
	// End:0x1D
	if(!IsFiring())
	{
		GotoState('Active');
	}
	//return;	
}

simulated function PutDownWeapon()
{
	GotoState('Inactive');
	//return;	
}

simulated function Vector GetPhysicalFireStartLoc(optional Vector AimDir)
{
	// End:0x34
	if(MyVehicle != none)
	{
		return MyVehicle.GetPhysicalFireStartLoc(self);		
	}
	else
	{
		return Location;
	}
	//return ReturnValue;	
}

simulated function BeginFire(byte FireModeNum)
{
	local UTVehicle V;

	V = UTVehicle(Instigator);
	// End:0x93
	if((V == none) || !V.bIsDisabled && !V.OverrideBeginFire(FireModeNum))
	{
		super(Weapon).BeginFire(FireModeNum);
	}
	//return;	
}

simulated function EndFire(byte FireModeNum)
{
	local UTVehicle V;

	V = UTVehicle(Instigator);
	// End:0x6D
	if((V == none) || !V.OverrideEndFire(FireModeNum))
	{
		super.EndFire(FireModeNum);
	}
	//return;	
}

simulated function Rotator GetAdjustedAim(Vector StartFireLoc)
{
	return Instigator.GetAdjustedAimFor(self, StartFireLoc);
	//return ReturnValue;	
}

simulated function Projectile ProjectileFire()
{
	local Projectile SpawnedProjectile;

	IncrementFlashCount();
	// End:0xBC
	if(int(Role) == int(ROLE_Authority))
	{
		SpawnedProjectile = Spawn(GetProjectileClass(),,, MyVehicle.GetPhysicalFireStartLoc(self));
		// End:0xBC
		if(SpawnedProjectile != none)
		{
			SpawnedProjectile.Init(Vector(AddSpread(MyVehicle.GetWeaponAim(self))));
		}
	}
	return SpawnedProjectile;
	//return ReturnValue;	
}

simulated function Vector InstantFireStartTrace()
{
	return ((MyVehicle != none) ? MyVehicle.GetPhysicalFireStartLoc(self) : vect(0.0000000, 0.0000000, 0.0000000));
	//return ReturnValue;	
}

simulated function Vector InstantFireEndTrace(Vector StartTrace)
{
	// End:0x19
	if(MyVehicle == none)
	{
		return StartTrace;
	}
	return StartTrace + (Vector(AddSpread(MyVehicle.GetWeaponAim(self))) * (GetTraceRange()));
	//return ReturnValue;	
}

simulated function Actor GetTraceOwner()
{
	return ((MyVehicle != none) ? MyVehicle : super(Weapon).GetTraceOwner());
	//return ReturnValue;	
}

simulated function float GetMaxFinalAimAdjustment()
{
	return MaxFinalAimAdjustment;
	//return ReturnValue;	
}

simulated function NotifyVehicleDeployed()
{
	//return;	
}

simulated function NotifyVehicleUndeployed()
{
	//return;	
}

simulated function WeaponPlaySound(SoundCue Sound, optional float NoiseLoudness)
{
	local int Barrel;
	local name Pivot;
	local Vector Loc;
	local Rotator Rot;

	// End:0x171
	if((bPlaySoundFromSocket && MyVehicle != none) && MyVehicle.Mesh != none)
	{
		// End:0x67
		if((Sound == none) || Instigator == none)
		{
			return;
		}
		Barrel = MyVehicle.GetBarrelIndex(SeatIndex);
		Pivot = MyVehicle.Seats[SeatIndex].GunSocket[Barrel];
		MyVehicle.Mesh.GetSocketWorldLocationAndRotation(Pivot, Loc, Rot);
		Instigator.PlaySound(Sound, false, true, false, Loc);		
	}
	else
	{
		super.WeaponPlaySound(Sound, NoiseLoudness);
	}
	//return;	
}

simulated function UTWeapon.EZoomState GetZoomedState()
{
	// End:0x62
	if(((int(Role) == int(ROLE_Authority)) && Instigator != none) && !Instigator.IsLocallyControlled())
	{
		return ((bCurrentlyZoomed) ? 3 : 0);		
	}
	else
	{
		return super.GetZoomedState();
	}
	//return ReturnValue;	
}

reliable server function ServerSetZoom(bool bNowZoomed)
{
	bCurrentlyZoomed = bNowZoomed;
	//return;	
}

simulated function StartZoom(UTPlayerController PC)
{
	super.StartZoom(PC);
	ServerSetZoom(true);
	//return;	
}

simulated function EndZoom(UTPlayerController PC)
{
	super.EndZoom(PC);
	ServerSetZoom(false);
	//return;	
}

defaultproperties
{
	DefaultImpactEffect=(MaterialType="None",Sound=none,DecalMaterials=none,DurationOfDecal=24.0000000,DecalDissolveParamName="DissolveAmount",DecalWidth=0.0000000,DecalHeight=0.0000000,ParticleTemplate=none)
	DefaultAltImpactEffect=(MaterialType="None",Sound=none,DecalMaterials=none,DurationOfDecal=24.0000000,DecalDissolveParamName="DissolveAmount",DecalWidth=0.0000000,DecalHeight=0.0000000,ParticleTemplate=none)
	bShouldAimAffectCrosshair=true
	MaxFinalAimAdjustment=0.9950000
	bExportMenuData=false
	ShotCost[0]=0
	ShotCost[1]=0
	// Reference: ForceFeedbackWaveform'UTGame.Default__UTVehicleWeapon.ForceFeedbackWaveformShooting1'
	// Archetype: ForceFeedbackWaveform'UTGame.Default__UTWeapon.ForceFeedbackWaveformShooting1'
	begin object name="ForceFeedbackWaveformShooting1"
	end object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	CrossHairCoordinates=(U=320.0000000,V=320.0000000,UL=60.0000000,VL=56.0000000)
	InventoryGroup=100
	GroupWeight=0.5000000
	aimerror=600.0000000
	// Reference: UDKSkeletalMeshComponent'UTGame.Default__UTVehicleWeapon.FirstPersonMesh'
	// Archetype: UDKSkeletalMeshComponent'UTGame.Default__UTWeapon.FirstPersonMesh'
	begin object name="FirstPersonMesh"
		ReplacementPrimitive=none
	end object
	Mesh=FirstPersonMesh
	// Reference: SkeletalMeshComponent'UTGame.Default__UTVehicleWeapon.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	// Archetype: SkeletalMeshComponent'UTGame.Default__UTWeapon.PickupMesh'
	begin object name="PickupMesh"
		ReplacementPrimitive=none
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
	TickGroup=ETickingGroup.TG_PostAsyncWork
}