class HaloWeapon_Shotgun extends HaloWeapon
	config(Weapon);

var int ShotWidth;
var int ShotHeight;
var int PelletsPerInnerRing;
var int PelletsPerOuterRing;
var float PelletYawSpread;
var float PelletPitchSpread;
var name ReloadLoopPawnAnimName;
var float ReloadLoopTime;
var name ReloadOutPawnAnimName;
var float ReloadOutTime;

function SpawnRingOfProjectiles(int Count, Class<Projectile> ProjectileClass, Vector ProjectileStart, Rotator BaseProjectileRot, int HorizontalAngle, int VerticalAngle)
{
	local int I;
	local float theta, thetaStart;
	local Rotator offsetRot;
	local Vector ProjectileDir;

	thetaStart = (FRand() * 2.0000000) * 3.1415927;
	I = 0;
	J0x25:

	// End:0x17B [Loop If]
	if(I < Count)
	{
		theta = thetaStart + (((2.0000000 * 3.1415927) * float(I)) / float(Count));
		offsetRot.Yaw = int(float(HorizontalAngle) * Cos(theta));
		offsetRot.Pitch = int(float(VerticalAngle) * Sin(theta));
		ProjectileDir = Vector(offsetRot);
		ProjectileDir = VRandCone2(ProjectileDir, PelletYawSpread, PelletPitchSpread);
		ProjectileDir = ProjectileDir >> BaseProjectileRot;
		SpawnProjectile(ProjectileClass, ProjectileStart, ProjectileDir);
		++I;
		// [Loop Continue]
		goto J0x25;
	}
	//return;	
}

function Projectile SpawnProjectile(Class<Projectile> ProjectileClass, Vector ProjectileStart, Vector ProjectileDir)
{
	local Rotator BaseProjectileRot;

	BaseProjectileRot = Rotator(ProjectileDir);
	SpawnRingOfProjectiles(PelletsPerInnerRing, ProjectileClass, ProjectileStart, BaseProjectileRot, ShotWidth / 3, ShotHeight / 3);
	SpawnRingOfProjectiles(PelletsPerOuterRing, ProjectileClass, ProjectileStart, BaseProjectileRot, ShotWidth, ShotHeight);
	return none;
	//return ReturnValue;	
}

function OnAnimDone()
{
	//return;	
}

function BeginFireDuringReload(byte FireModeNum)
{
	// End:0x11
	if(AmmoCount <= 0)
	{
		return;
	}
	// End:0x52
	if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		// End:0x52
		if(CheckZoom(FireModeNum))
		{
			return;
		}
	}
	// End:0xC9
	if(!bDeleteMe && Instigator != none)
	{
		global.BeginFire(FireModeNum);
		// End:0xC9
		if(PendingFire(int(FireModeNum)) && HasAmmo(FireModeNum))
		{
			SendToFiringState(FireModeNum);
		}
	}
	//return;	
}

simulated state WeaponFiring
{
	simulated function RefireCheckTimer()
	{
		ForceEndFire();
		HandleFinishedFiring();
		//return;		
	}
	stop;	
}

simulated state ReloadingAmmo
{
	simulated function BeginState(name PreviousStateName)
	{
		local float AnimTime;

		AnimTime = PlayTopHalfAnim(ReloadPawnAnimName, ReloadTime,, ReloadBlendInTime, 0.0000000);
		PlayAkEvent(AkEvent'Weapons.Play_WEP_UNSC_Shotgun_Reload_Start');
		// End:0x7C
		if(AnimTime > 0.0000000)
		{
			SetTimer(AnimTime, false, 'OnAnimDone');			
		}
		else
		{
			OnAnimDone();
		}
		//return;		
	}

	simulated function EndState(name NextStateName)
	{
		local HaloPawn P;

		// End:0x61
		if(NextStateName != 'ReloadingAmmo_Loop')
		{
			P = HaloPawn(Instigator);
			// End:0x61
			if(P != none)
			{
				P.OnWeaponReloadDone();
			}
		}
		//return;		
	}

	simulated function OnAnimDone()
	{
		GotoState('ReloadingAmmo_Loop');
		//return;		
	}

	simulated function BeginFire(byte FireModeNum)
	{
		BeginFireDuringReload(FireModeNum);
		//return;		
	}
	stop;	
}

