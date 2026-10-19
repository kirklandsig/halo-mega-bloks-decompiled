class UTHUD extends UTHUDBase
	transient
	config(Game);

struct native DamageInfo
{
	var float FadeTime;
	var float FadeValue;
	var MaterialInstanceConstant MatConstant;

	structdefaultproperties
	{
		FadeTime=0.0000000
		FadeValue=0.0000000
		MatConstant=none
	}
};

var Class<UTLocalMessage> WeaponSwitchMessage;
var const Texture2D AltHudTexture;
var const Texture2D TalkingTexture;
var const Texture2D UT3GHudTexture;
var const LinearColor LC_White;
var const Color GrayColor;
var float LastAmmoPickupTime;
var float LastHealthPickupTime;
var float LastArmorPickupTime;
var Pawn PawnOwner;
var UTPawn UTPawnOwner;
var UTPlayerReplicationInfo UTOwnerPRI;
var bool bShowAllAI;
var bool bHudMessageRendered;
var config bool bShowWeaponbar;
var config bool bOnlyShowWeaponBarIfChanging;
var bool bNoWeaponNumbers;
var bool bFadeOutHitEffect;
var globalconfig bool bShowClock;
var globalconfig bool bShowDoll;
var globalconfig bool bShowAmmo;
var bool bHasMap;
var globalconfig bool bShowMap;
var globalconfig bool bShowPowerups;
var bool bDisplayingPowerups;
var globalconfig bool bShowScoring;
var bool bShowFragCount;
var bool bHasLeaderboard;
var bool bShowLeaderboard;
var globalconfig bool bShowVehicle;
var bool bShowVehicleArmorCount;
var bool bIsFirstPlayer;
var array<Font> HudFonts;
var Material CharPortraitMaterial;
var MaterialInstanceConstant CharPortraitMI;
var float CharPortraitYPerc;
var float CharPortraitXPerc;
var float CharPortraitTime;
var float CharPortraitSlideTime;
var float CharPortraitSlideTransitionTime;
var Vector2D CharPortraitSize;
var UTPlayerReplicationInfo CharPRI;
var UTPlayerReplicationInfo CharPendingPRI;
var float WeaponBarScale;
var float WeaponBoxWidth;
var float WeaponBoxHeight;
var float HUDScaleX;
var float HUDScaleY;
var LinearColor TeamHUDColor;
var Color TeamTextColor;
var float WeaponBarY;
var UTWeapon WeaponList[10];
var float CurrentWeaponScale[10];
var float SelectedWeaponScale;
var float BounceWeaponScale;
var float SelectedWeaponAlpha;
var float OffWeaponAlpha;
var float EmptyWeaponAlpha;
var float LastHUDUpdateTime;
var int BouncedWeapon;
var float WeaponScaleSpeed;
var float WeaponBarXOffset;
var float WeaponXOffset;
var float SelectedBoxScale;
var float WeaponYScale;
var float WeaponYOffset;
var float WeaponAmmoLength;
var float WeaponAmmoThickness;
var float WeaponAmmoOffsetX;
var float WeaponAmmoOffsetY;
var float SelectedWeaponAmmoOffsetX;
var float LastWeaponBarDrawnTime;
var float MessageOffset[7];
var Texture2D MapBackground;
var config float MapDefaultSize;
var string DisplayedOrders;
var float OrderUpdateTime;
var Weapon LastSelectedWeapon;
var config float SafeRegionPct;
var float FullWidth;
var float FullHeight;
var int MaxNoOfIndicators;
var array<DamageInfo> DamageData;
var Material BaseMaterial;
var float FadeTime;
var name PositionalParamName;
var name FadeParamName;
var float HitEffectIntensity;
var LinearColor MaxHitEffectColor;
var float HitEffectFadeTime;
var MaterialEffect HitEffect;
var transient MaterialInstanceConstant HitEffectMaterialInstance;
var Vector2D ClockPosition;
var Vector2D DollPosition;
var float LastDollUpdate;
var float DollVisibility;
var TextureCoordinates HealthBGCoords;
var float HealthOffsetX;
var float HealthBGOffsetX;
var float HealthBGOffsetY;
var float HealthIconX;
var float HealthIconY;
var float HealthTextX;
var float HealthTextY;
var int LastHealth;
var float HealthPulseTime;
var TextureCoordinates ArmorBGCoords;
var float ArmorBGOffsetX;
var float ArmorBGOffsetY;
var float ArmorIconX;
var float ArmorIconY;
var float ArmorTextX;
var float ArmorTextY;
var int LastArmorAmount;
var float ArmorPulseTime;
var Vector2D AmmoPosition;
var float AmmoBarOffsetY;
var TextureCoordinates AmmoBGCoords;
var float AmmoTextOffsetX;
var float AmmoTextOffsetY;
var UTWeapon LastWeapon;
var int LastAmmoCount;
var float AmmoPulseTime;
var Vector2D MapPosition;
var Vector2D PowerupDims;
var float PowerupYPos;
var float PowerupTransitionTime;
var Vector2D ScoringPosition;
var float FragPulseTime;
var int LastFragCount;
var Vector2D VehiclePosition;
var globalconfig float DamageIndicatorSize;
var float NameplateWidth;
var float NameplateBubbleWidth;
var TextureCoordinates NameplateLeft;
var TextureCoordinates NameplateCenter;
var TextureCoordinates NameplateBubble;
var TextureCoordinates NameplateRight;
var LinearColor BlackBackgroundColor;
var const localized string WarmupString;
var const localized string WaitingForMatch;
var const localized string PressFireToBegin;
var const localized string SpectatorMessage;
var const localized string DeadMessage;
var const localized string FireToRespawnMessage;
var const localized string YouHaveWon;
var const localized string YouHaveLost;
var const localized string PlaceMarks[4];
var TextureCoordinates PawnDollBGCoords;
var float DollOffsetX;
var float DollOffsetY;
var float DollWidth;
var float DollHeight;
var float VestX;
var float VestY;
var float VestWidth;
var float VestHeight;
var float ThighX;
var float ThighY;
var float ThighWidth;
var float ThighHeight;
var float HelmetX;
var float HelmetY;
var float HelmetWidth;
var float HelmetHeight;
var float BootX;
var float BootY;
var float BootWidth;
var float BootHeight;
var float THeight;
var float TX;
var float TY;
var const LinearColor AmmoBarColor;
var const LinearColor RedLinearColor;
var const LinearColor BlueLinearColor;
var const LinearColor DMLinearColor;
var const LinearColor WhiteLinearColor;
var const LinearColor GoldLinearColor;
var const LinearColor SilverLinearColor;
var Texture2D BkgTexture;
var TextureCoordinates BkgTexCoords;
var Color BkgTexColor;

function DrawTileCentered(Texture2D Tex, float XL, float YL, float U, float V, float UL, float VL, LinearColor C)
{
	local float X, Y;

	X = Canvas.CurX - (XL * 0.5000000);
	Y = Canvas.CurY - (YL * 0.5000000);
	Canvas.SetPos(X, Y, Canvas.CurZ);
	Canvas.DrawTile(Tex, XL, YL, U, V, UL, VL, C);
	//return;	
}

function SetDisplayedOrders(string OrderText)
{
	DisplayedOrders = OrderText;
	OrderUpdateTime = WorldInfo.TimeSeconds;
	//return;	
}

exec function GrowHUD()
{
	// End:0x25
	if(Class'Engine.WorldInfo'.static.IsConsoleBuild())
	{
		return;
	}
	// End:0x43
	if(!bShowDoll)
	{
		bShowDoll = true;		
	}
	else
	{
		// End:0x7E
		if(!bShowAmmo || !bShowVehicle)
		{
			bShowAmmo = true;
			bShowVehicle = true;			
		}
		else
		{
			// End:0x9C
			if(!bShowScoring)
			{
				bShowScoring = true;				
			}
			else
			{
				// End:0xBA
				if(!bShowWeaponbar)
				{
					bShowWeaponbar = true;					
				}
				else
				{
					// End:0xD8
					if(!bShowVehicleArmorCount)
					{
						bShowVehicleArmorCount = true;						
					}
					else
					{
						// End:0xF6
						if(!bShowPowerups)
						{
							bShowPowerups = true;							
						}
						else
						{
							// End:0x131
							if(!bShowMap || !bShowLeaderboard)
							{
								bShowMap = true;
								bShowLeaderboard = true;								
							}
							else
							{
								// End:0x14C
								if(!bShowClock)
								{
									bShowClock = true;
								}
							}
						}
					}
				}
			}
		}
	}
	//return;	
}

exec function ShrinkHUD()
{
	// End:0x25
	if(Class'Engine.WorldInfo'.static.IsConsoleBuild())
	{
		return;
	}
	// End:0x41
	if(bShowClock)
	{
		bShowClock = false;		
	}
	else
	{
		// End:0x78
		if(bShowMap || bShowLeaderboard)
		{
			bShowMap = false;
			bShowLeaderboard = false;			
		}
		else
		{
			// End:0x94
			if(bShowPowerups)
			{
				bShowPowerups = false;				
			}
			else
			{
				// End:0xB0
				if(bShowVehicleArmorCount)
				{
					bShowVehicleArmorCount = false;					
				}
				else
				{
					// End:0xCC
					if(bShowWeaponbar)
					{
						bShowWeaponbar = false;						
					}
					else
					{
						// End:0xE8
						if(bShowScoring)
						{
							bShowScoring = false;							
						}
						else
						{
							// End:0x11F
							if(bShowAmmo || bShowVehicle)
							{
								bShowAmmo = false;
								bShowVehicle = false;								
							}
							else
							{
								// End:0x138
								if(bShowDoll)
								{
									bShowDoll = false;
								}
							}
						}
					}
				}
			}
		}
	}
	//return;	
}

simulated function PostBeginPlay()
{
	local int I;

	super.PostBeginPlay();
	// End:0x2E
	if(UTConsolePlayerController(PlayerOwner) != none)
	{
		bNoWeaponNumbers = true;
	}
	DamageData.Length = MaxNoOfIndicators;
	I = 0;
	J0x4D:

	// End:0x181 [Loop If]
	if(I < MaxNoOfIndicators)
	{
		DamageData[I].FadeTime = 0.0000000;
		DamageData[I].FadeValue = 0.0000000;
		DamageData[I].MatConstant = new (self) Class'Engine.MaterialInstanceConstant';
		// End:0x173
		if((DamageData[I].MatConstant != none) && BaseMaterial != none)
		{
			DamageData[I].MatConstant.SetParent(BaseMaterial);
		}
		I++;
		// [Loop Continue]
		goto J0x4D;
	}
	//return;	
}

function NotifyBindPostProcessEffects()
{
	HitEffect = MaterialEffect(LocalPlayer(PlayerOwner.Player).PlayerPostProcess.FindPostProcessEffect('HitEffect'));
	// End:0x1C8
	if(HitEffect != none)
	{
		// End:0x122
		if((MaterialInstanceConstant(HitEffect.Material) != none) && HitEffect.Material.GetPackageName() == 'Transient')
		{
			HitEffectMaterialInstance = MaterialInstanceConstant(HitEffect.Material);			
		}
		else
		{
			HitEffectMaterialInstance = new (HitEffect) Class'Engine.MaterialInstanceConstant';
			HitEffectMaterialInstance.SetParent(HitEffect.Material);
			HitEffect.Material = HitEffectMaterialInstance;
		}
		HitEffect.bShowInGame = false;
	}
	//return;	
}

function Message(PlayerReplicationInfo PRI, coerce string msg, name MsgType, optional float Lifetime)
{
	local Class<LocalMessage> MsgClass;

	// End:0x2D
	if(bMessageBeep)
	{
		PlayerOwner.PlayBeepSound();
	}
	MsgClass = Class'UTGame.UTSayMsg';
	// End:0xD3
	if((MsgType == 'Say') || MsgType == 'TeamSay')
	{
		msg = (PRI.PlayerName $ ": ") $ msg;
		// End:0xD3
		if(MsgType == 'TeamSay')
		{
			MsgClass = Class'UTGame.UTTeamSayMsg';
		}
	}
	AddConsoleMessage(msg, MsgClass, PRI, Lifetime);
	//return;	
}

