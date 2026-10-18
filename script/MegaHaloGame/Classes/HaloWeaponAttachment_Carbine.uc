class HaloWeaponAttachment_Carbine extends HaloWeaponAttachment;

defaultproperties
{
	OverheatFxTemplate=ParticleSystem'WP_COV_STORM.Effects.WP_STORM_OVERHEAT'
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment_Carbine.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment.SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0"
		SkeletalMesh=SkeletalMesh'Covenant_Carbine.Covenant_Carbine'
		// Reference: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment_Carbine.SkeletalMeshComponent0.MeshSequenceA'
		// Archetype: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment.SkeletalMeshComponent0.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		Materials[0]=Material'Covenant_Carbine.Covenant_Carbine_MAT'
		Materials[1]=Material'Covenant_Carbine.Covenant_Carbine_MAT'
		ReplacementPrimitive=none
		MaxDrawDistance=5000.0000000
		CachedMaxDrawDistance=5000.0000000
	end object
	Mesh=SkeletalMeshComponent0
	MuzzleFlashSocket="Muzzle_Socket"
	MuzzleFlashPSCTemplate=ParticleSystem'WP_COV_CARBINE.Effects.WP_COV_CARBINE_MUZZ'
	MuzzleFlashColor=(R=222,G=222,B=255,A=0)
	MuzzleFlashDuration=0.0950000
	DefaultImpactEffect=(ParticleTemplate=ParticleSystem'WP_UNSC_ASSAULT.Effects.WP_UNSC_AssaultRifle_Hit')
	WeaponClass=Class'MegaHaloGame.HaloWeapon_Carbine'
}