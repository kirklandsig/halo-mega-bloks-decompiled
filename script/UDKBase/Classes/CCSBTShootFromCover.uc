class CCSBTShootFromCover extends GripBTNode
	native;

var int FireBurstPerShot;
var float DelayBetweenBursts;

defaultproperties
{
	FireBurstPerShot=1
	DelayBetweenBursts=0.4000000
	NodeDescription="Shoot Selected Target from Cover. Re-orient if necessary. Succeed after given number of fire burst is taken. If in Stand Cover, fails if there is no Line of Fire to the Target."
	DefaultTitle="ShootFromCover"
}