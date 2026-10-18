class UTFirstBloodMessage extends UTLocalMessage;

var const localized string FirstBloodString;

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	// End:0x17
	if(RelatedPRI_1 == none)
	{
		return "";
	}
	// End:0x3F
	if(RelatedPRI_1.PlayerName == "")
	{
		return "";
	}
	return RelatedPRI_1.PlayerName @ default.FirstBloodString;
	//return ReturnValue;	
}

static simulated function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	super(LocalMessage).ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	// End:0x69
	if(RelatedPRI_1 != P.PlayerReplicationInfo)
	{
		return;
	}
	UTPlayerController(P).PlayAnnouncement(default.Class, 0);
	UTPlayerController(P).ClientMusicEvent(6);
	//return;	
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
	return none;
	//return ReturnValue;	
}

defaultproperties
{
	FirstBloodString="drew first blood!"
	MessageArea=3
	AnnouncementPriority=9
	DrawColor=(R=0,G=255,B=255,A=0)
	FontSize=2
}