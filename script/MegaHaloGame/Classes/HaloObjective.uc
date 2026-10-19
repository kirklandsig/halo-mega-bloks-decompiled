class HaloObjective extends Object
	config(HUDMarkers)
	implements(HaloSaveInterface);

enum EObjectiveStatus
{
	MOS_Pending,                    // 0
	MOS_Complete,                   // 1
	MOS_Failed,                     // 2
	MOS_MAX                         // 3
};

enum EObjectiveMarker
{
	OMN_None,                       // 0
	OMN_Inactive,                   // 1
	OMN_Defend,                     // 2
	OMN_Location,                   // 3
	OMN_Takedown,                   // 4
	OMN_Use,                        // 5
	OMN_Zone,                       // 6
	OMN_Chase,                      // 7
	OMN_Flee,                       // 8
	OMN_MAX                         // 9
};

enum EObjectivePlayerCount
{
	OPC_None,                       // 0
	OPC_One,                        // 1
	OPC_All,                        // 2
	OPC_MAX                         // 3
};

struct ObjectiveMarkerData
{
	var Actor Actor;
	var HaloObjective.EObjectiveMarker Marker;
	var bool bDraw;
	var bool bDrawTagSymbol;
	var bool bShowHealth;
	var bool bShowDistance;
	var bool bClampToScreen;

	structdefaultproperties
	{
		Actor=none
		Marker=OMN_None
		bDraw=true
		bDrawTagSymbol=false
		bShowHealth=false
		bShowDistance=false
		bClampToScreen=true
	}
};

struct ObjectiveRewardData
{
	var int BlokTotal;
	var name DeployableUnlock;

	structdefaultproperties
	{
		BlokTotal=0
		DeployableUnlock="None"
	}
};

struct ObjectiveMarker
{
	var Actor Actor;
	var HaloObjective.EObjectiveMarker Type;
	var Vector2D ScreenLocation;
	var MaterialInstanceConstant Icon;
	var Vector2D iconOffset;
	var Vector2D IconSize;
	var bool bShowDistance;
	var bool bShowHealth;
	var MaterialInstanceConstant Health;

	structdefaultproperties
	{
		Actor=none
		Type=OMN_None
		ScreenLocation=(X=-64.0000000,Y=-64.0000000)
		Icon=none
		iconOffset=(X=-32.0000000,Y=-32.0000000)
		IconSize=(X=64.0000000,Y=64.0000000)
		bShowDistance=false
		bShowHealth=false
		Health=none
	}
};

struct IconData
{
	var HaloObjective.EObjectiveMarker Type;
	var Texture2D Icon;
	var Vector2D Size;
	var Vector2D Offset;

	structdefaultproperties
	{
		Type=OMN_None
		Icon=none
		Size=(X=0.0000000,Y=0.0000000)
		Offset=(X=0.0000000,Y=0.0000000)
	}
};

var array<ObjectiveMarker> Markers;
var config array<config IconData> Icons;
var name ObjectiveName;
var bool bIsPrimaryObjective;
var bool bIsTimed;
var bool bUseNavigation;
var bool bShowStartMessage;
var bool bShowCompleteMessage;
var float TimeLimit;
var byte Priority;
var ObjectiveRewardData Reward;
var string DisplayName;
var string RedisplayName;
var string DisplayDescription;
var float DisplayTime;
var string IconFrame;
var AkEvent OnStartSound;
var AkEvent OnCompleteSound;
var AkEvent OnFailSound;
var float ReNotifyTimer;
var float ReNotifyInterval;
var float Timer;
var HaloMission MissionOwner;
var SeqAct_StartObjective KismetOwner;
var const localized string ObjectiveCompleteMessage;
//var delegate<PCDelegate> __PCDelegate__Delegate;

delegate PCDelegate(HaloPlayerPawnController PC, Object param1)
{
	//return;	
}

