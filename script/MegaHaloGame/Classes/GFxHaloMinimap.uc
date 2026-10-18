class GFxHaloMinimap extends GFxObject within GFxMoviePlayer;

enum MinimapIconType
{
	MMIT_Objective,                 // 0
	MMIT_Zone,                      // 1
	MMIT_Defend,                    // 2
	MMIT_OnFoot,                    // 3
	MMIT_Warthog,                   // 4
	MMIT_Mongoose,                  // 5
	MMIT_Scorpion,                  // 6
	MMIT_Ghost,                     // 7
	MMIT_Turret,                    // 8
	MMIT_MAX                        // 9
};

struct MinimapActorData
{
	var Actor Actor;
	var byte TeamFrame;

	structdefaultproperties
	{
		Actor=none
		TeamFrame=1
	}
};

var PlayerController PlayerOwner;
var GFxHaloMinimapHUD HUD;
var WorldInfo ThisWorld;
var Matrix IconMatrix;
var float CurZoom;
var float NormalZoom;
var float MaxZoom;
var float MinZoom;
var float Radius;
var GFxObject Container_Player;
var GFxObject Container_Warthog;
var GFxObject Container_Mongoose;
var GFxObject Container_Scorpion;
var GFxObject Container_Ghost;
var GFxObject Container_Turret;
var GFxObject IconsPowerCoreMC;
var GFxObject IconsObjectiveMC;
var GFxObject IconsObjectiveZoneMC;
var GFxObject IconsObjectiveDefendMC;
var UTMapInfo MapInfo;
var int MapTexSize;
var bool bNeedsUpdateData;
var GFxObject PlayerIcon;
var GFxObject CompassIcon;
var GFxObject MapMC;
var int playerIconType;
var array<GFxObject> Icons_Player;
var array<GFxObject> Icons_Warthog;
var array<GFxObject> Icons_Mongoose;
var array<GFxObject> Icons_Scorpion;
var array<GFxObject> Icons_Ghost;
var array<GFxObject> Icons_Turret;
var array<GFxObject> PowerCoreIcons;
var array<GFxObject> PowerCoreDesignations;
var array<GFxObject> PowerCoreDamaged;
var array<GFxObject> ObjectiveIcons;
var array<GFxObject> ObjectiveZoneIcons;
var array<GFxObject> DefendHealthIcons;
var array<GFxObject> DefendDamagedIcons;
var int IconCount_Player;
var int IconCount_Warthog;
var int IconCount_Mongoose;
var int IconCount_Scorpion;
var int IconCount_Ghost;
var int IconCount_Turret;
var int IconsObjectiveCount;
var int IconsObjectiveZoneCount;
var int IconsObjectiveDefendCount;
var array<Vector> PowerCoreLocations;
var array<float> TurretLastHealth;
var array<float> DefendTargetLastHealth;
var GFxObject DBGTF;
var GFxObject DBG2TF;

