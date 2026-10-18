class HaloObjective_DeployItem extends HaloObjective
	config(HUDMarkers);

struct DeployableObjective
{
	var ObjectiveMarkerData DeployMarker;
	var HaloDeploymentMonitor HDM;
	var bool bHasBeenDeployed;

	structdefaultproperties
	{
		DeployMarker=(Actor=none,Marker=EObjectiveMarker.OMN_None,bDraw=true,bDrawTagSymbol=false,bShowHealth=false,bShowDistance=false,bClampToScreen=true)
		HDM=none
		bHasBeenDeployed=false
	}
};

var array<DeployableObjective> DeployableObjectives;
var int MinDeploys;
var int ClosestTargetIndex;
var float RepathTimer;
var float RepathDelay;

function TickMarkers()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0xF6 [Loop If]
	if(I < DeployableObjectives.Length)
	{
		// End:0xE8
		if(DeployableObjectives[I].HDM.bHasBeenDeployed)
		{
			// End:0xE8
			if(DeployableObjectives[I].bHasBeenDeployed == false)
			{
				RemoveObjectiveMarker(DeployableObjectives[I].DeployMarker);
				DeployableObjectives[I].bHasBeenDeployed = true;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function TickStatus(float DeltaTime)
{
	local int I, DeployCount;
	local bool bIsComplete;

	DeployCount = 0;
	bIsComplete = true;
	I = 0;
	J0x22:

	// End:0xCB [Loop If]
	if(I < DeployableObjectives.Length)
	{
		// End:0xB1
		if(DeployableObjectives[I].HDM.bHasBeenDeployed)
		{
			// End:0xA3
			if(ClosestTargetIndex == I)
			{
				RepathTimer = RepathDelay;
			}
			DeployCount++;			
		}
		else
		{
			bIsComplete = false;
		}
		I++;
		// [Loop Continue]
		goto J0x22;
	}
	// End:0xEE
	if(DeployCount >= MinDeploys)
	{
		bIsComplete = true;
	}
	// End:0x107
	if(bIsComplete)
	{
		Complete();
		return;
	}
	RepathTimer += DeltaTime;
	// End:0x17F
	if(RepathTimer >= RepathDelay)
	{
		I = ClosestTargetIndex;
		TickNavigationPoint();
		RepathTimer = 0.0000000;
		// End:0x17F
		if(I != ClosestTargetIndex)
		{
			UpdateCompassWaypoint();
		}
	}
	//return;	
}

function TickNavigationPoint()
{
	local int I;
	local float DistSq, shortestDistSq;
	local Actor Target;
	local Vector PlayerLocation;
	local array<Vector> PlayerLocations;

	ClosestTargetIndex = -1;
	GetPlayerLocations(PlayerLocations);
	I = 0;
	J0x2D:

	// End:0x1D0 [Loop If]
	if(I < DeployableObjectives.Length)
	{
		// End:0x1C2
		if(DeployableObjectives[I].HDM.bHasBeenDeployed == false)
		{
			Target = DeployableObjectives[I].DeployMarker.Actor;
			// End:0x1C2
			if(Target != none)
			{
				// End:0x1C1
				foreach PlayerLocations(PlayerLocation)
				{
					// End:0x14E
					if(ClosestTargetIndex == -1)
					{
						ClosestTargetIndex = I;
						shortestDistSq = VSizeSq(Target.Location - PlayerLocation);						
					}
					else
					{
						DistSq = VSizeSq(Target.Location - PlayerLocation);
						// End:0x1C0
						if(DistSq < shortestDistSq)
						{
							ClosestTargetIndex = I;
							shortestDistSq = DistSq;
						}
					}					
				}				
			}
		}
		I++;
		// [Loop Continue]
		goto J0x2D;
	}
	//return;	
}

function GetPlayerLocations(out array<Vector> PlayerLocations)
{
	local HaloGameDefault HGD;
	local HaloPlayerPawnController HPPC;

	HGD = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x10E
	if(HGD != none)
	{
		// End:0x10D
		foreach HGD.TheMainPlayerGroup.PlayerControllers(HPPC)
		{
			// End:0x10C
			if((HPPC != none) && HPPC.Pawn != none)
			{
				PlayerLocations.AddItem(HPPC.Pawn.Location);
			}			
		}		
	}
	//return;	
}

function Actor GetNavigationPoint()
{
	// End:0x63
	if((ClosestTargetIndex >= 0) && ClosestTargetIndex < DeployableObjectives.Length)
	{
		return DeployableObjectives[ClosestTargetIndex].DeployMarker.Actor;
	}
	return none;
	//return ReturnValue;	
}

function CreateObjectiveMarkers()
{
	local int I;

	ClearObjectiveMarkers();
	I = 0;
	J0x15:

	// End:0x6B [Loop If]
	if(I < DeployableObjectives.Length)
	{
		CreateObjectiveMarker(DeployableObjectives[I].DeployMarker);
		I++;
		// [Loop Continue]
		goto J0x15;
	}
	//return;	
}

defaultproperties
{
	ClosestTargetIndex=-1
	RepathDelay=5.0000000
	IconFrame="use"
}