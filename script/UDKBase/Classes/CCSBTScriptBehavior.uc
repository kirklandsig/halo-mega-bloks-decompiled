class CCSBTScriptBehavior extends GripBTScriptBehavior
	abstract
	native;

var CCSController Controller;

function Initialize()
{
	super(GripBTScriptNode).Initialize();
	Controller = CCSController(Owner);
	//return;	
}
