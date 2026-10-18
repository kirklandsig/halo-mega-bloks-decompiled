class HaloBuildIndicatorComponent extends ActorComponent;

var export editinline ParticleSystemComponent StartParticleSystem;
var export editinline ParticleSystemComponent OnParticleSystem;
var export editinline ParticleSystemComponent StopParticleSystem;
var MaterialInterface IconMaterial;
var MaterialInterface DistortedIconMaterial;
var Texture2D IconTexture;
var bool bShowing;
var bool bNeedsInit;

function SetVisible(bool bShow)
{
	((bShow) ? show() : Hide());
	//return;	
}

function InitSystem()
{
	CreateAndSetParticleSystemMaterials();
	AttachParticleSystems();
	bNeedsInit = false;
	//return;	
}

private final function bool show()
{
	// End:0x7B
	if(bShowing == false)
	{
		// End:0x27
		if(bNeedsInit)
		{
			InitSystem();
		}
		StartParticleSystem.ActivateSystem();
		Owner.SetTimer(0.2500000, false, 'CompleteStart', self);
		bShowing = true;
	}
	return bShowing;
	//return ReturnValue;	
}

private final function bool Hide()
{
	// End:0xA9
	if(bShowing)
	{
		OnParticleSystem.DeactivateSystem();
		StopParticleSystem.ActivateSystem();
		Owner.ClearTimer('CompleteStart', self);
		Owner.SetTimer(0.2500000, false, 'CompleteStop', self);
		bShowing = false;
	}
	return bShowing;
	//return ReturnValue;	
}

private final function CreateAndSetParticleSystemMaterials()
{
	local MaterialInstanceConstant MIC;

	MIC = new Class'Engine.MaterialInstanceConstant';
	// End:0xB1
	if(MIC != none)
	{
		MIC.SetParent(IconMaterial);
		MIC.SetTextureParameterValue('CLR_Texture', IconTexture);
		OnParticleSystem.SetMaterialParameter('IndicatorMap', MIC);
	}
	MIC = new Class'Engine.MaterialInstanceConstant';
	// End:0x193
	if(MIC != none)
	{
		MIC.SetParent(DistortedIconMaterial);
		MIC.SetTextureParameterValue('CLR_Texture', IconTexture);
		StartParticleSystem.SetMaterialParameter('IndicatorMap', MIC);
		StopParticleSystem.SetMaterialParameter('IndicatorMap', MIC);
	}
	//return;	
}

private final function AttachParticleSystems()
{
	Owner.AttachComponent(StartParticleSystem);
	Owner.AttachComponent(OnParticleSystem);
	Owner.AttachComponent(StopParticleSystem);
	//return;	
}

private final function CompleteStart()
{
	StartParticleSystem.DeactivateSystem();
	OnParticleSystem.ActivateSystem();
	//return;	
}

private final function CompleteStop()
{
	StopParticleSystem.DeactivateSystem();
	//return;	
}

defaultproperties
{
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloBuildIndicatorComponent.ParticleSystemComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent0'
	begin object name="ParticleSystemComponent0" class=Engine.ParticleSystemComponent
		Template=ParticleSystem'FX_BuildPadIndicator.Effects.BuildPadIndicator_START'
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=7000.0000000
		CachedMaxDrawDistance=7000.0000000
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	StartParticleSystem=ParticleSystemComponent0
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloBuildIndicatorComponent.ParticleSystemComponent1'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent1'
	begin object name="ParticleSystemComponent1" class=Engine.ParticleSystemComponent
		Template=ParticleSystem'FX_BuildPadIndicator.Effects.BuildPadIndicator'
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=7000.0000000
		CachedMaxDrawDistance=7000.0000000
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	OnParticleSystem=ParticleSystemComponent1
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloBuildIndicatorComponent.ParticleSystemComponent2'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent2'
	begin object name="ParticleSystemComponent2" class=Engine.ParticleSystemComponent
		Template=ParticleSystem'FX_BuildPadIndicator.Effects.BuildPadIndicator_OFF'
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=7000.0000000
		CachedMaxDrawDistance=7000.0000000
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	StopParticleSystem=ParticleSystemComponent2
	IconMaterial=MaterialInstanceConstant'BuildPadIndicator.Materials.MIC.BuildPadIndicator_Icon_MIC'
	DistortedIconMaterial=Material'BuildPadIndicator.Materials.Master.BuildPadIndicator_Icon_DIST'
	IconTexture=Texture2D'BuildPadIndicator.Textures.BuildPadIcon_BlokConstruction'
	bNeedsInit=true
}