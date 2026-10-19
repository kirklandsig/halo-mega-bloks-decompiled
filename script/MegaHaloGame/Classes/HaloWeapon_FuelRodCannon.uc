class HaloWeapon_FuelRodCannon extends HaloWeapon
	config(Weapon);

var ParticleSystem MuzzleFxTemplate;
var export editinline ParticleSystemComponent MuzzleFx;
var ParticleSystem ChargeUpFxTemplate;
var export editinline ParticleSystemComponent ChargeUpFx;
var ParticleSystem TracerFxTemplate;
var name TracerFxEndName;
var ParticleSystem TracerHitFxTemplate;

simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
	return HasAnyAmmo();
	//return ReturnValue;	
}

simulated function Vector InstantFireStartTrace()
{
	local Vector StartTrace;

	// End:0xE5
	if(Owner != none)
	{
		StartTrace.X = Owner.Location.X;
		StartTrace.Y = Owner.Location.Y;
		StartTrace.Z = GetMuzzleFlashLocation().Z;
	}
	return StartTrace;
	//return ReturnValue;	
}

function Vector GetMuzzleFlashLocation()
{
	local Vector MuzzleFlashLoc;
	local UTPawn UTOwner;

	// End:0xE9
	if(Owner != none)
	{
		UTOwner = UTPawn(Owner);
		// End:0xCA
		if((UTOwner != none) && UTOwner.Mesh != none)
		{
			// End:0xCA
			if(UTOwner.Mesh.GetSocketWorldLocationAndRotation(UTOwner.WeaponSocket, MuzzleFlashLoc))
			{
				return MuzzleFlashLoc;
			}
		}
		return Owner.Location;
	}
	return vect(0.0000000, 0.0000000, 0.0000000);
	//return ReturnValue;	
}

function SpawnMuzzleFx()
{
	local UTPawn UTOwner;

	UTOwner = UTPawn(Owner);
	// End:0xDC
	if(UTOwner != none)
	{
		// End:0xBC
		if(true)
		{
			// End:0xB9
			if(true)
			{
				MuzzleFx = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(MuzzleFxTemplate, UTOwner.Mesh, UTOwner.WeaponSocket, true);
			}			
		}
		else
		{
			MuzzleFx.ActivateSystem();
		}
	}
	//return;	
}

function StartChargeUpFX()
{
	local UTPawn UTOwner;

	UTOwner = UTPawn(Owner);
	// End:0xD1
	if(UTOwner != none)
	{
		// End:0xD1
		if((ChargeUpFx == none) && ChargeUpFxTemplate != none)
		{
			ChargeUpFx = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(ChargeUpFxTemplate, UTOwner.Mesh, UTOwner.WeaponSocket, true);
		}
	}
	//return;	
}

function StopChargeUpFX()
{
	// End:0x39
	if(ChargeUpFx != none)
	{
		ChargeUpFx.DeactivateSystem();
		ChargeUpFx = none;
	}
	//return;	
}

function StartChargeUpSound()
{
	//return;	
}

function StopChargeUpSound()
{
	//return;	
}

simulated function SpawnTracer(Vector HitLocation)
{
	local Vector MuzzleLoc;
	local editinline ParticleSystemComponent Emitter;
	local Vector fxFwd;
	local Rotator fxRot;

	MuzzleLoc = GetMuzzleFlashLocation();
	// End:0xA9
	if(TracerFxTemplate != none)
	{
		Emitter = WorldInfo.MyEmitterPool.SpawnEmitter(TracerFxTemplate, MuzzleLoc);
		Emitter.SetVectorParameter(TracerFxEndName, HitLocation);
	}
	// End:0x180
	if(TracerHitFxTemplate != none)
	{
		fxFwd = HitLocation - MuzzleLoc;
		// End:0x105
		if(VSizeSq(fxFwd) > 0.0000001)
		{
			fxRot = Rotator(Normal(fxFwd));			
		}
		else
		{
			fxRot = Instigator.Rotation;
		}
		WorldInfo.MyEmitterPool.SpawnEmitter(TracerHitFxTemplate, HitLocation, fxRot);
	}
	//return;	
}

function DropFrom(Vector StartLocation, Vector StartVelocity)
{
	Destroy();
	//return;	
}

simulated state WeaponFiring
{
	ignores BeginState;

	simulated function Tick(float DeltaTime)
	{
		super(Actor).Tick(DeltaTime);
		// End:0x6D
		if(!PendingFire(int(CurrentFireMode)))
		{
			FireAmmunition();
			SpawnMuzzleFx();
			// End:0x6D
			if(IsFiring())
			{
				ClearPendingFire(int(CurrentFireMode));
				HandleFinishedFiring();
			}
		}
		//return;		
	}
	stop;	
}

simulated state WeaponFiringInstant extends WeaponFiring
{
	simulated event BeginState(name PrevStateName)
	{
		StartChargeUpFX();
		StartChargeUpSound();
		super.BeginState(PrevStateName);
		//return;		
	}

	simulated event EndState(name NextStateName)
	{
		StopChargeUpFX();
		StopChargeUpSound();
		super.EndState(NextStateName);
		//return;		
	}

	simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
	{
		SpawnTracer(Impact.HitLocation);
		super(HaloWeapon).ProcessInstantHit(FiringMode, Impact, NumHits);
		//return;		
	}
	stop;	
}

