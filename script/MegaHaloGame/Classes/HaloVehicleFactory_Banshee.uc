class HaloVehicleFactory_Banshee extends UTVehicleFactory;

defaultproperties
{
	VehicleClassPath="MegaHaloGameContent.HaloVehicle_Banshee_Content"
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloVehicleFactory_Banshee.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'UTGame.Default__UTVehicleFactory.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=120.0000000
		CollisionRadius=200.0000000
		ReplacementPrimitive=none
		Translation=(X=-40.0000000,Y=0.0000000,Z=0.0000000)
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=none
	Components[1]=CollisionCylinder
	Components[2]=none
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloVehicleFactory_Banshee.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'UTGame.Default__UTVehicleFactory.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	Components[3]=MyLightEnvironment
	Components[4]=none
	DrawScale=1.3000000
	CollisionComponent=CollisionCylinder
}