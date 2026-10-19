class GFxMinimapHud extends GFxMoviePlayer
	config(UI);

struct MessageRow
{
	var GFxObject MC;
	var GFxObject TF;
	var float StartFadeTime;
	var int Y;

	structdefaultproperties
	{
		MC=none
		TF=none
		StartFadeTime=0.0000000
		Y=0
	}
};

var WorldInfo ThisWorld;
var GFxMinimap Minimap;
var float Radius;
var float CurZoomf;
var float NormalZoomf;
var float MaxZoomf;
var float MinZoomf;
var GFxObject LogMC;
var array<MessageRow> Messages;
var array<MessageRow> FreeMessages;
var float MessageHeight;
var int NumMessages;
var GFxObject PlayerStatsMC;
var GFxObject TeamStatsMC;
var GFxObject HealthTF;
var GFxObject HealthBarMC;
var GFxObject AmmoCountTF;
var GFxObject AmmoBarMC;
var GFxObject MaxAmmoMC;
var GFxObject ArmorTF;
var GFxObject ArmorMC;
var GFxObject VArmorMC;
var GFxObject VArmorTF;
var GFxObject TimeTF;
var GFxObject WeaponMC;
var GFxObject ArmorPercTF;
var GFxObject CenterTextMC;
var GFxObject CenterTextTF;
var GFxObject ScoreBarMC[2];
var GFxObject ScoreTF[2];
var GFxObject FlagCarrierMC[2];
var GFxObject FlagCarrierTF[2];
var GFxObject EnemyNameTF;
var GFxObject HitLocMC[8];
var GFxObject MultiKillN_TF;
var GFxObject MultiKillMsg_TF;
var GFxObject MultiKillMC;
var GFxObject ReticuleMC;
var GFxObject RBotMC;
var GFxObject RRightMC;
var GFxObject RTopMC;
var GFxObject RLeftMC;
var UTVehicle LastVehicle;
var UTWeapon LastWeapon;
var float LastHealth;
var float LastArmor;
var float LastVHealth;
var int LastAmmoCount;
var int LastScore[2];
var byte LastFlagHome[2];
var UTPlayerReplicationInfo LastEnemy;
var UTPlayerReplicationInfo LastFlagCarrier[2];
var UTGameReplicationInfo GRI;
var bool bIsTeamHUD;
var bool bDrawWeaponCrosshairs;

function registerMiniMapView(GFxMinimap MC, float R)
{
	Minimap = MC;
	Radius = R;
	CurZoomf = 64.0000000;
	NormalZoomf = 64.0000000;
	// End:0xED
	if(Minimap != none)
	{
		Minimap.Init(self);
		Minimap.SetVisible(false);
		Minimap.SetFloat("_xscale", 85.0000000);
		Minimap.SetFloat("_yscale", 85.0000000);
	}
	//return;	
}

function GFxObject CreateMessageRow()
{
	return LogMC.AttachMovie("LogMessage", "logMessage" $ string(NumMessages++));
	//return ReturnValue;	
}

function GFxObject InitMessageRow()
{
	local MessageRow mrow;

	mrow.Y = 0;
	mrow.MC = CreateMessageRow();
	mrow.TF = mrow.MC.GetObject("message").GetObject("textField");
	mrow.TF.SetBool("html", true);
	mrow.TF.SetString("htmlText", "");
	FreeMessages.AddItem(mrow);
	return mrow.MC;
	//return ReturnValue;	
}