defaultproperties
{
	MuzzleFxTemplate=ParticleSystem'WP_COV_HUNTER.Effects.WP_COV_HUNTER_MUZZ'
	ChargeUpFxTemplate=ParticleSystem'WP_COV_HUNTER.Effects.WP_COV_HUNTER_CHARGEUP'
	TracerFxTemplate=ParticleSystem'WP_COV_HUNTER.Effects.WP_COV_HNT_CHRG_BEAM'
	TracerFxEndName="ShockBeamEnd"
	TracerHitFxTemplate=ParticleSystem'WP_COV_HUNTER.Effects.WP_COV_HUNTER_HIT'
	ReloadPawnAnimName="Reload_FuelRodCannon"
	ExtraAmmoCount=25
	MaxExtraAmmoCount=25
	FireSoundEvent[0]=AkEvent'Weapons.Play_Weapon_Fire'
	FireSoundEvent[1]=AkEvent'Weapons.Play_Weapon_Fire'
	MeleeSoundEvent=AkEvent'Melee.Play_Melee_Swing'
	ReloadSoundEvent=AkEvent'Weapons.Play_Weapon_Reload'
	SwitchToSoundEvent=AkEvent'Weapons.Play_Weapon_Equip'
	RicochetArraySize=10
	akWeaponType="COV_FuelRod"
	SpreadMin=0.0208000
	SpreadMax=0.1744000
	SpreadIncWithEachShot=0.0200000
	MeleeAnimName="Melee_Pistol"
	MeleeRange=250.0000000
	ThrowGrenadePawnAnimName="ThrowGrenade_FuelRodCannon"
	ReadyPawnAnimName="Fire_Anticipation"
	FirePawnAnimName="Fire"
	FireChargedPawnAnimName="Fire_FuelRodCannon_Alt"
	RelaxPawnAnimName="Relax_FuelRodCannon"
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_FuelRodCannon.FireWaveform1'
	begin object name="FireWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=60,RightAmplitude=60,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.2000000)
	end object
	FireWaveform=FireWaveform1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_FuelRodCannon.ReloadWaveform1'
	begin object name="ReloadWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.2500000)
	end object
	RemoveClipWaveform=ReloadWaveform1
	InsertClipWaveform=ReloadWaveform1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_FuelRodCannon.MeleeWaveform1'
	begin object name="MeleeWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=60,RightAmplitude=60,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.2000000)
	end object
	MeleeWaveform=MeleeWaveform1
	RemoveClipFeedbackDelay=0.5000000
	InsertClipFeedbackDelay=1.0000000
	MeleeFeedbackDelay=0.1000000
	// Reference: CameraShake'MegaHaloGame.Default__HaloWeapon_FuelRodCannon.FireCameraShake1'
	begin object name="FireCameraShake1" class=Engine.CameraShake
		OscillationDuration=0.1000000
		RotOscillation=(Pitch=(Amplitude=10.0000000,Frequency=1.0000000,InitialOffset=EOO_OffsetZero),Yaw=(Amplitude=10.0000000,Frequency=1.0000000,InitialOffset=EOO_OffsetZero))
	end object
	FireCameraShake=FireCameraShake1
	// Reference: CameraShake'MegaHaloGame.Default__HaloWeapon_FuelRodCannon.MeleeCameraShake1'
	begin object name="MeleeCameraShake1" class=Engine.CameraShake
		OscillationDuration=0.4000000
		RotOscillation=(Pitch=(Amplitude=100.0000000,Frequency=1.0000000),Yaw=(Amplitude=1000.0000000,Frequency=2.0000000))
	end object
	MeleeCameraShake=MeleeCameraShake1
	bShouldDrawCrosshairDropShadow=false
	LockerAmmoCount=30
	MaxAmmoCount=5
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_FuelRodCannon.ForceFeedbackWaveformShooting1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon.ForceFeedbackWaveformShooting1'
	begin object name="ForceFeedbackWaveformShooting1"
	end object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	CrossHairCoordinates=(U=256.0000000,V=0.0000000)
	CrosshairImage=Texture2D'mainhud.Crosshairs'
	WeaponName="Weapon_FuelRodCannon"
	HUDFrameName="assaultRifle"
	InventoryGroup=1
	MuzzleFlashDuration=0.1500000
	AmmoCount=5
	FiringStatesArray[0]="WeaponFiring"
	FiringStatesArray[1]="WeaponFiringInstant"
	WeaponFireTypes[0]=0
	WeaponFireTypes[1]=0
	WeaponProjectiles[0]=Class'MegaHaloGame.HaloProjectile_FuelRodCannonBall'
	WeaponProjectiles[1]=none
	FireInterval[0]=0.1500000
	FireInterval[1]=0.1500000
	Spread[0]=0.0208000
	Spread[1]=0.0208000
	InstantHitDamage[0]=0.0000000
	InstantHitDamage[1]=50.0000000
	InstantHitMomentum[0]=0.0000000
	InstantHitMomentum[1]=300.0000000
	InstantHitDamageTypes[0]=Class'MegaHaloGame.HaloDamageType'
	InstantHitDamageTypes[1]=Class'MegaHaloGame.HaloDamageType_FuelRodCannonBeam'
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_FuelRodCannon.FirstPersonMesh'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon.FirstPersonMesh'
	begin object name="FirstPersonMesh"
		ReplacementPrimitive=none
	end object
	Mesh=FirstPersonMesh
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_FuelRodCannon.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon.PickupMesh'
	begin object name="PickupMesh"
		ReplacementPrimitive=none
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
}