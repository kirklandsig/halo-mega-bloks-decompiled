class GFxHaloMinimapHUD extends GFxHaloMoviePlayer
	config(UI);

enum PlayerPawnType
{
	PPT_None,                       // 0
	PPT_Soldier,                    // 1
	PPT_Scout,                      // 2
	PPT_Turret,                     // 3
	PPT_Mongoose,                   // 4
	PPT_Warthog,                    // 5
	PPT_Scorpion,                   // 6
	PPT_Ghost,                      // 7
	PPT_MAX                         // 8
};

enum BlokAccumulatorState
{
	BAS_Wait,                       // 0
	BAS_Collect,                    // 1
	BAS_Deposit,                    // 2
	BAS_MAX                         // 3
};

enum GrenadeType
{
	GT_None,                        // 0
	GT_Frag,                        // 1
	GT_Plasma,                      // 2
	GT_MAX                          // 3
};

enum ArmorAbilityType
{
	AAT_None,                       // 0
	AAT_Boost,                      // 1
	AAT_Camo,                       // 2
	AAT_Shield,                     // 3
	AAT_MAX                         // 4
};

enum GameMessageState
{
	GMS_None,                       // 0
	GMS_Wait,                       // 1
	GMS_TransIn,                    // 2
	GMS_ShowText,                   // 3
	GMS_Show,                       // 4
	GMS_HideText,                   // 5
	GMS_TransOut,                   // 6
	GMS_MMTransIn,                  // 7
	GMS_MMShow,                     // 8
	GMS_MMTransOut,                 // 9
	GMS_MAX                         // 10
};

enum MessageBarState
{
	MBS_None,                       // 0
	MBS_Wait,                       // 1
	MBS_TransIn,                    // 2
	MBS_ShowInfo,                   // 3
	MBS_Show,                       // 4
	MBS_HideInfo,                   // 5
	MBS_TransOut,                   // 6
	MBS_MAX                         // 7
};

struct BlokCollectionStreak
{
	var name DisplayName;
	var int BlokCount;

	structdefaultproperties
	{
		DisplayName="None"
		BlokCount=-1
	}
};

struct GameMessageData
{
	var string Title;
	var string Subtitle;
	var float DisplayTime;
	var AkEvent Sound;

	structdefaultproperties
	{
		Title=""
		Subtitle=""
		DisplayTime=3.0000000
		Sound=none
	}
};

struct MessageBarData
{
	var string Message;
	var float DisplayTime;
	var string IconFrame;
	var AkEvent Sound;

	structdefaultproperties
	{
		Message=""
		DisplayTime=3.0000000
		IconFrame="checkpoint"
		Sound=none
	}
};

var GFxObject Clip_Avatar;
var Pawn Last_PlayerPawn;
var GFxHaloMinimapHUD.PlayerPawnType Last_PlayerPawnType;
var GFxHaloMinimapHUD.BlokAccumulatorState BAState;
var byte Last_BCSIndex;
var GFxHaloMinimapHUD.GrenadeType Last_GrenadeType;
var GFxHaloMinimapHUD.ArmorAbilityType Last_AbilityType;
var HaloWeapon_TargetDesignator.ETargetDesignatorCategory Last_TDCategory;
var GFxHaloMinimapHUD.GameMessageState GMState;
var byte GMEndFrame_TransIn;
var byte GMEndFrame_TransOut;
var byte GMEndFrame_TextIn;
var byte GMEndFrame_TextOut;
var GFxHaloMinimapHUD.MessageBarState MBState;
var byte MBEndFrame_TransIn;
var byte MBEndFrame_TransOut;
var byte MBEndFrame_InfoIn;
var byte MBEndFrame_InfoOut;
var float Last_Currency;
var GFxObject Text_Currency;
var GFxObject Clip_CurrencyPlate;
var GFxObject Clip_BACollectBase;
var GFxObject Clip_BACollect;
var GFxObject Text_BACollect;
var GFxObject Clip_BADeposit;
var GFxObject Text_BADeposit;
var GFxObject Clip_BAWithdraw;
var GFxObject Text_BAWithdraw;
var float BATimer_Total;
var float BATimer_Individual;
var int Last_BlokCount;
var int Last_BACount;
var bool bDepositingBloks;
var bool bWithdrawingBloks;
var bool Last_bShowShield;
var bool Last_bShowWeapon;
var bool Last_bIsOverheated;
var bool Last_bHasAmmo;
var bool Last_bShowAbility;
var bool Last_bAbilityAvailable;
var bool bWillShowVAOTarget;
var bool Last_BMShowing;
var bool bDisplayMissionMessage;
var bool bShowMessage;
var bool bForceMessageUpdate;
var bool Last_bShowMessage;
var bool bShowNavMarkers;
var bool Last_bMissionTimerActive;
var bool Last_bCombatMode;
var bool bShowCombatElements;
var bool bSplitScreen;
var bool bIsTeamHUD;
var bool bDrawWeaponCrosshairs;
var int BAWithdrawFrame;
var float BACollectOffsetX;
var float BACollectPosX;
var float BACollectVelX;
var float BACollectPosY;
var float BACollectVelY;
var float BACollectSpringiness;
var float BACollectDampening;
var float BACollectPosYDefault;
var float BADepositStartX;
var float BADepositStartY;
var float BADepositEndX;
var float BADepositEndY;
var float BADepositEndX_FS;
var float BADepositEndY_FS;
var float BADepositEndX_SS;
var float BADepositEndY_SS;
var float BATimer_DepositEnd;
var float BADepositTime;
var float BAScale_SS;
var float BlokStreakCollectTime;
var float BlokStreakTotalTime;
var GFxObject Clip_BAStreak;
var GFxObject Text_BAStreak;
var GFxObject Clip_Shield;
var GFxObject Clip_ShieldMeter;
var float Last_ShieldPct;
var GFxObject Clip_Weapon;
var GFxObject Clip_GunMeter_Plasma;
var GFxObject Text_GunMeter_Plasma;
var GFxObject Clip_GunMeter_Bullet;
var GFxObject Text_GunMeter_Bullet;
var GFxObject Clip_WeaponIcon_Primary;
var GFxObject Clip_WeaponIcon_Secondary;
var int Last_AmmoCount;
var int Last_ExtraAmmoCount;
var float Last_PlasmaPct;
var float Last_OverheatPct;
var HaloWeapon Last_Weapon;
var HaloWeapon Last_WeaponSecondary;
var float WeaponIconX_1;
var float WeaponIconX_2;
var GFxObject Clip_Grenade;
var GFxObject Text_Grenade;
var GFxObject Clip_GrenadeType;
var int Last_GrenadeCount;
var float GrenadeMarkerMaxDist;
var float GrenadeMarkerFlashRedTime;
var GFxObject Clip_Ability;
var GFxObject Clip_AbilityMeter;
var GFxObject Clip_AbilityIcon;
var GFxObject Clip_AbilityState;
var float Last_AbilityPct;
var GFxObject Clip_TDBar;
var int Last_TDIndex;
var float Last_TDProgress;
var GFxObject Clip_VAOTarget;
var Vector VOAPostion;
var const localized string BlueprintNeeded;
var const localized string VehicleCustomization;
var GFxObject Clip_BuildMessageBox;
var GFxObject Clip_BMIcon;
var GFxObject Clip_BMMask;
var GFxObject Clip_BMInfoBar;
var GFxObject Text_BMTitle;
var GFxObject Text_BMBody;
var GFxObject Text_BMCostNeg;
var GFxObject Text_BMCostPos;
var GFxObject Clip_BMCostIcon;
var GFxObject Clip_BMVehicleIcon;
var GFxObject Clip_BMInputIcon;
var int BMEndFrame_TransIn;
var int BMEndFrame_TransOut;
var AkEvent Audio_BuildMessageOpen;
var AkEvent Audio_BuildMessageClose;
var GFxObject Clip_MissionMessageBox;
var GFxObject Text_MMTitle;
var float MMDisplayTime;
var int MMEndFrame_TransIn;
var int MMEndFrame_TransOut;
var array<GFxObject> NonMMClips;
var array<bool> NonMMClipsVisibility;
var GFxObject Clip_GameMessageBox;
var GFxObject Clip_GMTitle;
var GFxObject Text_GMTitle;
var GFxObject Clip_GMSubtitle;
var GFxObject Text_GMSubtitle;
var array<GameMessageData> GameMessages;
var float GMTimer;
var float GMTitleOffset;
var float GMSubtitleOffset;
var AkEvent Audio_GameMessageOpen;
var AkEvent Audio_GameMessageClose;
var GFxObject Clip_MessageBar;
var GFxObject Clip_MBInfo;
var GFxObject Text_MBText;
var GFxObject Clip_MBIcon;
var array<MessageBarData> MBMessages;
var float MBTimer;
var float MB1LineY;
var float MB2LineY;
var float MB3LineY;
var AkEvent Audio_UpdateMessageOpen;
var AkEvent Audio_UpdateMessageClose;
var const localized string TakedownMessage;
var const localized string OutOfAmmo;
var const localized string WeaponsEmpty;
var const localized string ScavengeNewWeapons;
var GFxObject Clip_Message;
var GFxObject Text_MessageLine1;
var GFxObject Text_MessageLine2;
var GFxObject Text_MessageCost;
var GFxObject Clip_MessageIcons;
var GFxObject Clip_MessageProgress;
var name MessageLine1;
var name MessageLine2;
var int MessageCost;
var name MessageIcon;
var float MessageProgress;
var name Last_MessageLine1;
var name Last_MessageLine2;
var int Last_MessageCost;
var name Last_MessageIcon;
var float Last_MessageProgress;
var GFxObject Clip_MissionTimer;
var GFxObject Clip_MissionTimerMeter;
var GFxObject Text_MissionTimer;
var float Last_MissionTimeRemaining;
var float Last_MissionTimePct;
var float PowerCoreDamagedTime;
var array<float> PowerCoreDamagedTimers;
var array<HaloDestructibleActor> PowerCores;
var array<float> PowerCoreLastHealth;
var float ShowCombatElementsTimer;
var float ShowCombatElementsMinDuration;
var GFxHaloMinimap Minimap;
var GFxHaloCompass Compass;
var GFxHaloCrosshair crosshair;
var GFxObject RootMC;
var Canvas Canvas;
var Vector2D Origin;
var Vector2D Clip;
var WorldInfo ThisWorld;
var GFxHaloHUD HUD;
var HaloPlayerPawnController PC;
var GFxObject DBGTextBox;
var GFxObject Text_DBGTextBox;
var GFxObject DBGTF;
var GFxObject DBG2TF;

function DBGText_setPosition(int X, int Y)
{
	DBGTextBox.ActionScriptVoid("setPosition");
	//return;	
}

function DBGText_setText(string Text)
{
	Text_DBGTextBox.SetText(Text);
	//return;	
}

function DBGText_clearText()
{
	DBGTextBox.ActionScriptVoid("clearText");
	//return;	
}

function DBGText_formatTextSize(int Size)
{
	DBGTextBox.ActionScriptVoid("formatTextSize");
	//return;	
}

function DBGText_formatTextColor(int R, int G, int B)
{
	DBGTextBox.ActionScriptVoid("formatTextColor");
	//return;	
}

function DBGText_formatTextAlign(string Align)
{
	DBGTextBox.ActionScriptVoid("formatTextAlign");
	//return;	
}

function InitToHUD(GFxHaloHUD HaloHUD)
{
	HUD = HaloHUD;
	LocalPlayerOwnerIndex = Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(HUD.UTPlayerOwner.Player));
	// End:0xAF
	if(LocalPlayerOwnerIndex == -1)
	{
		LocalPlayerOwnerIndex = 0;
	}
	PC = HaloPlayerPawnController(HUD.PlayerOwner);
	// End:0x117
	if(Minimap != none)
	{
		Minimap.PlayerOwner = PC;
	}
	// End:0x14E
	if(Compass != none)
	{
		Compass.PlayerOwner = PC;
	}
	// End:0x185
	if(crosshair != none)
	{
		crosshair.PlayerOwner = PC;
	}
	InitViewport();
	//return;	
}

