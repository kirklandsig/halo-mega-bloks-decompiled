class HaloProfileSettings extends OnlineProfileSettings;

const MarkAutoAimTargets = 34;
const StorageDeviceId = 35;
const CameraEncounterViewEnabled = 36;

enum EHaloOptsOnOff
{
	HOOO_On,                        // 0
	HOOO_Off,                       // 1
	HOOO_MAX                        // 2
};

function bool GetControllerVibrationOption()
{
	local bool Retval;
	local int Value;

	GetProfileSettingValueId(1, Value);
	switch(Value)
	{
		// End:0x3C
		case 3:
			Retval = true;
			// End:0x61
			break;
		// End:0x4F
		case 0:
			Retval = false;
			// End:0x61
			break;
		// End:0xFFFF
		default:
			Retval = true;
			// End:0x61
			break;
			break;
	}
	return Retval;
	//return ReturnValue;	
}

function bool GetInvertMouseOption()
{
	local bool Retval;
	local int Value;

	GetProfileSettingValueId(2, Value);
	switch(Value)
	{
		// End:0x3C
		case 1:
			Retval = true;
			// End:0x61
			break;
		// End:0x4F
		case 0:
			Retval = false;
			// End:0x61
			break;
		// End:0xFFFF
		default:
			Retval = false;
			// End:0x61
			break;
			break;
	}
	return Retval;
	//return ReturnValue;	
}

defaultproperties
{
	ProfileSettingIds[0]=1
	ProfileSettingIds[1]=2
	ProfileSettingIds[2]=13
	ProfileSettingIds[3]=34
	ProfileSettingIds[4]=35
	ProfileSettingIds[5]=36
	DefaultSettings[0]=(Owner=OPPO_OnlineService,ProfileSetting=(PropertyId=1,Data=(Type=SDT_Int32,Value1=3),AdvertisementType=ODAT_DontAdvertise))
	DefaultSettings[1]=(Owner=OPPO_OnlineService,ProfileSetting=(PropertyId=2,Data=(Type=SDT_Int32,Value1=0),AdvertisementType=ODAT_DontAdvertise))
	DefaultSettings[2]=(Owner=OPPO_OnlineService,ProfileSetting=(PropertyId=13,Data=(Type=SDT_Int32,Value1=0),AdvertisementType=ODAT_DontAdvertise))
	DefaultSettings[3]=(Owner=OPPO_Game,ProfileSetting=(PropertyId=34,Data=(Type=SDT_Int32,Value1=0),AdvertisementType=ODAT_DontAdvertise))
	DefaultSettings[4]=(Owner=OPPO_Game,ProfileSetting=(PropertyId=35,Data=(Type=SDT_Int32,Value1=-1),AdvertisementType=ODAT_DontAdvertise))
	DefaultSettings[5]=(Owner=OPPO_Game,ProfileSetting=(PropertyId=36,Data=(Type=SDT_Int32,Value1=0),AdvertisementType=ODAT_DontAdvertise))
	VersionNumber=2
	ProfileMappings[0]=(Id=1,Name="Controller Vibration",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=/* ERROR: System.Exception */,Id=3,Name="Off")
	ProfileMappings[1]=(Id=0,Name="On")
	ProfileMappings[2]=(PredefinedValues=none,MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[3]=(Id=2,Name="Invert Y",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=/* ERROR: System.Exception */,Id=0,Name="Off")
	ProfileMappings[4]=(Id=1,Name="On")
	ProfileMappings[5]=(PredefinedValues=none,MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[6]=(Id=13,Name="Controller Sensitivity",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=/* ERROR: System.Exception */,Id=1,Name="No")
	ProfileMappings[7]=(Id=0,Name="Yes")
	ProfileMappings[8]=(Id=2,Name="None")
	ProfileMappings[9]=(PredefinedValues=none,MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[10]=(Id=34,Name="Mark Auto-Aim Targets",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=/* ERROR: System.Exception */,Id=0,Name="Off")
	ProfileMappings[11]=(Id=1,Name="On")
	ProfileMappings[12]=(Id=0,Name="Both")
	ProfileMappings[13]=(PredefinedValues=none,MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[14]=(Id=35,Name="Storage Device Id",ColumnHeaderText="",MappingType=PVMT_RawValue,ValueMappings=none,PredefinedValues=none,MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[15]=(Id=36,Name="Encounter Camera View Enabled",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=/* ERROR: System.Exception */,Id=0,Name="Normal")
}