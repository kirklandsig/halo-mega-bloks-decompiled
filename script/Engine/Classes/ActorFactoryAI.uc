class ActorFactoryAI extends ActorFactory
	native
	config(Editor)
	editinlinenew
	collapsecategories;

var Class<AIController> ControllerClass;
var Class<Pawn> PawnClass;
var Class<Vehicle> VehicleClass;
var string PawnName;
var bool bGiveDefaultInventory;
var array< Class<Inventory> > InventoryList;
var int TeamIndex;

defaultproperties
{
	ControllerClass=Class'Engine.AIController'
	TeamIndex=255
	bPlaceable=false
}