function Init(optional LocalPlayer Player)
{
	local int J;
	local GFxObject TempWidget;

	super.Init(Player);
	ThisWorld = GetPC().WorldInfo;
	GRI = UTGameReplicationInfo(GetPC().WorldInfo.GRI);
	Start();
	Advance(0.0000000);
	NumMessages = 0;
	LastHealth = -110.0000000;
	LastArmor = -110.0000000;
	LastAmmoCount = -110;
	LastScore[0] = -110;
	LastScore[1] = -110;
	TempWidget = GetVariableObject("_root.expBar");
	// End:0x154
	if(TempWidget != none)
	{
		TempWidget.SetBool("_visible", false);
	}
	TempWidget = GetVariableObject("_root.rank");
	// End:0x1AE
	if(TempWidget != none)
	{
		TempWidget.SetBool("_visible", false);
	}
	TempWidget = GetVariableObject("_root.billboard");
	// End:0x20D
	if(TempWidget != none)
	{
		TempWidget.SetBool("_visible", false);
	}
	TempWidget = GetVariableObject("_root.title");
	// End:0x268
	if(TempWidget != none)
	{
		TempWidget.SetBool("_visible", false);
	}
	TempWidget = GetVariableObject("_root.stats");
	// End:0x2C3
	if(TempWidget != none)
	{
		TempWidget.SetBool("_visible", false);
	}
	TempWidget = GetVariableObject("_root.flag");
	// End:0x313
	if(TempWidget != none)
	{
		TempWidget.SetVisible(false);
	}
	TempWidget = GetVariableObject("_root.teamStats.redWinning");
	// End:0x373
	if(TempWidget != none)
	{
		TempWidget.SetVisible(false);
	}
	TempWidget = GetVariableObject("_root.teamStats.blueWinning");
	// End:0x3D4
	if(TempWidget != none)
	{
		TempWidget.SetVisible(false);
	}
	LogMC = GetVariableObject("_root.log");
	J = 0;
	J0x3FF:

	// End:0x427 [Loop If]
	if(J < 15)
	{
		InitMessageRow();
		J++;
		// [Loop Continue]
		goto J0x3FF;
	}
	TeamStatsMC = GetVariableObject("_root.teamStats");
	PlayerStatsMC = GetVariableObject("_root.playerStats");
	PlayerStatsMC.GotoAndStopI(3);
	VArmorTF = GetVariableObject("_root.playerStats.vehicleN");
	VArmorMC = GetVariableObject("_root.playerStats.healthVehicle");
	PlayerStatsMC.GotoAndStopI(2);
	WeaponMC = GetVariableObject("_root.playerStats.weapon");
	HealthTF = GetVariableObject("_root.playerStats.healthN");
	HealthBarMC = GetVariableObject("_root.playerStats.health");
	AmmoCountTF = GetVariableObject("_root.playerStats.ammoN");
	AmmoBarMC = GetVariableObject("_root.playerStats.ammo");
	MaxAmmoMC = GetVariableObject("_root.playerStats.ammo.ammoBG");
	ArmorTF = GetVariableObject("_root.playerStats.armorN");
	ArmorMC = GetVariableObject("_root.playerStats.armor");
	ArmorPercTF = GetVariableObject("_root.playerStats.armorPerc");
	EnemyNameTF = GetVariableObject("_root.teamStats.redName");
	CenterTextTF = GetVariableObject("_root.centerTextMC.centerText.textField");
	CenterTextMC = GetVariableObject("_root.centerTextMC");
	ReticuleMC = GetVariableObject("_root.reticule");
	RBotMC = GetVariableObject("_root.reticule.bottom");
	RTopMC = GetVariableObject("_root.reticule.top");
	RLeftMC = GetVariableObject("_root.reticule.left");
	RRightMC = GetVariableObject("_root.reticule.right");
	MultiKillMC = GetVariableObject("_root.popup");
	TimeTF = GetVariableObject("_root.teamStats.roundTime");
	// End:0x9A1
	if(bIsTeamHUD)
	{
		ScoreBarMC[0] = GetVariableObject("_root.teamStats.teamRed");
		ScoreTF[0] = GetVariableObject("_root.teamStats.scoreRed");
		ScoreBarMC[1] = GetVariableObject("_root.teamStats.teamBlue");
		ScoreTF[1] = GetVariableObject("_root.teamStats.scoreBlue");
		FlagCarrierMC[0] = GetVariableObject("_root.flagRed");
		FlagCarrierMC[1] = GetVariableObject("_root.flagBlue");		
	}
	else
	{
		ScoreBarMC[1] = GetVariableObject("_root.teamStats.teamRed");
		ScoreTF[1] = GetVariableObject("_root.teamStats.scoreRed");
		ScoreBarMC[0] = GetVariableObject("_root.teamStats.teamBlue");
		ScoreTF[0] = GetVariableObject("_root.teamStats.scoreBlue");
		FlagCarrierMC[0] = GetVariableObject("_root.flagBlue");
		FlagCarrierMC[1] = GetVariableObject("_root.flagRed");
	}
	// End:0xB9C
	if(bIsTeamHUD)
	{
		EnemyNameTF.SetVisible(false);
		FlagCarrierTF[0] = FlagCarrierMC[0].GetObject("textField");
		FlagCarrierTF[1] = FlagCarrierMC[1].GetObject("textField");
		FlagCarrierTF[0].SetText("");
		FlagCarrierTF[1].SetText("");		
	}
	else
	{
		EnemyNameTF.SetText("");
		FlagCarrierMC[0].SetVisible(false);
		FlagCarrierMC[1].SetVisible(false);
		ScoreBarMC[0].SetVisible(false);
		ScoreBarMC[1].SetVisible(false);
		ScoreTF[0].SetVisible(false);
		ScoreTF[1].SetVisible(false);
		TeamStatsMC.SetVisible(false);
	}
	HitLocMC[0] = GetVariableObject("_root.dirHit.t");
	HitLocMC[1] = GetVariableObject("_root.dirHit.tr");
	HitLocMC[2] = GetVariableObject("_root.dirHit.r");
	HitLocMC[3] = GetVariableObject("_root.dirHit.br");
	HitLocMC[4] = GetVariableObject("_root.dirHit.b");
	HitLocMC[5] = GetVariableObject("_root.dirHit.bl");
	HitLocMC[6] = GetVariableObject("_root.dirHit.l");
	HitLocMC[7] = GetVariableObject("_root.dirHit.tl");
	LogMC.SetFloat("_yrotation", -15.0000000);
	TeamStatsMC.SetFloat("_yrotation", -15.0000000);
	FlagCarrierMC[0].SetFloat("_yrotation", 15.0000000);
	FlagCarrierMC[1].SetFloat("_yrotation", 15.0000000);
	PlayerStatsMC.SetFloat("_yrotation", 15.0000000);
	ClearStats(true);
	//return;	
}