function Vector2D ResolveHUDPosition(Vector2D Position, float Width, float Height)
{
	local Vector2D FinalPos;

	FinalPos.X = ((Position.X < float(0)) ? (Canvas.ClipX - (Position.X * ResolutionScale)) - (Width * ResolutionScale) : Position.X * ResolutionScale);
	FinalPos.Y = ((Position.Y < float(0)) ? (Canvas.ClipY - (Position.Y * ResolutionScale)) - (Height * ResolutionScale) : Position.Y * ResolutionScale);
	return FinalPos;
	//return ReturnValue;	
}

function GetScreenCoords(float PosY, out float ScreenX, out float ScreenY, out HudLocalizedMessage InMessage)
{
	local float Offset, MapSize;

	// End:0x133
	if(PosY > 1.0000000)
	{
		Offset = PosY - float(int(PosY));
		// End:0x60
		if(Offset < float(0))
		{
			Offset = Offset + 1.0000000;
		}
		// End:0xAA
		if(bIsSplitScreen)
		{
			ScreenY = (0.1500000 + Offset) * Canvas.ClipY;			
		}
		else
		{
			ScreenY = (0.3800000 + Offset) * Canvas.ClipY;
		}
		ScreenX = (0.9800000 * Canvas.ClipX) - InMessage.DX;
		return;
	}
	ScreenX = 0.5000000 * Canvas.ClipX;
	ScreenY = ((PosY * HudCanvasScale) * Canvas.ClipY) + (((1.0000000 - HudCanvasScale) * 0.5000000) * Canvas.ClipY);
	ScreenX -= (InMessage.DX * 0.5000000);
	ScreenY -= (InMessage.DY * 0.5000000);
	// End:0x3DE
	if((bHasMap && bShowMap) && !bIsSplitScreen)
	{
		MapSize = (MapDefaultSize * Canvas.ClipY) / float(768);
		// End:0x3DE
		if((ScreenY < ((MapPosition.Y * Canvas.ClipY) + MapSize)) && (ScreenX + InMessage.DX) > ((MapPosition.X * Canvas.ClipX) - MapSize))
		{
			ScreenX = FMax(1.0000000, ((MapPosition.X * Canvas.ClipX) - MapSize) - InMessage.DX);
		}
	}
	//return;	
}

function DrawMessageText(HudLocalizedMessage LocalMessage, float ScreenX, float ScreenY)
{
	local Color CanvasColor;
	local string StringMessage;

	// End:0x4E
	if(Canvas.Font == none)
	{
		Canvas.Font = GetFontSizeIndex(0);
	}
	StringMessage = LocalMessage.StringMessage;
	// End:0x107
	if(LocalMessage.Count > 0)
	{
		// End:0xCD
		if(Right(StringMessage, 1) ComplementEqual ".")
		{
			StringMessage = Left(StringMessage, Len(StringMessage) - 1);
		}
		StringMessage = (StringMessage $ " X ") $ string(LocalMessage.Count);
	}
	CanvasColor = Canvas.DrawColor;
	Canvas.DrawColor = BlackColor;
	Canvas.DrawColor.A = CanvasColor.A;
	Canvas.SetPos(ScreenX + float(2), ScreenY + float(2));
	Canvas.DrawText(StringMessage, false,,, TextRenderInfo);
	Canvas.DrawColor = CanvasColor;
	Canvas.SetPos(ScreenX, ScreenY);
	Canvas.DrawText(StringMessage, false,,, TextRenderInfo);
	//return;	
}

event PostRender()
{
	local int TeamIndex;
	local LocalPlayer LP;

	super.PostRender();
	LP = LocalPlayer(PlayerOwner.Player);
	bIsFirstPlayer = (LP != none) && LP.Outer.GamePlayers[0] == LP;
	bHudMessageRendered = false;
	PawnOwner = Pawn(PlayerOwner.ViewTarget);
	// End:0x10B
	if(PawnOwner == none)
	{
		PawnOwner = PlayerOwner.Pawn;
	}
	UTPawnOwner = UTPawn(PawnOwner);
	// End:0x188
	if(UTPawnOwner == none)
	{
		// End:0x188
		if(UDKVehicleBase(PawnOwner) != none)
		{
			UTPawnOwner = UTPawn(UDKVehicleBase(PawnOwner).Driver);
		}
	}
	UTOwnerPRI = UTPlayerReplicationInfo(UTPlayerOwner.PlayerReplicationInfo);
	PlayerOwner.DrawDebugTextList(Canvas, RenderDelta);
	TeamIndex = 2;
	// End:0x2B9
	if(PawnOwner != none)
	{
		// End:0x2B6
		if((PawnOwner.PlayerReplicationInfo != none) && PawnOwner.PlayerReplicationInfo.Team != none)
		{
			TeamIndex = PawnOwner.PlayerReplicationInfo.Team.TeamIndex;
		}		
	}
	else
	{
		// End:0x36A
		if((PlayerOwner.PlayerReplicationInfo != none) && PlayerOwner.PlayerReplicationInfo.Team != none)
		{
			TeamIndex = PlayerOwner.PlayerReplicationInfo.Team.TeamIndex;
		}
	}
	HUDScaleX = Canvas.ClipX / float(1280);
	HUDScaleY = Canvas.ClipX / float(1280);
	GetTeamColor(TeamIndex, TeamHUDColor, TeamTextColor);
	FullWidth = Canvas.ClipX;
	FullHeight = Canvas.ClipY;
	UpdateDamage();
	// End:0x46B
	if(bShowScores || UTGRI == none)
	{
		return;
	}
	// End:0x491
	if(bShowHUD && bShowGameHud)
	{
		DrawHUD();
	}
	// End:0x4A8
	if(bShowMobileHud)
	{
		DrawInputZoneOverlays();
	}
	RenderMobileMenu();
	//return;	
}

function DrawHUD()
{
	local float X, Y, W, H, XL, YL;

	local Vector ViewPoint;
	local Rotator ViewRotation;

	// End:0xCC
	if((((UTGRI != none) && !UTGRI.bMatchIsOver) && bShowHUD) && PawnOwner != none)
	{
		Canvas.Font = GetFontSizeIndex(0);
		PlayerOwner.GetPlayerViewPoint(ViewPoint, ViewRotation);
		DrawActorOverlays(ViewPoint, ViewRotation);
	}
	W = FullWidth * SafeRegionPct;
	X = Canvas.OrgX + ((Canvas.ClipX - W) * 0.5000000);
	H = FullHeight * SafeRegionPct;
	// End:0x1C4
	if(bIsSplitScreen)
	{
		// End:0x1B2
		if(bIsFirstPlayer)
		{
			Y = Canvas.ClipY - H;			
		}
		else
		{
			Y = 0.0000000;
		}		
	}
	else
	{
		Y = Canvas.OrgY + ((Canvas.ClipY - H) * 0.5000000);
	}
	Canvas.OrgX = X;
	Canvas.OrgY = Y;
	Canvas.ClipX = W;
	Canvas.ClipY = H;
	Canvas.Reset(true);
	RenderDelta = WorldInfo.TimeSeconds - LastHUDRenderTime;
	LastHUDRenderTime = WorldInfo.TimeSeconds;
	// End:0x39B
	if((UTGRI != none) && !UTGRI.bMatchIsOver)
	{
		PlayerOwner.DrawHUD(self);
		DrawGameHud();		
	}
	else
	{
		DrawPostGameHud();
		// End:0x524
		if(WorldInfo.Pauser != none)
		{
			Canvas.Font = GetFontSizeIndex(2);
			Canvas.StrLen(Class'UTGame.UTGameViewportClient'.default.LevelActionMessages[1], XL, YL);
			Canvas.SetDrawColor(255, 255, 255, 255);
			Canvas.SetPos(0.5000000 * (Canvas.ClipX - XL), 0.4400000 * Canvas.ClipY);
			Canvas.DrawText(Class'UTGame.UTGameViewportClient'.default.LevelActionMessages[1]);
		}
	}
	LastHUDUpdateTime = WorldInfo.TimeSeconds;
	//return;	
}

exec function ShowAllAI()
{
	bShowAllAI = !bShowAllAI;
	//return;	
}

exec function ShowSquadRoutes()
{
	local UTBot B;
	local int I, J;
	local byte Red, Green, Blue;

	// End:0x28C
	if(PawnOwner != none)
	{
		B = UTBot(PawnOwner.Controller);
		// End:0x28C
		if((B != none) && B.Squad != none)
		{
			FlushPersistentDebugLines();
			I = 0;
			J0x8A:

			// End:0x28C [Loop If]
			if(I < B.Squad.SquadRoutes.Length)
			{
				Red = byte(Rand(255));
				Green = byte(Rand(255));
				Blue = byte(Rand(255));
				J = 0;
				J0x107:

				// End:0x27E [Loop If]
				if(J < (B.Squad.SquadRoutes[I].RouteCache.Length - 1))
				{
					DrawDebugLine(B.Squad.SquadRoutes[I].RouteCache[J].Location, B.Squad.SquadRoutes[I].RouteCache[J + 1].Location, Red, Green, Blue, true);
					J++;
					// [Loop Continue]
					goto J0x107;
				}
				I++;
				// [Loop Continue]
				goto J0x8A;
			}
		}
	}
	//return;	
}

