class HVCCSkin extends HaloVCustomizationComponent
	placeable;

var MaterialInterface SkinMaterial;
var int MeshElementIndex;
var int DamageMeshElementIndex;
var LinearColor GeneralColor;

function OnAttach()
{
	// End:0xD0
	if((((ParentVehicle != none) && ParentVehicle.Mesh != none) && MeshElementIndex >= 0) && MeshElementIndex < ParentVehicle.Mesh.GetNumElements())
	{
		ParentVehicle.Mesh.SetMaterial(MeshElementIndex, SkinMaterial);
	}
	//return;	
}

function OnDetach()
{
	// End:0x73
	if((ParentVehicle != none) && ParentVehicle.Mesh != none)
	{
		ParentVehicle.Mesh.SetMaterial(MeshElementIndex, none);
	}
	//return;	
}

defaultproperties
{
	MeshElementIndex=-1
	GeneralColor=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000)
	HVCC_Type=HVCC_Skin
}