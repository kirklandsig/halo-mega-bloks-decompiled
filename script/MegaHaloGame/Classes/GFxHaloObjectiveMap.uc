class GFxHaloObjectiveMap extends GFxObject within GFxMoviePlayer;

struct ObjectiveIndicator
{
	var Actor MarkedActor;
	var GFxObject Icon;

	structdefaultproperties
	{
		MarkedActor=none
		Icon=none
	}
};

var string LocalizationSection;
var string LocalizationPackage;
var PlayerController PlayerOwner;
var float CurrentZoom;
var float PanMultiplier;
var float ZoomMultiplier;
var float MinScaleZoom;
var float MaxScaleZoom;
var float MapCenterX;
var float MapCenterY;
var float ExtrudeDepthIn;
var float ExtrudeDepthOut;
var float ExtrudeShiftIn;
var float ExtrudeShiftOut;
var float MarkerRotation;
var GFxObject PlayerIconContainer;
var GFxObject ObjectiveContainer;
var GFxObject MapContainer1;
var GFxObject MapContainer2;
var GFxObject MapContainer3;
var GFxObject PlayerIcon;
var array<ObjectiveIndicator> MarkedObjectives;
var array<GFxObject> MapClipStack;
var array<GFxObject> MapPanStack;

function Init()
{
	local GFxObject tempMC;

	PlayerOwner = Outer.GetPC();
	tempMC = GetObject("map3");
	MapClipStack.AddItem(tempMC);
	MapContainer3 = tempMC.GetObject("base");
	MapPanStack.AddItem(MapContainer3);
	tempMC = GetObject("map2");
	MapClipStack.AddItem(tempMC);
	MapContainer2 = tempMC.GetObject("base");
	MapPanStack.AddItem(MapContainer2);
	tempMC = GetObject("map1");
	MapClipStack.AddItem(tempMC);
	MapContainer1 = tempMC.GetObject("base");
	MapPanStack.AddItem(MapContainer1);
	tempMC = GetObject("player");
	MapClipStack.AddItem(tempMC);
	PlayerIconContainer = tempMC.GetObject("base");
	MapPanStack.AddItem(PlayerIconContainer);
	tempMC = GetObject("objectives");
	MapClipStack.AddItem(tempMC);
	ObjectiveContainer = tempMC.GetObject("base");
	MapPanStack.AddItem(ObjectiveContainer);
	PlayerIcon = PlayerIconContainer.GetObject("icon");
	LogInternal("-----------------------");
	LogInternal(string(PlayerIconContainer));
	LogInternal(string(ObjectiveContainer));
	LogInternal(string(MapContainer1));
	LogInternal(string(PlayerIcon));
	SetupPlayerIcon();
	SetupObjectiveIcons();
	SetMapZoom(MinScaleZoom);
	LogInternal("OBJECTIVE MAP INITIALIZED");
	//return;	
}

function SetupPlayerIcon()
{
	local ASDisplayInfo DI;

	// End:0x5A
	if(HaloVehicle_Warthog(PlayerOwner.Pawn) != none)
	{
		PlayerIcon.GotoAndStop("inWarthog");		
	}
	else
	{
		// End:0xB2
		if(HaloVehicle_Ghost(PlayerOwner.Pawn) != none)
		{
			PlayerIcon.GotoAndStop("inGhost");			
		}
		else
		{
			// End:0x10B
			if(HaloTurret(PlayerOwner.Pawn) != none)
			{
				PlayerIcon.GotoAndStop("inTurret");				
			}
			else
			{
				PlayerIcon.GotoAndStop("onFoot");
			}
		}
	}
	DI.hasRotation = true;
	DI.Rotation = (float(PlayerOwner.Rotation.Yaw & 65535) * (360.0000000 / 65536.0000000)) + float(90);
	PlayerIcon.SetDisplayInfo(DI);
	//return;	
}

function SetupObjectiveIcons()
{
	local HaloGameDefault Game;
	local HaloMission mission;
	local HaloObjective Objective;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0xDE
	if(Game != none)
	{
		mission = Game.GetActiveMission();
		// End:0xDE
		if(mission != none)
		{
			// End:0xDD
			foreach mission.Objectives(Objective)
			{
				// End:0xDC
				if(Objective != none)
				{
					MarkObjective(Objective);
				}				
			}			
		}
	}
	//return;	
}