static function string FormatTime(int Seconds)
{
	local int Hours, Mins;
	local string NewTimeString;

	Hours = Seconds / 3600;
	Seconds -= (Hours * 3600);
	Mins = Seconds / 60;
	Seconds -= (Mins * 60);
	// End:0xAF
	if(Hours > 0)
	{
		NewTimeString = ((Hours > 9) ? string(Hours) : "0" $ string(Hours)) $ ":";
	}
	NewTimeString = (NewTimeString $ ((Mins > 9) ? string(Mins) : "0" $ string(Mins))) $ ":";
	NewTimeString = NewTimeString $ ((Seconds > 9) ? string(Seconds) : "0" $ string(Seconds));
	return NewTimeString;
	//return ReturnValue;	
}

function ClearStats(optional bool clearScores)
{
	local ASDisplayInfo DI;

	DI.hasXScale = true;
	DI.XScale = 0.0000000;
	// End:0x7D
	if(LastVehicle != none)
	{
		PlayerStatsMC.GotoAndStopI(2);
		LastVehicle = none;
	}
	// End:0xF1
	if(LastHealth != float(-10))
	{
		HealthTF.SetString("text", "");
		HealthBarMC.SetDisplayInfo(DI);
		LastHealth = -10.0000000;
	}
	// End:0x16C
	if(LastArmor != float(-10))
	{
		// End:0x135
		if(ArmorMC != none)
		{
			ArmorMC.SetVisible(false);
		}
		ArmorTF.SetString("text", "");
		LastArmor = -10.0000000;
	}
	// End:0x1D7
	if(LastAmmoCount != -10)
	{
		AmmoCountTF.SetString("text", "");
		AmmoBarMC.GotoAndStopI(51);
		LastAmmoCount = -10;
	}
	// End:0x232
	if(LastWeapon != none)
	{
		WeaponMC.SetVisible(false);
		MaxAmmoMC.GotoAndStopI(51);
		LastWeapon = none;
	}
	// End:0x3CA
	if(clearScores && LastScore[0] != -100000)
	{
		// End:0x375
		if(bIsTeamHUD)
		{
			LastScore[0] = -100000;
			LastScore[1] = -100000;
			ScoreTF[0].SetString("text", "");
			ScoreTF[1].SetString("text", "");
			ScoreBarMC[0].SetDisplayInfo(DI);
			ScoreBarMC[1].SetDisplayInfo(DI);
			FlagCarrierTF[0].SetText("");
			FlagCarrierTF[1].SetText("");
		}
		TimeTF.SetString("text", "");
		LastEnemy = none;
		EnemyNameTF.SetText("");
	}
	//return;	
}

