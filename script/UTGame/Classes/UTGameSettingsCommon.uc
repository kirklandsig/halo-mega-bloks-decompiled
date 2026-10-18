class UTGameSettingsCommon extends UDKGameSettingsCommon;

const GS_USERNAME_MAXLENGTH = 15;
const GS_PASSWORD_MAXLENGTH = 30;
const GS_MESSAGE_MAXLENGTH = 255;
const GS_EMAIL_MAXLENGTH = 50;
const GS_CDKEY_PART_MAXLENGTH = 4;
const CONTEXT_PRESENCE_MENUPRESENCE = 0;
const CONTEXT_GAME_MODE = 0x0000800B;
const CONTEXT_GAME_MODE_DM = 0;
const CONTEXT_GAME_MODE_CTF = 1;
const CONTEXT_GAME_MODE_WAR = 2;
const CONTEXT_GAME_MODE_VCTF = 3;
const CONTEXT_GAME_MODE_TDM = 4;
const CONTEXT_GAME_MODE_DUEL = 5;
const CONTEXT_GAME_MODE_CUSTOM = 6;
const CONTEXT_GAME_MODE_CAMPAIGN = 7;
const CONTEXT_BOTSKILL = 0;
const CONTEXT_MAPNAME = 1;
const CONTEXT_PURESERVER = 6;
const CONTEXT_LOCKEDSERVER = 7;
const CONTEXT_VSBOTS = 8;
const CONTEXT_CAMPAIGN = 9;
const CONTEXT_FORCERESPAWN = 10;
const CONTEXT_ALLOWKEYBOARD = 11;
const CONTEXT_FULLSERVER = 12;
const CONTEXT_EMPTYSERVER = 13;
const CONTEXT_DEDICATEDSERVER = 14;
const CONTEXT_MAPNAME_CUSTOM = 0;
const CONTEXT_BOTSKILL_NOVICE = 0;
const CONTEXT_BOTSKILL_AVERAGE = 1;
const CONTEXT_BOTSKILL_EXPERIENCED = 2;
const CONTEXT_BOTSKILL_SKILLED = 3;
const CONTEXT_BOTSKILL_ADEPT = 4;
const CONTEXT_BOTSKILL_MASTERFUL = 5;
const CONTEXT_BOTSKILL_INHUMAN = 6;
const CONTEXT_BOTSKILL_GODLIKE = 7;
const CONTEXT_GOALSCORE_5 = 0;
const CONTEXT_GOALSCORE_10 = 1;
const CONTEXT_GOALSCORE_15 = 2;
const CONTEXT_GOALSCORE_20 = 3;
const CONTEXT_GOALSCORE_30 = 4;
const CONTEXT_NUMBOTS = 0;
const CONTEXT_NUMBOTS_1 = 1;
const CONTEXT_NUMBOTS_2 = 2;
const CONTEXT_NUMBOTS_3 = 3;
const CONTEXT_NUMBOTS_4 = 4;
const CONTEXT_NUMBOTS_5 = 5;
const CONTEXT_NUMBOTS_6 = 6;
const CONTEXT_NUMBOTS_7 = 7;
const CONTEXT_NUMBOTS_8 = 8;
const CONTEXT_TIMELIMIT_5 = 0;
const CONTEXT_TIMELIMIT_10 = 1;
const CONTEXT_TIMELIMIT_15 = 2;
const CONTEXT_TIMELIMIT_20 = 3;
const CONTEXT_TIMELIMIT_30 = 4;
const CONTEXT_PURESERVER_NO = 0;
const CONTEXT_PURESERVER_YES = 1;
const CONTEXT_PURESERVER_ANY = 2;
const CONTEXT_LOCKEDSERVER_NO = 0;
const CONTEXT_LOCKEDSERVER_YES = 1;
const CONTEXT_CAMPAIGN_NO = 0;
const CONTEXT_CAMPAIGN_YES = 1;
const CONTEXT_FORCERESPAWN_NO = 0;
const CONTEXT_FORCERESPAWN_YES = 1;
const CONTEXT_ALLOWKEYBOARD_NO = 0;
const CONTEXT_ALLOWKEYBOARD_YES = 1;
const CONTEXT_ALLOWKEYBOARD_ANY = 2;
const CONTEXT_FULLSERVER_NO = 0;
const CONTEXT_FULLSERVER_YES = 1;
const CONTEXT_EMPTYSERVER_NO = 0;
const CONTEXT_EMPTYSERVER_YES = 1;
const CONTEXT_DEDICATEDSERVER_NO = 0;
const CONTEXT_DEDICATEDSERVER_YES = 1;
const CONTEXT_VSBOTS_NONE = 0;
const CONTEXT_VSBOTS_1_TO_2 = 1;
const CONTEXT_VSBOTS_1_TO_1 = 2;
const CONTEXT_VSBOTS_3_TO_2 = 3;
const CONTEXT_VSBOTS_2_TO_1 = 4;
const CONTEXT_VSBOTS_3_TO_1 = 5;
const CONTEXT_VSBOTS_4_TO_1 = 6;
const PROPERTY_NUMBOTS = 0x100000F7;
const PROPERTY_GOALSCORE = 0x100000F8;
const PROPERTY_TIMELIMIT = 0x100000F9;
const PROPERTY_LEADERBOARDRATING = 0x20000004;
const PROPERTY_EPICMUTATORS = 0x10000105;
const PROPERTY_CUSTOMMAPNAME = 0x40000001;
const PROPERTY_CUSTOMGAMEMODE = 0x40000002;
const PROPERTY_SERVERDESCRIPTION = 0x40000003;
const PROPERTY_CUSTOMMUTATORS = 0x40000004;
const QUERY_DM = 0;
const QUERY_TDM = 1;
const QUERY_CTF = 2;
const QUERY_VCTF = 3;
const QUERY_WAR = 4;
const QUERY_DUEL = 5;
const QUERY_CAMPAIGN = 6;
const STATS_VIEW_DM_PLAYER_ALLTIME = 1;
const STATS_VIEW_DM_RANKED_ALLTIME = 2;
const STATS_VIEW_DM_WEAPONS_ALLTIME = 3;
const STATS_VIEW_DM_VEHICLES_ALLTIME = 4;
const STATS_VIEW_DM_VEHICLEWEAPONS_ALLTIME = 5;
const STATS_VIEW_DM_VEHICLES_RANKED_ALLTIME = 6;
const STATS_VIEW_DM_VEHICLEWEAPONS_RANKED_ALLTIME = 7;
const STATS_VIEW_DM_WEAPONS_RANKED_ALLTIME = 8;

