class HaloWeaponAttachment_Shotgun extends HaloWeaponAttachment;

var name FirePawnAnim;
var float FirePawnAnimBlendOutTime;

simulated function ThirdPersonFireEffects(Vector HitLocation)
{
	local HaloPawn P;

	// End:0x51
	if((Instigator != none) && EffectIsRelevant(Instigator.Location, false, MaxFireEffectDistance))
	{
		CauseMuzzleFlash();
	}
	P = HaloPawn(Instigator);
	// End:0xD6
	if(P != none)
	{
		P.PlayCustomAnimation(FirePawnAnim, false, false, WeaponClass.default.FireInterval[0],, 0.0000000, FirePawnAnimBlendOutTime);
	}
	//return;	
}

defaultproperties
{
	FirePawnAnim="Fire_SG"
	FirePawnAnimBlendOutTime=0.1500000
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment_Shotgun.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment.SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0"
		SkeletalMesh=SkeletalMesh'Shotgun.Shotgun'
		// Reference: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment_Shotgun.SkeletalMeshComponent0.MeshSequenceA'
		// Archetype: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment.SkeletalMeshComponent0.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		Materials[0]=MaterialInstanceConstant'Shotgun.Materials.MIC.MI_WeaponsUNSCShotgun_Mat'
		ReplacementPrimitive=none
		MaxDrawDistance=5000.0000000
		CachedMaxDrawDistance=5000.0000000
	end object
	Mesh=SkeletalMeshComponent0
	MuzzleFlashSocket="Muzzle_Socket"
	MuzzleFlashPSCTemplate=ParticleSystem'wp_unsc_m90_shgun.Effects.WP_UNSC_M90_SHGUN_Muzz_Flsh'
	MuzzleFlashColor=(R=222,G=222,B=255,A=0)
	MuzzleFlashDuration=0.0950000
	DefaultImpactEffect=(DecalMaterials=(MaterialInstanceTimeVarying'WP_UNSC_ASSAULT.Decals.MITV_WP_RocketLauncher_Impact_Decal01'),DurationOfDecal=5.0000000,DecalWidth=32.0000000,DecalHeight=32.0000000,ParticleTemplate=ParticleSystem'WP_UNSC_ASSAULT.Effects.WP_UNSC_AssaultRifle_Hit')
	WeaponClass=Class'MegaHaloGame.HaloWeapon_Shotgun'
}