class HaloAnimBlendByJumpLand extends AnimNodeBlendList
	native;

var float JumpBlendInTime;
var float FallingBlendInTime;
var float JumpToPrelandBlendInTime;
var float FallingToPrelandBlendInTime;
var float LandBlendInTime;
var float EarlyLandBlendInTime;
var float PreLandTime;

// Export UHaloAnimBlendByJumpLand::execPlayJumpAnim(FFrame&, void* const)
native function PlayJumpAnim();

defaultproperties
{
	FallingToPrelandBlendInTime=0.1000000
	EarlyLandBlendInTime=0.1000000
	PreLandTime=0.2000000
	bPlayActiveChild=true
	Children[0]=(Name="Jump",Anim=none,Weight=1.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[1]=(Name="Fall",Anim=none,Weight=0.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[2]=(Name="PreLand",Anim=none,Weight=0.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[3]=(Name="Land",Anim=none,Weight=0.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	bFixNumChildren=true
}