function MarkObjective(HaloObjective Objective)
{
	local int Index;
	local GFxObject OM, OM_H, OM_N;
	local int frame;
	local bool bWillShow;
	local Pawn P;
	local HaloDestructibleActor HDA;
	local ObjectiveMarker HUDMarker;

	// End:0x598
	foreach Objective.Markers(HUDMarker)
	{
		// End:0x597
		if(HUDMarker.Actor != none)
		{
			Index = MarkedObjectives.Length;
			OM = ObjectiveContainer.AttachMovie("objectiveMarker", "OM_" $ string(Index));
			OM_N = OM.GetObject("distance");
			OM_H = OM.GetObject("health");
			OM.SetFloat("_xrotation", -GetFloat("_xrotation") + MarkerRotation);
			switch(HUDMarker.Type)
			{
				// End:0x1BB
				case 1:
					OM.GotoAndStop("inactive");
					// End:0x2A3
					break;
				// End:0x1EC
				case 3:
					OM.GotoAndStop("location");
					// End:0x2A3
					break;
				// End:0x218
				case 5:
					OM.GotoAndStop("use");
					// End:0x2A3
					break;
				// End:0x249
				case 4:
					OM.GotoAndStop("takedown");
					// End:0x2A3
					break;
				// End:0x278
				case 2:
					OM.GotoAndStop("defend");
					// End:0x2A3
					break;
				// End:0xFFFF
				default:
					OM.GotoAndStop("none");
					// End:0x2A3
					break;
					break;
			}
			// End:0x329
			if(Objective.DisplayName != "")
			{
				OM_N.SetVisible(true);
				OM_N.SetText(Objective.DisplayName);				
			}
			else
			{
				OM_N.SetVisible(false);
			}
			bWillShow = HUDMarker.bShowHealth;
			// End:0x4A0
			if(bWillShow)
			{
				P = Pawn(HUDMarker.Actor);
				// End:0x3EA
				if(P != none)
				{
					frame = P.Health + 1;					
				}
				else
				{
					HDA = HaloDestructibleActor(HUDMarker.Actor);
					// End:0x494
					if(HDA != none)
					{
						frame = ((HDA.Health / HDA.HealthMax) * 100) + 1;
						frame = Min(Max(frame, 1), 101);						
					}
					else
					{
						bWillShow = false;
					}
				}
			}
			// End:0x4F8
			if(bWillShow)
			{
				OM_H.SetVisible(true);
				OM_H.GotoAndStopI(frame);				
			}
			else
			{
				OM_H.SetVisible(false);
			}
			MarkedObjectives.Add(1);
			MarkedObjectives[Index].MarkedActor = HUDMarker.Actor;
			MarkedObjectives[Index].Icon = OM;
		}		
	}	
	//return;	
}

function SetIconPosition(Actor A, GFxObject Icon)
{
	local Vector V;

	V = A.Location;
	Icon.SetFloat("_x", (V.X - MapCenterX) * CurrentZoom);
	Icon.SetFloat("_y", (V.Y - MapCenterY) * CurrentZoom);
	//return;	
}

function UpdateIconPosition()
{
	local ObjectiveIndicator currentMarker;

	// End:0x5A
	foreach MarkedObjectives(currentMarker)
	{
		SetIconPosition(currentMarker.MarkedActor, currentMarker.Icon);		
	}	
	SetIconPosition(PlayerOwner.Pawn, PlayerIcon);
	//return;	
}

function Pan(Vector2D StickVector)
{
	local float widthDiff, heightDiff;
	local Vector2D NewPosition;

	widthDiff = (MapContainer1.GetFloat("_width") * 0.5000000) - 440.0000000;
	// End:0x117
	if(widthDiff > 0.0000000)
	{
		NewPosition.X = MapContainer1.GetFloat("_x") - (StickVector.X * PanMultiplier);
		NewPosition.X = float(Min(Max(int(NewPosition.X), int(-widthDiff)), int(widthDiff)));		
	}
	else
	{
		NewPosition.X = 0.0000000;
	}
	heightDiff = (MapContainer1.GetFloat("_height") * 0.5000000) - 260.0000000;
	// End:0x251
	if(heightDiff > 0.0000000)
	{
		NewPosition.Y = MapContainer1.GetFloat("_y") + (StickVector.Y * PanMultiplier);
		NewPosition.Y = float(Min(Max(int(NewPosition.Y), int(-heightDiff)), int(heightDiff)));		
	}
	else
	{
		NewPosition.Y = 0.0000000;
	}
	SetMapPan(NewPosition);
	//return;	
}

function SetMapPan(Vector2D NewPosition)
{
	local GFxObject currentMapClip;

	// End:0x96
	foreach MapPanStack(currentMapClip)
	{
		currentMapClip.SetFloat("_x", NewPosition.X);
		currentMapClip.SetFloat("_y", NewPosition.Y);		
	}	
	//return;	
}

function Zoom(float StickAngle)
{
	local float newZoom;
	local Vector2D emptyVector;

	newZoom = CurrentZoom - (StickAngle * ZoomMultiplier);
	// End:0x56
	if(newZoom > MaxScaleZoom)
	{
		newZoom = MaxScaleZoom;		
	}
	else
	{
		// End:0x80
		if(newZoom < MinScaleZoom)
		{
			newZoom = MinScaleZoom;
		}
	}
	// End:0xBD
	if(newZoom != CurrentZoom)
	{
		SetMapZoom(newZoom);
		Pan(emptyVector);
	}
	//return;	
}

