class AnimNodeRandom extends AnimNodeBlendList
	native;

struct native RandomAnimInfo
{
	var float Chance;
	var byte LoopCountMin;
	var byte LoopCountMax;
	var float BlendInTime;
	var Vector2D PlayRateRange;
	var bool bStillFrame;
	var transient byte LoopCount;
	var transient float LastPosition;

	structdefaultproperties
	{
		Chance=1.0000000
		LoopCountMin=0
		LoopCountMax=0
		BlendInTime=0.2500000
		PlayRateRange=(X=1.0000000,Y=1.0000000)
		bStillFrame=false
		LoopCount=0
		LastPosition=0.0000000
	}
};

var editfixedsize editinline array<editinline RandomAnimInfo> RandomInfo;
var bool HoldOnLastFrame;
var transient bool bPickedPendingChildIndex;
var transient AnimNodeSequence PlayingSeqNode;
var transient int PendingChildIndex;

defaultproperties
{
	PendingChildIndex=-1
	ActiveChildIndex=-1
}