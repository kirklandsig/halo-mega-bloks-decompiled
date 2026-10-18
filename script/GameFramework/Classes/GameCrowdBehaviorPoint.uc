class GameCrowdBehaviorPoint extends GameCrowdInteractionPoint
	native
	config(Crowd)
	placeable;

var config float RadiusOfBehaviorEvent;
var config float DurationOfBehaviorEvent;
var GameCrowdAgentBehavior.ECrowdBehaviorEvent EventType;
var bool bRequireLOS;
var Actor Initiator;

event PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	// End:0x4A
	if(RadiusOfBehaviorEvent > 0.0000000)
	{
		CylinderComponent.SetCylinderSize(RadiusOfBehaviorEvent, 200.0000000);
	}
	// End:0x74
	if(DurationOfBehaviorEvent > 0.0000000)
	{
		SetTimer(DurationOfBehaviorEvent, false, 'DestroySelf');
	}
	//return;	
}

function DestroySelf()
{
	LifeSpan = 0.0010000;
	//return;	
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	local GameCrowdAgent Agent;

	Agent = GameCrowdAgent(Other);
	// End:0x9E
	if(Agent != none)
	{
		// End:0x9E
		if(bRequireLOS! || FastTrace(Other.Location, Location))
		{
			Agent.HandleBehaviorEvent(EventType, Initiator, false, true);
		}
	}
	super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
	//return;	
}

defaultproperties
{
	// Reference: CylinderComponent'GameFramework.Default__GameCrowdBehaviorPoint.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'GameFramework.Default__GameCrowdInteractionPoint.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=200.0000000
		CollisionRadius=512.0000000
		bDrawBoundingBox=true
		ReplacementPrimitive=none
		HiddenGame=false
		CollideActors=true
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	Components[1]=none
	bNoDelete=false
	bCollideActors=true
	CollisionComponent=CollisionCylinder
}