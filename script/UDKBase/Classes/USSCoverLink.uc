class USSCoverLink extends CoverLink
	config(Game);

defaultproperties
{
	StandHeight=88.0000000
	MidHeight=35.0000000
	StandingLeanOffset=(X=34.0000000,Y=60.0000000,Z=0.0000000)
	CrouchLeanOffset=(X=9.0000000,Y=35.0000000,Z=0.0000000)
	PopupOffset=(X=35.0000000,Y=0.0000000,Z=0.0000000)
	// Reference: CylinderComponent'UDKBase.Default__USSCoverLink.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__CoverLink.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=44.0000000
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=none
	Components[1]=none
	Components[2]=CollisionCylinder
	Components[3]=none
	CollisionComponent=CollisionCylinder
}