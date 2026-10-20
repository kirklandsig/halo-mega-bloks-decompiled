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
	ProfileMappings[0]=(Id=1,Name="Controller Vibration",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=((Id=3,Name="Off"),(Id=0,Name="On")),MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[1]=(Id=2,Name="Invert Y",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=((Id=0,Name="Off"),(Id=1,Name="On")),MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[2]=(Id=13,Name="Controller Sensitivity",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=((Id=1,Name="No"),(Id=0,Name="Yes"),(Id=2,Name="None")),MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[3]=(Id=34,Name="Mark Auto-Aim Targets",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=((Id=0,Name="Off"),(Id=1,Name="On"),(Id=0,Name="Both")),MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[4]=(Id=35,Name="Storage Device Id",ColumnHeaderText="",MappingType=PVMT_RawValue,MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[5]=(Id=36,Name="Encounter Camera View Enabled",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=((Id=0,Name="Normal"),(Id=1,Name="Easy"),(Id=0,Name="Hard")),MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[6]=(Id=13,Name="Controller Sensitivity",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=((Id=0,Name="Medium"),(Id=1,Name="Low"),(Id=2,Name="High")),MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[7]=(Id=14,Name="First Preferred Color",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=((Id=0,Name="None"),(Id=1,Name="Black"),(Id=2,Name="White"),(Id=3,Name="Yellow"),(Id=4,Name="Orange"),(Id=5,Name="Pink"),(Id=6,Name="Red"),(Id=7,Name="Purple"),(Id=8,Name="Blue"),(Id=9,Name="Green"),(Id=10,Name="Brown"),(Id=11,Name="Silver")),MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[8]=(Id=15,Name="Second Preferred Color",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=((Id=0,Name="None"),(Id=1,Name="Black"),(Id=2,Name="White"),(Id=3,Name="Yellow"),(Id=4,Name="Orange"),(Id=5,Name="Pink"),(Id=6,Name="Red"),(Id=7,Name="Purple"),(Id=8,Name="Blue"),(Id=9,Name="Green"),(Id=10,Name="Brown"),(Id=11,Name="Silver")),MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[9]=(Id=16,Name="Auto Aim",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=((Id=0,Name="Off"),(Id=1,Name="On")),MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[10]=(Id=17,Name="Auto Center",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=((Id=0,Name="Off"),(Id=1,Name="On")),MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[11]=(Id=18,Name="Movement Control",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=((Id=0,Name="Left Thumbstick"),(Id=1,Name="Right Thumbstick")),MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[12]=(Id=19,Name="Transmission Preference",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=((Id=0,Name="Auto"),(Id=1,Name="Manual")),MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[13]=(Id=20,Name="Race Camera Preference",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=((Id=0,Name="Behind"),(Id=1,Name="Front"),(Id=2,Name="Inside")),MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[14]=(Id=21,Name="Brake Preference",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=((Id=0,Name="Trigger"),(Id=1,Name="Button")),MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[15]=(Id=22,Name="Accelerator Preference",ColumnHeaderText="",MappingType=PVMT_IdMapped,ValueMappings=((Id=0,Name="Trigger"),(Id=1,Name="Button")),MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
}