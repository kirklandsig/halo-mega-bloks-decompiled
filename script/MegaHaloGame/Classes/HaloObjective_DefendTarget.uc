class HaloObjective_DefendTarget extends HaloObjective
	config(HUDMarkers);

struct VIPData
{
	var int PrevHealth;
	var ObjectiveMarkerData VIP;
	var float DamageIndicatorTimer;
	var bool bFlashMarker;

	structdefaultproperties
	{
		PrevHealth=0
		VIP=(Actor=none,Marker=OMN_None,bDraw=true,bDrawTagSymbol=false,bShowHealth=false,bShowDistance=false,bClampToScreen=true)
		DamageIndicatorTimer=0.0000000
		bFlashMarker=false
	}
};

var array<VIPData> VIPs;
var int LowestHealthVIPIndex;
var float RepathTimer;
var float RepathDelay;
var float DamageIndicatorTime;

function Start()
{
	GetInitialVIPHealth();
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

	// End:0x3F9 [Loop If]
	if(I < VIPs.Length)
	{
		bRemove = false;
		P = Pawn(VIPs[I].VIP.Actor);
		// End:0x224
		if(P == none)
		{
			HDA = HaloDestructibleActor(VIPs[I].VIP.Actor);
			// End:0xF4
			if(HDA == none)
			{
				bRemove = true;				
			}
			else
			{
				// End:0x127
				if(HDA.Health <= 0)
				{
					bRemove = true;					
				}
				else
				{
					// End:0x221
					if(HDA.Health != VIPs[I].PrevHealth)
					{
						VIPs[I].PrevHealth = HDA.Health;
						VIPs[I].bFlashMarker = true;
						VIPs[I].DamageIndicatorTimer = DamageIndicatorTime;
						FlashObjectiveMarker(I);
					}
				}
			}			
		}
		else
		{
			// End:0x257
			if(P.Health <= 0)
			{
				bRemove = true;				
			}
			else
			{
				// End:0x351
				if(P.Health != VIPs[I].PrevHealth)
				{
					VIPs[I].PrevHealth = P.Health;
					VIPs[I].bFlashMarker = true;
					VIPs[I].DamageIndicatorTimer = DamageIndicatorTime;
					FlashObjectiveMarker(I);
				}
			}
		}
		// End:0x3AE
		if(bRemove == true)
		{
			RemoveObjectiveMarker(VIPs[I].VIP);
			VIPs.Remove(I--, 1);
			goto J0x3EB;			
		}
		else
		{
			// End:0x3EB
			if(VIPs[I].bFlashMarker)
			{
				FlashObjectiveMarker(I);
			}
		}
		J0x3EB:

		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function FlashObjectiveMarker(int Index)
{
	local ObjectiveMarker Marker;

	// End:0x1F0
	if(GetObjectiveMarker(VIPs[Index].VIP, Marker))
	{
		Marker.Icon.SetScalarParameterValue('Pulse', VIPs[Index].DamageIndicatorTimer);
		VIPs[Index].DamageIndicatorTimer -= VIPs[Index].VIP.Actor.WorldInfo.DeltaSeconds;
		// End:0x1ED
		if(VIPs[Index].DamageIndicatorTimer <= 0.0000000)
		{
			VIPs[Index].bFlashMarker = false;
			VIPs[Index].DamageIndicatorTimer = 0.0000000;
			Marker.Icon.SetScalarParameterValue('Pulse', 0.0000000);
		}		
	}
	else
	{
		VIPs[Index].bFlashMarker = false;
	}
	LogInternal(string(VIPs[Index].DamageIndicatorTimer));
	//return;	
}

function TickStatus(float DeltaTime)
{
	// End:0x1C
	if(VIPs.Length == 0)
	{
		Fail();
		return;
	}
	RepathTimer += DeltaTime;
	// End:0x6A
	if(RepathTimer >= RepathDelay)
	{
		TickNavigationPoint();
		UpdateCompassWaypoint();
		RepathTimer = 0.0000000;
	}
	//return;	
}

function GetInitialVIPHealth()
{
	local int I;
	local Pawn P;
	local HaloDestructibleActor HDA;

	I = 0;
	J0x0B:

	// End:0x177 [Loop If]
	if(I < VIPs.Length)
	{
		P = Pawn(VIPs[I].VIP.Actor);
		// End:0xC6
		if(P != none)
		{
			VIPs[I].PrevHealth = P.Health;			
		}
		else
		{
			HDA = HaloDestructibleActor(VIPs[I].VIP.Actor);
			// End:0x169
			if(HDA != none)
			{
				VIPs[I].PrevHealth = HDA.Health;				
			}
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function TickNavigationPoint()
{
	local int I, lowestHealth;
	local Pawn P;
	local HaloDestructibleActor HDA;

	lowestHealth = 9999999;
	LowestHealthVIPIndex = -1;
	I = 0;
	J0x29:

	// End:0x1D9 [Loop If]
	if(I < VIPs.Length)
	{
		P = Pawn(VIPs[I].VIP.Actor);
		// End:0x106
		if(P != none)
		{
			// End:0x106
			if(P.Health < lowestHealth)
			{
				lowestHealth = P.Health;
				LowestHealthVIPIndex = I;
				// [Explicit Continue]
				goto J0x1CB;
			}
		}
		HDA = HaloDestructibleActor(VIPs[I].VIP.Actor);
		// End:0x1CB
		if(HDA != none)
		{
			// End:0x1CB
			if(HDA.Health < lowestHealth)
			{
				lowestHealth = HDA.Health;
				LowestHealthVIPIndex = I;				
			}
		}
		J0x1CB:

		I++;
		// [Loop Continue]
		goto J0x29;
	}
	//return;	
}

function Actor GetNavigationPoint()
{
	// End:0x52
	if(VIPs.Length > LowestHealthVIPIndex)
	{
		return VIPs[LowestHealthVIPIndex].VIP.Actor;
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
	if(I < VIPs.Length)
	{
		CreateObjectiveMarker(VIPs[I].VIP);
		I++;
		// [Loop Continue]
		goto J0x15;
	}
	//return;	
}

defaultproperties
{
	LowestHealthVIPIndex=-1
	RepathDelay=5.0000000
	DamageIndicatorTime=1.0000000
	IconFrame="defend"
}