function Start()
{
	local HaloGameDefault Game;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x150
	if(Game != none)
	{
		MissionOwner = Game.GetActiveMission();
		// End:0x111
		if(MissionOwner != none)
		{
			// End:0x10E
			if(MissionOwner.AddObjective(self) == true)
			{
				LogInternal("Starting Objective: " $ string(ObjectiveName));
				PlaySound(OnStartSound);
				// End:0x104
				if(bShowStartMessage)
				{
					AnnounceObjectiveStart();
				}
				CreateObjectiveMarkers();
			}			
		}
		else
		{
			WarnInternal(("No active Mission; " $ string(ObjectiveName)) $ " will not be started");
		}		
	}
	else
	{
		WarnInternal(("Game is not of type HaloGameDefault; " $ string(ObjectiveName)) $ " will not be started");
	}
	Timer = TimeLimit;
	UpdateCompassWaypoint();
	//return;	
}

function Complete()
{
	LogInternal("Completed Objective: " $ string(ObjectiveName));
	MissionOwner.GameOwner.CompletedObjectives.AddItem(self);
	MissionOwner.CompletedObjectives.AddItem(self);
	GiveReward();
	PlaySound(OnCompleteSound);
	SendStatusEvent(name(string(ObjectiveName) $ "_Complete"));
	UpdateCompassWaypoint();
	// End:0xE4
	if(bShowCompleteMessage)
	{
		AnnounceObjectiveComplete();
	}
	// End:0x11D
	if(KismetOwner != none)
	{
		KismetOwner.Complete();
		KismetOwner = none;
	}
	Term();
	//return;	
}

function Fail()
{
	LogInternal("Failed Objective: " $ string(ObjectiveName));
	PlaySound(OnFailSound);
	SendStatusEvent(name(string(ObjectiveName) $ "_Failed"));
	UpdateCompassWaypoint();
	// End:0x9C
	if(KismetOwner != none)
	{
		KismetOwner.Fail();
		KismetOwner = none;
	}
	Term();
	//return;	
}

static function SendStatusEvent(name EventName)
{
	local array<SequenceObject> AllSeqEvents;
	local WorldInfo WorldInfo;
	local Sequence GameSeq;
	local int I;

	WorldInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
	GameSeq = WorldInfo.GetGameSequence();
	// End:0x145
	if(GameSeq != none)
	{
		GameSeq.FindSeqObjectsByClass(Class'Engine.SeqEvent_RemoteEvent', true, AllSeqEvents);
		I = 0;
		J0x9E:

		// End:0x145 [Loop If]
		if(I < AllSeqEvents.Length)
		{
			// End:0x137
			if(SeqEvent_RemoteEvent(AllSeqEvents[I]).EventName == EventName)
			{
				SeqEvent_RemoteEvent(AllSeqEvents[I]).CheckActivate(WorldInfo, none);
				// [Explicit Break]
				goto J0x145;
			}
			I++;
			// [Loop Continue]
			goto J0x9E;
		}
	}
	J0x145:

	//return;	
}

function Term()
{
	// End:0x3A
	if(MissionOwner != none)
	{
		MissionOwner.QueueObjectiveForRemoval(self);
		MissionOwner = none;
	}
	// End:0x73
	if(KismetOwner != none)
	{
		KismetOwner.Abort();
		KismetOwner = none;
	}
	ClearObjectiveMarkers();
	bIsTimed = false;
	//return;	
}

function Tick(float DeltaTime)
{
	TickMarkers();
	TickStatus(DeltaTime);
	TickTimer(DeltaTime);
	TickReNotify(DeltaTime);
	//return;	
}

function TickMarkers()
{
	//return;	
}

function TickStatus(float DeltaTime)
{
	//return;	
}

function TickTimer(float DeltaTime)
{
	// End:0x3E
	if(bIsTimed)
	{
		Timer -= DeltaTime;
		// End:0x3E
		if(Timer <= 0.0000000)
		{
			Fail();
		}
	}
	//return;	
}

function TickReNotify(float DeltaTime)
{
	ReNotifyTimer += DeltaTime;
	// End:0x44
	if(ReNotifyTimer >= ReNotifyInterval)
	{
		ReannounceObjectiveStart();
		ReNotifyTimer = 0.0000000;
	}
	//return;	
}

function Actor GetNavigationPoint()
{
	return none;
	//return ReturnValue;	
}

