class GFxHaloConstructionStrip extends GFxObject within GFxMoviePlayer;

struct ConstructionStripItem
{
	var GFxObject Clip;
	var GFxAttachedUILoader Image;
	var GFxObject Text;
	var GFxObject ActionIcon;
	var bool bUnlocked;

	structdefaultproperties
	{
		Clip=none
		Image=none
		Text=none
		ActionIcon=none
		bUnlocked=true
	}
};

var bool bInitialized;
var bool bShowActionIcon;
var bool bSelectionIsSliding;
var bool bContainerIsSliding;
var float SlideSpeed;
var WorldInfo ThisWorld;
var array<ConstructionStripItem> ConstructionStripItems;
var string ItemClipIdentifier;
var Vector2D NodeOffset;
var int TotalNodes;
var int VisibleNodes;
var GFxObject SelectionBox;
var GFxObject SelectionHighlight;
var int SelectionIndex;
var Vector2D SelectionStartPosition;
var Vector2D SelectionGoalPosition;
var float SelectionEndTimer;
var GFxObject ItemContainer;
var GFxObject ItemArrow_L;
var GFxObject ItemArrow_R;
var int ContainerIndex;
var Vector2D ContainerStartPosition;
var Vector2D ContainerGoalPosition;
var float ContainerEndTimer;
var int ActiveSelectedIndex;
var float SlideTime;

function Init(string ClipIdentifier)
{
	// End:0xED
	if(!bInitialized)
	{
		SelectionBox = GetObject("selectionBox");
		// End:0x76
		if(SelectionBox != none)
		{
			SelectionHighlight = SelectionBox.GetObject("highlight");
		}
		ItemContainer = GetObject("itemContainer");
		ItemArrow_L = GetObject("itemArrow_L");
		ItemArrow_R = GetObject("itemArrow_R");
		bInitialized = true;		
	}
	else
	{
		Reset();
	}
	ThisWorld = Outer.GetPC().WorldInfo;
	ItemClipIdentifier = ClipIdentifier;
	//return;	
}

function NodeSettings(int TotalNodeCount, int VisibleNodeCount, Vector2D NodeStep)
{
	local int I, NodeCount;
	local GFxObject RootMC, tempMC;

	TotalNodes = TotalNodeCount;
	VisibleNodes = VisibleNodeCount;
	NodeOffset = NodeStep;
	NodeCount = Max(TotalNodeCount, ConstructionStripItems.Length);
	I = 0;
	J0x63:

	// End:0x372 [Loop If]
	if(I < NodeCount)
	{
		// End:0x292
		if(I >= ConstructionStripItems.Length)
		{
			ConstructionStripItems.Add(1);
			RootMC = ItemContainer.AttachMovie("CS_Item", "CS_Item" $ string(I));
			ConstructionStripItems[I].Clip = RootMC;
			tempMC = RootMC.GetObject("image");
			// End:0x1B8
			if(tempMC != none)
			{
				ConstructionStripItems[I].Image = GFxAttachedUILoader(tempMC.GetObject("loader", Class'MegaHaloGame.GFxAttachedUILoader'));
			}
			tempMC = RootMC.GetObject("count");
			// End:0x243
			if(tempMC != none)
			{
				ConstructionStripItems[I].Text = tempMC.GetObject("tf");
			}
			ConstructionStripItems[I].ActionIcon = RootMC.GetObject("action");
		}
		ConstructionStripItems[I].Clip.SetFloat("_x", NodeOffset.X * float(I));
		ConstructionStripItems[I].Clip.SetFloat("_y", NodeOffset.Y * float(I));
		I++;
		// [Loop Continue]
		goto J0x63;
	}
	//return;	
}

function Reset()
{
	SelectionIndex = -1;
	ContainerIndex = -1;
	ActiveSelectedIndex = -1;
	JumpContainer(0);
	JumpSelection(0);
	//return;	
}