function registerMiniMapView(GFxHaloMinimap MC, float R)
{
	// End:0x5E
	if(Minimap == none)
	{
		Minimap = MC;
		// End:0x5E
		if(Minimap != none)
		{
			Minimap.Init("HUD_Minimap", self);
		}
	}
	//return;	
}

function registerCompass(GFxHaloCompass MC)
{
	// End:0x5E
	if(Compass == none)
	{
		Compass = MC;
		// End:0x5E
		if(Compass != none)
		{
			Compass.Init("HUD_Compass", self);
		}
	}
	//return;	
}

function registerCrosshair(GFxHaloCrosshair MC)
{
	// End:0x60
	if(crosshair == none)
	{
		crosshair = MC;
		// End:0x60
		if(crosshair != none)
		{
			crosshair.Init("HUD_Crosshair", self);
		}
	}
	//return;	
}

function Init(optional LocalPlayer Player)
{
	super(GFxMoviePlayer).Init(Player);
	ThisWorld = GetPC().WorldInfo;
	Start();
	Advance(0.0000000);
	RootMC = GetVariableObject("_root");
	// End:0xE9
	if(Class'Engine.Engine'.static.GetEngine().GamePlayers.Length > 1)
	{
		RootMC.GotoAndStop("SplitScreen");
		bSplitScreen = true;		
	}
	else
	{
		RootMC.GotoAndStop("FullScreen");
		bSplitScreen = false;
	}
	Clip_Avatar = GetVariableObject("_root.HUD_Avatar");
	Text_Currency = GetVariableObject("_root.HUD_Currency.tf");
	Clip_CurrencyPlate = GetVariableObject("_root.HUD_Currency.plate");
	Clip_BACollectBase = GetVariableObject("_root.HUD_BlokAccumulator.collect");
	Clip_BACollect = GetVariableObject("_root.HUD_BlokAccumulator.collect.text");
	Text_BACollect = GetVariableObject("_root.HUD_BlokAccumulator.collect.text.base.tf");
	Clip_BADeposit = GetVariableObject("_root.HUD_BlokAccumulator.deposit");
	Text_BADeposit = GetVariableObject("_root.HUD_BlokAccumulator.deposit.base.tf");
	Clip_BAWithdraw = GetVariableObject("_root.HUD_BlokAccumulator.withdraw");
	Text_BAWithdraw = GetVariableObject("_root.HUD_BlokAccumulator.withdraw.base.tf");
	Clip_BAStreak = GetVariableObject("_root.HUD_BlokAccumulator.streak");
	Text_BAStreak = GetVariableObject("_root.HUD_BlokAccumulator.streak.base.tf");
	Clip_BACollect.SetVisible(false);
	Clip_BADeposit.SetVisible(false);
	// End:0x5B8
	if(bSplitScreen)
	{
		BADepositEndX = BADepositEndX_SS;
		BADepositEndY = BADepositEndY_SS;
		Clip_BACollectBase.SetFloat("_xscale", BAScale_SS);
		Clip_BACollectBase.SetFloat("_yscale", BAScale_SS);
		Clip_BADeposit.SetFloat("_xscale", BAScale_SS);
		Clip_BADeposit.SetFloat("_yscale", BAScale_SS);
		Clip_BAWithdraw.SetFloat("_xscale", BAScale_SS);
		Clip_BAWithdraw.SetFloat("_yscale", BAScale_SS);
		Clip_BAWithdraw.SetFloat("_x", BADepositEndX_SS);
		Clip_BAWithdraw.SetFloat("_y", BADepositEndY_SS);		
	}
	else
	{
		BADepositEndX = BADepositEndX_FS;
		BADepositEndY = BADepositEndY_FS;
		Clip_BACollectBase.SetFloat("_xscale", 100.0000000);
		Clip_BACollectBase.SetFloat("_yscale", 100.0000000);
		Clip_BADeposit.SetFloat("_xscale", 100.0000000);
		Clip_BADeposit.SetFloat("_yscale", 100.0000000);
		Clip_BAWithdraw.SetFloat("_xscale", 100.0000000);
		Clip_BAWithdraw.SetFloat("_yscale", 100.0000000);
		Clip_BAWithdraw.SetFloat("_x", BADepositEndX_FS);
		Clip_BAWithdraw.SetFloat("_y", BADepositEndY_FS);
	}
	Clip_Shield = GetVariableObject("_root.HUD_Shield");
	Clip_ShieldMeter = GetVariableObject("_root.HUD_Shield.base");
	Clip_Weapon = GetVariableObject("_root.HUD_Weapon");
	Clip_GunMeter_Plasma = GetVariableObject("_root.HUD_Weapon.gun.plasma");
	Text_GunMeter_Plasma = GetVariableObject("_root.HUD_Weapon.gun.plasma.tf");
	Clip_GunMeter_Bullet = GetVariableObject("_root.HUD_Weapon.gun.bullet");
	Text_GunMeter_Bullet = GetVariableObject("_root.HUD_Weapon.gun.bullet.tf");
	Clip_WeaponIcon_Primary = GetVariableObject("_root.HUD_Weapon.gun.iconP");
	Clip_WeaponIcon_Secondary = GetVariableObject("_root.HUD_Weapon.gun.iconS");
	Clip_Grenade = GetVariableObject("_root.HUD_Weapon.grenade");
	Text_Grenade = GetVariableObject("_root.HUD_Weapon.grenade.base.tf");
	Clip_GrenadeType = GetVariableObject("_root.HUD_Weapon.grenade.base");
	Clip_Ability = GetVariableObject("_root.HUD_Ability.HUD_AbilityMeter");
	Clip_AbilityMeter = GetVariableObject("_root.HUD_Ability.HUD_AbilityMeter.base");
	Clip_AbilityIcon = GetVariableObject("_root.HUD_Ability.icon");
	Clip_AbilityState = GetVariableObject("_root.HUD_Ability");
	Clip_TDBar = GetVariableObject("_root.HUD_TargetDesignator_Bar");
	Clip_TDBar.SetVisible(false);
	Clip_VAOTarget = GetVariableObject("_root.HUD_VehicleAddOnTarget");
	Clip_BuildMessageBox = GetVariableObject("_root.HUD_BuildMessage");
	Clip_BMIcon = GetVariableObject("_root.HUD_BuildMessage.icon");
	Clip_BMMask = GetVariableObject("_root.HUD_BuildMessage.mask");
	Clip_BMInfoBar = GetVariableObject("_root.HUD_BuildMessage.infoBar");
	Text_BMTitle = GetVariableObject("_root.HUD_BuildMessage.infoBar.title");
	Text_BMBody = GetVariableObject("_root.HUD_BuildMessage.infoBar.body");
	Text_BMCostNeg = GetVariableObject("_root.HUD_BuildMessage.infoBar.costNeg");
	Text_BMCostPos = GetVariableObject("_root.HUD_BuildMessage.infoBar.costPos");
	Clip_BMCostIcon = GetVariableObject("_root.HUD_BuildMessage.infoBar.blok");
	Clip_BMVehicleIcon = GetVariableObject("_root.HUD_BuildMessage.infoBar.vehicle");
	Clip_BMInputIcon = GetVariableObject("_root.HUD_BuildMessage.infoBar.input");
	Clip_MissionMessageBox = GetVariableObject("_root.HUD_MissionMessage");
	Clip_MissionMessageBox.SetVisible(false);
	Text_MMTitle = GetVariableObject("_root.HUD_MissionMessage.name.tf");
	Clip_GameMessageBox = GetVariableObject("_root.HUD_GameMessage.base");
	Clip_GMTitle = GetVariableObject("_root.HUD_GameMessage.title");
	Text_GMTitle = GetVariableObject("_root.HUD_GameMessage.title.base.textField");
	Clip_GMSubtitle = GetVariableObject("_root.HUD_GameMessage.subtitle");
	Text_GMSubtitle = GetVariableObject("_root.HUD_GameMessage.subtitle.base.textField");
	Clip_MessageBar = GetVariableObject("_root.HUD_MessageBar.base");
	Clip_MBInfo = GetVariableObject("_root.HUD_MessageBar.info");
	Text_MBText = GetVariableObject("_root.HUD_MessageBar.info.base.tf");
	Clip_MBIcon = GetVariableObject("_root.HUD_MessageBar.info.icon");
	Clip_Message = GetVariableObject("_root.HUD_Message");
	Text_MessageLine1 = GetVariableObject("_root.HUD_Message.base.line1");
	Text_MessageLine2 = GetVariableObject("_root.HUD_Message.base.line2");
	Text_MessageCost = GetVariableObject("_root.HUD_Message.base.cost");
	Clip_MessageIcons = GetVariableObject("_root.HUD_Message.base.icons");
	Clip_MessageProgress = GetVariableObject("_root.HUD_Message.base.buildMeter");
	Clip_MissionTimer = GetVariableObject("_root.HUD_MissionTimer");
	Clip_MissionTimerMeter = GetVariableObject("_root.HUD_MissionTimer.meter");
	Text_MissionTimer = GetVariableObject("_root.HUD_MissionTimer.base.tf");
	DBGTextBox = GetVariableObject("_root.DBGTextBox");
	Text_DBGTextBox = GetVariableObject("_root.DBGTextBox.textBox");
	DBGTF = GetVariableObject("_root.DBGTF");
	DBG2TF = GetVariableObject("_root.DBG2TF");
	NonMMClips.AddItem(Clip_Avatar);
	NonMMClips.AddItem(GetVariableObject("_root.HUD_Currency"));
	NonMMClips.AddItem(Clip_Ability);
	NonMMClips.AddItem(Clip_AbilityState);
	NonMMClips.AddItem(Clip_Shield);
	NonMMClips.AddItem(Clip_Weapon);
	NonMMClips.AddItem(Clip_Message);
	NonMMClips.AddItem(Compass);
	NonMMClips.AddItem(Minimap);
	NonMMClips.AddItem(crosshair);
	NonMMClips.AddItem(GetVariableObject("_root.HUD_ScreenTag"));
	NonMMClipsVisibility.Add(NonMMClips.Length);
	ClearStats(true);
	//return;	
}

function ClearStats(optional bool clearScores)
{
	local ASColorTransform cxform;

	Last_PlayerPawn = none;
	Last_PlayerPawnType = 0;
	BAState = 0;
	BATimer_Total = -1.0000000;
	BATimer_Individual = -1.0000000;
	Last_BACount = 0;
	bDepositingBloks = false;
	bWithdrawingBloks = false;
	Clip_BACollect.SetVisible(false);
	Clip_BADeposit.SetVisible(false);
	Clip_BAWithdraw.SetVisible(false);
	Last_BCSIndex = 255;
	Last_bShowShield = false;
	Last_ShieldPct = -1.0000000;
	Clip_ShieldMeter.GotoAndStopI(1);
	Last_AmmoCount = -1;
	Last_ExtraAmmoCount = -1;
	Last_PlasmaPct = -1.0000000;
	Last_bShowWeapon = false;
	Last_bIsOverheated = false;
	Last_OverheatPct = -1.0000000;
	Last_Weapon = none;
	Last_WeaponSecondary = none;
	Last_bHasAmmo = true;
	cxform.Multiply.R = 1.0000000;
	cxform.Multiply.G = 1.0000000;
	cxform.Multiply.B = 1.0000000;
	Clip_GunMeter_Plasma.SetColorTransform(cxform);
	Last_GrenadeCount = -1;
	Last_GrenadeType = 0;
	Last_bShowAbility = true;
	Last_bAbilityAvailable = false;
	Last_AbilityPct = -1.0000000;
	Last_AbilityType = 0;
	Last_TDIndex = -1;
	Last_TDProgress = -1.0000000;
	Last_TDCategory = 0;
	Clip_TDBar.SetVisible(false);
	Last_BMShowing = false;
	Clip_BuildMessageBox.GotoAndStopI(BMEndFrame_TransOut);
	bDisplayMissionMessage = false;
	bShowMessage = false;
	bForceMessageUpdate = true;
	MessageLine1 = 'None';
	MessageLine2 = 'None';
	MessageCost = -1;
	MessageIcon = 'None';
	MessageProgress = -1.0000000;
	Last_bShowMessage = false;
	Last_MessageLine1 = 'None';
	Last_MessageLine2 = 'None';
	Last_MessageCost = -1;
	Last_MessageIcon = 'None';
	Last_MessageProgress = -1.0000000;
	GMState = 1;
	Text_MessageLine1.SetText("");
	Text_MessageLine2.SetText("");
	Clip_MessageProgress.SetVisible(false);
	Clip_MessageIcons.SetVisible(false);
	Clip_MessageBar.GotoAndStopI(int(MBEndFrame_TransOut));
	Clip_MBInfo.GotoAndStopI(int(MBEndFrame_InfoOut));
	MBState = 1;
	Last_bCombatMode = false;
	bShowCombatElements = true;
	ShowCombatElementsTimer = ShowCombatElementsMinDuration;
	Last_MissionTimeRemaining = -1.0000000;
	Last_bMissionTimerActive = false;
	//return;	
}