function RemoveMessage()
{
	//return;	
}

function AddMessage(string Type, string msg)
{
	local MessageRow mrow;
	local ASDisplayInfo DI;
	local int J;

	// End:0x13
	if(Len(msg) == 0)
	{
		return;
	}
	// End:0x60
	if(FreeMessages.Length > 0)
	{
		mrow = FreeMessages[FreeMessages.Length - 1];
		FreeMessages.Remove(FreeMessages.Length - 1, 1);		
	}
	else
	{
		mrow = Messages[Messages.Length - 1];
		Messages.Remove(Messages.Length - 1, 1);
	}
	mrow.TF.SetString(Type, msg);
	mrow.Y = 0;
	DI.hasY = true;
	DI.Y = 0.0000000;
	mrow.MC.SetDisplayInfo(DI);
	mrow.MC.GotoAndPlay("show");
	J = 0;
	J0x1BC:

	// End:0x29F [Loop If]
	if(J < Messages.Length)
	{
		Messages[J].Y -= int(MessageHeight);
		DI.Y = float(Messages[J].Y);
		Messages[J].MC.SetDisplayInfo(DI);
		J++;
		// [Loop Continue]
		goto J0x1BC;
	}
	Messages.InsertItem(0, mrow);
	//return;	
}

function UpdateGameHUD(UTPlayerReplicationInfo PRI)
{
	local UTPlayerReplicationInfo MaxPRI;
	local int I, J;

	MaxPRI = none;
	I = -10000000;
	J = 0;
	J0x25:

	// End:0x212 [Loop If]
	if(J < GRI.PRIArray.Length)
	{
		// End:0x204
		if(((GRI.PRIArray[J] != PRI) && GRI.PRIArray[J].Score > float(I)) && (GRI.PRIArray[J].Score > float(0)) || GRI.PRIArray[J].Score > PRI.Score)
		{
			I = int(GRI.PRIArray[J].Score);
			MaxPRI = UTPlayerReplicationInfo(GRI.PRIArray[J]);
		}
		J++;
		// [Loop Continue]
		goto J0x25;
	}
	// End:0x28D
	if(MaxPRI != LastEnemy)
	{
		EnemyNameTF.SetText(((MaxPRI != none) ? MaxPRI.PlayerName : ""));
		LastEnemy = MaxPRI;
	}
	//return;	
}

