class HaloBubbleShieldComponent extends HaloArmorAbilityComponent;

var HaloDeployableBubbleShield BubbleShield;

function bool Activate()
{
	// End:0xAB
	if((bAvailable == true) && bActive == false)
	{
		// End:0x60
		if(BubbleShield != none)
		{
			BubbleShield.LifeSpan = 0.0001000;
			BubbleShield = none;
		}
		Duration = 0.0000000;
		DurationTimer = 0.0000000;
		// End:0xAB
		if((TryToDropShield()) == true)
		{
			bAvailable = false;
			CooldownTimer = 0.0000000;
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function bool TryToDropShield()
{
	local bool bDropped;
	local HaloPawn Pawn;

	bDropped = false;
	Pawn = HaloPawn(Owner);
	// End:0x124
	if((Pawn != none) && int(Pawn.Physics) == int(1))
	{
		Duration = Pawn.PlayCustomAnimation('Bubble') * 0.5000000;
		// End:0x10F
		if(Duration > 0.0000000)
		{
			bActive = true;
			DurationTimer = Duration;
			bDropped = true;
			Pawn.SetTimer(Duration, false, 'DropShieldAfterAnim', self);			
		}
		else
		{
			bDropped = DropShieldNow();
		}
	}
	return bDropped;
	//return ReturnValue;	
}

function DropShieldAfterAnim()
{
	// End:0x22
	if((DropShieldNow()) == true)
	{
		CooldownTimer = 0.0000000;		
	}
	//return;	
}

function bool DropShieldNow()
{
	local HaloPawn Pawn;
	local Vector SpawnLoc;

	Pawn = HaloPawn(Owner);
	// End:0x194
	if((Pawn != none) && int(Pawn.Physics) == int(1))
	{
		SpawnLoc = Pawn.Location;
		SpawnLoc.Z -= Pawn.CylinderComponent.CollisionHeight;
		SpawnLoc += (Vector(Pawn.Rotation) * (Pawn.CylinderComponent.CollisionRadius * 2.0000000));
		BubbleShield = Pawn.Spawn(Class'MegaHaloGame.HaloDeployableBubbleShield',,, SpawnLoc, Pawn.Rotation);
	}
	return BubbleShield != none;
	//return ReturnValue;	
}

defaultproperties
{
	Cooldown=30.0000000
}