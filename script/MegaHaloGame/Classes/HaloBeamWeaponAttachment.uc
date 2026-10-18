class HaloBeamWeaponAttachment extends UTBeamWeaponAttachment;

simulated function ThirdPersonFireEffects(Vector HitLocation)
{
	LastRenderTime = Mesh.LastRenderTime;
	super(UTWeaponAttachment).ThirdPersonFireEffects(HitLocation);
	//return;	
}

defaultproperties
{
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloBeamWeaponAttachment.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	// Archetype: SkeletalMeshComponent'UTGame.Default__UTBeamWeaponAttachment.SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0"
		// Reference: UTAnimNodeSequence'MegaHaloGame.Default__HaloBeamWeaponAttachment.SkeletalMeshComponent0.MeshSequenceA'
		// Archetype: UTAnimNodeSequence'UTGame.Default__UTBeamWeaponAttachment.SkeletalMeshComponent0.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		ReplacementPrimitive=none
	end object
	Mesh=SkeletalMeshComponent0
}