class HaloWeaponAttachment_UnscPistol extends HaloWeaponAttachment;

defaultproperties
{
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment_UnscPistol.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment.SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0"
		SkeletalMesh=SkeletalMesh'm6d_pistol.M6Dpistol'
		// Reference: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment_UnscPistol.SkeletalMeshComponent0.MeshSequenceA'
		// Archetype: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment.SkeletalMeshComponent0.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		Materials[0]=MaterialInstanceConstant'm6d_pistol.Materials.MIC.MI_WeaponsUNSCM6DPistol_Mat'
		ReplacementPrimitive=none
		MaxDrawDistance=5000.0000000
		CachedMaxDrawDistance=5000.0000000
	end object
	Mesh=SkeletalMeshComponent0
	MuzzleFlashSocket="Muzzle_Socket"
	MuzzleFlashPSCTemplate=ParticleSystem'WP_UNSC_M6D_Pistol.Effects.WP_M6D_Pistol_Muzz_Flsh'
	MuzzleFlashColor=(R=222,G=222,B=255,A=0)
	MuzzleFlashDuration=0.0950000
	DefaultImpactEffect=(DecalMaterials=(MaterialInstanceTimeVarying'WP_UNSC_ASSAULT.Decals.MITV_WP_RocketLauncher_Impact_Decal01'),DurationOfDecal=5.0000000,DecalWidth=32.0000000,DecalHeight=32.0000000,ParticleTemplate=ParticleSystem'WP_UNSC_ASSAULT.Effects.WP_UNSC_AssaultRifle_Hit')
	WeaponClass=Class'MegaHaloGame.HaloWeapon_UnscPistol'
	WeapAnimType=EWeapAnimType.EWAT_Pistol
}