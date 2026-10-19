class GFxHaloMoviePlayer extends GFxMoviePlayer
	config(UI);

var HaloAkEventMap AkEventMap;
var string LocalizationSection;

function PlayAkEvent(AkEvent Event)
{
	Class'Engine.WorldInfo'.static.GetWorldInfo().PlayAkEvent(Event);
	//return;	
}

function PostAkEvent(AkEvent Event)
{
	Class'Engine.WorldInfo'.static.GetWorldInfo().PostAkEvent(Event);
	//return;	
}

function PostGlobalAkEvent(AkEvent Event)
{
	Class'Engine.WorldInfo'.static.GetWorldInfo().PostGlobalAkEvent(Event);
	//return;	
}

function SetRTPCValue(name rtpcName, float Value)
{
	Class'Engine.WorldInfo'.static.GetWorldInfo().SetRTPCValue(rtpcName, Value);
	//return;	
}

function SetAkState(name StateGroup, name StateName)
{
	Class'Engine.WorldInfo'.static.GetWorldInfo().SetAkState(StateGroup, StateName);
	//return;	
}

function SetSwitch(name SwitchGroup, name switchVal)
{
	Class'Engine.WorldInfo'.static.GetWorldInfo().SetSwitch(SwitchGroup, switchVal);
	//return;	
}

function PostTrigger(name Trigger)
{
	Class'Engine.WorldInfo'.static.GetWorldInfo().PostTrigger(Trigger);
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