class HaloVehicleFactory_Scorpion extends UTVehicleFactory;

defaultproperties
{
	VehicleClassPath="MegaHaloGameContent.HaloVehicle_Scorpion_Content"
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloVehicleFactory_Scorpion.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'UTGame.Default__UTVehicleFactory.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=80.0000000
		CollisionRadius=120.0000000
		ReplacementPrimitive=none
		Translation=(X=-10.0000000,Y=0.0000000,Z=-45.0000000)
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=none
	Components[1]=CollisionCylinder
	Components[2]=none
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloVehicleFactory_Scorpion.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'UTGame.Default__UTVehicleFactory.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	Components[3]=MyLightEnvironment
	Components[4]=none
	CollisionComponent=CollisionCylinder
}