simulated state ReloadingAmmo_Loop extends ReloadingAmmo
{
	simulated function BeginState(name PreviousStateName)
	{
		local float AnimTime;

		AnimTime = PlayTopHalfAnim(ReloadLoopPawnAnimName, ReloadLoopTime,, 0.0000000, 0.0000000, false);
		PlayReloadSound();
		// End:0x69
		if(AnimTime > 0.0000000)
		{
			SetTimer(AnimTime, false, 'OnAnimDone');			
		}
		else
		{
			OnAnimDone();
		}
		//return;		
	}

	simulated function EndState(name NextStateName)
	{
		local HaloPawn P;

		// End:0x61
		if(NextStateName != 'ReloadingAmmo_OutAnim')
		{
			P = HaloPawn(Instigator);
			// End:0x61
			if(P != none)
			{
				P.OnWeaponReloadDone();
			}
		}
		//return;		
	}

	simulated function ReloadNow()
	{
		AmmoCount += 1;
		// End:0x27
		if(!bInfiniteExtraAmmo)
		{
			ExtraAmmoCount -= 1;
		}
		//return;		
	}

	simulated function OnAnimDone()
	{
		// End:0x22
		if(CanReloadAmmo())
		{
			BeginState('ReloadingAmmo_Loop');
			return;
		}
		GotoState('ReloadingAmmo_OutAnim');
		//return;		
	}

	simulated function BeginFire(byte FireModeNum)
	{
		BeginFireDuringReload(FireModeNum);
		//return;		
	}
	stop;	
}

simulated state ReloadingAmmo_OutAnim extends ReloadingAmmo
{
	simulated function BeginState(name PreviousStateName)
	{
		local float AnimTime;

		AnimTime = PlayTopHalfAnim(ReloadOutPawnAnimName, ReloadOutTime,, 0.0000000, ReloadBlendOutTime);
		PlayAkEvent(AkEvent'Weapons.Play_WEP_UNSC_Shotgun_Reload_End');
		// End:0x7C
		if(AnimTime > 0.0000000)
		{
			SetTimer(AnimTime, false, 'OnAnimDone');			
		}
		else
		{
			OnAnimDone();
		}
		//return;		
	}

	simulated function EndState(name NextStateName)
	{
		local HaloPawn P;

		P = HaloPawn(Instigator);
		// End:0x4A
		if(P != none)
		{
			P.OnWeaponReloadDone();
		}
		//return;		
	}

	simulated function OnAnimDone()
	{
		GotoState('Active');
		//return;		
	}

	simulated function BeginFire(byte FireModeNum)
	{
		BeginFireDuringReload(FireModeNum);
		//return;		
	}
	stop;	
}

