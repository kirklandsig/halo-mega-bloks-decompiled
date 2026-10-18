class HaloAnimNodeBlendDirectional extends AnimNodeBlendBase
	native;

var float RunSpeed;
var float MoveSpeedThreshold;
var float BlendTime;
var float StartBlendDegreeThreshold;
var float BackWeight;
var float DesiredBackWeight;
var Vector RelMoveVel;
var float FwdAngle;
var float BackAngle;

defaultproperties
{
	RunSpeed=600.0000000
	MoveSpeedThreshold=200.0000000
	BlendTime=0.2500000
	StartBlendDegreeThreshold=10.0000000
	Children[0]=(Name="Forward",Anim=none,Weight=1.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[1]=(Name="ForwardLeft",Anim=none,Weight=0.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[2]=(Name="ForwardRight",Anim=none,Weight=0.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[3]=(Name="back",Anim=none,Weight=0.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[4]=(Name="BackLeft",Anim=none,Weight=0.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[5]=(Name="BackRight",Anim=none,Weight=0.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	bFixNumChildren=true
}