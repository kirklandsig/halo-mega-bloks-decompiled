class HaloGravityLift extends GravityVolume;

var bool bEnabled;
var float CenteringSpeed;

simulated event PostBeginPlay()
{
	super(PhysicsVolume).PostBeginPlay();
	SetCollision(bEnabled, bBlockActors);
	//return;	
}

simulated function TickPawn(Pawn Pawn, float DeltaTime)
{
	local Vector toCenter;
	local float Dist, theta;

	// End:0x43
	if(int(Pawn.Physics) == int(1))
	{
		Pawn.SetPhysics(2);
	}
	toCenter = Location - Pawn.Location;
	toCenter.Z = 0.0000000;
	// End:0x120
	if(IsZero(toCenter)!)
	{
		Dist = VSize2D(toCenter);
		theta = float(Min(int((Dist / 256.0000000) * 3.1415927), int(3.1415927)));
		toCenter *= ((Sin(theta) / Dist) * CenteringSpeed);
	}
	Pawn.Velocity.X = toCenter.X;
	Pawn.Velocity.Y = toCenter.Y;
	Pawn.Acceleration.X = 0.0000000;
	Pawn.Acceleration.Y = 0.0000000;
	//return;	
}

defaultproperties
{
	bEnabled=true
	CenteringSpeed=300.0000000
	GravityZ=300.0000000
	BrushColor=(R=255,G=100,B=255,A=255)
	bColored=true
	// Reference: BrushComponent'MegaHaloGame.Default__HaloGravityLift.BrushComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'BrushComponent0'
	// Archetype: BrushComponent'Engine.Default__GravityVolume.BrushComponent0'
	begin object name="BrushComponent0"
		ReplacementPrimitive=none
	end object
	BrushComponent=BrushComponent0
	Components[0]=BrushComponent0
	Physics=EPhysics.PHYS_Interpolating
	bStatic=false
	CollisionComponent=BrushComponent0
}