var databinding int MaxPlayers;
var databinding int MinNetPlayers;
var databinding string SteamServerId;

function SetOfficialMutatorBitmask(int MutatorBitMask)
{
	SetIntProperty(268435717, MutatorBitMask);
	//return;	
}

function BuildURL(out string OutURL)
{
	local int SettingIdx, OutValue;
	local float Ratio;
	local name SettingName, PropertyName;
	local string Description;

	OutURL = "";
	AppendDataBindingsToURL(OutURL);
	SettingIdx = 0;
	J0x2A:

	// End:0x323 [Loop If]
	if(SettingIdx < LocalizedSettings.Length)
	{
		SettingName = GetStringSettingName(LocalizedSettings[SettingIdx].Id);
		// End:0x315
		if(SettingName != 'None')
		{
			switch(LocalizedSettings[SettingIdx].Id)
			{
				// End:0x117
				case 0:					
					OutURL $= ("?Difficulty=" $ string(LocalizedSettings[SettingIdx].ValueIndex));
					// End:0x315
					break;
				// End:0x225
				case 8:
					// End:0x222
					if(GetStringSettingValue(8, OutValue))
					{
						Ratio = -1.0000000;
						switch(OutValue)
						{
							// End:0x16C
							case 1:
								Ratio = 0.5000000;
								// End:0x1E5
								break;
							// End:0x183
							case 2:
								Ratio = 1.0000000;
								// End:0x1E5
								break;
							// End:0x19A
							case 3:
								Ratio = 1.5000000;
								// End:0x1E5
								break;
							// End:0x1B1
							case 4:
								Ratio = 2.0000000;
								// End:0x1E5
								break;
							// End:0x1C8
							case 5:
								Ratio = 3.0000000;
								// End:0x1E5
								break;
							// End:0x1DF
							case 6:
								Ratio = 4.0000000;
								// End:0x1E5
								break;
							// End:0xFFFF
							default:
								// End:0x1E5
								break;
								break;
						}
						// End:0x222
						if(Ratio > float(0))
						{							
							OutURL $= ("?VsBots=" $ string(Ratio));
						}
					}
					// End:0x315
					break;
				// End:0x229
				case 1:
				// End:0x22E
				case 12:
				// End:0x233
				case 13:
				// End:0x23B
				case 14:
					// End:0x315
					break;
				// End:0x2BB
				case 11:
					// End:0x2B8
					if(Class'Engine.WorldInfo'.static.IsConsoleBuild(2))
					{						
						OutURL $= ((("?" $ string(SettingName)) $ "=") $ string(LocalizedSettings[SettingIdx].ValueIndex));
					}
					// End:0x315
					break;
				// End:0xFFFF
				default:					
					OutURL $= ((("?" $ string(SettingName)) $ "=") $ string(LocalizedSettings[SettingIdx].ValueIndex));
					// End:0x315
					break;
					break;
			}
		}
		SettingIdx++;
		// [Loop Continue]
		goto J0x2A;
	}
	SettingIdx = 0;
	J0x32E:

	// End:0x4B8 [Loop If]
	if(SettingIdx < Properties.Length)
	{
		PropertyName = GetPropertyName(Properties[SettingIdx].PropertyId);
		// End:0x4AA
		if(PropertyName != 'None')
		{
			switch(Properties[SettingIdx].PropertyId)
			{
				// End:0x3D2
				case 268435703:
					// End:0x4AA
					break;
				// End:0x435
				case 1073741827:
					Description = GetPropertyAsString(1073741827);					
					OutURL $= ("?ServerDescription=" $ (BlobToString(Description)));
					// End:0x4AA
					break;
				// End:0x43D
				case 268435717:
				// End:0x448
				case 1073741828:
					// End:0x4AA
					break;
				// End:0xFFFF
				default:					
					OutURL $= ((("?" $ string(PropertyName)) $ "=") $ (GetPropertyAsString(Properties[SettingIdx].PropertyId)));
					// End:0x4AA
					break;
					break;
			}
		}
		SettingIdx++;
		// [Loop Continue]
		goto J0x32E;
	}
	//return;	
}