function DrawGameHud()
{
	local float XL, YL, YPos, TempResScale;
	local Pawn P;
	local int I, Len;
	local UniqueNetId OtherPlayerNetId;

	// End:0x271
	if(UTOwnerPRI != none)
	{
		// End:0x188
		if(UTOwnerPRI.bOnlySpectator || UTPlayerOwner.IsInState('Spectating'))
		{
			P = Pawn(UTPlayerOwner.ViewTarget);
			// End:0x168
			if(((P != none) && P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo != UTOwnerPRI)
			{
				// End:0x165
				if(UTPlayerOwner.bBehindView)
				{
					DisplayHUDMessage((SpectatorMessage @ "-") @ P.PlayerReplicationInfo.PlayerName, 0.0500000, 0.1500000);
				}				
			}
			else
			{
				DisplayHUDMessage(SpectatorMessage, 0.0500000, 0.1500000);
			}			
		}
		else
		{
			// End:0x20D
			if(UTOwnerPRI.bIsSpectator)
			{
				// End:0x1F5
				if((UTGRI != none) && UTGRI.bMatchHasBegun)
				{
					DisplayHUDMessage(PressFireToBegin);					
				}
				else
				{
					DisplayHUDMessage(WaitingForMatch);
				}				
			}
			else
			{
				// End:0x271
				if(UTPlayerOwner.IsDead())
				{
					DisplayHUDMessage(((UTPlayerOwner.bFrozen) ? DeadMessage : FireToRespawnMessage));
				}
			}
		}
	}
	// End:0x3D2
	if((UTGRI != none) && UTGRI.bWarmupRound)
	{
		Canvas.Font = GetFontSizeIndex(2);
		Canvas.DrawColor = WhiteColor;
		Canvas.StrLen(WarmupString, XL, YL);
		Canvas.SetPos((Canvas.ClipX - XL) * 0.5000000, Canvas.ClipY * 0.1750000);
		Canvas.DrawText(WarmupString);
	}
	// End:0x403
	if(bCrosshairOnFriendly)
	{
		bGreenCrosshair = CheckCrosshairOnFriendly();
		bCrosshairOnFriendly = false;		
	}
	else
	{
		bGreenCrosshair = false;
	}
	// End:0x570
	if(bShowDebugInfo)
	{
		Canvas.Font = GetFontSizeIndex(0);
		Canvas.DrawColor = ConsoleColor;
		Canvas.StrLen("X", XL, YL);
		YPos = 0.0000000;
		PlayerOwner.ViewTarget.DisplayDebug(self, YL, YPos);
		// End:0x56E
		if((ShouldDisplayDebug('AI')) && Pawn(PlayerOwner.ViewTarget) != none)
		{
			DrawRoute(Pawn(PlayerOwner.ViewTarget));
		}
		return;
	}
	// End:0x587
	if(bShowAllAI)
	{
		DrawAIOverlays();
	}
	// End:0x706
	if(WorldInfo.Pauser != none)
	{
		Canvas.Font = GetFontSizeIndex(2);
		Canvas.StrLen(Class'UTGame.UTGameViewportClient'.default.LevelActionMessages[1], XL, YL);
		Canvas.SetDrawColor(255, 255, 255, 255);
		Canvas.SetPos(0.5000000 * (Canvas.ClipX - XL), 0.4400000 * Canvas.ClipY);
		Canvas.DrawText(Class'UTGame.UTGameViewportClient'.default.LevelActionMessages[1]);
	}
	DisplayLocalMessages();
	DisplayConsoleMessages();
	Canvas.Font = GetFontSizeIndex(1);
	// End:0xA3E
	if((((CharPRI == none) && NotEqual_InterfaceInterface(PlayerOwner.VoiceInterface, OnlineVoiceInterface(none))) && int(WorldInfo.NetMode) != int(NM_Standalone)) && WorldInfo.GRI != none)
	{
		Len = WorldInfo.GRI.PRIArray.Length;
		I = 0;
		J0x824:

		// End:0xA3E [Loop If]
		if(I < Len)
		{
			OtherPlayerNetId = WorldInfo.GRI.PRIArray[I].UniqueId;
			// End:0xA30
			if(((PlayerOwner.VoiceInterface.IsRemotePlayerTalking(OtherPlayerNetId) && WorldInfo.GRI.PRIArray[I] != PlayerOwner.PlayerReplicationInfo) && UTPlayerReplicationInfo(WorldInfo.GRI.PRIArray[I]) != none) && PlayerOwner.GameplayVoiceMuteList.Find('Uid', OtherPlayerNetId.Uid) == -1)
			{
				ShowPortrait(UTPlayerReplicationInfo(WorldInfo.GRI.PRIArray[I]));
				// [Explicit Break]
				goto J0xA3E;
			}
			I++;
			// [Loop Continue]
			goto J0x824;
		}
	}
	J0xA3E:

	// End:0xA60
	if(CharPRI != none)
	{
		DisplayPortrait(RenderDelta);
	}
	// End:0xA88
	if(bShowClock && !bIsSplitScreen)
	{
		DisplayClock();
	}
	// End:0xAAE
	if(bIsSplitScreen && bShowScoring)
	{
		DisplayScoring();
	}
	// End:0xADC
	if(!UTPlayerOwner.IsDead())
	{
		DrawLivingHud();
	}
	// End:0xB44
	if(bHasMap && bShowMap)
	{
		TempResScale = ResolutionScale;
		// End:0xB27
		if(bIsSplitScreen)
		{
			ResolutionScale *= float(2);
		}
		DisplayMap();
		ResolutionScale = TempResScale;
	}
	DisplayDamage();
	// End:0xBA5
	if(UTPlayerOwner.bIsTyping && int(WorldInfo.NetMode) != int(NM_Standalone))
	{
		DrawMicIcon();
	}
	//return;	
}

function DrawMicIcon()
{
	local Vector2D pos;

	pos.X = 0.0000000;
	pos.Y = ((Canvas.ClipY * (CharPortraitYPerc + 0.0500000)) + (CharPortraitSize.Y * (Canvas.ClipY / 768.0000000))) + float(6);
	Canvas.SetPos(pos.X, pos.Y);
	Canvas.DrawTile(TalkingTexture, 64.0000000, 64.0000000, 0.0000000, 0.0000000, 64.0000000, 64.0000000);
	//return;	
}

function DisplayLocalMessages()
{
	// End:0x4A
	if(!PlayerOwner.bCinematicMode)
	{
		MaxHUDAreaMessageCount = ((bIsSplitScreen) ? 1 : 2);
		super(HUD).DisplayLocalMessages();
	}
	//return;	
}

function DrawLivingHud()
{
	local UTWeapon Weapon;
	local float Alpha;

	// End:0x28
	if(!bIsSplitScreen && bShowScoring)
	{
		DisplayScoring();
	}
	// End:0x50
	if(bShowDoll && UTPawnOwner != none)
	{
		DisplayPawnDoll();
	}
	// End:0x122
	if(bShowVehicle && UDKVehicleBase(PawnOwner) != none)
	{
		// End:0xCE
		if(UTVehicle(PawnOwner) != none)
		{
			UTVehicle(PawnOwner).DisplayHud(self, Canvas, VehiclePosition);			
		}
		else
		{
			// End:0x122
			if(UTWeaponPawn(PawnOwner) != none)
			{
				UTWeaponPawn(PawnOwner).DisplayHud(self, Canvas, VehiclePosition);
			}
		}
	}
	// End:0x170
	if((bShowPowerups && UTPawnOwner != none) && UTPawnOwner.InvManager != none)
	{
		DisplayPowerups();
	}
	// End:0x417
	if(PawnOwner != none)
	{
		Alpha = TeamHUDColor.A;
		// End:0x1BF
		if(bShowWeaponbar)
		{
			DisplayWeaponBar();			
		}
		else
		{
			// End:0x264
			if((Vehicle(PawnOwner) != none) && PawnOwner.Weapon != LastSelectedWeapon)
			{
				LastSelectedWeapon = PawnOwner.Weapon;
				PlayerOwner.ReceiveLocalizedMessage(Class'UTGame.UTWeaponSwitchMessage',,,, LastSelectedWeapon);				
			}
			else
			{
				// End:0x377
				if(((PawnOwner.InvManager != none) && PawnOwner.InvManager.PendingWeapon != none) && PawnOwner.InvManager.PendingWeapon != LastSelectedWeapon)
				{
					LastSelectedWeapon = PawnOwner.InvManager.PendingWeapon;
					PlayerOwner.ReceiveLocalizedMessage(Class'UTGame.UTWeaponSwitchMessage',,,, LastSelectedWeapon);
				}
			}
		}
		TeamHUDColor.A = Alpha;
		// End:0x417
		if(bShowAmmo)
		{
			Weapon = UTWeapon(PawnOwner.Weapon);
			// End:0x417
			if((Weapon != none) && UTVehicleWeapon(Weapon) == none)
			{
				DisplayAmmo(Weapon);
			}
		}
	}
	//return;	
}

function DrawPostGameHud()
{
	local bool bWinner;

	// End:0x224
	if((((WorldInfo.GRI != none) && PlayerOwner.PlayerReplicationInfo != none) && !PlayerOwner.PlayerReplicationInfo.bOnlySpectator) && !PlayerOwner.IsInState('InQueue'))
	{
		// End:0x145
		if(UTPlayerReplicationInfo(WorldInfo.GRI.Winner) != none)
		{
			bWinner = UTPlayerReplicationInfo(WorldInfo.GRI.Winner) == UTOwnerPRI;			
		}
		else
		{
			// End:0x1F7
			if(WorldInfo.GRI.Winner != none)
			{
				bWinner = int(WorldInfo.GRI.Winner.GetTeamNum()) == int(UTPlayerOwner.GetTeamNum());
			}
		}
		DisplayHUDMessage(((bWinner) ? YouHaveWon : YouHaveLost));
	}
	DisplayConsoleMessages();
	//return;	
}

function DisplayWeaponBar()
{
	local int I, SelectedWeapon, LastWeapIndex, PrevWeapIndex, NextWeapIndex, FirstWeaponIndex;

	local float TotalOffsetX, OffsetX, OffsetY, BoxOffsetSize, OffsetSizeX, OffsetSizeY,
		DesiredWeaponScale[10], Delta, MaxWidth;

	local UTWeapon W;
	local UTVehicle V;
	local LinearColor FadedAmmoBarColor;
	local float SelectedAmmoBarX, SelectedAmmoBarY, AlphaScale, AmmoCountScale;
	local Rotator R;
	local Inventory Inv;

	// End:0x20
	if((PawnOwner == none) || bIsSplitScreen)
	{
		return;
	}
	FirstWeaponIndex = ((WorldInfo.bUseConsoleInput) ? 1 : 0);
	// End:0x143
	if(((PawnOwner.InvManager != none) && UTWeapon(PawnOwner.InvManager.PendingWeapon) != none) && int(UTWeapon(PawnOwner.InvManager.PendingWeapon).InventoryGroup) > FirstWeaponIndex)
	{
		LastWeaponBarDrawnTime = WorldInfo.TimeSeconds;
	}
	// End:0x2AA
	if(((PawnOwner.Weapon == none) || PawnOwner.InvManager == none) || UTVehicle(PawnOwner) != none)
	{
		V = UTVehicle(PawnOwner);
		// End:0x2A8
		if(V != none)
		{
			// End:0x220
			if(V.bHasWeaponBar)
			{
				V.DisplayWeaponBar(Canvas, self);				
			}
			else
			{
				// End:0x2A8
				if(PawnOwner.Weapon != LastSelectedWeapon)
				{
					LastSelectedWeapon = PawnOwner.Weapon;
					PlayerOwner.ReceiveLocalizedMessage(WeaponSwitchMessage, 0, none, none, LastSelectedWeapon);
				}
			}
		}
		return;
	}
	// End:0x343
	if(bOnlyShowWeaponBarIfChanging)
	{
		// End:0x2EC
		if((WorldInfo.TimeSeconds - LastWeaponBarDrawnTime) > 1.0000000)
		{
			return;
		}
		AlphaScale = FClamp(1.0000000 - (3.0000000 * ((WorldInfo.TimeSeconds - LastWeaponBarDrawnTime) - 0.3330000)), 0.0000000, 1.0000000);		
	}
	else
	{
		AlphaScale = 1.0000000;
	}
	I = 0;
	J0x35D:

	// End:0x390 [Loop If]
	if(I < 10)
	{
		WeaponList[I] = none;
		I++;
		// [Loop Continue]
		goto J0x35D;
	}
	I = 0;
	Inv = PawnOwner.InvManager.InventoryChain;
	J0x3D8:

	// End:0x4CD [Loop If]
	if(Inv != none)
	{
		W = UTWeapon(Inv);
		// End:0x4A2
		if(((W != none) && int(W.InventoryGroup) < int(11)) && int(W.InventoryGroup) > int(0))
		{
			WeaponList[int(W.InventoryGroup) - int(1)] = W;
		}
		Inv = Inv.Inventory;
		// [Loop Continue]
		goto J0x3D8;
	}
	SelectedWeapon = ((PawnOwner.InvManager.PendingWeapon != none) ? int(UTWeapon(PawnOwner.InvManager.PendingWeapon).InventoryGroup) - int(1) : int(UTWeapon(PawnOwner.Weapon).InventoryGroup) - int(1));
	Delta = WeaponScaleSpeed * (WorldInfo.TimeSeconds - LastHUDUpdateTime);
	BoxOffsetSize = (HUDScaleX * WeaponBarScale) * WeaponBoxWidth;
	PrevWeapIndex = -1;
	NextWeapIndex = -1;
	LastWeapIndex = -1;
	// End:0x820
	if((PawnOwner.InvManager.PendingWeapon != none) && PawnOwner.InvManager.PendingWeapon != LastSelectedWeapon)
	{
		LastSelectedWeapon = PawnOwner.InvManager.PendingWeapon;
		I = 0;
		J0x707:

		// End:0x7EC [Loop If]
		if(I < 8)
		{
			// End:0x746
			if(LocalMessages[I].Message == none)
			{
				// [Explicit Break]
				goto J0x7EC;
			}
			// End:0x7DE
			if(LocalMessages[I].OptionalObject == LastSelectedWeapon.Class)
			{
				LocalMessages[I].EndOfLife = WorldInfo.TimeSeconds - 1.0000000;
				// [Explicit Break]
				goto J0x7EC;
			}
			I++;
			// [Loop Continue]
			goto J0x707;
		}
		J0x7EC:

		PlayerOwner.ReceiveLocalizedMessage(WeaponSwitchMessage, 0, none, none, LastSelectedWeapon);
	}
	I = FirstWeaponIndex;
	J0x833:

	// End:0xAAB [Loop If]
	if(I < 10)
	{
		// End:0xA84
		if(WeaponList[I] != none)
		{
			// End:0x91B
			if(SelectedWeapon == I)
			{
				PrevWeapIndex = LastWeapIndex;
				// End:0x8BD
				if(BouncedWeapon == I)
				{
					DesiredWeaponScale[I] = SelectedWeaponScale;					
				}
				else
				{
					DesiredWeaponScale[I] = BounceWeaponScale;
					// End:0x918
					if(CurrentWeaponScale[I] >= DesiredWeaponScale[I])
					{
						BouncedWeapon = I;
					}
				}				
			}
			else
			{
				// End:0x945
				if(LastWeapIndex == SelectedWeapon)
				{
					NextWeapIndex = I;
				}
				DesiredWeaponScale[I] = 1.0000000;
			}
			// End:0xA45
			if(CurrentWeaponScale[I] != DesiredWeaponScale[I])
			{
				// End:0x9FE
				if(DesiredWeaponScale[I] > CurrentWeaponScale[I])
				{
					CurrentWeaponScale[I] = FMin(CurrentWeaponScale[I] + Delta, DesiredWeaponScale[I]);					
				}
				else
				{
					CurrentWeaponScale[I] = FMax(CurrentWeaponScale[I] - Delta, DesiredWeaponScale[I]);
				}
			}
			TotalOffsetX += (CurrentWeaponScale[I] * BoxOffsetSize);
			LastWeapIndex = I;			
		}
		else
		{
			CurrentWeaponScale[I] = 0.0000000;
		}
		I++;
		// [Loop Continue]
		goto J0x833;
	}
	OffsetX = (HUDScaleX * WeaponBarXOffset) + (0.5000000 * (Canvas.ClipX - TotalOffsetX));
	OffsetY = Canvas.ClipY - (HUDScaleY * WeaponBarY);
	Canvas.SetDrawColor(255, 255, 255, 255);
	OffsetSizeX = ((HUDScaleX * WeaponBarScale) * float(96)) * SelectedBoxScale;
	OffsetSizeY = ((HUDScaleY * WeaponBarScale) * float(64)) * SelectedBoxScale;
	FadedAmmoBarColor = AmmoBarColor;
	FadedAmmoBarColor.A *= AlphaScale;
	I = FirstWeaponIndex;
	J0xC0B:

	// End:0x1356 [Loop If]
	if(I < 10)
	{
		// End:0x1348
		if(WeaponList[I] != none)
		{
			Canvas.SetPos(OffsetX, OffsetY - (OffsetSizeY * CurrentWeaponScale[I]));
			// End:0x1090
			if(SelectedWeapon == I)
			{
				TeamHUDColor.A = SelectedWeaponAlpha * AlphaScale;
				Canvas.DrawTile(AltHudTexture, CurrentWeaponScale[I] * OffsetSizeX, CurrentWeaponScale[I] * OffsetSizeY, 530.0000000, 248.0000000, 69.0000000, 49.0000000, TeamHUDColor);
				Canvas.SetPos(OffsetX, OffsetY - (OffsetSizeY * CurrentWeaponScale[I]));
				Canvas.DrawTile(AltHudTexture, CurrentWeaponScale[I] * OffsetSizeX, CurrentWeaponScale[I] * OffsetSizeY, 459.0000000, 148.0000000, 69.0000000, 49.0000000, TeamHUDColor);
				Canvas.SetPos(OffsetX, OffsetY - (OffsetSizeY * CurrentWeaponScale[I]));
				Canvas.DrawTile(AltHudTexture, CurrentWeaponScale[I] * OffsetSizeX, CurrentWeaponScale[I] * OffsetSizeY, 459.0000000, 248.0000000, 69.0000000, 49.0000000, TeamHUDColor);
				SelectedAmmoBarX = (HUDScaleX * (SelectedWeaponAmmoOffsetX - WeaponBarXOffset)) + OffsetX;
				SelectedAmmoBarY = Canvas.ClipY - (HUDScaleY * (WeaponBarY + (CurrentWeaponScale[I] * WeaponAmmoOffsetY)));
				Canvas.SetPos(SelectedAmmoBarX, SelectedAmmoBarY);
				MaxWidth = ((CurrentWeaponScale[I] * HUDScaleY) * WeaponBarScale) * WeaponAmmoLength;
				Canvas.DrawTileStretched(AltHudTexture, MaxWidth, ((CurrentWeaponScale[I] * HUDScaleY) * WeaponBarScale) * WeaponAmmoThickness, 407.0000000, 479.0000000, FMin(118.0000000, MaxWidth), 16.0000000, FadedAmmoBarColor);				
			}
			else
			{
				TeamHUDColor.A = OffWeaponAlpha * AlphaScale;
				Canvas.DrawTile(AltHudTexture, CurrentWeaponScale[I] * OffsetSizeX, CurrentWeaponScale[I] * OffsetSizeY, 459.0000000, 148.0000000, 69.0000000, 49.0000000, TeamHUDColor);
				// End:0x1233
				if(I == PrevWeapIndex)
				{
					Canvas.SetPos(OffsetX, OffsetY - (OffsetSizeY * CurrentWeaponScale[I]));
					Canvas.DrawTile(AltHudTexture, CurrentWeaponScale[I] * OffsetSizeX, CurrentWeaponScale[I] * OffsetSizeY, 530.0000000, 97.0000000, 69.0000000, 49.0000000, TeamHUDColor);					
				}
				else
				{
					// End:0x131F
					if(I == NextWeapIndex)
					{
						Canvas.SetPos(OffsetX, OffsetY - (OffsetSizeY * CurrentWeaponScale[I]));
						Canvas.DrawTile(AltHudTexture, CurrentWeaponScale[I] * OffsetSizeX, CurrentWeaponScale[I] * OffsetSizeY, 530.0000000, 148.0000000, 69.0000000, 49.0000000, TeamHUDColor);
					}
				}
			}
			OffsetX += (CurrentWeaponScale[I] * BoxOffsetSize);
		}
		I++;
		// [Loop Continue]
		goto J0xC0B;
	}
	Canvas.SetDrawColor(255, 255, 255, 255);
	OffsetX = (HUDScaleX * WeaponAmmoOffsetX) + (0.5000000 * (Canvas.ClipX - TotalOffsetX));
	OffsetSizeY = (HUDScaleY * WeaponBarScale) * WeaponAmmoThickness;
	FadedAmmoBarColor = AmmoBarColor;
	FadedAmmoBarColor.A *= AlphaScale;
	I = FirstWeaponIndex;
	J0x1443:

	// End:0x16EC [Loop If]
	if(I < 10)
	{
		// End:0x16B5
		if((WeaponList[I] != none) && WeaponList[I].AmmoCount > 0)
		{
			// End:0x1525
			if(SelectedWeapon == I)
			{
				Canvas.SetPos(SelectedAmmoBarX - ((((0.2000000 * HUDScaleY) * WeaponBarScale) * WeaponAmmoLength) * CurrentWeaponScale[I]), SelectedAmmoBarY);				
			}
			else
			{
				Canvas.SetPos(OffsetX, Canvas.ClipY - (HUDScaleY * (WeaponBarY + (CurrentWeaponScale[I] * WeaponAmmoOffsetY))));
			}
			AmmoCountScale = 0.3000000 + FMin(1.0000000, float(WeaponList[I].AmmoCount) / float(WeaponList[I].MaxAmmoCount));
			Canvas.DrawTileStretched(AltHudTexture, (((HUDScaleY * WeaponBarScale) * WeaponAmmoLength) * CurrentWeaponScale[I]) * AmmoCountScale, CurrentWeaponScale[I] * OffsetSizeY, 273.0000000, 494.0000000, 12.0000000, 13.0000000, FadedAmmoBarColor);
		}
		OffsetX += (CurrentWeaponScale[I] * BoxOffsetSize);
		I++;
		// [Loop Continue]
		goto J0x1443;
	}
	// End:0x192D
	if(!bNoWeaponNumbers)
	{
		OffsetX = ((HUDScaleX * (WeaponAmmoOffsetX + WeaponXOffset)) * 0.5000000) + (0.5000000 * (Canvas.ClipX - TotalOffsetX));
		OffsetY = Canvas.ClipY - (HUDScaleY * (WeaponBarY + WeaponYOffset));
		Canvas.SetDrawColor(255, 255, 255, 255);
		Canvas.DrawColor.A = byte(255.0000000 * AlphaScale);
		Canvas.Font = HudFonts[0];
		I = 0;
		J0x1846:

		// End:0x192D [Loop If]
		if(I < 10)
		{
			// End:0x191F
			if(WeaponList[I] != none)
			{
				Canvas.SetPos(OffsetX, OffsetY - (OffsetSizeY * CurrentWeaponScale[I]));
				Canvas.DrawText(string((I + 1) % 10));
				OffsetX += (CurrentWeaponScale[I] * BoxOffsetSize);
			}
			I++;
			// [Loop Continue]
			goto J0x1846;
		}
	}
	OffsetX = (HUDScaleX * WeaponXOffset) + (0.5000000 * (Canvas.ClipX - TotalOffsetX));
	OffsetY = Canvas.ClipY - (HUDScaleY * (WeaponBarY + WeaponYOffset));
	OffsetSizeX = (HUDScaleX * WeaponBarScale) * float(100);
	OffsetSizeY = (HUDScaleY * WeaponBarScale) * WeaponYScale;
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.DrawColor.A = byte(255.0000000 * AlphaScale);
	R.Yaw = 2048;
	I = FirstWeaponIndex;
	J0x1AB3:

	// End:0x1D80 [Loop If]
	if(I < 10)
	{
		// End:0x1D72
		if(WeaponList[I] != none)
		{
			OffsetSizeX = (HUDScaleX * WeaponBarScale) * float(100);
			OffsetSizeY = OffsetSizeX * (WeaponList[I].IconCoordinates.VL / WeaponList[I].IconCoordinates.UL);
			Canvas.SetPos(OffsetX, OffsetY - ((1.1000000 * OffsetSizeY) * CurrentWeaponScale[I]));
			Canvas.DrawRotatedTile(IconHudTexture, R, CurrentWeaponScale[I] * OffsetSizeX, CurrentWeaponScale[I] * OffsetSizeY, WeaponList[I].IconCoordinates.U, WeaponList[I].IconCoordinates.V, WeaponList[I].IconCoordinates.UL, WeaponList[I].IconCoordinates.VL, 1.0000000, 1.0000000);
			OffsetX += (CurrentWeaponScale[I] * BoxOffsetSize);
		}
		I++;
		// [Loop Continue]
		goto J0x1AB3;
	}
	//return;	
}

function DisplayMap()
{
	local UTMapInfo MI;
	local float ScaleY, W, H, X, Y, ScreenX,
		ScreenY, XL, YL, OrdersScale, ScaleIn,
		ScaleAlpha;

	local Color CanvasColor;
	local float AdjustedViewportHeight;

	// End:0x380
	if(DisplayedOrders != "")
	{
		Canvas.Font = GetFontSizeIndex(2);
		Canvas.StrLen(DisplayedOrders, XL, YL);
		// End:0xC9
		if(XL > 0.0000000)
		{
			OrdersScale = FMin(1.0000000, (0.3000000 * Canvas.ClipX) / XL);
		}
		ScaleIn = FMax(1.0000000, ((0.6000000 + OrderUpdateTime) - WorldInfo.TimeSeconds) / 0.1500000);
		ScaleAlpha = FMin(1.0000000, 4.5000000 - ScaleIn);
		OrdersScale *= ScaleIn;
		ScreenY = 0.0100000 * Canvas.ClipY;
		ScreenX = (0.9800000 * Canvas.ClipX) - (OrdersScale * XL);
		// End:0x277
		if(ScaleIn < 1.1000000)
		{
			Canvas.DrawColor = BlackColor;
			Canvas.SetPos(ScreenX + float(2), ScreenY + float(2));
			Canvas.DrawText(DisplayedOrders, false, OrdersScale, OrdersScale, TextRenderInfo);
		}
		Canvas.DrawColor = LightGoldColor;
		Canvas.DrawColor.A = byte(float(255) * ScaleAlpha);
		Canvas.SetPos(ScreenX, ScreenY);
		Canvas.DrawText(DisplayedOrders, false, OrdersScale, OrdersScale, TextRenderInfo);
		Canvas.DrawColor = CanvasColor;
	}
	// End:0x38F
	if(bIsSplitScreen)
	{
		return;
	}
	MI = UTMapInfo(WorldInfo.GetMapInfo());
	// End:0x5B4
	if(MI != none)
	{
		AdjustedViewportHeight = ((bIsSplitScreen) ? Canvas.ClipY * float(2) : Canvas.ClipY);
		ScaleY = AdjustedViewportHeight / float(768);
		H = MapDefaultSize * ScaleY;
		W = MapDefaultSize * ScaleY;
		X = (Canvas.ClipX - (Canvas.ClipX * (1.0000000 - MapPosition.X))) - W;
		Y = AdjustedViewportHeight * MapPosition.Y;
		MI.DrawMap(Canvas, UTPlayerController(PlayerOwner), X, Y, W, H, false, Canvas.ClipX / AdjustedViewportHeight);
	}
	//return;	
}

function DrawAIOverlays()
{
	local UTBot B;
	local Vector pos;
	local float XL, YL;
	local string Text;

	Canvas.Font = GetFontSizeIndex(0);
	// End:0x6A1
	foreach WorldInfo.AllControllers(Class'UTGame.UTBot', B)
	{
		// End:0x6A0
		if(B.Pawn != none)
		{
			DrawRoute(B.Pawn);
			// End:0x6A0
			if((Vector(PlayerOwner.Rotation) Dot (B.Pawn.Location - PlayerOwner.ViewTarget.Location)) > 0.0000000)
			{
				pos = Canvas.Project(B.Pawn.Location + (B.Pawn.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.1000000)));
				Text = (B.GetHumanReadableName() $ ":") @ B.GoalString;
				Canvas.StrLen(Text, XL, YL);
				pos.X = FClamp(pos.X, 0.0000000, Canvas.ClipX - XL);
				pos.Y = FClamp(pos.Y, 0.0000000, Canvas.ClipY - YL);
				Canvas.SetPos(pos.X, pos.Y);
				// End:0x5B7
				if((B.PlayerReplicationInfo != none) && B.PlayerReplicationInfo.Team != none)
				{
					Canvas.DrawColor = UTTeamInfo(B.PlayerReplicationInfo.Team).GetHUDColor();
					Canvas.DrawColor.R = byte(Min(int(Canvas.DrawColor.R) + int(64), 255));
					Canvas.DrawColor.G = byte(Min(int(Canvas.DrawColor.G) + int(64), 255));
					Canvas.DrawColor.B = byte(Min(int(Canvas.DrawColor.B) + int(64), 255));					
				}
				else
				{
					Canvas.DrawColor = ConsoleColor;
				}
				Canvas.DrawColor.A = (((WorldInfo.TimeSeconds - B.Pawn.LastRenderTime) < 0.1000000) ? 255 : 128);
				Canvas.DrawText(Text);
			}
		}		
	}	
	//return;	
}

