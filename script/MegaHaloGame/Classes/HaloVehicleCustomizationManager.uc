class HaloVehicleCustomizationManager extends Actor
	config(VehicleCustomization)
	notplaceable
	implements(HaloSaveInterface);

enum HVCCType
{
	HVCC_Vehicle,                   // 0
	HVCC_Addon,                     // 1
	HVCC_Weapon,                    // 2
	HVCC_Skin,                      // 3
	HVCC_Decal,                     // 4
	HVCC_WheelSet,                  // 5
	HVCC_NONE,                      // 6
	HVCC_MAX                        // 7
};

struct HVCCInfo
{
	var name Name;
	var bool Unlocked;
	var string IconPkgPath;
	var SkeletalMesh PreviewMesh;
	var name PreviewSocketName;
	var string TargetVehicleClassName;
	var Class<HaloVehicle> TargetVehicleClass;
	var name MagicMomentEventName;
	var name UnlockRemoteEventName;
	var HaloVCustomizationComponent ArchetypeToSpawn;
	var string ClassToSpawnName;
	var Class<HaloVCustomizationComponent> ClassToSpawn;
	var byte DefaultAddonIdx;
	var byte DefaultWheelSetIdx;
	var byte DefaultWeaponIdx;
	var byte DefaultSkinIdx;
	var byte DefaultDecalIdx;

	structdefaultproperties
	{
		Name="None"
		Unlocked=true
		IconPkgPath=""
		PreviewMesh=none
		PreviewSocketName="None"
		TargetVehicleClassName=""
		TargetVehicleClass=none
		MagicMomentEventName="None"
		UnlockRemoteEventName="None"
		ArchetypeToSpawn=none
		ClassToSpawnName=""
		ClassToSpawn=none
		DefaultAddonIdx=255
		DefaultWheelSetIdx=255
		DefaultWeaponIdx=255
		DefaultSkinIdx=0
		DefaultDecalIdx=255
	}
};

struct MagicMomentInfo
{
	var name EventName;
	var Actor MMActor;

	structdefaultproperties
	{
		EventName="None"
		MMActor=none
	}
};

var HaloVehicleCustomizationManager.HVCCType CurrentHVCCType;
var byte CurrentHVCCItemIdx;
var byte CurrentHVCCItemMaxIdx;
var byte SelectedWheelSetIdx;
var byte SelectedAddonIdx;
var byte SelectedVehicleIdx;
var byte SelectedSkinIdx;
var byte SelectedWeaponIdx;
var byte SelectedDecalIdx;
var HVCCInfo CurrentVehicleInfo;
var HaloVehicleCustomizationPanel ActivePanel;
var HVCCInfo CurrentHVCCItemInfo;
var const float JoystickInputDelay;
var float TimeSinceLastJoystickXInput;
var float TimeSinceLastJoystickYInput;
var const float SecsRequiredToConfirm;
var float CurrentConfirmCountdown;
var float MagicMomentDeployTimer;
var float MagicMomentDelay;
var config array<config HVCCInfo> HVCC_MasterVehicleArray;
var config array<config HVCCInfo> HVCC_MasterAddonArray;
var config array<config HVCCInfo> HVCC_MasterWheelsetArray;
var config array<config HVCCInfo> HVCC_MasterSkinArray;
var config array<config HVCCInfo> HVCC_MasterDecalArray;
var config array<config HVCCInfo> HVCC_MasterWeaponArray;
var array<HVCCInfo> HVCC_FilteredAddonArray;
var array<HVCCInfo> HVCC_FilteredWheelsetArray;
var array<HVCCInfo> HVCC_FilteredSkinArray;
var array<HVCCInfo> HVCC_FilteredDecalArray;
var array<HVCCInfo> HVCC_FilteredWeaponArray;
var array<MagicMomentInfo> MagicMomentStack;

event PostBeginPlay()
{
	ResolveClassReferences();
	super.PostBeginPlay();
	//return;	
}

simulated function ResolveClassReferences()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x15D [Loop If]
	if(I < HVCC_MasterVehicleArray.Length)
	{
		// End:0xB9
		if(HVCC_MasterVehicleArray[I].TargetVehicleClassName != "")
		{
			HVCC_MasterVehicleArray[I].TargetVehicleClass = Class<HaloVehicle>(FindObject(HVCC_MasterVehicleArray[I].TargetVehicleClassName, Class'Core.Class'));
		}
		// End:0x14F
		if(HVCC_MasterVehicleArray[I].ClassToSpawnName != "")
		{
			HVCC_MasterVehicleArray[I].ClassToSpawn = Class<HaloVCustomizationComponent>(FindObject(HVCC_MasterVehicleArray[I].ClassToSpawnName, Class'Core.Class'));
		}
		++I;
		// [Loop Continue]
		goto J0x0B;
	}
	I = 0;
	J0x168:

	// End:0x2BA [Loop If]
	if(I < HVCC_MasterAddonArray.Length)
	{
		// End:0x216
		if(HVCC_MasterAddonArray[I].TargetVehicleClassName != "")
		{
			HVCC_MasterAddonArray[I].TargetVehicleClass = Class<HaloVehicle>(FindObject(HVCC_MasterAddonArray[I].TargetVehicleClassName, Class'Core.Class'));
		}
		// End:0x2AC
		if(HVCC_MasterAddonArray[I].ClassToSpawnName != "")
		{
			HVCC_MasterAddonArray[I].ClassToSpawn = Class<HaloVCustomizationComponent>(FindObject(HVCC_MasterAddonArray[I].ClassToSpawnName, Class'Core.Class'));
		}
		++I;
		// [Loop Continue]
		goto J0x168;
	}
	I = 0;
	J0x2C5:

	// End:0x417 [Loop If]
	if(I < HVCC_MasterWheelsetArray.Length)
	{
		// End:0x373
		if(HVCC_MasterWheelsetArray[I].TargetVehicleClassName != "")
		{
			HVCC_MasterWheelsetArray[I].TargetVehicleClass = Class<HaloVehicle>(FindObject(HVCC_MasterWheelsetArray[I].TargetVehicleClassName, Class'Core.Class'));
		}
		// End:0x409
		if(HVCC_MasterWheelsetArray[I].ClassToSpawnName != "")
		{
			HVCC_MasterWheelsetArray[I].ClassToSpawn = Class<HaloVCustomizationComponent>(FindObject(HVCC_MasterWheelsetArray[I].ClassToSpawnName, Class'Core.Class'));
		}
		++I;
		// [Loop Continue]
		goto J0x2C5;
	}
	I = 0;
	J0x422:

	// End:0x574 [Loop If]
	if(I < HVCC_MasterSkinArray.Length)
	{
		// End:0x4D0
		if(HVCC_MasterSkinArray[I].TargetVehicleClassName != "")
		{
			HVCC_MasterSkinArray[I].TargetVehicleClass = Class<HaloVehicle>(FindObject(HVCC_MasterSkinArray[I].TargetVehicleClassName, Class'Core.Class'));
		}
		// End:0x566
		if(HVCC_MasterSkinArray[I].ClassToSpawnName != "")
		{
			HVCC_MasterSkinArray[I].ClassToSpawn = Class<HaloVCustomizationComponent>(FindObject(HVCC_MasterSkinArray[I].ClassToSpawnName, Class'Core.Class'));
		}
		++I;
		// [Loop Continue]
		goto J0x422;
	}
	I = 0;
	J0x57F:

	// End:0x6D1 [Loop If]
	if(I < HVCC_MasterDecalArray.Length)
	{
		// End:0x62D
		if(HVCC_MasterDecalArray[I].TargetVehicleClassName != "")
		{
			HVCC_MasterDecalArray[I].TargetVehicleClass = Class<HaloVehicle>(FindObject(HVCC_MasterDecalArray[I].TargetVehicleClassName, Class'Core.Class'));
		}
		// End:0x6C3
		if(HVCC_MasterDecalArray[I].ClassToSpawnName != "")
		{
			HVCC_MasterDecalArray[I].ClassToSpawn = Class<HaloVCustomizationComponent>(FindObject(HVCC_MasterDecalArray[I].ClassToSpawnName, Class'Core.Class'));
		}
		++I;
		// [Loop Continue]
		goto J0x57F;
	}
	I = 0;
	J0x6DC:

	// End:0x82E [Loop If]
	if(I < HVCC_MasterWeaponArray.Length)
	{
		// End:0x78A
		if(HVCC_MasterWeaponArray[I].TargetVehicleClassName != "")
		{
			HVCC_MasterWeaponArray[I].TargetVehicleClass = Class<HaloVehicle>(FindObject(HVCC_MasterWeaponArray[I].TargetVehicleClassName, Class'Core.Class'));
		}
		// End:0x820
		if(HVCC_MasterWeaponArray[I].ClassToSpawnName != "")
		{
			HVCC_MasterWeaponArray[I].ClassToSpawn = Class<HaloVCustomizationComponent>(FindObject(HVCC_MasterWeaponArray[I].ClassToSpawnName, Class'Core.Class'));
		}
		++I;
		// [Loop Continue]
		goto J0x6DC;
	}
	//return;	
}