function UpdateFromURL(const out string URL, GameInfo Game)
{
	local string Description, RealDescription, BotSkillString, BotCountString;

	super(Settings).UpdateFromURL(URL, Game);
	Description = GetPropertyAsString(1073741827);
	NumPublicConnections = Clamp(NumPublicConnections, 0, Game.MaxPlayers);
	NumPrivateConnections = Clamp(NumPrivateConnections, 0, Game.MaxPlayers - NumPublicConnections);
	// End:0xDF
	if(StringToBlob(Description, RealDescription))
	{
		SetStringProperty(1073741827, RealDescription);
	}
	SetMutators(URL);
	BotSkillString = Class'Engine.GameInfo'.static.ParseOption(URL, "Difficulty");
	// End:0x15F
	if(BotSkillString != "")
	{
		SetStringSettingValueByName('BotSkill', int(BotSkillString), true);
	}
	BotCountString = Class'Engine.GameInfo'.static.ParseOption(URL, "NumPlay");
	// End:0x1C7
	if(BotCountString != "")
	{
		SetIntProperty(268435703, int(BotCountString) - 1);
	}
	// End:0x249
	if((int(Game.WorldInfo.NetMode) == int(NM_DedicatedServer)) || Class'Engine.GameInfo'.static.HasOption(URL, "Dedicated"))
	{
		bIsDedicated = true;
	}
	// End:0x264
	if(bIsDedicated)
	{
		SetStringSettingValue(14, 1, true);
	}
	//return;	
}

