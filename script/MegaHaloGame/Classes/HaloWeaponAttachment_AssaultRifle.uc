class HaloWeaponAttachment_AssaultRifle extends HaloWeaponAttachment;

defaultproperties
{
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment_AssaultRifle.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment.SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0"
		SkeletalMesh=SkeletalMesh'Assault_Rifle.Assault_Rifle_skelm'
		// Reference: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment_AssaultRifle.SkeletalMeshComponent0.MeshSequenceA'
		// Archetype: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment.SkeletalMeshComponent0.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		Materials[0]=MaterialInstanceConstant'Assault_Rifle.Materials.MIC.MI_WeaponsUNSCAssaultRifle_Mat'
		ReplacementPrimitive=none
		MaxDrawDistance=5000.0000000
		CachedMaxDrawDistance=5000.0000000
	end object
	Mesh=SkeletalMeshComponent0
	MuzzleFlashSocket="Muzzle_Socket"
	MuzzleFlashPSCTemplate=ParticleSystem'WP_UNSC_ASSAULT.Effects.WP_AssaultRifle_Muzzle_Flash'
	MuzzleFlashColor=(R=222,G=222,B=255,A=0)
	MuzzleFlashDuration=0.0950000
	DefaultImpactEffect=(DecalMaterials=(MaterialInstanceTimeVarying'WP_UNSC_ASSAULT.Decals.MITV_WP_RocketLauncher_Impact_Decal01'),DurationOfDecal=5.0000000,DecalWidth=32.0000000,DecalHeight=32.0000000,ParticleTemplate=ParticleSystem'WP_UNSC_ASSAULT.Effects.WP_UNSC_AssaultRifle_Hit')
	WeaponClass=Class'MegaHaloGame.HaloWeapon_AssaultRifle'
}