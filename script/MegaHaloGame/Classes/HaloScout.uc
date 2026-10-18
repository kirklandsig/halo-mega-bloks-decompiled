class HaloScout extends UDKScout
	transient
	config(Game);

defaultproperties
{
	PrototypePawnClass=Class'MegaHaloGame.HaloPawn'
	SizePersonFindName="JumpPads"
	PathSizes[0]=(Desc="Human",Radius=50.0000000,Height=200.0000000,CrouchHeight=0.0000000,PathColor=0)
	PathSizes[1]=(Desc="JumpPads",Radius=50.0000000,Height=500.0000000,CrouchHeight=0.0000000,PathColor=0)
	EdgePathColors=/* ERROR: System.ArgumentOutOfRangeException */
	NavMeshGen_MaxPolyHeight=200.0000000
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloScout.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'UDKBase.Default__UDKScout.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	CollisionComponent=CollisionCylinder
}