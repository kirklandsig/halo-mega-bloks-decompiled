class Player extends Object
	transient
	native
	config(Engine);

var private native const noexport Pointer VfTable_FExec;
var const transient PlayerController Actor;
var const int CurrentNetSpeed;
var globalconfig int ConfiguredInternetSpeed;
var globalconfig int ConfiguredLanSpeed;
var config float PP_DesaturationMultiplier;
var config float PP_HighlightsMultiplier;
var config float PP_MidTonesMultiplier;
var config float PP_ShadowsMultiplier;

// Export UPlayer::execSwitchController(FFrame&, void* const)
native function SwitchController(PlayerController PC);

defaultproperties
{
	ConfiguredInternetSpeed=10000
	ConfiguredLanSpeed=20000
	PP_DesaturationMultiplier=1.0000000
	PP_HighlightsMultiplier=1.0000000
	PP_MidTonesMultiplier=1.0000000
	PP_ShadowsMultiplier=1.0000000
}