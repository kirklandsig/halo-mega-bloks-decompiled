class GwNavObstacleComponent extends ActorComponent
	native
	collapsecategories;

var Vector LocationOffset;
var native Pointer GwNavObstacle;

defaultproperties
{
	TickGroup=ETickingGroup.TG_PostAsyncWork
}