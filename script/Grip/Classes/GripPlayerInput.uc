class GripPlayerInput extends PlayerInput within PlayerController
	transient
	config(Input);

function bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed = 1.0000000, optional bool bGamepad = false)
{
	return ProcessKey(Outer, Key, Event);
	//return ReturnValue;	
}

static function bool ProcessKey(PlayerController OwnerCtrl, name Key, Object.EInputEvent Event)
{
	// End:0x26
	if(!Class'Grip.GripDebug'.static.IsDebugEnabled())
	{
		return false;
	}
	// End:0x169
	if(int(Event) == 0)
	{
		// End:0x72
		if(Key == 'F1')
		{
			Class'Grip.GripDebug'.static.SelectDebugPawn();
			return true;
		}
		// End:0xAA
		if(Key == 'F2')
		{
			Class'Grip.GripDebug'.static.NextBrainDebugRenderType();
			return true;
		}
		// End:0xE2
		if(Key == 'F3')
		{
			Class'Grip.GripDebug'.static.GripAdvanceSim();
			return true;
		}
		// End:0x131
		if(Key == 'F4')
		{			
			OwnerCtrl.ConsoleCommand("Playersonly");
			return true;
		}
		// End:0x169
		if(Key == 'F5')
		{
			Class'Grip.GripDebug'.static.ToggleDisableNPC();
			return true;
		}
	}
	// End:0x1B5
	if(int(Event) == 1)
	{
		// End:0x1B5
		if(Key == 'F3')
		{
			Class'Grip.GripDebug'.static.GripStopAdvanceSim();
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

defaultproperties
{
	OnReceivedNativeInputKey=InputKey
}