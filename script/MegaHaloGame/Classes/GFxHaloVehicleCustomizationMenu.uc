class GFxHaloVehicleCustomizationMenu extends GFxHaloMoviePlayer
	config(UI);

var bool bIsInit;
var bool Last_bConfirmOpen;
var HaloPlayerPawnController PC;
var const localized string PurchaseItem;
var const localized string BuildVehicle;
var const localized string CancelCustomization;
var const localized string VCCategory_Vehicle;
var const localized string VCCategory_AddOn;
var const localized string VCCategory_Weapon;
var const localized string VCCategory_Paint;
var const localized string VCCategory_Decal;
var GFxObject Clip_Category_Vehicle;
var GFxObject Clip_Category_AddOn;
var GFxObject Clip_Category_Weapon;
var GFxObject Clip_Category_Paint;
var GFxObject Clip_Category_Decal;
var GFxObject Clip_New_Vehicle;
var GFxObject Clip_New_AddOn;
var GFxObject Clip_New_Weapon;
var GFxObject Clip_New_Paint;
var GFxObject Clip_New_Decal;
var GFxObject Text_ItemStd_Vehicle;
var GFxObject Text_ItemStd_AddOn;
var GFxObject Text_ItemStd_Weapon;
var GFxObject Text_ItemStd_Paint;
var GFxObject Text_ItemStd_Decal;
var GFxObject Text_ItemSel_Vehicle;
var GFxObject Text_ItemSel_AddOn;
var GFxObject Text_ItemSel_Weapon;
var GFxObject Text_ItemSel_Paint;
var GFxObject Text_ItemSel_Decal;
var GFxObject Clip_TabEdge;
var GFxObject Clip_TabMask;
var GFxObject Clip_BuyHint;
var HaloVehicleCustomizationManager.HVCCType Last_VCCategory;
var int Last_VCIndex_Vehicle;
var int Last_VCIndex_AddOn;
var int Last_VCIndex_Weapon;
var int Last_VCIndex_Paint;
var int Last_VCIndex_Decal;
var int Last_VCIndex;
var int Last_SelectedIndex;
var array<float> CategoriesYPositions;
var float SelectedCategoryOffset;
var const localized string AvailableItems;
var GFxHaloConstructionStrip ConstructionStrip;
var string CSItemPath;
var Vector2D CSSpacing;
var int CSMaxVisibleItem;
var GFxObject Text_Currency_Gold;
var int Last_GoldCount;
var const localized string ConfirmTitle;
var const localized string ConfirmBody_Winch;
var const localized string ConfirmYes;
var const localized string ConfirmNo;
var GFxObject Clip_Confirm;

