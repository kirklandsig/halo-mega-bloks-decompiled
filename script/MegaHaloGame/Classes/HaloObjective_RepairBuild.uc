class HaloObjective_RepairBuild extends HaloObjective
	config(HUDMarkers);

struct RepairData
{
	var bool bHasBeenRepaired;
	var ObjectiveMarkerData RepairObject;

	structdefaultproperties
	{
		bHasBeenRepaired=false
		RepairObject=(Actor=none,Marker=OMN_None,bDraw=true,bDrawTagSymbol=false,bShowHealth=false,bShowDistance=false,bClampToScreen=true)
	}
};

var array<RepairData> Repairs;
var int MinRepairs;
var int ClosestTargetIndex;
var float RepathTimer;
var float RepathDelay;

function TickMarkers()
{
	//return;	
}

function TickStatus(float DeltaTime)
{
	local int I, RepairCount;
	local bool bIsComplete;

	RepairCount = 0;
	bIsComplete = true;
	I = 0;
	J0x22:

	// End:0x152 [Loop If]
	if(I < Repairs.Length)
	{
		// End:0x10F
		if(Repairs[I].bHasBeenRepaired == false)
		{
			// End:0x103
			if(CheckRepair(I))
			{
				// End:0xA7
				if(ClosestTargetIndex == I)
				{
					RepathTimer = RepathDelay;
				}
				Repairs[I].bHasBeenRepaired = true;
				RemoveObjectiveMarker(Repairs[I].RepairObject);				
			}
			else
			{
				bIsComplete = false;
			}
		}
		// End:0x144
		if(Repairs[I].bHasBeenRepaired)
		{
			RepairCount++;
		}
		I++;
		// [Loop Continue]
		goto J0x22;
	}
	// End:0x175
	if(RepairCount >= MinRepairs)
	{
		bIsComplete = true;
	}
	// End:0x18E
	if(bIsComplete)
	{
		Complete();
		return;
	}
	RepathTimer += DeltaTime;
	// End:0x206
	if(RepathTimer >= RepathDelay)
	{
		I = ClosestTargetIndex;
		TickNavigationPoint();
		RepathTimer = 0.0000000;
		// End:0x206
		if(I != ClosestTargetIndex)
		{
			UpdateCompassWaypoint();
		}
	}
	//return;	
}

function bool CheckRepair(int Idx)
{
	local SequenceEvent SeqEv;
	local SeqEvent_Used SeqEv_Used;

	// End:0xB1
	foreach Repairs[Idx].RepairObject.Actor.GeneratedEvents(SeqEv)
	{
		SeqEv_Used = SeqEvent_Used(SeqEv);
		// End:0xB0
		if((SeqEv_Used != none) && SeqEv_Used.Instigator != none)
		{			
			return true;
		}		
	}	
	return false;
	//return ReturnValue;	
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

	// End:0x1BB [Loop If]
	if(I < Repairs.Length)
	{
		// End:0x1AD
		if(Repairs[I].bHasBeenRepaired == false)
		{
			Target = Repairs[I].RepairObject.Actor;
			// End:0x1AD
			if(Target != none)
			{
				// End:0x1AC
				foreach PlayerLocations(PlayerLocation)
				{
					// End:0x139
					if(ClosestTargetIndex == -1)
					{
						ClosestTargetIndex = I;
						shortestDistSq = VSizeSq(Target.Location - PlayerLocation);						
					}
					else
					{
						DistSq = VSizeSq(Target.Location - PlayerLocation);
						// End:0x1AB
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
	if((ClosestTargetIndex >= 0) && ClosestTargetIndex < Repairs.Length)
	{
		return Repairs[ClosestTargetIndex].RepairObject.Actor;
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
	if(I < Repairs.Length)
	{
		CreateObjectiveMarker(Repairs[I].RepairObject);
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