class CrowdAgentBase extends Actor
	abstract
	native
	notplaceable
	implements(Interface_NavigationHandle)
	dependson(CoverLink);


event NotifyPathChanged()
{
	//return;	
}

defaultproperties
{
	CollisionType=COLLIDE_CustomDefault
}