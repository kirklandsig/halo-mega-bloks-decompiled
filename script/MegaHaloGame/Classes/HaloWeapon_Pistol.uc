class HaloWeapon_Pistol extends HaloWeapon
	config(Weapon);

var float BeginChargingDelay;
var float ChargedShotDelay;
var float ChargedShotAmmoConsumptionRate;
var bool bChargedShotIsReady;
var float HeatPerChargedShot;
var AkEvent PlayChargeSoundEvent;
var AkEvent StopChargeSoundEvent;
var CameraShake ChargeShotCameraShake;
var ForceFeedbackWaveform ChargeWaveform;
var ForceFeedbackWaveform ChargeShotWaveform;

function float GetChargePercent()
{
	return 0.0000000;
	//return ReturnValue;	
}

function SetChargeShotAsReady()
{
	//return;	
}

function ConsumeAmmo(byte FireModeNum)
{
	// End:0x1C
	if(bChargedShotIsReady)
	{
		super.ConsumeAmmo(1);		
	}
	else
	{
		super.ConsumeAmmo(0);
	}
	//return;	
}

function Class<Projectile> GetProjectileClass()
{
	// End:0x1C
	if(bChargedShotIsReady)
	{
		return WeaponProjectiles[1];		
	}
	else
	{
		return WeaponProjectiles[0];
	}
	//return ReturnValue;	
}

function bool ShouldTickOverheating()
{
	// End:0x3E
	if((IsFiring()) && !bChargedShotIsReady)
	{
		return GetTimerCount('SetChargeShotAsReady') >= BeginChargingDelay;
	}
	return true;
	//return ReturnValue;	
}

function ApplyHeatFromShot()
{
	// End:0x23
	if(bChargedShotIsReady)
	{
		ApplyHeat(HeatPerChargedShot);		
	}
	else
	{
		super.ApplyHeatFromShot();
	}
	//return;	
}

function ApplySpreadFromShot()
{
	// End:0x19
	if(!bChargedShotIsReady)
	{
		super.ApplySpreadFromShot();
	}
	//return;	
}

simulated function float PlayOverheatAnimation()
{
	local bool bIsFullBodyAnim;

	// End:0x67
	if(bChargedShotIsReady)
	{
		bChargedShotIsReady = true;
		bIsFullBodyAnim = HaloAIGruntPawn(Owner) != none;
		return PlayPawnAnim(CooldownPawnAnimName, bIsFullBodyAnim, CooldownPawnAnimTime);		
	}
	else
	{
		return super.PlayOverheatAnimation();
	}
	//return ReturnValue;	
}

simulated function PlayFireCameraShake(optional float magnitude = 1.0000000)
{
	local PlayerController PC;

	PC = PlayerController(Instigator.Controller);
	// End:0x1DC
	if(PC != none)
	{
		// End:0xB2
		if(bChargedShotIsReady && ChargeShotCameraShake != none)
		{
			PC.PlayerCamera.PlayCameraShake(ChargeShotCameraShake, magnitude);			
		}
		else
		{
			// End:0x1DC
			if(FireCameraShake != none)
			{
				FireCameraShake.RotOscillation.Pitch.Amplitude = float(int(Spread[int(CurrentFireMode)] * HorizontalRecoilRate));
				FireCameraShake.RotOscillation.Yaw.Amplitude = float(int(((RandomFloatSpread()) * (CurrentRecoilSpread())) * VerticalRecoilRate));
				PC.PlayerCamera.PlayCameraShake(FireCameraShake, magnitude);
			}
		}
	}
	//return;	
}

simulated function PlayFireForceFeedback()
{
	local PlayerController PC;

	PC = PlayerController(Instigator.Controller);
	// End:0xF1
	if((PC != none) && LocalPlayer(PC.Player) != none)
	{
		// End:0xB9
		if(bChargedShotIsReady && ChargeShotWaveform != none)
		{
			PC.ClientPlayForceFeedbackWaveform(ChargeShotWaveform);			
		}
		else
		{
			// End:0xF1
			if(FireWaveform != none)
			{
				PC.ClientPlayForceFeedbackWaveform(FireWaveform);
			}
		}
	}
	//return;	
}

function StartChargeUpFX()
{
	local HaloWeaponAttachment_Pistol WeapAttach;

	WeapAttach = HaloWeaponAttachment_Pistol(GetCurrentWeaponAttachment());
	// End:0x4B
	if(WeapAttach != none)
	{
		WeapAttach.StartChargeUpFX();
	}
	//return;	
}

function StopChargeUpFX()
{
	local HaloWeaponAttachment_Pistol WeapAttach;

	WeapAttach = HaloWeaponAttachment_Pistol(GetCurrentWeaponAttachment());
	// End:0x4B
	if(WeapAttach != none)
	{
		WeapAttach.StopChargeUpFX();
	}
	//return;	
}

function StartChargeSound()
{
	// End:0x28
	if(PlayChargeSoundEvent != none)
	{
		PlayAkEvent(PlayChargeSoundEvent);
	}
	//return;	
}

