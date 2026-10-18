class HaloWeapon_StormRifle extends HaloWeapon
	config(Weapon);

defaultproperties
{
	HUDIcon="stormRifle"
	SwapToMessage="Press [MainHUD.InlineInputIcons.inputIcon_y] To Switch To Storm Rifle"
	bIsEnergyPowered=true
	HeatPerShot=0.0312500
	CooldownRate=0.3125000
	FireSoundEvent[0]=AkEvent'Weapons.Play_Weapon_Fire'
	MeleeSoundEvent=AkEvent'Melee.Play_Melee_Swing'
	akWeaponType="COV_PlasmaRifle"
	SpreadMax=0.0000000
	SpreadIncWithEachShot=0.0100000
	SpreadDecRate=-0.0750000
	DroppedPickupMeshTemplate=StaticMesh'Storm_Rifle.Storm_Rifle_Static'
	MeleeRange=250.0000000
	ReadyPawnAnimName="Ready_Rifle"
	FirePawnAnimName="Fire_Rifle"
	FireChargedPawnAnimName="Fire_Rifle"
	RelaxPawnAnimName="Relax_Rifle"
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_StormRifle.FireWaveform1'
	begin object name="FireWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=60,RightAmplitude=60,LeftFunction=EWaveformFunction.WF_LinearDecreasing,RightFunction=EWaveformFunction.WF_LinearDecreasing,Duration=0.2000000)
	end object
	FireWaveform=FireWaveform1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_StormRifle.ReloadWaveform1'
	begin object name="ReloadWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=EWaveformFunction.WF_LinearDecreasing,RightFunction=EWaveformFunction.WF_LinearDecreasing,Duration=0.2500000)
	end object
	RemoveClipWaveform=ReloadWaveform1
	InsertClipWaveform=ReloadWaveform1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_StormRifle.MeleeWaveform1'
	begin object name="MeleeWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=60,RightAmplitude=60,LeftFunction=EWaveformFunction.WF_LinearDecreasing,RightFunction=EWaveformFunction.WF_LinearDecreasing,Duration=0.2000000)
	end object
	MeleeWaveform=MeleeWaveform1
	RemoveClipFeedbackDelay=0.5000000
	InsertClipFeedbackDelay=1.0000000
	MeleeFeedbackDelay=0.1000000
	// Reference: CameraShake'MegaHaloGame.Default__HaloWeapon_StormRifle.FireCameraShake1'
	begin object name="FireCameraShake1" class=Engine.CameraShake
		OscillationDuration=0.1000000
		RotOscillation=(Pitch=(Amplitude=10.0000000,Frequency=1.0000000,InitialOffset=EInitialOscillatorOffset.EOO_OffsetZero),Yaw=(Amplitude=10.0000000,Frequency=1.0000000,InitialOffset=EInitialOscillatorOffset.EOO_OffsetZero))
	end object
	FireCameraShake=FireCameraShake1
	// Reference: CameraShake'MegaHaloGame.Default__HaloWeapon_StormRifle.MeleeCameraShake1'
	begin object name="MeleeCameraShake1" class=Engine.CameraShake
		OscillationDuration=0.4000000
		RotOscillation=(Pitch=(Amplitude=100.0000000,Frequency=1.0000000),Yaw=(Amplitude=1000.0000000,Frequency=2.0000000))
	end object
	MeleeCameraShake=MeleeCameraShake1
	bShouldDrawCrosshairDropShadow=false
	MaxAmmoCount=200
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_StormRifle.ForceFeedbackWaveformShooting1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon.ForceFeedbackWaveformShooting1'
	begin object name="ForceFeedbackWaveformShooting1"
	end object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	CrossHairCoordinates=(U=256.0000000,V=0.0000000)
	CrosshairImage=Texture2D'mainhud.Crosshairs'
	WeaponName="Weapon_StormRifle"
	HUDFrameName="stormRifle"
	InventoryGroup=1
	AttachmentClass=Class'MegaHaloGame.HaloWeaponAttachment_StormRifle'
	MuzzleFlashDuration=0.1500000
	AmmoCount=200
	FiringStatesArray[0]="DelayedWeaponFiring"
	FiringStatesArray[1]="WeaponFiring"
	WeaponFireTypes[0]=0
	WeaponFireTypes[1]=0
	WeaponProjectiles[0]=Class'MegaHaloGame.HaloProjectile_StormRifleBullet'
	WeaponProjectiles[1]=none
	FireInterval[0]=0.1500000
	FireInterval[1]=1.0000000
	Spread[0]=0.0914000
	Spread[1]=0.0000000
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_StormRifle.FirstPersonMesh'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon.FirstPersonMesh'
	begin object name="FirstPersonMesh"
		ReplacementPrimitive=none
	end object
	Mesh=FirstPersonMesh
	PickupMessage="Hold [MainHUD.InlineInputIcons.inputIcon_y] To Pick Up Storm Rifle"
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_StormRifle.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon.PickupMesh'
	begin object name="PickupMesh"
		SkeletalMesh=SkeletalMesh'Storm_Rifle.Storm_Rifle'
		ReplacementPrimitive=none
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
}