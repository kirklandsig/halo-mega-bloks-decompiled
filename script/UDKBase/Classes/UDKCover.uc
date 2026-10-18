class UDKCover extends KAsset
	native;

var CoverLink FirstCoverLink;

// Export UUDKCover::execAddCoverLink(FFrame&, void* const)
native function AddCoverLink(CoverLink Link);

// Export UUDKCover::execRemoveCoverLink(FFrame&, void* const)
native function RemoveCoverLink(CoverLink Link);

// Export UUDKCover::execKillCoverLinks(FFrame&, void* const)
native function KillCoverLinks();

// Export UUDKCover::execGetPawnViewLocation(FFrame&, void* const)
native simulated event Vector GetPawnViewLocation();

defaultproperties
{
	// Reference: SkeletalMeshComponent'UDKBase.Default__UDKCover.KAssetSkelMeshComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'KAssetSkelMeshComponent'
	// Archetype: SkeletalMeshComponent'Engine.Default__KAsset.KAssetSkelMeshComponent'
	begin object name="KAssetSkelMeshComponent"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'UDKBase.Default__UDKCover.MyLightEnvironment'
	end object
	SkeletalMeshComponent=KAssetSkelMeshComponent
	// Reference: DynamicLightEnvironmentComponent'UDKBase.Default__UDKCover.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'Engine.Default__KAsset.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	Components[0]=MyLightEnvironment
	Components[1]=KAssetSkelMeshComponent
	CollisionComponent=KAssetSkelMeshComponent
}