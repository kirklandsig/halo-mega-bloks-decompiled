class HaloWeapon_EnergySword_Content extends HaloWeapon_EnergySword
	config(Weapon);

defaultproperties
{
	MeleeSoundEvent=AkEvent'Melee.Play_Melee_Swing'
	SwitchToSoundEvent=AkEvent'Weapons.Play_Weapon_Equip'
	DroppedPickupMeshTemplate=StaticMesh'Plasma_Sword.Plasma_Sword_Static'
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_EnergySword_Content.ForceFeedbackWaveformShooting1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_EnergySword.ForceFeedbackWaveformShooting1'
	begin object name="ForceFeedbackWaveformShooting1"
	end object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	AttachmentClass=Class'MegaHaloGame.HaloWeaponAttachment_EnergySword_Content'
	MuzzleFlashDuration=0.1500000
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_EnergySword_Content.FirstPersonMesh'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_EnergySword.FirstPersonMesh'
	begin object name="FirstPersonMesh"
		ReplacementPrimitive=none
	end object
	Mesh=FirstPersonMesh
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_EnergySword_Content.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_EnergySword.PickupMesh'
	begin object name="PickupMesh"
		SkeletalMesh=SkeletalMesh'Plasma_Sword.Plasma_Sword'
		ReplacementPrimitive=none
		Scale=0.6666660
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
}