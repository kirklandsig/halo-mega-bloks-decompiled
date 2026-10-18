class UTGib_VehiclePiece extends UTGib_Vehicle
	config(Game)
	notplaceable;

var name AkObjectType;

simulated event PreBeginPlay()
{
	super(Actor).PreBeginPlay();
	//return;	
}

simulated event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData Collision, int ContactIndex)
{
	SetSwitch('Object_Type', AkObjectType);
	SetSwitch('Surface', 'Concrete');
	SetRTPCValue('Impulse_Value', float(Min(int(Abs(Velocity.Z)), 100)));
	PlayAkEvent(AkEvent'Objects.Play_Object_Impact');
	super.RigidBodyCollision(HitComponent, OtherComponent, Collision, ContactIndex);
	//return;	
}

simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	SetSwitch('Object_Type', AkObjectType);
	SetSwitch('Surface', 'Concrete');
	SetRTPCValue('Impulse_Value', float(Min(int(Abs(Velocity.Z)), 100)));
	PlayAkEvent(AkEvent'Objects.Play_Object_Impact');
	super.HitWall(HitNormal, Wall, WallComp);
	//return;	
}

defaultproperties
{
	// Reference: DynamicLightEnvironmentComponent'UTGame.Default__UTGib_VehiclePiece.GibLightEnvironmentComp'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'GibLightEnvironmentComp'
	// Archetype: DynamicLightEnvironmentComponent'UTGame.Default__UTGib_Vehicle.GibLightEnvironmentComp'
	begin object name="GibLightEnvironmentComp"
	end object
	GibLightEnvironment=GibLightEnvironmentComp
	Components[0]=GibLightEnvironmentComp
}