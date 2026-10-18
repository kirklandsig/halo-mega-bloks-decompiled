class GFxHaloCarousel_BCM extends GFxHaloCarousel within GFxMoviePlayer;

var array<GFxObject> ItemCountTextfields;

function Init(int NumNodes, int SelectedIndex, string ClipIdentifier, array<Vector2D> Positions, optional array<float> Scales, optional array<float> Alphas)
{
	local int I;

	super.Init(NumNodes, SelectedIndex, ClipIdentifier, Positions, Scales, Alphas);
	I = 0;
	J0x4D:

	// End:0xAD [Loop If]
	if(I < NumNodes)
	{
		ItemCountTextfields.AddItem(NodeClips[I].GetObject("tf"));
		I++;
		// [Loop Continue]
		goto J0x4D;
	}
	//return;	
}

function SetItemsState(int Index, int Count)
{
	local array<GFxObject> mcs;
	local GFxObject currentMC;

	mcs = GetItemsOfIndex(Index);
	// End:0xAA
	foreach mcs(currentMC)
	{
		// End:0x81
		if(currentMC == NodeClips[SelectedNodeIndex])
		{
			currentMC.GotoAndStop("selected");			
		}
		else
		{
			currentMC.GotoAndStop("default");
		}		
	}	
	mcs = GetItemsCountsOfIndex(Index);
	// End:0x110
	foreach mcs(currentMC)
	{
		currentMC.SetText("x" $ string(Count));		
	}	
	//return;	
}

function array<GFxObject> GetItemsCountsOfIndex(int Index)
{
	local int I;
	local array<GFxObject> returnArray;

	I = 0;
	J0x0B:

	// End:0x71 [Loop If]
	if(I < NodeCount)
	{
		// End:0x63
		if(ItemOrder[I] == Index)
		{
			returnArray.AddItem(ItemCountTextfields[I]);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return returnArray;
	//return ReturnValue;	
}
