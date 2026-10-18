class HaloProjectile_UnscRocket extends HaloProjectile;

var float MinSpiralRate;
var float MaxSpiralRate;
var float MinSpiralRadius;
var float MaxSpiralRadius;
var float SpiralRate;
var float SpiralRadius;
var Vector SpiralLoc;
var Vector SpiralStartAxis;
var Vector SpiralAxis;
var float SeekingTimer;
var float EstTimeOfImpact;

function Init(Vector Direction)
{
	super.Init(Direction);
	SpiralRate = RandRange(MinSpiralRate, MaxSpiralRate) * 0.0174533;
	SpiralRate = ((Rand(2) > 0) ? SpiralRate- : SpiralRate);
	SpiralRadius = RandRange(MinSpiralRadius, MaxSpiralRadius);
	SpiralLoc = Location;
	SpiralLoc.Z += SpiralRadius;
	SpiralAxis = Direction;
	SpiralStartAxis = SpiralAxis;
	Velocity = (SpiralRate * SpiralRadius) * (SpiralAxis Cross vect(0.0000000, 0.0000000, 1.0000000));
	Velocity += (Speed * SpiralAxis);
	//return;	
}

function SetTarget(HaloPawn Target)
{
	local float targDist, maxSpeedTime, maxSpeedDist, A, B, C,
		Q, loopCt;

	SeekTarget = Target;
	// End:0x24A
	if(SeekTarget != none)
	{
		targDist = VSize(SeekTarget.Location - SpiralLoc);
		// End:0x8B
		if(AccelRate <= 0.0000000)
		{
			EstTimeOfImpact = targDist / Speed;			
		}
		else
		{
			maxSpeedTime = (MaxSpeed - Speed) / AccelRate;
			maxSpeedDist = (0.5000000 * maxSpeedTime) * (MaxSpeed + Speed);
			// End:0x1C0
			if(maxSpeedDist >= targDist)
			{
				A = 0.5000000 * AccelRate;
				B = Speed;
				C = targDist-;
				Q = (B * B) - ((4.0000000 * A) * C);
				// End:0x1BD
				if(Q > 0.0000000)
				{
					EstTimeOfImpact = (Sqrt(Q) - B) / (2.0000000 * A);
				}				
			}
			else
			{
				EstTimeOfImpact = maxSpeedTime + ((targDist - maxSpeedDist) / MaxSpeed);
			}
		}
		loopCt = SpiralRate * EstTimeOfImpact;
		SpiralRate = (float(FCeil(loopCt * 2.0000000)) * 0.5000000) / EstTimeOfImpact;
	}
	//return;	
}

function TickTargetSeeking(float DeltaTime)
{
	local Vector toTarg;
	local float T;
	local Vector toAxis, NewLoc;
	local Quat spinDelta;

	// End:0x49
	if((SeekTargetsComponent != none) && SeekTargetsComponent.IsDead())
	{
		SeekTarget = none;
		SeekTargetsComponent = none;
	}
	// End:0x13D
	if(SeekTarget != none)
	{
		SeekingTimer += DeltaTime;
		toTarg = SeekTarget.Location - SpiralLoc;
		toTarg = Normal(toTarg);
		// End:0xF0
		if(SeekingTimer >= EstTimeOfImpact)
		{
			T = 1.0000000;
			SpiralAxis = toTarg;			
		}
		else
		{
			T = SeekingTimer / EstTimeOfImpact;
			SpiralAxis = VLerp(SpiralStartAxis, toTarg, T);
		}
	}
	toAxis = SpiralLoc - Location;
	toAxis -= ((SpiralAxis Dot toAxis) * SpiralAxis);
	// End:0x1E5
	if(SeekTarget != none)
	{
		toAxis = Lerp(SpiralRadius, 0.5000000 * SeekTarget.GetCollisionRadius(), T) * Normal(toAxis);
	}
	spinDelta = QuatFromAxisAndAngle(SpiralAxis, SpiralRate * DeltaTime);
	toAxis = QuatRotateVector(spinDelta, toAxis);
	NewLoc = SpiralLoc - toAxis;
	Velocity = (NewLoc - Location) / DeltaTime;
	Velocity += (Speed * SpiralAxis);
	SpiralLoc += ((Speed * DeltaTime) * SpiralAxis);
	SetRotation(Rotator(Velocity));
	//return;	
}

simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	local Vector NewLoc, fwd;

	// End:0x3F
	if(Pawn(Wall) != none)
	{
		super(Projectile).HitWall(HitNormal, Wall, WallComp);
		return;
	}
	fwd = Vector(Rotation);
	// End:0x99
	if((HitNormal Dot fwd) < -0.8000000)
	{
		super(Projectile).HitWall(HitNormal, Wall, WallComp);
		return;
	}
	NewLoc = Location + (5.0000000 * HitNormal);
	SetLocation(NewLoc);
	fwd -= ((1.5000000 * (HitNormal Dot fwd)) * HitNormal);
	fwd = Normal(fwd);
	SetRotation(Rotator(fwd));
	Velocity -= ((1.5000000 * (HitNormal Dot Velocity)) * HitNormal);
	//return;	
}

defaultproperties
{
	MinSpiralRate=360.0000000
	MaxSpiralRate=530.0000000
	MinSpiralRadius=50.0000000
	MaxSpiralRadius=150.0000000
	SeekingTurnRate=10000.0000000
	akWeaponType="UNSC_RocketLauncher"
	MaxEffectDistance=5000.0000000
	CheckRadius=40.0000000
	Speed=3000.0000000
	MaxSpeed=0.0000000
	Damage=250.0000000
	DamageRadius=100.0000000
	MomentumTransfer=5000.0000000
	MyDamageType=Class'MegaHaloGame.HaloDamageType_UnscRocket'
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloProjectile_UnscRocket.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloProjectile.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	AISpeedOverride=100.0000000
	Components[0]=CollisionCylinder
	bCollideComplex=false
	LifeSpan=2.0000000
	CollisionComponent=CollisionCylinder
}