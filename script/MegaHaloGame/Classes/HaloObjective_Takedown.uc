class HaloObjective_Takedown extends HaloObjective
	config(HUDMarkers);

var array<ObjectiveMarkerData> TakedownTargets;
var int ClosestTargetIndex;
var float RepathTimer;
var float RepathDelay;

function Start()
{
	TickNavigationPoint();
	super.Start();
	//return;	
}

function TickMarkers()
{
	local int I;
	local bool bRemove;
	local Pawn P;
	local HaloDestructibleActor HDA;

	I = 0;
	J0x0B:

	// End:0x1B0 [Loop If]
	if(I < TakedownTargets.Length)
	{
		bRemove = false;
		P = Pawn(TakedownTargets[I].Actor);
		// End:0x101
		if(P == none)
		{
			HDA = HaloDestructibleActor(TakedownTargets[I].Actor);
			// End:0xCE
			if(HDA == none)
			{
				bRemove = true;				
			}
			else
			{
				// End:0xFE
				if(HDA.Health <= 0)
				{
					bRemove = true;
				}
			}			
		}
		else
		{
			// End:0x131
			if(P.Health <= 0)
			{
				bRemove = true;
			}
		}
		// End:0x1A2
		if(bRemove == true)
		{
			// End:0x16B
			if(ClosestTargetIndex == I)
			{
				RepathTimer = RepathDelay;
			}
			RemoveObjectiveMarker(TakedownTargets[I]);
			TakedownTargets.Remove(I--, 1);			
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function TickStatus(float DeltaTime)
{
	local int I;

	// End:0x1C
	if(TakedownTargets.Length == 0)
	{
		Complete();
		return;
	}
	RepathTimer += DeltaTime;
	// End:0x94
	if(RepathTimer >= RepathDelay)
	{
		I = ClosestTargetIndex;
		TickNavigationPoint();
		RepathTimer = 0.0000000;
		// End:0x94
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

	// End:0x17B [Loop If]
	if(I < TakedownTargets.Length)
	{
		Target = TakedownTargets[I].Actor;
		// End:0x16D
		if(Target != none)
		{
			// End:0x16C
			foreach PlayerLocations(PlayerLocation)
			{
				// End:0xF9
				if(ClosestTargetIndex == -1)
				{
					ClosestTargetIndex = I;
					shortestDistSq = VSizeSq(Target.Location - PlayerLocation);					
				}
				else
				{
					DistSq = VSizeSq(Target.Location - PlayerLocation);
					// End:0x16B
					if(DistSq < shortestDistSq)
					{
						ClosestTargetIndex = I;
						shortestDistSq = DistSq;
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
	// End:0x50
	if((ClosestTargetIndex >= 0) && ClosestTargetIndex < TakedownTargets.Length)
	{
		return TakedownTargets[ClosestTargetIndex].Actor;
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

	// End:0x58 [Loop If]
	if(I < TakedownTargets.Length)
	{
		CreateObjectiveMarker(TakedownTargets[I]);
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
	IconFrame="takedown"
}