class HaloWeapon_BattleRifle extends HaloWeapon
	config(Weapon);

var bool bDisableFiring;
var float BurstInterval;
var int BurstFireCounter;

simulated function StartFire(byte FireModeNum)
{
	// End:0x22
	if(!bDisableFiring)
	{
		super.StartFire(FireModeNum);
	}
	//return;	
}

simulated function BeginFire(byte FireModeNum)
{
	super(Weapon).BeginFire(FireModeNum);
	// End:0x49
	if(BurstInterval > 0.0000000)
	{
		bDisableFiring = true;
		SetTimer(BurstInterval, false, 'EnableFiring');
	}
	//return;	
}

function EnableFiring()
{
	bDisableFiring = false;
	//return;	
}

simulated function FireAmmunition()
{
	BurstFireCounter -= 1;
	super.FireAmmunition();
	//return;	
}

simulated state WeaponFiring
{
	simulated event BeginState(name PrevStateName)
	{
		BurstFireCounter = 3;
		super.BeginState(PrevStateName);
		//return;		
	}

	simulated function RefireCheckTimer()
	{
		// End:0x1C
		if(BurstFireCounter > 0)
		{
			FireAmmunition();			
		}
		else
		{
			ForceEndFire();
			HandleFinishedFiring();
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	BurstInterval=0.3300000
	HUDIcon="battleRifle"
	SwapToMessage="Press [MainHUD.InlineInputIcons.inputIcon_y] To Switch To Battle Rifle"
	zoomLevelCt=2
	ExtraAmmoCount=108
	MaxExtraAmmoCount=108
	FireSoundEvent[0]=AkEvent'Weapons.Play_Weapon_Fire'
	MeleeSoundEvent=AkEvent'Melee.Play_Melee_Swing'
	ReloadSoundEvent=AkEvent'Weapons.Play_Weapon_Reload'
	SwitchToSoundEvent=AkEvent'Weapons.Play_Weapon_Equip'
	RicochetArraySize=10
	akWeaponType="UNSC_BattleRifle"
	SpreadMin=0.0050000
	SpreadMax=0.1200000
	SpreadIncWithEachShot=0.0050000
	DroppedPickupMeshTemplate=StaticMesh'Battle_Rifle.Battle_Rifle_Static'
	MeleeRange=250.0000000
	ReadyPawnAnimName="Ready_Rifle"
	FirePawnAnimName="Fire_Rifle"
	FireChargedPawnAnimName="Fire_Rifle"
	RelaxPawnAnimName="Relax_Rifle"
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_BattleRifle.FireWaveform1'
	begin object name="FireWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=60,RightAmplitude=60,LeftFunction=EWaveformFunction.WF_LinearDecreasing,RightFunction=EWaveformFunction.WF_LinearDecreasing,Duration=0.2000000)
	end object
	FireWaveform=FireWaveform1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_BattleRifle.ReloadWaveform1'
	begin object name="ReloadWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=EWaveformFunction.WF_LinearDecreasing,RightFunction=EWaveformFunction.WF_LinearDecreasing,Duration=0.2500000)
	end object
	RemoveClipWaveform=ReloadWaveform1
	InsertClipWaveform=ReloadWaveform1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_BattleRifle.MeleeWaveform1'
	begin object name="MeleeWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=60,RightAmplitude=60,LeftFunction=EWaveformFunction.WF_LinearDecreasing,RightFunction=EWaveformFunction.WF_LinearDecreasing,Duration=0.2000000)
	end object
	MeleeWaveform=MeleeWaveform1
	RemoveClipFeedbackDelay=0.5000000
	InsertClipFeedbackDelay=1.0000000
	MeleeFeedbackDelay=0.1000000
	// Reference: CameraShake'MegaHaloGame.Default__HaloWeapon_BattleRifle.FireCameraShake1'
	begin object name="FireCameraShake1" class=Engine.CameraShake
		OscillationDuration=0.1000000
		RotOscillation=(Pitch=(Amplitude=10.0000000,Frequency=1.0000000,InitialOffset=EInitialOscillatorOffset.EOO_OffsetZero),Yaw=(Amplitude=10.0000000,Frequency=1.0000000,InitialOffset=EInitialOscillatorOffset.EOO_OffsetZero))
	end object
	FireCameraShake=FireCameraShake1
	// Reference: CameraShake'MegaHaloGame.Default__HaloWeapon_BattleRifle.MeleeCameraShake1'
	begin object name="MeleeCameraShake1" class=Engine.CameraShake
		OscillationDuration=0.4000000
		RotOscillation=(Pitch=(Amplitude=100.0000000,Frequency=1.0000000),Yaw=(Amplitude=1000.0000000,Frequency=2.0000000))
	end object
	MeleeCameraShake=MeleeCameraShake1
	bShouldDrawCrosshairDropShadow=false
	LockerAmmoCount=144
	MaxAmmoCount=36
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_BattleRifle.ForceFeedbackWaveformShooting1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon.ForceFeedbackWaveformShooting1'
	begin object name="ForceFeedbackWaveformShooting1"
	end object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	CrossHairCoordinates=(U=256.0000000,V=0.0000000)
	CrosshairImage=Texture2D'mainhud.Crosshairs'
	WeaponName="Weapon_BattleRifle"
	HUDFrameName="battleRifle"
	InventoryGroup=1
	AttachmentClass=Class'MegaHaloGame.HaloWeaponAttachment_BattleRifle'
	MuzzleFlashDuration=0.1500000
	AmmoCount=36
	FiringStatesArray[0]="DelayedWeaponFiring"
	FiringStatesArray[1]="WeaponFiring"
	WeaponFireTypes[0]=0
	WeaponFireTypes[1]=0
	WeaponProjectiles[0]=Class'MegaHaloGame.HaloProjectile_BattleRifleBullet'
	WeaponProjectiles[1]=none
	FireInterval[0]=0.0600000
	FireInterval[1]=1.0000000
	Spread[0]=0.0050000
	Spread[1]=0.0000000
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_BattleRifle.FirstPersonMesh'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon.FirstPersonMesh'
	begin object name="FirstPersonMesh"
		ReplacementPrimitive=none
	end object
	Mesh=FirstPersonMesh
	PickupMessage="Hold [MainHUD.InlineInputIcons.inputIcon_y] To Pick Up Battle Rifle"
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_BattleRifle.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon.PickupMesh'
	begin object name="PickupMesh"
		SkeletalMesh=SkeletalMesh'Battle_Rifle.Battle_Rifle'
		ReplacementPrimitive=none
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
}