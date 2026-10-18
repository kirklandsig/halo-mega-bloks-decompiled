class HaloUpgrade extends Actor
	notplaceable;

var array<HaloUpgrade> NextUpgrades;
var int XPRequired;
var int BloksRequired;
var int GlobalBloksRequired;
var string DescriptionRef;
var const localized string InteractMessage0;
var const localized string InteractMessage1;

defaultproperties
{
	InteractMessage0="Press [MainHUD.InlineInputIcons.inputIcon_y] To Upgrade"
	InteractMessage1="Press [MainHUD.InlineInputIcons.inputIcon_b] To Upgrade"
}