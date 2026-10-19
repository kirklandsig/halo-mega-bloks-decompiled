class HaloGravityLiftExit extends HaloGravityLift;

var float ExitingAccel;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	SetCollision(bEnabled, bBlockActors);
	//return;	
}

simulated function TickPawn(Pawn Pawn, float DeltaTime)
{
	local Vector toCenter;
	local float accelZ;

	// End:0x43
	if(int(Pawn.Physics) == int(1))
	{
		Pawn.SetPhysics(2);
	}
	toCenter = Location - Pawn.Location;
	// End:0x230
	if(Abs(toCenter.Z) > 0.0010000)
	{
		// End:0x156
		if((Pawn.Velocity.Z * toCenter.Z) <= 0.0000000)
		{
			Pawn.Velocity.Z = (2.0000000 * toCenter.Z) / 0.2500000;			
		}
		else
		{
			accelZ = (Pawn.Velocity.Z * Pawn.Velocity.Z) / (-2.0000000 * toCenter.Z);
			Pawn.Velocity.Z += (accelZ * DeltaTime);
		}
	}
	toCenter.Z = 0.0000000;
	// End:0x2B8
	if(VSizeSq2D(toCenter) <= (100.0000000 * 100.0000000))
	{
		Pawn.Acceleration = Vector(Pawn.Rotation);		
	}
	else
	{
		Pawn.Acceleration = -Normal(toCenter);
	}
	Pawn.Acceleration *= ExitingAccel;
	Pawn.Acceleration.Z = accelZ;
	//return;	
}

defaultproperties
{
	ExitingAccel=600.0000000
	GravityZ=0.0000000
	// Reference: BrushComponent'MegaHaloGame.Default__HaloGravityLiftExit.BrushComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'BrushComponent0'
	// Archetype: BrushComponent'MegaHaloGame.Default__HaloGravityLift.BrushComponent0'
	begin object name="BrushComponent0"
		ReplacementPrimitive=none
	end object
	BrushComponent=BrushComponent0
	Components[0]=BrushComponent0
	CollisionComponent=BrushComponent0
}