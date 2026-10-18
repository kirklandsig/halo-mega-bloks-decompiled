class HaloDeployPreviewActor extends DynamicSMActor;

var bool MeshIsGhosted;
var MaterialInstance GhostedMaterialTemplate;
var MaterialInstanceConstant ghostedMaterial;
var LinearColor LastUsedColor;
var float LastSetOpacity;
var float OpacityStepTime;
var float OpacityStepPct;

simulated function bool IsTransparent()
{
	return LastSetOpacity == 0.0000000;
	//return ReturnValue;	
}

simulated function Colorize(LinearColor newColor)
{
	// End:0x62
	if(newColor != LastUsedColor)
	{
		ghostedMaterial.SetVectorParameterValue('GlowColor', newColor);
		LastUsedColor = newColor;
	}
	//return;	
}

simulated function RampDownOpacity()
{
	ClearTimer('RampUpOpacity');
	LastSetOpacity = FClamp(LastSetOpacity - OpacityStepPct, 0.0000000, 1.0000000);
	// End:0x7E
	if(ghostedMaterial != none)
	{
		ghostedMaterial.SetScalarParameterValue('FadeByTime', LastSetOpacity);
	}
	// End:0xA8
	if(LastSetOpacity > 0.0000000)
	{
		SetTimer(OpacityStepTime, false, 'RampDownOpacity');
	}
	//return;	
}

simulated function RampUpOpacity()
{
	ClearTimer('RampDownOpacity');
	LastSetOpacity = FClamp(LastSetOpacity + OpacityStepPct, 0.0000000, 1.0000000);
	// End:0x7E
	if(ghostedMaterial != none)
	{
		ghostedMaterial.SetScalarParameterValue('FadeByTime', LastSetOpacity);
	}
	// End:0xA8
	if(LastSetOpacity < 1.0000000)
	{
		SetTimer(OpacityStepTime, false, 'RampUpOpacity');
	}
	//return;	
}

simulated function SetStaticColorizedMesh(StaticMesh desiredMesh, LinearColor newColor)
{
	local int I;

	// End:0x171
	if(StaticMeshComponent.StaticMesh != desiredMesh)
	{
		StaticMeshComponent.SetStaticMesh(desiredMesh);
		ghostedMaterial = StaticMeshComponent.CreateAndSetMaterialInstanceConstant(0);
		I = 0;
		J0x8A:

		// End:0xF6 [Loop If]
		if(I < StaticMeshComponent.GetNumElements())
		{
			StaticMeshComponent.SetMaterial(I, ghostedMaterial);
			I++;
			// [Loop Continue]
			goto J0x8A;
		}
		LastUsedColor = MakeLinearColor(0.0000000, 0.0000000, 0.0000000, 0.0000000);
		Colorize(newColor);
		LastSetOpacity = 0.0000000;
		ghostedMaterial.SetScalarParameterValue('FadeByTime', LastSetOpacity);
	}
	//return;	
}

defaultproperties
{
	LastSetOpacity=-1.0000000
	OpacityStepTime=0.0500000
	OpacityStepPct=0.0650000
	// Reference: StaticMeshComponent'MegaHaloGame.Default__HaloDeployPreviewActor.StaticMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'StaticMeshComponent0'
	// Archetype: StaticMeshComponent'Engine.Default__DynamicSMActor.StaticMeshComponent0'
	begin object name="StaticMeshComponent0"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloDeployPreviewActor.MyLightEnvironment'
		CastShadow=false
		bAcceptsLights=false
		bAcceptsDynamicLights=false
	end object
	StaticMeshComponent=StaticMeshComponent0
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloDeployPreviewActor.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'Engine.Default__DynamicSMActor.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	Components[0]=MyLightEnvironment
	Components[1]=StaticMeshComponent0
	CollisionComponent=StaticMeshComponent0
}