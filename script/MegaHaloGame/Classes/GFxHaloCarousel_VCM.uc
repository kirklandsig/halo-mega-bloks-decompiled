class GFxHaloCarousel_VCM extends GFxHaloCarousel within GFxMoviePlayer;

var array<GFxObject> ItemEquippedIcons;

function Init(int NumNodes, int SelectedIndex, string ClipIdentifier, array<Vector2D> Positions, optional array<float> Scales, optional array<float> Alphas)
{
	local int I;

	super.Init(NumNodes, SelectedIndex, ClipIdentifier, Positions, Scales, Alphas);
	I = 0;
	J0x4D:

	// End:0xB3 [Loop If]
	if(I < NumNodes)
	{
		ItemEquippedIcons.AddItem(NodeClips[I].GetObject("equipped"));
		I++;
		// [Loop Continue]
		goto J0x4D;
	}
	//return;	
}

function SetItemsState(int Index, bool bUnlocked, bool bEquipped)
{
	local array<GFxObject> mcs;
	local GFxObject currentMC;

	mcs = GetItemsOfIndex(Index);
	// End:0x11B
	foreach mcs(currentMC)
	{
		// End:0xBB
		if(currentMC == NodeClips[SelectedNodeIndex])
		{
			// End:0x8E
			if(bUnlocked)
			{
				currentMC.GotoAndStop("selected");				
			}
			else
			{
				currentMC.GotoAndStop("lockedSel");
			}			
		}
		else
		{
			// End:0xF3
			if(bUnlocked)
			{
				currentMC.GotoAndStop("default");				
			}
			else
			{
				currentMC.GotoAndStop("locked");
			}
		}		
	}	
	mcs = GetItemsEquippedIconsOfIndex(Index);
	// End:0x17A
	foreach mcs(currentMC)
	{
		currentMC.SetVisible(bEquipped);		
	}	
	//return;	
}

function array<GFxObject> GetItemsEquippedIconsOfIndex(int Index)
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
			returnArray.AddItem(ItemEquippedIcons[I]);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return returnArray;
	//return ReturnValue;	
}
