class HaloPlayerPersistentData extends OnlinePlayerStorage;

const VersionNum = 0;
const SaveCountId = 1;
const CurrentMap = 2;

function int GetValue(int PersistentDataID)
{
	local int Data;

	// End:0x29
	if(GetProfileSettingValueInt(PersistentDataID, Data))
	{
		return Data;
	}
	AddSettingInt(PersistentDataID);
	return 0;
	//return ReturnValue;	
}

function SetValue(int PersistentDataID, int NewValue)
{
	local int OldValue;

	OldValue = GetValue(PersistentDataID);
	// End:0x50
	if(NewValue != OldValue)
	{
		SetProfileSettingValueInt(PersistentDataID, NewValue);
	}
	//return;	
}

defaultproperties
{
	VersionNumber=2
	ProfileMappings[0]=(Id=0,Name="None",ColumnHeaderText="",MappingType=PVMT_RawValue,ValueMappings=none,PredefinedValues=none,MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[1]=(Id=0,Name="None",ColumnHeaderText="",MappingType=PVMT_RawValue,ValueMappings=none,PredefinedValues=none,MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
	ProfileMappings[2]=(Id=2,Name="CurrentMap",ColumnHeaderText="",MappingType=PVMT_RawValue,ValueMappings=none,PredefinedValues=none,MinVal=0.0000000,MaxVal=0.0000000,RangeIncrement=0.0000000)
}