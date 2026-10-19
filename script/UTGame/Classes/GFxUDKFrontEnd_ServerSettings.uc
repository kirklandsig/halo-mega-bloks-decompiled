class GFxUDKFrontEnd_ServerSettings extends GFxUDKFrontEnd_SettingsBase within GFxMoviePlayer
	config(UI);

var bool bDataChangedByReqs;

function SetSelectedOptionSet()
{
	SelectedOptionSet = "Server";
	//return;	
}

function OnOptionChanged(EventData ev)
{
	local string OptionName;
	local UTGameSettingsCommon GameSettings;

	GameSettings = UTGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
	OptionName = string(SettingsList[ev.Index].Name);
	bDataChangedByReqs = false;
	// End:0x255
	if(((((OptionName == "MaxPlayers_PC") || OptionName == "MaxPlayers_Console") || OptionName == "PrivateSlots") || OptionName == "MinNumPlayers_PC") || OptionName == "MinNumPlayers_Console")
	{
		SaveState();
		// End:0x1C1
		if(GameSettings.MaxPlayers < GameSettings.NumPrivateConnections)
		{
			GameSettings.NumPrivateConnections = GameSettings.MaxPlayers;
			bDataChangedByReqs = true;
		}
		// End:0x24B
		if(GameSettings.MinNetPlayers > GameSettings.MaxPlayers)
		{
			GameSettings.MinNetPlayers = GameSettings.MaxPlayers;
			bDataChangedByReqs = true;
		}
		SaveState();
	}
	// End:0x26C
	if(bDataChangedByReqs)
	{
		UpdateListDataProvider();
	}
	//return;	
}

function SaveState()
{
	local int I, StepperSelectedIndex;
	local string ValueToSave, ControlType, SettingName;
	local GFxObject Data;
	local DataStoreClient DSClient;
	local string LocationPart, RelevantPart;
	local UIDataStore_Registry Registry;
	local UTUIDataStore_StringList StringListDataStore;
	local name MatchTypeName;
	local UTGameSettingsCommon LocalGameSettings;

	LocalGameSettings = UTGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
	I = 0;
	J0x3D:

	// End:0x72C [Loop If]
	if(I < SettingsList.Length)
	{
		Data = ListDataProvider.GetElementObject(I);
		RelevantPart = Split(SettingsList[I].DataStoreMarkup, ":", true);
		LocationPart = Left(SettingsList[I].DataStoreMarkup, Len(SettingsList[I].DataStoreMarkup) - (Len(RelevantPart) + 1));
		LocationPart = Right(LocationPart, Len(LocationPart) - 1);
		RelevantPart = Left(RelevantPart, Len(RelevantPart) - 1);
		ControlType = Data.GetString("control");
		switch(ControlType)
		{
			// End:0x5D1
			case "stepper":
				SettingName = Data.GetString("name");
				StepperSelectedIndex = int(Data.GetFloat("optIndex"));
				// End:0x330
				if(SettingName == "ServerType")
				{
					MatchTypeName = ((Class'Engine.WorldInfo'.static.IsConsoleBuild(1)) ? 'ServerType360' : 'ServerType');
					DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
					StringListDataStore = UTUIDataStore_StringList(DSClient.FindDataStore('UTStringList'));
					StringListDataStore.SetCurrentValueIndex(MatchTypeName, ((StepperSelectedIndex == 0) ? 0 : 1));					
				}
				else
				{
					ValueToSave = Data.GetObject("dataProvider").GetElementString(StepperSelectedIndex);
					// End:0x473
					if(bDataChangedByReqs)
					{
						// End:0x402
						if((SettingName == "MaxPlayers_PC") || SettingName == "MaxPlayers_Console")
						{
							ValueToSave = string(LocalGameSettings.MaxPlayers);							
						}
						else
						{
							// End:0x473
							if((SettingName == "MinNumPlayers_PC") || SettingName == "MinNumPlayers_Console")
							{
								ValueToSave = string(LocalGameSettings.MinNetPlayers);
							}
						}
					}
					// End:0x4E1
					if((SettingName == "MaxPlayers_PC") || SettingName == "MaxPlayers_Console")
					{
						LocalGameSettings.MaxPlayers = int(ValueToSave);						
					}
					else
					{
						// End:0x552
						if((SettingName == "MinNumPlayers_PC") || SettingName == "MinNumPlayers_Console")
						{
							LocalGameSettings.MinNetPlayers = int(ValueToSave);
						}
					}
					SettingsList[I].RangeData.CurrentValue = float(int(ValueToSave));
					LocalGameSettings.SetPropertyFromStringByName(name(RelevantPart), ValueToSave);
				}
				// End:0x71E
				break;
			// End:0x718
			case "input":
				SettingName = string(SettingsList[I].Name);
				ValueToSave = Data.GetString("text");
				// End:0x6C3
				if(LocationPart == "Registry")
				{
					Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
					Registry.SetData(RelevantPart, ValueToSave);
				}
				// End:0x715
				if(SettingName == "ServerDescription")
				{
					LocalGameSettings.SetPropertyFromStringByName('ServerDescription', ValueToSave);
				}
				// End:0x71E
				break;
			// End:0xFFFF
			default:
				// End:0x71E
				break;
				break;
		}
		I++;
		// [Loop Continue]
		goto J0x3D;
	}
	//return;	
}

