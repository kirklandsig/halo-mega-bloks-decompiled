class GripDebugCameraInput extends DebugCameraInput within PlayerController
	transient
	config(Input);

function bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed = 1.0000000, optional bool bGamepad = false)
{
	// End:0x6B
	if(Class'Grip.GripDebug'.static.IsDebugEnabled()!)
	{
		return super.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
	}
	// End:0x1C9
	if(int(Event) == int(0))
	{
		// End:0xB7
		if(Key == 'F2')
		{
			Class'Grip.GripDebug'.static.NextBrainDebugRenderType();
			return true;
		}
		// End:0xEF
		if(Key == 'F3')
		{
			Class'Grip.GripDebug'.static.GripAdvanceSim();
			return true;
		}
		// End:0x13E
		if(Key == 'F4')
		{			
			Outer.ConsoleCommand("Playersonly");
			return true;
		}
		// End:0x176
		if(Key == 'F5')
		{
			Class'Grip.GripDebug'.static.ToggleDisableNPC();
			return true;
		}
		// End:0x1C9
		if(Key == 'Escape')
		{			
			Outer.ConsoleCommand("ToggleDebugCamera");
		}
	}
	// End:0x24D
	if(int(Event) == int(1))
	{
		// End:0x215
		if(Key == 'F1')
		{
			Class'Grip.GripDebug'.static.SelectDebugPawn();
			return true;
		}
		// End:0x24D
		if(Key == 'F3')
		{
			Class'Grip.GripDebug'.static.GripStopAdvanceSim();
			return true;
		}
	}
	return super.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
	//return ReturnValue;	
}