function SetMutators(const out string URL)
{
	local DataStoreClient DSClient;
	local UTUIDataStore_MenuItems MenuDataStore;
	local string MutatorURLValue;
	local array<string> MutatorClassNames;

	DSClient = Class'Engine.UIInteraction'.static.GetDataStoreClient();
	// End:0xEE
	if(DSClient != none)
	{
		MenuDataStore = UTUIDataStore_MenuItems(DSClient.FindDataStore('UTMenuItems'));
		// End:0xEE
		if(MenuDataStore != none)
		{
			MutatorURLValue = Class'Engine.GameInfo'.static.ParseOption(URL, "Mutator");
			// End:0xEE
			if(MutatorURLValue != "")
			{
				ParseStringIntoArray(MutatorURLValue, MutatorClassNames, ",", true);
			}
		}
	}
	SetOfficialMutatorBitmask(GenerateMutatorBitmaskFromURL(MenuDataStore, MutatorClassNames));
	SetCustomMutators(MenuDataStore, MutatorClassNames);
	//return;	
}

function int GenerateMutatorBitmaskFromURL(UTUIDataStore_MenuItems MenuDataStore, out array<string> MutatorClassNames)
{
	local int Idx, EnabledMutatorBitmask;
	local string GameModeString;
	local UIDataStore_Registry Registry;
	local array<UIResourceDataProvider> Providers;
	local int I;
	local UTUIDataProvider_Mutator MutatorProvider;

	Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
	Registry.GetData("SelectedGameMode", GameModeString);
	Registry.SetData("SelectedGameMode", "");
	Idx = 0;
	J0xB4:

	// End:0x1E1 [Loop If]
	if(Idx < MutatorClassNames.Length)
	{
		MenuDataStore.GetResourceProviders('OfficialMutators', Providers);
		I = 0;
		J0x108:

		// End:0x1D3 [Loop If]
		if(I < Providers.Length)
		{
			MutatorProvider = UTUIDataProvider_Mutator(Providers[I]);
			// End:0x1C5
			if((MutatorProvider != none) && MutatorProvider.ClassName == MutatorClassNames[Idx])
			{
				EnabledMutatorBitmask = EnabledMutatorBitmask | (1 << I);
				MutatorClassNames.Remove(Idx--, 1);
			}
			I++;
			// [Loop Continue]
			goto J0x108;
		}
		Idx++;
		// [Loop Continue]
		goto J0xB4;
	}
	Registry.SetData("SelectedGameMode", GameModeString);
	return EnabledMutatorBitmask;
	//return ReturnValue;	
}

function SetCustomMutators(UTUIDataStore_MenuItems MenuDataStore, const out array<string> MutatorClassNames)
{
	local int Idx;
	local string CustomMutators, CustomMutatorDelimiter;
	local array<UIResourceDataProvider> Providers;
	local int I;
	local UTUIDataProvider_Mutator MutatorProvider;

	CustomMutatorDelimiter = Chr(28);
	Idx = 0;
	J0x19:

	// End:0x16F [Loop If]
	if(Idx < MutatorClassNames.Length)
	{
		MenuDataStore.GetResourceProviders('Mutators', Providers);
		I = 0;
		J0x6D:

		// End:0x161 [Loop If]
		if(I < Providers.Length)
		{
			MutatorProvider = UTUIDataProvider_Mutator(Providers[I]);
			// End:0x153
			if((MutatorProvider != none) && MutatorProvider.ClassName == MutatorClassNames[Idx])
			{
				// End:0x120
				if(CustomMutators != "")
				{					
					CustomMutators $= CustomMutatorDelimiter;
				}				
				CustomMutators $= MutatorProvider.FriendlyName;
			}
			I++;
			// [Loop Continue]
			goto J0x6D;
		}
		Idx++;
		// [Loop Continue]
		goto J0x19;
	}
	SetStringProperty(1073741828, CustomMutators);
	//return;	
}

