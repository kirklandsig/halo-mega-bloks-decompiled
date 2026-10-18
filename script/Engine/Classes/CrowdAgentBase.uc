class CrowdAgentBase extends Actor
	abstract
	native
	notplaceable
	implements(Interface_NavigationHandle);

var private native const noexport Pointer VfTable_IInterface_NavigationHandle;

event NotifyPathChanged()
{
	//return;	
}

defaultproperties
{
	CollisionType=ECollisionType.COLLIDE_CustomDefault
}