function UIInteraction GetUIController(optional out LocalPlayer LP)
{
	LP = LocalPlayer(PlayerOwner.Player);
	// End:0x75
	if(LP != none)
	{
		return LP.ViewportClient.UIController;
	}
	return none;
	//return ReturnValue;	
}

exec function StartMusic()
{
	// End:0x65
	if(UTPlayerOwner.MusicManager == none)
	{
		UTPlayerOwner.MusicManager = Spawn(MusicManagerClass, UTPlayerOwner);
	}
	//return;	
}

static simulated function GetTeamColor(int TeamIndex, optional out LinearColor ImageColor, optional out Color TextColor)
{
	switch(TeamIndex)
	{
		// End:0x42
		case 0:
			ImageColor = default.RedLinearColor;
			TextColor = default.LightGoldColor;
			// End:0xBD
			break;
		// End:0x6F
		case 1:
			ImageColor = default.BlueLinearColor;
			TextColor = default.LightGoldColor;
			// End:0xBD
			break;
		// End:0xFFFF
		default:
			ImageColor = default.DMLinearColor;
			ImageColor.A = 1.0000000;
			TextColor = default.LightGoldColor;
			// End:0xBD
			break;
			break;
	}
	//return;	
}

function DisplayHit(Vector HitDir, int Damage, Class<DamageType> DamageType)
{
	local Vector Loc;
	local Rotator Rot;
	local float DirOfHit_L;
	local Vector AxisX, AxisY, AxisZ, ShotDirection;
	local bool bIsInFront;
	local Vector2D AngularDist;
	local float PositionInQuadrant, Multiplier, DamageIntensity;
	local Class<UTDamageType> UTDamage;
	local Pawn P;

	// End:0xAC
	if((PawnOwner != none) && PawnOwner.Health > 0)
	{
		DamageIntensity = ((PawnOwner.InGodMode()) ? 0.5000000 : (float(Damage) / 100.0000000) + (float(Damage) / float(PawnOwner.Health)));		
	}
	else
	{
		DamageIntensity = FMax(0.2000000, 0.0200000 * float(Damage));
	}
	UTDamage = Class<UTDamageType>(DamageType);
	// End:0x30E
	if((UTDamage != none) && UTDamage.default.bLocationalHit)
	{
		PlayerOwner.GetPlayerViewPoint(Loc, Rot);
		GetAxes(Rot, AxisX, AxisY, AxisZ);
		ShotDirection = Normal(HitDir - Loc);
		bIsInFront = GetAngularDistance(AngularDist, ShotDirection, AxisX, AxisY, AxisZ);
		GetAngularDegreesFromRadians(AngularDist);
		Multiplier = 0.2600000 / 90.0000000;
		PositionInQuadrant = Abs(AngularDist.X) * Multiplier;
		// End:0x28E
		if(bIsInFront)
		{
			DirOfHit_L = ((AngularDist.X > float(0)) ? PositionInQuadrant : float(-1) * PositionInQuadrant);			
		}
		else
		{
			DirOfHit_L = ((AngularDist.X > float(0)) ? 0.5200000 + PositionInQuadrant : 0.5200000 - PositionInQuadrant);
		}
		DirOfHit_L = -1.0000000 * DirOfHit_L;
		FlashDamage(DirOfHit_L);		
	}
	else
	{
		FlashDamage(0.1000000);
		FlashDamage(0.9000000);
	}
	// End:0x378
	if(UTVehicle_Hoverboard(PawnOwner) != none)
	{
		P = UTVehicle_Hoverboard(PawnOwner).Driver;		
	}
	else
	{
		P = PawnOwner;
	}
	// End:0x564
	if((DamageIntensity > float(0)) && HitEffect != none)
	{
		DamageIntensity = FClamp(DamageIntensity, 0.2000000, 1.0000000);
		// End:0x433
		if((P == none) || P.Health <= 0)
		{
			HitEffectFadeTime = PlayerOwner.MinRespawnDelay * 2.0000000;			
		}
		else
		{
			HitEffectFadeTime = default.HitEffectFadeTime * DamageIntensity;
		}
		HitEffectIntensity = default.HitEffectIntensity * DamageIntensity;
		MaxHitEffectColor = (((UTDamage != none) && UTDamage.default.bOverrideHitEffectColor) ? UTDamage.default.HitEffectColor : default.MaxHitEffectColor);
		HitEffectMaterialInstance.SetScalarParameterValue('HitAmount', HitEffectIntensity);
		HitEffectMaterialInstance.SetVectorParameterValue('HitColor', MaxHitEffectColor);
		HitEffect.bShowInGame = true;
		bFadeOutHitEffect = true;
	}
	//return;	
}

