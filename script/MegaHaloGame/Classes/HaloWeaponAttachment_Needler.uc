class HaloWeaponAttachment_Needler extends HaloWeaponAttachment;

defaultproperties
{
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment_Needler.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment.SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0"
		SkeletalMesh=SkeletalMesh'Needler.Needler'
		// Reference: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment_Needler.SkeletalMeshComponent0.MeshSequenceA'
		// Archetype: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment.SkeletalMeshComponent0.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		Materials[0]=MaterialInstanceConstant'Needler.Materials.MIC.MI_WeaponsCovenantNeedler_Mat'
		Materials[1]=MaterialInstanceConstant'Needler.Materials.MI_FX_Glass_Needles_Mat'
		Materials[2]=MaterialInstanceConstant'Needler.Materials.MIC.MI_WeaponsCovenantNeedler_Mat'
		ReplacementPrimitive=none
		MaxDrawDistance=5000.0000000
		CachedMaxDrawDistance=5000.0000000
	end object
	Mesh=SkeletalMeshComponent0
	MuzzleFlashSocket="Muzzle_Socket"
	MuzzleFlashPSCTemplate=ParticleSystem'WP_COV_NEEDLER.Effects.wp_cov_NEEDLER_MUZZ'
	MuzzleFlashColor=(R=222,G=222,B=255,A=0)
	MuzzleFlashDuration=0.0950000
	DefaultImpactEffect=(DecalMaterials=(MaterialInstanceTimeVarying'WP_UNSC_ASSAULT.Decals.MITV_WP_RocketLauncher_Impact_Decal01'),DurationOfDecal=5.0000000,DecalWidth=32.0000000,DecalHeight=32.0000000,ParticleTemplate=ParticleSystem'WP_UNSC_ASSAULT.Effects.WP_UNSC_AssaultRifle_Hit')
	WeaponClass=Class'MegaHaloGame.HaloWeapon_Needler'
	WeapAnimType=EWeapAnimType.EWAT_Pistol
}