class HaloVehicleWeapon extends UTVehicleWeapon
	config(Weapon);

var GFxHaloMinimapHUD.PlayerPawnType PawnTypeOverride;
var array<Projectile> WeaponProjectileArchetypes;
var Actor AimTargetedActor;
var AkEvent FireSoundEvent;
var name akWeaponType;
var bool bIsPlayingLoopFiringSound;
var ForceFeedbackWaveform FireWaveform;
var float FireFeedbackDelay;
var CameraShake FireCameraShake;
var float HorizontalRecoilRate;
var float VerticalRecoilRate;
var float DefaultRecoilSpread;

function Tick(float DeltaTime)
{
	local Pawn P;

	super(Actor).Tick(DeltaTime);
	AimTargetedActor = none;
	GetDesiredAimPoint(AimTargetedActor);
	P = Pawn(AimTargetedActor);
	bCrosshairIsOverValidTarget = (P != none) && P.Health > 0;
	//return;	
}

simulated event Vector GetDesiredAimPoint(optional out Actor TargetActor)
{
	local Vector CameraLocation, HitLocation, HitNormal, DesiredAimPoint;
	local Rotator CameraRotation;
	local Controller C;
	local PlayerController PC;

	C = ((Instigator != none) ? Instigator.Controller : none);
	PC = PlayerController(C);
	// End:0x133
	if(PC != none)
	{
		PC.GetPlayerViewPoint(CameraLocation, CameraRotation);
		DesiredAimPoint = CameraLocation + (Vector(CameraRotation) * (GetTraceRange()));
		TargetActor = GetTraceOwner().Trace(HitLocation, HitNormal, DesiredAimPoint, CameraLocation);
		// End:0x130
		if(TargetActor != none)
		{
			DesiredAimPoint = HitLocation;
		}		
	}
	else
	{
		// End:0x193
		if(C != none)
		{
			DesiredAimPoint = C.GetFocalPoint();
			TargetActor = C.Focus;
		}
	}
	return DesiredAimPoint;
	//return ReturnValue;	
}

simulated function HandleFinishedFiring()
{
	// End:0x32
	if(bIsPlayingLoopFiringSound)
	{
		PlayAkEvent(AkEvent'Weapons.Stop_Weapon_Fire_Loop');
		bIsPlayingLoopFiringSound = false;
	}
	super(Weapon).HandleFinishedFiring();
	//return;	
}

simulated function FireAmmunition()
{
	PlayHaloFireEffects();
	super(UTWeapon).FireAmmunition();
	//return;	
}

simulated function PlayHaloFireEffects(optional float magnitude = 1.0000000)
{
	PlayFireSound();
	PlayFireCameraShake(magnitude);
	InitiateFireFeedback();
	//return;	
}

simulated function PlayFireSound()
{
	// End:0x10F
	if(FireSoundEvent != none)
	{
		// End:0x10F
		if((FireSoundEvent != AkEvent'Weapons.Play_Weapon_Fire_Loop') || !bIsPlayingLoopFiringSound)
		{
			SetSwitch('Local_Player', (((Instigator.Controller != none) && Instigator.Controller.IsLocalPlayerController()) ? 'Yes' : 'No'));
			SetSwitch('Weapon_Type', akWeaponType);
			PlayAkEvent(FireSoundEvent);
			bIsPlayingLoopFiringSound = FireSoundEvent == AkEvent'Weapons.Play_Weapon_Fire_Loop';
		}
	}
	//return;	
}

simulated function InitiateFireFeedback()
{
	((FireFeedbackDelay == 0.0000000) ? PlayFireForceFeedback() : SetTimer(FireFeedbackDelay, false, 'PlayFireForceFeedback'));
	//return;	
}

simulated function PlayFireForceFeedback()
{
	local PlayerController PC;

	PC = PlayerController(Instigator.Controller);
	// End:0xA9
	if(((PC != none) && LocalPlayer(PC.Player) != none) && FireWaveform != none)
	{
		PC.ClientPlayForceFeedbackWaveform(FireWaveform);
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

function Projectile GetProjectileArchetype()
{
	return ((int(CurrentFireMode) < WeaponProjectileArchetypes.Length) ? WeaponProjectileArchetypes[int(CurrentFireMode)] : none);
	//return ReturnValue;	
}

simulated function Projectile ProjectileFire()
{
	local Projectile SpawnedProjectile, aArchetype;

	IncrementFlashCount();
	// End:0x142
	if(int(Role) == int(ROLE_Authority))
	{
		aArchetype = GetProjectileArchetype();
		// End:0xA4
		if(aArchetype != none)
		{
			SpawnedProjectile = Spawn(aArchetype.Class, self,, MyVehicle.GetPhysicalFireStartLoc(self),, aArchetype);			
		}
		else
		{
			SpawnedProjectile = Spawn(GetProjectileClass(), self,, MyVehicle.GetPhysicalFireStartLoc(self));
		}
		// End:0x142
		if(SpawnedProjectile != none)
		{
			SpawnedProjectile.Init(Vector(AddSpread(MyVehicle.GetWeaponAim(self))));
		}
	}
	return SpawnedProjectile;
	//return ReturnValue;	
}

defaultproperties
{
	PawnTypeOverride=PPT_Turret
	MaxFinalAimAdjustment=0.8500000
	bCrosshairShouldHighlightOnValidTarget=true
	WeaponFireWaveForm=none
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloVehicleWeapon.FirstPersonMesh'
	// Archetype: UDKSkeletalMeshComponent'UTGame.Default__UTVehicleWeapon.FirstPersonMesh'
	begin object name="FirstPersonMesh"
		ReplacementPrimitive=none
	end object
	Mesh=FirstPersonMesh
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloVehicleWeapon.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	// Archetype: SkeletalMeshComponent'UTGame.Default__UTVehicleWeapon.PickupMesh'
	begin object name="PickupMesh"
		ReplacementPrimitive=none
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
}