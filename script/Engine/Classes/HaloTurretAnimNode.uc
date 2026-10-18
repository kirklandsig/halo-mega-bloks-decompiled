class HaloTurretAnimNode extends AnimNodeBlendList
	native;

var float AnimPositionSlider;
var float MinYaw;
var float MaxYaw;
var float MinPitch;
var float MaxPitch;

// Export UHaloTurretAnimNode::execSetRotation(FFrame&, void* const)
native final function SetRotation(Rotator Rot);

defaultproperties
{
	MinYaw=-90.0000000
	MaxYaw=90.0000000
	MinPitch=-45.0000000
	MaxPitch=45.0000000
	Children[0]=(Name="Up",Anim=none,Weight=1.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[1]=(Name="Center",Anim=none,Weight=0.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[2]=(Name="Down",Anim=none,Weight=0.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	bFixNumChildren=true
}