event Tick(float DeltaTime)
{
	// End:0xC7
	if(IsActive())
	{
		TimeSinceLastJoystickXInput += DeltaTime;
		// End:0x4B
		if(TimeSinceLastJoystickXInput >= JoystickInputDelay)
		{
			TimeSinceLastJoystickXInput = JoystickInputDelay;
		}
		TimeSinceLastJoystickYInput += DeltaTime;
		// End:0x89
		if(TimeSinceLastJoystickYInput >= JoystickInputDelay)
		{
			TimeSinceLastJoystickYInput = JoystickInputDelay;
		}
		UpdateConfirmTimer(DeltaTime);
		ActivePanel.StoredDeltaTime = DeltaTime;		
	}
	else
	{
		// End:0x167
		if(MagicMomentStack.Length != 0)
		{
			MagicMomentDeployTimer -= DeltaTime;
			// End:0x167
			if(MagicMomentDeployTimer <= 0.0000000)
			{
				// End:0x154
				if(PlayMagicMoment(MagicMomentStack[0].EventName, MagicMomentStack[0].MMActor))
				{
					MagicMomentStack.Remove(0, 1);
				}
				MagicMomentDeployTimer = MagicMomentDelay;
			}
		}
	}
	//return;	
}

function bool IsActive()
{
	return int(CurrentHVCCType) != int(6);
	//return ReturnValue;	
}

function array<HVCCInfo> GetCurrentCustomizationArray()
{
	switch(CurrentHVCCType)
	{
		// End:0x3B
		case 5:
			CurrentHVCCItemMaxIdx = byte(HVCC_FilteredWheelsetArray.Length);
			return HVCC_FilteredWheelsetArray;
			// End:0xDE
			break;
		// End:0x63
		case 1:
			CurrentHVCCItemMaxIdx = byte(HVCC_FilteredAddonArray.Length);
			return HVCC_FilteredAddonArray;
			// End:0xDE
			break;
		// End:0x8B
		case 0:
			CurrentHVCCItemMaxIdx = byte(HVCC_MasterVehicleArray.Length);
			return HVCC_MasterVehicleArray;
			// End:0xDE
			break;
		// End:0xB3
		case 3:
			CurrentHVCCItemMaxIdx = byte(HVCC_FilteredSkinArray.Length);
			return HVCC_FilteredSkinArray;
			// End:0xDE
			break;
		// End:0xDB
		case 2:
			CurrentHVCCItemMaxIdx = byte(HVCC_FilteredWeaponArray.Length);
			return HVCC_FilteredWeaponArray;
			// End:0xDE
			break;
		// End:0xFFFF
		default:
			break;
	}
	//return ReturnValue;	
}

function byte GetSelectedIndex(HaloVehicleCustomizationManager.HVCCType Type)
{
	switch(Type)
	{
		// End:0x25
		case 5:
			return SelectedWheelSetIdx;
			// End:0x82
			break;
		// End:0x37
		case 1:
			return SelectedAddonIdx;
			// End:0x82
			break;
		// End:0x49
		case 0:
			return SelectedVehicleIdx;
			// End:0x82
			break;
		// End:0x5B
		case 3:
			return SelectedSkinIdx;
			// End:0x82
			break;
		// End:0x6D
		case 2:
			return SelectedWeaponIdx;
			// End:0x82
			break;
		// End:0x7F
		case 4:
			return SelectedDecalIdx;
			// End:0x82
			break;
		// End:0xFFFF
		default:
			break;
	}
	return 255;
	//return ReturnValue;	
}

function SetSelectedIndex(HaloVehicleCustomizationManager.HVCCType Type, byte newIdx)
{
	switch(Type)
	{
		// End:0x76
		case 5:
			// End:0x73
			if((int(newIdx) < HVCC_FilteredWheelsetArray.Length) && HVCC_FilteredWheelsetArray[int(newIdx)].Unlocked)
			{
				SelectedWheelSetIdx = newIdx;
			}
			// End:0x268
			break;
		// End:0xD9
		case 1:
			// End:0xD6
			if((int(newIdx) < HVCC_FilteredAddonArray.Length) && HVCC_FilteredAddonArray[int(newIdx)].Unlocked)
			{
				SelectedAddonIdx = newIdx;
			}
			// End:0x268
			break;
		// End:0x13C
		case 0:
			// End:0x139
			if((int(newIdx) < HVCC_MasterVehicleArray.Length) && HVCC_MasterVehicleArray[int(newIdx)].Unlocked)
			{
				SelectedVehicleIdx = newIdx;
			}
			// End:0x268
			break;
		// End:0x19F
		case 3:
			// End:0x19C
			if((int(newIdx) < HVCC_FilteredSkinArray.Length) && HVCC_FilteredSkinArray[int(newIdx)].Unlocked)
			{
				SelectedSkinIdx = newIdx;
			}
			// End:0x268
			break;
		// End:0x202
		case 2:
			// End:0x1FF
			if((int(newIdx) < HVCC_FilteredWeaponArray.Length) && HVCC_FilteredWeaponArray[int(newIdx)].Unlocked)
			{
				SelectedWeaponIdx = newIdx;
			}
			// End:0x268
			break;
		// End:0x265
		case 4:
			// End:0x262
			if((int(newIdx) < HVCC_FilteredDecalArray.Length) && HVCC_FilteredDecalArray[int(newIdx)].Unlocked)
			{
				SelectedDecalIdx = newIdx;
			}
			// End:0x268
			break;
		// End:0xFFFF
		default:
			break;
	}
	//return;	
}

function byte GetCurrentSelectedIndex()
{
	return GetSelectedIndex(CurrentHVCCType);
	//return ReturnValue;	
}

