class HaloObjective_GoToLocation extends HaloObjective
	config(HUDMarkers);

struct LocationData
{
	var bool bHasBeenVisited;
	var ObjectiveMarkerData Location;

	structdefaultproperties
	{
		bHasBeenVisited=false
		Location=(Actor=none,Marker=EObjectiveMarker.OMN_None,bDraw=true,bDrawTagSymbol=false,bShowHealth=false,bShowDistance=false,bClampToScreen=true)
	}
};

var HaloObjective.EObjectivePlayerCount PlayerCount;
var Class<Pawn> PlayerPawnType;
var array<ObjectiveMarkerData> NPCs;
var int MinNPCCount;
var array<LocationData> Locations;
var int ClosestTargetIndex;
var float RepathTimer;
var float RepathDelay;

function TickMarkers()
{
	local int I;
	local Pawn P;

	I = 0;
	J0x0B:

	// End:0xD6 [Loop If]
	if(I < NPCs.Length)
	{
		P = Pawn(NPCs[I].Actor);
		// End:0xC8
		if((P == none) || P.Health <= 0)
		{
			RemoveObjectiveMarker(NPCs[I]);
			NPCs.Remove(I--, 1);			
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
	local bool bIsComplete;

	// End:0x24
	if(NPCs.Length < MinNPCCount)
	{
		Fail();
		return;
	}
	bIsComplete = true;
	I = 0;
	J0x3B:

	// End:0x27F [Loop If]
	if(I < Locations.Length)
	{
		// End:0x184
		if(((Locations[I].Location.Actor == none) || Locations[I].Location.Actor.bPendingDelete) || Locations[I].Location.Actor.bDeleteMe)
		{
			RemoveObjectiveMarker(Locations[I].Location);
			Locations.Remove(I--, 1);			
		}
		else
		{
			// End:0x271
			if(Locations[I].bHasBeenVisited == false)
			{
				// End:0x265
				if((CheckPlayers(I)) && CheckNPCs(I))
				{
					// End:0x209
					if(ClosestTargetIndex == I)
					{
						RepathTimer = RepathDelay;
					}
					Locations[I].bHasBeenVisited = true;
					RemoveObjectiveMarker(Locations[I].Location);					
				}
				else
				{
					bIsComplete = false;
				}
			}
		}
		I++;
		// [Loop Continue]
		goto J0x3B;
	}
	// End:0x298
	if(bIsComplete)
	{
		Complete();
		return;
	}
	RepathTimer += DeltaTime;
	// End:0x310
	if(RepathTimer >= RepathDelay)
	{
		I = ClosestTargetIndex;
		TickNavigationPoint();
		RepathTimer = 0.0000000;
		// End:0x310
		if(I != ClosestTargetIndex)
		{
			UpdateCompassWaypoint();
		}
	}
	//return;	
}

function bool CheckNPCs(int Idx)
{
	local int NPCCount;
	local ObjectiveMarkerData NPC;

	NPCCount = 0;
	// End:0xA6
	foreach NPCs(NPC)
	{
		// End:0xA5
		if(Locations[Idx].Location.Actor.Touching.Find(NPC.Actor) != -1)
		{
			NPCCount++;
		}		
	}	
	return NPCCount >= MinNPCCount;
	//return ReturnValue;	
}

function bool CheckPlayers(int Idx)
{
	local int validTouchCount, totalPlayerCount;
	local HaloPlayerPawnController PC;

	validTouchCount = 0;
	totalPlayerCount = 0;
	// End:0x159
	foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'MegaHaloGame.HaloPlayerPawnController', PC)
	{
		// End:0x14D
		if((PC.Pawn != none) && ClassIsChildOf(PC.Pawn.Class, PlayerPawnType))
		{
			// End:0x14D
			if(Locations[Idx].Location.Actor.Touching.Find(PC.Pawn) != -1)
			{
				validTouchCount++;
			}
		}
		totalPlayerCount++;		
	}	
	switch(PlayerCount)
	{
		// End:0x174
		case 0:
			return true;
		// End:0x186
		case 1:
			return validTouchCount >= 1;
		// End:0x1A0
		case 2:
			return validTouchCount >= totalPlayerCount;
		// End:0xFFFF
		default:
			return false;
			break;
	}
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
	if(I < Locations.Length)
	{
		// End:0x1AD
		if(Locations[I].bHasBeenVisited == false)
		{
			Target = Locations[I].Location.Actor;
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
	if((ClosestTargetIndex >= 0) && ClosestTargetIndex < Locations.Length)
	{
		return Locations[ClosestTargetIndex].Location.Actor;
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
	if(I < NPCs.Length)
	{
		CreateObjectiveMarker(NPCs[I]);
		I++;
		// [Loop Continue]
		goto J0x15;
	}
	I = 0;
	J0x63:

	// End:0xB9 [Loop If]
	if(I < Locations.Length)
	{
		CreateObjectiveMarker(Locations[I].Location);
		I++;
		// [Loop Continue]
		goto J0x63;
	}
	//return;	
}

defaultproperties
{
	PlayerCount=EObjectivePlayerCount.OPC_All
	PlayerPawnType=Class'Engine.Pawn'
	ClosestTargetIndex=-1
	RepathDelay=5.0000000
	IconFrame="location"
}