function TickHud(float DeltaTime)
{
	local UTPawn UTP;
	local UTVehicle UTV;
	local UTWeaponPawn UWP;
	local int TotalArmor;
	local UTWeapon Weapon;
	local int I;
	local float F;
	local UTPlayerReplicationInfo PRI;
	local ASDisplayInfo DI;
	local ASColorTransform cxform;
	local PlayerController PC;

	PC = GetPC();
	GRI = UTGameReplicationInfo(PC.WorldInfo.GRI);
	PRI = UTPlayerReplicationInfo(PC.PlayerReplicationInfo);
	// End:0x15D
	if(GRI != none)
	{
		// End:0x13B
		if(TimeTF != none)
		{
			TimeTF.SetString("text", FormatTime(((GRI.TimeLimit != 0) ? GRI.RemainingTime : GRI.ElapsedTime)));
		}
		// End:0x15D
		if(PRI != none)
		{
			UpdateGameHUD(PRI);
		}
	}
	UTP = UTPawn(PC.Pawn);
	// End:0x2F5
	if(UTP == none)
	{
		UTV = UTVehicle(PC.Pawn);
		// End:0x282
		if(UTV == none)
		{
			UWP = UTWeaponPawn(PC.Pawn);
			// End:0x27F
			if(UWP != none)
			{
				UTV = UTVehicle(UWP.MyVehicle);
				UTP = UTPawn(UWP.Driver);
			}			
		}
		else
		{
			UTP = UTPawn(UTV.Driver);
		}
		// End:0x2D2
		if(UTV == none)
		{
			ClearStats();
			return;			
		}
		else
		{
			// End:0x2F5
			if(UTVehicle_Hoverboard(UTV) != none)
			{
				UTV = none;
			}
		}
	}
	// End:0x32C
	if(Minimap != none)
	{
		Minimap.Update(CurZoomf);
	}
	// End:0x3E2
	if(UTV != LastVehicle)
	{
		// End:0x376
		if(UTV == none)
		{
			PlayerStatsMC.GotoAndStopI(2);			
		}
		else
		{
			PlayerStatsMC.GotoAndStopI(3);
		}
		LastVehicle = UTV;
		LastHealth = -101.0000000;
		LastArmor = -101.0000000;
		LastAmmoCount = -101;
		LastWeapon = none;
	}
	// End:0x6D9
	if(LastHealth != float(UTP.Health))
	{
		HealthTF.SetText(string(UTP.Health));
		DI.hasXScale = true;
		DI.XScale = (100.0000000 * float(UTP.Health)) / float(UTP.HealthMax);
		// End:0x65F
		if(DI.XScale >= float(100))
		{
			DI.XScale = 101.0000000;
			F = FMin((float(UTP.Health - 100) / 100.0000000) + 0.1500000, 1.0000000);
			cxform.Multiply.R = 1.0000000 - F;
			cxform.Multiply.G = 1.0000000 - F;
			cxform.Multiply.B = 1.0000000 - F;
			cxform.Add.B = 255.0000000 * F;
		}
		HealthBarMC.SetColorTransform(cxform);
		HealthBarMC.SetDisplayInfo(DI);
		LastHealth = float(UTP.Health);
	}
	TotalArmor = UTP.GetShieldStrength();
	// End:0x82C
	if(float(TotalArmor) != LastArmor)
	{
		// End:0x7C6
		if(TotalArmor > 0)
		{
			// End:0x798
			if(ArmorMC != none)
			{
				ArmorMC.SetVisible(true);
				ArmorMC.GotoAndStopI(((TotalArmor >= 100) ? 100 : 1 + TotalArmor));
			}
			ArmorTF.SetText(string(TotalArmor));			
		}
		else
		{
			// End:0x7F5
			if(ArmorMC != none)
			{
				ArmorMC.SetVisible(false);
			}
			ArmorTF.SetText("");
		}
		LastArmor = float(TotalArmor);
	}
	Weapon = UTWeapon(UTP.Weapon);
	// End:0xAB7
	if((Weapon != none) && UTV == none)
	{
		// End:0x9CE
		if(Weapon != LastWeapon)
		{
			// End:0x8DF
			if(int(Weapon.AmmoDisplayType) == int(3))
			{
				AmmoCountTF.SetText("");
			}
			I = ((Weapon.MaxAmmoCount > 30) ? 30 : Weapon.MaxAmmoCount);
			MaxAmmoMC.GotoAndStopI(31 - I);
			WeaponMC.SetVisible(true);
			WeaponMC.GotoAndStopI(int(Weapon.InventoryGroup));
			LastWeapon = Weapon;
		}
		I = Weapon.GetAmmoCount();
		// End:0xAB4
		if(I != LastAmmoCount)
		{
			LastAmmoCount = I;
			AmmoCountTF.SetText(string(I));
			// End:0xA68
			if(I > 30)
			{
				I = 30;
			}
			AmmoBarMC.GotoAndStopI(31 - I);
			AmmoBarMC.SetVisible(true);
		}		
	}
	else
	{
		// End:0xB30
		if(Weapon != LastWeapon)
		{
			AmmoCountTF.SetText("");
			AmmoBarMC.SetVisible(false);
			WeaponMC.SetVisible(false);
		}
	}
	// End:0xCCB
	if(UTV != none)
	{
		// End:0xCCB
		if(float(UTV.Health) != LastVHealth)
		{
			VArmorTF.SetText(string(UTV.Health));
			DI.hasXScale = true;
			DI.XScale = (100.0000000 * float(UTV.Health)) / float(UTV.HealthMax);
			// End:0xC79
			if(DI.XScale > float(100))
			{
				DI.XScale = 100.0000000;
			}
			VArmorMC.SetDisplayInfo(DI);
			LastVHealth = float(UTV.Health);
		}
	}
	//return;	
}

function ToggleCrosshair(bool bToggle)
{
	bToggle = ((!bDrawWeaponCrosshairs && bToggle) && !UTPlayerController(GetPC()).bNoCrosshair) && UTHUDBase(GetPC().myHUD).bCrosshairShow;
	ReticuleMC.SetVisible(bToggle);
	RBotMC.SetVisible(bToggle);
	RTopMC.SetVisible(bToggle);
	RLeftMC.SetVisible(bToggle);
	RRightMC.SetVisible(bToggle);
	//return;	
}

