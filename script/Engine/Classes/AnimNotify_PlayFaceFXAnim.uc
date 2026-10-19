class AnimNotify_PlayFaceFXAnim extends AnimNotify_Scripted
	editinlinenew
	collapsecategories;

var FaceFXAnimSet FaceFXAnimSetRef;
var string GroupName;
var string AnimName;
var SoundCue SoundCueToPlay;
var AkEvent AkEventToPlay;
var bool bOverridePlayingAnim;
var float PlayFrequency;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	// End:0x28
	if(PlayFrequency < 1.0000000)
	{
		// End:0x25
		if(FRand() > PlayFrequency)
		{
			return;
		}		
	}
	else
	{
		// End:0x11C
		if(PlayFrequency > 1.0000000)
		{
			LogInternal((((((("Play FaceFX animation from notify" @ string(AnimSeqInstigator.AnimSeqName)) @ "for") @ string(Owner)) @ "GroupName:") @ GroupName) @ "AnimName:") @ AnimName);
			LogInternal(" PlayFrequency > 1.0 is useless. Chance to play valid range is from 0.0 to 1.0.");
		}
	}
	// End:0x286
	if(Owner != none)
	{
		// End:0x286
		if(Owner.CanActorPlayFaceFXAnim())
		{
			// End:0x286
			if(bOverridePlayingAnim || !Owner.IsActorPlayingFaceFXAnim())
			{
				// End:0x286
				if(Owner.PlayActorFaceFXAnim(FaceFXAnimSetRef, GroupName, AnimName, SoundCueToPlay, AkEventToPlay) == false)
				{
					LogInternal((((string(AnimSeqInstigator.AnimSeq.Outer) @ "(") @ string(AnimSeqInstigator.AnimSeqName)) @ ")") @ " - PlayFaceFXAnim notifier failed. Verify if this notifier is valid.", 'DevFaceFX');
				}
			}
		}
	}
	//return;	
}

defaultproperties
{
	bOverridePlayingAnim=true
	PlayFrequency=1.0000000
}