class HaloWeaponAttachment_UnscRocketLauncher_Content extends HaloWeaponAttachment_UnscRocketLauncher;

defaultproperties
{
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment_UnscRocketLauncher_Content.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment_UnscRocketLauncher.SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0"
		SkeletalMesh=SkeletalMesh'rocket_launcher.rocket_launcher'
		// Reference: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment_UnscRocketLauncher_Content.SkeletalMeshComponent0.MeshSequenceA'
		// Archetype: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment_UnscRocketLauncher.SkeletalMeshComponent0.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		Materials[0]=Material'rocket_launcher.Rocket_Launcher_MAT'
		ReplacementPrimitive=none
		MaxDrawDistance=5000.0000000
		CachedMaxDrawDistance=5000.0000000
	end object
	Mesh=SkeletalMeshComponent0
	MuzzleFlashSocket="Muzzle_Socket"
	MuzzleFlashPSCTemplate=ParticleSystem'WP_UNSC_ROCKETLAUNCHER.Effects.WP_UNSC_ROCKETLAUNCH_MUZZ'
	MuzzleFlashColor=(R=222,G=222,B=255,A=0)
	MuzzleFlashDuration=0.0950000
	DefaultImpactEffect=(DecalMaterials=(MaterialInstanceTimeVarying'WP_UNSC_ASSAULT.Decals.MITV_WP_RocketLauncher_Impact_Decal01'),DurationOfDecal=5.0000000,DecalWidth=32.0000000,DecalHeight=32.0000000,ParticleTemplate=ParticleSystem'WP_UNSC_ASSAULT.Effects.WP_UNSC_AssaultRifle_Hit')
}