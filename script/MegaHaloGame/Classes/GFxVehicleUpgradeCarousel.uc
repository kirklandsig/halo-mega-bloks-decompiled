class GFxVehicleUpgradeCarousel extends GFxHaloCarousel within GFxMoviePlayer;

struct VUCarouselItem
{
	var GFxObject NameTextfield;
	var GFxObject ImageLoader;

	structdefaultproperties
	{
		NameTextfield=none
		ImageLoader=none
	}
};

var GFxObject SelectedItemTextfield;
var array<VUCarouselItem> VUCarouselItems;

function Init(int NumNodes, int SelectedIndex, string ClipIdentifier, array<Vector2D> Positions, optional array<float> Scales, optional array<float> Alphas)
{
	local int I;

	super.Init(NumNodes, SelectedIndex, ClipIdentifier, Positions, Scales, Alphas);
	I = 0;
	J0x4D:

	// End:0x131 [Loop If]
	if(I < NumNodes)
	{
		VUCarouselItems.Add(1);
		VUCarouselItems[I].NameTextfield = NodeClips[I].GetObject("itemName");
		VUCarouselItems[I].ImageLoader = NodeClips[I].GetObject("image");
		I++;
		// [Loop Continue]
		goto J0x4D;
	}
	SelectedItemTextfield = GetObject("itemName");
	//return;	
}

function SetItemData(array<HVCCInfo> ItemInfo)
{
	local int I, currentItemIndex;

	I = 0;
	J0x0B:

	// End:0x206 [Loop If]
	if(I < NodeCount)
	{
		currentItemIndex = ItemOrder[I];
		// End:0x9F
		if(!ItemInfo[currentItemIndex].Unlocked)
		{
			NodeClips[I].GotoAndStop("locked");			
		}
		else
		{
			// End:0xEC
			if(I == SelectedNodeIndex)
			{
				NodeClips[I].GotoAndStop("selected");				
			}
			else
			{
				NodeClips[I].GotoAndStop("default");
			}
		}
		VUCarouselItems[I].NameTextfield.SetText(string(ItemInfo[currentItemIndex].Name));
		VUCarouselItems[I].ImageLoader.SetString("source", "img://" $ ItemInfo[currentItemIndex].IconPkgPath);
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	SelectedItemTextfield.SetText(string(ItemInfo[SelectedItemIndex].Name));
	//return;	
}

function ShowFullCarousel(bool bShow)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0xA7 [Loop If]
	if(I < NodeCount)
	{
		// End:0x66
		if(I == SelectedNodeIndex)
		{
			NodeClips[I].SetVisible(true);			
		}
		else
		{
			NodeClips[I].SetVisible(bShow);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}
