class UTAchievementsBase extends Object within UTPlayerController;

enum EAchievementUnlockType
{
	EAUT_Count,                     // 0
	EAUT_Bitmask,                   // 1
	EAUT_ByteCount,                 // 2
	EAUT_MAX                        // 3
};

struct AchievementData
{
	var int Id;
	var UTAchievementsBase.EAchievementUnlockType UnlockType;
	var int UnlockCriteria;
	var int ProgressCriteria;
	var bool bDoUnlock;
	var bool bDoProgress;

	structdefaultproperties
	{
		Id=0
		UnlockType=EAchievementUnlockType.EAUT_Count
		UnlockCriteria=0
		ProgressCriteria=0
		bDoUnlock=false
		bDoProgress=false
	}
};

struct AchievementValue
{
	var int Id;
	var int Value;

	structdefaultproperties
	{
		Id=0
		Value=0
	}
};

var array<AchievementData> AchievementsArray;
var Class<OnlineStatsRead> AchievementStatsReadClass;
var Class<OnlineStatsWrite> AchievementStatsWriteClass;
var array<AchievementValue> AchievementValues;
var bool bInitializedAchievementValues;
var array<AchievementValue> DeferredAchievementUpdates;
var OnlineStatsRead AchievementStatsRead;
var int ReadStatsCount;

function Initialize()
{
	ReadAchievementStats();
	//return;	
}

function Cleanup()
{
	AchievementStatsRead = none;
	// End:0x142
	if(Outer.OnlineSub != none)
	{
		Outer.OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(ReadAchievementStatsComplete);
		Outer.OnlineSub.StatsInterface.ClearFlushOnlineStatsCompleteDelegate(FlushAchievementStatsComplete);
		Outer.OnlineSub.PlayerInterface.ClearUnlockAchievementCompleteDelegate(0, AchievementDone);
	}
	Outer.ClearTimer('ReadAchievementStats', self);
	//return;	
}

function UpdateAchievement(int AchievementId, optional int Value = 1, optional bool bSkipCommit)
{
	local bool bUnlockedAchievement;
	local int I, UnlockType, Progress, MaxProgress;
	local byte bUnlockEnabled, bProgressEnabled;

	// End:0xA2
	if(bInitializedAchievementValues!)
	{
		I = DeferredAchievementUpdates.Length;
		DeferredAchievementUpdates.Length = I + 1;
		DeferredAchievementUpdates[I].Id = AchievementId;
		DeferredAchievementUpdates[I].Value = Value;
		return;
	}
	// End:0x217
	if(Value != -1)
	{
		// End:0x1D8
		if(GetAchievementUnlockType(AchievementId, UnlockType, bUnlockEnabled))
		{
			// End:0x131
			if(UnlockType == 0)
			{
				bUnlockedAchievement = UpdateAchievementCount(AchievementId, Value, Progress, MaxProgress, bProgressEnabled);				
			}
			else
			{
				// End:0x185
				if(UnlockType == 1)
				{
					bUnlockedAchievement = UpdateAchievementBitMask(AchievementId, Value, Progress, MaxProgress, bProgressEnabled);					
				}
				else
				{
					// End:0x1BC
					if(UnlockType == 2)
					{
						bUnlockedAchievement = UpdateAchievementByteCount(AchievementId, Value);
					}
				}
			}
			// End:0x1D5
			if(bSkipCommit!)
			{
				WriteAchievementStats();
			}			
		}
		else
		{
			LogInternal("Failed to get unlock type for achievement " $ string(AchievementId));
		}		
	}
	else
	{
		bUnlockedAchievement = true;
	}
	// End:0x254
	if(bUnlockedAchievement)
	{
		// End:0x251
		if(bool(bUnlockEnabled))
		{
			UnlockAchievement(AchievementId);
		}		
	}
	else
	{
		// End:0x29A
		if(Progress != -1)
		{
			// End:0x29A
			if(bool(bProgressEnabled))
			{
				DisplayAchievementProgress(AchievementId, Progress, MaxProgress);
			}
		}
	}
	//return;	
}

