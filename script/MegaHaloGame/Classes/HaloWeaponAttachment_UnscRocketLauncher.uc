class HaloWeaponAttachment_UnscRocketLauncher extends HaloWeaponAttachment;

defaultproperties
{
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment_UnscRocketLauncher.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment.SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0"
		// Reference: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment_UnscRocketLauncher.SkeletalMeshComponent0.MeshSequenceA'
		// Archetype: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment.SkeletalMeshComponent0.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		ReplacementPrimitive=none
	end object
	Mesh=SkeletalMeshComponent0
	WeaponClass=Class'MegaHaloGame.HaloWeapon_UnscRocketLauncher'
}