class Trigger extends Actor
	native
	placeable;

struct CheckpointRecord
{
	var bool bCollideActors;

	structdefaultproperties
	{
		bCollideActors=false
	}
};

var const editconst export editinline CylinderComponent CylinderComponent;
var bool bRecentlyTriggered;
var float AITriggerDelay;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	//return;	
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	// End:0x22
	if(FindEventsOfClass(Class'Engine.SeqEvent_Touch'))
	{
		NotifyTriggered();
	}
	//return;	
}

function NotifyTriggered()
{
	bRecentlyTriggered = true;
	SetTimer(AITriggerDelay, false, 'UnTrigger');
	//return;	
}

function UnTrigger()
{
	bRecentlyTriggered = false;
	//return;	
}

simulated function bool StopsProjectile(Projectile P)
{
	return bBlockActors;
	//return ReturnValue;	
}

function bool ShouldSaveForCheckpoint()
{
	return bStatic || bNoDelete;
	//return ReturnValue;	
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
	Record.bCollideActors = bCollideActors;
	//return;	
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
	SetCollision(Record.bCollideActors, bBlockActors, bIgnoreEncroachers);
	ForceNetRelevant();
	//return;	
}

defaultproperties
{
	// Reference: CylinderComponent'Engine.Default__Trigger.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	begin object name="CollisionCylinder" class=Engine.CylinderComponent
		CollisionHeight=40.0000000
		CollisionRadius=40.0000000
		bAlwaysRenderIfSelected=true
		ReplacementPrimitive=none
		CollideActors=true
		BlockZeroExtent=false
	end object
	CylinderComponent=CollisionCylinder
	AITriggerDelay=2.0000000
	// Reference: SpriteComponent'Engine.Default__Trigger.Sprite'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'Sprite'
	begin object name="Sprite" class=Engine.SpriteComponent
		ReplacementPrimitive=none
		AlwaysLoadOnClient=false
		AlwaysLoadOnServer=false
	end object
	Components[0]=Sprite
	Components[1]=CollisionCylinder
	CollisionType=ECollisionType.COLLIDE_CustomDefault
	bHidden=true
	bCollideActors=true
	bProjTarget=true
	CollisionComponent=CollisionCylinder
	SupportedEvents[0]=Class'Engine.SeqEvent_Touch'
	SupportedEvents[1]=Class'Engine.SeqEvent_Destroyed'
	SupportedEvents[2]=Class'Engine.SeqEvent_TakeDamage'
	SupportedEvents[3]=Class'Engine.SeqEvent_HitWall'
	SupportedEvents[4]=Class'Engine.SeqEvent_AnimNotify'
	SupportedEvents[5]=Class'Engine.SeqEvent_MobileTouch'
	SupportedEvents[6]=Class'Engine.SeqEvent_Used'
}