function InitViewport()
{
	local int ssiIndex;
	local Vector2D VpSize;
	local float XPos, YPos, xSize, ySize;
	local GameViewportClient Viewport;
	local PerPlayerSplitscreenData ssData;

	Viewport = GetGameViewportClient();
	// End:0x264
	if(Viewport != none)
	{
		Viewport.GetViewportSize(VpSize);
		ssiIndex = Class'Engine.Engine'.static.GetEngine().GamePlayers.Length - 1;
		ssData = Viewport.SplitscreenInfo[ssiIndex].PlayerData[LocalPlayerOwnerIndex];
		XPos = 0.0000000;
		YPos = ssData.OriginY * VpSize.Y;
		xSize = VpSize.X;
		ySize = ssData.SizeY * VpSize.Y;
		SetViewScaleMode(0);
		SetAlignment(1);
		SetViewport(int(XPos), int(YPos), int(xSize), int(ySize));
		Origin.X = ssData.OriginX * VpSize.X;
		Origin.Y = YPos;
	}
	//return;	
}

function TickHud(float DeltaTime)
{
	local bool bCombatMode;

	// End:0x43
	if((PC == none) || PC.Pawn == none)
	{
		ClearStats(true);		
	}
	else
	{
		bCombatMode = true;
		TickBlokAccumulator(DeltaTime);
		TickNavigation(bCombatMode, DeltaTime);
		TickCrosshair(DeltaTime);
		TickBuildMessage();
		TickMessages();
		TickObjectiveMarkers(DeltaTime);
		TickGrenadeMarkers();
		TickVehicleAddOnTarget();
		TickRocketTargetMarkers();
		TickMissionTimer();
		TickPlayerModule(bCombatMode, DeltaTime);
		TickTargetDesignator();
	}
	TickMessageBar();
	TickGameMessage();
	//return;	
}

function TickBlokAccumulator(float DeltaTime)
{
	local int Bank;
	local float gameTime;
	local Vector screenPosition;
	local float collectAccel, CurrentTime, TimeRemaining, trSquared, trInvSquared, trTimesInv,
		bezierX, bezierY;

	gameTime = ThisWorld.TimeSeconds;
	// End:0x9E6
	if(PC.BlokCollector != none)
	{
		Bank = PC.BlokCollector.GetBankCount();
		// End:0x230
		if(Last_BlokCount < Bank)
		{
			Last_BACount += (Bank - Last_BlokCount);
			Text_BACollect.SetText("+" $ string(Last_BACount));
			Last_BlokCount = Bank;
			switch(BAState)
			{
				// End:0x1E3
				case 0:
					BATimer_Total = gameTime + BlokStreakTotalTime;
					Clip_BACollect.SetVisible(true);
					screenPosition = GetBlokAccumulatorPosition();
					BACollectPosX = screenPosition.X;
					BACollectPosY = screenPosition.Y;
					BACollectVelX = 0.0000000;
					BACollectVelY = 0.0000000;
					BAState = 1;
				// End:0x22A
				case 1:
					BATimer_Individual = gameTime + BlokStreakCollectTime;
					Clip_BACollect.GotoAndPlayI(2);
					// End:0x22D
					break;
				// End:0xFFFF
				default:
					break;
			}			
		}
		else
		{
			// End:0x2E2
			if(Last_BlokCount > Bank)
			{
				bWithdrawingBloks = true;
				Text_BAWithdraw.SetText("-" $ string(Last_BlokCount - Bank));
				Clip_BAWithdraw.GotoAndPlayI(2);
				Clip_BAWithdraw.SetVisible(true);
				Last_BlokCount = Bank;
			}
		}
		// End:0x61A
		if(int(BAState) == int(1))
		{
			screenPosition = GetBlokAccumulatorPosition();
			collectAccel = (BACollectSpringiness * (screenPosition.X - BACollectPosX)) - (BACollectDampening * BACollectVelX);
			BACollectPosX += ((BACollectVelX * DeltaTime) + (((0.5000000 * collectAccel) * DeltaTime) * DeltaTime));
			BACollectVelX += (collectAccel * DeltaTime);
			Clip_BACollectBase.SetFloat("_x", BACollectPosX);
			collectAccel = (BACollectSpringiness * (screenPosition.Y - BACollectPosY)) - (BACollectDampening * BACollectVelY);
			BACollectPosY += ((BACollectVelY * DeltaTime) + (((0.5000000 * collectAccel) * DeltaTime) * DeltaTime));
			BACollectVelY += (collectAccel * DeltaTime);
			Clip_BACollectBase.SetFloat("_y", BACollectPosY);
			// End:0x61A
			if((gameTime >= BATimer_Individual) || gameTime >= BATimer_Total)
			{
				Last_BCSIndex = 255;
				Clip_BACollect.SetVisible(false);
				BAState = 0;
				bDepositingBloks = true;
				Text_BADeposit.SetText("+" $ string(Last_BACount));
				Clip_BADeposit.SetVisible(true);
				Clip_BADeposit.GotoAndStopI(1);
				BATimer_DepositEnd = ThisWorld.TimeSeconds + BADepositTime;
				BADepositStartX = BACollectPosX;
				BADepositStartY = BACollectPosY;
				Last_BACount = 0;
			}
		}
		// End:0x930
		if(bDepositingBloks)
		{
			CurrentTime = ThisWorld.TimeSeconds;
			// End:0x74C
			if(CurrentTime >= BATimer_DepositEnd)
			{
				Clip_BADeposit.SetFloat("_x", BADepositEndX);
				Clip_BADeposit.SetFloat("_y", BADepositEndY);
				Clip_BADeposit.GotoAndPlayI(2);
				Text_Currency.SetText(string(Bank - Last_BACount));
				Clip_CurrencyPlate.GotoAndPlay("deposit");
				bDepositingBloks = false;				
			}
			else
			{
				bezierX = ((BADepositStartX >= BADepositEndX) ? BADepositStartX + (BADepositStartX * 0.1000000) : BADepositStartX - (BADepositStartX * 0.1000000));
				bezierY = -BADepositStartY * 0.2000000;
				TimeRemaining = 1.0000000 - ((BATimer_DepositEnd - CurrentTime) / BADepositTime);
				trSquared = TimeRemaining * TimeRemaining;
				trInvSquared = (1.0000000 - TimeRemaining) * (float(1) - TimeRemaining);
				trTimesInv = (1.0000000 - TimeRemaining) * TimeRemaining;
				Clip_BADeposit.SetFloat("_x", ((trInvSquared * BADepositStartX) + ((float(2) * trTimesInv) * bezierX)) + (trSquared * BADepositEndX));
				Clip_BADeposit.SetFloat("_y", ((trInvSquared * BADepositStartY) + ((float(2) * trTimesInv) * bezierY)) + (trSquared * BADepositEndY));
			}
		}
		// End:0x9E6
		if(bWithdrawingBloks)
		{
			// End:0x9E6
			if(Clip_BAWithdraw.GetFloat("_currentframe") >= float(BAWithdrawFrame))
			{
				Text_Currency.SetText(string(Bank - Last_BACount));
				Clip_CurrencyPlate.GotoAndPlay("withdraw");
				bWithdrawingBloks = false;
			}
		}
	}
	//return;	
}

function Vector GetBlokAccumulatorPosition()
{
	local Vector screenPosition;
	local Rotator perpRotator;
	local float OffsetX, OffsetY;

	perpRotator = PC.PlayerCamera.ViewTarget.POV.Rotation;
	perpRotator.Yaw += 16384;
	ProjectToScreenSpace((PC.Pawn.Location + (PC.Pawn.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000))) + (PC.Pawn.GetCollisionRadius() * Normal(Vector(perpRotator))), false, screenPosition);
	switch(Last_PlayerPawnType)
	{
		// End:0x190
		case 4:
			OffsetX = 50.0000000;
			OffsetY = -80.0000000;
			// End:0x226
			break;
		// End:0x1B6
		case 5:
			OffsetX = -90.0000000;
			OffsetY = -75.0000000;
			// End:0x226
			break;
		// End:0x1DC
		case 6:
			OffsetX = -80.0000000;
			OffsetY = -100.0000000;
			// End:0x226
			break;
		// End:0x202
		case 7:
			OffsetX = 45.0000000;
			OffsetY = -65.0000000;
			// End:0x226
			break;
		// End:0xFFFF
		default:
			OffsetX = 60.0000000;
			OffsetY = 15.0000000;
			// End:0x226
			break;
			break;
	}
	screenPosition.X += OffsetX;
	screenPosition.Y += OffsetY;
	return screenPosition;
	//return ReturnValue;	
}

function TickNavigation(bool bCombatMode, float DeltaTime)
{
	// End:0xBA
	if(Last_bCombatMode != bCombatMode)
	{
		Last_bCombatMode = bCombatMode;
		// End:0x7C
		if(bCombatMode)
		{
			Minimap.TransitionIn();
			Compass.TransitionOut();			
		}
		else
		{
			Minimap.TransitionOut();
			Compass.TransitionIn();
		}
	}
	// End:0xD4
	if(bCombatMode)
	{
		TickMinimap();		
	}
	else
	{
		TickCompass(DeltaTime);
	}
	//return;	
}

function TickMinimap()
{
	// End:0x2E
	if(Minimap != none)
	{
		Minimap.Update();
	}
	//return;	
}

function TickCompass(float DeltaTime)
{
	// End:0x37
	if(Compass != none)
	{
		Compass.Update(DeltaTime);
	}
	//return;	
}

function TickCrosshair(float DeltaTime)
{
	// End:0x37
	if(crosshair != none)
	{
		crosshair.Update(DeltaTime);
	}
	//return;	
}

function ShowCombatElements()
{
	bShowCombatElements = true;
	ShowCombatElementsTimer = ShowCombatElementsMinDuration;
	//return;	
}

function HideCombatElements()
{
	bShowCombatElements = false;
	//return;	
}

function TickPlayerModule(bool bCombatMode, float DeltaTime)
{
	local bool bInCombatThisFrame;

	// End:0x17
	if(bCombatMode)
	{
		ShowCombatElements();
	}
	// End:0x55
	if(bShowCombatElements)
	{
		ShowCombatElementsTimer -= DeltaTime;
		// End:0x55
		if(ShowCombatElementsTimer <= 0.0000000)
		{
			HideCombatElements();
		}
	}
	bInCombatThisFrame = bShowCombatElements;
	TickAvatar();
	TickShield(bInCombatThisFrame);
	TickWeapons(bInCombatThisFrame);
	TickAbility(bInCombatThisFrame);
	//return;	
}

function TickAvatar()
{
	// End:0x7C
	if(Last_PlayerPawn != PC.Pawn)
	{
		UpdatePlayerPawnType(PC.Pawn);
		Last_PlayerPawn = PC.Pawn;
	}
	//return;	
}

function UpdatePlayerPawnType(Pawn NewPawn)
{
	local GFxHaloMinimapHUD.PlayerPawnType NewPawnType;

	NewPawnType = 0;
	// End:0xE1
	if(NewPawn.IsA('HaloPawn'))
	{
		// End:0xB0
		if(NewPawn.Weapon.IsA('HaloVehicleWeapon'))
		{
			NewPawnType = HaloVehicleWeapon(NewPawn.Weapon).PawnTypeOverride;			
		}
		else
		{
			NewPawnType = HaloPawn(NewPawn).PawnType;
		}
	}
	// End:0x149
	if(int(NewPawnType) == int(0))
	{
		// End:0x149
		if(NewPawn.IsA('HaloVehicle'))
		{
			NewPawnType = HaloVehicle(NewPawn).PawnType;
		}
	}
	// End:0x1B1
	if(int(NewPawnType) == int(0))
	{
		// End:0x1B1
		if(NewPawn.IsA('HaloTurret'))
		{
			NewPawnType = HaloTurret(NewPawn).PawnType;
		}
	}
	// End:0x233
	if(int(Last_PlayerPawnType) != int(NewPawnType))
	{
		// End:0x220
		if((int(NewPawnType) == int(1)) || int(NewPawnType) == int(2))
		{
			Clip_Avatar.GotoAndStopI(int(NewPawnType));
		}
		Last_PlayerPawnType = NewPawnType;
	}
	//return;	
}