function Init(string baseClip, GFxHaloMinimapHUD H)
{
	HUD = H;
	bNeedsUpdateData = true;
	ThisWorld = Outer.GetPC().WorldInfo;
	MapInfo = UTMapInfo(ThisWorld.GetMapInfo());
	PlayerIcon = Outer.GetVariableObject(("_root." $ baseClip) $ ".player.base");
	CompassIcon = Outer.GetVariableObject(("_root." $ baseClip) $ ".minimap.compass");
	MapMC = Outer.GetVariableObject(("_root." $ baseClip) $ ".minimap.map");
	// End:0x240
	if((MapInfo != none) && MapInfo.MapTexture != none)
	{
		MapTexSize = Texture2D(MapInfo.MapTexture).SizeX;
		SetString("mapImagePath", "img://" $ PathName(MapInfo.MapTexture));
	}
	Container_Player = Outer.GetVariableObject(("_root." $ baseClip) $ ".minimap.icons_player");
	Container_Warthog = Outer.GetVariableObject(("_root." $ baseClip) $ ".minimap.icons_warthog");
	Container_Mongoose = Outer.GetVariableObject(("_root." $ baseClip) $ ".minimap.icons_mongoose");
	Container_Scorpion = Outer.GetVariableObject(("_root." $ baseClip) $ ".minimap.icons_scorpion");
	Container_Ghost = Outer.GetVariableObject(("_root." $ baseClip) $ ".minimap.icons_ghost");
	Container_Turret = Outer.GetVariableObject(("_root." $ baseClip) $ ".minimap.icons_turret");
	IconsPowerCoreMC = Outer.GetVariableObject(("_root." $ baseClip) $ ".minimap.icons_powerCore");
	IconsObjectiveMC = Outer.GetVariableObject(("_root." $ baseClip) $ ".minimap.icons_objective");
	IconsObjectiveZoneMC = Outer.GetVariableObject(("_root." $ baseClip) $ ".minimap.icons_zone");
	IconsObjectiveDefendMC = Outer.GetVariableObject(("_root." $ baseClip) $ ".minimap.icons_defend");
	playerIconType = -1;
	DBGTF = GetObject("DBGTF");
	DBG2TF = GetObject("DBG2TF");
	SetVisible(false);
	//return;	
}

function TransitionIn()
{
	GotoAndPlay("transIn");
	//return;	
}

function TransitionOut()
{
	GotoAndPlay("transOut");
	//return;	
}

function UpdateData()
{
	SetVisible(true);
	// End:0x39
	if(MapInfo != none)
	{
		MapInfo.VerifyMapExtent();
	}
	bNeedsUpdateData = false;
	//return;	
}

