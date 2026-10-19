class GFxHaloCarousel extends GFxObject within GFxMoviePlayer;

var bool bInitialized;
var GFxObject ItemContainer;
var int NodeCount;
var int SelectedNodeIndex;
var array<GFxObject> NodeClips;
var int ItemCount;
var int SelectedItemIndex;
var array<int> ItemOrder;
var array<GFxObject> ItemImageLoaders;

function Init(int NumNodes, int SelectedIndex, string ClipIdentifier, array<Vector2D> Positions, optional array<float> Scales, optional array<float> Alphas)
{
	local int I;
	local GFxObject MC;

	// End:0x2D4
	if(!bInitialized)
	{
		ItemContainer = GetObject("itemContainer");
		NodeCount = NumNodes;
		SelectedNodeIndex = SelectedIndex;
		I = 0;
		J0x66:

		// End:0x2C5 [Loop If]
		if(I < NodeCount)
		{
			MC = ItemContainer.AttachMovie(ClipIdentifier, ClipIdentifier $ string(I));
			// End:0x171
			if(Positions.Length > I)
			{
				MC.SetFloat("_x", Positions[I].X);
				MC.SetFloat("_y", Positions[I].Y);
			}
			// End:0x1FF
			if(Scales.Length > I)
			{
				MC.SetFloat("_xscale", Scales[I]);
				MC.SetFloat("_yscale", Scales[I]);
			}
			// End:0x251
			if(Alphas.Length > I)
			{
				MC.SetFloat("_alpha", Alphas[I]);
			}
			NodeClips.AddItem(MC);
			ItemImageLoaders.AddItem(NodeClips[I].GetObject("image"));
			ItemOrder.AddItem(-1);
			I++;
			// [Loop Continue]
			goto J0x66;
		}
		bInitialized = true;		
	}
	else
	{
		WarnInternal("GFxCarousels can only be initialized once until more functionality is added to the class");
	}
	//return;	
}

function SetItemCount(int NumItems)
{
	ItemCount = NumItems;
	//return;	
}

function ResetItemPositions()
{
	JumpToIndex(0);
	//return;	
}

function JumpToIndex(int Index)
{
	local int I, distFromSelectedNode, NewIndex;

	// End:0x11B
	if((Index >= 0) && Index < ItemCount)
	{
		SelectedItemIndex = Index;
		I = 0;
		J0x46:

		// End:0x118 [Loop If]
		if(I < NodeCount)
		{
			distFromSelectedNode = I - SelectedNodeIndex;
			NewIndex = SelectedItemIndex + distFromSelectedNode;
			J0x99:

			// End:0xBF [Loop If]
			if(NewIndex < 0)
			{
				NewIndex += ItemCount;
				// [Loop Continue]
				goto J0x99;
			}
			J0xBF:

			// End:0xED [Loop If]
			if(NewIndex >= ItemCount)
			{
				NewIndex -= ItemCount;
				// [Loop Continue]
				goto J0xBF;
			}
			ItemOrder[I] = NewIndex;
			I++;
			// [Loop Continue]
			goto J0x46;
		}		
	}
	else
	{
		WarnInternal("Trying to select an invalid carousel index");
	}
	//return;	
}

function array<GFxObject> GetItemsOfIndex(int Index)
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
			returnArray.AddItem(NodeClips[I]);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return returnArray;
	//return ReturnValue;	
}

function int GetSelectedItemIndex()
{
	return ItemOrder[0];
	//return ReturnValue;	
}

function array<GFxObject> GetItemsImageLoadersOfIndex(int Index)
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
			returnArray.AddItem(ItemImageLoaders[I]);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return returnArray;
	//return ReturnValue;	
}

function SetItemsImage(int Index, string ImgPath)
{
	local array<GFxObject> imageLoaders;
	local GFxObject currentLoader;

	imageLoaders = GetItemsImageLoadersOfIndex(Index);
	// End:0x70
	foreach imageLoaders(currentLoader)
	{
		currentLoader.SetString("source", "img://" $ ImgPath);		
	}	
	//return;	
}