function CallDelegateOnAllPCs(optional Object param1 = none)
{
	local HaloPlayerPawnController PC;

	// End:0x75
	foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'MegaHaloGame.HaloPlayerPawnController', PC)
	{
		PCDelegate(PC, param1);		
	}	
	//return;	
}

function GiveReward()
{
	__PCDelegate__Delegate = GiveRewardToPC;
	CallDelegateOnAllPCs();
	//return;	
}

function GiveRewardToPC(HaloPlayerPawnController PC, Object NotUsed)
{
	// End:0xB0
	if(PC != none)
	{
		LogInternal((((("Giving Reward for " $ string(ObjectiveName)) $ ": ") $ string(Reward.BlokTotal)) $ " Bloks to ") $ string(PC));
		PC.AddBloksToBank(Reward.BlokTotal, true);
	}
	//return;	
}

function PlaySound(AkEvent Sound)
{
	// End:0x3D
	if(Sound != none)
	{
		__PCDelegate__Delegate = PlaySoundOnPC;
		CallDelegateOnAllPCs(Sound);
	}
	//return;	
}

function PlaySoundOnPC(HaloPlayerPawnController PC, Object SoundToPlay)
{
	// End:0x46
	if(PC != none)
	{
		PC.PlayAkEvent(AkEvent(SoundToPlay));
	}
	//return;	
}

function UpdateCompassWaypoint()
{
	__PCDelegate__Delegate = UpdatePCCompassWaypoint;
	CallDelegateOnAllPCs();
	//return;	
}

function UpdatePCCompassWaypoint(HaloPlayerPawnController PC, Object NotUsed)
{
	// End:0x30
	if(PC != none)
	{
		PC.bUpdateCompassPath = true;
	}
	//return;	
}

function AnnounceObjectiveStart()
{
	// End:0x36
	if(DisplayName != "")
	{
		__PCDelegate__Delegate = AnnounceObjectiveStartToPC;
		CallDelegateOnAllPCs();
	}
	//return;	
}

function AnnounceObjectiveStartToPC(HaloPlayerPawnController PC, Object NotUsed)
{
	local GFxHaloHUD HUD;

	// End:0xCB
	if(PC != none)
	{
		HUD = GFxHaloHUD(PC.myHUD);
		// End:0xCB
		if(HUD != none)
		{
			// End:0xCB
			if(HUD.HudMovie != none)
			{
				HUD.HudMovie.ShowGameMessage(DisplayName, DisplayDescription, DisplayTime, AkEvent'UIHUD.Play_UI_Objective_Appear');
			}
		}
	}
	//return;	
}

function ReannounceObjectiveStart()
{
	// End:0x36
	if(RedisplayName != "")
	{
		__PCDelegate__Delegate = ReannounceObjectiveStartToPC;
		CallDelegateOnAllPCs();
	}
	//return;	
}

function ReannounceObjectiveStartToPC(HaloPlayerPawnController PC, Object NotUsed)
{
	local GFxHaloHUD HUD;

	// End:0xC3
	if(PC != none)
	{
		HUD = GFxHaloHUD(PC.myHUD);
		// End:0xC3
		if(HUD != none)
		{
			// End:0xC3
			if(HUD.HudMovie != none)
			{
				HUD.HudMovie.ShowUpdateMessage(DisplayDescription, DisplayTime, IconFrame);
			}
		}
	}
	//return;	
}

function AnnounceObjectiveComplete()
{
	// End:0x36
	if(DisplayName != "")
	{
		__PCDelegate__Delegate = AnnounceObjectiveCompleteToPC;
		CallDelegateOnAllPCs();
	}
	//return;	
}

function AnnounceObjectiveCompleteToPC(HaloPlayerPawnController PC, Object NotUsed)
{
	local GFxHaloHUD HUD;

	// End:0xBC
	if(PC != none)
	{
		HUD = GFxHaloHUD(PC.myHUD);
		// End:0xBC
		if(HUD != none)
		{
			// End:0xBC
			if(HUD.HudMovie != none)
			{
				HUD.HudMovie.ShowGameMessage(ObjectiveCompleteMessage, "", DisplayTime);
			}
		}
	}
	//return;	
}

function CreateObjectiveMarkers()
{
	//return;	
}

