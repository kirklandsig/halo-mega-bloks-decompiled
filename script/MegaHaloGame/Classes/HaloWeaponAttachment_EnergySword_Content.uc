class HaloWeaponAttachment_EnergySword_Content extends HaloWeaponAttachment;

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
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment_EnergySword_Content.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment.SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0"
		SkeletalMesh=SkeletalMesh'Plasma_Sword.Plasma_Sword'
		// Reference: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment_EnergySword_Content.SkeletalMeshComponent0.MeshSequenceA'
		// Archetype: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment.SkeletalMeshComponent0.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		Materials[0]=MaterialInstanceConstant'Plasma_Sword.Materials.MIC.MI_Presets_PlasmaSword_Mat'
		ReplacementPrimitive=none
		MaxDrawDistance=5000.0000000
		CachedMaxDrawDistance=5000.0000000
		Scale=0.6666660
	end object
	Mesh=SkeletalMeshComponent0
	WeaponClass=Class'MegaHaloGame.HaloWeapon_EnergySword_Content'
	WeapAnimType=EWeapAnimType.EWAT_Stinger
}