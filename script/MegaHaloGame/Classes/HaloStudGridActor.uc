class HaloStudGridActor extends DynamicSMActor;

var export editinline HaloStudGridComponent StudComponent;
var export editinline HaloBuildIndicatorComponent BuildIndicator;
var HaloStudGridActionArea ActionArea;
var const localized string StudGridInteractMessage;
var Pawn PotentialActioningPawn;
var bool PotentialActioningPawnIsTouching;
var float GlintVisualPct;
var float GlintUpdateStepPct;
var float GlintUpdateInterval;
var name GlintIntensityParamName;

simulated function PostBeginPlay()
{
	local int I;
	local float highlightUpdateIntervalSecs;

	super.PostBeginPlay();
	// End:0x87
	if(StaticMeshComponent != none)
	{
		I = 0;
		J0x24:

		// End:0x87 [Loop If]
		if(I < StaticMeshComponent.GetNumElements())
		{
			StaticMeshComponent.CreateAndSetMaterialInstanceConstant(I);
			I++;
			// [Loop Continue]
			goto J0x24;
		}
	}
	TurnOffBuildIndicator();
	RampDownGlintVisuals();
	// End:0x1C0
	if(StudComponent != none)
	{
		ActionArea = Spawn(Class'MegaHaloGame.HaloStudGridActionArea', self,, Location, Rotation,, true);
		// End:0x19A
		if(ActionArea != none)
		{
			ActionArea.AssociatedStudGrid = self;
			ActionArea.TouchCylinder.SetCylinderSize(StudComponent.GetApproxRadius() + 400.0000000, ActionArea.TouchCylinder.CollisionHeight);
		}
		highlightUpdateIntervalSecs = 1.0000000;
		SetTimer(highlightUpdateIntervalSecs, true, 'UpdateSelfHighlighting');
	}
	BuildIndicator = new (self) Class'MegaHaloGame.HaloBuildIndicatorComponent';
	BuildIndicator.IconTexture = Texture2D'BuildPadIndicator.Textures.BuildPadIcon_TargetDesignator';
	AttachComponent(BuildIndicator);
	//return;	
}

simulated function SetActionableState(Pawn actioningPawn, bool canAction)
{
	local Pawn OldPawn;

	OldPawn = PotentialActioningPawn;
	// End:0x45
	if(PotentialActioningPawn == none)
	{
		// End:0x42
		if(canAction)
		{
			PotentialActioningPawn = actioningPawn;
		}		
	}
	else
	{
		// End:0x76
		if(actioningPawn == PotentialActioningPawn)
		{
			// End:0x76
			if(canAction!)
			{
				PotentialActioningPawn = none;
			}
		}
	}
	// End:0xC8
	if(OldPawn != PotentialActioningPawn)
	{
		PotentialActioningPawnIsTouching = false;
		// End:0xC8
		if(PotentialActioningPawn == none)
		{
			BuildIndicator.SetVisible(false);
		}
	}
	//return;	
}

simulated function TurnOnBuildIndicator()
{
	// End:0x2F
	if(BuildIndicator != none)
	{
		BuildIndicator.SetVisible(true);
	}
	//return;	
}

simulated function TurnOffBuildIndicator()
{
	// End:0x2F
	if(BuildIndicator != none)
	{
		BuildIndicator.SetVisible(false);
	}
	//return;	
}

simulated function bool CanBeActionedNow()
{
	return ((PotentialActioningPawn != none) && PotentialActioningPawnIsTouching == false) && StudComponent.HasOpenPegs();
	//return ReturnValue;	
}

event RampUpGlintVisuals()
{
	local int I;
	local MaterialInstanceConstant alterableMaterial;

	GlintVisualPct = FClamp(GlintVisualPct + GlintUpdateStepPct, 0.0000000, 1.0000000);
	// End:0xFA
	if(StaticMeshComponent != none)
	{
		I = 0;
		J0x44:

		// End:0xFA [Loop If]
		if(I < StaticMeshComponent.GetNumElements())
		{
			alterableMaterial = MaterialInstanceConstant(StaticMeshComponent.GetMaterial(I));
			// End:0xEC
			if(alterableMaterial != none)
			{
				alterableMaterial.SetScalarParameterValue(GlintIntensityParamName, GlintVisualPct);
			}
			I++;
			// [Loop Continue]
			goto J0x44;
		}
	}
	// End:0x124
	if(GlintVisualPct < 1.0000000)
	{
		SetTimer(GlintUpdateInterval, false, 'RampUpGlintVisuals');
	}
	//return;	
}

