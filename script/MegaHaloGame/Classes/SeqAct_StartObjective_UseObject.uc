class SeqAct_StartObjective_UseObject extends SeqAct_StartObjective;

var ObjectiveMarkerData UseObject;

function CreateObjective()
{
	Objective = new Class'MegaHaloGame.HaloObjective_UseObject';
	//return;	
}

function SetObjectiveProperties()
{
	local HaloObjective_UseObject UseObj;

	UseObj = HaloObjective_UseObject(Objective);
	// End:0x56
	if(UseObj != none)
	{
		UseObj.UseObject = UseObject;		
	}
	else
	{
		WarnInternal("Error creating new Objective -- not of type HaloObjective_UseObject!");
	}
	super.SetObjectiveProperties();
	//return;	
}

defaultproperties
{
	UseObject=(Actor=none,Marker=OMN_Use,bDraw=true,bDrawTagSymbol=false,bShowHealth=false,bShowDistance=true,bClampToScreen=true)
	ObjectiveName="Use Object"
	ObjName="Start Use Object Objective"
}