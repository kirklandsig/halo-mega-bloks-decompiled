class GFxHaloMoviePlayer extends GFxMoviePlayer
	config(UI);

var HaloAkEventMap AkEventMap;
var string LocalizationSection;

function PlayAkEvent(AkEvent Event)
{
	Class'Engine.WorldInfo'.static.GetWorldInfo().super(GFxHaloMoviePlayer).PlayAkEvent(Event);
	//return;	
}

function PostAkEvent(AkEvent Event)
{
	Class'Engine.WorldInfo'.static.GetWorldInfo().super(GFxHaloMoviePlayer).PostAkEvent(Event);
	//return;	
}

function PostGlobalAkEvent(AkEvent Event)
{
	Class'Engine.WorldInfo'.static.GetWorldInfo().super(GFxHaloMoviePlayer).PostGlobalAkEvent(Event);
	//return;	
}

function SetRTPCValue(name rtpcName, float Value)
{
	Class'Engine.WorldInfo'.static.GetWorldInfo().super(GFxHaloMoviePlayer).SetRTPCValue(rtpcName, Value);
	//return;	
}

function SetAkState(name StateGroup, name StateName)
{
	Class'Engine.WorldInfo'.static.GetWorldInfo().super(GFxHaloMoviePlayer).SetAkState(StateGroup, StateName);
	//return;	
}

function SetSwitch(name SwitchGroup, name switchVal)
{
	Class'Engine.WorldInfo'.static.GetWorldInfo().super(GFxHaloMoviePlayer).SetSwitch(SwitchGroup, switchVal);
	//return;	
}

function PostTrigger(name Trigger)
{
	Class'Engine.WorldInfo'.static.GetWorldInfo().super(GFxHaloMoviePlayer).PostTrigger(Trigger);
	//return;	
}

function PlayMenuSound(string soundName)
{
	LogInternal("GFxHaloMoviePlayer.PlayMenuSound " $ soundName);
	AkEventMap.PostAkEvent(soundName);
	//return;	
}

function string LocalizeString(string locStr)
{
	LogInternal(((("Localizing " $ locStr) $ " in ") $ LocalizationSection) $ " section of MegaHaloGame");
	return Localize(LocalizationSection, locStr, "MegaHaloGame");
	//return ReturnValue;	
}

defaultproperties
{
	LocalizationSection="GFxHaloMoviePlayer"
}