function Init(optional LocalPlayer Player)
{
	local GFxObject tempMC;

	super(GFxMoviePlayer).Init(Player);
	// End:0xE9E
	if(Start())
	{
		// End:0xE09
		if(!bIsInit)
		{
			ExternalInterface = self;
			Clip_Category_Vehicle = GetVariableObject("_root.Menu_Tab.base.cat_vehicle");
			Clip_Category_AddOn = GetVariableObject("_root.Menu_Tab.base.cat_addOn");
			Clip_Category_Weapon = GetVariableObject("_root.Menu_Tab.base.cat_weapon");
			Clip_Category_Paint = GetVariableObject("_root.Menu_Tab.base.cat_paint");
			Clip_Category_Decal = GetVariableObject("_root.Menu_Tab.base.cat_decal");
			Clip_New_Vehicle = GetVariableObject("_root.Menu_Tab.base.cat_vehicle.newItem");
			Clip_New_AddOn = GetVariableObject("_root.Menu_Tab.base.cat_addOn.newItem");
			Clip_New_Weapon = GetVariableObject("_root.Menu_Tab.base.cat_weapon.newItem");
			Clip_New_Paint = GetVariableObject("_root.Menu_Tab.base.cat_paint.newItem");
			Clip_New_Decal = GetVariableObject("_root.Menu_Tab.base.cat_decal.newItem");
			Text_ItemSel_Vehicle = GetVariableObject("_root.Menu_Tab.base.cat_vehicle.sel_item.tf");
			Text_ItemSel_AddOn = GetVariableObject("_root.Menu_Tab.base.cat_addOn.sel_item.tf");
			Text_ItemSel_Weapon = GetVariableObject("_root.Menu_Tab.base.cat_weapon.sel_item.tf");
			Text_ItemSel_Paint = GetVariableObject("_root.Menu_Tab.base.cat_paint.sel_item.tf");
			Text_ItemSel_Decal = GetVariableObject("_root.Menu_Tab.base.cat_decal.sel_item.tf");
			Text_ItemStd_Vehicle = GetVariableObject("_root.Menu_Tab.base.cat_vehicle.std_item.tf");
			Text_ItemStd_AddOn = GetVariableObject("_root.Menu_Tab.base.cat_addOn.std_item.tf");
			Text_ItemStd_Weapon = GetVariableObject("_root.Menu_Tab.base.cat_weapon.std_item.tf");
			Text_ItemStd_Paint = GetVariableObject("_root.Menu_Tab.base.cat_paint.std_item.tf");
			Text_ItemStd_Decal = GetVariableObject("_root.Menu_Tab.base.cat_decal.std_item.tf");
			Clip_TabEdge = GetVariableObject("_root.Menu_Tab.base.tab");
			Clip_TabMask = GetVariableObject("_root.Menu_Tab.base.tabMask");
			Clip_BuyHint = GetVariableObject("_root.Menu_Tab.base.hint1");
			Clip_Confirm = GetVariableObject("_root.CDB");
			tempMC = GetVariableObject("_root.CDB.base.title");
			tempMC.SetText(ConfirmTitle);
			tempMC = GetVariableObject("_root.CDB.base.body");
			tempMC.HackSetTextWithIcon(ConfirmBody_Winch);
			tempMC = GetVariableObject("_root.CDB.base.yes");
			tempMC.SetText(ConfirmYes);
			tempMC = GetVariableObject("_root.Menu_Tab.base.cat_vehicle.std_cat.tf");
			tempMC.SetText(VCCategory_Vehicle);
			tempMC = GetVariableObject("_root.Menu_Tab.base.cat_vehicle.sel_cat.tf");
			tempMC.SetText(VCCategory_Vehicle);
			tempMC = GetVariableObject("_root.Menu_Tab.base.cat_addOn.std_cat.tf");
			tempMC.SetText(VCCategory_AddOn);
			tempMC = GetVariableObject("_root.Menu_Tab.base.cat_addOn.sel_cat.tf");
			tempMC.SetText(VCCategory_AddOn);
			tempMC = GetVariableObject("_root.Menu_Tab.base.cat_weapon.std_cat.tf");
			tempMC.SetText(VCCategory_Weapon);
			tempMC = GetVariableObject("_root.Menu_Tab.base.cat_weapon.sel_cat.tf");
			tempMC.SetText(VCCategory_Weapon);
			tempMC = GetVariableObject("_root.Menu_Tab.base.cat_paint.std_cat.tf");
			tempMC.SetText(VCCategory_Paint);
			tempMC = GetVariableObject("_root.Menu_Tab.base.cat_paint.sel_cat.tf");
			tempMC.SetText(VCCategory_Paint);
			tempMC = GetVariableObject("_root.Menu_Tab.base.cat_decal.std_cat.tf");
			tempMC.SetText(VCCategory_Decal);
			tempMC = GetVariableObject("_root.Menu_Tab.base.cat_decal.sel_cat.tf");
			tempMC.SetText(VCCategory_Decal);
			tempMC = GetVariableObject("_root.Menu_Tab.base.cat_vehicle.icon");
			tempMC.GotoAndStop("vehicle");
			tempMC = GetVariableObject("_root.Menu_Tab.base.cat_weapon.icon");
			tempMC.GotoAndStop("weapon");
			tempMC = GetVariableObject("_root.Menu_Tab.base.cat_paint.icon");
			tempMC.GotoAndStop("paint");
			tempMC = GetVariableObject("_root.Menu_Tab.base.cat_decal.icon");
			tempMC.GotoAndStop("decal");
			tempMC = GetVariableObject("_root.Menu_Tab.base.cat_addOn.icon");
			tempMC.GotoAndStop("addOn");
			tempMC = GetVariableObject("_root.Menu_Tab.base.hint1.tf");
			tempMC.SetText(PurchaseItem);
			tempMC = GetVariableObject("_root.Menu_Tab.base.hint2TF");
			tempMC.SetText(BuildVehicle);
			tempMC = GetVariableObject("_root.Menu_Tab.base.hint3TF");
			tempMC.SetText(CancelCustomization);
			tempMC = GetVariableObject("_root.Menu_CS.items");
			tempMC.SetText(AvailableItems);
			bIsInit = true;
		}
		Last_VCCategory = 6;
		Last_VCIndex_Vehicle = -1;
		Last_VCIndex_AddOn = -1;
		Last_VCIndex_Weapon = -1;
		Last_VCIndex_Paint = -1;
		Last_VCIndex_Decal = -1;
		Last_VCIndex = -1;
		Last_SelectedIndex = -1;
		Last_bConfirmOpen = false;
		SetCurrencyCounts();
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
	// End:0x37
	if(ConstructionStrip != none)
	{
		ConstructionStrip.Init(CSItemPath);
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
		theHUD.CompleteVCMenuClose();
	}
	//return;	
}

function Tick(float DeltaTime)
{
	local HaloGameDefault Game;
	local HaloVehicleCustomizationManager HVCM;
	local HaloVehicleCustomizationManager.HVCCType currentUpgradeType;
	local int CurrentIndex, currentSelectedIndex;
	local bool bForceUpdate, bCategoryChanged, bConfirmOpen;

	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x6AD
	if(Game != none)
	{
		HVCM = Game.TheCustomizationManager;
		// End:0x6AD
		if(HVCM != none)
		{
			currentUpgradeType = HVCM.CurrentHVCCType;
			CurrentIndex = int(HVCM.CurrentHVCCItemIdx);
			currentSelectedIndex = int(HVCM.GetCurrentSelectedIndex());
			bForceUpdate = (int(currentUpgradeType) == int(0)) && Last_VCIndex != CurrentIndex;
			// End:0x1BE
			if(!bForceUpdate)
			{
				bForceUpdate = UpdateCategoryItem(Text_ItemStd_Vehicle, Text_ItemSel_Vehicle, HVCM.SelectedVehicleIdx, Last_VCIndex_Vehicle, HVCM.HVCC_MasterVehicleArray, false);				
			}
			else
			{
				UpdateCategoryItem(Text_ItemStd_Vehicle, Text_ItemSel_Vehicle, HVCM.SelectedVehicleIdx, Last_VCIndex_Vehicle, HVCM.HVCC_MasterVehicleArray, bForceUpdate);
			}
			UpdateCategoryItem(Text_ItemStd_AddOn, Text_ItemSel_AddOn, HVCM.SelectedAddonIdx, Last_VCIndex_AddOn, HVCM.HVCC_FilteredAddonArray, bForceUpdate);
			UpdateCategoryItem(Text_ItemStd_Weapon, Text_ItemSel_Weapon, HVCM.SelectedWeaponIdx, Last_VCIndex_Weapon, HVCM.HVCC_FilteredWeaponArray, bForceUpdate);
			UpdateCategoryItem(Text_ItemStd_Paint, Text_ItemSel_Paint, HVCM.SelectedSkinIdx, Last_VCIndex_Paint, HVCM.HVCC_FilteredSkinArray, bForceUpdate);
			UpdateCategoryItem(Text_ItemStd_Decal, Text_ItemSel_Decal, HVCM.SelectedDecalIdx, Last_VCIndex_Decal, HVCM.HVCC_FilteredDecalArray, bForceUpdate);
			bCategoryChanged = int(Last_VCCategory) != int(currentUpgradeType);
			// End:0x59C
			if(bCategoryChanged || bForceUpdate)
			{
				UpdateCategoryState(Clip_Category_Vehicle, Clip_New_Vehicle, HVCM.HVCC_MasterVehicleArray.Length > 0, 0, int(currentUpgradeType));
				UpdateCategoryState(Clip_Category_AddOn, Clip_New_AddOn, HVCM.HVCC_FilteredAddonArray.Length > 0, 1, int(currentUpgradeType));
				UpdateCategoryState(Clip_Category_Weapon, Clip_New_Weapon, HVCM.HVCC_FilteredWeaponArray.Length > 0, 2, int(currentUpgradeType));
				UpdateCategoryState(Clip_Category_Paint, Clip_New_Paint, HVCM.HVCC_FilteredSkinArray.Length > 0, 3, int(currentUpgradeType));
				UpdateCategoryState(Clip_Category_Decal, Clip_New_Decal, HVCM.HVCC_FilteredDecalArray.Length > 0, 4, int(currentUpgradeType));
				Last_VCCategory = currentUpgradeType;
			}
			// End:0x614
			if(bCategoryChanged)
			{
				ConstructionStrip.bShowActionIcon = (int(currentUpgradeType) == int(1)) && Last_GoldCount > 0;
				UpdateConstructionStripData(HVCM.GetCurrentCustomizationArray());
			}
			// End:0x6AD
			if(((Last_VCIndex != CurrentIndex) || Last_SelectedIndex != currentSelectedIndex) || bCategoryChanged)
			{
				ConstructionStrip.MoveToIndex(CurrentIndex, !bCategoryChanged);
				Last_VCIndex = CurrentIndex;
				Last_SelectedIndex = currentSelectedIndex;
			}
		}
	}
	// End:0x81B
	if(PC != none)
	{
		bConfirmOpen = PC.bShowHVCCPrompt;
		// End:0x81B
		if(Last_bConfirmOpen != bConfirmOpen)
		{
			// End:0x749
			if(bConfirmOpen)
			{
				PlayMenuSound("select");
				Clip_Confirm.GotoAndPlay("transIn");				
			}
			else
			{
				PlayMenuSound("select");
				Clip_Confirm.GotoAndPlay("transOut");
				SetCurrencyCounts();
				Clip_New_AddOn.SetVisible(Last_GoldCount > 0);
				ConstructionStrip.bShowActionIcon = Last_GoldCount > 0;
				ConstructionStrip.UpdateItemState(0);
			}
			Last_bConfirmOpen = bConfirmOpen;
		}
	}
	// End:0x852
	if(ConstructionStrip != none)
	{
		ConstructionStrip.Tick(DeltaTime);
	}
	//return;	
}

function UpdateConstructionStripData(array<HVCCInfo> ItemInfo)
{
	local int I, NumItems, VisibleNodeCount;

	NumItems = ItemInfo.Length;
	VisibleNodeCount = Min(NumItems, CSMaxVisibleItem);
	ConstructionStrip.NodeSettings(NumItems, VisibleNodeCount, CSSpacing);
	I = 0;
	J0x77:

	// End:0x162 [Loop If]
	if(I < NumItems)
	{
		ConstructionStrip.SetItemImage(I, ItemInfo[I].IconPkgPath);
		ConstructionStrip.SetItemUnlocked(I, ItemInfo[I].Unlocked);
		ConstructionStrip.UpdateItemState(I);
		I++;
		// [Loop Continue]
		goto J0x77;
	}
	//return;	
}

function UpdateCategoryState(GFxObject MC, GFxObject NewMC, bool bUnlocked, int CategoryIndex, int SelectedIndex)
{
	// End:0x39
	if(!bUnlocked)
	{
		MC.GotoAndStop("locked");		
	}
	else
	{
		// End:0x7C
		if(CategoryIndex == SelectedIndex)
		{
			MC.GotoAndStop("selected");			
		}
		else
		{
			MC.GotoAndStop("default");
		}
	}
	// End:0xE1
	if(CategoryIndex == 1)
	{
		NewMC.SetVisible(Last_GoldCount > 0);		
	}
	else
	{
		NewMC.SetVisible(false);
	}
	//return;	
}

function bool UpdateCategoryItem(GFxObject TFStd, GFxObject TFSel, byte CurrentIndex, out int lastIndex, array<HVCCInfo> ItemInfo, bool bForceUpdate)
{
	// End:0x148
	if((lastIndex != int(CurrentIndex)) || bForceUpdate)
	{
		// End:0xE5
		if((ItemInfo.Length > 0) && int(CurrentIndex) != int(255))
		{
			TFStd.SetText(string(ItemInfo[int(CurrentIndex)].Name));
			TFSel.SetText(string(ItemInfo[int(CurrentIndex)].Name));			
		}
		else
		{
			TFStd.SetText("None");
			TFSel.SetText("None");
		}
		lastIndex = int(CurrentIndex);
		return true;
	}
	return false;
	//return ReturnValue;	
}

function SetCurrencyCounts()
{
	local HaloGameDefault Game;
	local HaloVehicleCustomizationManager HVCM;
	local int I, J, goldCount;

	goldCount = 0;
	Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x252
	if(Game != none)
	{
		HVCM = Game.TheCustomizationManager;
		// End:0x252
		if(HVCM != none)
		{
			I = 0;
			J0xA3:

			// End:0x252 [Loop If]
			if(I < HVCM.HVCC_MasterVehicleArray.Length)
			{
				// End:0x244
				if(HVCM.HVCC_MasterVehicleArray[I].Name == 'Warthog')
				{
					// End:0x241
					if(int(HVCM.HVCC_MasterVehicleArray[I].DefaultAddonIdx) == int(255))
					{
						J = 0;
						J0x16A:

						// End:0x23E [Loop If]
						if(J < HVCM.HVCC_MasterAddonArray.Length)
						{
							// End:0x230
							if(HVCM.HVCC_MasterAddonArray[J].ClassToSpawn == Class'MegaHaloGame.HVCCAddon_MagWinch')
							{
								// End:0x22D
								if(HVCM.HVCC_MasterAddonArray[J].Unlocked)
								{
									goldCount = 1;									
								}
								else
								{
									// [Explicit Break]
									goto J0x23E;
								}
							}
							J++;
							// [Loop Continue]
							goto J0x16A;
						}
						J0x23E:
						
					}
					else
					{
						// [Explicit Break]
						goto J0x252;
					}
				}
				I++;
				// [Loop Continue]
				goto J0xA3;
			}
		}
	}
	J0x252:

	Last_GoldCount = goldCount;
	//return;	
}

defaultproperties
{
	PurchaseItem="Open"
	BuildVehicle="Build"
	CancelCustomization="Cancel"
	VCCategory_Vehicle="VEHICLE"
	VCCategory_AddOn="TOOL"
	VCCategory_Weapon="WEAPON"
	VCCategory_Paint="PAINT"
	VCCategory_Decal="DECAL"
	CategoriesYPositions[0]=210.0000000
	CategoriesYPositions[1]=280.0000000
	CategoriesYPositions[2]=345.0000000
	CategoriesYPositions[3]=410.0000000
	CategoriesYPositions[4]=476.0000000
	SelectedCategoryOffset=-1.0000000
	AvailableItems="AVAILABLE ITEMS"
	CSItemPath="CS_Item"
	CSSpacing=(X=0.0000000,Y=140.0000000)
	CSMaxVisibleItem=6
	ConfirmTitle="UPGRADE UNLOCKED!"
	ConfirmBody_Winch="Hold [MainHUD.InlineInputIcons.inputIcon_lb] to launch the warthog winch. Once connected, hold [MainHUD.InlineInputIcons.inputIcon_b] to reverse the warthog and pull the winch cable."
	ConfirmYes="Continue"
	ConfirmNo="Cancel"
	AkEventMap=HaloAkEventMap'UIHUD.MenuAkEventMap'
	LocalizationSection="GFxHaloVehicleCustomizationMenu"
	MovieInfo=SwfMovie'VehicleCustomizationMenu.GFx_VehicleCustomization'
	bAutoPlay=true
	bOnlyOwnerFocusable=true
	bDiscardNonOwnerInput=true
	TimingMode=GFxTimingMode.TM_Real
}