function StopChargeSound()
{
	// End:0x28
	if(StopChargeSoundEvent != none)
	{
		PlayAkEvent(StopChargeSoundEvent);
	}
	//return;	
}

function StartChargeUpRumble()
{
	local PlayerController PC;

	// End:0x89
	if((Instigator != none) && ChargeWaveform != none)
	{
		PC = PlayerController(Instigator.Controller);
		// End:0x89
		if(PC != none)
		{
			PC.ClientPlayForceFeedbackWaveform(ChargeWaveform);
		}
	}
	//return;	
}

function StopChargeUpRumble()
{
	local PlayerController PC;

	// End:0x88
	if((Instigator != none) && ChargeWaveform != none)
	{
		PC = PlayerController(Instigator.Controller);
		// End:0x88
		if(PC != none)
		{
			PC.ClientStopForceFeedbackWaveform(ChargeWaveform);
		}
	}
	//return;	
}

simulated state WeaponFiring
{
	simulated event BeginState(name PrevStateName)
	{
		bChargedShotIsReady = false;
		// End:0x47
		if(AmmoCount >= ShotCost[1])
		{
			SetTimer(BeginChargingDelay + ChargedShotDelay, false, 'SetChargeShotAsReady');
		}
		//return;		
	}

	simulated function EndState(name NextStateName)
	{
		StopChargeUpFX();
		StopChargeUpRumble();
		StopChargeSound();
		ClearTimer('ConsumeAmmoForChargeUp');
		ClearTimer('SetChargeShotAsReady');
		super.EndState(NextStateName);
		//return;		
	}

	function SetChargeShotAsReady()
	{
		StartChargeUpFX();
		StartChargeUpRumble();
		StartChargeSound();
		// End:0x4F
		if(ChargedShotAmmoConsumptionRate > 0.0000000)
		{
			SetTimer(1.0000000 / ChargedShotAmmoConsumptionRate, true, 'ConsumeAmmoForChargeUp');
		}
		FireSoundEvent[0] = AkEvent'Weapons.Play_WEP_COV_PlasmaPistol_Charge_Shot';
		bChargedShotIsReady = true;
		//return;		
	}

	function ConsumeAmmoForChargeUp()
	{
		AmmoCount = Max(0, AmmoCount - 1);
		//return;		
	}

	simulated function Tick(float DeltaTime)
	{
		local bool doFire;

		// End:0x29
		if(!PendingFire(int(CurrentFireMode)))
		{
			doFire = true;			
		}
		else
		{
			// End:0x63
			if((ChargedShotAmmoConsumptionRate > 0.0000000) && AmmoCount <= ShotCost[1])
			{
				doFire = true;
			}
		}
		// End:0xBE
		if(doFire)
		{
			FireAmmunition();
			FireSoundEvent[0] = AkEvent'Weapons.Play_Weapon_Fire';
			// End:0xBB
			if(IsFiring())
			{
				ClearPendingFire(int(CurrentFireMode));
				HandleFinishedFiring();
			}			
		}
		else
		{
			TickOverheating(DeltaTime);
		}
		//return;		
	}

	function float GetChargePercent()
	{
		local float Elapsed, Percent;

		// End:0x1F
		if(bChargedShotIsReady)
		{
			Percent = 1.0000000;			
		}
		else
		{
			// End:0x9A
			if(IsTimerActive('SetChargeShotAsReady'))
			{
				Elapsed = GetTimerCount('SetChargeShotAsReady') - BeginChargingDelay;
				Percent = Elapsed / ChargedShotDelay;
				Percent = FMax(Percent, 0.0000000);				
			}
			else
			{
				Percent = 0.0000000;
			}
		}
		return Percent;
		//return ReturnValue;		
	}
	stop;	
}

