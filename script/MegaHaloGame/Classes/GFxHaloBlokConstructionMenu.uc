class GFxHaloBlokConstructionMenu extends GFxHaloMoviePlayer
	config(UI);

var bool bIsInit;
var bool Last_bPuzzleLocked;
var HaloPlayerPawnController PC;
var const localized string PiecesNeeded;
var const localized string BlokConstructionComplete;
var const localized string PlacePiece;
var const localized string SelectSection;
var const localized string RotateCamera;
var const localized string CancelBuild;
var GFxObject Clip_PuzzlePctComplete;
var GFxObject Text_PuzzlePctComplete;
var int Last_BCIndex;
var float Last_BCPctComplete;
var const localized string AvailableBloks;
var GFxHaloConstructionStrip ConstructionStrip;
var string CSItemPath;
var Vector2D CSSpacing;
var int CSMaxVisibleItem;

function Init(optional LocalPlayer Player)
{
	local GFxObject tempMC;
	local HaloGameDefault Game;
	local HaloConstructionManager HCM;

	super(GFxMoviePlayer).Init(Player);
	// End:0x445
	if(Start())
	{
		// End:0x209
		if(!bIsInit)
		{
			ExternalInterface = self;
			Text_PuzzlePctComplete = GetVariableObject("_root.Menu_Tab.base.pct");
			Clip_PuzzlePctComplete = GetVariableObject("_root.Menu_Tab.base.meter");
			tempMC = GetVariableObject("_root.Menu_Tab.base.hintTF");
			tempMC.SetText(PlacePiece);
			tempMC = GetVariableObject("_root.Menu_Tab.base.hint2TF");
			tempMC.SetText(SelectSection);
			tempMC = GetVariableObject("_root.Menu_Tab.base.hint3TF");
			tempMC.SetText(CancelBuild);
			tempMC = GetVariableObject("_root.Menu_CS.bloks");
			tempMC.SetText(AvailableBloks);
			bIsInit = true;
		}
		Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
		// End:0x411
		if(Game != none)
		{
			HCM = Game.TheConstructionManager;
			// End:0x411
			if(HCM != none)
			{
				tempMC = GetVariableObject("_root.Menu_Tab.base.itemName");
				tempMC.SetText(HCM.GetBuildName());
				tempMC = GetVariableObject("_root.Menu_Tab.base.pieceCount");
				tempMC.SetText((string(HCM.GetTotalPrimitives()) $ " ") $ PiecesNeeded);
				tempMC = GetVariableObject("_root.Menu_Tab.base.preview");
				tempMC.SetString("source", "img://" $ HCM.GetPreviewImagePath());
			}
		}
		Last_BCIndex = -1;
		Last_BCPctComplete = -1.0000000;
		Last_bPuzzleLocked = false;
		OpenMenu();
	}
	//return;	
}

function registerConstructionStrip(GFxHaloConstructionStrip MC)
{
	// End:0x59
	if(ConstructionStrip == none)
	{
		ConstructionStrip = MC;
		// End:0x59
		if(ConstructionStrip != none)
		{
			ConstructionStrip.Init(CSItemPath);
		}
	}
	//return;	
}

function OpenMenu()
{
	// End:0x57
	if(ConstructionStrip != none)
	{
		ConstructionStrip.Init(CSItemPath);
		ConstructionStrip.SetVisible(true);
	}
	//return;	
}

function CloseMenu()
{
	local GFxHaloHUD theHUD;

	theHUD = GFxHaloHUD(PC.myHUD);
	// End:0x5F
	if(theHUD != none)
	{
		theHUD.CompleteBCMenuClose();
	}
	//return;	
}

function Tick(float DeltaTime)
{
	local HaloGameDefault Game;
	local HaloConstructionManager HCM;
	local bool forceItemUpdate;
	local int CurrentIndex;
	local float pctComplete;
	local bool bIsLocked;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x2E1
	if(Game != none)
	{
		HCM = Game.TheConstructionManager;
		// End:0x2E1
		if(HCM != none)
		{
			forceItemUpdate = false;
			pctComplete = float(HCM.GetUsedPrimitives()) / float(HCM.GetTotalPrimitives());
			// End:0x1C6
			if(Last_BCPctComplete != pctComplete)
			{
				forceItemUpdate = true;
				Last_BCPctComplete = pctComplete;
				// End:0x150
				if(pctComplete >= 1.0000000)
				{
					ConstructionStrip.SetVisible(false);
				}
				pctComplete *= float(100);
				Text_PuzzlePctComplete.SetText(string(int(pctComplete)) $ BlokConstructionComplete);
				Clip_PuzzlePctComplete.GotoAndStopI(int(pctComplete + float(1)));
			}
			bIsLocked = HCM.GetPrimitiveAlreadyPlaced();
			// End:0x256
			if((Last_bPuzzleLocked != bIsLocked) || forceItemUpdate)
			{
				Last_bPuzzleLocked = bIsLocked;
				UpdateConstructionStripData(HCM.GetConstructionUIPrimitives());
			}
			CurrentIndex = HCM.GetConstructionUIPrimitivesIndex();
			// End:0x2E1
			if((Last_BCIndex != CurrentIndex) || forceItemUpdate)
			{
				ConstructionStrip.MoveToIndex(CurrentIndex);
				Last_BCIndex = CurrentIndex;
			}
		}
	}
	// End:0x318
	if(ConstructionStrip != none)
	{
		ConstructionStrip.Tick(DeltaTime);
	}
	//return;	
}

function UpdateConstructionStripData(array<HaloConstructionUIPrimitive> ItemInfo)
{
	local int I, NumItems, VisibleNodeCount;

	NumItems = ItemInfo.Length;
	VisibleNodeCount = Min(NumItems, CSMaxVisibleItem);
	ConstructionStrip.NodeSettings(NumItems, VisibleNodeCount, CSSpacing);
	I = 0;
	J0x77:

	// End:0x19C [Loop If]
	if(I < NumItems)
	{
		ConstructionStrip.SetItemImage(I, ItemInfo[I].IconPkgPath);
		ConstructionStrip.SetItemUnlocked(I, !Last_bPuzzleLocked);
		ConstructionStrip.SetItemText(I, string(ItemInfo[I].Count) $ "x");
		ConstructionStrip.UpdateItemState(I);
		I++;
		// [Loop Continue]
		goto J0x77;
	}
	//return;	
}

function PlacementError()
{
	// End:0x2F
	if(!Last_bPuzzleLocked)
	{
		ConstructionStrip.HighlightSelection(false);
	}
	//return;	
}

function PlacementSuccess()
{
	// End:0x2F
	if(!Last_bPuzzleLocked)
	{
		ConstructionStrip.HighlightSelection(true);
	}
	//return;	
}

defaultproperties
{
	PiecesNeeded="PIECES"
	BlokConstructionComplete="% COMPLETE"
	PlacePiece="Place"
	SelectSection="Next"
	RotateCamera="Rotate"
	CancelBuild="Cancel"
	AvailableBloks="AVAILABLE BLOKS"
	CSItemPath="CS_Item"
	CSSpacing=(X=0.0000000,Y=140.0000000)
	CSMaxVisibleItem=6
	AkEventMap=HaloAkEventMap'UIHUD.MenuAkEventMap'
	LocalizationSection="GFxHaloBlokConstructionMenu"
	MovieInfo=SwfMovie'BlokConstructionMenu.GFx_BlokConstruction'
	bAutoPlay=true
	bOnlyOwnerFocusable=true
	bDiscardNonOwnerInput=true
	TimingMode=TM_Real
}