function UpdateListDataProvider()
{
	local byte I, J;
	local string ControlType, DefaultValue;
	local int DefaultIndex;
	local GFxObject RendererDataProvider, DataProvider, TempObj;
	local UTGameSettingsCommon GameSettings;
	local string LocationPart, RelevantPart;
	local name MatchTypeName;
	local int StringIndex, StringIter, ChoiceIter;
	local bool bFoundDefault;
	local DataStoreClient DSClient;
	local UTUIDataStore_StringList StringListDataStore;
	local UIDataStore_Registry Registry;

	Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
	DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
	StringListDataStore = UTUIDataStore_StringList(DSClient.FindDataStore('UTStringList'));
	GameSettings = UTGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
	DataProvider = Outer.CreateArray();
	I = 0;
	J0x108:

	// End:0xC29 [Loop If]
	if(int(I) < SettingsList.Length)
	{
		bFoundDefault = false;
		TempObj = Outer.CreateObject("Object");
		TempObj.SetString("name", string(SettingsList[int(I)].Name));
		TempObj.SetString("label", Caps(SettingsList[int(I)].FriendlyName));
		ControlType = FindControlByUTClassName(SettingsList[int(I)].OptionType);
		TempObj.SetString("control", ControlType);
		RelevantPart = Split(SettingsList[int(I)].DataStoreMarkup, ":", true);
		LocationPart = Left(SettingsList[int(I)].DataStoreMarkup, Len(SettingsList[int(I)].DataStoreMarkup) - (Len(RelevantPart) + 1));
		LocationPart = Right(LocationPart, Len(LocationPart) - 1);
		RelevantPart = Left(RelevantPart, Len(RelevantPart) - 1);
		// End:0x766
		if(ControlType == "stepper")
		{
			RendererDataProvider = Outer.CreateArray();
			// End:0x699
			if((string(SettingsList[int(I)].Name) == "ServerType") || string(SettingsList[int(I)].Name) == "ServerType360")
			{
				StringIter = 0;
				J0x43A:

				// End:0x696 [Loop If]
				if(StringIter < StringListDataStore.StringData.Length)
				{
					// End:0x688
					if(string(StringListDataStore.StringData[StringIter].Tag) == RelevantPart)
					{
						RendererDataProvider.SetElementString(0, StringListDataStore.StringData[StringIter].Strings[0]);
						// End:0x605
						if(!Class'Engine.WorldInfo'.static.IsConsoleBuild(2))
						{
							ChoiceIter = 1;
							J0x540:

							// End:0x605 [Loop If]
							if(ChoiceIter < StringListDataStore.StringData[StringIter].Strings.Length)
							{
								RendererDataProvider.SetElementString(ChoiceIter, StringListDataStore.StringData[StringIter].Strings[ChoiceIter]);
								ChoiceIter++;
								// [Loop Continue]
								goto J0x540;
							}
						}
						MatchTypeName = ((Class'Engine.WorldInfo'.static.IsConsoleBuild(1)) ? 'ServerType360' : 'ServerType');
						DefaultIndex = StringListDataStore.GetCurrentValueIndex(MatchTypeName);
						bFoundDefault = true;
						// [Explicit Break]
						goto J0x696;
					}
					StringIter++;
					// [Loop Continue]
					goto J0x43A;
				}
				J0x696:
				
			}
			else
			{
				PopulateOptionDataProviderForIndex(int(I), RendererDataProvider, DefaultValue, DefaultIndex);
			}
			TempObj.SetBool("bUpdateFromUnreal", true);
			TempObj.SetObject("dataProvider", RendererDataProvider);
			TempObj.SetFloat("optIndex", float(DefaultIndex));
		}
		// End:0x8D1
		if(!bFoundDefault)
		{
			J = 0;
			J0x781:

			// End:0x8D1 [Loop If]
			if(int(J) < GameSettings.LocalizedSettings.Length)
			{
				StringIndex = InStr(RelevantPart, string(GameSettings.LocalizedSettingsMappings[int(J)].Name));
				// End:0x8C3
				if(StringIndex > -1)
				{
					DefaultValue = string(GameSettings.LocalizedSettingsMappings[int(J)].ValueMappings[GameSettings.LocalizedSettings[int(J)].ValueIndex].Name);
					bFoundDefault = true;
					// [Explicit Break]
					goto J0x8D1;
				}
				J++;
				// [Loop Continue]
				goto J0x781;
			}
		}
		J0x8D1:

		// End:0x935
		if(!bFoundDefault)
		{
			// End:0x935
			if(LocationPart == "Registry")
			{
				Registry.GetData(RelevantPart, DefaultValue);
				bFoundDefault = true;
			}
		}
		// End:0xA66
		if(!bFoundDefault)
		{
			// End:0xA66
			if(LocationPart == "UTGameSettings")
			{
				// End:0x9B8
				if(RelevantPart == "MinNetPlayers")
				{
					DefaultValue = string(GameSettings.MinNetPlayers);
					bFoundDefault = true;					
				}
				else
				{
					// End:0xA0B
					if(RelevantPart == "MaxPlayers")
					{
						DefaultValue = string(GameSettings.MaxPlayers);
						bFoundDefault = true;						
					}
					else
					{
						// End:0xA66
						if(RelevantPart == "NumPrivateConnections")
						{
							DefaultValue = string(GameSettings.NumPrivateConnections);
							bFoundDefault = true;
						}
					}
				}
			}
		}
		// End:0xAA9
		if(!bFoundDefault)
		{
			DefaultValue = GameSettings.GetPropertyAsStringByName(name(RelevantPart));
		}
		TempObj.SetString("text", DefaultValue);
		TempObj.SetBool("bNumericCombo", SettingsList[int(I)].bNumericCombo);
		TempObj.SetBool("bEditableCombo", SettingsList[int(I)].bEditableCombo);
		TempObj.SetFloat("editBoxMaxLength", float(SettingsList[int(I)].EditBoxMaxLength));
		DataProvider.SetElementObject(int(I), TempObj);
		I++;
		// [Loop Continue]
		goto J0x108;
	}
	ListMC.SetObject("dataProvider", DataProvider);
	ListDataProvider = ListMC.GetObject("dataProvider");
	//return;	
}