function IncrementCurrentItemIndex()
{
	local array<HVCCInfo> curInfo;
	local byte OriginalIdx;

	curInfo = GetCurrentCustomizationArray();
	OriginalIdx = CurrentHVCCItemIdx;
	J0x27:

	CurrentHVCCItemIdx += 1;
	// End:0x5A
	if(int(CurrentHVCCItemIdx) == curInfo.Length)
	{
		CurrentHVCCItemIdx = 0;
	}
	// End:0x27
	if(!(((int(CurrentHVCCItemIdx) == int(OriginalIdx)) || curInfo[int(CurrentHVCCItemIdx)].Unlocked) || int(CurrentHVCCType) != int(0)))
		goto J0x27;
	// End:0xE9
	if(int(CurrentHVCCType) != int(1))
	{
		SetSelectedIndex(CurrentHVCCType, CurrentHVCCItemIdx);
	}
	// End:0x250
	if(((int(OriginalIdx) != int(CurrentHVCCItemIdx)) && int(CurrentHVCCType) == int(0)) && int(CurrentHVCCItemIdx) == int(SelectedVehicleIdx))
	{
		SelectedWheelSetIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultWheelSetIdx;
		SelectedAddonIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultAddonIdx;
		SelectedSkinIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultSkinIdx;
		SelectedWeaponIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultWeaponIdx;
		ActivePanel.SwapVehiclePreview(HVCC_MasterVehicleArray[int(SelectedVehicleIdx)]);
		FilterCustomizationArrays(SelectedVehicleIdx);
		InitializePreviews();
	}
	UpdateCurrentItemDisplay(curInfo, CurrentHVCCType);
	//return;	
}

function DecrementCurrentItemIndex()
{
	local array<HVCCInfo> curInfo;
	local byte OriginalIdx;

	curInfo = GetCurrentCustomizationArray();
	OriginalIdx = CurrentHVCCItemIdx;
	J0x27:

	CurrentHVCCItemIdx -= 1;
	// End:0x61
	if(int(CurrentHVCCItemIdx) == int(255))
	{
		CurrentHVCCItemIdx = byte(curInfo.Length - 1);
	}
	// End:0x27
	if(!(((int(OriginalIdx) == int(CurrentHVCCItemIdx)) || curInfo[int(CurrentHVCCItemIdx)].Unlocked) || int(CurrentHVCCType) != int(0)))
		goto J0x27;
	// End:0xF0
	if(int(CurrentHVCCType) != int(1))
	{
		SetSelectedIndex(CurrentHVCCType, CurrentHVCCItemIdx);
	}
	// End:0x257
	if(((int(OriginalIdx) != int(CurrentHVCCItemIdx)) && int(CurrentHVCCType) == int(0)) && int(CurrentHVCCItemIdx) == int(SelectedVehicleIdx))
	{
		SelectedWheelSetIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultWheelSetIdx;
		SelectedAddonIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultAddonIdx;
		SelectedSkinIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultSkinIdx;
		SelectedWeaponIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultWeaponIdx;
		ActivePanel.SwapVehiclePreview(HVCC_MasterVehicleArray[int(SelectedVehicleIdx)]);
		FilterCustomizationArrays(SelectedVehicleIdx);
		InitializePreviews();
	}
	UpdateCurrentItemDisplay(curInfo, CurrentHVCCType);
	//return;	
}

function IncrementCurrentCategoryIndex()
{
	local array<HVCCInfo> curInfo;
	local HaloVehicleCustomizationManager.HVCCType InitialType;

	InitialType = CurrentHVCCType;
	J0x13:

	switch(CurrentHVCCType)
	{
		// End:0x4D
		case 5:
			CurrentHVCCType = 1;
			CurrentHVCCItemIdx = SelectedAddonIdx;
			// End:0x220
			break;
		// End:0x74
		case 1:
			CurrentHVCCType = 0;
			CurrentHVCCItemIdx = SelectedVehicleIdx;
			// End:0x220
			break;
		// End:0x1CF
		case 0:
			CurrentHVCCType = 3;
			// End:0x1B9
			if(int(CurrentHVCCItemIdx) != int(SelectedVehicleIdx))
			{
				ActivePanel.SwapVehiclePreview(HVCC_MasterVehicleArray[int(SelectedVehicleIdx)]);
				FilterCustomizationArrays(SelectedVehicleIdx);
				SelectedWheelSetIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultWheelSetIdx;
				SelectedAddonIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultAddonIdx;
				SelectedSkinIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultSkinIdx;
				SelectedWeaponIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultWeaponIdx;
				InitializePreviews();
			}
			CurrentHVCCItemIdx = SelectedSkinIdx;
			// End:0x220
			break;
		// End:0x1F6
		case 3:
			CurrentHVCCType = 2;
			CurrentHVCCItemIdx = SelectedWeaponIdx;
			// End:0x220
			break;
		// End:0x21D
		case 2:
			CurrentHVCCType = 5;
			CurrentHVCCItemIdx = SelectedWheelSetIdx;
			// End:0x220
			break;
		// End:0xFFFF
		default:
			break;
	}
	curInfo = GetCurrentCustomizationArray();
	// End:0x247
	if(curInfo.Length > 0)
	{		
	}
	else
	{
		// End:0x13
		if(!(int(CurrentHVCCType) == int(InitialType)))
			goto J0x13;
	}
	// End:0x282
	if(int(CurrentHVCCItemIdx) == int(255))
	{
		CurrentHVCCItemIdx = 0;
	}
	UpdateCurrentItemDisplay(curInfo, InitialType);
	//return;	
}

function DecrementCurrentCategoryIndex()
{
	local array<HVCCInfo> curInfo;
	local HaloVehicleCustomizationManager.HVCCType InitialType;

	InitialType = CurrentHVCCType;
	J0x13:

	switch(CurrentHVCCType)
	{
		// End:0x4D
		case 5:
			CurrentHVCCType = 2;
			CurrentHVCCItemIdx = SelectedWeaponIdx;
			// End:0x216
			break;
		// End:0x74
		case 1:
			CurrentHVCCType = 5;
			CurrentHVCCItemIdx = SelectedWheelSetIdx;
			// End:0x216
			break;
		// End:0x1C5
		case 0:
			CurrentHVCCType = 1;
			// End:0x1AF
			if(int(CurrentHVCCItemIdx) != int(SelectedVehicleIdx))
			{
				ActivePanel.SwapVehiclePreview(HVCC_MasterVehicleArray[int(SelectedVehicleIdx)]);
				FilterCustomizationArrays(SelectedVehicleIdx);
				SelectedWheelSetIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultWheelSetIdx;
				SelectedAddonIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultAddonIdx;
				SelectedSkinIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultSkinIdx;
				SelectedWeaponIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultWeaponIdx;
			}
			CurrentHVCCItemIdx = SelectedAddonIdx;
			// End:0x216
			break;
		// End:0x1EC
		case 3:
			CurrentHVCCType = 0;
			CurrentHVCCItemIdx = SelectedVehicleIdx;
			// End:0x216
			break;
		// End:0x213
		case 2:
			CurrentHVCCType = 3;
			CurrentHVCCItemIdx = SelectedSkinIdx;
			// End:0x216
			break;
		// End:0xFFFF
		default:
			break;
	}
	curInfo = GetCurrentCustomizationArray();
	// End:0x23D
	if(curInfo.Length > 0)
	{		
	}
	else
	{
		// End:0x13
		if(!(int(CurrentHVCCType) == int(InitialType)))
			goto J0x13;
	}
	// End:0x278
	if(int(CurrentHVCCItemIdx) == int(255))
	{
		CurrentHVCCItemIdx = 0;
	}
	UpdateCurrentItemDisplay(curInfo, InitialType);
	//return;	
}