function TickCurrency()
{
	local int Bank;

	// End:0xBB
	if(PC.BlokCollector != none)
	{
		Bank = PC.BlokCollector.GetBankCount();
		// End:0xBB
		if(Last_Currency != float(Bank))
		{
			Last_Currency = float(Bank);
			Text_Currency.SetText(string(Bank));
		}
	}
	//return;	
}

function TickShield(bool bShowShield)
{
	local int Health;
	local HaloPawn HP;

	// End:0x8F
	if(Last_bShowShield != bShowShield)
	{
		Last_bShowShield = bShowShield;
		// End:0x66
		if(bShowShield)
		{
			Clip_Shield.GotoAndPlay("transIn");			
		}
		else
		{
			Clip_Shield.GotoAndPlay("transOut");
		}
	}
	// End:0x198
	if(bShowShield)
	{
		HP = HaloPawn(PC.Pawn);
		// End:0x198
		if(HP != none)
		{
			// End:0x198
			if(HP.SuitShield != none)
			{
				Health = int(HP.SuitShield.Shield);
				// End:0x198
				if(Last_ShieldPct != float(Health))
				{
					Last_ShieldPct = float(Health);
					Clip_ShieldMeter.GotoAndStopI(Health + 1);
				}
			}
		}
	}
	//return;	
}

function TickWeapons(bool bShowWeapons)
{
	// End:0xC0
	if(((PC.Pawn.Weapon == none) || PC.Pawn.Weapon.IsA('HaloWeapon_TargetDesignator')) || (int(Last_PlayerPawnType) != int(1)) && int(Last_PlayerPawnType) != int(2))
	{
		bShowWeapons = false;
	}
	// End:0x14F
	if(Last_bShowWeapon != bShowWeapons)
	{
		Last_bShowWeapon = bShowWeapons;
		// End:0x126
		if(bShowWeapons)
		{
			Clip_Weapon.GotoAndPlay("transIn");			
		}
		else
		{
			Clip_Weapon.GotoAndPlay("transOut");
		}
	}
	TickWeapon();
	TickGrenades();
	//return;	
}

function TickWeapon()
{
	local HaloWeapon Weapon, SecondaryWeapon;
	local bool bChangedWeapon;

	// End:0x6A
	if(PC.Pawn != none)
	{
		Weapon = HaloWeapon(PC.Pawn.Weapon);
	}
	bChangedWeapon = (((Last_Weapon == Weapon) || PC.bIsAimingTargetDesignator) ? false : true);
	// End:0x334
	if(bChangedWeapon)
	{
		Last_Weapon = Weapon;
		// End:0x1C8
		if(Weapon != none)
		{
			// End:0x148
			if(Weapon.bIsEnergyPowered)
			{
				Clip_GunMeter_Bullet.SetVisible(false);
				Clip_GunMeter_Plasma.SetVisible(true);				
			}
			else
			{
				Clip_GunMeter_Bullet.SetVisible(true);
				Clip_GunMeter_Plasma.SetVisible(false);
			}
			Clip_WeaponIcon_Primary.GotoAndStop(Weapon.HUDIcon);			
		}
		else
		{
			Clip_GunMeter_Bullet.SetVisible(false);
			Clip_GunMeter_Plasma.SetVisible(false);
		}
		SecondaryWeapon = HaloWeapon(PC.GetUnequippedWeapon());
		// End:0x2D5
		if(SecondaryWeapon != none)
		{
			Clip_WeaponIcon_Secondary.GotoAndStop(SecondaryWeapon.HUDIcon);
			Clip_WeaponIcon_Secondary.SetVisible(true);
			Clip_WeaponIcon_Primary.SetFloat("_x", WeaponIconX_2);			
		}
		else
		{
			Clip_WeaponIcon_Secondary.SetVisible(false);
			Clip_WeaponIcon_Primary.SetFloat("_x", WeaponIconX_1);
		}
		Last_WeaponSecondary = SecondaryWeapon;
	}
	// End:0x3A2
	if(Weapon != none)
	{
		// End:0x385
		if(Weapon.bIsEnergyPowered)
		{
			TickEnergyWeapon(Weapon, bChangedWeapon);			
		}
		else
		{
			TickKineticWeapon(Weapon, bChangedWeapon);
		}
	}
	//return;	
}

function TickEnergyWeapon(HaloWeapon Weapon, bool bIsNewWeapon)
{
	local float OverheatPct, ChargePct;
	local bool bIsOverheated;
	local ASColorTransform cxform;

	bIsOverheated = false;
	OverheatPct = Weapon.OverheatPct;
	// End:0xBF
	if((OverheatPct >= 1.0000000) || Weapon.CooldownPct < 1.0000000)
	{
		OverheatPct = 1.0000000 - Weapon.CooldownPct;
		// End:0xBF
		if(OverheatPct >= 0.1500000)
		{
			bIsOverheated = true;
		}
	}
	// End:0x251
	if(bIsOverheated)
	{
		// End:0x24E
		if(Last_bIsOverheated == false)
		{
			cxform.Multiply.R = 1.0000000;
			cxform.Multiply.G = 0.1000000;
			cxform.Multiply.B = 0.1000000;
			cxform.Add.R = 1.0000000;
			cxform.Add.G = 0.0000000;
			cxform.Add.B = 0.0000000;
			Clip_GunMeter_Plasma.SetColorTransform(cxform);
			Last_bIsOverheated = true;
		}		
	}
	else
	{
		// End:0x334
		if(Last_bIsOverheated == true)
		{
			cxform.Multiply.R = 1.0000000;
			cxform.Multiply.G = 1.0000000;
			cxform.Multiply.B = 1.0000000;
			Clip_GunMeter_Plasma.SetColorTransform(cxform);
			Last_bIsOverheated = false;
		}
	}
	// End:0x393
	if(Last_OverheatPct != OverheatPct)
	{
		Last_OverheatPct = OverheatPct;
		Clip_GunMeter_Plasma.GotoAndStopI(int((OverheatPct * float(100)) + float(1)));
	}
	ChargePct = float(Weapon.AmmoCount) / float(Weapon.MaxAmmoCount);
	// End:0x441
	if(Last_PlasmaPct != ChargePct)
	{
		Text_GunMeter_Plasma.SetText(string(int(ChargePct * float(100))) $ "%");
		Last_PlasmaPct = ChargePct;
	}
	Last_bHasAmmo = ChargePct > 0.0000000;
	//return;	
}

function TickKineticWeapon(HaloWeapon Weapon, bool bIsNewWeapon)
{
	local int AmmoCount, ExtraAmmoCount;

	AmmoCount = Weapon.GetAmmoCount();
	ExtraAmmoCount = Weapon.ExtraAmmoCount;
	// End:0xF9
	if((Last_AmmoCount != AmmoCount) || Last_ExtraAmmoCount != ExtraAmmoCount)
	{
		Last_AmmoCount = AmmoCount;
		Last_ExtraAmmoCount = ExtraAmmoCount;
		Text_GunMeter_Bullet.SetText((string(AmmoCount) $ "|") $ string(Weapon.ExtraAmmoCount));
	}
	Last_bHasAmmo = (AmmoCount > 0) || ExtraAmmoCount > 0;
	//return;	
}

function TickGrenades()
{
	local int GrenadeCount;
	local bool bGrenadeTypeChanged;
	local GFxHaloMinimapHUD.GrenadeType CurrentGrenadeType;
	local HaloPlayerInventoryManager InvManager;

	GrenadeCount = 0;
	CurrentGrenadeType = 0;
	InvManager = HaloPlayerInventoryManager(PC.Pawn.InvManager);
	// End:0x166
	if(InvManager != none)
	{
		GrenadeCount = int(InvManager.PlasmaGrenadeCount);
		// End:0xB4
		if(GrenadeCount > 0)
		{
			CurrentGrenadeType = 2;			
		}
		else
		{
			GrenadeCount = int(InvManager.FragGrenadeCount);
			// End:0xF9
			if(GrenadeCount > 0)
			{
				CurrentGrenadeType = 1;
			}
		}
		bGrenadeTypeChanged = int(Last_GrenadeType) != int(CurrentGrenadeType);
		// End:0x166
		if(bGrenadeTypeChanged)
		{
			Last_GrenadeType = CurrentGrenadeType;
			Clip_GrenadeType.GotoAndStopI(int(CurrentGrenadeType));
		}
	}
	// End:0x22D
	if(Last_GrenadeCount != GrenadeCount)
	{
		// End:0x1B8
		if(GrenadeCount < 1)
		{
			Clip_Grenade.GotoAndPlay("transOut");			
		}
		else
		{
			// End:0x1EF
			if(Last_GrenadeCount < 1)
			{
				Clip_Grenade.GotoAndPlay("transIn");
			}
		}
		Last_GrenadeCount = GrenadeCount;
		Text_Grenade.SetText(string(GrenadeCount));
	}
	//return;	
}

function TickAbility(bool bShowAbility)
{
	local HaloPawn HP;
	local float AbilityPct;
	local string IconFrame;
	local GFxHaloMinimapHUD.ArmorAbilityType AbilityType;
	local editinline HaloArmorAbilityComponent ArmorAbility;
	local bool bAbilityAvaible;

	AbilityType = 0;
	bAbilityAvaible = false;
	// End:0xDD
	if(PC.Pawn.IsA('HaloVehicle'))
	{
		// End:0xDA
		if(PC.Pawn.IsA('HaloVehicle_Ghost'))
		{
			AbilityPct = HaloVehicle(PC.Pawn).BoostAmount;
			AbilityType = 1;
		}		
	}
	else
	{
		HP = HaloPawn(PC.Pawn);
		// End:0x2FA
		if(HP != none)
		{
			ArmorAbility = HP.ArmorAbility;
			// End:0x2FA
			if(ArmorAbility != none)
			{
				// End:0x1CE
				if(ArmorAbility.bActive)
				{
					AbilityPct = 200.0000000 - ((ArmorAbility.DurationTimer / ArmorAbility.Duration) * float(100));					
				}
				else
				{
					AbilityPct = (ArmorAbility.CooldownTimer / ArmorAbility.Cooldown) * float(100);
				}
				switch(ArmorAbility.Class)
				{
					// End:0x26F
					case Class'MegaHaloGame.HaloActiveCamoComponent':
						AbilityType = 2;
						IconFrame = "camo";
						// End:0x2FA
						break;
					// End:0x29C
					case Class'MegaHaloGame.HaloBubbleShieldComponent':
						AbilityType = 3;
						IconFrame = "shield";
						// End:0x2FA
						break;
					// End:0xFFFF
					default:
						AbilityType = 0;
						IconFrame = "none";
						WarnInternal(string(ArmorAbility.Class) $ " NOT HOOKED UP IN HUD!");
						// End:0x2FA
						break;
						break;
				}
			}
		}
	}
	// End:0x3FC
	if(int(AbilityType) != int(0))
	{
		// End:0x367
		if(Last_AbilityPct != AbilityPct)
		{
			Last_AbilityPct = AbilityPct;
			Clip_AbilityMeter.GotoAndStopI(int(AbilityPct + float(1)));
		}
		// End:0x3BD
		if(int(Last_AbilityType) != int(AbilityType))
		{
			Last_AbilityType = AbilityType;
			Clip_AbilityIcon.GotoAndStop(IconFrame);
		}
		bAbilityAvaible = ((ArmorAbility != none) ? ArmorAbility.bAvailable : false);		
	}
	else
	{
		bShowAbility = false;
	}
	// End:0x497
	if(Last_bShowAbility != bShowAbility)
	{
		Last_bShowAbility = bShowAbility;
		// End:0x46E
		if(bShowAbility)
		{
			Clip_Ability.GotoAndPlay("transIn");			
		}
		else
		{
			Clip_Ability.GotoAndPlay("transOut");
		}
	}
	// End:0x54F
	if(Last_bAbilityAvailable != bAbilityAvaible)
	{
		// End:0x4EA
		if(!Last_bAbilityAvailable)
		{
			Clip_AbilityState.GotoAndPlay("transIn");			
		}
		else
		{
			Clip_AbilityState.GotoAndPlay("transOut");
		}
		Last_bAbilityAvailable = ((ArmorAbility != none) ? ArmorAbility.bAvailable : false);
	}
	//return;	
}