defaultproperties
{
	BeginChargingDelay=0.3000000
	ChargedShotDelay=0.7000000
	HeatPerChargedShot=1.0000000
	PlayChargeSoundEvent=AkEvent'Weapons.Play_WEP_COV_PlasmaPistol_Charge'
	StopChargeSoundEvent=AkEvent'Weapons.Stop_WEP_COV_PlasmaPistol_Charge_Start'
	// Reference: CameraShake'MegaHaloGame.Default__HaloWeapon_Pistol.ChargeShotCameraShake1'
	begin object name="ChargeShotCameraShake1" class=Engine.CameraShake
		OscillationDuration=0.2000000
		RotOscillation=(Pitch=(Amplitude=7500.0000000,Frequency=1.0000000,InitialOffset=EOO_OffsetZero),Yaw=(Amplitude=1500.0000000,Frequency=2.0000000))
	end object
	ChargeShotCameraShake=ChargeShotCameraShake1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_Pistol.ChargeWaveform1'
	begin object name="ChargeWaveform1" class=Engine.ForceFeedbackWaveform
		bIsLooping=true
		Samples[0]=(LeftAmplitude=60,RightAmplitude=60,LeftFunction=WF_Noise,RightFunction=WF_Noise,Duration=0.2000000)
	end object
	ChargeWaveform=ChargeWaveform1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_Pistol.ChargeShotWaveform1'
	begin object name="ChargeShotWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=90,RightAmplitude=90,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=1.0000000)
	end object
	ChargeShotWaveform=ChargeShotWaveform1
	HUDIcon="plasmaPistol"
	SwapToMessage="Press [MainHUD.InlineInputIcons.inputIcon_y] To Switch To Plasma Pistol"
	bIsEnergyPowered=true
	HeatPerShot=0.1000000
	CooldownRate=0.3000000
	CooldownPawnAnimName="Overheat_Pistol"
	FireSoundEvent[0]=AkEvent'Weapons.Play_Weapon_Fire'
	FireSoundEvent[1]=AkEvent'Weapons.Play_WEP_COV_PlasmaPistol_Charge_Shot'
	MeleeSoundEvent=AkEvent'Melee.Play_Melee_Swing'
	SwitchToSoundEvent=AkEvent'Weapons.Play_Weapon_Equip'
	OverheatSoundEvent=AkEvent'Weapons.Play_WEP_COV_PlasmaPistol_Charge_Shot'
	akWeaponType="COV_PlasmaPistol"
	SpreadMax=0.0000000
	SpreadIncWithEachShot=0.0300000
	SpreadDecRate=-0.1000000
	DroppedPickupMeshTemplate=StaticMesh'Plasma_Pistol.Plasma_Pistol_Static'
	MeleeAnimName="Spartan_Pist_Melee_02"
	MeleeRange=250.0000000
	ThrowGrenadePawnAnimName="ThrowGrenade_Pistol"
	ReadyPawnAnimName="Ready_Pistol"
	FirePawnAnimName="Fire_Pistol"
	FireChargedPawnAnimName="Fire_Pistol_Charged"
	RelaxPawnAnimName="Relax_Pistol"
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_Pistol.FireWaveform1'
	begin object name="FireWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.1500000)
	end object
	FireWaveform=FireWaveform1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_Pistol.MeleeWaveform1'
	begin object name="MeleeWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=60,RightAmplitude=60,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.2000000)
	end object
	MeleeWaveform=MeleeWaveform1
	MeleeFeedbackDelay=0.1000000
	// Reference: CameraShake'MegaHaloGame.Default__HaloWeapon_Pistol.FireCameraShake1'
	begin object name="FireCameraShake1" class=Engine.CameraShake
		OscillationDuration=0.1000000
		RotOscillation=(Pitch=(Amplitude=10.0000000,Frequency=1.0000000,InitialOffset=EOO_OffsetZero),Yaw=(Amplitude=10.0000000,Frequency=1.0000000,InitialOffset=EOO_OffsetZero))
	end object
	FireCameraShake=FireCameraShake1
	// Reference: CameraShake'MegaHaloGame.Default__HaloWeapon_Pistol.MeleeCameraShake1'
	begin object name="MeleeCameraShake1" class=Engine.CameraShake
		OscillationDuration=0.4000000
		RotOscillation=(Pitch=(Amplitude=100.0000000,Frequency=1.0000000),Yaw=(Amplitude=1000.0000000,Frequency=2.0000000))
	end object
	MeleeCameraShake=MeleeCameraShake1
	HorizontalRecoilRate=20000.0000000
	VerticalRecoilRate=10000.0000000
	DefaultRecoilSpread=0.1000000
	bShouldDrawCrosshairDropShadow=false
	MaxAmmoCount=100
	ShotCost[0]=2
	ShotCost[1]=20
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_Pistol.ForceFeedbackWaveformShooting1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon.ForceFeedbackWaveformShooting1'
	begin object name="ForceFeedbackWaveformShooting1"
	end object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	CrossHairCoordinates=(U=256.0000000,V=0.0000000)
	CrosshairImage=Texture2D'mainhud.Crosshairs'
	WeaponName="Weapon_PlasmaPistol"
	HUDFrameName="plasmaPistol"
	InventoryGroup=1
	AttachmentClass=Class'MegaHaloGame.HaloWeaponAttachment_Pistol'
	MuzzleFlashDuration=0.1500000
	AmmoCount=100
	FiringStatesArray[0]="DelayedWeaponFiring"
	FiringStatesArray[1]="WeaponFiring"
	WeaponFireTypes[0]=0
	WeaponFireTypes[1]=0
	WeaponProjectiles[0]=Class'MegaHaloGame.HaloProjectile_PistolBullet'
	WeaponProjectiles[1]=Class'MegaHaloGame.HaloProjectile_ChargedPistolBullet'
	Spread[0]=0.0200000
	Spread[1]=0.0000000
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_Pistol.FirstPersonMesh'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon.FirstPersonMesh'
	begin object name="FirstPersonMesh"
		ReplacementPrimitive=none
	end object
	Mesh=FirstPersonMesh
	PickupMessage="Hold [MainHUD.InlineInputIcons.inputIcon_y] To Pick Up Plasma Pistol"
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_Pistol.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon.PickupMesh'
	begin object name="PickupMesh"
		SkeletalMesh=SkeletalMesh'Plasma_Pistol.Plasma_Pistol'
		ReplacementPrimitive=none
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
}