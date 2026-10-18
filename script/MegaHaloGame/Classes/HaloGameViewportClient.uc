class HaloGameViewportClient extends UTGameViewportClient within Engine
	transient
	config(Game);

var string SplitscreenBuckets[6];
var bool ForceSetBucket;
var bool IsSplitscreenEnabled;

exec function EnableSplitscreen()
{
	IsSplitscreenEnabled = true;
	//return;	
}

exec function DisableSplitscreen()
{
	IsSplitscreenEnabled = false;
	//return;	
}

event bool Init(out string OutError)
{
	ForceSetBucket = true;
	return super(GameViewportClient).Init(OutError);
	//return ReturnValue;	
}

function UpdateActiveSplitscreenType()
{
	local GameViewportClient.ESplitScreenType SplitType;

	SplitType = ActiveSplitscreenType;
	// End:0x30
	if(IsSplitscreenEnabled == true)
	{
		super.UpdateActiveSplitscreenType();		
	}
	else
	{
		ActiveSplitscreenType = 0;
	}
	// End:0xAE
	if((int(SplitType) != int(ActiveSplitscreenType)) || ForceSetBucket == true)
	{
		ForceSetBucket = false;		
		ConsoleCommand("scale bucket " $ SplitscreenBuckets[int(ActiveSplitscreenType)]);
	}
	//return;	
}

defaultproperties
{
	SplitscreenBuckets[0]="Bucket1P"
	SplitscreenBuckets[1]="Bucket2P"
	SplitscreenBuckets[2]="Bucket2P"
	SplitscreenBuckets[3]="Bucket2P"
	SplitscreenBuckets[4]="Bucket2P"
	SplitscreenBuckets[5]="Bucket2P"
	IsSplitscreenEnabled=true
	SplitscreenInfo[0]=(PlayerData=((SizeX=1.0000000,SizeY=1.0000000,OriginX=0.0000000,OriginY=0.0000000)))
	SplitscreenInfo[1]=(PlayerData=((SizeX=0.7500000,SizeY=0.5000000,OriginX=0.1250000,OriginY=0.0000000),(SizeX=0.7500000,SizeY=0.5000000,OriginX=0.1250000,OriginY=0.5000000)))
	SplitscreenInfo[2]=(PlayerData=((SizeX=0.5000000,SizeY=1.0000000,OriginX=0.0000000,OriginY=0.0000000),(SizeX=0.5000000,SizeY=1.0000000,OriginX=0.5000000,OriginY=0.0000000)))
	SplitscreenInfo[3]=(PlayerData=((SizeX=1.0000000,SizeY=0.5000000,OriginX=0.0000000,OriginY=0.0000000),(SizeX=0.5000000,SizeY=0.5000000,OriginX=0.0000000,OriginY=0.5000000),(SizeX=0.5000000,SizeY=0.5000000,OriginX=0.5000000,OriginY=0.5000000)))
	SplitscreenInfo[4]=(PlayerData=((SizeX=0.5000000,SizeY=0.5000000,OriginX=0.0000000,OriginY=0.0000000),(SizeX=0.5000000,SizeY=0.5000000,OriginX=0.5000000,OriginY=0.0000000),(SizeX=1.0000000,SizeY=0.5000000,OriginX=0.0000000,OriginY=0.5000000)))
	SplitscreenInfo[5]=(PlayerData=((SizeX=0.5000000,SizeY=0.5000000,OriginX=0.0000000,OriginY=0.0000000),(SizeX=0.5000000,SizeY=0.5000000,OriginX=0.5000000,OriginY=0.0000000),(SizeX=0.5000000,SizeY=0.5000000,OriginX=0.0000000,OriginY=0.5000000),(SizeX=0.5000000,SizeY=0.5000000,OriginX=0.5000000,OriginY=0.5000000)))
}