function TickMissionTimer()
{
	local HaloGameDefault Game;
	local HaloMission mission;
	local HaloObjective Objective;
	local RaceWaypoint activeWaypoint;
	local bool bTimerIsActive;
	local float TimeRemaining, timePct;

	bTimerIsActive = false;
	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x34C
	if(Game != none)
	{
		mission = Game.GetActiveMission();
		// End:0x34C
		if(mission != none)
		{
			Objective = mission.GetHighestPriorityObjective();
			// End:0x2B4
			if(Objective != none)
			{
				switch(Objective.Class)
				{
					// End:0x216
					case Class'MegaHaloGame.HaloObjective_WaypointRace':
						// End:0x213
						if(HaloObjective_WaypointRace(Objective).RaceWaypoints.Length > 0)
						{
							activeWaypoint = HaloObjective_WaypointRace(Objective).RaceWaypoints[0];
							// End:0x213
							if(activeWaypoint.bWaypointIsTimed)
							{
								TimeRemaining = activeWaypoint.WaypointTimeLimit - HaloObjective_WaypointRace(Objective).TimeElapsed;
								timePct = TimeRemaining / activeWaypoint.WaypointTimeLimit;
								bTimerIsActive = true;
							}
						}
						// End:0x21C
						break;
					// End:0xFFFF
					default:
						// End:0x21C
						break;
						break;
				}
				// End:0x2B4
				if(!bTimerIsActive)
				{
					// End:0x2B4
					if(Objective.bIsTimed)
					{
						TimeRemaining = Objective.Timer;
						timePct = TimeRemaining / Objective.TimeLimit;
						bTimerIsActive = true;
					}
				}
			}
			// End:0x34C
			if(!bTimerIsActive)
			{
				// End:0x34C
				if(mission.bIsTimed)
				{
					TimeRemaining = mission.Timer;
					timePct = TimeRemaining / mission.TimeLimit;
					bTimerIsActive = true;
				}
			}
		}
	}
	// End:0x3DB
	if(bTimerIsActive != Last_bMissionTimerActive)
	{
		Last_bMissionTimerActive = bTimerIsActive;
		// End:0x3B2
		if(bTimerIsActive)
		{
			Clip_MissionTimer.GotoAndPlay("transIn");			
		}
		else
		{
			Clip_MissionTimer.GotoAndPlay("transOut");
		}
	}
	// End:0x4B7
	if(bTimerIsActive)
	{
		timePct = FClamp(timePct, 0.0000000, 1.0000000);
		// End:0x453
		if(timePct != Last_MissionTimePct)
		{
			Clip_MissionTimerMeter.GotoAndStopI(int((timePct * float(100)) + float(1)));
		}
		TimeRemaining = FMax(TimeRemaining, 0.0000000);
		// End:0x4B7
		if(TimeRemaining != Last_MissionTimeRemaining)
		{
			Text_MissionTimer.SetText(FormatMissionTime(TimeRemaining));
		}
	}
	//return;	
}

function string FormatMissionTime(float Seconds)
{
	local int Minutes, remainingSeconds;
	local string secondsTensDigit;

	Minutes = int(Seconds / float(60));
	remainingSeconds = int(Seconds % float(60));
	secondsTensDigit = ((remainingSeconds >= 10) ? "" : "0");
	return ((string(Minutes) $ ":") $ secondsTensDigit) $ string(remainingSeconds);
	//return ReturnValue;	
}

function TickTargetDesignator()
{
	local int I, TDItemCount;
	local float TDProgress;
	local DeployableItemInfo TDItemInfo;
	local HaloWeapon_TargetDesignator.ETargetDesignatorCategory TDCategory;
	local HaloWeapon_TargetDesignator TD;

	TD = HaloWeapon_TargetDesignator(PC.Pawn.Weapon);
	// End:0x398
	if(TD != none)
	{
		TDCategory = TD.GetSelectedCategory();
		// End:0x2B5
		if(int(Last_TDCategory) != int(TDCategory))
		{
			Last_TDCategory = TDCategory;
			// End:0x277
			if(int(TDCategory) != int(0))
			{
				ChangeTDCategory(int(TDCategory));
				TDItemCount = TD.GetCategoryItemCount(TDCategory);
				I = 0;
				J0x112:

				// End:0x22A [Loop If]
				if(I < TDItemCount)
				{
					TDItemInfo = TD.GetDeployableItemInfo(TDCategory, I);
					AddTDItem(string(TDItemInfo.Name), TDItemInfo.BlokCost, "img://" $ TDItemInfo.IconPkgPath, TDItemInfo.Unlocked, TD.IsCategoryItemAffordable(TDCategory, I));
					I++;
					// [Loop Continue]
					goto J0x112;
				}
				JumpToTDItem(int(TD.CurrentTDItemIdx));
				Clip_TDBar.SetVisible(true);				
			}
			else
			{
				Last_TDIndex = -1;
				Last_TDProgress = -1.0000000;
				Clip_TDBar.SetVisible(false);
			}
		}
		// End:0x395
		if(int(TDCategory) != int(0))
		{
			I = TD.GetSelectedItemIdx();
			// End:0x32F
			if(Last_TDIndex != I)
			{
				Last_TDIndex = I;
				JumpToTDItem(I);
			}
			TDProgress = TD.GetDeployConfirmPct();
			// End:0x395
			if(Last_TDProgress != TDProgress)
			{
				Last_TDProgress = TDProgress;
				SetTDBuildComplete(TDProgress);
			}
		}		
	}
	else
	{
		// End:0x3F6
		if(int(Last_TDCategory) != int(0))
		{
			Last_TDCategory = 0;
			Last_TDProgress = -1.0000000;
			Last_TDIndex = -1;
			Clip_TDBar.SetVisible(false);
		}
	}
	//return;	
}

function TickVehicleAddOnTarget()
{
	local ASDisplayInfo DI;
	local Vector screenPosition;

	DI.hasVisible = true;
	// End:0x153
	if(bWillShowVAOTarget)
	{
		// End:0x131
		if(IsInfrontOfCamera(VOAPostion))
		{
			ProjectToScreenSpace(VOAPostion, false, screenPosition);
			DI.hasX = true;
			DI.hasY = true;
			DI.X = screenPosition.X;
			DI.Y = screenPosition.Y;
			DI.Visible = true;			
		}
		else
		{
			DI.Visible = false;
		}		
	}
	else
	{
		DI.Visible = false;
	}
	Clip_VAOTarget.SetDisplayInfo(DI);
	//return;	
}

function UpdateVehicleAddOnTarget(Vector TargetPosition)
{
	VOAPostion = TargetPosition;
	//return;	
}

function ShowVehicleAddOnTarget(bool bShow)
{
	bWillShowVAOTarget = bShow;
	//return;	
}

function TickBuildMessage()
{
	local HaloConstructionBuildPadTrigger HCBPT;
	local bool bShowBuildMessage, bCanBuild, bIsBlokConstruction;
	local int CurrentFrame;

	bShowBuildMessage = false;
	HCBPT = PC.ActiveConstructionTrigger;
	// End:0x6A
	if(HCBPT != none)
	{
		bCanBuild = true;
		bIsBlokConstruction = true;
		bShowBuildMessage = true;		
	}
	else
	{
		HCBPT = PC.InactiveConstructionTrigger;
		// End:0xC5
		if(HCBPT != none)
		{
			bCanBuild = false;
			bIsBlokConstruction = true;
			bShowBuildMessage = true;
		}
	}
	// End:0x110
	if(!bShowBuildMessage)
	{
		// End:0x110
		if(PC.ActiveVehiclePanel != none)
		{
			bIsBlokConstruction = false;
			bShowBuildMessage = true;
		}
	}
	// End:0x72D
	if(bShowBuildMessage)
	{
		// End:0x72A
		if(!Last_BMShowing)
		{
			CurrentFrame = Clip_BuildMessageBox.GetInt("_currentframe");
			// End:0x72A
			if(((CurrentFrame == BMEndFrame_TransOut) || CurrentFrame == 1) && int(GMState) == int(1))
			{
				// End:0x55A
				if(bIsBlokConstruction)
				{
					Clip_BMIcon.GotoAndStop("blok");
					Clip_BMMask.GotoAndStop("blok");
					Clip_BMInfoBar.GotoAndStop("blok");
					Text_BMTitle.SetText(HCBPT.GetTypeMessage());
					Clip_BMVehicleIcon.SetVisible(false);
					// End:0x48E
					if(bCanBuild)
					{
						Text_BMBody.SetVisible(false);
						Clip_BMCostIcon.SetVisible(true);
						// End:0x48B
						if(PC.BlokCollector != none)
						{
							// End:0x3EA
							if(HCBPT.GetConstructionCost() > PC.BlokCollector.GetBankCount())
							{
								Text_BMCostNeg.SetVisible(true);
								Text_BMCostNeg.SetText(string(HCBPT.GetConstructionCost()));
								Clip_BMInputIcon.SetVisible(true);
								Text_BMCostPos.SetVisible(false);								
							}
							else
							{
								Text_BMCostPos.SetVisible(true);
								Text_BMCostPos.SetText(string(HCBPT.GetConstructionCost()));
								Clip_BMInputIcon.SetVisible(true);
								Text_BMCostNeg.SetVisible(false);
							}
						}						
					}
					else
					{
						Text_BMBody.SetVisible(true);
						Text_BMCostNeg.SetVisible(false);
						Text_BMCostPos.SetVisible(false);
						Clip_BMCostIcon.SetVisible(false);
						Clip_BMInputIcon.SetVisible(false);
						Text_BMBody.SetText(BlueprintNeeded);
					}					
				}
				else
				{
					Clip_BMIcon.GotoAndStop("vehicle");
					Clip_BMMask.GotoAndStop("vehicle");
					Clip_BMInfoBar.GotoAndStop("vehicle");
					Text_BMTitle.SetText(VehicleCustomization);
					Text_BMBody.SetVisible(false);
					Text_BMCostNeg.SetVisible(false);
					Text_BMCostPos.SetVisible(false);
					Clip_BMCostIcon.SetVisible(false);
					Clip_BMVehicleIcon.SetVisible(true);
					Clip_BMInputIcon.SetVisible(true);
					Clip_BMVehicleIcon.GotoAndPlay("transIn");
				}
				Clip_BuildMessageBox.GotoAndPlay("transIn");
				PlayAkEvent(Audio_BuildMessageOpen);
				Last_BMShowing = true;
			}
		}		
	}
	else
	{
		// End:0x7D1
		if(Last_BMShowing)
		{
			CurrentFrame = Clip_BuildMessageBox.GetInt("_currentframe");
			// End:0x7D1
			if(CurrentFrame == BMEndFrame_TransIn)
			{
				Clip_BuildMessageBox.GotoAndPlay("transOut");
				PlayAkEvent(Audio_BuildMessageClose);
				Last_BMShowing = false;
			}
		}
	}
	//return;	
}