function Tick(float DeltaTime)
{
	local float slideTimeRemaining, sinModifier, pos;

	// End:0x284
	if(bSelectionIsSliding)
	{
		slideTimeRemaining = SelectionEndTimer - ThisWorld.TimeSeconds;
		// End:0x1BA
		if(slideTimeRemaining > 0.0000000)
		{
			sinModifier = Sin((3.1415927 / float(2)) * (float(1) - (slideTimeRemaining / SlideTime)));
			pos = SelectionStartPosition.X + ((SelectionGoalPosition.X - SelectionStartPosition.X) * sinModifier);
			SelectionBox.SetFloat("_x", pos);
			pos = SelectionStartPosition.Y + ((SelectionGoalPosition.Y - SelectionStartPosition.Y) * sinModifier);
			SelectionBox.SetFloat("_y", pos);			
		}
		else
		{
			SelectionBox.SetFloat("_x", SelectionGoalPosition.X);
			SelectionBox.SetFloat("_y", SelectionGoalPosition.Y);
			bSelectionIsSliding = false;
			SelectionBox.GotoAndPlayI(2);
			ActivateSelection(SelectionIndex + ContainerIndex, true);
		}
	}
	// End:0x508
	if(bContainerIsSliding)
	{
		slideTimeRemaining = ContainerEndTimer - ThisWorld.TimeSeconds;
		// End:0x43E
		if(slideTimeRemaining > 0.0000000)
		{
			sinModifier = Sin((3.1415927 / float(2)) * (float(1) - (slideTimeRemaining / SlideTime)));
			pos = ContainerStartPosition.X + ((ContainerGoalPosition.X - ContainerStartPosition.X) * sinModifier);
			ItemContainer.SetFloat("_x", pos);
			pos = ContainerStartPosition.Y + ((ContainerGoalPosition.Y - ContainerStartPosition.Y) * sinModifier);
			ItemContainer.SetFloat("_y", pos);			
		}
		else
		{
			ItemContainer.SetFloat("_x", ContainerGoalPosition.X);
			ItemContainer.SetFloat("_y", ContainerGoalPosition.Y);
			bContainerIsSliding = false;
			ItemContainer.GotoAndPlayI(2);
			ActivateSelection(SelectionIndex + ContainerIndex, true);
		}
	}
	//return;	
}

function MoveToIndex(int Index, optional bool doSlide = true)
{
	local int minindex, maxIndex, I;

	minindex = ContainerIndex;
	maxIndex = (VisibleNodes + minindex) - 1;
	// End:0x89
	if(Index < minindex)
	{
		// End:0x73
		if(doSlide)
		{
			SlideContainer(Index);			
		}
		else
		{
			JumpContainer(Index);
		}		
	}
	else
	{
		// End:0x102
		if(Index > maxIndex)
		{
			// End:0xD9
			if(doSlide)
			{
				SlideContainer((Index - maxIndex) + ContainerIndex);				
			}
			else
			{
				JumpContainer((Index - maxIndex) + ContainerIndex);
			}
		}
	}
	// End:0x130
	if(doSlide)
	{
		SlideSelection(Index - ContainerIndex);		
	}
	else
	{
		JumpSelection(Index - ContainerIndex);
	}
	minindex = ContainerIndex;
	maxIndex = (VisibleNodes + minindex) - 1;
	I = 0;
	J0x18D:

	// End:0x21C [Loop If]
	if(I < ConstructionStripItems.Length)
	{
		ConstructionStripItems[I].Clip.SetVisible((I >= minindex) && I <= maxIndex);
		I++;
		// [Loop Continue]
		goto J0x18D;
	}
	ItemArrow_L.SetVisible(minindex > 0);
	ItemArrow_R.SetVisible(maxIndex < (TotalNodes - 1));
	//return;	
}

function JumpContainer(int Index)
{
	// End:0x108
	if(ContainerIndex != Index)
	{
		ContainerIndex = Index;
		ContainerGoalPosition = Multiply_Vector2DFloat(NodeOffset, float(-Index));
		ItemContainer.SetFloat("_x", ContainerGoalPosition.X);
		ItemContainer.SetFloat("_y", ContainerGoalPosition.Y);
		bContainerIsSliding = false;
		DeactivateSelection();
		ActivateSelection(SelectionIndex + ContainerIndex);
	}
	//return;	
}

function SlideContainer(int Index)
{
	// End:0x11E
	if(ContainerIndex != Index)
	{
		ContainerIndex = Index;
		ContainerGoalPosition = Multiply_Vector2DFloat(NodeOffset, float(-Index));
		ContainerStartPosition.X = ItemContainer.GetFloat("_x");
		ContainerStartPosition.Y = ItemContainer.GetFloat("_y");
		ContainerEndTimer = ThisWorld.TimeSeconds + SlideTime;
		bContainerIsSliding = true;
		DeactivateSelection(true);
	}
	//return;	
}