function bool OpenHVCMenu(HaloVehicleCustomizationPanel myPanel)
{
	local array<HVCCInfo> curInfo;

	// End:0x186
	if((myPanel != none) && HVCC_MasterVehicleArray.Length > 0)
	{
		SelectedVehicleIdx = 0;
		CurrentHVCCItemIdx = 0;
		CurrentHVCCType = 0;
		FilterCustomizationArrays(SelectedVehicleIdx);
		// End:0x183
		if(int(CurrentHVCCType) != int(6))
		{
			ActivePanel = myPanel;
			curInfo = GetCurrentCustomizationArray();
			UpdateCurrentItemDisplay(curInfo, CurrentHVCCType);
			SelectedWheelSetIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultWheelSetIdx;
			SelectedAddonIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultAddonIdx;
			SelectedSkinIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultSkinIdx;
			SelectedWeaponIdx = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultWeaponIdx;
			InitializePreviews();
			return true;
		}		
	}
	else
	{
		LogInternal("!!! WARNING: NO VEHICLES IN THE MASTER ARRAY in OpenHVCMenu() !!!");
		return false;
	}
	//return ReturnValue;	
}

function InitializePreviews()
{
	ActivePanel.SwapVehiclePreview(HVCC_MasterVehicleArray[int(SelectedVehicleIdx)]);
	// End:0x98
	if((int(SelectedAddonIdx) != int(255)) && int(SelectedAddonIdx) < HVCC_FilteredAddonArray.Length)
	{
		ActivePanel.AttachPreviewCustomization(HVCC_FilteredAddonArray[int(SelectedAddonIdx)]);
	}
	// End:0xFC
	if((int(SelectedSkinIdx) != int(255)) && int(SelectedSkinIdx) < HVCC_FilteredSkinArray.Length)
	{
		ActivePanel.AttachPreviewCustomization(HVCC_FilteredSkinArray[int(SelectedSkinIdx)]);
	}
	//return;	
}

function FilterCustomizationArrays(byte vehicleArrayIdx)
{
	local int I;

	HVCC_FilteredAddonArray.Length = 0;
	HVCC_FilteredWheelsetArray.Length = 0;
	HVCC_FilteredSkinArray.Length = 0;
	HVCC_FilteredWeaponArray.Length = 0;
	SelectedWheelSetIdx = 255;
	SelectedAddonIdx = 255;
	SelectedSkinIdx = 0;
	SelectedWeaponIdx = 255;
	SelectedDecalIdx = 255;
	I = 0;
	J0x77:

	// End:0x144 [Loop If]
	if(I < HVCC_MasterAddonArray.Length)
	{
		// End:0x136
		if((HVCC_MasterVehicleArray[int(vehicleArrayIdx)].TargetVehicleClass == HVCC_MasterAddonArray[I].TargetVehicleClass) && HVCC_MasterAddonArray[I].Unlocked)
		{
			HVCC_FilteredAddonArray[HVCC_FilteredAddonArray.Length] = HVCC_MasterAddonArray[I];
		}
		I++;
		// [Loop Continue]
		goto J0x77;
	}
	I = 0;
	J0x14F:

	// End:0x1F0 [Loop If]
	if(I < HVCC_MasterWheelsetArray.Length)
	{
		// End:0x1E2
		if(HVCC_MasterVehicleArray[int(vehicleArrayIdx)].TargetVehicleClass == HVCC_MasterWheelsetArray[I].TargetVehicleClass)
		{
			HVCC_FilteredWheelsetArray[HVCC_FilteredWheelsetArray.Length] = HVCC_MasterWheelsetArray[I];
		}
		I++;
		// [Loop Continue]
		goto J0x14F;
	}
	I = 0;
	J0x1FB:

	// End:0x29C [Loop If]
	if(I < HVCC_MasterSkinArray.Length)
	{
		// End:0x28E
		if(HVCC_MasterVehicleArray[int(vehicleArrayIdx)].TargetVehicleClass == HVCC_MasterSkinArray[I].TargetVehicleClass)
		{
			HVCC_FilteredSkinArray[HVCC_FilteredSkinArray.Length] = HVCC_MasterSkinArray[I];
		}
		I++;
		// [Loop Continue]
		goto J0x1FB;
	}
	I = 0;
	J0x2A7:

	// End:0x348 [Loop If]
	if(I < HVCC_MasterWeaponArray.Length)
	{
		// End:0x33A
		if(HVCC_MasterVehicleArray[int(vehicleArrayIdx)].TargetVehicleClass == HVCC_MasterWeaponArray[I].TargetVehicleClass)
		{
			HVCC_FilteredWeaponArray[HVCC_FilteredWeaponArray.Length] = HVCC_MasterWeaponArray[I];
		}
		I++;
		// [Loop Continue]
		goto J0x2A7;
	}
	//return;	
}

function SelectCurrentIndex()
{
	switch(CurrentHVCCType)
	{
		// End:0x5A
		case 5:
			// End:0x57
			if(HVCC_FilteredWheelsetArray[int(CurrentHVCCItemIdx)].Unlocked)
			{
				SelectedWheelSetIdx = CurrentHVCCItemIdx;
			}
			// End:0x22F
			break;
		// End:0x157
		case 1:
			// End:0x154
			if(HVCC_FilteredAddonArray[int(CurrentHVCCItemIdx)].Unlocked)
			{
				SelectedAddonIdx = CurrentHVCCItemIdx;
				HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultAddonIdx = SelectedAddonIdx;
				ActivePanel.AttachPreviewCustomization(HVCC_FilteredAddonArray[int(SelectedAddonIdx)]);
				PlayMagicMoment(HVCC_FilteredAddonArray[int(SelectedAddonIdx)].MagicMomentEventName, ActivePanel.HVCCAddon_Preview);
			}
			// End:0x22F
			break;
		// End:0x19E
		case 0:
			// End:0x19B
			if(HVCC_MasterVehicleArray[int(CurrentHVCCItemIdx)].Unlocked)
			{
				SelectedVehicleIdx = CurrentHVCCItemIdx;
			}
			// End:0x22F
			break;
		// End:0x1E5
		case 3:
			// End:0x1E2
			if(HVCC_FilteredSkinArray[int(CurrentHVCCItemIdx)].Unlocked)
			{
				SelectedSkinIdx = CurrentHVCCItemIdx;
			}
			// End:0x22F
			break;
		// End:0x22C
		case 2:
			// End:0x229
			if(HVCC_FilteredWeaponArray[int(CurrentHVCCItemIdx)].Unlocked)
			{
				SelectedWeaponIdx = CurrentHVCCItemIdx;
			}
			// End:0x22F
			break;
		// End:0xFFFF
		default:
			break;
	}
	//return;	
}

function CloseHVCMenu()
{
	CurrentHVCCType = 6;
	// End:0x64
	if(ActivePanel != none)
	{
		ActivePanel.RemoveAllPreviewCustomizations();
		ActivePanel.DeactivatePanel();
		ActivePanel = none;
	}
	HVCC_FilteredAddonArray.Length = 0;
	HVCC_FilteredWheelsetArray.Length = 0;
	HVCC_FilteredSkinArray.Length = 0;
	HVCC_FilteredWeaponArray.Length = 0;
	//return;	
}

function HVCCInfo GetSelectedItemInfo(HaloVehicleCustomizationManager.HVCCType ItemType)
{
	switch(ItemType)
	{
		// End:0x3B
		case 5:
			return HVCC_FilteredWheelsetArray[int(GetSelectedIndex(ItemType))];
			// End:0xD4
			break;
		// End:0x63
		case 1:
			return HVCC_FilteredAddonArray[int(GetSelectedIndex(ItemType))];
			// End:0xD4
			break;
		// End:0x81
		case 0:
			return HVCC_MasterVehicleArray[int(SelectedVehicleIdx)];
			// End:0xD4
			break;
		// End:0xA9
		case 3:
			return HVCC_FilteredSkinArray[int(GetSelectedIndex(ItemType))];
			// End:0xD4
			break;
		// End:0xD1
		case 2:
			return HVCC_FilteredWeaponArray[int(GetSelectedIndex(ItemType))];
			// End:0xD4
			break;
		// End:0xFFFF
		default:
			break;
	}
	//return ReturnValue;	
}

