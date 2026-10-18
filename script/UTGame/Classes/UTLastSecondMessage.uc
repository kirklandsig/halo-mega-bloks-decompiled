class UTLastSecondMessage extends UTLocalMessage;

var const localized string LastSecondRed;
var const localized string LastSecondBlue;

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	// End:0x20
	if(TeamInfo(OptionalObject) == none)
	{
		return "";
	}
	// End:0x5A
	if(TeamInfo(OptionalObject).TeamIndex == 0)
	{
		return default.LastSecondRed;		
	}
	else
	{
		return default.LastSecondBlue;
	}
	//return ReturnValue;	
}

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	UTPlayerController(P).PlayAnnouncement(default.Class, Switch);
	// End:0xD0
	if(P.PlayerReplicationInfo == RelatedPRI_1)
	{
		UTPlayerController(P).ClientMusicEvent(2);		
	}
	else
	{
		UTPlayerController(P).ClientMusicEvent(10);
	}
	//return;	
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
	return none;
	//return ReturnValue;	
}

defaultproperties
{
	LastSecondRed="Last second save by Red!"
	LastSecondBlue="Last second save by Blue!"
	MessageArea=2
	AnnouncementPriority=12
	bIsUnique=true
	DrawColor=(R=160,G=0,B=255,A=255)
	FontSize=2
}