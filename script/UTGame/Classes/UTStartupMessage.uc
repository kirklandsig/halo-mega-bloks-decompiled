class UTStartupMessage extends UTLocalMessage;

var const localized string Stage[7];
var const localized string NotReady;
var const localized string SinglePlayer;

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	local UTPlayerController UTP;
	local UTHUD HUD;

	super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	UTP = UTPlayerController(P);
	// End:0x68
	if(UTP == none)
	{
		return;
	}
	HUD = UTHUD(P.myHUD);
	// End:0xF4
	if(((HUD != none) && HUD.bIsSplitScreen) && !HUD.bIsFirstPlayer)
	{
		return;
	}
	// End:0x1F3
	if(Switch == 5)
	{
		// End:0x1F0
		if((P.WorldInfo != none) && (UTGame(P.WorldInfo.Game) == none) || !UTGame(P.WorldInfo.Game).SkipPlaySound())
		{
			UTP.PlayAnnouncement(default.Class, 1);
		}		
	}
	else
	{
		// End:0x233
		if((Switch > 1) && Switch < 5)
		{
			UTP.PlayBeepSound();
		}
	}
	//return;	
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
	return none;
	//return ReturnValue;	
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	local int I, PlayerCount;
	local GameReplicationInfo GRI;

	// End:0x10D
	if((RelatedPRI_1 != none) && int(RelatedPRI_1.WorldInfo.NetMode) == int(NM_Standalone))
	{
		// End:0xF0
		if((UTGame(RelatedPRI_1.WorldInfo.Game) != none) && UTGame(RelatedPRI_1.WorldInfo.Game).bQuickStart)
		{
			return "";
		}
		// End:0x10A
		if(Switch < 2)
		{
			return default.SinglePlayer;
		}		
	}
	else
	{
		// End:0x39D
		if((Switch == 0) && RelatedPRI_1 != none)
		{
			GRI = RelatedPRI_1.WorldInfo.GRI;
			// End:0x185
			if(GRI == none)
			{
				return default.Stage[0];
			}
			I = 0;
			J0x190:

			// End:0x316 [Loop If]
			if(I < GRI.PRIArray.Length)
			{
				// End:0x308
				if((((GRI.PRIArray[I] != none) && !GRI.PRIArray[I].bOnlySpectator) && !GRI.PRIArray[I].bBot) && !GRI.PRIArray[I].bIsSpectator || GRI.PRIArray[I].bWaitingPlayer)
				{
					PlayerCount++;
				}
				I++;
				// [Loop Continue]
				goto J0x190;
			}
			// End:0x39A
			if((UTGameReplicationInfo(GRI).MinNetPlayers - PlayerCount) > 0)
			{
				return ((default.Stage[0] @ "(") $ string(UTGameReplicationInfo(GRI).MinNetPlayers - PlayerCount)) $ ")";
			}			
		}
		else
		{
			// End:0x42B
			if(Switch == 1)
			{
				// End:0x3F0
				if((RelatedPRI_1 == none) || !RelatedPRI_1.bWaitingPlayer)
				{
					return default.Stage[0];					
				}
				else
				{
					// End:0x421
					if(RelatedPRI_1.bReadyToPlay)
					{
						return default.Stage[1];						
					}
					else
					{
						return default.NotReady;
					}
				}
			}
		}
	}
	return default.Stage[Switch];
	//return ReturnValue;	
}

defaultproperties
{
	Stage[0]="Waiting for other players."
	Stage[1]="Waiting for other ready signals."
	Stage[2]="The match is about to begin...3"
	Stage[3]="The match is about to begin...2"
	Stage[4]="The match is about to begin...1"
	Stage[5]="The match has begun!"
	Stage[6]="The match has begun!"
	NotReady="You are NOT READY. Press Fire!"
	SinglePlayer="Press [FIRE] to start!"
	AnnouncementPriority=20
	bIsUnique=true
	bIsConsoleMessage=false
	FontSize=2
}