function ClearObjectiveMarkers()
{
	Markers.Length = 0;
	//return;	
}

function AddObjectiveMarker(ObjectiveMarkerData Data)
{
	local int MarkerIndex;

	MarkerIndex = Markers.Find('Actor', Data.Actor);
	// End:0x62
	if(MarkerIndex == -1)
	{
		CreateObjectiveMarker(Data);
	}
	//return;	
}

function RemoveObjectiveMarker(ObjectiveMarkerData Data)
{
	local int MarkerIndex;

	MarkerIndex = Markers.Find('Actor', Data.Actor);
	// End:0x64
	if(MarkerIndex != -1)
	{
		Markers.Remove(MarkerIndex, 1);
	}
	//return;	
}

function bool GetObjectiveMarker(ObjectiveMarkerData Data, out ObjectiveMarker Marker)
{
	local int MarkerIndex;

	MarkerIndex = Markers.Find('Actor', Data.Actor);
	// End:0x6E
	if(MarkerIndex != -1)
	{
		Marker = Markers[MarkerIndex];
		return true;
	}
	return false;
	//return ReturnValue;	
}

function CreateObjectiveMarker(ObjectiveMarkerData Data)
{
	local int IconIndex;
	local ObjectiveMarker Marker;
	local MaterialInstanceConstant IconMIC, HealthMIC;

	// End:0x49
	if((Data.Actor == none) || Data.bDraw == false)
	{
		return;
	}
	IconIndex = Icons.Find('Type', Data.Marker);
	// End:0x454
	if(IconIndex != -1)
	{
		IconMIC = new Class'Engine.MaterialInstanceConstant';
		IconMIC.SetParent(Material'mainhud.ObjectiveMarkers.ObjectiveMarker_Mat');
		IconMIC.SetTextureParameterValue('Icon', Icons[IconIndex].Icon);
		// End:0x244
		if(Data.bDrawTagSymbol)
		{
			switch(Data.Actor.Tag)
			{
				// End:0x1C1
				case 'HaloPowerCorePawnAlpha':
					IconMIC.SetTextureParameterValue('Designation', Texture2D'mainhud.ObjectiveMarkers.OMDesignation_Alpha');
					// End:0x244
					break;
				// End:0x201
				case 'HaloPowerCorePawnBravo':
					IconMIC.SetTextureParameterValue('Designation', Texture2D'mainhud.ObjectiveMarkers.OMDesignation_Bravo');
					// End:0x244
					break;
				// End:0x241
				case 'HaloPowerCorePawnCharlie':
					IconMIC.SetTextureParameterValue('Designation', Texture2D'mainhud.ObjectiveMarkers.OMDesignation_Charlie');
					// End:0x244
					break;
				// End:0xFFFF
				default:
					break;
			}
		}
		HealthMIC = new Class'Engine.MaterialInstanceConstant';
		HealthMIC.SetParent(Material'mainhud.ObjectiveMarkers.ObjectiveHealthBar_Mat');
		Marker.Actor = Data.Actor;
		Marker.Type = Data.Marker;
		Marker.Icon = IconMIC;
		Marker.iconOffset = Icons[IconIndex].Offset;
		Marker.IconSize = Icons[IconIndex].Size;
		Marker.bShowDistance = Data.bShowDistance;
		Marker.bShowHealth = Data.bShowHealth;
		Marker.Health = HealthMIC;
		Markers.AddItem(Marker);
		//return;		
	}
}

