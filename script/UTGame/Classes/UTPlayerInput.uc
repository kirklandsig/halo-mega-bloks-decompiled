class UTPlayerInput extends UDKPlayerInput within UTPlayerController
	transient
	config(Game);

var float LastDuckTime;
var bool bHoldDuck;
var Actor.EDoubleClickDir ForcedDoubleClick;

simulated exec function Duck()
{
	// End:0x11F
	if(UTPawn(Outer.Pawn) != none)
	{
		// End:0x69
		if(bHoldDuck)
		{
			bHoldDuck = false;
			Outer.bDuck = 0;
			return;
		}
		Outer.bDuck = 1;
		// End:0xE2
		if((Outer.WorldInfo.TimeSeconds - LastDuckTime) < DoubleClickTime)
		{
			bHoldDuck = true;
		}
		LastDuckTime = Outer.WorldInfo.TimeSeconds;
	}
	//return;	
}

simulated exec function UnDuck()
{
	// End:0x30
	if(!bHoldDuck)
	{
		Outer.bDuck = 0;
	}
	//return;	
}

exec function Jump()
{
	local UTPawn P;

	// End:0x10A
	if(!Outer.IsMoveInputIgnored())
	{
		P = UTPawn(Outer.Pawn);
		// End:0xAA
		if((P != none) && P.bFeigningDeath)
		{
			P.FeignDeath();			
		}
		else
		{
			// End:0x100
			if(int(Outer.bDuck) > int(0))
			{
				Outer.bDuck = 0;
				bHoldDuck = false;
			}
			super(PlayerInput).Jump();
		}
	}
	//return;	
}

function bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed = 1.0000000, optional bool bGamepad = false)
{
	return Class'Grip.GripPlayerInput'.static.ProcessKey(Outer, Key, Event);
	//return ReturnValue;	
}

defaultproperties
{
	bEnableFOVScaling=true
	OnReceivedNativeInputKey=InputKey
}