function ToggleZoom()
{
	// End:0x24
	if(CurrentZoom > MinScaleZoom)
	{
		ZoomToAll();		
	}
	else
	{
		ZoomToObjectives();
	}
	//return;	
}

function ZoomToAll()
{
	local Vector2D NewPosition;

	SetMapZoom(MinScaleZoom);
	SetMapPan(NewPosition);
	//return;	
}

function ZoomToObjectives()
{
	local float ScaleX, ScaleY, newZoom, MinX, MaxX, MinY,
		MaxY;

	local Vector V;
	local Vector2D NewPosition;
	local ObjectiveIndicator currentMarker;

	V = PlayerOwner.Pawn.Location;
	MinX = V.X;
	MaxX = V.X;
	MinY = V.Y;
	MaxY = V.Y;
	// End:0x26E
	foreach MarkedObjectives(currentMarker)
	{
		V = currentMarker.MarkedActor.Location;
		// End:0x17A
		if(V.X < MinX)
		{
			MinX = V.X;			
		}
		else
		{
			// End:0x1CA
			if(V.X > MaxX)
			{
				MaxX = V.X;
			}
		}
		// End:0x21D
		if(V.Y < MinY)
		{
			MinY = V.Y;			
		}
		else
		{
			// End:0x26D
			if(V.Y > MaxY)
			{
				MaxY = V.Y;
			}
		}		
	}	
	ScaleX = 880.0000000 / (MaxX - MinX);
	ScaleY = 520.0000000 / (MaxY - MinY);
	// End:0x2E6
	if(ScaleX < ScaleY)
	{
		newZoom = ScaleX;		
	}
	else
	{
		newZoom = ScaleY;
	}
	// End:0x326
	if(newZoom > MaxScaleZoom)
	{
		newZoom = MaxScaleZoom;		
	}
	else
	{
		// End:0x350
		if(newZoom < MinScaleZoom)
		{
			newZoom = MinScaleZoom;
		}
	}
	SetMapZoom(newZoom);
	NewPosition.X = (-((MinX - MapCenterX) + MaxX) - MapCenterX * 0.5000000) * CurrentZoom;
	NewPosition.Y = (-((MinY - MapCenterY) + MaxY) - MapCenterY * 0.5000000) * CurrentZoom;
	SetMapPan(NewPosition);
	NewPosition.X = 0.0000000;
	NewPosition.Y = 0.0000000;
	Pan(NewPosition);
	//return;	
}

function SetMapZoom(float newZoom)
{
	local float MapScale;
	local int I, numClips;
	local float zoomPct, depthOffset, shiftOffset;

	CurrentZoom = newZoom;
	MapScale = (CurrentZoom / MaxScaleZoom) * float(100);
	MapContainer1.SetFloat("_xscale", MapScale);
	MapContainer1.SetFloat("_yscale", MapScale);
	MapContainer2.SetFloat("_xscale", MapScale);
	MapContainer2.SetFloat("_yscale", MapScale);
	MapContainer3.SetFloat("_xscale", MapScale);
	MapContainer3.SetFloat("_yscale", MapScale);
	zoomPct = (CurrentZoom - MinScaleZoom) / (MaxScaleZoom - MinScaleZoom);
	numClips = MapClipStack.Length;
	depthOffset = ((ExtrudeDepthIn - ExtrudeDepthOut) * zoomPct) + ExtrudeDepthOut;
	shiftOffset = ((ExtrudeShiftIn - ExtrudeShiftOut) * zoomPct) + ExtrudeShiftOut;
	I = 0;
	J0x218:

	// End:0x2C9 [Loop If]
	if(I < numClips)
	{
		MapClipStack[I].SetFloat("_z", depthOffset * float(I + 1));
		MapClipStack[I].SetFloat("_y", shiftOffset * float(I + 1));
		I++;
		// [Loop Continue]
		goto J0x218;
	}
	LogInternal("++++++++++++++");
	LogInternal(string(depthOffset));
	LogInternal(string(shiftOffset));
	UpdateIconPosition();
	//return;	
}

defaultproperties
{
	LocalizationSection="GFxHaloObjectiveMap"
	LocalizationPackage="MegaHaloGame"
	PanMultiplier=8.0000000
	ZoomMultiplier=0.0005000
	MinScaleZoom=0.0035000
	MaxScaleZoom=0.0128000
	MapCenterX=-49500.0000000
	MapCenterY=-70000.0000000
	ExtrudeDepthIn=-500.0000000
	ExtrudeDepthOut=-100.0000000
	ExtrudeShiftIn=-4.0000000
	ExtrudeShiftOut=-8.0000000
	MarkerRotation=30.0000000
}