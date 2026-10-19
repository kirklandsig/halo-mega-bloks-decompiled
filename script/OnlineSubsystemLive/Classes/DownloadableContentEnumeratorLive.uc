class DownloadableContentEnumeratorLive extends DownloadableContentEnumerator
	native;

var transient int ReadsOutstanding;

function FindDLC()
{
	local OnlineSubsystem OnlineSub;
	local OnlineContentInterface ContentInt;
	local OnlinePlayerInterface PlayerInt;
	local int PlayerIndex;

	// End:0x21D
	if(ReadsOutstanding == 0)
	{
		DLCBundles.Length = 0;
		OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
		// End:0x21D
		if(OnlineSub != none)
		{
			PlayerInt = OnlineSub.PlayerInterface;
			// End:0x21D
			if(NotEqual_InterfaceInterface(PlayerInt, none))
			{
				ContentInt = OnlineSub.ContentInterface;
				// End:0x21D
				if(NotEqual_InterfaceInterface(ContentInt, none))
				{
					PlayerIndex = 0;
					J0xEE:

					// End:0x21D [Loop If]
					if(PlayerIndex < 4)
					{
						// End:0x1E2
						if((int(PlayerInt.GetLoginStatus(byte(PlayerIndex))) > 0) && !PlayerInt.IsGuestLogin(byte(PlayerIndex)))
						{
							ContentInt.AddReadContentComplete(byte(PlayerIndex), 0, OnReadContentComplete);
							ReadsOutstanding += int(ContentInt.ReadContentList(byte(PlayerIndex), 0));							
						}
						else
						{
							ContentInt.ClearContentList(byte(PlayerIndex), 0);
						}
						PlayerIndex++;
						// [Loop Continue]
						goto J0xEE;
					}
				}
			}
		}
	}
	// End:0x236
	if(ReadsOutstanding == 0)
	{
		TriggerFindDLCDelegates();
	}
	//return;	
}

function OnReadContentComplete(bool bWasSuccessful)
{
	local OnlineSubsystem OnlineSub;
	local OnlineContentInterface ContentInt;
	local int PlayerIndex;
	local array<OnlineContent> UserBundles;

	ReadsOutstanding--;
	// End:0x132
	if(ReadsOutstanding == 0)
	{
		OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
		// End:0x128
		if(OnlineSub != none)
		{
			ContentInt = OnlineSub.ContentInterface;
			// End:0x128
			if(NotEqual_InterfaceInterface(ContentInt, none))
			{
				PlayerIndex = 0;
				J0xA5:

				// End:0x128 [Loop If]
				if(PlayerIndex < 4)
				{
					UserBundles.Length = 0;
					ContentInt.GetContentList(byte(PlayerIndex), 0, UserBundles);
					// End:0x11A
					if(UserBundles.Length > 0)
					{
						AppendDLC(UserBundles);
					}
					PlayerIndex++;
					// [Loop Continue]
					goto J0xA5;
				}
			}
		}
		TriggerFindDLCDelegates();
	}
	//return;	
}

// Export UDownloadableContentEnumeratorLive::execAppendDLC(FFrame&, void* const)
native function AppendDLC(const out array<OnlineContent> Bundles);

function DeleteDLC(string DLCName)
{
	//return;	
}