function MinimapZoomOut()
{
	// End:0x26
	if(CurZoomf < MaxZoomf)
	{
		CurZoomf *= float(2);
	}
	//return;	
}

function MinimapZoomIn()
{
	// End:0x27
	if(CurZoomf > MinZoomf)
	{
		CurZoomf *= 0.5000000;
	}
	//return;	
}

function DisplayHit(Vector HitDir, int Damage, Class<DamageType> DamageType)
{
	local Vector Loc;
	local Rotator Rot;
	local float DirOfHit;
	local Vector AxisX, AxisY, AxisZ, ShotDirection;
	local bool bIsInFront;
	local Vector2D AngularDist;

	// End:0x1C1
	if((Class<UTDamageType>(DamageType) != none) && Class<UTDamageType>(DamageType).default.bLocationalHit)
	{
		GetPC().GetPlayerViewPoint(Loc, Rot);
		GetAxes(Rot, AxisX, AxisY, AxisZ);
		ShotDirection = Normal(HitDir - Loc);
		bIsInFront = GetAngularDistance(AngularDist, ShotDirection, AxisX, AxisY, AxisZ);
		GetAngularDegreesFromRadians(AngularDist);
		DirOfHit = AngularDist.X;
		// End:0x191
		if(bIsInFront)
		{
			DirOfHit = AngularDist.X;
			// End:0x18E
			if(DirOfHit < float(0))
			{
				DirOfHit += float(360);
			}			
		}
		else
		{
			DirOfHit = 180.0000000 + AngularDist.X;
		}		
	}
	else
	{
		DirOfHit = 180.0000000;
	}
	HitLocMC[int(DirOfHit / 45.0000000)].GotoAndPlay("on");
	//return;	
}

function ShowMultiKill(int N, string msg)
{
	// End:0x7D
	if(MultiKillN_TF == none)
	{
		MultiKillN_TF = GetVariableObject("_root.popup.popupNumber.textField");
		MultiKillMsg_TF = GetVariableObject("_root.popup.popupText.textField");
	}
	MultiKillN_TF.SetText(string(N + 1));
	MultiKillMsg_TF.SetText(msg);
	MultiKillMC.GotoAndPlay("on");
	//return;	
}

function SetCenterText(string Text)
{
	CenterTextTF.SetText(Text);
	CenterTextMC.GotoAndPlay("on");
	//return;	
}

function string GetRank(PlayerReplicationInfo PRI)
{
	local int I, J;

	I = -10000000;
	J = 0;
	J0x1A:

	// End:0xEB [Loop If]
	if(J < GRI.PRIArray.Length)
	{
		// End:0xDD
		if(GRI.PRIArray[J].Score > float(I))
		{
			I = int(GRI.PRIArray[J].Score);
		}
		J++;
		// [Loop Continue]
		goto J0x1A;
	}
	// End:0x156
	if((PRI.Score >= float(I)) && PRI.Score > float(0))
	{
		return "<img src='rank15'>";
	}
	return "";
	//return ReturnValue;	
}

function AddDeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Killed, Class<UTDamageType> Dmg)
{
	local string msg;
	local byte Index;

	// End:0x4C
	if(Killer != none)
	{
		msg = (GetRank(Killer)) @ Killer.PlayerName;
	}
	// End:0xEF
	if((Dmg != none) && Dmg.default.DamageWeaponClass != none)
	{
		Index = ((ClassIsChildOf(Dmg.default.DamageWeaponClass, Class'UTGame.UTWeap_LinkGun')) ? 5 : Dmg.default.DamageWeaponClass.default.InventoryGroup);
	}
	// End:0x144
	if(int(Index) < int(12))
	{		
		msg @= (("<img src='ut3_weapon" $ string(Index)) $ "'>");		
	}
	else
	{		
		msg @= "<img src='skull'>";
	}	
	msg @= ((GetRank(Killed)) @ Killed.PlayerName);
	AddMessage("htmlText", msg);
	//return;	
}

defaultproperties
{
	MaxZoomf=128.0000000
	MinZoomf=16.0000000
	MessageHeight=38.0000000
	bDrawWeaponCrosshairs=true
	MovieInfo=SwfMovie'UDKHUD.udk_hud'
	bDisplayWithHudOff=false
	bAllowInput=false
	bAllowFocus=false
}