function FlashDamage(float FlashPosition)
{
	local int I, minindex;
	local float Min;

	Min = 1.0000000;
	I = 0;
	J0x1A:

	// End:0x1DF [Loop If]
	if(I < MaxNoOfIndicators)
	{
		// End:0x15A
		if(DamageData[I].FadeValue <= 0.0000000)
		{
			DamageData[I].FadeValue = 1.0000000;
			DamageData[I].FadeTime = FadeTime;
			DamageData[I].MatConstant.SetScalarParameterValue(PositionalParamName, FlashPosition);
			DamageData[I].MatConstant.SetScalarParameterValue(FadeParamName, 1.0000000);
			return;			
		}
		else
		{
			// End:0x1D1
			if(DamageData[I].FadeValue < Min)
			{
				minindex = I;
				Min = DamageData[I].FadeValue;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x1A;
	}
	DamageData[minindex].FadeValue = 1.0000000;
	DamageData[minindex].FadeTime = FadeTime;
	DamageData[minindex].MatConstant.SetScalarParameterValue(PositionalParamName, FlashPosition);
	DamageData[minindex].MatConstant.SetScalarParameterValue(FadeParamName, 1.0000000);
	//return;	
}

function UpdateDamage()
{
	local int I;
	local float HitAmount;
	local LinearColor HitColor;

	I = 0;
	J0x0B:

	// End:0x180 [Loop If]
	if(I < MaxNoOfIndicators)
	{
		// End:0x172
		if(DamageData[I].FadeTime > float(0))
		{
			DamageData[I].FadeValue += ((float(0) - DamageData[I].FadeValue) * (RenderDelta / DamageData[I].FadeTime));
			DamageData[I].FadeTime -= RenderDelta;
			DamageData[I].MatConstant.SetScalarParameterValue(FadeParamName, DamageData[I].FadeValue);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	// End:0x302
	if(bFadeOutHitEffect)
	{
		HitEffectMaterialInstance.GetScalarParameterValue('HitAmount', HitAmount);
		HitAmount -= ((HitEffectIntensity * RenderDelta) / HitEffectFadeTime);
		// End:0x22B
		if(HitAmount <= 0.0000000)
		{
			HitEffect.bShowInGame = false;
			bFadeOutHitEffect = false;			
		}
		else
		{
			HitEffectMaterialInstance.SetScalarParameterValue('HitAmount', HitAmount);
			HitEffectMaterialInstance.GetVectorParameterValue('HitColor', HitColor);
			HitColor = Subtract_LinearColorLinearColor(HitColor, Multiply_LinearColorFloat(MaxHitEffectColor, RenderDelta / HitEffectFadeTime));
			HitEffectMaterialInstance.SetVectorParameterValue('HitColor', HitColor);
		}
	}
	//return;	
}

function DisplayDamage()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x184 [Loop If]
	if(I < MaxNoOfIndicators)
	{
		// End:0x176
		if(DamageData[I].FadeTime > float(0))
		{
			Canvas.SetPos((Canvas.ClipX * 0.5000000) - ((DamageIndicatorSize * 0.5000000) * ResolutionScale), (Canvas.ClipY * 0.5000000) - ((DamageIndicatorSize * 0.5000000) * ResolutionScale));
			Canvas.DrawMaterialTile(DamageData[I].MatConstant, DamageIndicatorSize * ResolutionScale, DamageIndicatorSize * ResolutionScale, 0.0000000, 0.0000000, 1.0000000, 1.0000000);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

static simulated function DrawBackground(float X, float Y, float Width, float Height, LinearColor DrawColor, Canvas DrawCanvas)
{
	DrawCanvas.SetPos(X, Y);
	DrawColor.R *= 0.2500000;
	DrawColor.G *= 0.2500000;
	DrawColor.B *= 0.2500000;
	DrawCanvas.DrawTile(default.AltHudTexture, Width, Height, 631.0000000, 202.0000000, 98.0000000, 48.0000000, DrawColor);
	//return;	
}

static simulated function DrawBeaconBackground(float X, float Y, float Width, float Height, LinearColor DrawColor, Canvas DrawCanvas)
{
	DrawCanvas.SetPos(X, Y);
	DrawColor.R *= 0.2500000;
	DrawColor.G *= 0.2500000;
	DrawColor.B *= 0.2500000;
	DrawCanvas.DrawTile(default.UT3GHudTexture, Width, Height, 137.0000000, 91.0000000, 101.0000000, 34.0000000, DrawColor);
	//return;	
}

static simulated function DrawHealth(float X, float Y, float Width, float MaxWidth, float Height, Canvas DrawCanvas, optional byte Alpha = 255)
{
	local float HealthX;
	local Color DrawColor, BackColor;

	HealthX = Width / MaxWidth;
	DrawColor = default.GrayColor;
	DrawColor.B = 16;
	// End:0x8B
	if(HealthX > 0.8000000)
	{
		DrawColor.R = 112;		
	}
	else
	{
		// End:0xBD
		if(HealthX < 0.4000000)
		{
			DrawColor.G = 80;
		}
	}
	DrawColor.A = Alpha;
	BackColor = default.GrayColor;
	BackColor.A = Alpha;
	DrawBarGraph(X, Y, Width, MaxWidth, Height, DrawCanvas, DrawColor, BackColor);
	//return;	
}

static simulated function DrawBarGraph(float X, float Y, float Width, float MaxWidth, float Height, Canvas DrawCanvas, Color BarColor, Color BackColor)
{
	// End:0xC9
	if(MaxWidth > 24.0000000)
	{
		DrawCanvas.DrawColor = BackColor;
		DrawCanvas.SetPos(X, Y);
		DrawCanvas.DrawTile(default.AltHudTexture, MaxWidth, Height, 407.0000000, 479.0000000, FMin(MaxWidth, 118.0000000), 16.0000000);
	}
	DrawCanvas.DrawColor = BarColor;
	DrawCanvas.SetPos(X, Y);
	DrawCanvas.DrawTile(default.AltHudTexture, Width, Height, 277.0000000, 494.0000000, 4.0000000, 13.0000000);
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
	NewTimeString = ("" $ ((Hours > 9) ? string(Hours) : "0" $ string(Hours))) $ ":";
	NewTimeString = (NewTimeString $ ((Mins > 9) ? string(Mins) : "0" $ string(Mins))) $ ":";
	NewTimeString = NewTimeString $ ((Seconds > 9) ? string(Seconds) : "0" $ string(Seconds));
	return NewTimeString;
	//return ReturnValue;	
}

static function Font GetFontSizeIndex(int FontSize)
{
	return default.HudFonts[Clamp(FontSize, 0, 3)];
	//return ReturnValue;	
}

simulated function ShowPortrait(UTPlayerReplicationInfo ShowPRI, optional float PortraitDuration, optional bool bOverrideCurrentSpeaker)
{
	// End:0x1C0
	if((ShowPRI != none) && ShowPRI.CharPortrait != none)
	{
		// End:0xE7
		if(CharPRI != none)
		{
			// End:0xBB
			if(ShowPRI == CharPRI)
			{
				// End:0xB8
				if(CharPortraitTime >= (CharPortraitSlideTime * CharPortraitSlideTransitionTime))
				{
					CharPortraitSlideTime += 2.0000000;
					CharPortraitTime = FMax(CharPortraitTime, CharPortraitSlideTime * CharPortraitSlideTransitionTime);
				}				
			}
			else
			{
				// End:0xE5
				if(bOverrideCurrentSpeaker)
				{
					CharPendingPRI = ShowPRI;
					HidePortrait();
				}
			}
			return;
		}
		// End:0x13E
		if(CharPortraitMI == none)
		{
			CharPortraitMI = new (Outer) Class'Engine.MaterialInstanceConstant';
			CharPortraitMI.SetParent(CharPortraitMaterial);
		}
		CharPortraitMI.SetTextureParameterValue('PortraitTexture', ShowPRI.CharPortrait);
		CharPRI = ShowPRI;
		CharPortraitTime = 0.0000000;
		CharPortraitSlideTime = FMax(2.0000000, PortraitDuration);
	}
	//return;	
}

simulated function HidePortrait()
{
	local float CurrentPos;

	CurrentPos = CharPortraitTime / CharPortraitSlideTime;
	// End:0x5D
	if(CurrentPos < CharPortraitSlideTransitionTime)
	{
		CharPortraitTime = CharPortraitSlideTime * (1.0000000 - CurrentPos);		
	}
	else
	{
		// End:0xA0
		if(CurrentPos < (1.0000000 - CharPortraitSlideTransitionTime))
		{
			CharPortraitTime = CharPortraitSlideTime * (1.0000000 - CharPortraitSlideTransitionTime);
		}
	}
	//return;	
}

simulated function DisplayPortrait(float DeltaTime)
{
	local float CurrentPos, LocalPos, XPos, YPos, W, H;

	H = CharPortraitSize.Y * (Canvas.ClipY / 768.0000000);
	W = CharPortraitSize.X * (Canvas.ClipY / 768.0000000);
	CharPortraitTime += (DeltaTime * ((CharPendingPRI != none) ? 1.5000000 : 1.0000000));
	CurrentPos = CharPortraitTime / CharPortraitSlideTime;
	// End:0x183
	if(CurrentPos < CharPortraitSlideTransitionTime)
	{
		LocalPos = CurrentPos / CharPortraitSlideTransitionTime;
		XPos = FCubicInterp(W * float(-1), 0.0000000, Canvas.ClipX * CharPortraitXPerc, 0.0000000, LocalPos);		
	}
	else
	{
		// End:0x1D7
		if(CurrentPos < (1.0000000 - CharPortraitSlideTransitionTime))
		{
			XPos = Canvas.ClipX * CharPortraitXPerc;			
		}
		else
		{
			// End:0x2BF
			if(NotEqual_InterfaceInterface(PlayerOwner.VoiceInterface, OnlineVoiceInterface(none)) && PlayerOwner.VoiceInterface.IsRemotePlayerTalking(CharPRI.UniqueId))
			{
				XPos = Canvas.ClipX * CharPortraitXPerc;
				CharPortraitTime = (1.0000000 - CharPortraitSlideTransitionTime) * CharPortraitSlideTime;				
			}
			else
			{
				// End:0x36E
				if(CurrentPos < 1.0000000)
				{
					LocalPos = (CurrentPos - (1.0000000 - CharPortraitSlideTransitionTime)) / CharPortraitSlideTransitionTime;
					XPos = FCubicInterp(W * float(-1), 0.0000000, Canvas.ClipX * CharPortraitXPerc, 0.0000000, 1.0000000 - LocalPos);					
				}
				else
				{
					CharPRI = none;
					// End:0x3A8
					if(CharPendingPRI != none)
					{
						ShowPortrait(CharPendingPRI);
						CharPendingPRI = none;
					}
					return;
				}
			}
		}
	}
	YPos = Canvas.ClipY * CharPortraitYPerc;
	Canvas.SetPos(XPos, YPos);
	Canvas.DrawColor = WhiteColor;
	Canvas.DrawMaterialTile(CharPortraitMI, W, H, 0.0000000, 0.0000000, 1.0000000, 1.0000000);
	Canvas.SetPos(XPos, (YPos + H) + float(5));
	Canvas.Font = HudFonts[0];
	Canvas.DrawText(CharPRI.PlayerName);
	//return;	
}

function DisplayHUDMessage(string Message, optional float XOffsetPct = 0.0500000, optional float YOffsetPct = 0.0500000)
{
	local float XL, YL, BarHeight, Height, YBuffer, XBuffer,
		YCenter;

	// End:0x380
	if(!bHudMessageRendered)
	{
		Canvas.SetDrawColor(255, 255, 255, 255);
		Canvas.Font = GetFontSizeIndex(2);
		// End:0x374
		if(Canvas.Font != none)
		{
			Canvas.StrLen(Message, XL, YL);
			BarHeight = YL * 1.1000000;
			YBuffer = Canvas.ClipY * YOffsetPct;
			XBuffer = Canvas.ClipX * XOffsetPct;
			Height = YL * 2.0000000;
			YCenter = (Canvas.ClipY - YBuffer) - (Height * 0.5000000);
			Canvas.SetPos(0.0000000, YCenter - (BarHeight * 0.5000000));
			Canvas.DrawTile(AltHudTexture, Canvas.ClipX, BarHeight, 382.0000000, 441.0000000, 127.0000000, 16.0000000);
			Canvas.SetPos(XBuffer, YCenter - (Height * 0.5000000));
			Canvas.DrawTile(AltHudTexture, Height * 1.3333300, Height, 734.0000000, 190.0000000, 82.0000000, 70.0000000);
			Canvas.SetPos(XBuffer + (Height * 1.5000000), YCenter - (YL * 0.5000000));
			Canvas.DrawText(Message);
		}
		bHudMessageRendered = true;
	}
	//return;	
}

function DisplayClock()
{
	local string Time;
	local Vector2D pos;

	// End:0x201
	if(UTGRI != none)
	{
		pos = ResolveHUDPosition(ClockPosition, 183.0000000, 44.0000000);
		Time = FormatTime(((UTGRI.TimeLimit != 0) ? UTGRI.RemainingTime : UTGRI.ElapsedTime));
		Canvas.SetPos(pos.X, pos.Y);
		Canvas.DrawTile(AltHudTexture, 183.0000000 * ResolutionScale, 44.0000000 * ResolutionScale, 490.0000000, 395.0000000, 181.0000000, 44.0000000, TeamHUDColor);
		Canvas.DrawColor = WhiteColor;
		DrawGlowText(Time, pos.X + (float(28) * ResolutionScale), pos.Y, 39.0000000 * ResolutionScale);
	}
	//return;	
}

function DisplayPawnDoll()
{
	local Vector2D pos;
	local string Amount;
	local int Health;
	local float XL, YL, ArmorAmount;
	local LinearColor ScaledWhite, ScaledTeamHUDColor;

	pos = ResolveHUDPosition(DollPosition, 216.0000000, 115.0000000);
	Canvas.DrawColor = WhiteColor;
	ArmorAmount = float(UTPawnOwner.GetShieldStrength());
	// End:0x100
	if((ArmorAmount > float(0)) || UTPawnOwner.JumpBootCharge > 0)
	{
		DollVisibility = FMin(DollVisibility + (3.0000000 * (WorldInfo.TimeSeconds - LastDollUpdate)), 1.0000000);		
	}
	else
	{
		DollVisibility = FMax(DollVisibility - (3.0000000 * (WorldInfo.TimeSeconds - LastDollUpdate)), 0.0000000);
	}
	LastDollUpdate = WorldInfo.TimeSeconds;
	pos.X = pos.X + (((DollVisibility - 1.0000000) * HealthOffsetX) * ResolutionScale);
	ScaledWhite = LC_White;
	ScaledWhite.A = DollVisibility;
	ScaledTeamHUDColor = TeamHUDColor;
	ScaledTeamHUDColor.A = FMin(DollVisibility, TeamHUDColor.A);
	// End:0x977
	if(DollVisibility > 0.0000000)
	{
		Canvas.SetPos(pos.X, pos.Y);
		Canvas.DrawTile(AltHudTexture, PawnDollBGCoords.UL * ResolutionScale, PawnDollBGCoords.VL * ResolutionScale, PawnDollBGCoords.U, PawnDollBGCoords.V, PawnDollBGCoords.UL, PawnDollBGCoords.VL, ScaledTeamHUDColor);
		Canvas.SetPos(pos.X + (DollOffsetX * ResolutionScale), pos.Y + (DollOffsetY * ResolutionScale));
		// End:0x4C8
		if(UTPawnOwner.ShieldBeltArmor > 0.0000000)
		{
			DrawTileCentered(AltHudTexture, DollWidth * ResolutionScale, DollHeight * ResolutionScale, 71.0000000, 224.0000000, 56.0000000, 109.0000000, ScaledWhite);			
		}
		else
		{
			DrawTileCentered(AltHudTexture, DollWidth * ResolutionScale, DollHeight * ResolutionScale, 4.0000000, 224.0000000, 56.0000000, 109.0000000, ScaledTeamHUDColor);
		}
		// End:0x624
		if(UTPawnOwner.VestArmor > 0.0000000)
		{
			Canvas.SetPos(pos.X + (VestX * ResolutionScale), pos.Y + (VestY * ResolutionScale));
			DrawTileCentered(AltHudTexture, VestWidth * ResolutionScale, VestHeight * ResolutionScale, 132.0000000, 220.0000000, 46.0000000, 28.0000000, ScaledWhite);
		}
		// End:0x728
		if(UTPawnOwner.ThighpadArmor > 0.0000000)
		{
			Canvas.SetPos(pos.X + (ThighX * ResolutionScale), pos.Y + (ThighY * ResolutionScale));
			DrawTileCentered(AltHudTexture, ThighWidth * ResolutionScale, ThighHeight * ResolutionScale, 134.0000000, 263.0000000, 42.0000000, 28.0000000, ScaledWhite);
		}
		// End:0x977
		if(UTPawnOwner.JumpBootCharge > 0)
		{
			Canvas.SetPos(pos.X + (BootX * ResolutionScale), pos.Y + (BootY * ResolutionScale));
			DrawTileCentered(AltHudTexture, BootWidth * ResolutionScale, BootHeight * ResolutionScale, 222.0000000, 263.0000000, 54.0000000, 26.0000000, ScaledWhite);
			Canvas.StrLen(string(UTPawnOwner.JumpBootCharge), XL, YL);
			Canvas.SetPos((pos.X + ((BootX - float(1)) * ResolutionScale)) - (0.5000000 * XL), (pos.Y + ((BootY + float(3)) * ResolutionScale)) - (0.5000000 * YL));
			Canvas.DrawText(string(UTPawnOwner.JumpBootCharge), false,,, TextRenderInfo);
		}
	}
	Canvas.SetPos(pos.X + (HealthBGOffsetX * ResolutionScale), pos.Y + (HealthBGOffsetY * ResolutionScale));
	Canvas.DrawTile(AltHudTexture, HealthBGCoords.UL * ResolutionScale, HealthBGCoords.VL * ResolutionScale, HealthBGCoords.U, HealthBGCoords.V, HealthBGCoords.UL, HealthBGCoords.VL, TeamHUDColor);
	Canvas.DrawColor = WhiteColor;
	Health = UTPawnOwner.Health;
	// End:0xB7B
	if(Health > LastHealth)
	{
		HealthPulseTime = WorldInfo.TimeSeconds;
	}
	LastHealth = Health;
	Amount = ((Health > 0) ? "" $ string(Health) : "0");
	DrawGlowText(Amount, pos.X + (HealthTextX * ResolutionScale), pos.Y + (HealthTextY * ResolutionScale), 60.0000000 * ResolutionScale, HealthPulseTime, true);
	Canvas.SetPos(pos.X + (HealthIconX * ResolutionScale), pos.Y + (HealthIconY * ResolutionScale));
	DrawTileCentered(AltHudTexture, 42.0000000 * ResolutionScale, 30.0000000 * ResolutionScale, 216.0000000, 102.0000000, 56.0000000, 40.0000000, LC_White);
	// End:0x10D5
	if(ArmorAmount > float(0))
	{
		// End:0xD72
		if(ArmorAmount > float(LastArmorAmount))
		{
			ArmorPulseTime = WorldInfo.TimeSeconds;
		}
		LastArmorAmount = int(ArmorAmount);
		Canvas.SetPos(pos.X + (ArmorBGOffsetX * ResolutionScale), pos.Y + (ArmorBGOffsetY * ResolutionScale));
		Canvas.DrawTile(AltHudTexture, ArmorBGCoords.UL * ResolutionScale, ArmorBGCoords.VL * ResolutionScale, ArmorBGCoords.U, ArmorBGCoords.V, ArmorBGCoords.UL, ArmorBGCoords.VL, ScaledTeamHUDColor);
		Canvas.DrawColor = WhiteColor;
		Canvas.DrawColor.A = byte(255.0000000 * DollVisibility);
		DrawGlowText("" $ string(int(ArmorAmount)), pos.X + (ArmorTextX * ResolutionScale), pos.Y + (ArmorTextY * ResolutionScale), 45.0000000 * ResolutionScale, ArmorPulseTime, true);
		Canvas.SetPos(pos.X + (ArmorIconX * ResolutionScale), pos.Y + (ArmorIconY * ResolutionScale));
		DrawTileCentered(AltHudTexture, 33.0000000 * ResolutionScale, 24.0000000 * ResolutionScale, 225.0000000, 68.0000000, 42.0000000, 32.0000000, ScaledWhite);
	}
	//return;	
}

function DisplayAmmo(UTWeapon Weapon)
{
	local Vector2D pos;
	local string Amount;
	local float BarWidth, PercValue;
	local int AmmoCount;

	// End:0x2B
	if(int(Weapon.AmmoDisplayType) == int(3))
	{
		return;
	}
	pos = ResolveHUDPosition(AmmoPosition, AmmoBGCoords.UL, AmmoBGCoords.VL);
	// End:0x38C
	if(int(Weapon.AmmoDisplayType) != int(1))
	{
		AmmoCount = Weapon.GetAmmoCount();
		// End:0x12A
		if((AmmoCount > LastAmmoCount) && LastWeapon == Weapon)
		{
			AmmoPulseTime = WorldInfo.TimeSeconds;
		}
		LastWeapon = Weapon;
		LastAmmoCount = AmmoCount;
		Canvas.SetPos(pos.X, pos.Y - (AmmoBarOffsetY * ResolutionScale));
		Canvas.DrawTile(AltHudTexture, AmmoBGCoords.UL * ResolutionScale, AmmoBGCoords.VL * ResolutionScale, AmmoBGCoords.U, AmmoBGCoords.V, AmmoBGCoords.UL, AmmoBGCoords.VL, TeamHUDColor);
		Amount = "" $ string(AmmoCount);
		Canvas.DrawColor = WhiteColor;
		DrawGlowText(Amount, pos.X + (AmmoTextOffsetX * ResolutionScale), pos.Y - ((AmmoBarOffsetY + AmmoTextOffsetY) * ResolutionScale), 58.0000000 * ResolutionScale, AmmoPulseTime, true);
	}
	// End:0x569
	if(int(Weapon.AmmoDisplayType) != int(0))
	{
		PercValue = Weapon.GetPowerPerc();
		Canvas.SetPos(pos.X + (float(40) * ResolutionScale), pos.Y - (float(8) * ResolutionScale));
		Canvas.DrawTile(AltHudTexture, 76.0000000 * ResolutionScale, 18.0000000 * ResolutionScale, 376.0000000, 458.0000000, 88.0000000, 14.0000000, LC_White);
		BarWidth = 70.0000000 * ResolutionScale;
		DrawHealth(pos.X + (float(43) * ResolutionScale), pos.Y - (float(4) * ResolutionScale), BarWidth * PercValue, BarWidth, 16.0000000, Canvas);
	}
	//return;	
}

function DisplayPowerups()
{
	local UTTimedPowerup TP;
	local float YPos;

	// End:0x3F
	if(bIsSplitScreen)
	{
		YPos = Canvas.ClipY * 0.5500000;		
	}
	else
	{
		YPos = Canvas.ClipY * PowerupYPos;
	}
	bDisplayingPowerups = false;
	// End:0x11D
	if(bShowPowerups)
	{
		// End:0x11C
		foreach UTPawnOwner.InvManager.InventoryActors(Class'UTGame.UTTimedPowerup', TP)
		{
			TP.DisplayPowerup(Canvas, self, ResolutionScale, YPos);
			bDisplayingPowerups = true;			
		}		
	}
	//return;	
}

function DisplayScoring()
{
	local Vector2D pos;

	// End:0x92
	if(bShowFragCount || bHasLeaderboard && bShowLeaderboard)
	{
		pos = ResolveHUDPosition(ScoringPosition, 115.0000000, 44.0000000);
		// End:0x72
		if(bShowFragCount)
		{
			DisplayFragCount(pos);
		}
		// End:0x92
		if(bHasLeaderboard)
		{
			DisplayLeaderBoard(pos);
		}
	}
	//return;	
}

function DisplayFragCount(Vector2D pos)
{
	local int FragCount;
	local UTPlayerReplicationInfo FragPRI;

	FragPRI = (((PawnOwner != none) && PawnOwner.PlayerReplicationInfo != none) ? UTPlayerReplicationInfo(PawnOwner.PlayerReplicationInfo) : UTOwnerPRI);
	Canvas.SetPos(pos.X, pos.Y);
	Canvas.DrawTile(AltHudTexture, 115.0000000 * ResolutionScale, 44.0000000 * ResolutionScale, 374.0000000, 395.0000000, 115.0000000, 44.0000000, TeamHUDColor);
	Canvas.DrawColor = WhiteColor;
	FragCount = int(((FragPRI != none) ? FragPRI.Score : 0.0000000));
	// End:0x1EA
	if(FragCount > LastFragCount)
	{
		FragPulseTime = WorldInfo.TimeSeconds;
		LastFragCount = FragCount;
	}
	DrawGlowText("" $ string(FragCount), pos.X + (float(87) * ResolutionScale), pos.Y + (float(-2) * ResolutionScale), 42.0000000 * ResolutionScale, FragPulseTime, true);
	//return;	
}

function DrawNameplateBackground(Vector2D pos, float WordWidth, LinearColor NameplateColor, optional float WordHeight = 0.0000000)
{
	local float NameplateHeight, EndCapWidth;

	// End:0x30
	if(WordHeight > float(0))
	{
		NameplateHeight = WordHeight;		
	}
	else
	{
		NameplateHeight = NameplateCenter.VL * ResolutionScale;
	}
	EndCapWidth = NameplateWidth * ResolutionScale;
	Canvas.SetPos((pos.X - (0.5000000 * WordWidth)) - EndCapWidth, pos.Y);
	Canvas.DrawTile(UT3GHudTexture, EndCapWidth, NameplateHeight, NameplateLeft.U, NameplateLeft.V, NameplateLeft.UL, NameplateLeft.VL, NameplateColor);
	Canvas.DrawTile(UT3GHudTexture, WordWidth, NameplateHeight, NameplateCenter.U, NameplateCenter.V, NameplateCenter.UL, NameplateCenter.VL, NameplateColor);
	Canvas.DrawTile(UT3GHudTexture, EndCapWidth, NameplateHeight, NameplateRight.U, NameplateRight.V, NameplateRight.UL, NameplateRight.VL, NameplateColor);
	//return;	
}

function DisplayLeaderBoard(Vector2D pos)
{
	local string Work, MySpreadStr;
	local int I, MySpread, MyPosition, LeaderboardCount;
	local float XL, YL;
	local Vector2D BackgroundPos;
	local bool bTravelling;
	local UTPlayerReplicationInfo FragPRI;

	FragPRI = (((PawnOwner != none) && PawnOwner.PlayerReplicationInfo != none) ? UTPlayerReplicationInfo(PawnOwner.PlayerReplicationInfo) : UTOwnerPRI);
	// End:0x93
	if((UTGRI == none) || FragPRI == none)
	{
		return;
	}
	pos.X = 0.9900000 * Canvas.ClipX;
	pos.Y += (float(50) * ResolutionScale);
	bTravelling = WorldInfo.IsInSeamlessTravel() || FragPRI.bFromPreviousLevel;
	I = 0;
	J0x15B:

	// End:0x1EB [Loop If]
	if(I < UTGRI.PRIArray.Length)
	{
		// End:0x1DD
		if(bTravelling || !UTGRI.PRIArray[I].bFromPreviousLevel)
		{
			// [Explicit Break]
			goto J0x1EB;
		}
		I++;
		// [Loop Continue]
		goto J0x15B;
	}
	J0x1EB:

	// End:0x2D9
	if(UTGRI.PRIArray[I] == FragPRI)
	{
		// End:0x2C0
		if(UTGRI.PRIArray.Length > (I + 1))
		{
			MySpread = int(FragPRI.Score - UTGRI.PRIArray[I + 1].Score);			
		}
		else
		{
			MySpread = 0;
		}
		MyPosition = 0;		
	}
	else
	{
		MySpread = int(FragPRI.Score - UTGRI.PRIArray[I].Score);
		MyPosition = UTGRI.PRIArray.Find(FragPRI);
	}
	// End:0x3A3
	if(MySpread > 0)
	{
		MySpreadStr = "+" $ string(MySpread);		
	}
	else
	{
		MySpreadStr = string(MySpread);
	}
	Work = ((string(MyPosition + 1) $ PlaceMarks[Min(MyPosition, 3)]) $ " / ") $ MySpreadStr;
	Canvas.Font = GetFontSizeIndex(2);
	// End:0x44C
	if(Canvas.Font == none)
	{
		return;
	}
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.StrLen(Work, XL, YL);
	BackgroundPos.X = pos.X - (0.5000000 * XL);
	BackgroundPos.Y = pos.Y;
	DrawNameplateBackground(BackgroundPos, XL, BlackBackgroundColor, YL);
	Canvas.SetPos(pos.X - XL, pos.Y);
	Canvas.DrawText(Work,,,, TextRenderInfo);
	// End:0x9E6
	if(bShowLeaderboard)
	{
		pos.Y += (YL * 1.2000000);
		Canvas.Font = GetFontSizeIndex(1);
		Canvas.SetDrawColor(200, 200, 200, 255);
		I = 0;
		J0x68D:

		// End:0x9E6 [Loop If]
		if((I < UTGRI.PRIArray.Length) && LeaderboardCount < 3)
		{
			// End:0x9D8
			if(((UTGRI.PRIArray[I] != none) && !UTGRI.PRIArray[I].bOnlySpectator) && bTravelling || !UTGRI.PRIArray[I].bFromPreviousLevel)
			{
				Work = ((string(I + 1) $ PlaceMarks[I]) $ ":") @ UTGRI.PRIArray[I].PlayerName;
				Canvas.StrLen(Work, XL, YL);
				BackgroundPos.X = pos.X - (0.5000000 * XL);
				BackgroundPos.Y = pos.Y;
				DrawNameplateBackground(BackgroundPos, XL, BlackBackgroundColor, 1.0500000 * YL);
				Canvas.SetPos(pos.X - XL, pos.Y + (float(2) * ResolutionScale));
				Canvas.DrawText(Work,,,, TextRenderInfo);
				pos.Y += (1.0500000 * YL);
				LeaderboardCount++;
			}
			I++;
			// [Loop Continue]
			goto J0x68D;
		}
	}
	//return;	
}

function DisplayConsoleMessages()
{
	local int Idx, XPos, YPos;
	local float XL, YL;

	// End:0x36
	if((ConsoleMessages.Length == 0) || PlayerOwner.bCinematicMode)
	{
		return;
	}
	Idx = 0;
	J0x41:

	// End:0xF6 [Loop If]
	if(Idx < ConsoleMessages.Length)
	{
		// End:0xE8
		if((ConsoleMessages[Idx].Text == "") || ConsoleMessages[Idx].MessageLife < WorldInfo.TimeSeconds)
		{
			ConsoleMessages.Remove(Idx--, 1);
		}
		Idx++;
		// [Loop Continue]
		goto J0x41;
	}
	ConsoleMessagePosX = ((bDisplayingPowerups) ? 0.1000000 : 0.0000000);
	XPos = int(((ConsoleMessagePosX * HudCanvasScale) * float(Canvas.SizeX)) + (((1.0000000 - HudCanvasScale) / 2.0000000) * float(Canvas.SizeX)));
	YPos = int(((ConsoleMessagePosY * HudCanvasScale) * float(Canvas.SizeY)) + (((1.0000000 - HudCanvasScale) / 2.0000000) * float(Canvas.SizeY)));
	Canvas.Font = GetFontSizeIndex(0);
	Canvas.TextSize("A", XL, YL);
	YPos -= int(YL * float(ConsoleMessages.Length));
	YPos -= int(YL);
	Idx = 0;
	J0x2B8:

	// End:0x43F [Loop If]
	if(Idx < ConsoleMessages.Length)
	{
		// End:0x300
		if(ConsoleMessages[Idx].Text == "")
		{			
		}
		else
		{
			Canvas.StrLen(ConsoleMessages[Idx].Text, XL, YL);
			Canvas.SetPos(float(XPos), float(YPos));
			Canvas.DrawColor = ConsoleMessages[Idx].TextColor;
			Canvas.DrawText(ConsoleMessages[Idx].Text, false);
			YPos += int(YL);
		}
		Idx++;
		// [Loop Continue]
		goto J0x2B8;
	}
	//return;	
}

defaultproperties
{
	WeaponSwitchMessage=Class'UTGame.UTWeaponSwitchMessage'
	AltHudTexture=Texture2D'UI_HUD.HUD.UI_HUD_BaseA'
	TalkingTexture=Texture2D'UT3GoldPatch.Talking'
	UT3GHudTexture=Texture2D'UI_GoldHud.HudIcons'
	LC_White=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000)
	GrayColor=(R=160,G=160,B=192,A=160)
	bShowDoll=true
	bShowAmmo=true
	bShowMap=true
	bShowPowerups=true
	bShowScoring=true
	bShowFragCount=true
	bHasLeaderboard=true
	bShowVehicle=true
	HudFonts[0]=MultiFont'UI_Fonts_Final.HUD.MF_Small'
	HudFonts[1]=MultiFont'UI_Fonts_Final.HUD.MF_Medium'
	HudFonts[2]=MultiFont'UI_Fonts_Final.HUD.MF_Large'
	HudFonts[3]=MultiFont'UI_Fonts_Final.HUD.MF_Huge'
	CharPortraitMaterial=Material'UI_HUD.Materials.CharPortrait'
	CharPortraitYPerc=0.1500000
	CharPortraitXPerc=0.0100000
	CharPortraitSlideTime=2.0000000
	CharPortraitSlideTransitionTime=0.1750000
	CharPortraitSize=(X=120.0000000,Y=96.0000000)
	WeaponBarScale=0.7500000
	WeaponBoxWidth=100.0000000
	WeaponBoxHeight=64.0000000
	TeamHUDColor=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000)
	WeaponBarY=16.0000000
	CurrentWeaponScale[0]=1.0000000
	CurrentWeaponScale[1]=1.0000000
	CurrentWeaponScale[2]=1.0000000
	CurrentWeaponScale[3]=1.0000000
	CurrentWeaponScale[4]=1.0000000
	CurrentWeaponScale[5]=1.0000000
	CurrentWeaponScale[6]=1.0000000
	CurrentWeaponScale[7]=1.0000000
	CurrentWeaponScale[8]=1.0000000
	CurrentWeaponScale[9]=1.0000000
	SelectedWeaponScale=1.5000000
	BounceWeaponScale=2.2500000
	SelectedWeaponAlpha=1.0000000
	OffWeaponAlpha=0.5000000
	EmptyWeaponAlpha=0.4000000
	WeaponScaleSpeed=10.0000000
	WeaponBarXOffset=70.0000000
	WeaponXOffset=60.0000000
	SelectedBoxScale=1.0000000
	WeaponYScale=64.0000000
	WeaponYOffset=8.0000000
	WeaponAmmoLength=48.0000000
	WeaponAmmoThickness=16.0000000
	WeaponAmmoOffsetX=100.0000000
	WeaponAmmoOffsetY=16.0000000
	SelectedWeaponAmmoOffsetX=110.0000000
	MessageOffset[0]=0.1500000
	MessageOffset[1]=0.2420000
	MessageOffset[2]=0.3600000
	MessageOffset[3]=0.5800000
	MessageOffset[4]=0.7800000
	MessageOffset[5]=0.8300000
	MessageOffset[6]=2.0000000
	MapDefaultSize=220.0000000
	SafeRegionPct=1.0000000
	MaxNoOfIndicators=3
	BaseMaterial=Material'UI_HUD.HUD.M_UI_HUD_DamageDir'
	FadeTime=0.5000000
	PositionalParamName="DamageDirectionRotation"
	FadeParamName="DamageDirectionAlpha"
	HitEffectIntensity=0.2500000
	MaxHitEffectColor=(R=1.0000000,G=-1.0000000,B=-1.0000000,A=2.0000000)
	HitEffectFadeTime=0.5000000
	DollPosition=(X=-1.0000000,Y=0.0000000)
	HealthBGCoords=(U=73.0000000,V=111.0000000,UL=143.0000000,VL=57.0000000)
	HealthOffsetX=65.0000000
	HealthBGOffsetX=65.0000000
	HealthBGOffsetY=59.0000000
	HealthIconX=80.0000000
	HealthIconY=88.0000000
	HealthTextX=185.0000000
	HealthTextY=55.0000000
	ArmorBGCoords=(U=74.0000000,V=69.0000000,UL=117.0000000,VL=42.0000000)
	ArmorBGOffsetX=65.0000000
	ArmorBGOffsetY=18.0000000
	ArmorIconX=80.0000000
	ArmorIconY=42.0000000
	ArmorTextX=160.0000000
	ArmorTextY=17.0000000
	AmmoPosition=(X=-1.0000000,Y=-1.0000000)
	AmmoBarOffsetY=2.0000000
	AmmoBGCoords=(U=1.0000000,V=368.0000000,UL=162.0000000,VL=53.0000000)
	AmmoTextOffsetX=125.0000000
	AmmoTextOffsetY=3.0000000
	MapPosition=(X=0.0500000,Y=0.9900000)
	PowerupYPos=0.7500000
	ScoringPosition=(X=0.0000000,Y=-1.0000000)
	VehiclePosition=(X=-1.0000000,Y=-1.0000000)
	DamageIndicatorSize=384.0000000
	NameplateWidth=8.0000000
	NameplateBubbleWidth=15.0000000
	NameplateLeft=(U=224.0000000,V=11.0000000,UL=14.0000000,VL=35.0000000)
	NameplateCenter=(U=238.0000000,V=11.0000000,UL=5.0000000,VL=35.0000000)
	NameplateBubble=(U=243.0000000,V=11.0000000,UL=26.0000000,VL=35.0000000)
	NameplateRight=(U=275.0000000,V=11.0000000,UL=14.0000000,VL=35.0000000)
	BlackBackgroundColor=(R=0.7000000,G=0.7000000,B=0.7000000,A=0.7000000)
	WarmupString="Warmup Round"
	WaitingForMatch="Waiting for the Match to Begin..."
	PressFireToBegin="Press [FIRE] to Begin..."
	SpectatorMessage="Spectator"
	DeadMessage="You have Died!"
	FireToRespawnMessage="Press [FIRE] to respawn"
	YouHaveWon="YOU HAVE WON THE MATCH!"
	YouHaveLost="YOU HAVE LOST THE MATCH!"
	PawnDollBGCoords=(U=9.0000000,V=52.0000000,UL=65.0000000,VL=116.0000000)
	DollOffsetX=35.0000000
	DollOffsetY=58.0000000
	DollWidth=56.0000000
	DollHeight=109.0000000
	VestX=36.0000000
	VestY=31.0000000
	VestWidth=46.0000000
	VestHeight=28.0000000
	ThighX=36.0000000
	ThighY=72.0000000
	ThighWidth=42.0000000
	ThighHeight=28.0000000
	HelmetX=36.0000000
	HelmetY=13.0000000
	HelmetWidth=22.0000000
	HelmetHeight=25.0000000
	BootX=37.0000000
	BootY=100.0000000
	BootWidth=54.0000000
	BootHeight=26.0000000
	AmmoBarColor=(R=1.0000000,G=7.0000000,B=7.0000000,A=7.0000000)
	RedLinearColor=(R=0.8000000,G=0.0500000,B=0.0000000,A=3.0000000)
	BlueLinearColor=(R=0.8000000,G=10.0000000,B=0.8000000,A=0.5000000)
	DMLinearColor=(R=0.5000000,G=1.0000000,B=1.0000000,A=1.0000000)
	WhiteLinearColor=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000)
	GoldLinearColor=(R=1.0000000,G=0.0000000,B=1.0000000,A=1.0000000)
	SilverLinearColor=(R=1.0000000,G=0.7500000,B=0.7500000,A=0.7500000)
	GlowFonts[0]=Font'UI_Fonts_Final.HUD.F_GlowPrimary'
	GlowFonts[1]=Font'UI_Fonts_Final.HUD.F_GlowSecondary'
	TextRenderInfo=(bClipText=true)
	ConsoleMessageCount=16
	MaxHUDAreaMessageCount=2
}