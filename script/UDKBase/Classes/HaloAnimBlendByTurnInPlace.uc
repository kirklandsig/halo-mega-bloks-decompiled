class HaloAnimBlendByTurnInPlace extends UDKAnimBlendByTurnInPlace
	native;

defaultproperties
{
	bPlayActiveChild=true
	Children[0]=(Name="Left",Anim=none,Weight=0.3000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[1]=(Name="Idle",Anim=none,Weight=0.4000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[2]=(Name="Right",Anim=none,Weight=0.3000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
}