function TickMessages()
{
	local bool bNewMessage;

	bNewMessage = false;
	MessageLine1 = 'None';
	MessageLine2 = 'None';
	MessageCost = -1;
	MessageIcon = 'None';
	MessageProgress = -1.0000000;
	// End:0x1EB
	if((!PC.bCinematicMode && !PC.bIsAimingTargetDesignator) && !PC.bPawnControlsLocked)
	{
		bShowMessage = TickTakedown();
		// End:0x1EB
		if(bShowMessage == false)
		{
			bShowMessage = TickVehicleEntry();
			// End:0x1EB
			if(bShowMessage == false)
			{
				bShowMessage = TickActionableBuildPads();
				// End:0x1EB
				if(bShowMessage == false)
				{
					bShowMessage = TickWeaponPickUp();
					// End:0x1EB
					if(bShowMessage == false)
					{
						bShowMessage = TickBaseEnhancements();
						// End:0x1EB
						if(bShowMessage == false)
						{
							bShowMessage = TickUpgradeAction();
							// End:0x1EB
							if(bShowMessage == false)
							{
								bShowMessage = TickNoAmmo();
								// End:0x1EB
								if(bShowMessage == false)
								{
									bShowMessage = TickVehicleSpecialAbility();
								}
							}
						}
					}
				}
			}
		}
	}
	// End:0x272
	if((Last_bShowMessage != bShowMessage) || bForceMessageUpdate)
	{
		Last_bShowMessage = bShowMessage;
		Clip_Message.SetVisible(bShowMessage);
		bForceMessageUpdate = false;
		bNewMessage = bShowMessage;
	}
	// End:0x557
	if(bShowMessage)
	{
		// End:0x33A
		if(Last_MessageLine1 != MessageLine1)
		{
			Last_MessageLine1 = MessageLine1;
			// End:0x31A
			if(MessageLine1 != 'None')
			{
				Text_MessageLine1.SetTextWithIcon(string(MessageLine1));
				Text_MessageLine1.SetVisible(true);
				bNewMessage = true;				
			}
			else
			{
				Text_MessageLine1.SetVisible(false);
			}
		}
		// End:0x3F5
		if(Last_MessageLine2 != MessageLine2)
		{
			Last_MessageLine2 = MessageLine2;
			// End:0x3D5
			if(MessageLine2 != 'None')
			{
				Text_MessageLine2.SetTextWithIcon(string(MessageLine2));
				Text_MessageLine2.SetVisible(true);
				bNewMessage = true;				
			}
			else
			{
				Text_MessageLine2.SetVisible(false);
			}
		}
		// End:0x4A3
		if(Last_MessageIcon != MessageIcon)
		{
			Last_MessageIcon = MessageIcon;
			// End:0x483
			if(MessageIcon != 'None')
			{
				Clip_MessageIcons.GotoAndStop(string(MessageIcon));
				Clip_MessageIcons.SetVisible(true);				
			}
			else
			{
				Clip_MessageIcons.SetVisible(false);
			}
		}
		// End:0x557
		if(Last_MessageProgress != MessageProgress)
		{
			Last_MessageProgress = MessageProgress;
			// End:0x537
			if(MessageProgress != -1.0000000)
			{
				Clip_MessageProgress.GotoAndStopI(int(MessageProgress * 100.0000000) + 1);
				Clip_MessageProgress.SetVisible(true);				
			}
			else
			{
				Clip_MessageProgress.SetVisible(false);
			}
		}
	}
	// End:0x58C
	if(bNewMessage)
	{
		Clip_Message.GotoAndPlay("transIn");
	}
	//return;	
}