event RampDownGlintVisuals()
{
	local int I;
	local MaterialInstanceConstant alterableMaterial;

	GlintVisualPct = FClamp(GlintVisualPct - GlintUpdateStepPct, 0.0000000, 1.0000000);
	// End:0xFA
	if(StaticMeshComponent != none)
	{
		I = 0;
		J0x44:

		// End:0xFA [Loop If]
		if(I < StaticMeshComponent.GetNumElements())
		{
			alterableMaterial = MaterialInstanceConstant(StaticMeshComponent.GetMaterial(I));
			// End:0xEC
			if(alterableMaterial != none)
			{
				alterableMaterial.SetScalarParameterValue(GlintIntensityParamName, GlintVisualPct);
			}
			I++;
			// [Loop Continue]
			goto J0x44;
		}
	}
	// End:0x124
	if(GlintVisualPct > 0.0000000)
	{
		SetTimer(GlintUpdateInterval, false, 'RampDownGlintVisuals');
	}
	//return;	
}

event UpdateSelfHighlighting()
{
	local PlayerController P;
	local float highlightRangeSq;
	local bool foundANearbyPlayer;

	highlightRangeSq = 2000.0000000 * 2000.0000000;
	foundANearbyPlayer = false;
	// End:0xF9
	if((StudComponent != none) && StudComponent.HasOpenPegs())
	{
		// End:0xF8
		foreach LocalPlayerControllers(Class'Engine.PlayerController', P)
		{
			// End:0xF7
			if((P.Pawn != none) && VSizeSq(Location - P.Pawn.Location) < highlightRangeSq)
			{
				foundANearbyPlayer = true;
				// End:0xF8
				break;
			}			
		}		
	}
	// End:0x150
	if(foundANearbyPlayer && GlintVisualPct < 1.0000000)
	{
		ClearTimer('RampUpGlintVisuals');
		ClearTimer('RampDownGlintVisuals');
		RampUpGlintVisuals();		
	}
	else
	{
		// End:0x1A6
		if(foundANearbyPlayer! && GlintVisualPct > 0.0000000)
		{
			ClearTimer('RampUpGlintVisuals');
			ClearTimer('RampDownGlintVisuals');
			RampDownGlintVisuals();
		}
	}
	//return;	
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	// End:0x23
	if(Other == PotentialActioningPawn)
	{
		PotentialActioningPawnIsTouching = true;
	}
	//return;	
}

simulated event UnTouch(Actor Other)
{
	// End:0x23
	if(Other == PotentialActioningPawn)
	{
		PotentialActioningPawnIsTouching = false;
	}
	//return;	
}

simulated function NotifyOfPluggedInActorChange(Actor NewActor, optional Actor oldActor)
{
	// End:0x4C
	if(NewActor != none)
	{
		ClearTimer('RampUpGlintVisuals');
		ClearTimer('RampDownGlintVisuals');
		RampDownGlintVisuals();
		TurnOffBuildIndicator();
	}
	//return;	
}

defaultproperties
{
	// Reference: HaloStudGridComponent'MegaHaloGame.Default__HaloStudGridActor.StudComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'StudComponent0'
	begin object name="StudComponent0" class=MegaHaloGame.HaloStudGridComponent
	end object
	StudComponent=StudComponent0
	StudGridInteractMessage="Press [MainHUD.InlineInputIcons.inputIcon_y] To Build"
	GlintUpdateStepPct=0.1000000
	GlintUpdateInterval=0.1000000
	GlintIntensityParamName="GlintIntensity"
	// Reference: StaticMeshComponent'MegaHaloGame.Default__HaloStudGridActor.StaticMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'StaticMeshComponent0'
	// Archetype: StaticMeshComponent'Engine.Default__DynamicSMActor.StaticMeshComponent0'
	begin object name="StaticMeshComponent0"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloStudGridActor.MyLightEnvironment'
	end object
	StaticMeshComponent=StaticMeshComponent0
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloStudGridActor.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'Engine.Default__DynamicSMActor.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	GwNavObstacleComponentClassPath=""
	Components[0]=MyLightEnvironment
	Components[1]=StaticMeshComponent0
	Components[2]=StudComponent0
	bCollideActors=true
	CollisionComponent=StaticMeshComponent0
}