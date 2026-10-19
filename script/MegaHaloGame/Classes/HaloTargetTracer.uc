class HaloTargetTracer extends Actor
	notplaceable;

var archetype const Actor GridSpotlightArchetypeRef;
var Light GridSpotlight;
var Vector GridSpotlightLocationOffset;
var Vector LastKnownAimOrigin;
var Vector LastKnownAimTarget;
var bool LastKnownTargetWasValid;
var bool bShouldRecreatePreviewActor;
var bool bShouldSelfDestruct;
var bool bShouldBeVisible;
var float SpotlightDimmingStepInterval;
var float SpotlightDimmingStepAmt;
var Color SpotlightValidTargetColor;
var Color SpotlightInvalidTargetColor;
var HaloDeployPreviewActor DeploymentPreviewActor;
var StaticMesh PreviewMesh;
var string PreviewMeshPath;

simulated function SetToSelfDestruct(bool bShouldInstantlyDestroyMesh)
{
	bShouldSelfDestruct = true;
	// End:0x6D
	if(DeploymentPreviewActor != none)
	{
		// End:0x4E
		if(bShouldInstantlyDestroyMesh)
		{
			DeploymentPreviewActor.Destroy();
			DeploymentPreviewActor = none;			
		}
		else
		{
			DeploymentPreviewActor.RampDownOpacity();
		}
	}
	//return;	
}

simulated function Destroyed()
{
	// End:0x32
	if(DeploymentPreviewActor != none)
	{
		DeploymentPreviewActor.Destroy();
		DeploymentPreviewActor = none;
	}
	// End:0x64
	if(GridSpotlight != none)
	{
		GridSpotlight.Destroy();
		GridSpotlight = none;
	}
	super.Destroyed();
	//return;	
}

simulated function TurnOn()
{
	self.GotoState('FadingOut');
	//return;	
}

simulated function TurnOff()
{
	self.GotoState('FadingOut');
	// End:0x49
	if(DeploymentPreviewActor != none)
	{
		DeploymentPreviewActor.RampDownOpacity();
	}
	//return;	
}

simulated function SetVisibility(bool Visible)
{
	bShouldBeVisible = Visible;
	//return;	
}

simulated function SetPreviewMeshPath(string Path)
{
	// End:0x66
	if(PreviewMeshPath != Path)
	{
		PreviewMeshPath = Path;
		PreviewMesh = StaticMesh(DynamicLoadObject(PreviewMeshPath, Class'Engine.StaticMesh'));
		bShouldRecreatePreviewActor = true;
	}
	//return;	
}

