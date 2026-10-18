class HaloWeapon_UnscRocketLauncher_Content extends HaloWeapon_UnscRocketLauncher
	config(Weapon);

defaultproperties
{
	FireSoundEvent[0]=AkEvent'Weapons.Play_Weapon_Fire'
	MeleeSoundEvent=AkEvent'Melee.Play_Melee_Swing'
	ReloadSoundEvent=AkEvent'Weapons.Play_Weapon_Reload'
	SwitchToSoundEvent=AkEvent'Weapons.Play_Weapon_Equip'
	RicochetArraySize=10
	DroppedPickupMeshTemplate=StaticMesh'rocket_launcher.Rocket_Launcher_Static'
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher_Content.FireWaveform1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher.FireWaveform1'
	begin object name="FireWaveform1"
	end object
	FireWaveform=FireWaveform1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher_Content.ReloadWaveform1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher.ReloadWaveform1'
	begin object name="ReloadWaveform1"
	end object
	RemoveClipWaveform=ReloadWaveform1
	InsertClipWaveform=ReloadWaveform1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher_Content.MeleeWaveform1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher.MeleeWaveform1'
	begin object name="MeleeWaveform1"
	end object
	MeleeWaveform=MeleeWaveform1
	// Reference: CameraShake'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher_Content.FireCameraShake1'
	// Archetype: CameraShake'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher.FireCameraShake1'
	begin object name="FireCameraShake1"
	end object
	FireCameraShake=FireCameraShake1
	// Reference: CameraShake'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher_Content.MeleeCameraShake1'
	// Archetype: CameraShake'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher.MeleeCameraShake1'
	begin object name="MeleeCameraShake1"
	end object
	MeleeCameraShake=MeleeCameraShake1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher_Content.ForceFeedbackWaveformShooting1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher.ForceFeedbackWaveformShooting1'
	begin object name="ForceFeedbackWaveformShooting1"
	end object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	AttachmentClass=Class'MegaHaloGame.HaloWeaponAttachment_UnscRocketLauncher_Content'
	MuzzleFlashDuration=0.1500000
	WeaponProjectiles[0]=Class'MegaHaloGame.HaloProjectile_UnscRocket_Content'
	WeaponProjectiles[1]=none
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher_Content.FirstPersonMesh'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher.FirstPersonMesh'
	begin object name="FirstPersonMesh"
		ReplacementPrimitive=none
	end object
	Mesh=FirstPersonMesh
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher_Content.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher.PickupMesh'
	begin object name="PickupMesh"
		SkeletalMesh=SkeletalMesh'Assault_Rifle.Assault_Rifle_skelm'
		ReplacementPrimitive=none
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
}