function PopulateOptionDataProviderForIndex(const int Index, out GFxObject OutDataProvider, out string OutDefaultValue, out int OutDefaultIndex)
{
	local int I, J;
	local UTUIDataProvider_MenuOption CurrentSetting;
	local UTGameSettingsCommon GameSettings;
	local int SettingIndex;

	GameSettings = UTGameSettingsCommon(SettingsDataStore.GetCurrentGameSettings());
	OutDefaultIndex = 0;
	SettingIndex = FindLocalizedSettingIndexByName(string(SettingsList[Index].Name));
	// End:0x1BB
	if(SettingIndex > -1)
	{
		I = 0;
		J0x99:

		// End:0x173 [Loop If]
		if(I < GameSettings.LocalizedSettingsMappings[SettingIndex].ValueMappings.Length)
		{
			OutDataProvider.SetElementString(I, string(GameSettings.LocalizedSettingsMappings[SettingIndex].ValueMappings[I].Name));
			I++;
			// [Loop Continue]
			goto J0x99;
		}
		OutDefaultIndex = GameSettings.LocalizedSettings[SettingIndex].ValueIndex;		
	}
	else
	{
		CurrentSetting = SettingsList[Index];
		J = 0;
		I = int(CurrentSetting.RangeData.MinValue);
		J0x220:

		// End:0x340 [Loop If]
		if(float(I) < CurrentSetting.RangeData.MaxValue)
		{
			OutDataProvider.SetElementString(J, string(I));
			// End:0x2E8
			if(float(I) == CurrentSetting.RangeData.CurrentValue)
			{
				OutDefaultIndex = J;
			}
			J++;
			I = int(float(I) + CurrentSetting.RangeData.NudgeValue);
			// [Loop Continue]
			goto J0x220;
		}
	}
	//return;	
}

function string FindControlByUTClassName(byte UTUIControlClass)
{
	switch(UTUIControlClass)
	{
		// End:0x25
		case 3:
			return "stepper";
			// End:0x45
			break;
		// End:0x35
		case 5:
			return "input";
			// End:0x45
			break;
		// End:0xFFFF
		default:
			return "stepper";
			break;
	}	
	// Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection. (Parameter 'index')
   at System.Collections.Generic.List`1.get_Item(Int32 index)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
	// 1 & Type:Switch Position:0x045
	//return ReturnValue;
	// Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection. (Parameter 'index')
   at System.Collections.Generic.List`1.get_Item(Int32 index)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
	// 1 & Type:Switch Position:0x045	
	// Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection. (Parameter 'index')
   at System.Collections.Generic.List`1.get_Item(Int32 index)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
	// 1 & Type:Switch Position:0x045
	// Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection. (Parameter 'index')
   at System.Collections.Generic.List`1.get_Item(Int32 index)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
	// 1 & Type:Switch Position:0x045
}

defaultproperties
{
	ViewTitle="SERVER SETTINGS"
}