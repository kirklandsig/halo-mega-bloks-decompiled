class UDKAnimBlendByPhysics extends UDKAnimBlendBase
	native;

var int PhysicsMap[12];
var int LastPhysics;
var float LandBlendDelay;
var int PendingChildIndex;
var float PendingTimeToGo;
var float QuickLandTimeThreshold;
var float QuickLandBlendDelay;

defaultproperties
{
	PhysicsMap[0]=-1
	PhysicsMap[1]=-1
	PhysicsMap[2]=-1
	PhysicsMap[3]=-1
	PhysicsMap[4]=-1
	PhysicsMap[5]=-1
	PhysicsMap[6]=-1
	PhysicsMap[7]=-1
	PhysicsMap[8]=-1
	PhysicsMap[9]=-1
	PhysicsMap[10]=-1
	PhysicsMap[11]=-1
	Children[0]=(Name="PHYS_Walking",Anim=none,Weight=1.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[1]=(Name="PHYS_Falling",Anim=none,Weight=0.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[2]=(Name="PHYS_Swimming",Anim=none,Weight=0.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
}