class HaloObjective_DefendZone extends HaloObjective
	config(HUDMarkers);

enum EZoneStatus
{
	DZS_Neutral,                    // 0
	DZS_Friendly,                   // 1
	DZS_Hostile,                    // 2
	DZS_MAX                         // 3
};

struct DefendZone
{
	var ObjectiveMarkerData Zone;
	var HaloObjective_DefendZone.EZoneStatus Status;
	var float Value;
	var export editinline ParticleSystemComponent PerimeterEffect;

	structdefaultproperties
	{
		Zone=(Actor=none,Marker=OMN_None,bDraw=true,bDrawTagSymbol=false,bShowHealth=false,bShowDistance=false,bClampToScreen=true)
		Status=DZS_Neutral
		Value=0.0000000
		PerimeterEffect=none
	}
};

var array<DefendZone> Zones;
var float CaptureRate;
var float NeutralizeRate;
var int FriendlyZoneCountToComplete;
var int HostileZoneCountToFail;
var AkEvent OnNeutralCaptureSound;
var AkEvent OnFriendlyCaptureSound;
var AkEvent OnHostileCaptureSound;
var AkEvent CaptureSound;
var int LowestValueZoneIndex;
var float RepathTimer;
var float RepathDelay;

function Start()
{
	local int I;
	local Vector FXScale;
	local Trigger zoneTrigger;
	local editinline ParticleSystemComponent PSC;

	I = 0;
	J0x0B:

	// End:0x2C0 [Loop If]
	if(I < Zones.Length)
	{
		zoneTrigger = Trigger(Zones[I].Zone.Actor);
		// End:0x2B2
		if(zoneTrigger != none)
		{
			PSC = zoneTrigger.WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'ENV_BattleZone_FX.Effects.ENV_FriendZone_FX', zoneTrigger.Location);
			PSC.CastShadow = false;
			PSC.bCastStaticShadow = false;
			PSC.bCastDynamicShadow = false;
			PSC.bAcceptsDynamicDominantLightShadows = false;
			FXScale.X = zoneTrigger.CylinderComponent.CollisionRadius * 0.0100000;
			FXScale.Y = zoneTrigger.CylinderComponent.CollisionRadius * 0.0100000;
			FXScale.Z = 1.0000000;
			PSC.SetVectorParameter('ScaleParam', FXScale);
			Zones[I].PerimeterEffect = PSC;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	TickNavigationPoint();
	super.Start();
	//return;	
}

function Term()
{
	local int I;
	local editinline ParticleSystemComponent PSC;

	I = 0;
	J0x0B:

	// End:0xB7 [Loop If]
	if(I < Zones.Length)
	{
		PSC = Zones[I].PerimeterEffect;
		// End:0xA9
		if(PSC != none)
		{
			PSC.DeactivateSystem();
			Zones[I].PerimeterEffect = none;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	super.Term();
	//return;	
}

function TickMarkers()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0xC3 [Loop If]
	if(I < Zones.Length)
	{
		// End:0xB5
		if(Trigger(Zones[I].Zone.Actor) == none)
		{
			RemoveObjectiveMarker(Zones[I].Zone);
			Zones.Remove(I--, 1);			
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function TickStatus(float DeltaTime)
{
	local int I, friendlyCount, hostileCount;

	TickZones(DeltaTime);
	friendlyCount = 0;
	hostileCount = 0;
	I = 0;
	J0x34:

	// End:0xB6 [Loop If]
	if(I < Zones.Length)
	{
		switch(Zones[I].Status)
		{
			// End:0x8F
			case 1:
				friendlyCount++;
				// End:0xA8
				break;
			// End:0xA2
			case 2:
				hostileCount++;
				// End:0xA8
				break;
			// End:0xFFFF
			default:
				// End:0xA8
				break;
				break;
		}
		I++;
		// [Loop Continue]
		goto J0x34;
	}
	// End:0xD9
	if(friendlyCount >= FriendlyZoneCountToComplete)
	{
		Complete();
		return;
	}
	// End:0xFC
	if(hostileCount >= HostileZoneCountToFail)
	{
		Fail();
		return;
	}
	// End:0x129
	if(CaptureSound != none)
	{
		PlaySound(CaptureSound);
		CaptureSound = none;
	}
	RepathTimer += DeltaTime;
	// End:0x177
	if(RepathTimer >= RepathDelay)
	{
		TickNavigationPoint();
		UpdateCompassWaypoint();
		RepathTimer = 0.0000000;
	}
	//return;	
}

function TickZones(float DeltaTime)
{
	local int I;
	local float zoneDelta, zoneValue, zonePct;
	local Vector zoneColor;
	local HaloObjective_DefendZone.EZoneStatus zoneStatus;
	local Pawn P;
	local Trigger zoneTrigger;
	local HaloPawn HP;
	local HaloVehicle HV;
	local VehicleSeat Seat;
	local array<HaloPawn> HPsInZone;

	I = 0;
	J0x0B:

	// End:0x773 [Loop If]
	if(I < Zones.Length)
	{
		HPsInZone.Length = 0;
		zoneTrigger = Trigger(Zones[I].Zone.Actor);
		// End:0x1DF
		if(zoneTrigger != none)
		{
			// End:0x1DE
			foreach zoneTrigger.TouchingActors(Class'Engine.Pawn', P)
			{
				// End:0x1DD
				if((P != none) && P.Health > 0)
				{
					HP = HaloPawn(P);
					// End:0x130
					if(HP != none)
					{
						HPsInZone.AddItem(HP);
						// End:0x1DD
						continue;
					}
					HV = HaloVehicle(P);
					// End:0x1DD
					if(HV != none)
					{
						// End:0x1DC
						foreach HV.Seats(Seat)
						{
							HP = HaloPawn(Seat.StoragePawn);
							// End:0x1DB
							if(HP != none)
							{
								HPsInZone.AddItem(HP);
							}							
						}						
					}
				}				
			}			
		}
		zoneDelta = 0.0000000;
		zoneValue = Zones[I].Value;
		zoneStatus = Zones[I].Status;
		// End:0x4DF
		if(HPsInZone.Length > 0)
		{
			// End:0x32F
			foreach HPsInZone(HP)
			{
				switch(HP.TeamNum)
				{
					// End:0x2E4
					case 1:
						zoneDelta += ((HP.ZoneCaptureRate * CaptureRate) * DeltaTime);
						// End:0x32E
						break;
					// End:0x32B
					case 2:
						zoneDelta -= ((HP.ZoneCaptureRate * CaptureRate) * DeltaTime);
						// End:0x32E
						break;
					// End:0xFFFF
					default:
						break;
				}				
			}			
			switch(zoneStatus)
			{
				// End:0x3D3
				case 0:
					zoneValue += zoneDelta;
					// End:0x37E
					if(zoneValue <= -100.0000000)
					{
						zoneStatus = 2;						
					}
					else
					{
						// End:0x3A0
						if(zoneValue >= 100.0000000)
						{
							zoneStatus = 1;							
						}
						else
						{
							Zones[I].Value = zoneValue;
						}
					}
					// End:0x4C0
					break;
				// End:0x448
				case 1:
					zoneValue += zoneDelta;
					// End:0x40E
					if(zoneValue <= 0.0000000)
					{
						zoneStatus = 0;						
					}
					else
					{
						Zones[I].Value = FMin(zoneValue, 100.0000000);
					}
					// End:0x4C0
					break;
				// End:0x4BD
				case 2:
					zoneValue += zoneDelta;
					// End:0x483
					if(zoneValue >= 0.0000000)
					{
						zoneStatus = 0;						
					}
					else
					{
						Zones[I].Value = FMax(zoneValue, -100.0000000);
					}
					// End:0x4C0
					break;
				// End:0xFFFF
				default:
					break;
			}
			SetZoneStatusAtIndex(I, zoneStatus);			
		}
		else
		{
			switch(zoneStatus)
			{
				// End:0x56B
				case 1:
					zoneValue -= (NeutralizeRate * DeltaTime);
					// End:0x538
					if(zoneValue <= 0.0000000)
					{
						zoneStatus = 0;						
					}
					else
					{
						Zones[I].Value = zoneValue;
					}
					// End:0x5EA
					break;
				// End:0x5E4
				case 2:
					zoneValue += (NeutralizeRate * DeltaTime);
					// End:0x5B1
					if(zoneValue >= 0.0000000)
					{
						zoneStatus = 0;						
					}
					else
					{
						Zones[I].Value = zoneValue;
					}
					// End:0x5EA
					break;
				// End:0xFFFF
				default:
					// End:0x5EA
					break;
					break;
			}
			SetZoneStatusAtIndex(I, zoneStatus);
		}
		// End:0x765
		if(Zones[I].PerimeterEffect != none)
		{
			zonePct = FClamp((Zones[I].Value + 100.0000000) / 200.0000000, 0.0000000, 1.0000000);
			zoneColor.X = FClamp((1.0000000 - zonePct) * 2.0000000, 0.0000000, 1.0000000);
			zoneColor.Y = FClamp(zonePct * 2.0000000, 0.0000000, 1.0000000);
			zoneColor.Z = 0.0000000;
			Zones[I].PerimeterEffect.SetVectorParameter('Color', zoneColor);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function SetZoneStatusAtIndex(int I, HaloObjective_DefendZone.EZoneStatus NewStatus)
{
	// End:0x19E
	if(int(NewStatus) != int(Zones[I].Status))
	{
		switch(NewStatus)
		{
			// End:0xBB
			case 0:
				Zones[I].Value = 0.0000000;
				Zones[I].Status = 0;
				CaptureSound = OnNeutralCaptureSound;
				// End:0x19E
				break;
			// End:0x12B
			case 1:
				Zones[I].Value = 100.0000000;
				Zones[I].Status = 1;
				CaptureSound = OnFriendlyCaptureSound;
				// End:0x19E
				break;
			// End:0x19B
			case 2:
				Zones[I].Value = -100.0000000;
				Zones[I].Status = 2;
				CaptureSound = OnHostileCaptureSound;
				// End:0x19E
				break;
			// End:0xFFFF
			default:
				break;
		}
	}
	else
	{
		//return;		
	}
}

function HaloObjective_DefendZone.EZoneStatus GetZoneStatusAtIndex(int I)
{
	return Zones[I].Status;
	//return ReturnValue;	
}

function int GetZoneIndex(Trigger zoneToCheck)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x8B [Loop If]
	if(I < Zones.Length)
	{
		// End:0x7D
		if(zoneToCheck == Trigger(Zones[I].Zone.Actor))
		{
			return I;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return -1;
	//return ReturnValue;	
}

function TickNavigationPoint()
{
	local int I;
	local float lowestValue;

	lowestValue = 1000.0000000;
	LowestValueZoneIndex = -1;
	I = 0;
	J0x29:

	// End:0xC6 [Loop If]
	if(I < Zones.Length)
	{
		// End:0xB8
		if(Zones[I].Value < lowestValue)
		{
			LowestValueZoneIndex = I;
			lowestValue = Zones[I].Value;
		}
		I++;
		// [Loop Continue]
		goto J0x29;
	}
	//return;	
}

function Actor GetNavigationPoint()
{
	// End:0x52
	if(Zones.Length > LowestValueZoneIndex)
	{
		return Zones[LowestValueZoneIndex].Zone.Actor;
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
	if(I < Zones.Length)
	{
		CreateObjectiveMarker(Zones[I].Zone);
		I++;
		// [Loop Continue]
		goto J0x15;
	}
	//return;	
}

defaultproperties
{
	Zones[0]=(Zone=(Actor=none,Marker=OMN_Zone,bDraw=true,bDrawTagSymbol=false,bShowHealth=false,bShowDistance=true,bClampToScreen=true),Status=DZS_Neutral,Value=0.0000000,PerimeterEffect=none)
	CaptureRate=1.0000000
	NeutralizeRate=0.0100000
	FriendlyZoneCountToComplete=1
	HostileZoneCountToFail=1
	LowestValueZoneIndex=-1
	RepathDelay=5.0000000
	IconFrame="zone"
}