simulated function ProcessAimChange(Vector aimOrigin, Vector AimTarget, Rotator forcedPreviewOrient, bool hasValidTargetLocation, bool shouldForceOrientation, LinearColor placementColor)
{
	local Vector AimDir;
	local Rotator flatXYaimOrient;

	AimDir = AimTarget - aimOrigin;
	AimDir.Z = 0.0000000;
	flatXYaimOrient = Rotator(AimDir);
	// End:0x116
	if(GridSpotlight == none)
	{
		GridSpotlight = Light(Spawn(GridSpotlightArchetypeRef.Class,,, AimTarget + GridSpotlightLocationOffset, Rotator(vect(0.0000000, 0.0000000, -1.0000000)), GridSpotlightArchetypeRef));
		// End:0x113
		if(!bShouldBeVisible)
		{
			GridSpotlight.LightComponent.SetEnabled(false);
		}		
	}
	else
	{
		GridSpotlight.SetLocation(AimTarget + GridSpotlightLocationOffset);
		GridSpotlight.LightComponent.SetLightProperties(20.0000000);
		GridSpotlight.LightComponent.SetLightProperties(,, ((hasValidTargetLocation) ? SpotlightValidTargetColor : SpotlightInvalidTargetColor));
		// End:0x255
		if((GridSpotlight.LightComponent.bEnabled == false) && bShouldBeVisible)
		{
			GridSpotlight.LightComponent.SetEnabled(true);			
		}
		else
		{
			// End:0x2D5
			if((GridSpotlight.LightComponent.bEnabled == true) && !bShouldBeVisible)
			{
				GridSpotlight.LightComponent.SetEnabled(false);
			}
		}
	}
	// End:0x355
	if((DeploymentPreviewActor == none) || bShouldRecreatePreviewActor)
	{
		// End:0x31A
		if(DeploymentPreviewActor != none)
		{
			DeploymentPreviewActor.Destroy();
		}
		DeploymentPreviewActor = Spawn(Class'MegaHaloGame.HaloDeployPreviewActor', self,, AimTarget);
		bShouldRecreatePreviewActor = false;		
	}
	else
	{
		// End:0x3B2
		if(VSizeSq(DeploymentPreviewActor.Location - AimTarget) > (2.0000000 * 2.0000000))
		{
			DeploymentPreviewActor.SetLocation(AimTarget);
		}
		// End:0x3E3
		if(shouldForceOrientation)
		{
			DeploymentPreviewActor.SetRotation(forcedPreviewOrient);			
		}
		else
		{
			DeploymentPreviewActor.SetRotation(flatXYaimOrient);
		}
	}
	// End:0x516
	if(PreviewMesh != none)
	{
		DeploymentPreviewActor.SetStaticColorizedMesh(PreviewMesh, placementColor);
		// End:0x497
		if(DeploymentPreviewActor.IsTransparent() && bShouldBeVisible)
		{
			DeploymentPreviewActor.RampUpOpacity();			
		}
		else
		{
			// End:0x4EB
			if(!DeploymentPreviewActor.IsTransparent() && !bShouldBeVisible)
			{
				DeploymentPreviewActor.RampDownOpacity();
			}
		}
		DeploymentPreviewActor.Colorize(placementColor);		
	}
	else
	{
		// End:0x559
		if(!DeploymentPreviewActor.IsTransparent())
		{
			DeploymentPreviewActor.RampDownOpacity();
		}
	}
	LastKnownAimOrigin = aimOrigin;
	LastKnownAimTarget = AimTarget;
	LastKnownTargetWasValid = hasValidTargetLocation;
	//return;	
}

auto state Off
{
	event BeginState(name PreviousState)
	{
		// End:0x8F
		if(GridSpotlight != none)
		{
			GridSpotlight.LightComponent.SetEnabled(false);
			GridSpotlight.LightComponent.SetLightProperties(,, SpotlightInvalidTargetColor);
			LastKnownTargetWasValid = false;
		}
		// End:0xBE
		if(DeploymentPreviewActor != none)
		{
			DeploymentPreviewActor.SetHidden(true);
		}
		// End:0xE7
		if(bShouldSelfDestruct)
		{
			bShouldSelfDestruct = false;
			self.Destroy();
		}
		//return;		
	}
	stop;	
}

state FadingOut
{Begin:

	// End:0x20
	if(GridSpotlight == none)
	{
		GotoState('Off');		
	}
	else
	{
		goto 'SlowDimLoop';
	}
	stop;
SlowDimLoop:


	// End:0x103
	if((GridSpotlight != none) && GridSpotlight.LightComponent.Brightness > 0.0000000)
	{
		GridSpotlight.LightComponent.SetLightProperties(GridSpotlight.LightComponent.Brightness - SpotlightDimmingStepAmt);
		Sleep(SpotlightDimmingStepInterval);
		goto 'SlowDimLoop';
	}
	GotoState('Off');
	stop;
	stop;		
}

defaultproperties
{
	GridSpotlightArchetypeRef=SpotLightMovable'Weap_TargetDesignator.GridSpotlight'
	GridSpotlightLocationOffset=(X=400.0000000,Y=0.0000000,Z=0.0000000)
	bShouldBeVisible=true
	SpotlightDimmingStepInterval=0.1000000
	SpotlightDimmingStepAmt=1.0000000
	SpotlightValidTargetColor=(R=255,G=64,B=0,A=64)
	SpotlightInvalidTargetColor=(R=64,G=255,B=0,A=64)
	CollisionType=ECollisionType.COLLIDE_CustomDefault
}