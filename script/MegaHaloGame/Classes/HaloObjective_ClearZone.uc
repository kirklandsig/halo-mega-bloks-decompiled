class HaloObjective_ClearZone extends HaloObjective
	config(HUDMarkers);

var ObjectiveMarkerData Zone;
var int EnemyCountToEnableEnemyMarkers;
var bool bFindEnemies;
var bool bAddMarkers;
var array<ObjectiveMarkerData> Enemies;
var float FindEnemiesTimer;

function TickMarkers()
{
	local int I;
	local Pawn P;

	// End:0x7F
	if(Enemies.Length <= EnemyCountToEnableEnemyMarkers)
	{
		// End:0x7F
		if(bAddMarkers)
		{
			I = 0;
			J0x30:

			// End:0x73 [Loop If]
			if(I < Enemies.Length)
			{
				AddObjectiveMarker(Enemies[I]);
				I++;
				// [Loop Continue]
				goto J0x30;
			}
			bAddMarkers = false;
		}
	}
	I = 0;
	J0x8A:

	// End:0x155 [Loop If]
	if(I < Enemies.Length)
	{
		P = Pawn(Enemies[I].Actor);
		// End:0x147
		if((P == none) || P.Health <= 0)
		{
			RemoveObjectiveMarker(Enemies[I]);
			Enemies.Remove(I--, 1);			
		}
		I++;
		// [Loop Continue]
		goto J0x8A;
	}
	//return;	
}

function TickStatus(float DeltaTime)
{
	local bool bLookedForEnemies;

	bLookedForEnemies = false;
	// End:0x3B
	if(bFindEnemies)
	{
		FindEnemiesInZone();
		bFindEnemies = false;
		bLookedForEnemies = true;
	}
	FindEnemiesTimer -= DeltaTime;
	// End:0x8B
	if(FindEnemiesTimer <= 0.0000000)
	{
		FindEnemiesInZone();
		FindEnemiesTimer = default.FindEnemiesTimer;
		bLookedForEnemies = true;
	}
	// End:0xD9
	if(Enemies.Length == 0)
	{
		// End:0xB5
		if(bLookedForEnemies)
		{
			Complete();			
		}
		else
		{
			FindEnemiesInZone();
			// End:0xD9
			if(Enemies.Length == 0)
			{
				Complete();
			}
		}
	}
	//return;	
}

function FindEnemiesInZone()
{
	local Trigger zoneTrigger;
	local HaloPawn HP;
	local ObjectiveMarkerData EnemyMarker;

	ClearObjectiveMarkers();
	Enemies.Length = 0;
	zoneTrigger = Trigger(Zone.Actor);
	// End:0x1F8
	if(zoneTrigger != none)
	{
		// End:0x1F7
		foreach zoneTrigger.CollidingActors(Class'MegaHaloGame.HaloPawn', HP, zoneTrigger.CylinderComponent.CollisionRadius * 1.5000000)
		{
			// End:0x1F6
			if(((HP != none) && int(HP.TeamNum) == int(2)) && HP.Health > 0)
			{
				EnemyMarker.Actor = HP;
				EnemyMarker.Marker = 4;
				EnemyMarker.bDraw = true;
				EnemyMarker.bShowHealth = true;
				EnemyMarker.bShowDistance = false;
				EnemyMarker.bClampToScreen = false;
				Enemies.AddItem(EnemyMarker);
			}			
		}		
	}
	CreateObjectiveMarkers();
	//return;	
}

function Actor GetNavigationPoint()
{
	return Zone.Actor;
	//return ReturnValue;	
}

function CreateObjectiveMarkers()
{
	local int I;

	ClearObjectiveMarkers();
	// End:0x7F
	if(Enemies.Length <= EnemyCountToEnableEnemyMarkers)
	{
		I = 0;
		J0x2D:

		// End:0x70 [Loop If]
		if(I < Enemies.Length)
		{
			CreateObjectiveMarker(Enemies[I]);
			I++;
			// [Loop Continue]
			goto J0x2D;
		}
		bAddMarkers = false;		
	}
	else
	{
		bAddMarkers = true;
	}
	CreateObjectiveMarker(Zone);
	//return;	
}

defaultproperties
{
	Zone=(Actor=none,Marker=OMN_Location,bDraw=true,bDrawTagSymbol=false,bShowHealth=false,bShowDistance=true,bClampToScreen=true)
	EnemyCountToEnableEnemyMarkers=5
	bFindEnemies=true
	FindEnemiesTimer=1.0000000
	IconFrame="location"
}