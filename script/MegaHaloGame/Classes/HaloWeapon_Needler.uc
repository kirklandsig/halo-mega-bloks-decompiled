class HaloWeapon_Needler extends HaloWeapon
	config(Weapon);

defaultproperties
{
	HUDIcon="needler"
	SwapToMessage="Press [MainHUD.InlineInputIcons.inputIcon_y] To Switch To Needler"
	ReloadPawnAnimName="Reload_Needler"
	ExtraAmmoCount=88
	MaxExtraAmmoCount=176
	FireSoundEvent[0]=AkEvent'Weapons.Play_Weapon_Fire'
	MeleeSoundEvent=AkEvent'Melee.Play_Melee_Swing'
	ReloadSoundEvent=AkEvent'Weapons.Play_Weapon_Reload'
	SwitchToSoundEvent=AkEvent'Weapons.Play_Weapon_Equip'
	RicochetArraySize=10
	akWeaponType="COV_Needler"
	SpreadMax=0.0000000
	SpreadIncWithEachShot=0.0000000
	DroppedPickupMeshTemplate=StaticMesh'Needler.Needler_static'
	MeleeAnimName="Melee_Needler"
	MeleeRange=250.0000000
	ThrowGrenadePawnAnimName="ThrowGrenade_Pistol"
	ReadyPawnAnimName="Ready_Pistol"
	FirePawnAnimName="Fire_Needler"
	FireChargedPawnAnimName="Fire_Pistol_Charged"
	RelaxPawnAnimName="Relax_Pistol"
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_Needler.FireWaveform1'
	begin object name="FireWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=60,RightAmplitude=60,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.2000000)
	end object
	FireWaveform=FireWaveform1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_Needler.ReloadWaveform1'
	begin object name="ReloadWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.2500000)
	end object
	RemoveClipWaveform=ReloadWaveform1
	InsertClipWaveform=ReloadWaveform1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_Needler.MeleeWaveform1'
	begin object name="MeleeWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=60,RightAmplitude=60,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.2000000)
	end object
	MeleeWaveform=MeleeWaveform1
	RemoveClipFeedbackDelay=0.5000000
	InsertClipFeedbackDelay=1.0000000
	MeleeFeedbackDelay=0.1000000
	// Reference: CameraShake'MegaHaloGame.Default__HaloWeapon_Needler.FireCameraShake1'
	begin object name="FireCameraShake1" class=Engine.CameraShake
		OscillationDuration=0.1000000
		RotOscillation=(Pitch=(Amplitude=10.0000000,Frequency=1.0000000,InitialOffset=EOO_OffsetZero),Yaw=(Amplitude=10.0000000,Frequency=1.0000000,InitialOffset=EOO_OffsetZero))
	end object
	FireCameraShake=FireCameraShake1
	// Reference: CameraShake'MegaHaloGame.Default__HaloWeapon_Needler.MeleeCameraShake1'
	begin object name="MeleeCameraShake1" class=Engine.CameraShake
		OscillationDuration=0.4000000
		RotOscillation=(Pitch=(Amplitude=100.0000000,Frequency=1.0000000),Yaw=(Amplitude=1000.0000000,Frequency=2.0000000))
	end object
	MeleeCameraShake=MeleeCameraShake1
	bShouldDrawCrosshairDropShadow=false
	LockerAmmoCount=96
	MaxAmmoCount=22
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_Needler.ForceFeedbackWaveformShooting1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon.ForceFeedbackWaveformShooting1'
	begin object name="ForceFeedbackWaveformShooting1"
	end object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	CrossHairCoordinates=(U=256.0000000,V=0.0000000)
	CrosshairImage=Texture2D'mainhud.Crosshairs'
	WeaponName="Weapon_Needler"
	HUDFrameName="needler"
	InventoryGroup=1
	AttachmentClass=Class'MegaHaloGame.HaloWeaponAttachment_Needler'
	MuzzleFlashDuration=0.1500000
	AmmoCount=22
	FiringStatesArray[0]="DelayedWeaponFiring"
	FiringStatesArray[1]="WeaponFiring"
	WeaponFireTypes[0]=0
	WeaponFireTypes[1]=0
	WeaponProjectiles[0]=Class'MegaHaloGame.HaloProjectile_NeedlerNeedle'
	WeaponProjectiles[1]=none
	FireInterval[0]=0.0750000
	FireInterval[1]=1.0000000
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_Needler.FirstPersonMesh'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon.FirstPersonMesh'
	begin object name="FirstPersonMesh"
		ReplacementPrimitive=none
	end object
	Mesh=FirstPersonMesh
	PickupMessage="Hold [MainHUD.InlineInputIcons.inputIcon_y] To Pick Up Needler"
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_Needler.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon.PickupMesh'
	begin object name="PickupMesh"
		SkeletalMesh=SkeletalMesh'Needler.Needler'
		ReplacementPrimitive=none
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
}