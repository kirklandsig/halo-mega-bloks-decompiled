class Note extends Actor
	native
	placeable;

defaultproperties
{
	Components[0]=none
	Components[1]=none
	CollisionType=COLLIDE_CustomDefault
	bStatic=true
	bHidden=true
	bNoDelete=true
	bRouteBeginPlayEvenIfStatic=false
	bMovable=false
}