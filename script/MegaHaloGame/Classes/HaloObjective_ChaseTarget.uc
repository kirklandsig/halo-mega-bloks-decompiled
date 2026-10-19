class HaloObjective_ChaseTarget extends HaloObjective
	config(HUDMarkers);

var ObjectiveMarkerData ChaseTarget;
var float InnerRadius;
var float OuterRadius;
var float GracePeriod;
var float TimeOutOfRadii;
var const localized string ChaseWarning;
var const localized string TooFarFromTarget;

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
	local array<HaloPlayerPawnController> TooFarControllers;
	local GFxHaloHUD HUD;

	TargetToChase = ChaseTarget.Actor;
	// End:0x2F7
	if(TargetToChase != none)
	{
		bIsInInnerRadius = false;
		bIsInOuterRadius = false;
		// End:0x18F
		foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'MegaHaloGame.HaloPlayerPawnController', PC)
		{
			// End:0x18E
			if((PC != none) && PC.Pawn != none)
			{
				DistSq = VSizeSq(TargetToChase.Location - PC.Pawn.Location);
				// End:0x153
				if(DistSq <= Square(OuterRadius))
				{
					bIsInOuterRadius = true;					
				}
				else
				{
					TooFarControllers.AddItem(PC);
				}
				// End:0x18E
				if(DistSq <= Square(InnerRadius))
				{
					bIsInInnerRadius = true;
				}
			}			
		}		
		// End:0x1A0
		if(bIsInInnerRadius == true)
		{
		}
		// End:0x1D5
		if(bIsInOuterRadius == true)
		{
			// End:0x1C3
			if(TimeOutOfRadii > 0.0000000)
			{
			}
			TimeOutOfRadii = 0.0000000;			
		}
		else
		{
			// End:0x2C0
			if(TimeOutOfRadii == 0.0000000)
			{
				// End:0x2BF
				foreach TooFarControllers(PC)
				{
					// End:0x2BE
					if(PC != none)
					{
						HUD = GFxHaloHUD(PC.myHUD);
						// End:0x2BE
						if(HUD != none)
						{
							// End:0x2BE
							if(HUD.HudMovie != none)
							{
								HUD.HudMovie.ShowGameMessage(ChaseWarning, TooFarFromTarget, 3.0000000);
							}
						}
					}					
				}				
			}
			TimeOutOfRadii += DeltaTime;
			// End:0x2F7
			if(TimeOutOfRadii > GracePeriod)
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
	return ChaseTarget.Actor;
	//return ReturnValue;	
}

function CreateObjectiveMarkers()
{
	ClearObjectiveMarkers();
	CreateObjectiveMarker(ChaseTarget);
	//return;	
}

defaultproperties
{
	ChaseTarget=(Actor=none,Marker=OMN_Chase,bDraw=true,bDrawTagSymbol=false,bShowHealth=true,bShowDistance=true,bClampToScreen=true)
	InnerRadius=100.0000000
	OuterRadius=500.0000000
	GracePeriod=3.0000000
	ChaseWarning="WARNING!"
	TooFarFromTarget="Too far from target"
	bUseNavigation=false
	IconFrame="chase"
}