class Console extends Interaction within GameViewportClient
	transient
	native
	config(Input);

const MaxHistory = 16;

struct native AutoCompleteCommand
{
	var string Command;
	var string Desc;

	structdefaultproperties
	{
		Command=""
		Desc=""
	}
};

struct native AutoCompleteNode
{
	var int IndexChar;
	var init array<init int> AutoCompleteListIndices;
	var init array<init Pointer> ChildNodes;

	structdefaultproperties
	{
		IndexChar=0
		AutoCompleteListIndices=none
		ChildNodes=none
	}
};

var LocalPlayer ConsoleTargetPlayer;
var Texture2D DefaultTexture_Black;
var Texture2D DefaultTexture_White;
var globalconfig name ConsoleKey;
var globalconfig name TypeKey;
var globalconfig int MaxScrollbackSize;
var array<string> Scrollback;
var int SBHead;
var int SBPos;
var config int HistoryTop;
var config int HistoryBot;
var config int HistoryCur;
var config string History[16];
var transient bool bNavigatingHistory;
var transient bool bCaptureKeyInput;
var bool bCtrl;
var config bool bEnableUI;
var transient bool bAutoCompleteLocked;
var config bool bRequireCtrlToNavigateAutoComplete;
var transient bool bIsRuntimeAutoCompleteUpToDate;
var string TypedStr;
var int TypedStrPos;
var config array<config AutoCompleteCommand> ManualAutoCompleteList;
var transient array<AutoCompleteCommand> AutoCompleteList;
var transient int AutoCompleteIndex;
var native transient AutoCompleteNode AutoCompleteTree;
var transient array<int> AutoCompleteIndices;

function Initialized()
{
	super.Initialized();
	//return;	
}

function SetInputText(string Text)
{
	TypedStr = Text;
	//return;	
}

function SetCursorPos(int Position)
{
	TypedStrPos = Position;
	//return;	
}

function PurgeCommandFromHistory(string Command)
{
	local int HistoryIdx, Idx, NextIdx;

	// End:0x132
	if((HistoryTop >= 0) && HistoryTop < 16)
	{
		HistoryIdx = 0;
		J0x2C:

		// End:0x132 [Loop If]
		if(HistoryIdx < 16)
		{
			// End:0x124
			if(History[HistoryIdx] ~= Command)
			{
				Idx = HistoryIdx;
				NextIdx = (HistoryIdx + 1) % 16;
				J0x8A:

				// End:0xF8 [Loop If]
				if(Idx != HistoryTop)
				{
					History[Idx] = History[NextIdx];
					Idx = NextIdx;
					NextIdx = (NextIdx + 1) % 16;
					// [Loop Continue]
					goto J0x8A;
				}
				HistoryTop = ((HistoryTop == 0) ? 16 - 1 : HistoryTop - 1);
			}
			++HistoryIdx;
			// [Loop Continue]
			goto J0x2C;
		}
	}
	//return;	
}

function ConsoleCommand(string Command)
{
	// End:0xE3
	if(((HistoryTop == 0) ? !(History[16 - 1] ~= Command) : !(History[HistoryTop - 1] ~= Command)))
	{
		PurgeCommandFromHistory(Command);
		History[HistoryTop] = Command;
		HistoryTop = (HistoryTop + 1) % 16;
		// End:0xE3
		if((HistoryBot == -1) || HistoryBot == HistoryTop)
		{
			HistoryBot = (HistoryBot + 1) % 16;
		}
	}
	HistoryCur = HistoryTop;
	SaveConfig();
	OutputText(("\n>>>" @ Command) @ "<<<");
	// End:0x174
	if(ConsoleTargetPlayer != none)
	{		
		ConsoleTargetPlayer.Actor.ConsoleCommand(Command);		
	}
	else if((Outer.Outer.GamePlayers.Length > 0) && Outer.Outer.GamePlayers[0].Actor != none)
	{			
		Outer.Outer.GamePlayers[0].Actor.ConsoleCommand(Command);			
	}
	else
	{			
		Outer.ConsoleCommand(Command);
	}
	//return;	
}

function ClearOutput()
{
	SBHead = 0;
	Scrollback.Remove(0, Scrollback.Length);
	//return;	
}

function OutputTextLine(coerce string Text)
{
	// End:0x3E
	if(Scrollback.Length > MaxScrollbackSize)
	{
		Scrollback.Remove(0, 1);
		SBHead = MaxScrollbackSize - 1;		
	}
	else
	{
		SBHead++;
	}
	Scrollback.Length = Scrollback.Length + 1;
	Scrollback[SBHead] = Text;
	//return;	
}

event OutputText(coerce string Text)
{
	local string RemainingText;
	local int StringLength, LineLength;

	RemainingText = Text;
	StringLength = Len(Text);
	J0x28:

	// End:0xD2 [Loop If]
	if(StringLength > 0)
	{
		LineLength = InStr(RemainingText, "\n");
		// End:0x78
		if(LineLength == -1)
		{
			LineLength = StringLength;
		}
		OutputTextLine(Left(RemainingText, LineLength));
		RemainingText = Mid(RemainingText, LineLength + 1);
		StringLength -= (LineLength + 1);
		// [Loop Continue]
		goto J0x28;
	}
	//return;	
}

function StartTyping(coerce string Text)
{
	GotoState('Typing');
	SetInputText(Text);
	SetCursorPos(Len(Text));
	//return;	
}

function PostRender_Console(Canvas Canvas)
{
	//return;	
}

function bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed = 1.0000000, optional bool bGamepad = false)
{
	// End:0x97
	if(int(Event) == 0)
	{
		bCaptureKeyInput = false;
		// End:0x64
		if(Key == ConsoleKey)
		{
			GotoState('Open');
			bCaptureKeyInput = true;
			return true;			
		}
		else if(Key == TypeKey)
		{
			GotoState('Typing');
			bCaptureKeyInput = true;
			return true;
		}
	}
	return bCaptureKeyInput;
	//return ReturnValue;	
}

function bool InputChar(int ControllerId, string Unicode)
{
	return bCaptureKeyInput;
	//return ReturnValue;	
}

function FlushPlayerInput()
{
	local PlayerController PC;

	// End:0x3A
	if(ConsoleTargetPlayer != none)
	{
		PC = ConsoleTargetPlayer.Actor;		
	}
	else if((Outer.Outer.GamePlayers.Length > 0) && Outer.Outer.GamePlayers[0].Actor != none)
	{
		PC = Outer.Outer.GamePlayers[0].Actor;
	}
	// End:0x183
	if((PC != none) && PC.PlayerInput != none)
	{
		PC.PlayerInput.ResetInput();
	}
	//return;	
}

function bool ProcessControlKey(name Key, Object.EInputEvent Event)
{
	// End:0x78
	if((Key == 'LeftControl') || Key == 'RightControl')
	{
		// End:0x53
		if(int(Event) == 1)
		{
			bCtrl = false;			
		}
		else if(int(Event) == 0)
		{
			bCtrl = true;
		}
		return true;		
	}
	else if(((bCtrl && int(Event) == 0) && Outer.Outer.GamePlayers.Length > 0) && Outer.Outer.GamePlayers[0].Actor != none)
	{
		// End:0x1AF
		if(Key == 'V')
		{
			AppendInputText(Outer.Outer.GamePlayers[0].Actor.PasteFromClipboard());
			return true;				
		}
		else if(Key == 'C')
		{
			Outer.Outer.GamePlayers[0].Actor.CopyToClipboard(TypedStr);
			return true;					
		}
		else if(Key == 'X')
		{
			// End:0x2DB
			if(TypedStr != "")
			{
				Outer.Outer.GamePlayers[0].Actor.CopyToClipboard(TypedStr);
				SetInputText("");
				SetCursorPos(0);
			}
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function AppendInputText(string Text)
{
	local int Character;

	J0x00:
	// End:0xCC [Loop If]
	if(Len(Text) > 0)
	{
		Character = Asc(Left(Text, 1));
		Text = Mid(Text, 1);
		// End:0xC9
		if((Character >= 32) && Character < 256)
		{
			SetInputText((Left(TypedStr, TypedStrPos) $ Chr(Character)) $ Right(TypedStr, Len(TypedStr) - TypedStrPos));
			SetCursorPos(TypedStrPos + 1);
		}
		// [Loop Continue]
		goto J0x00;
	}
	UpdateCompleteIndices();
	//return;	
}

// Export UConsole::execBuildRuntimeAutoCompleteList(FFrame&, void* const)
native final function BuildRuntimeAutoCompleteList(optional bool bForce);

// Export UConsole::execUpdateCompleteIndices(FFrame&, void* const)
native function UpdateCompleteIndices();

state Typing
{
	function bool InputChar(int ControllerId, string Unicode)
	{
		// End:0x0F
		if(bCaptureKeyInput)
		{
			return true;
		}
		AppendInputText(Unicode);
		return true;
		//return ReturnValue;		
	}

	function bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed = 1.0000000, optional bool bGamepad = false)
	{
		local string Temp;
		local int NewPos, SpacePos, PeriodPos;

		// End:0x2E
		if(int(Event) == 0)
		{
			bCaptureKeyInput = false;
		}
		// End:0x52
		if(ProcessControlKey(Key, Event))
		{
			return true;			
		}
		else if(bGamepad)
		{
			return false;				
		}
		else if((Key == 'Escape') && int(Event) == 1)
		{
			// End:0xD0
			if(TypedStr != "")
			{
				SetInputText("");
				SetCursorPos(0);
				HistoryCur = HistoryTop;
				return true;						
			}
			else
			{
				GotoState('None');
			}
			return true;					
		}
		else if((Key == ConsoleKey) && int(Event) == 0)
		{
			GotoState('Open');
			bCaptureKeyInput = true;
			return true;						
		}
		else if((Key == TypeKey) && int(Event) == 0)
		{
			// End:0x1DB
			if((AutoCompleteIndices.Length > 0) && !bAutoCompleteLocked)
			{
				TypedStr = AutoCompleteList[AutoCompleteIndices[AutoCompleteIndex]].Command;
				SetCursorPos(Len(TypedStr));
				bAutoCompleteLocked = true;								
			}
			else
			{
				GotoState('None');
				bCaptureKeyInput = true;
			}
			return true;							
		}
		else if((Key == 'Enter') && int(Event) == 1)
		{
			// End:0x29B
			if(TypedStr != "")
			{
				Temp = TypedStr;
				SetInputText("");
				SetCursorPos(0);
				ConsoleCommand(Temp);
				OutputText("");
				GotoState('None');
				UpdateCompleteIndices();									
			}
			else
			{
				GotoState('None');
			}
			return true;								
		}
		else if(global.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad))
		{
			return true;									
		}
		else if((int(Event) != 0) && int(Event) != 2)
		{
			// End:0x36E
			if(!bGamepad)
			{
				return ((Key != 'LeftMouseButton') && Key != 'MiddleMouseButton') && Key != 'RightMouseButton';
			}
			return false;										
		}
		else if(Key == 'Up')
		{
			// End:0x413
			if(!bNavigatingHistory && (bRequireCtrlToNavigateAutoComplete && bCtrl) || (!bRequireCtrlToNavigateAutoComplete && !bCtrl) && AutoCompleteIndices.Length > 1)
			{
				// End:0x410
				if(++AutoCompleteIndex == AutoCompleteIndices.Length)
				{
					AutoCompleteIndex = 0;
				}												
			}
			else if(HistoryBot >= 0)
			{
				// End:0x44F
				if(HistoryCur == HistoryBot)
				{
					HistoryCur = HistoryTop;														
				}
				else
				{
					HistoryCur--;
					// End:0x478
					if(HistoryCur < 0)
					{
						HistoryCur = 16 - 1;
					}
				}
				SetInputText(History[HistoryCur]);
				SetCursorPos(Len(History[HistoryCur]));
				UpdateCompleteIndices();
				bNavigatingHistory = true;
			}
			return true;											
		}
		else if(Key == 'Down')
		{
			// End:0x57E
			if(!bNavigatingHistory && (bRequireCtrlToNavigateAutoComplete && bCtrl) || (!bRequireCtrlToNavigateAutoComplete && !bCtrl) && AutoCompleteIndices.Length > 1)
			{
				// End:0x56F
				if(--AutoCompleteIndex < 0)
				{
					AutoCompleteIndex = AutoCompleteIndices.Length - 1;
				}
				bAutoCompleteLocked = false;													
			}
			else if(HistoryBot >= 0)
			{
				// End:0x5BA
				if(HistoryCur == HistoryTop)
				{
					HistoryCur = HistoryBot;															
				}
				else
				{
					HistoryCur = (HistoryCur + 1) % 16;
				}
				SetInputText(History[HistoryCur]);
				SetCursorPos(Len(History[HistoryCur]));
				UpdateCompleteIndices();
				bNavigatingHistory = true;
			}
		}
		else if(Key == 'BackSpace')
		{
			// End:0x6B5
			if(TypedStrPos > 0)
			{
				SetInputText(Left(TypedStr, TypedStrPos - 1) $ Right(TypedStr, Len(TypedStr) - TypedStrPos));
				SetCursorPos(TypedStrPos - 1);
				bAutoCompleteLocked = false;
			}
			return true;													
		}
		else if(Key == 'Delete')
		{
			// End:0x72E
			if(TypedStrPos < Len(TypedStr))
			{
				SetInputText(Left(TypedStr, TypedStrPos) $ Right(TypedStr, (Len(TypedStr) - TypedStrPos) - 1));
			}
			return true;														
		}
		else if(Key == 'Left')
		{
			// End:0x7AE
			if(bCtrl)
			{
				NewPos = Max(InStr(TypedStr, ".", true, false, TypedStrPos), InStr(TypedStr, " ", true, false, TypedStrPos));
				SetCursorPos(Max(0, NewPos));																
			}
			else
			{
				SetCursorPos(Max(0, TypedStrPos - 1));
			}
			return true;															
		}
		else if(Key == 'Right')
		{
			// End:0x8E4
			if(bCtrl)
			{
				SpacePos = InStr(TypedStr, " ", false, false, TypedStrPos + 1);
				PeriodPos = InStr(TypedStr, ".", false, false, TypedStrPos + 1);
				NewPos = ((SpacePos < 0) ? PeriodPos : ((PeriodPos < 0) ? SpacePos : Min(SpacePos, PeriodPos)));
				// End:0x8B6
				if(NewPos == -1)
				{
					NewPos = Len(TypedStr);
				}
				SetCursorPos(Min(Len(TypedStr), Max(TypedStrPos, NewPos)));																	
			}
			else
			{
				SetCursorPos(Min(Len(TypedStr), TypedStrPos + 1));
			}
			return true;																
		}
		else if(Key == 'Home')
		{
			SetCursorPos(0);
			return true;																	
		}
		else if(Key == 'End')
		{
			SetCursorPos(Len(TypedStr));
			return true;
		}
		return true;
		//return ReturnValue;		
	}

	event PostRender_Console(Canvas Canvas)
	{
		local float Y, XL, YL, info_xl, info_yl, ClipX,
			ClipY, LeftPos;

		local string OutStr;
		local int MatchIdx, Idx, StartIdx;

		global.PostRender_Console(Canvas);
		Canvas.Font = Class'Engine.Engine'.static.GetSmallFont();
		OutStr = "(>" @ TypedStr;
		Canvas.StrLen(OutStr, XL, YL);
		ClipX = Canvas.ClipX;
		ClipY = Canvas.ClipY;
		LeftPos = 0.0000000;
		// End:0x153
		if(Class'Engine.WorldInfo'.static.IsConsoleBuild())
		{
			ClipX -= float(32);
			ClipY -= float(32);
			LeftPos = 32.0000000;
		}
		Canvas.SetPos(LeftPos, (ClipY - float(6)) - YL);
		Canvas.DrawTile(DefaultTexture_Black, ClipX, YL + float(6), 0.0000000, 0.0000000, 32.0000000, 32.0000000);
		Canvas.SetPos(LeftPos, (ClipY - float(6)) - YL);
		Canvas.SetDrawColor(0, 255, 0);
		Canvas.DrawTile(DefaultTexture_White, ClipX, 2.0000000, 0.0000000, 0.0000000, 32.0000000, 32.0000000);
		Canvas.SetPos(LeftPos, (ClipY - float(3)) - YL);
		Canvas.bCenter = false;
		Canvas.DrawText(OutStr, false);
		// End:0x961
		if(AutoCompleteIndices.Length > 0)
		{
			Idx = AutoCompleteIndices[AutoCompleteIndex];
			Canvas.SetPos(LeftPos + XL, (ClipY - float(3)) - YL);
			Canvas.SetDrawColor(87, 148, 87);
			Canvas.DrawText(Right(AutoCompleteList[Idx].Command, Len(AutoCompleteList[Idx].Command) - Len(TypedStr)), false);
			Canvas.StrLen("(>", XL, YL);
			StartIdx = AutoCompleteIndex - 5;
			// End:0x4D1
			if(StartIdx < 0)
			{
				StartIdx = Max(0, AutoCompleteIndices.Length + StartIdx);
			}
			Idx = StartIdx;
			Y = (ClipY - float(6)) - (YL * float(2));
			MatchIdx = 0;
			J0x519:

			// End:0x7A0 [Loop If]
			if(MatchIdx < 10)
			{
				OutStr = AutoCompleteList[AutoCompleteIndices[Idx]].Desc;
				Canvas.StrLen(OutStr, info_xl, info_yl);
				Y -= (info_yl - YL);
				Canvas.SetPos(LeftPos + XL, Y);
				Canvas.SetDrawColor(0, 0, 0);
				Canvas.DrawTile(DefaultTexture_White, info_xl, info_yl, 0.0000000, 0.0000000, 32.0000000, 32.0000000);
				Canvas.SetPos(LeftPos + XL, Y);
				// End:0x6ED
				if(Idx == AutoCompleteIndex)
				{
					Canvas.SetDrawColor(0, 255, 0);					
				}
				else
				{
					Canvas.SetDrawColor(0, 150, 0);
				}
				Canvas.DrawText(OutStr, false);
				// End:0x764
				if(++Idx >= AutoCompleteIndices.Length)
				{
					Idx = 0;
				}
				Y -= YL;
				// End:0x792
				if(Idx == StartIdx)
				{
					// [Explicit Break]
					goto J0x7A0;
				}
				MatchIdx++;
				// [Loop Continue]
				goto J0x519;
			}
			J0x7A0:

			// End:0x961
			if(AutoCompleteIndices.Length >= 10)
			{
				OutStr = ("[" $ string((AutoCompleteIndices.Length - 10) + 1)) @ "more matches]";
				Canvas.StrLen(OutStr, info_xl, info_yl);
				Canvas.SetPos(LeftPos + XL, Y);
				Canvas.SetDrawColor(0, 0, 0);
				Canvas.DrawTile(DefaultTexture_White, info_xl, info_yl, 0.0000000, 0.0000000, 32.0000000, 32.0000000);
				Canvas.SetPos(LeftPos + XL, Y);
				Canvas.SetDrawColor(0, 255, 0);
				Canvas.DrawText(OutStr, false);
			}
		}
		OutStr = "(>" @ Left(TypedStr, TypedStrPos);
		Canvas.StrLen(OutStr, XL, YL);
		Canvas.SetPos(LeftPos + XL, (ClipY - float(1)) - YL);
		Canvas.DrawText("_");
		//return;		
	}

	event BeginState(name PreviousStateName)
	{
		// End:0x21
		if(PreviousStateName == 'None')
		{
			FlushPlayerInput();
		}
		bCaptureKeyInput = true;
		HistoryCur = HistoryTop;
		//return;		
	}

	event EndState(name NextStateName)
	{
		bAutoCompleteLocked = false;
		//return;		
	}
	stop;	
}

state Open
{
	function bool InputChar(int ControllerId, string Unicode)
	{
		// End:0x0F
		if(bCaptureKeyInput)
		{
			return true;
		}
		AppendInputText(Unicode);
		return true;
		//return ReturnValue;		
	}

	function bool InputKey(int ControllerId, name Key, Object.EInputEvent Event, optional float AmountDepressed = 1.0000000, optional bool bGamepad = false)
	{
		local string Temp;

		// End:0x2E
		if(int(Event) == 0)
		{
			bCaptureKeyInput = false;
		}
		// End:0x52
		if(ProcessControlKey(Key, Event))
		{
			return true;			
		}
		else if(bGamepad)
		{
			return false;				
		}
		else if((Key == 'Escape') && int(Event) == 1)
		{
			// End:0xD0
			if(TypedStr != "")
			{
				SetInputText("");
				SetCursorPos(0);
				HistoryCur = HistoryTop;
				return true;						
			}
			else
			{
				GotoState('None');
			}					
		}
		else if((Key == ConsoleKey) && int(Event) == 0)
		{
			GotoState('None');
			bCaptureKeyInput = true;
			return true;						
		}
		else if((Key == TypeKey) && int(Event) == 0)
		{
			// End:0x1D1
			if((AutoCompleteIndices.Length > 0) && !bAutoCompleteLocked)
			{
				TypedStr = AutoCompleteList[AutoCompleteIndices[0]].Command;
				SetCursorPos(Len(TypedStr));
				bAutoCompleteLocked = true;								
			}
			else
			{
				GotoState('None');
				bCaptureKeyInput = true;
			}
			return true;							
		}
		else if((Key == 'Enter') && int(Event) == 1)
		{
			// End:0x294
			if(TypedStr != "")
			{
				Temp = TypedStr;
				SetInputText("");
				SetCursorPos(0);
				// End:0x277
				if(Temp ~= "cls")
				{
					ClearOutput();										
				}
				else
				{
					ConsoleCommand(Temp);
				}
				UpdateCompleteIndices();
			}
			return true;								
		}
		else if(global.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad))
		{
			return true;									
		}
		else if((int(Event) != 0) && int(Event) != 2)
		{
			// End:0x359
			if(!bGamepad)
			{
				return ((Key != 'LeftMouseButton') && Key != 'MiddleMouseButton') && Key != 'RightMouseButton';
			}
			return false;										
		}
		else if(Key == 'Up')
		{
			// End:0x428
			if(!bCtrl)
			{
				// End:0x425
				if(HistoryBot >= 0)
				{
					// End:0x3C0
					if(HistoryCur == HistoryBot)
					{
						HistoryCur = HistoryTop;														
					}
					else
					{
						HistoryCur--;
						// End:0x3E9
						if(HistoryCur < 0)
						{
							HistoryCur = 16 - 1;
						}
					}
					SetInputText(History[HistoryCur]);
					SetCursorPos(Len(History[HistoryCur]));
				}												
			}
			else if(SBPos < (Scrollback.Length - 1))
			{
				SBPos++;
				// End:0x47D
				if(SBPos >= Scrollback.Length)
				{
					SBPos = Scrollback.Length - 1;
				}
			}
			return true;											
		}
		else if(Key == 'Down')
		{
			// End:0x53D
			if(!bCtrl)
			{
				// End:0x53A
				if(HistoryBot >= 0)
				{
					// End:0x4E4
					if(HistoryCur == HistoryTop)
					{
						HistoryCur = HistoryBot;															
					}
					else
					{
						HistoryCur = (HistoryCur + 1) % 16;
					}
					SetInputText(History[HistoryCur]);
					SetCursorPos(Len(History[HistoryCur]));
				}													
			}
			else if(SBPos > 0)
			{
				SBPos--;
				// End:0x571
				if(SBPos < 0)
				{
					SBPos = 0;
				}
			}
			return true;												
		}
		else if(Key == 'BackSpace')
		{
			// End:0x602
			if(TypedStrPos > 0)
			{
				SetInputText(Left(TypedStr, TypedStrPos - 1) $ Right(TypedStr, Len(TypedStr) - TypedStrPos));
				SetCursorPos(TypedStrPos - 1);
				bAutoCompleteLocked = false;
			}
			return true;													
		}
		else if(Key == 'Delete')
		{
			// End:0x67B
			if(TypedStrPos < Len(TypedStr))
			{
				SetInputText(Left(TypedStr, TypedStrPos) $ Right(TypedStr, (Len(TypedStr) - TypedStrPos) - 1));
			}
			return true;														
		}
		else if(Key == 'Left')
		{
			SetCursorPos(Max(0, TypedStrPos - 1));
			return true;															
		}
		else if(Key == 'Right')
		{
			SetCursorPos(Min(Len(TypedStr), TypedStrPos + 1));
			return true;																
		}
		else if(bCtrl && Key == 'Home')
		{
			SBPos = 0;																	
		}
		else if(Key == 'Home')
		{
			SetCursorPos(0);
			return true;																		
		}
		else if(bCtrl && Key == 'End')
		{
			SBPos = Scrollback.Length - 1;																			
		}
		else if(Key == 'End')
		{
			SetCursorPos(Len(TypedStr));
			return true;																				
		}
		else if((Key == 'PageUp') || Key == 'MouseScrollUp')
		{
			// End:0x862
			if(SBPos < (Scrollback.Length - 1))
			{
				// End:0x828
				if(bCtrl)
				{
					SBPos += 5;																							
				}
				else
				{
					SBPos++;
				}
				// End:0x862
				if(SBPos >= Scrollback.Length)
				{
					SBPos = Scrollback.Length - 1;
				}
			}
			return true;																					
		}
		else if((Key == 'PageDown') || Key == 'MouseScrollDown')
		{
			// End:0x8E8
			if(SBPos > 0)
			{
				// End:0x8C3
				if(bCtrl)
				{
					SBPos -= 5;																								
				}
				else
				{
					SBPos--;
				}
				// End:0x8E8
				if(SBPos < 0)
				{
					SBPos = 0;
				}
			}
			return true;
		}
		return true;
		//return ReturnValue;		
	}

	event PostRender_Console(Canvas Canvas)
	{
		local float Height, XL, YL, Y, ScrollLineXL, ScrollLineYL,
			info_xl, info_yl;

		local string OutStr;
		local int Idx, MatchIdx;

		Canvas.Font = Class'Engine.Engine'.static.GetSmallFont();
		Height = Canvas.ClipY * 0.7500000;
		Canvas.SetDrawColor(255, 255, 255, 255);
		Canvas.SetPos(0.0000000, 0.0000000);
		Canvas.DrawTile(DefaultTexture_Black, Canvas.ClipX, Height, 0.0000000, 0.0000000, 32.0000000, 32.0000000);
		OutStr = "(>" @ TypedStr;
		Canvas.StrLen(OutStr, XL, YL);
		Canvas.SetPos(0.0000000, (Height - float(12)) - YL);
		Canvas.SetDrawColor(0, 255, 0);
		Canvas.DrawTile(DefaultTexture_White, Canvas.ClipX, 2.0000000, 0.0000000, 0.0000000, 32.0000000, 32.0000000);
		Canvas.SetPos(0.0000000, Height);
		Canvas.DrawTile(DefaultTexture_White, Canvas.ClipX, 2.0000000, 0.0000000, 0.0000000, 32.0000000, 32.0000000);
		Canvas.SetPos(0.0000000, (Height - float(5)) - YL);
		Canvas.bCenter = false;
		Canvas.DrawText(OutStr, false);
		// End:0x6E0
		if(AutoCompleteIndices.Length > 0)
		{
			Idx = AutoCompleteIndices[0];
			Canvas.SetPos(0.0000000 + XL, (Height - float(5)) - YL);
			Canvas.SetDrawColor(87, 148, 87);
			Canvas.DrawText(Right(AutoCompleteList[Idx].Command, Len(AutoCompleteList[Idx].Command) - Len(TypedStr)), false);
			Canvas.StrLen("(>", XL, YL);
			Y = Height + float(5);
			MatchIdx = 0;
			J0x4C8:

			// End:0x6E0 [Loop If]
			if((MatchIdx < AutoCompleteIndices.Length) && MatchIdx < 10)
			{
				Idx = AutoCompleteIndices[MatchIdx];
				Canvas.SetPos(0.0000000 + XL, Y);
				Canvas.StrLen(AutoCompleteList[Idx].Desc, info_xl, info_yl);
				Canvas.SetDrawColor(0, 0, 0);
				Canvas.DrawTile(DefaultTexture_White, info_xl, info_yl, 0.0000000, 0.0000000, 32.0000000, 32.0000000);
				Canvas.SetPos(0.0000000 + XL, Y);
				Canvas.SetDrawColor(0, 255, 0);
				Canvas.DrawText(AutoCompleteList[Idx].Desc, false);
				Y += info_yl;
				MatchIdx++;
				// [Loop Continue]
				goto J0x4C8;
			}
		}
		OutStr = "(>" @ Left(TypedStr, TypedStrPos);
		Canvas.StrLen(OutStr, XL, YL);
		Canvas.SetPos(XL, (Height - float(3)) - YL);
		Canvas.DrawText("_");
		Idx = SBHead - SBPos;
		Y = (Height - float(16)) - (YL * float(2));
		// End:0x801
		if(Scrollback.Length == 0)
		{
			return;
		}
		Canvas.SetDrawColor(255, 255, 255, 255);
		J0x828:

		// End:0x9B4 [Loop If]
		if((Y > YL) && Idx >= 0)
		{
			Canvas.SetPos(0.0000000, Y);
			Canvas.StrLen(Scrollback[Idx], ScrollLineXL, ScrollLineYL);
			// End:0x95C
			if(ScrollLineYL > YL)
			{
				Y -= (ScrollLineYL - YL);
				Canvas.SetPos(Canvas.CurX, Y, Canvas.CurZ);
			}
			Canvas.DrawText(Scrollback[Idx], false);
			Idx--;
			Y -= YL;
			// [Loop Continue]
			goto J0x828;
		}
		//return;		
	}

	event BeginState(name PreviousStateName)
	{
		bCaptureKeyInput = true;
		HistoryCur = HistoryTop;
		SBPos = 0;
		bCtrl = false;
		// End:0x57
		if(PreviousStateName == 'None')
		{
			FlushPlayerInput();
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	DefaultTexture_Black=Texture2D'EngineResources.Black'
	DefaultTexture_White=Texture2D'EngineResources.WhiteSquareTexture'
	ConsoleKey="Tilde"
	TypeKey="Tab"
	MaxScrollbackSize=1024
	HistoryBot=-1
	ManualAutoCompleteList[0]=(Command="Exit",Desc="Exit (Exits the game)")
	ManualAutoCompleteList[1]=(Command="DebugCreatePlayer 1",Desc="")
	ManualAutoCompleteList[2]=(Command="FreezeAt",Desc="Locks the player view and rendering time.")
	ManualAutoCompleteList[3]=(Command="SSSwapControllers",Desc="")
	ManualAutoCompleteList[4]=(Command="Open",Desc="Open <MapName> (Opens the specified map)")
	ManualAutoCompleteList[5]=(Command="DisplayAll",Desc="DisplayAll <ClassName> <PropertyName> (Display property values for instances of classname)")
	ManualAutoCompleteList[6]=(Command="DisplayAllState",Desc="DisplayAllState <ClassName> (Display state names for all instances of classname)")
	ManualAutoCompleteList[7]=(Command="DisplayClear",Desc="DisplayClear (Clears previous DisplayAll entries)")
	ManualAutoCompleteList[8]=(Command="FlushPersistentDebugLines",Desc="FlushPersistentDebugLines (Clears persistent debug line cache)")
	ManualAutoCompleteList[9]=(Command="GetAll ",Desc="GetAll <ClassName> <PropertyName> <Name=ObjectInstanceName> <OUTER=ObjectInstanceName> <SHOWDEFAULTS> <SHOWPENDINGKILLS> <DETAILED> (Log property values of all instances of classname)")
	ManualAutoCompleteList[10]=(Command="GetAllState",Desc="GetAllState <ClassName> (Log state names for all instances of classname)")
	ManualAutoCompleteList[11]=(Command="Obj List ",Desc="Obj List <Class=ClassName> <Type=MetaClass> <Outer=OuterObject> <Package=InsidePackage> <Inside=InsideObject>")
	ManualAutoCompleteList[12]=(Command="Obj ListContentRefs",Desc="Obj ListContentRefs <Class=ClassName> <ListClass=ClassName>")
	ManualAutoCompleteList[13]=(Command="Obj Classes",Desc="Obj Classes (Shows all classes)")
	ManualAutoCompleteList[14]=(Command="Obj Refs",Desc="Name=<ObjectName> Class=<OptionalObjectClass> Lists referencers of the specified object")
	ManualAutoCompleteList[15]=(Command="EditActor",Desc="EditActor <Class=ClassName> or <Name=ObjectName> or TRACE")
	ManualAutoCompleteList[16]=(Command="EditDefault",Desc="EditDefault <Class=ClassName>")
	ManualAutoCompleteList[17]=(Command="EditObject",Desc="EditObject <Class=ClassName> or <Name=ObjectName> or <ObjectName>")
	ManualAutoCompleteList[18]=(Command="ReloadCfg ",Desc="ReloadCfg <Class/ObjectName> (Reloads config variables for the specified object/class)")
	ManualAutoCompleteList[19]=(Command="ReloadLoc ",Desc="ReloadLoc <Class/ObjectName> (Reloads localized variables for the specified object/class)")
	ManualAutoCompleteList[20]=(Command="Set ",Desc="Set <ClassName> <PropertyName> <Value> (Sets property to value on objectname)")
	ManualAutoCompleteList[21]=(Command="Show BOUNDS",Desc="Show BOUNDS (Displays bounding boxes for all visible objects)")
	ManualAutoCompleteList[22]=(Command="Show BSP",Desc="Show BSP (Toggles BSP rendering)")
	ManualAutoCompleteList[23]=(Command="Show COLLISION",Desc="Show COLLISION (Toggles collision rendering)")
	ManualAutoCompleteList[24]=(Command="Show COVER",Desc="Show COVER (Toggles cover rendering)")
	ManualAutoCompleteList[25]=(Command="Show DECALS",Desc="Show DECALS (Toggles decal rendering)")
	ManualAutoCompleteList[26]=(Command="Show FOG",Desc="Show FOG (Toggles fog rendering)")
	ManualAutoCompleteList[27]=(Command="Show LEVELCOLORATION",Desc="Show LEVELCOLORATION (Toggles per-level coloration)")
	ManualAutoCompleteList[28]=(Command="Show LEVELSTREAMINGVOLUMES",Desc="Show LEVELSTREAMINGVOLUMES (Toggles LevelStreamingVolume rendering)")
	ManualAutoCompleteList[29]=(Command="Show PATHS",Desc="Show PATHS (Toggles path rendering)")
	ManualAutoCompleteList[30]=(Command="Show POSTPROCESS",Desc="Show POSTPROCESS (Toggles post process rendering)")
	ManualAutoCompleteList[31]=(Command="Show SKELMESHES",Desc="Show SKELMESHES (Toggles skeletal mesh rendering)")
	ManualAutoCompleteList[32]=(Command="Show TERRAIN",Desc="Show TERRAIN (Toggles terrain rendering)")
	ManualAutoCompleteList[33]=(Command="Show VOLUMES",Desc="Show VOLUMES (Toggles volume rendering, excepting LevelStreamingVolumes)")
	ManualAutoCompleteList[34]=(Command="Show SPLINES",Desc="Show SPLINES (Toggles spline rendering)")
	ManualAutoCompleteList[35]=(Command="ShowSet",Desc="Sets a show flag to enable it")
	ManualAutoCompleteList[36]=(Command="ShowClear",Desc="Clears a show flag to disable it")
	ManualAutoCompleteList[37]=(Command="Stat FPS",Desc="Stat FPS (Shows FPS counter)")
	ManualAutoCompleteList[38]=(Command="Stat UNIT",Desc="Stat UNIT (Shows hardware unit framerate)")
	ManualAutoCompleteList[39]=(Command="Stat LEVELS",Desc="Stat LEVELS (Displays level streaming info)")
	ManualAutoCompleteList[40]=(Command="Stat GAME",Desc="Stat GAME (Displays game performance stats)")
	ManualAutoCompleteList[41]=(Command="Stat MEMORY",Desc="Stat MEMORY (Displays memory stats)")
	ManualAutoCompleteList[42]=(Command="Stat XBOXMEMORY",Desc="Stat XBOXMEMORY (Displays Xbox memory stats while playing on PC)")
	ManualAutoCompleteList[43]=(Command="Stat PHYSICS",Desc="Stat PHYSICS (Displays physics performance stats)")
	ManualAutoCompleteList[44]=(Command="Stat STREAMING",Desc="Stat STREAMING (Displays basic texture streaming stats)")
	ManualAutoCompleteList[45]=(Command="Stat STREAMINGDETAILS",Desc="Stat STREAMINGDETAILS (Displays detailed texture streaming stats)")
	ManualAutoCompleteList[46]=(Command="Stat COLLISION",Desc="Stat COLLISION")
	ManualAutoCompleteList[47]=(Command="Stat PARTICLES",Desc="Stat PARTICLES")
	ManualAutoCompleteList[48]=(Command="Stat SCRIPT",Desc="Stat SCRIPT")
	ManualAutoCompleteList[49]=(Command="Stat AUDIO",Desc="Stat AUDIO")
	ManualAutoCompleteList[50]=(Command="Stat ANIM",Desc="Stat ANIM")
	ManualAutoCompleteList[51]=(Command="Stat NET",Desc="Stat NET")
	ManualAutoCompleteList[52]=(Command="Stat LIST",Desc="Stat LIST Groups/Sets/Group (List groups of stats, saved sets, or specific stats within a specified group)")
	ManualAutoCompleteList[53]=(Command="Stat splitscreen",Desc="")
	ManualAutoCompleteList[54]=(Command="ListTextures",Desc="ListTextures (Lists all loaded textures and their current memory footprint)")
	ManualAutoCompleteList[55]=(Command="ListUncachedStaticLightingInteractions",Desc="ListUncachedStaticLightingInteractions (Lists all uncached static lighting interactions, which causes Lighting needs to be rebuilt messages)")
	ManualAutoCompleteList[56]=(Command="RestartLevel",Desc="RestartLevel (restarts the level)")
	ManualAutoCompleteList[57]=(Command="ListSounds",Desc="ListSounds (Lists all the loaded sounds and their memory footprint)")
	ManualAutoCompleteList[58]=(Command="ListWaves",Desc="ListWaves (List the WaveInstances and whether they have a source)")
	ManualAutoCompleteList[59]=(Command="ListSoundClasses",Desc="ListSoundClasses (Lists a summary of loaded sound collated by class)")
	ManualAutoCompleteList[60]=(Command="ListSoundModes",Desc="ListSoundModes (Lists loaded sound modes)")
	ManualAutoCompleteList[61]=(Command="ListAudioComponents",Desc="ListAudioComponents (Dumps a detailed list of all AudioComponent objects)")
	ManualAutoCompleteList[62]=(Command="ListSoundDurations",Desc="ListSoundDurations")
	ManualAutoCompleteList[63]=(Command="PlaySoundCue",Desc="PlaySoundCue (Lists a summary of loaded sound collated by class)")
	ManualAutoCompleteList[64]=(Command="PlaySoundWave",Desc="PlaySoundWave")
	ManualAutoCompleteList[65]=(Command="SetSoundMode",Desc="SetSoundMode <ModeName>")
	ManualAutoCompleteList[66]=(Command="DisableLowPassFilter",Desc="DisableLowPassFilter")
	ManualAutoCompleteList[67]=(Command="DisableEQFilter",Desc="DisableEQFilter")
	ManualAutoCompleteList[68]=(Command="IsolateDryAudio",Desc="IsolateDryAudio")
	ManualAutoCompleteList[69]=(Command="IsolateReverb",Desc="IsolateReverb")
	ManualAutoCompleteList[70]=(Command="ResetSoundState",Desc="ResetSoundState (Resets volumes to default and removes test filters)")
	ManualAutoCompleteList[71]=(Command="ModifySoundClass",Desc="ModifySoundClass <SoundClassName> Vol=<new volume>")
	ManualAutoCompleteList[72]=(Command="DisableAllScreenMessages",Desc="Disables all on-screen warnings/messages")
	ManualAutoCompleteList[73]=(Command="EnableAllScreenMessages",Desc="Enables all on-screen warnings/messages")
	ManualAutoCompleteList[74]=(Command="ToggleAllScreenMessages",Desc="Toggles display state of all on-screen warnings/messages")
	ManualAutoCompleteList[75]=(Command="CaptureMode",Desc="Toggles display state of all on-screen warnings/messages")
	ManualAutoCompleteList[76]=(Command="ShowDebug NET",Desc="")
	ManualAutoCompleteList[77]=(Command="ShowDebug PHYSICS",Desc="")
	ManualAutoCompleteList[78]=(Command="ShowDebug COLLISION",Desc="")
	ManualAutoCompleteList[79]=(Command="ShowDebug AI",Desc="")
	ManualAutoCompleteList[80]=(Command="ShowDebug CAMERA",Desc="")
	ManualAutoCompleteList[81]=(Command="ShowDebug WEAPON",Desc="")
	ManualAutoCompleteList[82]=(Command="ShowDebug ANIMATION",Desc="")
	ManualAutoCompleteList[83]=(Command="ShowDebug INPUT",Desc="")
	ManualAutoCompleteList[84]=(Command="memleakcheck",Desc="")
	ManualAutoCompleteList[85]=(Command="togglehdwarning",Desc="")
	ManualAutoCompleteList[86]=(Command="Stat SOUNDWAVES",Desc="Stat SOUNDWAVES (Shows active SoundWaves)")
	ManualAutoCompleteList[87]=(Command="Stat SOUNDCUES",Desc="Stat SOUNDCUES (Shows active SoundCues)")
	ManualAutoCompleteList[88]=(Command="Stat SOUNDS",Desc="Stat SOUNDS <?> <sort=distance|class|name|waves|default> <-debug> <off> (Shows active SoundCues and SoundWaves)")
	ManualAutoCompleteList[89]=(Command="STARTMOVIECAPTURE",Desc="STARTMOVIECAPTURE")
	ManualAutoCompleteList[90]=(Command="STOPMOVIECAPTURE",Desc="STOPMOVIECAPTURE")
	ManualAutoCompleteList[91]=(Command="DoMemLeakChecking 30",Desc="Sets a timer to do a MemLeakCheck every N seconds")
	ManualAutoCompleteList[92]=(Command="StopMemLeakChecking",Desc="Stops the periodic MemLeakCheck that was started via DoMemLeakChecking")
	ManualAutoCompleteList[93]=(Command="Stat NAVIGATION",Desc="Stat NAVIGATION (Displays Navigation performance stats)")
	ManualAutoCompleteList[94]=(Command="GwNavDrawNavMesh",Desc="GwNavDrawNavMesh Toggles the display of the Navigation Navigation Mesh")
	ManualAutoCompleteList[95]=(Command="GwNavDrawNavMeshFamily",Desc="GwNavDrawNavMeshFamily <FamilyName> Display given Navigation Navigation Mesh Family. Use GwNavDrawNavMesh to turn off.")
	ManualAutoCompleteList[96]=(Command="GwNavDrawBot",Desc="GwNavDrawBot Toggles the display of the Navigation Bots")
	ManualAutoCompleteList[97]=(Command="GwNavDrawObstacle",Desc="GwNavDrawObstacle Toggles the display of the Navigation Obstacles")
	OnReceivedNativeInputKey=InputKey
	OnReceivedNativeInputChar=InputChar
}