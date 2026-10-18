class SeqAct_DisplayTextToHUD extends SequenceAction;

var string Text;
var int XPosition;
var int YPosition;
var int FontSize;
var int R;
var int G;
var int B;
var string Alignment;

defaultproperties
{
	FontSize=18
	R=255
	G=255
	Alignment="left"
	HandlerName="DisplayTextToHUD"
	ObjName="Display Text to HUD"
}