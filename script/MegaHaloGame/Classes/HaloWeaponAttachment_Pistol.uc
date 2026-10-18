class HaloWeaponAttachment_Pistol extends HaloWeaponAttachment;

var name ChargeUpFxSocket;
var ParticleSystem ChargeUpFxTemplate;
var export editinline ParticleSystemComponent ChargeUpFx;
var Class<PointLightComponent> ChargeUpLightClass;
var export editinline PointLightComponent ChargeUpLight;
var float ChargeUpLightBrightnessPctInterpSpeed;
var float ChargeUpLightBrightnessPct;

function Destroyed()
{
	StopChargeUpFX();
	super(Actor).Destroyed();
	//return;	
}

function Tick(float DeltaTime)
{
	TickChargeUpLightBrightness(DeltaTime);
	super(Actor).Tick(DeltaTime);
	//return;	
}

simulated event StopThirdPersonFireEffects()
{
	//return;	
}

function StartChargeUpFX()
{
	// End:0x7C
	if((ChargeUpFx == none) && ChargeUpFxTemplate != none)
	{
		ChargeUpFx = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(ChargeUpFxTemplate, Mesh, ChargeUpFxSocket, true);
	}
	// End:0x12D
	if((ChargeUpLight == none) && ChargeUpLightClass != none)
	{
		// End:0x12D
		if(Mesh != none)
		{
			ChargeUpLight = new ChargeUpLightClass;
			Mesh.AttachComponentToSocket(ChargeUpLight, ChargeUpFxSocket);
			ChargeUpLightBrightnessPct = 0.0000000;
			ChargeUpLight.SetLightProperties(ChargeUpLightBrightnessPct);
		}
	}
	//return;	
}

function StopChargeUpFX()
{
	// End:0x51
	if(ChargeUpLight != none)
	{
		// End:0x46
		if(Mesh != none)
		{
			Mesh.DetachComponent(ChargeUpLight);
		}
		ChargeUpLight = none;
	}
	// End:0x8A
	if(ChargeUpFx != none)
	{
		ChargeUpFx.DeactivateSystem();
		ChargeUpFx = none;
	}
	//return;	
}

function TickChargeUpLightBrightness(float DeltaTime)
{
	// End:0xA2
	if((ChargeUpLight != none) && ChargeUpLightBrightnessPct < 1.0000000)
	{
		ChargeUpLightBrightnessPct = FInterpConstantTo(ChargeUpLightBrightnessPct, 1.0000000, DeltaTime, ChargeUpLightBrightnessPctInterpSpeed);
		ChargeUpLight.SetLightProperties(ChargeUpLightBrightnessPct * ChargeUpLightClass.default.Brightness);
	}
	//return;	
}

defaultproperties
{
	ChargeUpFxSocket="Muzzle_Socket"
	ChargeUpFxTemplate=ParticleSystem'wp_cov_plasmapistol.Effects.wp_cov_PlsPistol_ChargUp'
	ChargeUpLightClass=Class'MegaHaloGame.HaloProjectile_ChargedPistolBulletLight'
	ChargeUpLightBrightnessPctInterpSpeed=3.0000000
	OverheatFxTemplate=ParticleSystem'wp_cov_plasmapistol.Effects.WP_PLASMAPISTOL_OVERHEAT'
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment_Pistol.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment.SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0"
		SkeletalMesh=SkeletalMesh'Plasma_Pistol.Plasma_Pistol'
		// Reference: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment_Pistol.SkeletalMeshComponent0.MeshSequenceA'
		// Archetype: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment.SkeletalMeshComponent0.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		Materials[0]=MaterialInstanceConstant'Plasma_Pistol.Materials.MIC.MI_WeaponsCovenantPlasmaPistol_Mat'
		ReplacementPrimitive=none
		MaxDrawDistance=5000.0000000
		CachedMaxDrawDistance=5000.0000000
	end object
	Mesh=SkeletalMeshComponent0
	MuzzleFlashSocket="Muzzle_Socket"
	MuzzleFlashPSCTemplate=ParticleSystem'wp_cov_plasmapistol.Effects.wp_cov_plasmapistol'
	MuzzleFlashColor=(R=222,G=222,B=255,A=0)
	MuzzleFlashDuration=0.1000000
	WeaponClass=Class'MegaHaloGame.HaloWeapon_Pistol'
	WeapAnimType=EWeapAnimType.EWAT_Pistol
}