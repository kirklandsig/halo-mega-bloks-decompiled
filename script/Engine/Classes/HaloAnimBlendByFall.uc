class HaloAnimBlendByFall extends AnimNodeBlendList
	native;

var float UpDownBlendThreshold;

defaultproperties
{
	UpDownBlendThreshold=500.0000000
	bPlayActiveChild=true
	Children[0]=(Name="Down",Anim=none,Weight=1.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[1]=(Name="Up",Anim=none,Weight=0.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	bFixNumChildren=true
}