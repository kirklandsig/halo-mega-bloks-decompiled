class UTTimerMessage extends UTLocalMessage
	abstract;

var array<ObjectiveAnnouncementInfo> Announcements;

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	local UTHUD HUD;

	super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	// End:0x142
	if(default.Announcements[Switch].AnnouncementSound != none)
	{
		HUD = UTHUD(P.myHUD);
		// End:0xF3
		if(((HUD != none) && HUD.bIsSplitScreen) && HUD.bIsFirstPlayer!)
		{
			return;
		}
		// End:0x106
		if(Switch < 11)
		{			
		}
		else
		{
			UTPlayerController(P).PlayAnnouncement(default.Class, Switch);
		}
	}
	//return;	
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	return default.Announcements[Switch].AnnouncementText;
	//return ReturnValue;	
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
	return default.Announcements[MessageIndex].AnnouncementSound;
	//return ReturnValue;	
}

static function int GetFontSize(int Switch, PlayerReplicationInfo RelatedPRI1, PlayerReplicationInfo RelatedPRI2, PlayerReplicationInfo LocalPlayer)
{
	// End:0x13
	if(Switch == 17)
	{
		return 4;
	}
	// End:0x2D
	if(Switch > 10)
	{
		return default.FontSize;
	}
	return 2;
	//return ReturnValue;	
}

defaultproperties
{
	bIsUnique=true
	bIsConsoleMessage=false
	FontSize=1
}