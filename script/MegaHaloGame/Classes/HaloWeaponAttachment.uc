class HaloWeaponAttachment extends UTWeaponAttachment;

var ParticleSystem OverheatFxTemplate;
var name OverheatFxSocketName;

simulated function ThirdPersonFireEffects(Vector HitLocation)
{
	LastRenderTime = Mesh.LastRenderTime;
	super.ThirdPersonFireEffects(HitLocation);
	//return;	
}

function SpawnOverheatFX()
{
	// End:0x72
	if((Mesh != none) && OverheatFxTemplate != none)
	{
		WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(OverheatFxTemplate, Mesh, OverheatFxSocketName, true);
	}
	//return;	
}

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
	local MaterialImpactEffect ImpactEffect;
	local MaterialInterface MI;
	local MaterialInstanceTimeVarying MITV_Decal;
	local int DecalMaterialsLength;

	// End:0x32F
	if(LandscapeHeightfieldCollisionComponent(Impact.HitInfo.HitComponent) != none)
	{
		ImpactEffect = GetImpactEffect(Impact.HitInfo.PhysMaterial);
		DecalMaterialsLength = ImpactEffect.DecalMaterials.Length;
		// End:0x32F
		if(DecalMaterialsLength > 0)
		{
			MI = ImpactEffect.DecalMaterials[Rand(DecalMaterialsLength)];
			// End:0x32F
			if(MI != none)
			{
				// End:0x26D
				if(MaterialInstanceTimeVarying(MI) != none)
				{
					MITV_Decal = new (self) Class'Engine.MaterialInstanceTimeVarying';
					MITV_Decal.SetParent(MI);
					WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, Impact.HitLocation, Rotator(Impact.HitNormal-), ImpactEffect.DecalWidth, ImpactEffect.DecalHeight, 10.0000000, false);
					MITV_Decal.SetScalarStartTime(ImpactEffect.DecalDissolveParamName, ImpactEffect.DurationOfDecal);					
				}
				else
				{
					WorldInfo.MyDecalManager.SpawnDecal(MI, Impact.HitLocation, Rotator(Impact.HitNormal-), ImpactEffect.DecalWidth, ImpactEffect.DecalHeight, 10.0000000, false);
				}
			}
		}
	}
	//return;	
}

defaultproperties
{
	OverheatFxSocketName="OverheatFX_Socket"
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	// Archetype: SkeletalMeshComponent'UTGame.Default__UTWeaponAttachment.SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0"
		// Reference: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment.SkeletalMeshComponent0.MeshSequenceA'
		// Archetype: UTAnimNodeSequence'UTGame.Default__UTWeaponAttachment.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		ReplacementPrimitive=none
	end object
	Mesh=SkeletalMeshComponent0
}