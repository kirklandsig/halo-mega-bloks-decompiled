class HaloArmorAbilityComponent extends ActorComponent;

var float Duration;
var float DurationTimer;
var float Cooldown;
var float CooldownTimer;
var bool bActive;
var bool bAvailable;

function PostBeginPlay()
{
	CooldownTimer = Cooldown;
	//return;	
}

function bool Activate()
{
	// End:0x5C
	if(bAvailable == true)
	{
		// End:0x5C
		if(bActive == false)
		{
			bAvailable = false;
			bActive = true;
			DurationTimer = Duration;
			CooldownTimer = 0.0000000;
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function bool Deactivate()
{
	// End:0x1E
	if(bActive == true)
	{
		bActive = false;
		return true;
	}
	return false;
	//return ReturnValue;	
}

function Tick(float DeltaTime)
{
	// End:0x3E
	if(bActive)
	{
		DurationTimer -= DeltaTime;
		// End:0x3E
		if(DurationTimer <= 0.0000000)
		{
			Deactivate();
		}
	}
	// End:0x98
	if(bAvailable == false)
	{
		CooldownTimer += DeltaTime;
		// End:0x98
		if(CooldownTimer >= Cooldown)
		{
			bAvailable = true;
			CooldownTimer = Cooldown;
		}
	}
	//return;	
}

defaultproperties
{
	bAvailable=true
}