function UnlockAchievement(int AchievementId)
{
	// End:0x1AE
	if((Outer.OnlineSub != none) && NotEqual_InterfaceInterface(Outer.OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
	{
		Outer.OnlineSub.PlayerInterface.AddUnlockAchievementCompleteDelegate(byte(LocalPlayer(Outer.Player).ControllerId), AchievementDone);
		// End:0x1AB
		if(Outer.OnlineSub.PlayerInterface.UnlockAchievement(byte(LocalPlayer(Outer.Player).ControllerId), AchievementId)!)
		{
			AchievementDone(false);
		}		
	}
	else
	{
		LogInternal("No online subsystem. Can't unlock an achievement");
	}
	//return;	
}

function AchievementDone(bool bWasSuccessful)
{
	// End:0x49
	if(bWasSuccessful!)
	{
		LogInternal("UTAchievements: Achievement unlock attempt has failed");
	}
	// End:0x116
	if((Outer.OnlineSub != none) && NotEqual_InterfaceInterface(Outer.OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
	{
		Outer.OnlineSub.PlayerInterface.ClearUnlockAchievementCompleteDelegate(0, AchievementDone);
	}
	//return;	
}

function DisplayAchievementProgress(int AchievementId, int Progress, int MaxProgress)
{
	//return;	
}

function bool UpdateAchievementBitMask(int AchievementId, int BitMask, optional out int Progress, optional out int MaxProgress, optional out byte bProgressEnabled)
{
	local bool bUnlocked;
	local int OldValue, Value, UnlockCriteria, ProgressCriteria, I, BitCount,
		BitMax;

	Progress = -1;
	MaxProgress = -1;
	// End:0x272
	if(GetAchievementValue(AchievementId, Value))
	{
		// End:0x22B
		if(GetAchievementUnlockCriteria(AchievementId, UnlockCriteria))
		{
			OldValue = Value;
			Value = Value | (BitMask & UnlockCriteria);
			// End:0x228
			if(OldValue != Value)
			{
				// End:0x1F2
				if(SetAchievementValue(AchievementId, Value))
				{
					bUnlocked = (Value & UnlockCriteria) == UnlockCriteria;
					// End:0x1EF
					if((bUnlocked! && GetAchievementProgressCriteria(AchievementId, ProgressCriteria, bProgressEnabled)) && ProgressCriteria > 0)
					{
						I = 1;
						J0x150:

						// End:0x1AF [Loop If]
						if(I <= UnlockCriteria)
						{
							// End:0x18B
							if(bool(Value & I))
							{
								BitCount++;
							}
							BitMax++;
							I = I << 1;
							// [Loop Continue]
							goto J0x150;
						}
						// End:0x1EF
						if((BitCount % ProgressCriteria) == 0)
						{
							Progress = BitCount;
							MaxProgress = BitMax;
						}
					}					
				}
				else
				{
					WarnInternal("Failed to set achievement bitmask for" @ string(AchievementId));
				}
			}			
		}
		else
		{
			WarnInternal(("Failed to find achievement" @ string(AchievementId)) @ "in achievements array");
		}		
	}
	else
	{
		WarnInternal("Failed to get achievement bitmask for" @ string(AchievementId));
	}
	return bUnlocked;
	//return ReturnValue;	
}

function bool UpdateAchievementCount(int AchievementId, optional int Count = 1, optional out int Progress, optional out int MaxProgress, optional out byte bProgressEnabled)
{
	local bool bUnlocked;
	local int Value, UnlockCriteria, ProgressCriteria;

	Progress = -1;
	MaxProgress = -1;
	// End:0x1D0
	if(GetAchievementValue(AchievementId, Value))
	{
		// End:0x1CD
		if(Count != 0)
		{
			Value += Count;
			// End:0x199
			if(SetAchievementValue(AchievementId, Value))
			{
				// End:0x152
				if(GetAchievementUnlockCriteria(AchievementId, UnlockCriteria))
				{
					bUnlocked = Value >= UnlockCriteria;
					// End:0x14F
					if((bUnlocked! && GetAchievementProgressCriteria(AchievementId, ProgressCriteria, bProgressEnabled)) && ProgressCriteria > 0)
					{
						// End:0x14F
						if((Value % ProgressCriteria) == 0)
						{
							Progress = Value;
							MaxProgress = UnlockCriteria;
						}
					}					
				}
				else
				{
					WarnInternal(("Failed to find achievement" @ string(AchievementId)) @ "in achievements array");
				}				
			}
			else
			{
				WarnInternal("Failed to set achievement count for" @ string(AchievementId));
			}
		}		
	}
	else
	{
		WarnInternal("Failed to get achievement count for" @ string(AchievementId));
	}
	return bUnlocked;
	//return ReturnValue;	
}

function bool UpdateAchievementByteCount(int AchievementId, int Counter)
{
	local bool bUnlocked;
	local int Value, Mask, OldValue, UnlockCriteria, I;

	local byte bUnlockedByte[4];

	// End:0x22D
	if(GetAchievementValue(AchievementId, Value))
	{
		Mask = 255 << (Counter * 8);
		// End:0x22A
		if((Value & Mask) != Mask)
		{
			OldValue = Value;
			Value += (1 << (Counter * 8));
			// End:0x22A
			if(Value != OldValue)
			{
				// End:0x1F6
				if(SetAchievementValue(AchievementId, Value))
				{
					// End:0x1AF
					if(GetAchievementUnlockCriteria(AchievementId, UnlockCriteria))
					{
						I = 0;
						J0xEA:

						// End:0x163 [Loop If]
						if(I < 4)
						{
							Mask = 255 << (I * 8);
							bUnlockedByte[I] = byte((Value & Mask) >= (UnlockCriteria & Mask));
							I++;
							// [Loop Continue]
							goto J0xEA;
						}
						bUnlocked = bool(((int(bUnlockedByte[0]) + int(bUnlockedByte[1])) + int(bUnlockedByte[2])) + int(bUnlockedByte[3]));						
					}
					else
					{
						WarnInternal(("Failed to find achievement" @ string(AchievementId)) @ "in achievements array");
					}					
				}
				else
				{
					WarnInternal("Failed to set achievement count for" @ string(AchievementId));
				}
			}
		}		
	}
	else
	{
		WarnInternal("Failed to get achievement count for" @ string(AchievementId));
	}
	return bUnlocked;
	//return ReturnValue;	
}

function bool GetAchievementValue(int AchievementId, out int Value)
{
	local bool bSuccess;
	local int AchievementIdx;

	// End:0x85
	if(bInitializedAchievementValues)
	{
		AchievementIdx = AchievementValues.Find('Id', AchievementId);
		// End:0x85
		if(AchievementIdx != -1)
		{
			Value = AchievementValues[AchievementIdx].Value;
			bSuccess = true;
		}
	}
	return bSuccess;
	//return ReturnValue;	
}

function bool SetAchievementValue(int AchievementId, int Value)
{
	local bool bSuccess;
	local int AchievementIdx;

	// End:0x85
	if(bInitializedAchievementValues)
	{
		AchievementIdx = AchievementValues.Find('Id', AchievementId);
		// End:0x85
		if(AchievementIdx != -1)
		{
			AchievementValues[AchievementIdx].Value = Value;
			bSuccess = true;
		}
	}
	return bSuccess;
	//return ReturnValue;	
}

final function bool GetAchievementUnlockCriteria(int AchievementId, out int UnlockCriteria)
{
	local bool bSuccess;
	local int I;

	I = 0;
	J0x0B:

	// End:0xA4 [Loop If]
	if(I < AchievementsArray.Length)
	{
		// End:0x96
		if(AchievementId == AchievementsArray[I].Id)
		{
			UnlockCriteria = AchievementsArray[I].UnlockCriteria;
			bSuccess = true;
			// [Explicit Break]
			goto J0xA4;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	J0xA4:

	return bSuccess;
	//return ReturnValue;	
}

final function bool GetAchievementProgressCriteria(int AchievementId, out int ProgressCriteria, optional out byte bProgressEnabled)
{
	local bool bSuccess;
	local int I;

	I = 0;
	J0x0C:

	// End:0xD8 [Loop If]
	if(I < AchievementsArray.Length)
	{
		// End:0xCA
		if(AchievementId == AchievementsArray[I].Id)
		{
			ProgressCriteria = AchievementsArray[I].ProgressCriteria;
			bProgressEnabled = byte(AchievementsArray[I].bDoProgress);
			bSuccess = true;
			// [Explicit Break]
			goto J0xD8;
		}
		I++;
		// [Loop Continue]
		goto J0x0C;
	}
	J0xD8:

	return bSuccess;
	//return ReturnValue;	
}

final function bool GetAchievementUnlockType(int AchievementId, out int UnlockType, optional out byte bUnlockEnabled)
{
	local bool bSuccess;
	local int I;

	I = 0;
	J0x0C:

	// End:0xDA [Loop If]
	if(I < AchievementsArray.Length)
	{
		// End:0xCC
		if(AchievementId == AchievementsArray[I].Id)
		{
			UnlockType = int(AchievementsArray[I].UnlockType);
			bUnlockEnabled = byte(AchievementsArray[I].bDoUnlock);
			bSuccess = true;
			// [Explicit Break]
			goto J0xDA;
		}
		I++;
		// [Loop Continue]
		goto J0x0C;
	}
	J0xDA:

	return bSuccess;
	//return ReturnValue;	
}

function ReadAchievementStats()
{
	local array<UniqueNetId> UIDList;

	Outer.ClearTimer('ReadAchievementStats', self);
	// End:0x275
	if(Outer.OnlineSub != none)
	{
		AchievementStatsRead = new AchievementStatsReadClass;
		// End:0x275
		if(AchievementStatsRead != none)
		{
			Outer.OnlineSub.StatsInterface.AddReadOnlineStatsCompleteDelegate(ReadAchievementStatsComplete);
			UIDList.AddItem(Outer.PlayerReplicationInfo.UniqueId);
			// End:0x26A
			if(Outer.OnlineSub.StatsInterface.ReadOnlineStats(UIDList, AchievementStatsRead)!)
			{
				Outer.OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(ReadAchievementStatsComplete);
				// End:0x211
				if(ReadStatsCount < 15)
				{
					ReadStatsCount++;
					Outer.SetTimer(1.0000000, true, 'ReadAchievementStats', self);					
				}
				else
				{
					LogInternal("UTAchievements: Failed to read achievement stats from online subsystem");
					ReadStatsCount = 0;
				}				
			}
			else
			{
				ReadStatsCount = 0;
			}
		}
	}
	//return;	
}

function ReadAchievementStatsComplete(bool bWasSuccessful)
{
	local int I, J, CurValue;

	// End:0x4D
	if(bWasSuccessful!)
	{
		LogInternal("UTAchievements: Failed to read online achievement stats");
		return;
	}
	I = 0;
	J0x58:

	// End:0x1F2 [Loop If]
	if(I < AchievementsArray.Length)
	{
		J = AchievementStatsRead.ColumnIds.Find(AchievementsArray[I].Id);
		// End:0x1E4
		if(J != -1)
		{
			// End:0x1E4
			if(AchievementStatsRead.GetIntStatValueForPlayer(Outer.PlayerReplicationInfo.UniqueId, J, CurValue))
			{
				J = AchievementValues.Length;
				AchievementValues.Length = J + 1;
				AchievementValues[J].Id = AchievementsArray[I].Id;
				AchievementValues[J].Value = CurValue;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x58;
	}
	bInitializedAchievementValues = true;
	AchievementStatsRead = none;
	Outer.OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(ReadAchievementStatsComplete);
	I = 0;
	J0x26F:

	// End:0x303 [Loop If]
	if(I < DeferredAchievementUpdates.Length)
	{
		UpdateAchievement(DeferredAchievementUpdates[I].Id, DeferredAchievementUpdates[I].Value, I != (DeferredAchievementUpdates.Length - 1));
		I++;
		// [Loop Continue]
		goto J0x26F;
	}
	DeferredAchievementUpdates.Length = 0;
	//return;	
}

function WriteAchievementStats()
{
	local OnlineStatsWrite StatsWriteObj;
	local int I;

	// End:0x311
	if(AchievementValues.Length > 0)
	{
		StatsWriteObj = new AchievementStatsWriteClass;
		// End:0x311
		if(StatsWriteObj != none)
		{
			I = 0;
			J0x42:

			// End:0xD3 [Loop If]
			if(I < AchievementValues.Length)
			{
				StatsWriteObj.SetIntStat(AchievementValues[I].Id, AchievementValues[I].Value);
				I++;
				// [Loop Continue]
				goto J0x42;
			}
			// End:0x2C8
			if(Outer.OnlineSub.StatsInterface.WriteOnlineStats('Game', Outer.PlayerReplicationInfo.UniqueId, StatsWriteObj))
			{
				Outer.OnlineSub.StatsInterface.AddFlushOnlineStatsCompleteDelegate(FlushAchievementStatsComplete);
				// End:0x2C5
				if(Outer.OnlineSub.StatsInterface.FlushOnlineStats('Game')!)
				{
					Outer.OnlineSub.StatsInterface.ClearFlushOnlineStatsCompleteDelegate(FlushAchievementStatsComplete);
					LogInternal("UTAchievements: Failed to flush achievement stats to online subsystem backend");
				}				
			}
			else
			{
				LogInternal("UTAchievements: Failed to write achievment stats to online subsystem");
			}
		}
	}
	//return;	
}

function FlushAchievementStatsComplete(name SessionName, bool bWasSuccessful)
{
	// End:0x4A
	if(bWasSuccessful!)
	{
		LogInternal("UTAchievements: Achievement stats flush attempt failed");
	}
	Outer.OnlineSub.StatsInterface.ClearFlushOnlineStatsCompleteDelegate(FlushAchievementStatsComplete);
	//return;	
}
