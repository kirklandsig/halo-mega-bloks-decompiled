class UIDataProvider_PlayerAchievements extends UIDataProvider_OnlinePlayerDataBase
	transient
	native
	config(Engine);

var transient array<AchievementDetails> Achievements;

// Export UUIDataProvider_PlayerAchievements::execGetTotalGamerScore(FFrame&, void* const)
native final function int GetTotalGamerScore();

// Export UUIDataProvider_PlayerAchievements::execGetMaxTotalGamerScore(FFrame&, void* const)
native final function int GetMaxTotalGamerScore();

function PopulateAchievementIcons()
{
	//return;	
}

function string GetAchievementIconPathName(int AchievementId, optional bool bReturnLockedIcon)
{
	//return ReturnValue;	
}

function GetAchievementDetails(const int AchievementId, out AchievementDetails OutAchievementDetails)
{
	local int Index;

	Index = Achievements.Find('Id', AchievementId);
	// End:0x59
	if(Index != -1)
	{
		OutAchievementDetails = Achievements[Index];
	}
	//return;	
}

function OnPlayerAchievementsChanged(int TitleId)
{
	local OnlineSubsystem OnlineSub;
	local OnlineSubsystem.EOnlineEnumerationReadState Result;

	// End:0x10D
	if(PlayerControllerId != -1)
	{
		OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
		// End:0x10D
		if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && TitleId == 0)
		{
			Result = OnlineSub.PlayerInterface.GetAchievements(byte(PlayerControllerId), Achievements, TitleId);
			// End:0x10D
			if(int(Result) == int(2))
			{
				PopulateAchievementIcons();
			}
		}
	}
	//return;	
}

function OnPlayerAchievementUnlocked(bool bWasSuccessful)
{
	// End:0x17
	if(bWasSuccessful)
	{
		UpdateAchievements();
	}
	//return;	
}

event OnRegister(LocalPlayer InPlayer)
{
	local OnlineSubsystem OnlineSub;

	super.OnRegister(InPlayer);
	// End:0x185
	if(PlayerControllerId != -1)
	{
		OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
		// End:0x185
		if(OnlineSub != none)
		{
			// End:0x185
			if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
			{
				OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
				OnlineSub.PlayerInterface.AddReadAchievementsCompleteDelegate(byte(PlayerControllerId), OnPlayerAchievementsChanged);
				OnlineSub.PlayerInterface.AddUnlockAchievementCompleteDelegate(byte(PlayerControllerId), OnPlayerAchievementUnlocked);
				UpdateAchievements();
			}
		}
	}
	//return;	
}

event OnUnregister()
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x18A
	if(OnlineSub != none)
	{
		// End:0xB3
		if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
		{
			OnlineSub.PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
		}
		// End:0x18A
		if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
		{
			OnlineSub.PlayerInterface.ClearUnlockAchievementCompleteDelegate(byte(PlayerControllerId), OnPlayerAchievementUnlocked);
			OnlineSub.PlayerInterface.ClearReadAchievementsCompleteDelegate(byte(PlayerControllerId), OnPlayerAchievementsChanged);
		}
	}
	Achievements.Length = 0;
	super.OnUnregister();
	//return;	
}

function OnLoginChange(byte LocalUserNum)
{
	// End:0x23
	if(int(LocalUserNum) == PlayerControllerId)
	{
		UpdateAchievements();
	}
	//return;	
}

function UpdateAchievements()
{
	local OnlineSubsystem OnlineSub;

	// End:0x165
	if(PlayerControllerId != -1)
	{
		Achievements.Length = 0;
		OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
		// End:0x165
		if((((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(PlayerControllerId))) > int(0)) && OnlineSub.PlayerInterface.IsGuestLogin(byte(PlayerControllerId))!)
		{
			OnlineSub.PlayerInterface.ReadAchievements(byte(PlayerControllerId));
		}
	}
	//return;	
}
