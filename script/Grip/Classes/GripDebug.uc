class GripDebug extends Object
	native;

// Export UGripDebug::execShowDESInfo(FFrame&, void* const)
native static function ShowDESInfo(optional string infoType);

// Export UGripDebug::execDESDebugOptions(FFrame&, void* const)
native static function DESDebugOptions(optional string Options);

// Export UGripDebug::execCCSDebugOptions(FFrame&, void* const)
native static function CCSDebugOptions(optional string Options);

// Export UGripDebug::execIsDebugEnabled(FFrame&, void* const)
native static function bool IsDebugEnabled();

// Export UGripDebug::execStartGripDebug(FFrame&, void* const)
native static function StartGripDebug();

// Export UGripDebug::execStopGripDebug(FFrame&, void* const)
native static function StopGripDebug();

// Export UGripDebug::execStartGripLogging(FFrame&, void* const)
native static function StartGripLogging();

// Export UGripDebug::execStopGripLogging(FFrame&, void* const)
native static function StopGripLogging();

// Export UGripDebug::execGripAdvanceSim(FFrame&, void* const)
native static function GripAdvanceSim();

// Export UGripDebug::execGripStopAdvanceSim(FFrame&, void* const)
native static function GripStopAdvanceSim();

// Export UGripDebug::execSelectDebugPawn(FFrame&, void* const)
native static function SelectDebugPawn();

// Export UGripDebug::execToggleDisableNPC(FFrame&, void* const)
native static function ToggleDisableNPC();

// Export UGripDebug::execNextBrainDebugRenderType(FFrame&, void* const)
native static function NextBrainDebugRenderType();

// Export UGripDebug::execGetLocationAndRotationFromBrainID(FFrame&, void* const)
native static function bool GetLocationAndRotationFromBrainID(int BrainID, out Vector ActorLocation, out Vector ActorRotation);

static function GripDebugViewNPCFromBrainID(int BrainID)
{
	local WorldInfo WI;
	local PlayerController PC;
	local DebugCameraController DCC;
	local bool SwitchedToDebugCamera;
	local Vector ActorLocation, ActorRotation, NewCameraPos, NewCameraRotation;
	local bool Result;
	local int Offset;

	Result = Class'Grip.GripDebug'.static.GetLocationAndRotationFromBrainID(BrainID, ActorLocation, ActorRotation);
	// End:0x56
	if(!Result)
	{
		return;
	}
	WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
	// End:0x152
	foreach WI.AllControllers(Class'Engine.PlayerController', PC)
	{
		// End:0x151
		if(PC.bIsPlayer && PC.IsLocalPlayerController())
		{
			DCC = DebugCameraController(PC);
			// End:0x14E
			if((DCC != none) && DCC.OriginalControllerRef == none)
			{
				continue;				
			}
			// End:0x152
			break;
		}		
	}	
	// End:0x28F
	if((PC != none) && DCC == none)
	{		
		PC.ConsoleCommand("ToggleDebugCamera");
		SwitchedToDebugCamera = true;
		// End:0x28E
		foreach WI.AllControllers(Class'Engine.PlayerController', PC)
		{
			// End:0x28D
			if(PC.bIsPlayer && PC.IsLocalPlayerController())
			{
				DCC = DebugCameraController(PC);
				// End:0x28A
				if((DCC != none) && DCC.OriginalControllerRef == none)
				{
					continue;					
				}
				// End:0x28E
				break;
			}			
		}		
	}
	// End:0x38C
	if((DCC != none) && DCC.OriginalControllerRef != none)
	{
		Offset = 300;
		NewCameraPos = ActorLocation - (ActorRotation * float(Offset));
		NewCameraPos.Z += float(Offset);
		NewCameraRotation = ActorLocation - NewCameraPos;
		DCC.SetLocation(NewCameraPos);
		DCC.SetRotation(Rotator(NewCameraRotation));		
	}
	else
	{
		// End:0x3D5
		if(SwitchedToDebugCamera)
		{			
			PC.ConsoleCommand("ToggleDebugCamera");
		}
	}
	//return;	
}