defaultproperties
{
	MaxPlayers=16
	NumPublicConnections=16
	LocalizedSettings[0]=(Id=32779,ValueIndex=0,AdvertisementType=EOnlineDataAdvertisementType.ODAT_OnlineService)
	LocalizedSettings[1]=(Id=0,ValueIndex=2,AdvertisementType=EOnlineDataAdvertisementType.ODAT_OnlineService)
	LocalizedSettings[2]=(Id=1,ValueIndex=0,AdvertisementType=EOnlineDataAdvertisementType.ODAT_OnlineService)
	LocalizedSettings[3]=(Id=6,ValueIndex=1,AdvertisementType=EOnlineDataAdvertisementType.ODAT_OnlineService)
	LocalizedSettings[4]=(Id=7,ValueIndex=0,AdvertisementType=EOnlineDataAdvertisementType.ODAT_OnlineService)
	LocalizedSettings[5]=(Id=8,ValueIndex=0,AdvertisementType=EOnlineDataAdvertisementType.ODAT_OnlineService)
	LocalizedSettings[6]=(Id=9,ValueIndex=0,AdvertisementType=EOnlineDataAdvertisementType.ODAT_OnlineService)
	LocalizedSettings[7]=(Id=10,ValueIndex=0,AdvertisementType=EOnlineDataAdvertisementType.ODAT_OnlineService)
	LocalizedSettings[8]=(Id=11,ValueIndex=0,AdvertisementType=EOnlineDataAdvertisementType.ODAT_OnlineService)
	LocalizedSettings[9]=(Id=12,ValueIndex=0,AdvertisementType=EOnlineDataAdvertisementType.ODAT_OnlineService)
	LocalizedSettings[10]=(Id=13,ValueIndex=1,AdvertisementType=EOnlineDataAdvertisementType.ODAT_OnlineService)
	LocalizedSettings[11]=(Id=14,ValueIndex=0,AdvertisementType=EOnlineDataAdvertisementType.ODAT_OnlineService)
	Properties[0]=(PropertyId=1073741825,Data=(Type=ESettingsDataType.SDT_String,Value1=0),AdvertisementType=EOnlineDataAdvertisementType.ODAT_QoS)
	Properties[1]=(PropertyId=1073741826,Data=(Type=ESettingsDataType.SDT_String,Value1=0),AdvertisementType=EOnlineDataAdvertisementType.ODAT_QoS)
	Properties[2]=(PropertyId=268435704,Data=(Type=ESettingsDataType.SDT_Int32,Value1=20),AdvertisementType=EOnlineDataAdvertisementType.ODAT_OnlineService)
	Properties[3]=(PropertyId=268435705,Data=(Type=ESettingsDataType.SDT_Int32,Value1=20),AdvertisementType=EOnlineDataAdvertisementType.ODAT_OnlineService)
	Properties[4]=(PropertyId=268435703,Data=(Type=ESettingsDataType.SDT_Int32,Value1=5),AdvertisementType=EOnlineDataAdvertisementType.ODAT_OnlineService)
	Properties[5]=(PropertyId=1073741827,Data=(Type=ESettingsDataType.SDT_String,Value1=0),AdvertisementType=EOnlineDataAdvertisementType.ODAT_QoS)
	Properties[6]=(PropertyId=268435717,Data=(Type=ESettingsDataType.SDT_Int32,Value1=0),AdvertisementType=EOnlineDataAdvertisementType.ODAT_OnlineService)
	Properties[7]=(PropertyId=1073741828,Data=(Type=ESettingsDataType.SDT_String,Value1=0),AdvertisementType=EOnlineDataAdvertisementType.ODAT_QoS)
	LocalizedSettingsMappings[0]=(Id=32779,Name="GameMode",ColumnHeaderText="Game",ValueMappings=((Id=0,Name="Deathmatch",bIsWildcard=false),(Id=4,Name="Team Deathmatch",bIsWildcard=false),(Id=1,Name="Capture The Flag",bIsWildcard=false),(Id=3,Name="Vehicle CTF",bIsWildcard=false),(Id=2,Name="Warfare",bIsWildcard=false),(Id=5,Name="Duel",bIsWildcard=false),(Id=7,Name="Greed",bIsWildcard=false),(Id=6,Name="Campaign",bIsWildcard=false),(Id=0,Name="Custom",bIsWildcard=false)))
	LocalizedSettingsMappings[1]=(Id=0,Name="BotSkill",ColumnHeaderText="Bot Skill",ValueMappings=((Id=0,Name="Novice",bIsWildcard=false),(Id=1,Name="Average",bIsWildcard=false),(Id=2,Name="Experienced",bIsWildcard=false),(Id=3,Name="Skilled",bIsWildcard=false),(Id=4,Name="Adept",bIsWildcard=false),(Id=5,Name="Masterful",bIsWildcard=false),(Id=6,Name="Inhuman",bIsWildcard=false),(Id=7,Name="Godlike",bIsWildcard=false)))
	LocalizedSettingsMappings[2]=(Id=1,Name="MapName",ColumnHeaderText="Map",ValueMappings=((Id=0,Name="Custom",bIsWildcard=false)))
	LocalizedSettingsMappings[3]=(Id=6,Name="PureServer",ColumnHeaderText="Pure",ValueMappings=((Id=0,Name="No",bIsWildcard=false),(Id=1,Name="Yes",bIsWildcard=false)))
	LocalizedSettingsMappings[4]=(Id=7,Name="LockedServer",ColumnHeaderText="Locked",ValueMappings=((Id=0,Name="No",bIsWildcard=false),(Id=1,Name="Yes",bIsWildcard=false)))
	LocalizedSettingsMappings[5]=(Id=8,Name="VsBots",ColumnHeaderText="Vs Bots",ValueMappings=((Id=0,Name="Disabled",bIsWildcard=false),(Id=2,Name="1:1",bIsWildcard=false),(Id=3,Name="3:2",bIsWildcard=false),(Id=4,Name="2:1",bIsWildcard=false)))
	LocalizedSettingsMappings[6]=(Id=9,Name="Campaign",ColumnHeaderText="Campaign",ValueMappings=((Id=0,Name="No",bIsWildcard=false),(Id=1,Name="Yes",bIsWildcard=false)))
	LocalizedSettingsMappings[7]=(Id=10,Name="ForceRespawn",ColumnHeaderText="Forced Respawn",ValueMappings=((Id=0,Name="No",bIsWildcard=false),(Id=1,Name="Yes",bIsWildcard=false)))
	LocalizedSettingsMappings[8]=(Id=11,Name="AllowKeyboard",ColumnHeaderText="M/KB",ValueMappings=((Id=0,Name="No",bIsWildcard=false),(Id=1,Name="Yes",bIsWildcard=false)))
	LocalizedSettingsMappings[9]=(Id=12,Name="IsFullServer",ColumnHeaderText="Full",ValueMappings=((Id=0,Name="No",bIsWildcard=false),(Id=1,Name="Yes",bIsWildcard=false)))
	LocalizedSettingsMappings[10]=(Id=13,Name="IsEmptyServer",ColumnHeaderText="Empty",ValueMappings=((Id=0,Name="No",bIsWildcard=false),(Id=1,Name="Yes",bIsWildcard=false)))
	LocalizedSettingsMappings[11]=(Id=14,Name="IsDedicated",ColumnHeaderText="Dedicated",ValueMappings=((Id=0,Name="No",bIsWildcard=false),(Id=1,Name="Yes",bIsWildcard=false)))
	PropertyMappings[0]=(Id=1073741825,Name="CustomMapName",ColumnHeaderText="Map",MappingType=EPropertyValueMappingType.PVMT_RawValue,ValueMappings=none,PredefinedValues=none,MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	PropertyMappings[1]=(Id=1073741826,Name="CustomGameMode",ColumnHeaderText="Game",MappingType=EPropertyValueMappingType.PVMT_RawValue,ValueMappings=none,PredefinedValues=none,MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	PropertyMappings[2]=(Id=268435704,Name="GoalScore",ColumnHeaderText="Goal Score",MappingType=EPropertyValueMappingType.PVMT_PredefinedValues,ValueMappings=none,PredefinedValues=/* ERROR: System.Exception */,Type=ESettingsDataType.SDT_Int32,Value1=0)
	PropertyMappings[3]=(Type=ESettingsDataType.SDT_Int32,Value1=5)
	PropertyMappings[4]=(Type=ESettingsDataType.SDT_Int32,Value1=10)
	PropertyMappings[5]=(Type=ESettingsDataType.SDT_Int32,Value1=15)
	PropertyMappings[6]=(Type=ESettingsDataType.SDT_Int32,Value1=20)
	PropertyMappings[7]=(Type=ESettingsDataType.SDT_Int32,Value1=25)
}