function bool UnlockUpgrade(HaloVCustomizationComponent CustomizationPickupArchetype, Class<HaloVCustomizationComponent> CustomizationPickupClass)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x161 [Loop If]
	if(I < HVCC_MasterAddonArray.Length)
	{
		// End:0x153
		if(((CustomizationPickupArchetype != none) && HVCC_MasterAddonArray[I].ArchetypeToSpawn == CustomizationPickupArchetype) || (CustomizationPickupClass != none) && HVCC_MasterAddonArray[I].ClassToSpawn == CustomizationPickupClass)
		{
			HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).SendRemoteEvent(HVCC_MasterAddonArray[I].UnlockRemoteEventName);
			HVCC_MasterAddonArray[I].Unlocked = true;
			return true;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	I = 0;
	J0x16C:

	// End:0x2C2 [Loop If]
	if(I < HVCC_MasterWheelsetArray.Length)
	{
		// End:0x2B4
		if(((CustomizationPickupArchetype != none) && HVCC_MasterWheelsetArray[I].ArchetypeToSpawn == CustomizationPickupArchetype) || (CustomizationPickupClass != none) && HVCC_MasterWheelsetArray[I].ClassToSpawn == CustomizationPickupClass)
		{
			HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).SendRemoteEvent(HVCC_MasterWheelsetArray[I].UnlockRemoteEventName);
			HVCC_MasterWheelsetArray[I].Unlocked = true;
			return true;
		}
		I++;
		// [Loop Continue]
		goto J0x16C;
	}
	I = 0;
	J0x2CD:

	// End:0x423 [Loop If]
	if(I < HVCC_MasterSkinArray.Length)
	{
		// End:0x415
		if(((CustomizationPickupArchetype != none) && HVCC_MasterSkinArray[I].ArchetypeToSpawn == CustomizationPickupArchetype) || (CustomizationPickupClass != none) && HVCC_MasterSkinArray[I].ClassToSpawn == CustomizationPickupClass)
		{
			HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).SendRemoteEvent(HVCC_MasterSkinArray[I].UnlockRemoteEventName);
			HVCC_MasterSkinArray[I].Unlocked = true;
			return true;
		}
		I++;
		// [Loop Continue]
		goto J0x2CD;
	}
	I = 0;
	J0x42E:

	// End:0x584 [Loop If]
	if(I < HVCC_MasterWeaponArray.Length)
	{
		// End:0x576
		if(((CustomizationPickupArchetype != none) && HVCC_MasterWeaponArray[I].ArchetypeToSpawn == CustomizationPickupArchetype) || (CustomizationPickupClass != none) && HVCC_MasterWeaponArray[I].ClassToSpawn == CustomizationPickupClass)
		{
			HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).SendRemoteEvent(HVCC_MasterWeaponArray[I].UnlockRemoteEventName);
			HVCC_MasterWeaponArray[I].Unlocked = true;
			return true;
		}
		I++;
		// [Loop Continue]
		goto J0x42E;
	}
	return false;
	//return ReturnValue;	
}

function ProcessJoyStickInput(PlayerInput theInput)
{
	// End:0x5D
	if((theInput.aBaseY > 0.5000000) && TimeSinceLastJoystickYInput >= JoystickInputDelay)
	{
		TimeSinceLastJoystickYInput = 0.0000000;
		IncrementCurrentCategoryIndex();		
	}
	else
	{
		// End:0xB7
		if((theInput.aBaseY < -0.5000000) && TimeSinceLastJoystickYInput >= JoystickInputDelay)
		{
			TimeSinceLastJoystickYInput = 0.0000000;
			DecrementCurrentCategoryIndex();
		}
	}
	// End:0x114
	if((theInput.aStrafe > 0.5000000) && TimeSinceLastJoystickXInput >= JoystickInputDelay)
	{
		TimeSinceLastJoystickXInput = 0.0000000;
		IncrementCurrentItemIndex();		
	}
	else
	{
		// End:0x16E
		if((theInput.aStrafe < -0.5000000) && TimeSinceLastJoystickXInput >= JoystickInputDelay)
		{
			TimeSinceLastJoystickXInput = 0.0000000;
			DecrementCurrentItemIndex();
		}
	}
	// End:0x1B8
	if(theInput.aTurn > 0.5000000)
	{
		ActivePanel.RotateMeshRight();		
	}
	else
	{
		// End:0x1FF
		if(theInput.aTurn < -0.5000000)
		{
			ActivePanel.RotateMeshLeft();
		}
	}
	//return;	
}

function UpdateCurrentItemDisplay(array<HVCCInfo> curInfo, HaloVehicleCustomizationManager.HVCCType PreviousHVCCType)
{
	local HVCCInfo SelectedInfo;

	// End:0xCE
	if((int(PreviousHVCCType) == int(CurrentHVCCType)) || int(GetCurrentSelectedIndex()) != int(GetSelectedIndex(PreviousHVCCType)))
	{
		ActivePanel.RemovePreviewCustomization(CurrentHVCCItemInfo);
		// End:0xCE
		if(int(GetSelectedIndex(PreviousHVCCType)) != int(255))
		{
			SelectedInfo = GetSelectedItemInfo(PreviousHVCCType);
			ActivePanel.AttachPreviewCustomization(SelectedInfo);
		}
	}
	CurrentHVCCItemInfo = curInfo[int(CurrentHVCCItemIdx)];
	// End:0x167
	if(CurrentHVCCItemInfo.Unlocked)
	{
		// End:0x167
		if((int(CurrentHVCCType) != int(1)) || int(CurrentHVCCItemIdx) == int(GetCurrentSelectedIndex()))
		{
			ActivePanel.AttachPreviewCustomization(CurrentHVCCItemInfo);
		}
	}
	//return;	
}

function StartConfirm()
{
	CurrentConfirmCountdown = SecsRequiredToConfirm;
	//return;	
}

function AbortConfirm()
{
	CurrentConfirmCountdown = -1.0000000;
	//return;	
}

