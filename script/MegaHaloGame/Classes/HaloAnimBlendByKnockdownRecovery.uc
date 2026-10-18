class HaloAnimBlendByKnockdownRecovery extends UDKAnimBlendBase;

function SetActiveChildFromForwardVector(Vector Forward)
{
	local int I;
	local AnimNodeSequence Seq;

	I = ((Forward.Z < float(0)) ? 1 : 2);
	SetActiveChild(I, 0.0000000);
	// End:0xE1
	if((ActiveChildIndex >= 0) && ActiveChildIndex < Children.Length)
	{
		Seq = AnimNodeSequence(Children[ActiveChildIndex].Anim);
		// End:0xE1
		if(Seq != none)
		{
			Seq.SetPosition(0.0000000, false);
		}
	}
	//return;	
}

function PlayActiveChild()
{
	// End:0x94
	if((ActiveChildIndex >= 0) && ActiveChildIndex < Children.Length)
	{
		// End:0x94
		if(Children[ActiveChildIndex].Anim != none)
		{
			Children[ActiveChildIndex].Anim.PlayAnim();
		}
	}
	//return;	
}

defaultproperties
{
	Children[0]=(Name="Pass Thru",Anim=none,Weight=1.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[1]=(Name="From Back",Anim=none,Weight=0.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	Children[2]=(Name="From Belly",Anim=none,Weight=0.0000000,BlendWeight=0.0000000,bMirrorSkeleton=false,bIsAdditive=false)
	bFixNumChildren=true
	NodeName="KnockdownRecovery"
}