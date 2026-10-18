class HaloAnimBlendByJumpType extends UDKAnimBlendBase
	native;

var float LandBlend;
var float LandBlendDelay;
var const int CachedJumpType;
var const float LandBlendDelayTimer;

// Export UHaloAnimBlendByJumpType::execOnChangeJumpType(FFrame&, void* const)
native function OnChangeJumpType(int JumpType, bool PlayJumpAnim);

defaultproperties
{
	LandBlend=0.1000000
	LandBlendDelay=0.1500000
	bPlayActiveChild=true
	Children[0]=(Name="None",Anim=none,Weight=1.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[1]=(Name="Single",Anim=none,Weight=0.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[2]=(Name="Double",Anim=none,Weight=0.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[3]=(Name="Ledge",Anim=none,Weight=0.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	bFixNumChildren=true
}