simulated function UpdateConfirmTimer(float DeltaTime)
{
	local HaloVCustomizationComponent spawnedComponent;
	local HaloVehicle SpawnedVehicle;
	local Vector vehicleSpawnPos;
	local Rotator vehicleSpawnRot;
	local IHaloDeployable deployable;
	local array< Class<HaloVCustomizationComponent> > BuiltCustomizations;

	// End:0xC00
	if(CurrentConfirmCountdown > 0.0000000)
	{
		CurrentConfirmCountdown -= DeltaTime;
		// End:0xC00
		if(CurrentConfirmCountdown <= 0.0000000)
		{
			ActivePanel.VehicleBuildPad.SkeletalMeshComponent.GetSocketWorldLocationAndRotation('VehicleBuildLoc', vehicleSpawnPos, vehicleSpawnRot);
			// End:0x198
			if(ActivePanel.PlayerController.DeployedVehicle != none)
			{
				ActivePanel.PlayerController.DeployedVehicle.KickOutAll();
				ActivePanel.PlayerController.DeployedVehicle.Destroy();
				ActivePanel.PlayerController.DeployedVehicle = none;
			}
			SpawnedVehicle = Spawn(HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].TargetVehicleClass,,, vehicleSpawnPos, vehicleSpawnRot);
			// End:0xBF1
			if(SpawnedVehicle != none)
			{
				ActivePanel.PlayerController.DeployedVehicle = SpawnedVehicle;
				// End:0x320
				if(HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].MagicMomentEventName != 'None')
				{
					MagicMomentStack.Add(1);
					MagicMomentStack[MagicMomentStack.Length - 1].EventName = HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].MagicMomentEventName;
					MagicMomentStack[MagicMomentStack.Length - 1].MMActor = SpawnedVehicle;
					SpawnedVehicle.SetHidden(true);
				}
				SpawnedVehicle.Mesh.WakeRigidBody();
				// End:0x69E
				if(((HVCC_FilteredAddonArray.Length > 0) && int(SelectedAddonIdx) < HVCC_FilteredAddonArray.Length) && HVCC_FilteredAddonArray[int(SelectedAddonIdx)].Unlocked)
				{
					// End:0x45F
					if(HVCC_FilteredAddonArray[int(SelectedAddonIdx)].ArchetypeToSpawn != none)
					{
						spawnedComponent = Spawn(HVCC_FilteredAddonArray[int(SelectedAddonIdx)].ArchetypeToSpawn.Class,,,,, HVCC_FilteredAddonArray[int(SelectedAddonIdx)].ArchetypeToSpawn);						
					}
					else
					{
						spawnedComponent = Spawn(HVCC_FilteredAddonArray[int(SelectedAddonIdx)].ClassToSpawn);
					}
					// End:0x69E
					if(spawnedComponent != none)
					{
						BuiltCustomizations[BuiltCustomizations.Length] = ((HVCC_FilteredAddonArray[int(SelectedAddonIdx)].ArchetypeToSpawn != none) ? HVCC_FilteredAddonArray[int(SelectedAddonIdx)].ArchetypeToSpawn.Class : HVCC_FilteredAddonArray[int(SelectedAddonIdx)].ClassToSpawn);
						SpawnedVehicle.SwapCustomization(spawnedComponent);
						HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultAddonIdx = SelectedAddonIdx;
						// End:0x69E
						if(HVCC_FilteredAddonArray[int(SelectedAddonIdx)].MagicMomentEventName != 'None')
						{
							MagicMomentStack.Add(1);
							MagicMomentStack[MagicMomentStack.Length - 1].EventName = HVCC_FilteredAddonArray[int(SelectedAddonIdx)].MagicMomentEventName;
							MagicMomentStack[MagicMomentStack.Length - 1].MMActor = spawnedComponent;
							spawnedComponent.SetHidden(true);
						}
					}
				}
				// End:0x9E7
				if(((HVCC_FilteredSkinArray.Length > 0) && int(SelectedSkinIdx) < HVCC_FilteredSkinArray.Length) && HVCC_FilteredSkinArray[int(SelectedSkinIdx)].Unlocked)
				{
					// End:0x7A8
					if(HVCC_FilteredSkinArray[int(SelectedSkinIdx)].ArchetypeToSpawn != none)
					{
						spawnedComponent = Spawn(HVCC_FilteredSkinArray[int(SelectedSkinIdx)].ArchetypeToSpawn.Class,,,,, HVCC_FilteredSkinArray[int(SelectedSkinIdx)].ArchetypeToSpawn);						
					}
					else
					{
						spawnedComponent = Spawn(HVCC_FilteredSkinArray[int(SelectedSkinIdx)].ClassToSpawn);
					}
					// End:0x9E7
					if(spawnedComponent != none)
					{
						BuiltCustomizations[BuiltCustomizations.Length] = ((HVCC_FilteredSkinArray[int(SelectedSkinIdx)].ArchetypeToSpawn != none) ? HVCC_FilteredSkinArray[int(SelectedSkinIdx)].ArchetypeToSpawn.Class : HVCC_FilteredSkinArray[int(SelectedSkinIdx)].ClassToSpawn);
						SpawnedVehicle.SwapCustomization(spawnedComponent);
						HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].DefaultSkinIdx = SelectedSkinIdx;
						// End:0x9E7
						if(HVCC_FilteredSkinArray[int(SelectedSkinIdx)].MagicMomentEventName != 'None')
						{
							MagicMomentStack.Add(1);
							MagicMomentStack[MagicMomentStack.Length - 1].EventName = HVCC_FilteredSkinArray[int(SelectedSkinIdx)].MagicMomentEventName;
							MagicMomentStack[MagicMomentStack.Length - 1].MMActor = spawnedComponent;
							spawnedComponent.SetHidden(true);
						}
					}
				}
				deployable = IHaloDeployable(SpawnedVehicle);
				// End:0xB3D
				if(NotEqual_InterfaceInterface(deployable, IHaloDeployable(none)))
				{
					deployable.SetDeployableCategory(2);
					deployable.SetDeployableName(HVCC_MasterVehicleArray[int(SelectedVehicleIdx)].Name);
					// End:0xAC5
					if(spawnedComponent != none)
					{
						deployable.SetCustomizations(BuiltCustomizations);
					}
					// End:0xB3A
					if(ActivePanel != none)
					{
						deployable.SetDeployableBase(ActivePanel);
						ActivePanel.PlayerController.NotifyOfDeployment(deployable);
					}					
				}
				else
				{
					WarnInternal(("Deploying " @ string(SpawnedVehicle)) @ " which does not implement IHaloDeployable from HaloVehicleCustomizationManager");
				}
				MagicMomentDeployTimer = 1.2500000;
				ActivePanel.PlayerController.GotoState('VehicleCustomizationBuildStateTransitionOut');
			}
			CurrentConfirmCountdown = -1.0000000;
		}
	}
	//return;	
}

simulated function float GetDeployConfirmPct()
{
	// End:0x19
	if(CurrentConfirmCountdown < 0.0000000)
	{
		return 0.0000000;
	}
	return 1.0000000 - FClamp(CurrentConfirmCountdown / SecsRequiredToConfirm, 0.0000000, 1.0000000);
	//return ReturnValue;	
}

simulated function bool PlayMagicMoment(name MagicMomentEventName, Actor EventInstigator)
{
	local array<SequenceObject> AllSeqEvents;
	local Sequence GameSeq;
	local int I;

	GameSeq = WorldInfo.GetGameSequence();
	// End:0x129
	if(GameSeq != none)
	{
		GameSeq.FindSeqObjectsByClass(Class'Engine.SeqEvent_RemoteEvent', true, AllSeqEvents);
		I = 0;
		J0x75:

		// End:0x129 [Loop If]
		if(I < AllSeqEvents.Length)
		{
			// End:0x11B
			if(SeqEvent_RemoteEvent(AllSeqEvents[I]).EventName == MagicMomentEventName)
			{
				// End:0x118
				if(SeqEvent_RemoteEvent(AllSeqEvents[I]).CheckActivate(WorldInfo, EventInstigator))
				{
					return true;
				}
				// [Explicit Break]
				goto J0x129;
			}
			I++;
			// [Loop Continue]
			goto J0x75;
		}
	}
	J0x129:

	return false;
	//return ReturnValue;	
}