function bool TickVehicleSpecialAbility()
{
	local HaloVehicle HV;
	local HVCCAddon_MagWinch Winch;

	HV = HaloVehicle(PC.Pawn);
	// End:0x127
	if(((HV != none) && HV.HVCC_AttachedAddon != none) && HV.HVCC_AttachedAddon.IsA('HVCCAddon_MagWinch'))
	{
		Winch = HVCCAddon_MagWinch(HV.HVCC_AttachedAddon);
		// End:0x127
		if(Winch.CurrentMagWinchMessage != 'None')
		{
			MessageLine1 = Winch.CurrentMagWinchMessage;
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function bool TickActionableBuildPads()
{
	local string Message;

	// End:0xD7
	if((!PC.bIsAimingTargetDesignator && PC.ActionableStudGrid != none) && PC.ActionableStudGrid.CanBeActionedNow())
	{
		Message = PC.ActionableStudGrid.StudGridInteractMessage;
		MessageLine1 = name(Message);
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool TickBaseEnhancements()
{
	local string Message;
	local HaloBaseEnhanceTrigger BET;

	BET = PC.ActiveEnhancementTrigger;
	// End:0x123
	if(BET != none)
	{
		Message = BET.InteractMessage;
		MessageLine1 = name(Message);
		// End:0xD1
		if(BET.bPromptShouldShowCost)
		{
			MessageCost = BET.BlokCost;
			MessageIcon = 'Blok';
		}
		// End:0x121
		if(BET.RequiredActivationTimeSecs > 0.0000000)
		{
			MessageProgress = BET.ActivationPctProgress;
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool TickVehicleEntry()
{
	local int Seat;
	local string Message;
	local UTVehicle UTV;

	UTV = PC.ActionableVehicleEntry.Vehicle;
	Seat = PC.ActionableVehicleEntry.Seat;
	PC.ActionableVehicleEntry.Vehicle = none;
	PC.ActionableVehicleEntry.Seat = -1;
	// End:0x276
	if(UTV != none)
	{
		// End:0x216
		if(HaloVehicle(UTV) != none)
		{
			switch(Seat)
			{
				// End:0x152
				case 0:
					Message = HaloVehicle(UTV).DriveVehicleMessage;
					// End:0x1FF
					break;
				// End:0x18A
				case 1:
					Message = HaloVehicle(UTV).ManTurretMessage;
					// End:0x1FF
					break;
				// End:0x1C3
				case 2:
					Message = HaloVehicle(UTV).RideInVehicleMessage;
					// End:0x1FF
					break;
				// End:0x1FC
				case 99:
					Message = HaloVehicle(UTV).FlipVehicleMessage;
					// End:0x1FF
					break;
				// End:0xFFFF
				default:
					break;
			}
			MessageLine1 = name(Message);
			return true;
		}
		// End:0x276
		if(HaloTurret(UTV) != none)
		{
			Message = HaloTurret(UTV).ManTurretMessage;
			MessageLine1 = name(Message);
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function bool TickUpgradeAction()
{
	local string Message0, Message1;
	local Actor UpgradeActor;
	local HaloUpgrade Upgrade;
	local HaloUpgradeManager HUM;

	// End:0x74
	if(HaloGameDefault(ThisWorld.Game) != none)
	{
		HUM = HaloGameDefault(ThisWorld.Game).GetUpgradeManager();
	}
	// End:0x347
	if((HUM != none) && HUM.FindUpgradeNearby(UpgradeActor, PC) == true)
	{
		Upgrade = HaloUpgradableInterface(UpgradeActor).GetUpgrade();
		Message0 = "";
		Message1 = "";
		// End:0x1FD
		if(Upgrade.NextUpgrades.Length > 0)
		{
			Message0 = Upgrade.NextUpgrades[0].InteractMessage0;
			// End:0x1FD
			if(Upgrade.NextUpgrades[0].BloksRequired > 0)
			{				
				Message0 @= (("($" $ string(Upgrade.NextUpgrades[0].BloksRequired)) $ ")");
			}
		}
		// End:0x2F3
		if(Upgrade.NextUpgrades.Length > 1)
		{
			Message1 = Upgrade.NextUpgrades[1].InteractMessage1;
			// End:0x2F3
			if(Upgrade.NextUpgrades[1].BloksRequired > 0)
			{				
				Message1 @= (("($" $ string(Upgrade.NextUpgrades[1].BloksRequired)) $ ")");
			}
		}
		// End:0x330
		if(Message1 != "")
		{
			MessageLine1 = name(Message1);
			MessageLine2 = name(Message0);			
		}
		else
		{
			MessageLine1 = name(Message0);
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool TickTakedown()
{
	local HaloPawn Pawn, Target;

	Pawn = HaloPawn(PC.Pawn);
	// End:0x42
	if(Pawn == none)
	{
		return false;
	}
	Target = Pawn.FindTakedownTarget();
	// End:0xB8
	if(Target != none)
	{
		MessageLine1 = name(TakedownMessage);
		MessageLine2 = 'None';
		MessageIcon = 'None';
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool TickNoAmmo()
{
	// End:0xC7
	if((int(Last_PlayerPawnType) == int(1)) || int(Last_PlayerPawnType) == int(2))
	{
		// End:0xC7
		if(!Last_bHasAmmo)
		{
			// End:0x88
			if(SecondaryWeaponHasAmmo())
			{
				MessageLine1 = name(Last_WeaponSecondary.SwapToMessage);
				MessageLine2 = name(OutOfAmmo);				
			}
			else
			{
				MessageLine1 = name(ScavengeNewWeapons);
				MessageLine2 = name(WeaponsEmpty);
			}
			MessageIcon = 'None';
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function bool SecondaryWeaponHasAmmo()
{
	// End:0x9F
	if(Last_WeaponSecondary != none)
	{
		// End:0x56
		if(Last_WeaponSecondary.bIsEnergyPowered)
		{
			return Last_WeaponSecondary.AmmoCount > 0;			
		}
		else
		{
			return (Last_WeaponSecondary.GetAmmoCount() > 0) || Last_WeaponSecondary.ExtraAmmoCount > 0;
		}
	}
	return false;
	//return ReturnValue;	
}

function SetWeaponPickUpMsg(Class<Inventory> PickupType)
{
	local Class<HaloWeapon> HWC;

	HWC = Class<HaloWeapon>(PickupType);
	// End:0xA9
	if((HWC != none) && HWC.default.PickupMessage != "")
	{
		MessageLine1 = name(HWC.default.PickupMessage);
		MessageIcon = name(HWC.default.HUDIcon);		
	}
	else
	{
		MessageLine1 = 'UNSUPPORTED WEAPON TYPE';
	}
	//return;	
}

function bool TickWeaponPickUp()
{
	local HaloPawn HP;
	local HaloDroppedPickup Pickup;
	local Class<Inventory> PickupType;

	HP = HaloPawn(PC.Pawn);
	// End:0x1F6
	if(HP != none)
	{
		// End:0x170
		if((HP.TouchedPickupCount > 0) || HP.ScriptedPickupClassMsg != none)
		{
			PickupType = none;
			// End:0xEE
			foreach HP.TouchingActors(Class'MegaHaloGame.HaloDroppedPickup', Pickup)
			{
				PickupType = Pickup.InventoryClass;
				// End:0xEE
				break;				
			}			
			// End:0x14C
			if((PickupType == none) && HP.ScriptedPickupClassMsg != none)
			{
				PickupType = HP.ScriptedPickupClassMsg;
			}
			// End:0x16E
			if(PickupType != none)
			{
				SetWeaponPickUpMsg(PickupType);
			}
			return true;
		}
		// End:0x1F6
		if(PC.ActiveWeaponCloset != none)
		{
			PickupType = PC.ActiveWeaponCloset.GetWeaponType();
			// End:0x1F4
			if(PickupType != none)
			{
				SetWeaponPickUpMsg(PickupType);
			}
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function TickObjectiveMarkers(float DeltaTime)
{
	local HaloGameDefault Game;
	local HaloMission mission;
	local HaloObjective Objective;
	local array<HaloObjective> Objectives;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x13D
	if(Game != none)
	{
		mission = Game.GetActiveMission();
		// End:0x13D
		if(mission != none)
		{
			// End:0x13C
			foreach mission.Objectives(Objective)
			{
				// End:0x13B
				if(Objective != none)
				{
					Objective.PostRender(HUD.Canvas, self, PC.Pawn);
					Objectives.AddItem(Objective);
				}				
			}			
		}
	}
	// End:0x154
	if(bShowNavMarkers)
	{
		TickNavigationMarkers();
	}
	Minimap.UpdateObjectives(Objectives);
	//return;	
}

function TickNavigationMarkers()
{
	local float Distance, StringWidth, StringHeight;
	local string DistanceString;
	local Vector WorldLocation, ScreenLocation;
	local FontRenderInfo FontRenderInfo;
	local MaterialInstanceConstant MIC;

	Canvas.Font = Font'UI_FontLibrary.Font_ObjectiveMarker';
	FontRenderInfo = Canvas.CreateFontRenderInfo(true, true);
	// End:0x32B
	foreach PC.CompassPath(WorldLocation)
	{
		// End:0x32A
		if(IsInfrontOfCamera(WorldLocation))
		{
			Project(WorldLocation, ScreenLocation);
			MIC = new Class'Engine.MaterialInstanceConstant';
			MIC.SetParent(Material'mainhud.ObjectiveMarkers.ObjectiveMarker_Mat');
			Canvas.SetPos(ScreenLocation.X - 9.0000000, ScreenLocation.Y - 9.0000000);
			Canvas.DrawMaterialTile(MIC, 64.0000000, 64.0000000,,,,, true);
			// End:0x32A
			if(PC.Pawn != none)
			{
				Distance = VSize(PC.Pawn.Location - WorldLocation);
				DistanceString = GetMeterString(Distance);
				Canvas.TextSize(DistanceString, StringWidth, StringHeight);
				Canvas.SetDrawColor(255, 255, 255);
				Canvas.SetPos(ScreenLocation.X + 12.0000000, ScreenLocation.Y + ((9.0000000 - StringHeight) * 0.5000000));
				Canvas.DrawText(DistanceString,,,, FontRenderInfo);
			}
		}		
	}	
	//return;	
}

function TickGrenadeMarkers()
{
	local HaloProjectile_Grenade grenade;
	local Vector ProjectLocation, ScreenLocation;
	local MaterialInstanceConstant MIC;
	local float maxDisSq, DistSq, Rotation;
	local int XOffset, YOffset;
	local float Opacity;

	maxDisSq = GrenadeMarkerMaxDist * GrenadeMarkerMaxDist;
	// End:0x987
	foreach HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).ActiveGrenades(grenade)
	{
		// End:0x986
		if(!grenade.IsInState('Inactive'))
		{
			DistSq = VSizeSq(grenade.Location - PC.Pawn.Location);
			// End:0x986
			if(DistSq <= maxDisSq)
			{
				Project(grenade.Location, ProjectLocation);
				MIC = new Class'Engine.MaterialInstanceConstant';
				MIC.SetParent(Material'mainhud.GrenadeMarkers.GrenadeMarker_Mat');
				MIC.SetTextureParameterValue('Texture', ((HaloProjectile_PlasmaGrenade(grenade) != none) ? Texture2D'mainhud.GrenadeMarkers.GrenadeMarker_PlasmaIcon' : Texture2D'mainhud.GrenadeMarkers.GrenadeMarker_FragIcon'));
				XOffset = -32;
				YOffset = -72;
				ScreenLocation = ProjectLocation;
				// End:0x28E
				if(ScreenLocation.X < float(-XOffset))
				{
					ScreenLocation.X = float(-XOffset);
					ScreenLocation.Y += float(32);					
				}
				else
				{
					// End:0x344
					if(ScreenLocation.X > (Canvas.ClipX + float(XOffset)))
					{
						ScreenLocation.X = Canvas.ClipX + float(XOffset);
						ScreenLocation.Y += float(32);
					}
				}
				// End:0x39F
				if(ScreenLocation.Y < float(-YOffset))
				{
					ScreenLocation.Y = float(-YOffset);					
				}
				else
				{
					// End:0x433
					if(ScreenLocation.Y > (Canvas.ClipY + float(YOffset)))
					{
						ScreenLocation.Y = Canvas.ClipY + float(YOffset);
					}
				}
				// End:0x4F4
				if(!IsInfrontOfCamera(grenade.Location))
				{
					ScreenLocation.X = Canvas.ClipX - ScreenLocation.X;
					ScreenLocation.Y = Canvas.ClipY;
				}
				// End:0x5A3
				if(ProjectLocation == ScreenLocation)
				{
					MIC.SetScalarParameterValue('Rotation', 3.1415927);
					Opacity = ((maxDisSq * 0.5000000) - DistSq) / (maxDisSq * 0.5000000);
					MIC.SetScalarParameterValue('Opacity', Opacity);					
				}
				else
				{
					// End:0x65C
					if(!IsInfrontOfCamera(grenade.Location))
					{
						Rotation = 3.1415927 + Atan((ProjectLocation.X - ScreenLocation.X) / (ProjectLocation.Y - ScreenLocation.Y));						
					}
					else
					{
						// End:0x6A2
						if(ScreenLocation.X == float(-XOffset))
						{
							Rotation = 3.1415927 / float(2);							
						}
						else
						{
							// End:0x708
							if(ScreenLocation.X == (Canvas.ClipX + float(XOffset)))
							{
								Rotation = -3.1415927 / float(2);								
							}
							else
							{
								// End:0x74A
								if(ScreenLocation.Y == float(-YOffset))
								{
									Rotation = -3.1415927;									
								}
								else
								{
									Rotation = 3.1415927;
								}
							}
						}
					}
					MIC.SetScalarParameterValue('Rotation', Rotation);
					Opacity = (maxDisSq - DistSq) / maxDisSq;
					MIC.SetScalarParameterValue('Opacity', Opacity);
				}
				// End:0x8B0
				if(((grenade.ExplodingNowDelay > float(0)) && grenade.TimePassedSinceThrown >= float(0)) && (grenade.ExplodingNowDelay - grenade.TimePassedSinceThrown) <= GrenadeMarkerFlashRedTime)
				{
					MIC.SetScalarParameterValue('Pulse', 1.0000000);					
				}
				else
				{
					MIC.SetScalarParameterValue('Pulse', 0.0000000);
				}
				Canvas.SetPos(ScreenLocation.X + float(XOffset), ScreenLocation.Y + float(YOffset));
				Canvas.DrawMaterialTile(MIC, 64.0000000, 64.0000000,,,,, true);
			}
		}		
	}	
	//return;	
}

function TickRocketTargetMarkers()
{
	local HaloWeapon_UnscRocketLauncher launcher;

	// End:0xB7
	if(PC.Pawn != none)
	{
		launcher = HaloWeapon_UnscRocketLauncher(PC.Pawn.Weapon);
		// End:0xB7
		if(launcher != none)
		{
			launcher.PostRender(HUD.Canvas, self);
		}
	}
	//return;	
}

function ChangeTDCategory(int Category)
{
	Clip_TDBar.ActionScriptVoid("changeCategory");
	//return;	
}

function AddTDItem(string ItemName, int itemCost, string itemImage, bool isUnlocked, bool isAffordable)
{
	Clip_TDBar.ActionScriptVoid("addItemBox");
	//return;	
}

function JumpToTDItem(int Idx)
{
	Clip_TDBar.ActionScriptVoid("jumpToItem");
	//return;	
}

function SetTDBuildComplete(float Idx)
{
	Clip_TDBar.ActionScriptVoid("setBuildComplete");
	//return;	
}

function ToggleCrosshair(bool bToggle)
{
	//return;	
}

function MinimapZoomOut()
{
	// End:0x2E
	if(Minimap != none)
	{
		Minimap.ZoomOut();
	}
	//return;	
}

function MinimapZoomIn()
{
	// End:0x2E
	if(Minimap != none)
	{
		Minimap.ZoomIn();
	}
	//return;	
}

function ShowMissionMessage(string missionName, float DisplayTime)
{
	Text_MMTitle.SetText(missionName);
	MMDisplayTime = DisplayTime;
	bDisplayMissionMessage = true;
	//return;	
}

function ShowNonMMClips(bool bShow)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0xF0 [Loop If]
	if(I < NonMMClips.Length)
	{
		// End:0xA6
		if(!bShow)
		{
			NonMMClipsVisibility[I] = NonMMClips[I].GetBool("_visible");
			NonMMClips[I].SetVisible(false);			
		}
		else
		{
			NonMMClips[I].SetVisible(NonMMClipsVisibility[I]);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function ShowGameMessage(string Title, string Subtitle, float DisplayTime, optional AkEvent Sound = none)
{
	local GameMessageData newMessage;

	newMessage.Title = Title;
	newMessage.Subtitle = Subtitle;
	newMessage.DisplayTime = DisplayTime;
	newMessage.Sound = Sound;
	GameMessages.AddItem(newMessage);
	//return;	
}

function TickGameMessage()
{
	local byte CurrentFrame;

	switch(GMState)
	{
		// End:0x112
		case 1:
			// End:0x87
			if(bDisplayMissionMessage)
			{
				Clip_MissionMessageBox.SetVisible(true);
				Clip_MissionMessageBox.GotoAndPlay("transIn");
				ShowNonMMClips(false);
				GMState = 7;				
			}
			else
			{
				// End:0x10F
				if((GameMessages.Length > 0) && !Last_BMShowing)
				{
					Clip_GameMessageBox.SetVisible(true);
					Clip_GameMessageBox.GotoAndPlay("transIn");
					PlayAkEvent(Audio_GameMessageOpen);
					GMState = 2;
				}
			}
			// End:0x757
			break;
		// End:0x185
		case 2:
			CurrentFrame = byte(Clip_GameMessageBox.GetFloat("_currentframe"));
			// End:0x182
			if(int(CurrentFrame) == int(GMEndFrame_TransIn))
			{
				InitializeGameMessageText();
				GMState = 3;
			}
			// End:0x757
			break;
		// End:0x236
		case 3:
			CurrentFrame = byte(Clip_GMTitle.GetFloat("_currentframe"));
			// End:0x233
			if(int(CurrentFrame) == int(GMEndFrame_TextIn))
			{
				GMTimer = ThisWorld.TimeSeconds + GameMessages[0].DisplayTime;
				GMState = 4;
			}
			// End:0x757
			break;
		// End:0x2C8
		case 4:
			// End:0x2C5
			if(ThisWorld.TimeSeconds >= GMTimer)
			{
				Clip_GMTitle.GotoAndPlay("transOut");
				Clip_GMSubtitle.GotoAndPlay("transOut");
				GMState = 5;
			}
			// End:0x757
			break;
		// End:0x40C
		case 5:
			CurrentFrame = byte(Clip_GMTitle.GetFloat("_currentframe"));
			// End:0x409
			if(int(CurrentFrame) == int(GMEndFrame_TextOut))
			{
				GameMessages.Remove(0, 1);
				// End:0x387
				if(bDisplayMissionMessage)
				{
					Clip_GameMessageBox.GotoAndPlay("transOut");
					PlayAkEvent(Audio_GameMessageClose);
					GMState = 6;					
				}
				else
				{
					// End:0x3C1
					if((GameMessages.Length > 0) && !Last_BMShowing)
					{
						InitializeGameMessageText();
						GMState = 3;						
					}
					else
					{
						Clip_GameMessageBox.GotoAndPlay("transOut");
						PlayAkEvent(Audio_GameMessageClose);
						GMState = 6;
					}
				}
			}
			// End:0x757
			break;
		// End:0x544
		case 6:
			CurrentFrame = byte(Clip_GameMessageBox.GetFloat("_currentframe"));
			// End:0x541
			if(int(CurrentFrame) == int(GMEndFrame_TransOut))
			{
				Clip_GameMessageBox.SetVisible(false);
				Clip_GMTitle.SetVisible(false);
				Clip_GMSubtitle.SetVisible(false);
				// End:0x535
				if(bDisplayMissionMessage)
				{
					Clip_MissionMessageBox.SetVisible(true);
					Clip_MissionMessageBox.GotoAndPlay("transIn");
					ShowNonMMClips(false);
					GMState = 7;					
				}
				else
				{
					GMState = 1;
				}
			}
			// End:0x757
			break;
		// End:0x5DE
		case 7:
			CurrentFrame = byte(Clip_MissionMessageBox.GetFloat("_currentframe"));
			// End:0x5DB
			if(int(CurrentFrame) == MMEndFrame_TransIn)
			{
				GMTimer = ThisWorld.TimeSeconds + MMDisplayTime;
				GMState = 8;
			}
			// End:0x757
			break;
		// End:0x647
		case 8:
			// End:0x644
			if(ThisWorld.TimeSeconds >= GMTimer)
			{
				Clip_MissionMessageBox.GotoAndPlay("transOut");
				GMState = 9;
			}
			// End:0x757
			break;
		// End:0x6E5
		case 9:
			CurrentFrame = byte(Clip_MissionMessageBox.GetFloat("_currentframe"));
			// End:0x6E2
			if(int(CurrentFrame) == MMEndFrame_TransOut)
			{
				Clip_MissionMessageBox.SetVisible(false);
				bDisplayMissionMessage = false;
				ShowNonMMClips(true);
				GMState = 1;
			}
			// End:0x757
			break;
		// End:0xFFFF
		default:
			Clip_GameMessageBox.SetVisible(false);
			Clip_GMTitle.SetVisible(false);
			Clip_GMSubtitle.SetVisible(false);
			GMState = 1;
			// End:0x757
			break;
			break;
	}
	//return;	
}

function InitializeGameMessageText()
{
	Text_GMTitle.SetText(GameMessages[0].Title);
	Text_GMSubtitle.SetText(GameMessages[0].Subtitle);
	// End:0x10C
	if(GameMessages[0].Title == "")
	{
		Clip_GMSubtitle.SetFloat("_y", 0.0000000);
		Clip_GMTitle.SetVisible(false);
		Clip_GMSubtitle.SetVisible(true);		
	}
	else
	{
		// End:0x19C
		if(GameMessages[0].Subtitle == "")
		{
			Clip_GMTitle.SetFloat("_y", 0.0000000);
			Clip_GMTitle.SetVisible(true);
			Clip_GMSubtitle.SetVisible(false);			
		}
		else
		{
			Clip_GMTitle.SetFloat("_y", GMTitleOffset);
			Clip_GMSubtitle.SetFloat("_y", GMSubtitleOffset);
			Clip_GMTitle.SetVisible(true);
			Clip_GMSubtitle.SetVisible(true);
		}
	}
	Clip_GMTitle.GotoAndPlay("transIn");
	Clip_GMSubtitle.GotoAndPlay("transIn");
	// End:0x2D0
	if(GameMessages[0].Sound != none)
	{
		PlayAkEvent(GameMessages[0].Sound);
	}
	//return;	
}

function ShowUpdateMessage(string Message, float DisplayTime, string IconFrame, optional AkEvent Sound = none)
{
	local MessageBarData newMessage;

	newMessage.Message = Message;
	newMessage.DisplayTime = DisplayTime;
	newMessage.IconFrame = IconFrame;
	newMessage.Sound = Sound;
	MBMessages.AddItem(newMessage);
	//return;	
}

function TickMessageBar()
{
	local byte CurrentFrame;

	switch(MBState)
	{
		// End:0x92
		case 1:
			// End:0x8F
			if(MBMessages.Length > 0)
			{
				Clip_MessageBar.SetVisible(true);
				Clip_MessageBar.GotoAndPlay("transIn");
				PlayAkEvent(Audio_UpdateMessageOpen);
				MBState = 2;
			}
			// End:0x3F5
			break;
		// End:0x105
		case 2:
			CurrentFrame = byte(Clip_MessageBar.GetFloat("_currentframe"));
			// End:0x102
			if(int(CurrentFrame) >= int(MBEndFrame_TransIn))
			{
				InitializeMessageBarInfo();
				MBState = 3;
			}
			// End:0x3F5
			break;
		// End:0x1B6
		case 3:
			CurrentFrame = byte(Clip_MBInfo.GetFloat("_currentframe"));
			// End:0x1B3
			if(int(CurrentFrame) == int(MBEndFrame_InfoIn))
			{
				MBTimer = ThisWorld.TimeSeconds + MBMessages[0].DisplayTime;
				MBState = 4;
			}
			// End:0x3F5
			break;
		// End:0x21F
		case 4:
			// End:0x21C
			if(ThisWorld.TimeSeconds >= MBTimer)
			{
				Clip_MBInfo.GotoAndPlay("transOut");
				MBState = 5;
			}
			// End:0x3F5
			break;
		// End:0x2FA
		case 5:
			CurrentFrame = byte(Clip_MBInfo.GetFloat("_currentframe"));
			// End:0x2F7
			if(int(CurrentFrame) == int(MBEndFrame_InfoOut))
			{
				MBMessages.Remove(0, 1);
				// End:0x2AF
				if(MBMessages.Length > 0)
				{
					InitializeMessageBarInfo();
					MBState = 3;					
				}
				else
				{
					Clip_MessageBar.GotoAndPlay("transOut");
					PlayAkEvent(Audio_UpdateMessageClose);
					MBState = 6;
				}
			}
			// End:0x3F5
			break;
		// End:0x3A3
		case 6:
			CurrentFrame = byte(Clip_MessageBar.GetFloat("_currentframe"));
			// End:0x3A0
			if(int(CurrentFrame) == int(MBEndFrame_TransOut))
			{
				Clip_MessageBar.SetVisible(false);
				Clip_MBInfo.SetVisible(false);
				MBState = 1;
			}
			// End:0x3F5
			break;
		// End:0xFFFF
		default:
			Clip_MessageBar.SetVisible(false);
			Clip_MBInfo.SetVisible(false);
			MBState = 1;
			// End:0x3F5
			break;
			break;
	}
	//return;	
}

function InitializeMessageBarInfo()
{
	local int numLines;

	Text_MBText.SetText(MBMessages[0].Message);
	numLines = int(Text_MBText.GetFloat("bottomScroll"));
	// End:0xB6
	if(numLines >= 3)
	{
		Text_MBText.SetFloat("_y", MB3LineY);		
	}
	else
	{
		// End:0xF5
		if(numLines >= 2)
		{
			Text_MBText.SetFloat("_y", MB2LineY);			
		}
		else
		{
			Text_MBText.SetFloat("_y", MB1LineY);
		}
	}
	Clip_MBIcon.GotoAndStop(MBMessages[0].IconFrame);
	Clip_MBInfo.SetVisible(true);
	Clip_MBInfo.GotoAndPlay("transIn");
	// End:0x1F2
	if(MBMessages[0].Sound != none)
	{
		PlayAkEvent(MBMessages[0].Sound);
	}
	//return;	
}

function string GetMeterString(float cm)
{
	local string returnString;
	local float mVal;
	local int digitsToShow;

	mVal = cm * 0.0100000;
	// End:0x3C
	if(mVal >= 1000.0000000)
	{
		digitsToShow = 6;		
	}
	else
	{
		// End:0x5E
		if(mVal >= 100.0000000)
		{
			digitsToShow = 5;			
		}
		else
		{
			// End:0x80
			if(mVal >= 10.0000000)
			{
				digitsToShow = 4;				
			}
			else
			{
				digitsToShow = 3;
			}
		}
	}
	returnString = string(mVal);
	returnString = Left(returnString, digitsToShow);
	returnString = returnString $ "M";
	return returnString;
	//return ReturnValue;	
}

function bool IsInfrontOfCamera(Vector Location)
{
	// End:0xDC
	if(PC != none)
	{
		// End:0xDC
		if(((Location - PC.PlayerCamera.ViewTarget.POV.Location) Dot Vector(PC.PlayerCamera.ViewTarget.POV.Rotation)) >= 0.0000000)
		{
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function Project(Vector WorldLocation, out Vector ScreenLocation)
{
	// End:0x48
	if((Canvas == none) && HUD != none)
	{
		Canvas = HUD.Canvas;
	}
	// End:0x89
	if(Canvas != none)
	{
		ScreenLocation = Canvas.Project(WorldLocation);
	}
	//return;	
}

function ClampToEdge(out Vector ScreenLocation)
{
	// End:0x48
	if((Canvas == none) && HUD != none)
	{
		Canvas = HUD.Canvas;
	}
	// End:0x270
	if(Canvas != none)
	{
		ScreenLocation.X -= Origin.X;
		// End:0x17A
		if(ScreenLocation.Z < 0.0000000)
		{
			ScreenLocation.X = FClamp(-ScreenLocation.X, 0.0000000, Canvas.ClipX);
			ScreenLocation.Y = FClamp(-ScreenLocation.Y, 0.0000000, Canvas.ClipY);			
		}
		else
		{
			ScreenLocation.X = FClamp(ScreenLocation.X, 0.0000000, Canvas.ClipX);
			ScreenLocation.Y = FClamp(ScreenLocation.Y, 0.0000000, Canvas.ClipY);
		}
		ScreenLocation.X += Origin.X;
	}
	//return;	
}

function ProjectToScreenSpace(Vector WorldPosition, bool bClamp, out Vector screenPosition)
{
	// End:0x48
	if((Canvas == none) && HUD != none)
	{
		Canvas = HUD.Canvas;
	}
	// End:0x412
	if(Canvas != none)
	{
		screenPosition = Canvas.Project(WorldPosition);
		// End:0x30F
		if(screenPosition.Z <= float(0))
		{
			// End:0x2C8
			if(bClamp)
			{
				screenPosition.X = FClamp(-screenPosition.X, 0.0000000, Canvas.ClipX);
				screenPosition.Y = FClamp(-screenPosition.Y, 0.0000000, Canvas.ClipY);
				// End:0x2C5
				if((screenPosition.X > 0.0000000) && screenPosition.X < Canvas.ClipX)
				{
					// End:0x2C5
					if((screenPosition.Y > 0.0000000) && screenPosition.Y < Canvas.ClipY)
					{
						screenPosition.Y = float(Round(screenPosition.Y / Canvas.ClipY)) * Canvas.ClipY;
					}
				}				
			}
			else
			{
				screenPosition.X = -100.0000000;
				screenPosition.Y = -100.0000000;
			}			
		}
		else
		{
			// End:0x3D8
			if(bClamp)
			{
				screenPosition.X = FClamp(screenPosition.X, 0.0000000, Canvas.ClipX);
				screenPosition.Y = FClamp(screenPosition.Y, 0.0000000, Canvas.ClipY);
			}
		}
		screenPosition.X += Origin.X;
	}
	//return;	
}

defaultproperties
{
	GMEndFrame_TransIn=24
	GMEndFrame_TransOut=43
	GMEndFrame_TextIn=17
	GMEndFrame_TextOut=33
	MBEndFrame_TransIn=17
	MBEndFrame_TransOut=31
	MBEndFrame_InfoIn=17
	MBEndFrame_InfoOut=33
	Last_Currency=-1.0000000
	bDrawWeaponCrosshairs=true
	BAWithdrawFrame=5
	BACollectOffsetX=130.0000000
	BACollectSpringiness=100.0000000
	BACollectDampening=40.0000000
	BACollectPosYDefault=460.0000000
	BADepositEndX_FS=167.0000000
	BADepositEndY_FS=136.0000000
	BADepositEndX_SS=226.0000000
	BADepositEndY_SS=109.0000000
	BADepositTime=0.5500000
	BAScale_SS=75.0000000
	BlokStreakCollectTime=2.0000000
	BlokStreakTotalTime=5.0000000
	WeaponIconX_1=53.0000000
	WeaponIconX_2=65.0000000
	GrenadeMarkerMaxDist=2000.0000000
	GrenadeMarkerFlashRedTime=0.5000000
	BlueprintNeeded="BLUEPRINT NEEDED"
	VehicleCustomization="BUILD VEHICLE"
	BMEndFrame_TransIn=32
	BMEndFrame_TransOut=57
	Audio_BuildMessageOpen=AkEvent'UIHUD.Play_UI_HUD_Checkpoint'
	Audio_BuildMessageClose=AkEvent'UIHUD.Play_UI_HUD_Checkpoint'
	MMEndFrame_TransIn=52
	MMEndFrame_TransOut=103
	GMTitleOffset=-12.0000000
	GMSubtitleOffset=16.0000000
	Audio_GameMessageOpen=AkEvent'UIHUD.Play_UI_Objective_Appear'
	Audio_GameMessageClose=AkEvent'UIHUD.Play_UI_Objective_Away'
	MB1LineY=-14.0000000
	MB2LineY=-25.5000000
	MB3LineY=-37.0000000
	Audio_UpdateMessageOpen=AkEvent'UIHUD.Play_UI_HUD_Checkpoint'
	Audio_UpdateMessageClose=AkEvent'UIHUD.Play_UI_HUD_Checkpoint'
	TakedownMessage="Press [MainHUD.InlineInputIcons.inputIcon_b] To Takedown"
	OutOfAmmo="Out Of Ammo"
	WeaponsEmpty="Weapons Empty"
	ScavengeNewWeapons="Scavenge New Weapons On The Battlefield"
	PowerCoreDamagedTime=2.0000000
	ShowCombatElementsMinDuration=4.0000000
	LocalizationSection="GFxHaloMinimapHUD"
	MovieInfo=SwfMovie'mainhud.GFx_MainHUD'
	bDisplayWithHudOff=false
	bAllowInput=false
	bAllowFocus=false
}