function JumpSelection(int Index)
{
	// End:0x106
	if(SelectionIndex != Index)
	{
		SelectionIndex = Index;
		SelectionGoalPosition = Multiply_Vector2DFloat(NodeOffset, float(Index));
		SelectionBox.SetFloat("_x", SelectionGoalPosition.X);
		SelectionBox.SetFloat("_y", SelectionGoalPosition.Y);
		bSelectionIsSliding = false;
		DeactivateSelection();
		ActivateSelection(SelectionIndex + ContainerIndex);
	}
	//return;	
}

function SlideSelection(int Index)
{
	// End:0x11C
	if(SelectionIndex != Index)
	{
		SelectionIndex = Index;
		SelectionGoalPosition = Multiply_Vector2DFloat(NodeOffset, float(Index));
		SelectionStartPosition.X = SelectionBox.GetFloat("_x");
		SelectionStartPosition.Y = SelectionBox.GetFloat("_y");
		SelectionEndTimer = ThisWorld.TimeSeconds + SlideTime;
		bSelectionIsSliding = true;
		DeactivateSelection(true);
	}
	//return;	
}

function HighlightSelection(bool bSuccess)
{
	// End:0x38
	if(bSuccess)
	{
		SelectionHighlight.GotoAndPlay("success");		
	}
	else
	{
		SelectionHighlight.GotoAndPlay("error");
	}
	//return;	
}

function UpdateItemState(int Index, optional bool doTransition = false)
{
	// End:0x209
	if(Index == ActiveSelectedIndex)
	{
		// End:0x160
		if(ConstructionStripItems[Index].bUnlocked)
		{
			// End:0xA5
			if(doTransition)
			{
				ConstructionStripItems[Index].Clip.GotoAndPlay("defaultToSelected");				
			}
			else
			{
				ConstructionStripItems[Index].Clip.GotoAndStop("selected");
			}
			// End:0x15D
			if(ConstructionStripItems[Index].ActionIcon != none)
			{
				ConstructionStripItems[Index].ActionIcon.SetVisible(bShowActionIcon);
			}			
		}
		else
		{
			// End:0x1BF
			if(doTransition)
			{
				ConstructionStripItems[Index].Clip.GotoAndPlay("lockedToLockedSel");				
			}
			else
			{
				ConstructionStripItems[Index].Clip.GotoAndStop("lockedSel");
			}
		}		
	}
	else
	{
		// End:0x2DA
		if(ConstructionStripItems[Index].bUnlocked)
		{
			// End:0x292
			if(doTransition)
			{
				ConstructionStripItems[Index].Clip.GotoAndPlay("selectedToDefault");				
			}
			else
			{
				ConstructionStripItems[Index].Clip.GotoAndStop("default");
			}			
		}
		else
		{
			// End:0x339
			if(doTransition)
			{
				ConstructionStripItems[Index].Clip.GotoAndPlay("lockedSelTolocked");				
			}
			else
			{
				ConstructionStripItems[Index].Clip.GotoAndStop("locked");
			}
		}
	}
	//return;	
}

function DeactivateSelection(optional bool doTransition = false)
{
	local int prevActiveSelIdx;

	// End:0x57
	if(ActiveSelectedIndex != -1)
	{
		prevActiveSelIdx = ActiveSelectedIndex;
		ActiveSelectedIndex = -1;
		UpdateItemState(prevActiveSelIdx, doTransition);
	}
	//return;	
}

function ActivateSelection(int Index, optional bool doTransition = false)
{
	// End:0x4C
	if(ActiveSelectedIndex != Index)
	{
		ActiveSelectedIndex = Index;
		UpdateItemState(Index, doTransition);
	}
	//return;	
}

function SetItemImage(int Index, string ImgPath)
{
	// End:0x71
	if(ConstructionStripItems[Index].Image != none)
	{
		ConstructionStripItems[Index].Image.SetImage(ImgPath);
	}
	//return;	
}

function SetItemUnlocked(int Index, bool Unlocked)
{
	// End:0x7C
	if(ConstructionStripItems[Index].bUnlocked != Unlocked)
	{
		ConstructionStripItems[Index].bUnlocked = Unlocked;
		UpdateItemState(Index);
	}
	//return;	
}

function SetItemText(int Index, string Text)
{
	// End:0x72
	if(ConstructionStripItems[Index].Text != none)
	{
		ConstructionStripItems[Index].Text.SetText(Text);
	}
	//return;	
}

defaultproperties
{
	SlideTime=0.3000000
}