function JsonObject Serialize()
{
	local JsonObject Data;
	local int I, Type;
	local HVCCInfo Info;

	Data = new Class'Engine.JsonObject';
	// End:0x591
	if(Data != none)
	{
		Data.SetStringValue("Name", PathName(self));
		Data.SetStringValue("ObjectArchetype", PathName(ObjectArchetype));
		I = 0;
		Type = 0;
		// End:0x153
		foreach HVCC_MasterAddonArray(Info)
		{
			// End:0x147
			if(Info.Unlocked)
			{
				Data.SetIntValue(("UnlockedVehicleAddOn_" $ string(I)) $ "_Type", Type);
				I++;
			}
			Type++;			
		}		
		Data.SetIntValue("UnlockedVehicleAddOnCount", I);
		I = 0;
		Type = 0;
		// End:0x253
		foreach HVCC_MasterWheelsetArray(Info)
		{
			// End:0x247
			if(Info.Unlocked)
			{
				Data.SetIntValue(("UnlockedVehicleWheelset_" $ string(I)) $ "_Type", Type);
				I++;
			}
			Type++;			
		}		
		Data.SetIntValue("UnlockedVehicleWheelsetCount", I);
		I = 0;
		Type = 0;
		// End:0x352
		foreach HVCC_MasterSkinArray(Info)
		{
			// End:0x346
			if(Info.Unlocked)
			{
				Data.SetIntValue(("UnlockedVehicleSkin_" $ string(I)) $ "_Type", Type);
				I++;
			}
			Type++;			
		}		
		Data.SetIntValue("UnlockedVehicleSkinCount", I);
		I = 0;
		Type = 0;
		// End:0x44E
		foreach HVCC_MasterDecalArray(Info)
		{
			// End:0x442
			if(Info.Unlocked)
			{
				Data.SetIntValue(("UnlockedVehicleDecal_" $ string(I)) $ "_Type", Type);
				I++;
			}
			Type++;			
		}		
		Data.SetIntValue("UnlockedVehicleDecalCount", I);
		I = 0;
		Type = 0;
		// End:0x54C
		foreach HVCC_MasterWeaponArray(Info)
		{
			// End:0x540
			if(Info.Unlocked)
			{
				Data.SetIntValue(("UnlockedVehicleWeapon_" $ string(I)) $ "_Type", Type);
				I++;
			}
			Type++;			
		}		
		Data.SetIntValue("UnlockedVehicleWeaponCount", I);
	}
	return Data;
	//return ReturnValue;	
}

function Deserialize(JsonObject Data)
{
	local int I, Cnt, Type;

	Cnt = Data.GetIntValue("UnlockedVehicleAddOnCount");
	I = 0;
	J0x4F:

	// End:0x1CF [Loop If]
	if(I < Cnt)
	{
		Type = Data.GetIntValue(("UnlockedVehicleAddOn_" $ string(I)) $ "_Type");
		HVCC_MasterAddonArray[Type].Unlocked = true;
		// End:0x192
		if(HVCC_MasterAddonArray[I].UnlockRemoteEventName != 'None')
		{
			HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).SendRemoteEvent(HVCC_MasterAddonArray[I].UnlockRemoteEventName);
		}
		LogInternal("Unlocked vehicle add-on type " $ string(Type));
		I++;
		// [Loop Continue]
		goto J0x4F;
	}
	Cnt = Data.GetIntValue("UnlockedVehicleWheelsetCount");
	I = 0;
	J0x221:

	// End:0x3A6 [Loop If]
	if(I < Cnt)
	{
		Type = Data.GetIntValue(("UnlockedVehicleWheelset_" $ string(I)) $ "_Type");
		HVCC_MasterWheelsetArray[Type].Unlocked = true;
		// End:0x367
		if(HVCC_MasterAddonArray[I].UnlockRemoteEventName != 'None')
		{
			HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).SendRemoteEvent(HVCC_MasterWheelsetArray[I].UnlockRemoteEventName);
		}
		LogInternal("Unlocked vehicle wheelset type " $ string(Type));
		I++;
		// [Loop Continue]
		goto J0x221;
	}
	Cnt = Data.GetIntValue("UnlockedVehicleSkinCount");
	I = 0;
	J0x3F4:

	// End:0x571 [Loop If]
	if(I < Cnt)
	{
		Type = Data.GetIntValue(("UnlockedVehicleSkin_" $ string(I)) $ "_Type");
		HVCC_MasterSkinArray[Type].Unlocked = true;
		// End:0x536
		if(HVCC_MasterSkinArray[I].UnlockRemoteEventName != 'None')
		{
			HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).SendRemoteEvent(HVCC_MasterSkinArray[I].UnlockRemoteEventName);
		}
		LogInternal("Unlocked vehicle skin type " $ string(Type));
		I++;
		// [Loop Continue]
		goto J0x3F4;
	}
	Cnt = Data.GetIntValue("UnlockedVehicleDecalCount");
	I = 0;
	J0x5C0:

	// End:0x73F [Loop If]
	if(I < Cnt)
	{
		Type = Data.GetIntValue(("UnlockedVehicleDecal_" $ string(I)) $ "_Type");
		HVCC_MasterDecalArray[Type].Unlocked = true;
		// End:0x703
		if(HVCC_MasterDecalArray[I].UnlockRemoteEventName != 'None')
		{
			HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).SendRemoteEvent(HVCC_MasterDecalArray[I].UnlockRemoteEventName);
		}
		LogInternal("Unlocked vehicle decal type " $ string(Type));
		I++;
		// [Loop Continue]
		goto J0x5C0;
	}
	Cnt = Data.GetIntValue("UnlockedVehicleWeaponCount");
	I = 0;
	J0x78F:

	// End:0x910 [Loop If]
	if(I < Cnt)
	{
		Type = Data.GetIntValue(("UnlockedVehicleWeapon_" $ string(I)) $ "_Type");
		HVCC_MasterWeaponArray[Type].Unlocked = true;
		// End:0x8D3
		if(HVCC_MasterWeaponArray[I].UnlockRemoteEventName != 'None')
		{
			HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).SendRemoteEvent(HVCC_MasterWeaponArray[I].UnlockRemoteEventName);
		}
		LogInternal("Unlocked vehicle weapon type " $ string(Type));
		I++;
		// [Loop Continue]
		goto J0x78F;
	}
	//return;	
}