function array<GFxObject> GenMinimapIcons(int Count, GFxObject Container, string iconPath, out int IconCounter)
{
	local array<GFxObject> Icons;
	local GFxObject IconMC;
	local int I;

	I = 0;
	J0x0B:

	// End:0x99 [Loop If]
	if(I < Count)
	{
		IconMC = Container.AttachMovie(iconPath, iconPath $ string(IconCounter++));
		Icons[I] = IconMC;
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return Icons;
	//return ReturnValue;	
}

function array<GFxObject> GenMinimapIconsWithMeter(int Count, GFxObject Container, string iconPath, out int IconCounter, out array<float> MeterArray)
{
	local array<GFxObject> Icons;
	local GFxObject IconMC;
	local int I;

	I = 0;
	J0x0B:

	// End:0xAB [Loop If]
	if(I < Count)
	{
		IconMC = Container.AttachMovie(iconPath, iconPath $ string(IconCounter++));
		Icons[I] = IconMC;
		MeterArray.AddItem(-1.0000000);
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return Icons;
	//return ReturnValue;	
}

function UpdateObjectives(array<HaloObjective> Objectives)
{
	local HaloObjective Objective;
	local HaloObjective_DefendZone zoneObjective;
	local DefendZone Zone;
	local ObjectiveMarker HUDMarker;
	local array<MinimapActorData> markedActors;
	local array<DefendZone> defendZones;
	local array<MinimapActorData> defendTargets;
	local int I, activeIndex;

	// End:0x3CB
	foreach Objectives(Objective)
	{
		zoneObjective = HaloObjective_DefendZone(Objective);
		// End:0x86
		if(zoneObjective != none)
		{
			// End:0x85
			foreach zoneObjective.Zones(Zone)
			{
				defendZones.AddItem(Zone);				
			}			
		}
		// End:0x3C9
		foreach Objective.Markers(HUDMarker)
		{
			// End:0x3C8
			if(HUDMarker.Actor != none)
			{
				// End:0xF6
				if(activeIndex == ObjectiveIcons.Length)
				{
					GenObjectiveIcon();
				}
				switch(HUDMarker.Type)
				{
					// End:0x157
					case 1:
						ObjectiveIcons[activeIndex].GotoAndStop("inactive");
						// End:0x36A
						break;
					// End:0x192
					case 3:
						ObjectiveIcons[activeIndex].GotoAndStop("location");
						// End:0x36A
						break;
					// End:0x1C8
					case 5:
						ObjectiveIcons[activeIndex].GotoAndStop("use");
						// End:0x36A
						break;
					// End:0x203
					case 4:
						ObjectiveIcons[activeIndex].GotoAndStop("takedown");
						// End:0x36A
						break;
					// End:0x28F
					case 2:
						ObjectiveIcons[activeIndex].GotoAndStop("defend");
						defendTargets.Add(1);
						defendTargets[defendTargets.Length - 1].Actor = HUDMarker.Actor;
						// End:0x36A
						break;
					// End:0x2C6
					case 6:
						ObjectiveIcons[activeIndex].GotoAndStop("zone");
						// End:0x36A
						break;
					// End:0x2FE
					case 7:
						ObjectiveIcons[activeIndex].GotoAndStop("chase");
						// End:0x36A
						break;
					// End:0x335
					case 8:
						ObjectiveIcons[activeIndex].GotoAndStop("flee");
						// End:0x36A
						break;
					// End:0xFFFF
					default:
						ObjectiveIcons[activeIndex].GotoAndStop("none");
						// End:0x36A
						break;
						break;
				}
				markedActors.Add(1);
				markedActors[markedActors.Length - 1].Actor = HUDMarker.Actor;
				activeIndex++;
			}			
		}				
	}	
	UpdateIcons(markedActors, ObjectiveIcons, 0);
	I = activeIndex;
	J0x3FE:

	// End:0x44E [Loop If]
	if(I < ObjectiveIcons.Length)
	{
		ObjectiveIcons[I].SetVisible(false);
		I++;
		// [Loop Continue]
		goto J0x3FE;
	}
	UpdateObjectiveZones(defendZones);
	UpdateObjectiveDefendTargets(defendTargets);
	//return;	
}

function GenObjectiveIcon()
{
	local GFxObject IconMC;

	IconMC = IconsObjectiveMC.AttachMovie("minimap_objective", "mm_objective" $ string(IconsObjectiveCount++));
	IconMC.SetFloat("_xscale", 50.0000000);
	IconMC.SetFloat("_yscale", 50.0000000);
	ObjectiveIcons.AddItem(IconMC);
	//return;	
}

function UpdateObjectiveZones(array<DefendZone> Zones)
{
	local DefendZone currentZone;
	local Trigger zoneTrigger;
	local int I, activeIndex;
	local array<MinimapActorData> markedZones;
	local array<float> zoneStatuses;

	// End:0xFF
	foreach Zones(currentZone)
	{
		zoneTrigger = Trigger(currentZone.Zone.Actor);
		// End:0xFE
		if(zoneTrigger != none)
		{
			// End:0x8A
			if(activeIndex == ObjectiveZoneIcons.Length)
			{
				GenObjectiveZoneIcon();
			}
			zoneStatuses.AddItem(currentZone.Value);
			markedZones.Add(1);
			markedZones[markedZones.Length - 1].Actor = zoneTrigger;
			activeIndex++;
		}		
	}	
	UpdateIcons(markedZones, ObjectiveZoneIcons, 1, zoneStatuses);
	I = activeIndex;
	J0x13A:

	// End:0x18A [Loop If]
	if(I < ObjectiveZoneIcons.Length)
	{
		ObjectiveZoneIcons[I].SetVisible(false);
		I++;
		// [Loop Continue]
		goto J0x13A;
	}
	//return;	
}

function GenObjectiveZoneIcon()
{
	local GFxObject IconMC;

	IconMC = IconsObjectiveZoneMC.AttachMovie("minimap_zone", "mm_zone" $ string(IconsObjectiveZoneCount++));
	ObjectiveZoneIcons.AddItem(IconMC);
	//return;	
}

function UpdateObjectiveDefendTargets(array<MinimapActorData> Targets)
{
	local MinimapActorData currentTarget;
	local int I, activeIndex;

	// End:0x45
	foreach Targets(currentTarget)
	{
		// End:0x39
		if(activeIndex == DefendHealthIcons.Length)
		{
			GenObjectiveDefendIcon();
		}
		activeIndex++;		
	}	
	UpdateIcons(Targets, DefendHealthIcons, 2, DefendTargetLastHealth, DefendDamagedIcons);
	I = activeIndex;
	J0x89:

	// End:0x103 [Loop If]
	if(I < DefendHealthIcons.Length)
	{
		DefendHealthIcons[I].SetVisible(false);
		DefendDamagedIcons[I].SetVisible(false);
		I++;
		// [Loop Continue]
		goto J0x89;
	}
	//return;	
}

function GenObjectiveDefendIcon()
{
	local GFxObject IconMC;

	IconMC = IconsObjectiveDefendMC.AttachMovie("minimap_defendHealth", "mm_defendH" $ string(IconsObjectiveDefendCount++));
	IconMC.SetFloat("_xscale", 50.0000000);
	IconMC.SetFloat("_yscale", 50.0000000);
	DefendHealthIcons.AddItem(IconMC);
	IconMC = IconsObjectiveDefendMC.AttachMovie("minimap_defendDamaged", "mm_defendD" $ string(IconsObjectiveDefendCount));
	IconMC.SetFloat("_xscale", 50.0000000);
	IconMC.SetFloat("_yscale", 50.0000000);
	DefendDamagedIcons.AddItem(IconMC);
	DefendTargetLastHealth.AddItem(-1.0000000);
	//return;	
}

function GenPowerCoreIcons(int N)
{
	local GFxObject IconMC;
	local int I;

	I = 0;
	J0x0B:

	// End:0x2D9 [Loop If]
	if(I < N)
	{
		IconMC = IconsPowerCoreMC.AttachMovie("powerCore", "powerCore" $ string(I));
		IconMC.SetFloat("_xscale", 50.0000000);
		IconMC.SetFloat("_yscale", 50.0000000);
		PowerCoreIcons.AddItem(IconMC);
		IconMC = IconsPowerCoreMC.AttachMovie("powerCoreDamaged", "powerCoreDamaged" $ string(I));
		IconMC.SetVisible(false);
		IconMC.SetFloat("_xscale", 50.0000000);
		IconMC.SetFloat("_yscale", 50.0000000);
		PowerCoreDamaged.AddItem(IconMC);
		IconMC = IconsPowerCoreMC.AttachMovie("powerCoreDesignation", "powerCoreDesignation" $ string(I));
		IconMC.GotoAndStopI(I + 1);
		IconMC.SetFloat("_xscale", 50.0000000);
		IconMC.SetFloat("_yscale", 50.0000000);
		PowerCoreDesignations.AddItem(IconMC);
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function SetPowerCoreLocation(Vector Location, int Index)
{
	PowerCoreLocations[Index] = Location;
	//return;	
}

function UpdatePowerCoreIcon(int Index, optional int newFrame = -1)
{
	local ASDisplayInfo D;
	local Vector V;

	V = TransformVector(IconMatrix, PowerCoreLocations[Index]);
	// End:0x7D
	if(VSizeSq(V) > (Radius * Radius))
	{
		V = Normal(V) * Radius;
	}
	D.hasX = true;
	D.hasY = true;
	D.X = V.X;
	D.Y = V.Y;
	PowerCoreIcons[Index].SetDisplayInfo(D);
	PowerCoreDesignations[Index].SetDisplayInfo(D);
	PowerCoreDamaged[Index].SetDisplayInfo(D);
	// End:0x208
	if(newFrame != -1)
	{
		PowerCoreIcons[Index].GotoAndStopI(newFrame);
	}
	//return;	
}

function SetPowerCoreDamaged(int Index, bool IsBeingDamaged)
{
	// End:0x64
	if(IsBeingDamaged)
	{
		PowerCoreDamaged[Index].GotoAndPlayI(1);
		PowerCoreDamaged[Index].SetVisible(true);		
	}
	else
	{
		PowerCoreDamaged[Index].SetVisible(false);
	}
	//return;	
}

function UpdateIcons(out array<MinimapActorData> ActorData, out array<GFxObject> ActorIcons, int iconType, optional out array<float> ActorHealth, optional out array<GFxObject> DamagedIcons)
{
	local ASDisplayInfo D;
	local array<GFxObject> Icons;
	local int I;
	local bool doShowHealth, doShowDamaged;
	local float currentHealth;
	local Vector V;
	local GFxObject val;
	local UTVehicle UTV;
	local Pawn P;
	local HaloDestructibleActor HDA;
	local Vector TV;
	local Rotator TR;
	local float zoneSize;

	D.hasVisible = true;
	// End:0x327
	if(((iconType != 0) && iconType != 2) && iconType != 1)
	{
		// End:0x29C
		if(ActorIcons.Length < ActorData.Length)
		{
			switch(iconType)
			{
				// End:0xD0
				case 4:
					Icons = GenMinimapIcons(ActorData.Length - ActorIcons.Length, Container_Warthog, "mmi_warthog", IconCount_Warthog);
					// End:0x26A
					break;
				// End:0x122
				case 5:
					Icons = GenMinimapIcons(ActorData.Length - ActorIcons.Length, Container_Mongoose, "mmi_mongoose", IconCount_Mongoose);
					// End:0x26A
					break;
				// End:0x174
				case 6:
					Icons = GenMinimapIcons(ActorData.Length - ActorIcons.Length, Container_Scorpion, "mmi_scorpion", IconCount_Scorpion);
					// End:0x26A
					break;
				// End:0x1C3
				case 7:
					Icons = GenMinimapIcons(ActorData.Length - ActorIcons.Length, Container_Ghost, "mmi_ghost", IconCount_Ghost);
					// End:0x26A
					break;
				// End:0x21C
				case 8:
					Icons = GenMinimapIconsWithMeter(ActorData.Length - ActorIcons.Length, Container_Turret, "mmi_turret", IconCount_Turret, TurretLastHealth);
					// End:0x26A
					break;
				// End:0xFFFF
				default:
					Icons = GenMinimapIcons(ActorData.Length - ActorIcons.Length, Container_Player, "mmi_player", IconCount_Player);
					// End:0x26A
					break;
					break;
			}
			// End:0x298
			foreach Icons(val)
			{
				ActorIcons.AddItem(val);				
			}						
		}
		else
		{
			D.Visible = false;
			I = ActorData.Length;
			J0x2CF:

			// End:0x327 [Loop If]
			if(I < ActorIcons.Length)
			{
				ActorIcons[I].SetDisplayInfo(D);
				I++;
				// [Loop Continue]
				goto J0x2CF;
			}
		}
	}
	D.hasX = true;
	D.hasY = true;
	D.Visible = true;
	doShowHealth = ActorHealth.Length > 0;
	doShowDamaged = DamagedIcons.Length > 0;
	I = 0;
	J0x3BF:

	// End:0xC4F [Loop If]
	if(I < ActorData.Length)
	{
		// End:0x45A
		if(((iconType != 0) && iconType != 2) && iconType != 1)
		{
			ActorIcons[I].GotoAndStopI(int(ActorData[I].TeamFrame));
		}
		V = TransformVector(IconMatrix, ActorData[I].Actor.Location);
		// End:0x60A
		if((((iconType == 4) || iconType == 5) || iconType == 6) || iconType == 7)
		{
			D.hasRotation = true;
			D.Rotation = float((PlayerOwner.PlayerCamera.ViewTarget.POV.Rotation.Yaw - ActorData[I].Actor.Rotation.Yaw) & 65535) * (-360.0000000 / 65536.0000000);			
		}
		else
		{
			// End:0x762
			if(iconType == 8)
			{
				UTV = UTVehicle(ActorData[I].Actor);
				UTV.GetBarrelLocationAndRotation(0, TV, TR);
				D.hasRotation = true;
				D.Rotation = float((PlayerOwner.PlayerCamera.ViewTarget.POV.Rotation.Yaw - TR.Yaw) & 65535) * (-360.0000000 / 65536.0000000);
			}
		}
		// End:0x7C7
		if((iconType == 0) || iconType == 2)
		{
			// End:0x7C7
			if(VSizeSq(V) > (Radius * Radius))
			{
				V = Normal(V) * Radius;
			}
		}
		// End:0x910
		if(iconType == 1)
		{
			zoneSize = (Trigger(ActorData[I].Actor).CylinderComponent.CollisionRadius / CurZoom) * 2.0000000;
			ActorIcons[I].SetFloat("_width", zoneSize);
			ActorIcons[I].SetFloat("_height", zoneSize);
			ActorIcons[I].GotoAndStopI(int(ActorHealth[I] + float(101)));
			doShowHealth = false;
		}
		// End:0xB5E
		if(doShowHealth)
		{
			P = Pawn(ActorData[I].Actor);
			// End:0x9B4
			if(P != none)
			{
				currentHealth = float(P.Health) / float(P.HealthMax);				
			}
			else
			{
				HDA = HaloDestructibleActor(ActorData[I].Actor);
				// End:0xA48
				if(HDA != none)
				{
					currentHealth = float(HDA.Health) / float(HDA.HealthMax);
				}
			}
			// End:0xB5E
			if(currentHealth != ActorHealth[I])
			{
				ActorIcons[I].GotoAndStopI(int((currentHealth * float(100)) + float(1)));
				// End:0xB41
				if(doShowDamaged)
				{
					// End:0xB41
					if(currentHealth < ActorHealth[I])
					{
						// End:0xB41
						if(DamagedIcons[I].GetFloat("_currentframe") == float(1))
						{
							DamagedIcons[I].GotoAndPlayI(2);
						}
					}
				}
				ActorHealth[I] = currentHealth;
			}
		}
		D.X = V.X;
		D.Y = V.Y;
		ActorIcons[I].SetDisplayInfo(D);
		// End:0xC41
		if(doShowDamaged)
		{
			DamagedIcons[I].SetDisplayInfo(D);
		}
		I++;
		// [Loop Continue]
		goto J0x3BF;
	}
	//return;	
}

function Update()
{
	local Pawn P;
	local byte myTeamNum;
	local ASDisplayInfo D;
	local array<MinimapActorData> Actors_Player, Actors_Warthog, Actors_Mongoose, Actors_Scorpion, Actors_Ghost, Actors_Turret;

	local UTPawn UTP;
	local UTVehicle UTV;
	local float F;
	local PlayerController PC;
	local HaloVehicle_ArcadeWarthog HV_W;
	local HaloVehicle_ArcadeMongoose HV_M;
	local HaloVehicle_ArcadeScorpion HV_S;
	local HaloVehicle_Ghost HV_G;
	local HaloTurret HT;
	local int addedItemIdx;
	local float Scale;

	PC = PlayerOwner;
	Scale = 1.0000000 / CurZoom;
	// End:0x53
	if(PC.Pawn == none)
	{
		return;
	}
	// End:0x6A
	if(bNeedsUpdateData)
	{
		UpdateData();
	}
	// End:0xCC
	if(PC.Pawn != none)
	{
		myTeamNum = PC.Pawn.GetTeamNum();
	}
	HV_W = HaloVehicle_ArcadeWarthog(PC.Pawn);
	HV_M = HaloVehicle_ArcadeMongoose(PC.Pawn);
	HV_S = HaloVehicle_ArcadeScorpion(PC.Pawn);
	HV_G = HaloVehicle_Ghost(PC.Pawn);
	HT = HaloTurret(PC.Pawn);
	// End:0x219
	if(HV_W != none)
	{
		// End:0x216
		if(playerIconType != 4)
		{
			playerIconType = 4;
			PlayerIcon.GotoAndStop("inWarthog");
		}		
	}
	else
	{
		// End:0x272
		if(HV_M != none)
		{
			// End:0x26F
			if(playerIconType != 5)
			{
				playerIconType = 5;
				PlayerIcon.GotoAndStop("inMongoose");
			}			
		}
		else
		{
			// End:0x2CB
			if(HV_S != none)
			{
				// End:0x2C8
				if(playerIconType != 6)
				{
					playerIconType = 6;
					PlayerIcon.GotoAndStop("inScorpion");
				}				
			}
			else
			{
				// End:0x321
				if(HV_G != none)
				{
					// End:0x31E
					if(playerIconType != 7)
					{
						playerIconType = 7;
						PlayerIcon.GotoAndStop("inGhost");
					}					
				}
				else
				{
					// End:0x378
					if(HT != none)
					{
						// End:0x375
						if(playerIconType != 8)
						{
							playerIconType = 8;
							PlayerIcon.GotoAndStop("inTurret");
						}						
					}
					else
					{
						// End:0x3BB
						if(playerIconType != 3)
						{
							playerIconType = 3;
							PlayerIcon.GotoAndStop("onFoot");
						}
					}
				}
			}
		}
	}
	D.hasRotation = true;
	D.Rotation = float(PC.PlayerCamera.ViewTarget.POV.Rotation.Yaw & 65535) * (-360.0000000 / 65536.0000000);
	CompassIcon.SetDisplayInfo(D);
	D.Rotation = D.Rotation - (float(PC.Rotation.Yaw & 65535) * (-360.0000000 / 65536.0000000));
	PlayerIcon.SetDisplayInfo(D);
	F = float((PC.PlayerCamera.ViewTarget.POV.Rotation.Yaw + 16384) & 65535-) * (3.1415927 / 32768.0000000);
	IconMatrix.XPlane.X = Cos(F) * Scale;
	IconMatrix.XPlane.Y = Sin(F) * Scale;
	IconMatrix.YPlane.X = Sin(F)- * Scale;
	IconMatrix.YPlane.Y = Cos(F) * Scale;
	IconMatrix.WPlane.X = 0.0000000;
	IconMatrix.WPlane.Y = 0.0000000;
	IconMatrix.WPlane.Z = 0.0000000;
	IconMatrix.WPlane.W = 1.0000000;
	IconMatrix.WPlane = TransformVector(IconMatrix, PC.Pawn.Location-);
	D.hasRotation = false;
	// End:0x115E
	foreach ThisWorld.AllPawns(Class'Engine.Pawn', P)
	{
		// End:0x94F
		if((((P.bHidden || P.Health <= 0) || P.IsInvisible()) || P.DrivenVehicle != none) || P == PC.Pawn)
		{
			continue;			
		}
		UTP = UTPawn(P);
		UTV = UTVehicle(P);
		// End:0x9AB
		if((UTP == none) && UTV == none)
		{
			continue;			
		}
		HV_W = HaloVehicle_ArcadeWarthog(P);
		HV_M = HaloVehicle_ArcadeMongoose(P);
		HV_S = HaloVehicle_ArcadeScorpion(P);
		HV_G = HaloVehicle_Ghost(P);
		HT = HaloTurret(P);
		// End:0xB73
		if(HV_W != none)
		{
			Actors_Warthog.Add(1);
			addedItemIdx = Actors_Warthog.Length - 1;
			Actors_Warthog[addedItemIdx].Actor = P;
			// End:0xAEA
			if(HV_W.GetFirstAvailableSeat() == 0)
			{
				Actors_Warthog[addedItemIdx].TeamFrame = 1;				
			}
			else
			{
				// End:0xB47
				if(int(HV_W.GetTeamNum()) == int(myTeamNum))
				{
					Actors_Warthog[addedItemIdx].TeamFrame = 2;					
				}
				else
				{
					Actors_Warthog[addedItemIdx].TeamFrame = 3;
				}
			}
			// End:0x115D
			continue;
		}
		// End:0xCAF
		if(HV_M != none)
		{
			Actors_Mongoose.Add(1);
			addedItemIdx = Actors_Mongoose.Length - 1;
			Actors_Mongoose[addedItemIdx].Actor = P;
			// End:0xC26
			if(HV_M.GetFirstAvailableSeat() == 0)
			{
				Actors_Mongoose[addedItemIdx].TeamFrame = 1;				
			}
			else
			{
				// End:0xC83
				if(int(HV_M.GetTeamNum()) == int(myTeamNum))
				{
					Actors_Mongoose[addedItemIdx].TeamFrame = 2;					
				}
				else
				{
					Actors_Mongoose[addedItemIdx].TeamFrame = 3;
				}
			}
			// End:0x115D
			continue;
		}
		// End:0xDEB
		if(HV_S != none)
		{
			Actors_Scorpion.Add(1);
			addedItemIdx = Actors_Scorpion.Length - 1;
			Actors_Scorpion[addedItemIdx].Actor = P;
			// End:0xD62
			if(HV_S.GetFirstAvailableSeat() == 0)
			{
				Actors_Scorpion[addedItemIdx].TeamFrame = 1;				
			}
			else
			{
				// End:0xDBF
				if(int(HV_S.GetTeamNum()) == int(myTeamNum))
				{
					Actors_Scorpion[addedItemIdx].TeamFrame = 2;					
				}
				else
				{
					Actors_Scorpion[addedItemIdx].TeamFrame = 3;
				}
			}
			// End:0x115D
			continue;
		}
		// End:0xF27
		if(HV_G != none)
		{
			Actors_Ghost.Add(1);
			addedItemIdx = Actors_Ghost.Length - 1;
			Actors_Ghost[addedItemIdx].Actor = P;
			// End:0xE9E
			if(HV_G.GetFirstAvailableSeat() == 0)
			{
				Actors_Ghost[addedItemIdx].TeamFrame = 1;				
			}
			else
			{
				// End:0xEFB
				if(int(HV_G.GetTeamNum()) == int(myTeamNum))
				{
					Actors_Ghost[addedItemIdx].TeamFrame = 2;					
				}
				else
				{
					Actors_Ghost[addedItemIdx].TeamFrame = 3;
				}
			}
			// End:0x115D
			continue;
		}
		// End:0x1063
		if(HT != none)
		{
			Actors_Turret.Add(1);
			addedItemIdx = Actors_Turret.Length - 1;
			Actors_Turret[addedItemIdx].Actor = P;
			// End:0xFDA
			if(HT.GetFirstAvailableSeat() == 0)
			{
				Actors_Turret[addedItemIdx].TeamFrame = 1;				
			}
			else
			{
				// End:0x1037
				if(int(HT.GetTeamNum()) == int(myTeamNum))
				{
					Actors_Turret[addedItemIdx].TeamFrame = 2;					
				}
				else
				{
					Actors_Turret[addedItemIdx].TeamFrame = 3;
				}
			}
			// End:0x115D
			continue;
		}
		Actors_Player.Add(1);
		addedItemIdx = Actors_Player.Length - 1;
		Actors_Player[addedItemIdx].Actor = P;
		// End:0x115D
		if(HaloPawn(P) != none)
		{
			// End:0x1134
			if(int(HaloPawn(P).GetTeamNum()) == int(myTeamNum))
			{
				Actors_Player[addedItemIdx].TeamFrame = 2;
				// End:0x115D
				continue;
			}
			Actors_Player[addedItemIdx].TeamFrame = 3;
		}		
	}	
	UpdateIcons(Actors_Player, Icons_Player, 3);
	UpdateIcons(Actors_Warthog, Icons_Warthog, 4);
	UpdateIcons(Actors_Mongoose, Icons_Mongoose, 5);
	UpdateIcons(Actors_Scorpion, Icons_Scorpion, 6);
	UpdateIcons(Actors_Ghost, Icons_Ghost, 7);
	UpdateIcons(Actors_Turret, Icons_Turret, 8);
	//return;	
}

function ZoomIn()
{
	CurZoom = FMin(CurZoom * 2.0000000, MaxZoom);
	//return;	
}

function ZoomOut()
{
	CurZoom = FMax(CurZoom * 0.5000000, MinZoom);
	//return;	
}

defaultproperties
{
	CurZoom=64.0000000
	NormalZoom=64.0000000
	MaxZoom=128.0000000
	MinZoom=16.0000000
	Radius=90.0000000
}