defaultproperties
{
	ShotWidth=2876
	ShotHeight=547
	PelletsPerInnerRing=5
	PelletsPerOuterRing=10
	PelletYawSpread=0.0344677
	PelletPitchSpread=0.0131111
	ReloadLoopPawnAnimName="Reload_Loop_SG"
	ReloadLoopTime=0.5500000
	ReloadOutPawnAnimName="Reload_Out_SG"
	ReloadOutTime=0.7500000
	HUDIcon="shotgun"
	SwapToMessage="Press [MainHUD.InlineInputIcons.inputIcon_y] To Switch To Shotgun"
	ReloadPawnAnimName="Reload_In_SG"
	ReloadTime=0.5000000
	ExtraAmmoCount=24
	MaxExtraAmmoCount=24
	AutoReloadDelay=0.5000000
	FireSoundEvent[0]=AkEvent'Weapons.Play_Weapon_Fire'
	MeleeSoundEvent=AkEvent'Melee.Play_Melee_Swing'
	ReloadSoundEvent=AkEvent'Weapons.Play_WEP_UNSC_Shotgun_Reload_Shell'
	SwitchToSoundEvent=AkEvent'Weapons.Play_Weapon_Equip'
	RicochetArraySize=10
	akWeaponType="UNSC_Shotgun"
	SpreadMin=0.0300000
	SpreadMax=0.0500000
	SpreadIncWithEachShot=0.0000000
	DroppedPickupMeshTemplate=StaticMesh'Shotgun.Shotgun_static'
	MeleeRange=250.0000000
	ReadyPawnAnimName="Ready_Rifle"
	FirePawnAnimName="Fire_SG"
	FireChargedPawnAnimName="Fire_Rifle"
	RelaxPawnAnimName="Relax_Rifle"
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_Shotgun.FireWaveform1'
	begin object name="FireWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=60,RightAmplitude=60,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.2000000)
	end object
	FireWaveform=FireWaveform1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_Shotgun.ReloadWaveform1'
	begin object name="ReloadWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.2500000)
	end object
	RemoveClipWaveform=ReloadWaveform1
	InsertClipWaveform=ReloadWaveform1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_Shotgun.MeleeWaveform1'
	begin object name="MeleeWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=60,RightAmplitude=60,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.2000000)
	end object
	MeleeWaveform=MeleeWaveform1
	RemoveClipFeedbackDelay=0.5000000
	InsertClipFeedbackDelay=1.0000000
	MeleeFeedbackDelay=0.1000000
	// Reference: CameraShake'MegaHaloGame.Default__HaloWeapon_Shotgun.FireCameraShake1'
	begin object name="FireCameraShake1" class=Engine.CameraShake
		OscillationDuration=0.1000000
		RotOscillation=(Pitch=(Amplitude=10.0000000,Frequency=1.0000000,InitialOffset=EOO_OffsetZero),Yaw=(Amplitude=10.0000000,Frequency=1.0000000,InitialOffset=EOO_OffsetZero))
	end object
	FireCameraShake=FireCameraShake1
	// Reference: CameraShake'MegaHaloGame.Default__HaloWeapon_Shotgun.MeleeCameraShake1'
	begin object name="MeleeCameraShake1" class=Engine.CameraShake
		OscillationDuration=0.4000000
		RotOscillation=(Pitch=(Amplitude=100.0000000,Frequency=1.0000000),Yaw=(Amplitude=1000.0000000,Frequency=2.0000000))
	end object
	MeleeCameraShake=MeleeCameraShake1
	bShouldDrawCrosshairDropShadow=false
	LockerAmmoCount=30
	MaxAmmoCount=6
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_Shotgun.ForceFeedbackWaveformShooting1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon.ForceFeedbackWaveformShooting1'
	begin object name="ForceFeedbackWaveformShooting1"
	end object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	CrossHairCoordinates=(U=256.0000000,V=0.0000000)
	CrosshairImage=Texture2D'mainhud.Crosshairs'
	WeaponName="Weapon_Shotgun"
	HUDFrameName="shotgun"
	InventoryGroup=1
	AttachmentClass=Class'MegaHaloGame.HaloWeaponAttachment_Shotgun'
	MuzzleFlashDuration=0.1500000
	AmmoCount=6
	FiringStatesArray[0]="DelayedWeaponFiring"
	FiringStatesArray[1]="WeaponFiring"
	WeaponFireTypes[0]=0
	WeaponFireTypes[1]=0
	WeaponProjectiles[0]=Class'MegaHaloGame.HaloProjectile_ShotgunPellet'
	WeaponProjectiles[1]=none
	FireInterval[0]=0.7500000
	FireInterval[1]=1.0000000
	Spread[0]=0.0300000
	Spread[1]=0.0000000
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_Shotgun.FirstPersonMesh'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon.FirstPersonMesh'
	begin object name="FirstPersonMesh"
		ReplacementPrimitive=none
	end object
	Mesh=FirstPersonMesh
	PickupMessage="Hold [MainHUD.InlineInputIcons.inputIcon_y] To Pick Up Shotgun"
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_Shotgun.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon.PickupMesh'
	begin object name="PickupMesh"
		SkeletalMesh=SkeletalMesh'Shotgun.Shotgun'
		ReplacementPrimitive=none
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
}