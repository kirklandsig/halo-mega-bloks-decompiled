class HaloDynamicSMActor_Spawnable extends DynamicSMActor_Spawnable;

event Attach(Actor Other)
{
	//return;	
}

event Detach(Actor Other)
{
	//return;	
}

defaultproperties
{
	// Reference: StaticMeshComponent'MegaHaloGame.Default__HaloDynamicSMActor_Spawnable.StaticMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'StaticMeshComponent0'
	// Archetype: StaticMeshComponent'Engine.Default__DynamicSMActor_Spawnable.StaticMeshComponent0'
	begin object name="StaticMeshComponent0"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloDynamicSMActor_Spawnable.MyLightEnvironment'
	end object
	StaticMeshComponent=StaticMeshComponent0
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloDynamicSMActor_Spawnable.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'Engine.Default__DynamicSMActor_Spawnable.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	Components[0]=MyLightEnvironment
	Components[1]=StaticMeshComponent0
	CollisionComponent=StaticMeshComponent0
}