class GripCheatManager extends GameCheatManager within GamePlayerController
	config(Game);

exec function ShowDESInfo(optional string infoType)
{
	Class'Grip.GripDebug'.static.ShowDESInfo(infoType);
	//return;	
}

exec function DESDebugOptions(optional string infoType)
{
	Class'Grip.GripDebug'.static.DESDebugOptions(infoType);
	//return;	
}

exec function CCSDebugOptions(optional string infoType)
{
	Class'Grip.GripDebug'.static.CCSDebugOptions(infoType);
	//return;	
}

exec function StartGripDebug()
{
	Class'Grip.GripDebug'.static.StartGripDebug();
	//return;	
}

exec function StopGripDebug()
{
	Class'Grip.GripDebug'.static.StopGripDebug();
	//return;	
}

exec function StartGripLogging()
{
	Class'Grip.GripDebug'.static.StartGripLogging();
	//return;	
}

exec function StopGripLogging()
{
	Class'Grip.GripDebug'.static.StopGripLogging();
	//return;	
}

exec function GripDebugViewNPCFromBrainID(int BrainID)
{
	Class'Grip.GripDebug'.static.GripDebugViewNPCFromBrainID(BrainID);
	//return;	
}
