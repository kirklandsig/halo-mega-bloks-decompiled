class HaloDroppedItemPickup extends UTDroppedItemPickup;

defaultproperties
{
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloDroppedItemPickup.DroppedPickupLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'DroppedPickupLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'UTGame.Default__UTDroppedItemPickup.DroppedPickupLightEnvironment'
	begin object name="DroppedPickupLightEnvironment"
	end object
	MyLightEnvironment=DroppedPickupLightEnvironment
	Components[0]=none
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloDroppedItemPickup.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'UTGame.Default__UTDroppedItemPickup.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	Components[1]=CollisionCylinder
	Components[2]=DroppedPickupLightEnvironment
	CollisionComponent=CollisionCylinder
}