function PostRender(Canvas Canvas, GFxHaloMinimapHUD HUD, Pawn Pawn)
{
	local int I;
	local bool bActorHasHealth;
	local Vector WorldLocation, ScreenLocation;
	local Actor Actor;
	local ObjectiveMarker Marker;

	// End:0x22
	if((Canvas == none) || HUD == none)
	{
		return;
	}
	I = 0;
	J0x2D:

	// End:0x42D [Loop If]
	if(I < Markers.Length)
	{
		Marker = Markers[I];
		Actor = Marker.Actor;
		// End:0x408
		if(Actor != none)
		{
			// End:0x1B5
			if(Actor.IsA('Pawn') || Actor.IsA('HaloDestructibleActor'))
			{
				WorldLocation = Actor.CollisionComponent.Bounds.Origin;
				WorldLocation.Z += Actor.CollisionComponent.Bounds.BoxExtent.Z;
				bActorHasHealth = true;				
			}
			else
			{
				WorldLocation = Actor.Location;
				bActorHasHealth = false;
			}
			// End:0x405
			if(HUD.IsInfrontOfCamera(WorldLocation))
			{
				HUD.Project(WorldLocation, ScreenLocation);
				Marker.ScreenLocation.X = ScreenLocation.X + Marker.iconOffset.X;
				Marker.ScreenLocation.Y = ScreenLocation.Y + Marker.iconOffset.Y;
				DrawIcon(Canvas, Marker);
				// End:0x3BA
				if(Marker.bShowDistance && Pawn != none)
				{
					DrawDistance(Canvas, HUD, Pawn, Marker);
				}
				// End:0x405
				if(Marker.bShowHealth && bActorHasHealth)
				{
					DrawHealth(Canvas, Marker);
				}
			}			
		}
		else
		{
			Markers.Remove(I--, 1);
		}
		I++;
		// [Loop Continue]
		goto J0x2D;
	}
	//return;	
}

function DrawIcon(Canvas Canvas, ObjectiveMarker Marker)
{
	Canvas.SetPos(Marker.ScreenLocation.X, Marker.ScreenLocation.Y);
	Canvas.DrawMaterialTile(Marker.Icon, 64.0000000, 64.0000000,,,,, true);
	//return;	
}

function DrawDistance(Canvas Canvas, GFxHaloMinimapHUD HUD, Pawn Pawn, ObjectiveMarker Marker)
{
	local float Distance, StringWidth, StringHeight;
	local string DistanceString;
	local Vector2D ScreenLocation;
	local FontRenderInfo FontRenderInfo;

	Distance = VSize(Pawn.Location - Marker.Actor.Location);
	DistanceString = HUD.GetMeterString(Distance);
	Canvas.TextSize(DistanceString, StringWidth, StringHeight);
	ScreenLocation.X = (Marker.ScreenLocation.X + Marker.IconSize.X) + 3.0000000;
	ScreenLocation.Y = Marker.ScreenLocation.Y + ((Marker.IconSize.Y - StringHeight) * 0.5000000);
	Canvas.Font = Font'UI_FontLibrary.Font_ObjectiveMarker';
	FontRenderInfo = Canvas.CreateFontRenderInfo(true, true);
	Canvas.SetDrawColor(255, 255, 255);
	Canvas.SetPos(ScreenLocation.X, ScreenLocation.Y);
	Canvas.DrawText(DistanceString,,,, FontRenderInfo);
	//return;	
}

function DrawHealth(Canvas Canvas, ObjectiveMarker Marker)
{
	local float HP;
	local Vector2D Offset, ScreenLocation;
	local Pawn Pawn;
	local HaloDestructibleActor HDA;

	Pawn = Pawn(Marker.Actor);
	// End:0x8D
	if(Pawn != none)
	{
		HP = float(Pawn.Health) / float(Pawn.HealthMax);		
	}
	else
	{
		HDA = HaloDestructibleActor(Marker.Actor);
		// End:0x11A
		if(HDA != none)
		{
			HP = float(HDA.Health) / float(HDA.HealthMax);			
		}
		else
		{
			HP = 0.0000000;
		}
	}
	Offset.X = (Marker.IconSize.X - 32.0000000) * 0.5000000;
	Offset.Y = Marker.IconSize.Y + 3.0000000;
	ScreenLocation = Add_Vector2DVector2D(Marker.ScreenLocation, Offset);
	Marker.Health.SetScalarParameterValue('Health', HP);
	Canvas.SetPos(ScreenLocation.X, ScreenLocation.Y);
	Canvas.DrawMaterialTile(Marker.Health, 32.0000000, 4.0000000,,,,, true);
	//return;	
}

