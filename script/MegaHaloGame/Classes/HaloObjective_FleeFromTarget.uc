class HaloObjective_FleeFromTarget extends HaloObjective
	config(HUDMarkers);

var ObjectiveMarkerData FleeTarget;
var float InnerRadius;
var float OuterRadius;
var float GracePeriod;
var float TimeInRadii;
var const localized string FleeWarning;
var const localized string TooCloseToTarget;

function TickMarkers()
{
	//return;	
}

function TickStatus(float DeltaTime)
{
	local bool bIsInInnerRadius, bIsInOuterRadius;
	local float DistSq;
	local Actor TargetToChase;
	local HaloPlayerPawnController PC;
	local array<HaloPlayerPawnController> TooCloseControllers;
	local GFxHaloHUD HUD;

	TargetToChase = FleeTarget.Actor;
	// End:0x2F4
	if(TargetToChase != none)
	{
		bIsInInnerRadius = false;
		bIsInOuterRadius = false;
		// End:0x18C
		foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'MegaHaloGame.HaloPlayerPawnController', PC)
		{
			// End:0x18B
			if((PC != none) && PC.Pawn != none)
			{
				DistSq = VSizeSq(TargetToChase.Location - PC.Pawn.Location);
				// End:0x166
				if(DistSq <= Square(OuterRadius))
				{
					bIsInOuterRadius = true;
					TooCloseControllers.AddItem(PC);
				}
				// End:0x18B
				if(DistSq <= Square(InnerRadius))
				{
					bIsInInnerRadius = true;
				}
			}			
		}		
		// End:0x19D
		if(bIsInInnerRadius == true)
		{
		}
		// End:0x1D2
		if(bIsInOuterRadius == false)
		{
			// End:0x1C0
			if(TimeInRadii > 0.0000000)
			{
			}
			TimeInRadii = 0.0000000;			
		}
		else
		{
			// End:0x2BD
			if(TimeInRadii == 0.0000000)
			{
				// End:0x2BC
				foreach TooCloseControllers(PC)
				{
					// End:0x2BB
					if(PC != none)
					{
						HUD = GFxHaloHUD(PC.myHUD);
						// End:0x2BB
						if(HUD != none)
						{
							// End:0x2BB
							if(HUD.HudMovie != none)
							{
								HUD.HudMovie.ShowGameMessage(FleeWarning, TooCloseToTarget, 3.0000000);
							}
						}
					}					
				}				
			}
			TimeInRadii += DeltaTime;
			// End:0x2F4
			if(TimeInRadii > GracePeriod)
			{
				Fail();
				return;
			}
		}
	}
	UpdateCompassWaypoint();
	//return;	
}

function Actor GetNavigationPoint()
{
	return FleeTarget.Actor;
	//return ReturnValue;	
}

function CreateObjectiveMarkers()
{
	ClearObjectiveMarkers();
	CreateObjectiveMarker(FleeTarget);
	//return;	
}

defaultproperties
{
	FleeTarget=(Actor=none,Marker=EObjectiveMarker.OMN_Flee,bDraw=true,bDrawTagSymbol=false,bShowHealth=true,bShowDistance=true,bClampToScreen=true)
	InnerRadius=100.0000000
	OuterRadius=500.0000000
	GracePeriod=3.0000000
	FleeWarning="WARNING!"
	TooCloseToTarget="Too close to target"
	bUseNavigation=false
	IconFrame="flee"
}