defaultproperties
{
	CurrentHVCCType=HVCC_NONE
	SelectedWheelSetIdx=255
	SelectedAddonIdx=255
	SelectedVehicleIdx=255
	SelectedWeaponIdx=255
	SelectedDecalIdx=255
	CurrentVehicleInfo=(Name="None",Unlocked=true,IconPkgPath="",PreviewMesh=none,PreviewSocketName="None",TargetVehicleClassName="",TargetVehicleClass=none,MagicMomentEventName="None",UnlockRemoteEventName="None",ArchetypeToSpawn=none,ClassToSpawnName="",ClassToSpawn=none,DefaultAddonIdx=255,DefaultWheelSetIdx=255,DefaultWeaponIdx=255,DefaultSkinIdx=0,DefaultDecalIdx=255)
	CurrentHVCCItemInfo=(Name="None",Unlocked=true,IconPkgPath="",PreviewMesh=none,PreviewSocketName="None",TargetVehicleClassName="",TargetVehicleClass=none,MagicMomentEventName="None",UnlockRemoteEventName="None",ArchetypeToSpawn=none,ClassToSpawnName="",ClassToSpawn=none,DefaultAddonIdx=255,DefaultWheelSetIdx=255,DefaultWeaponIdx=255,DefaultSkinIdx=0,DefaultDecalIdx=255)
	JoystickInputDelay=0.2500000
	SecsRequiredToConfirm=0.0200000
	CurrentConfirmCountdown=-1.0000000
	MagicMomentDelay=1.9000000
	HVCC_MasterVehicleArray[0]=(Name="Warthog",Unlocked=true,IconPkgPath="MainHUD.VehicleCustomizationIcons.VCItem_Vehicle_Warthog",PreviewMesh=SkeletalMesh'Warthog.Vehicles.Warthog',PreviewSocketName="Warthog",TargetVehicleClassName="MegaHaloGameContent.HaloVehicle_ArcadeWarthog_Content",TargetVehicleClass=none,MagicMomentEventName="WarthogMagicMoment",UnlockRemoteEventName="None",ArchetypeToSpawn=none,ClassToSpawnName="",ClassToSpawn=none,DefaultAddonIdx=255,DefaultWheelSetIdx=255,DefaultWeaponIdx=255,DefaultSkinIdx=0,DefaultDecalIdx=255)
	HVCC_MasterVehicleArray[1]=(Name="Mongoose",Unlocked=false,IconPkgPath="MainHUD.VehicleCustomizationIcons.VCItem_Vehicle_Mongoose",PreviewMesh=SkeletalMesh'Mongoose.Mongoose_Final',PreviewSocketName="Mongoose",TargetVehicleClassName="MegaHaloGameContent.HaloVehicle_ArcadeMongoose_Content",TargetVehicleClass=none,MagicMomentEventName="None",UnlockRemoteEventName="None",ArchetypeToSpawn=none,ClassToSpawnName="",ClassToSpawn=none,DefaultAddonIdx=255,DefaultWheelSetIdx=255,DefaultWeaponIdx=255,DefaultSkinIdx=0,DefaultDecalIdx=255)
	HVCC_MasterVehicleArray[2]=(Name="Scorpion",Unlocked=false,IconPkgPath="MainHUD.VehicleCustomizationIcons.VCItem_Vehicle_Scorpion",PreviewMesh=SkeletalMesh'Scorpion.Scorpion_Final',PreviewSocketName="Scorpion",TargetVehicleClassName="MegaHaloGameContent.HaloVehicle_ArcadeScorpion_Content",TargetVehicleClass=none,MagicMomentEventName="None",UnlockRemoteEventName="None",ArchetypeToSpawn=none,ClassToSpawnName="",ClassToSpawn=none,DefaultAddonIdx=255,DefaultWheelSetIdx=255,DefaultWeaponIdx=255,DefaultSkinIdx=0,DefaultDecalIdx=255)
	HVCC_MasterAddonArray[0]=(Name="Winch",Unlocked=false,IconPkgPath="MainHUD.VehicleCustomizationIcons.VCItem_AddOn_Winch",PreviewMesh=SkeletalMesh'Winch_Addon.Winch_Addon',PreviewSocketName="None",TargetVehicleClassName="MegaHaloGameContent.HaloVehicle_ArcadeWarthog_Content",TargetVehicleClass=none,MagicMomentEventName="WinchMagicMoment",UnlockRemoteEventName="WinchUnlocked",ArchetypeToSpawn=none,ClassToSpawnName="MegaHaloGame.HVCCAddon_MagWinch",ClassToSpawn=none,DefaultAddonIdx=255,DefaultWheelSetIdx=255,DefaultWeaponIdx=255,DefaultSkinIdx=0,DefaultDecalIdx=255)
	HVCC_MasterSkinArray[0]=(Name="Warthog Default",Unlocked=true,IconPkgPath="MainHUD.VehicleCustomizationIcons.VCItem_Paint_WDefault",PreviewMesh=none,PreviewSocketName="None",TargetVehicleClassName="MegaHaloGameContent.HaloVehicle_ArcadeWarthog_Content",TargetVehicleClass=none,MagicMomentEventName="None",UnlockRemoteEventName="None",ArchetypeToSpawn=HVCCSkin'Warthog.Skins.DefaultWarthogSkin',ClassToSpawnName="",ClassToSpawn=none,DefaultAddonIdx=255,DefaultWheelSetIdx=255,DefaultWeaponIdx=255,DefaultSkinIdx=0,DefaultDecalIdx=255)
	HVCC_MasterSkinArray[1]=(Name="Desert Camo",Unlocked=true,IconPkgPath="MainHUD.VehicleCustomizationIcons.VCItem_Paint_WDesert",PreviewMesh=none,PreviewSocketName="None",TargetVehicleClassName="MegaHaloGameContent.HaloVehicle_ArcadeWarthog_Content",TargetVehicleClass=none,MagicMomentEventName="None",UnlockRemoteEventName="None",ArchetypeToSpawn=HVCCSkin'Warthog.Skins.DesertWarthogSkin',ClassToSpawnName="",ClassToSpawn=none,DefaultAddonIdx=255,DefaultWheelSetIdx=255,DefaultWeaponIdx=255,DefaultSkinIdx=0,DefaultDecalIdx=255)
	HVCC_MasterSkinArray[2]=(Name="Urban Style",Unlocked=true,IconPkgPath="MainHUD.VehicleCustomizationIcons.VCItem_Paint_WUrban",PreviewMesh=none,PreviewSocketName="None",TargetVehicleClassName="MegaHaloGameContent.HaloVehicle_ArcadeWarthog_Content",TargetVehicleClass=none,MagicMomentEventName="None",UnlockRemoteEventName="None",ArchetypeToSpawn=HVCCSkin'Warthog.Skins.UrbanWarthogSkin',ClassToSpawnName="",ClassToSpawn=none,DefaultAddonIdx=255,DefaultWheelSetIdx=255,DefaultWeaponIdx=255,DefaultSkinIdx=0,DefaultDecalIdx=255)
	HVCC_MasterSkinArray[3]=(Name="Stealth Camo",Unlocked=true,IconPkgPath="MainHUD.VehicleCustomizationIcons.VCItem_Paint_WStealth",PreviewMesh=none,PreviewSocketName="None",TargetVehicleClassName="MegaHaloGameContent.HaloVehicle_ArcadeWarthog_Content",TargetVehicleClass=none,MagicMomentEventName="None",UnlockRemoteEventName="None",ArchetypeToSpawn=HVCCSkin'Warthog.Skins.StealthWarthogSkin',ClassToSpawnName="",ClassToSpawn=none,DefaultAddonIdx=255,DefaultWheelSetIdx=255,DefaultWeaponIdx=255,DefaultSkinIdx=0,DefaultDecalIdx=255)
	HVCC_MasterSkinArray[4]=(Name="Covenant Colors",Unlocked=true,IconPkgPath="MainHUD.VehicleCustomizationIcons.VCItem_Paint_WCovenant",PreviewMesh=none,PreviewSocketName="None",TargetVehicleClassName="MegaHaloGameContent.HaloVehicle_ArcadeWarthog_Content",TargetVehicleClass=none,MagicMomentEventName="None",UnlockRemoteEventName="None",ArchetypeToSpawn=HVCCSkin'Warthog.Skins.CovenantWarthogSkin',ClassToSpawnName="",ClassToSpawn=none,DefaultAddonIdx=255,DefaultWheelSetIdx=255,DefaultWeaponIdx=255,DefaultSkinIdx=0,DefaultDecalIdx=255)
	HVCC_MasterSkinArray[5]=(Name="Utility Colors",Unlocked=true,IconPkgPath="MainHUD.VehicleCustomizationIcons.VCItem_Paint_WUtility",PreviewMesh=none,PreviewSocketName="None",TargetVehicleClassName="MegaHaloGameContent.HaloVehicle_ArcadeWarthog_Content",TargetVehicleClass=none,MagicMomentEventName="None",UnlockRemoteEventName="None",ArchetypeToSpawn=HVCCSkin'Warthog.Skins.UtilityWarthogSkin',ClassToSpawnName="",ClassToSpawn=none,DefaultAddonIdx=255,DefaultWheelSetIdx=255,DefaultWeaponIdx=255,DefaultSkinIdx=0,DefaultDecalIdx=255)
	CollisionType=COLLIDE_CustomDefault
}