function JsonObject Serialize()
{
	local JsonObject Data;

	Data = new Class'Engine.JsonObject';
	// End:0x142
	if(Data != none)
	{
		Data.SetStringValue("Name", PathName(self));
		Data.SetStringValue("ObjectArchetype", PathName(ObjectArchetype));
		Data.SetStringValue("ObjectiveName", string(ObjectiveName));
		Data.SetBoolValue("IsPrimary", bIsPrimaryObjective);
		Data.SetStringValue("SeqName", PathName(KismetOwner));
	}
	return Data;
	//return ReturnValue;	
}

function Deserialize(JsonObject Data)
{
	local array<SequenceObject> AllSeqEvents;
	local WorldInfo WorldInfo;
	local Sequence GameSeq;
	local string SeqName;
	local int I;

	ObjectiveName = name(Data.GetStringValue("ObjectiveName"));
	bIsPrimaryObjective = Data.GetBoolValue("IsPrimary");
	SeqName = Data.GetStringValue("SeqName");
	// End:0x22F
	if((SeqName != "") && SeqName != "None")
	{
		WorldInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
		GameSeq = WorldInfo.GetGameSequence();
		// End:0x22F
		if(GameSeq != none)
		{
			GameSeq.FindSeqObjectsByClass(Class'MegaHaloGame.SeqAct_StartObjective', true, AllSeqEvents);
			I = 0;
			J0x165:

			// End:0x1E2 [Loop If]
			if(I < AllSeqEvents.Length)
			{
				// End:0x1D4
				if(InStr(PathName(AllSeqEvents[I]), SeqName) >= 0)
				{
					KismetOwner = SeqAct_StartObjective(AllSeqEvents[I]);
				}
				I++;
				// [Loop Continue]
				goto J0x165;
			}
			// End:0x22F
			if(KismetOwner == none)
			{
				WarnInternal("Could not find kismet owner for sequence name: " $ SeqName);
			}
		}
	}
	//return;	
}

defaultproperties
{
	Icons[0]=(Type=OMN_Inactive,Icon=Texture2D'mainhud.ObjectiveMarkers.OMIcon_Inactive',Size=(X=18.0000000,Y=18.0000000),Offset=(X=-9.0000000,Y=-9.0000000))
	Icons[1]=(Type=OMN_Defend,Icon=Texture2D'mainhud.ObjectiveMarkers.OMIcon_DefendTarget',Size=(X=32.0000000,Y=30.0000000),Offset=(X=-16.0000000,Y=-15.0000000))
	Icons[2]=(Type=OMN_Location,Icon=Texture2D'mainhud.ObjectiveMarkers.OMIcon_Location',Size=(X=32.0000000,Y=32.0000000),Offset=(X=-16.0000000,Y=-16.0000000))
	Icons[3]=(Type=OMN_Takedown,Icon=Texture2D'mainhud.ObjectiveMarkers.OMIcon_TakeDown',Size=(X=20.0000000,Y=36.0000000),Offset=(X=-16.0000000,Y=-18.0000000))
	Icons[4]=(Type=OMN_Use,Icon=Texture2D'mainhud.ObjectiveMarkers.OMIcon_Use',Size=(X=32.0000000,Y=32.0000000),Offset=(X=-28.0000000,Y=-16.0000000))
	Icons[5]=(Type=OMN_Zone,Icon=Texture2D'mainhud.ObjectiveMarkers.OMIcon_DefendZone',Size=(X=32.0000000,Y=30.0000000),Offset=(X=-16.0000000,Y=-15.0000000))
	Icons[6]=(Type=OMN_Chase,Icon=Texture2D'mainhud.ObjectiveMarkers.OMIcon_Chase',Size=(X=32.0000000,Y=32.0000000),Offset=(X=-16.0000000,Y=-16.0000000))
	Icons[7]=(Type=OMN_Flee,Icon=Texture2D'mainhud.ObjectiveMarkers.OMIcon_Flee',Size=(X=32.0000000,Y=32.0000000),Offset=(X=-16.0000000,Y=-16.0000000))
	bIsPrimaryObjective=true
	bUseNavigation=true
	bShowStartMessage=true
	DisplayTime=3.0000000
	IconFrame="inactive"
	ReNotifyInterval=60.0000000
	ObjectiveCompleteMessage="Objective Complete"
}