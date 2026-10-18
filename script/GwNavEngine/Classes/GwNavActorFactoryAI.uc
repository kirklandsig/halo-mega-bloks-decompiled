class GwNavActorFactoryAI extends ActorFactoryAI
	native
	config(Editor)
	editinlinenew
	collapsecategories;

var const GwNavNavdataFamily NavDataFamily;
var bool EnableAvoidance;
var bool EnableShortcut;
var int AllowedCanTraverseType;

defaultproperties
{
	NavDataFamily=GwNavNavdataFamily'EngineGwNav.DefaultFamily'
	EnableAvoidance=true
	EnableShortcut=true
	AllowedCanTraverseType=-1
	ControllerClass=Class'GwNavEngine.GwNavAIController'
}