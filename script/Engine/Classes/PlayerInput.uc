class PlayerInput extends Input within PlayerController
	transient
	native
	config(Input);

var const bool bUsingGamepad;
var globalconfig bool bInvertMouse;
var globalconfig bool bInvertTurn;
var bool bWasForward;
var bool bWasBack;
var bool bWasLeft;
var bool bWasRight;
var bool bEdgeForward;
var bool bEdgeBack;
var bool bEdgeLeft;
var bool bEdgeRight;
var globalconfig bool bEnableMouseSmoothing;
var bool bEnableFOVScaling;
var transient bool bLockTurnUntilRelease;
var const name LastAxisKeyName;
var float DoubleClickTimer;
var globalconfig float DoubleClickTime;
var globalconfig float MouseSensitivity;
var input float aBaseX;
var input float aBaseY;
var input float aBaseZ;
var input float aMouseX;
var input float aMouseY;
var input float aForward;
var input float aTurn;
var input float aStrafe;
var input float aUp;
var input float aLookUp;
var input float aRightAnalogTrigger;
var input float aLeftAnalogTrigger;
var input float aPS3AccelX;
var input float aPS3AccelY;
var input float aPS3AccelZ;
var input float aPS3Gyro;
var input float aWiiUPointerX;
var input float aWiiUPointerY;
var input Vector aTilt;
var input Vector aRotationRate;
var input Vector aGravity;
var input Vector aAcceleration;
var input Vector aTouch[5];
var input Vector aBackTouch[5];
var transient float RawJoyUp;
var transient float RawJoyRight;
var transient float RawJoyLookRight;
var transient float RawJoyLookUp;
var config float MoveForwardSpeed;
var config float MoveStrafeSpeed;
var config float LookRightScale;
var config float LookUpScale;
var input byte bStrafe;
var input byte bXAxis;
var input byte bYAxis;
var float ZeroTime[2];
var float SmoothedMouse[2];
var int MouseSamples;
var float MouseSamplingTotal;
var transient float AutoUnlockTurnTime;

// Export UPlayerInput::execCancelMobileInput(FFrame&, void* const)
native function CancelMobileInput();

exec function bool InvertMouse()
{
	bInvertMouse = !bInvertMouse;
	SaveConfig();
	return bInvertMouse;
	//return ReturnValue;	
}

exec function bool InvertTurn()
{
	bInvertTurn = !bInvertTurn;
	SaveConfig();
	return bInvertTurn;
	//return ReturnValue;	
}

exec function SetSensitivity(float F)
{
	MouseSensitivity = F;
	//return;	
}

function DrawHUD(HUD H)
{
	//return;	
}

function PreProcessInput(float DeltaTime)
{
	//return;	
}

function PostProcessInput(float DeltaTime)
{
	//return;	
}

function AdjustMouseSensitivity(float FOVScale)
{
	aMouseX *= (MouseSensitivity * FOVScale);
	aMouseY *= (MouseSensitivity * FOVScale);
	//return;	
}

event PlayerInput(float DeltaTime)
{
	local float FOVScale, TimeScale;

	RawJoyUp = aBaseY;
	RawJoyRight = aStrafe;
	RawJoyLookRight = aTurn;
	RawJoyLookUp = aLookUp;
	DeltaTime /= Outer.WorldInfo.TimeDilation;
	// End:0x12A
	if(Outer.bDemoOwner && int(Outer.WorldInfo.NetMode) == int(NM_Client))
	{
		DeltaTime /= Outer.WorldInfo.DemoPlayTimeDilation;
	}
	PreProcessInput(DeltaTime);
	TimeScale = 100.0000000 * DeltaTime;
	aBaseY *= (TimeScale * MoveForwardSpeed);
	aStrafe *= (TimeScale * MoveStrafeSpeed);
	aUp *= (TimeScale * MoveStrafeSpeed);
	aTurn *= (TimeScale * LookRightScale);
	aLookUp *= (TimeScale * LookUpScale);
	PostProcessInput(DeltaTime);
	ProcessInputMatching(DeltaTime);
	CatchDoubleClickInput();
	// End:0x262
	if(bEnableFOVScaling)
	{
		FOVScale = Outer.GetFOVAngle() * 0.0111100;		
	}
	else
	{
		FOVScale = 1.0000000;
	}
	AdjustMouseSensitivity(FOVScale);
	// End:0x2F1
	if(bEnableMouseSmoothing)
	{
		aMouseX = SmoothMouse(aMouseX, DeltaTime, bXAxis, 0);
		aMouseY = SmoothMouse(aMouseY, DeltaTime, bYAxis, 1);
	}
	aLookUp *= FOVScale;
	aTurn *= FOVScale;
	// End:0x34F
	if(int(bStrafe) > int(0))
	{
		aStrafe += (aBaseX + aMouseX);		
	}
	else
	{
		aTurn += (aBaseX + aMouseX);
	}
	aLookUp += aMouseY;
	// End:0x39F
	if(bInvertMouse)
	{
		aLookUp *= -1.0000000;
	}
	// End:0x3BC
	if(bInvertTurn)
	{
		aTurn *= -1.0000000;
	}
	aForward += aBaseY;
	Outer.HandleWalking();
	// End:0x471
	if(bLockTurnUntilRelease)
	{
		// End:0x465
		if(RawJoyLookRight != float(0))
		{
			aTurn = 0.0000000;
			// End:0x462
			if(AutoUnlockTurnTime > 0.0000000)
			{
				AutoUnlockTurnTime -= DeltaTime;
				// End:0x462
				if(AutoUnlockTurnTime < 0.0000000)
				{
					bLockTurnUntilRelease = false;
				}
			}			
		}
		else
		{
			bLockTurnUntilRelease = false;
		}
	}
	// End:0x4C0
	if(Outer.IsMoveInputIgnored())
	{
		aForward = 0.0000000;
		aStrafe = 0.0000000;
		aUp = 0.0000000;
	}
	// End:0x500
	if(Outer.IsLookInputIgnored())
	{
		aTurn = 0.0000000;
		aLookUp = 0.0000000;
	}
	//return;	
}

function CatchDoubleClickInput()
{
	// End:0x11C
	if(!Outer.IsMoveInputIgnored())
	{
		bEdgeForward = bWasForward ^^ (aBaseY > float(0));
		bEdgeBack = bWasBack ^^ (aBaseY < float(0));
		bEdgeLeft = bWasLeft ^^ (aStrafe < float(0));
		bEdgeRight = bWasRight ^^ (aStrafe > float(0));
		bWasForward = aBaseY > float(0);
		bWasBack = aBaseY < float(0);
		bWasLeft = aStrafe < float(0);
		bWasRight = aStrafe > float(0);
	}
	//return;	
}

function Actor.EDoubleClickDir CheckForDoubleClickMove(float DeltaTime)
{
	local Actor.EDoubleClickDir DoubleClickMove, OldDoubleClick;

	// End:0x38
	if(int(Outer.DoubleClickDir) == int(5))
	{
		DoubleClickMove = 5;		
	}
	else
	{
		DoubleClickMove = 0;
	}
	// End:0x49F
	if(DoubleClickTime > 0.0000000)
	{
		// End:0x117
		if(int(Outer.DoubleClickDir) == int(5))
		{
			// End:0x114
			if((Outer.Pawn != none) && int(Outer.Pawn.Physics) == int(1))
			{
				DoubleClickTimer = 0.0000000;
				Outer.DoubleClickDir = 6;
			}			
		}
		else
		{
			// End:0x35A
			if(int(Outer.DoubleClickDir) != int(6))
			{
				OldDoubleClick = Outer.DoubleClickDir;
				Outer.DoubleClickDir = 0;
				// End:0x1C9
				if(bEdgeForward && bWasForward)
				{
					Outer.DoubleClickDir = 3;					
				}
				else
				{
					// End:0x209
					if(bEdgeBack && bWasBack)
					{
						Outer.DoubleClickDir = 4;						
					}
					else
					{
						// End:0x249
						if(bEdgeLeft && bWasLeft)
						{
							Outer.DoubleClickDir = 1;							
						}
						else
						{
							// End:0x286
							if(bEdgeRight && bWasRight)
							{
								Outer.DoubleClickDir = 2;
							}
						}
					}
				}
				// End:0x2DA
				if(int(Outer.DoubleClickDir) == int(0))
				{
					Outer.DoubleClickDir = OldDoubleClick;					
				}
				else
				{
					// End:0x332
					if(int(Outer.DoubleClickDir) != int(OldDoubleClick))
					{
						DoubleClickTimer = DoubleClickTime + (0.5000000 * DeltaTime);						
					}
					else
					{
						DoubleClickMove = Outer.DoubleClickDir;
					}
				}
			}
		}
		// End:0x3F2
		if(int(Outer.DoubleClickDir) == int(6))
		{
			DoubleClickTimer = FMin(DoubleClickTimer - DeltaTime, 0.0000000);
			// End:0x3EF
			if(DoubleClickTimer < -0.3500000)
			{
				Outer.DoubleClickDir = 0;
				DoubleClickTimer = DoubleClickTime;
			}			
		}
		else
		{
			// End:0x49F
			if((int(Outer.DoubleClickDir) != int(0)) && int(Outer.DoubleClickDir) != int(5))
			{
				DoubleClickTimer -= DeltaTime;
				// End:0x49F
				if(DoubleClickTimer < float(0))
				{
					Outer.DoubleClickDir = 0;
					DoubleClickTimer = DoubleClickTime;
				}
			}
		}
	}
	return DoubleClickMove;
	//return ReturnValue;	
}

final function ProcessInputMatching(float DeltaTime)
{
	local float Value;
	local int I, MatchIdx;
	local bool bMatch;

	I = 0;
	J0x0B:

	// End:0x9AE [Loop If]
	if(I < Outer.InputRequests.Length)
	{
		// End:0x9A0
		if((Outer.InputRequests[I].MatchIdx >= 0) && Outer.InputRequests[I].MatchIdx < Outer.InputRequests[I].Inputs.Length)
		{
			// End:0x17D
			if(Outer.InputRequests[I].MatchActor == none)
			{
				Outer.InputRequests[I].MatchActor = Outer;
			}
			MatchIdx = Outer.InputRequests[I].MatchIdx;
			// End:0x45A
			if(((MatchIdx != 0) && Outer.InputRequests[I].Inputs[MatchIdx].TimeDelta > 0.0000000) && (Outer.WorldInfo.TimeSeconds - Outer.InputRequests[I].LastMatchTime) >= Outer.InputRequests[I].Inputs[MatchIdx].TimeDelta)
			{
				Outer.InputRequests[I].LastMatchTime = 0.0000000;
				Outer.InputRequests[I].MatchIdx = 0;
				// End:0x457
				if(Outer.InputRequests[I].FailedFuncName != 'None')
				{
					Outer.InputRequests[I].MatchActor.SetTimer(0.0100000, false, Outer.InputRequests[I].FailedFuncName);
				}				
			}
			else
			{
				Value = 0.0000000;
				switch(Outer.InputRequests[I].Inputs[MatchIdx].Type)
				{
					// End:0x4E6
					case 0:
						Value = aStrafe;
						// End:0x504
						break;
					// End:0x501
					case 1:
						Value = aBaseY;
						// End:0x504
						break;
					// End:0xFFFF
					default:
						break;
				}
				switch(Outer.InputRequests[I].Inputs[MatchIdx].Action)
				{
					// End:0x5DC
					case 0:
						bMatch = Value >= Outer.InputRequests[I].Inputs[MatchIdx].Value;
						// End:0x655
						break;
					// End:0x652
					case 1:
						bMatch = Value <= Outer.InputRequests[I].Inputs[MatchIdx].Value;
						// End:0x655
						break;
					// End:0xFFFF
					default:
						break;
				}
				// End:0x9A0
				if(bMatch)
				{
					Outer.InputRequests[I].LastMatchTime = Outer.WorldInfo.TimeSeconds;
					Outer.InputRequests[I].MatchIdx++;
					// End:0x9A0
					if(Outer.InputRequests[I].MatchIdx >= Outer.InputRequests[I].Inputs.Length)
					{
						// End:0x84D
						if(Outer.InputRequests[I].MatchDelegate != none)
						{
							Outer.__InputMatchDelegate__Delegate = Outer.InputRequests[I].MatchDelegate;
							Outer.InputMatchDelegate();
						}
						// End:0x922
						if(Outer.InputRequests[I].MatchFuncName != 'None')
						{
							Outer.InputRequests[I].MatchActor.SetTimer(0.0100000, false, Outer.InputRequests[I].MatchFuncName);
						}
						Outer.InputRequests[I].LastMatchTime = 0.0000000;
						Outer.InputRequests[I].MatchIdx = 0;
					}
				}
			}
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

exec function Jump()
{
	// End:0x7A
	if(Outer.WorldInfo.Pauser == Outer.PlayerReplicationInfo)
	{
		Outer.SetPause(false);		
	}
	else
	{
		Outer.bPressedJump = true;
	}
	//return;	
}

exec function SmartJump()
{
	Jump();
	//return;	
}

exec function ClearSmoothing()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x5B [Loop If]
	if(I < 2)
	{
		ZeroTime[I] = 0.0000000;
		SmoothedMouse[I] = 0.0000000;
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	MouseSamplingTotal = default.MouseSamplingTotal;
	MouseSamples = default.MouseSamples;
	//return;	
}

function float SmoothMouse(float aMouse, float DeltaTime, out byte SampleCount, int Index)
{
	local float MouseSamplingTime;

	// End:0x1BB
	if(DeltaTime < 0.2500000)
	{
		MouseSamplingTime = MouseSamplingTotal / float(MouseSamples);
		// End:0xD5
		if(aMouse == float(0))
		{
			ZeroTime[Index] += DeltaTime;
			// End:0xB9
			if(ZeroTime[Index] < MouseSamplingTime)
			{
				aMouse = (SmoothedMouse[Index] * DeltaTime) / MouseSamplingTime;				
			}
			else
			{
				SmoothedMouse[Index] = 0.0000000;
			}			
		}
		else
		{
			ZeroTime[Index] = 0.0000000;
			// End:0x18E
			if(SmoothedMouse[Index] != float(0))
			{
				// End:0x16E
				if(DeltaTime < (MouseSamplingTime * float(int(SampleCount) + int(1))))
				{
					aMouse = (aMouse * DeltaTime) / (MouseSamplingTime * float(SampleCount));					
				}
				else
				{
					SampleCount = byte(DeltaTime / MouseSamplingTime);
				}
			}
			SmoothedMouse[Index] = aMouse / float(SampleCount);
		}		
	}
	else
	{
		ClearSmoothing();
	}
	SampleCount = 0;
	return aMouse;
	//return ReturnValue;	
}

// Export UPlayerInput::execInitInputSystem(FFrame&, void* const)
native function InitInputSystem();

function ClientInitInputSystem()
{
	//return;	
}

function PreClientTravel(string PendingURL, Actor.ETravelType TravelType, bool bIsSeamlessTravel)
{
	//return;	
}

defaultproperties
{
	bEnableMouseSmoothing=true
	DoubleClickTime=0.2500000
	MouseSensitivity=30.0000000
	MoveForwardSpeed=1200.0000000
	MoveStrafeSpeed=1200.0000000
	LookRightScale=300.0000000
	LookUpScale=-250.0000000
	MouseSamples=1
	MouseSamplingTotal=0.0083000
	Bindings[0]=(Name="Duck",Command="Button bDuck | Axis aUp Speed=-1.0  AbsoluteAxis=100",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[1]=(Name="Look",Command="Button bLook",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[2]=(Name="Pause",Command="Pause",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[3]=(Name="LookToggle",Command="Toggle bLook",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[4]=(Name="LookUp",Command="Axis aLookUp Speed=+25.0 AbsoluteAxis=100",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[5]=(Name="LookDown",Command="Axis aLookUp Speed=-25.0 AbsoluteAxis=100",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[6]=(Name="CenterView",Command="Button bSnapLevel",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[7]=(Name="Walking",Command="Button bRun",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[8]=(Name="Strafe",Command="Button bStrafe",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[9]=(Name="NextWeapon",Command="NextWeapon",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[10]=(Name="ViewTeam",Command="ViewClass Pawn",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[11]=(Name="TurnToNearest",Command="Button bTurnToNearest",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[12]=(Name="Turn180",Command="Button bTurn180",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[13]=(Name="MouseX",Command="Count bXAxis | Axis aMouseX",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[14]=(Name="MouseY",Command="Count bYAxis | Axis aMouseY",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[15]=(Name="C",Command="DoDuck",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[16]=(Name="P",Command="TogglePhysicsMode",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[17]=(Name="B",Command="ToggleSpeaking true | OnRelease ToggleSpeaking false",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[18]=(Name="T",Command="Talk",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[19]=(Name="Y",Command="TeamTalk",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[20]=(Name="LeftShift",Command="Walking",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[21]=(Name="F1",Command="ShowMouseCursor",Control=false,Shift=true,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[22]=(Name="F1",Command="viewmode wireframe",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=true,bIgnoreAlt=false)
	Bindings[23]=(Name="F4",Command="viewmode detaillighting",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[24]=(Name="F5",Command="viewmode shadercomplexity",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[25]=(Name="F7",Command="OPENKISMETDEBUGGER SEQUENCE=PAUSEKISMETDEBUGGER",Control=false,Shift=false,Alt=true,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[26]=(Name="F9",Command="shot",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[27]=(Name="Period",Command="RECOMPILESHADERS CHANGED",Control=true,Shift=true,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[28]=(Name="Delete",Command="Camera Default",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[29]=(Name="End",Command="Camera FirstPerson",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[30]=(Name="XboxTypeS_X",Command="Use",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[31]=(Name="XboxTypeS_A",Command="Jump",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[32]=(Name="XboxTypeS_B",Command="ChangePosture",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[33]=(Name="XboxTypeS_Y",Command="NextWeapon",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[34]=(Name="XboxTypeS_Back",Command="",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[35]=(Name="XboxTypeS_Start",Command="|onrelease showmenu",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[36]=(Name="XboxTypeS_LeftShoulder",Command="obj list",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[37]=(Name="XboxTypeS_RightShoulder",Command="mem",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[38]=(Name="XboxTypeS_DPad_Up",Command="MoveForward",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[39]=(Name="XboxTypeS_DPad_Down",Command="MoveBackward",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[40]=(Name="XboxTypeS_DPad_Left",Command="TurnLeft",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[41]=(Name="XboxTypeS_DPad_Right",Command="TurnRight",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[42]=(Name="XboxTypeS_RightTrigger",Command="Fire",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[43]=(Name="XboxTypeS_LeftTrigger",Command="ToggleTargetingMode",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[44]=(Name="XboxTypeS_LeftX",Command="Axis aStrafe Speed=1.0 DeadZone=0.3",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[45]=(Name="XboxTypeS_LeftY",Command="Axis aBaseY Speed=1.0 DeadZone=0.3",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[46]=(Name="XboxTypeS_RightX",Command="Axis aTurn Speed=1.0 DeadZone=0.2",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[47]=(Name="XboxTypeS_RightY",Command="Axis aLookup Speed=0.8 DeadZone=0.2",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[48]=(Name="XboxTypeS_LeftTriggerAxis",Command="Axis aLeftAnalogTrigger Speed=1.0 DeadZone=0.11",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[49]=(Name="XboxTypeS_RightTriggerAxis",Command="Axis aRightAnalogTrigger Speed=1.0 DeadZone=0.11",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[50]=(Name="MOBILE_StopMatinee",Command="ce stopmatinee | OnRelease StopUseAttractModeInputConfig",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[51]=(Name="MOBILE_StartMatinee",Command="ce playmatinee | OnRelease StartUseAttractModeInputConfig",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[52]=(Name="MOBILE_NextConfig",Command="OnRelease NextMobileInputConfig",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[53]=(Name="MOBILE_CalibrateTilt",Command="CalibrateTilt",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[54]=(Name="MOBILE_ATurn",Command="Axis aTurn DeadZone=0.05",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[55]=(Name="MOBILE_ALookup",Command="Axis aLookup Speed=-1 DeadZone=0.05",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[56]=(Name="MOBILE_AStrafe",Command="Axis aStrafe DeadZone=0.15",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[57]=(Name="MOBILE_AForward",Command="Axis aBaseY DeadZone=0.15",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[58]=(Name="MOBILE_Fire",Command="StartFire | OnRelease StopFire",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[59]=(Name="MOBILE_NextWeapon",Command="NextWeapon",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[60]=(Name="MOBILE_Jump",Command="Jump",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[61]=(Name="MOBILE_ToggleFPS",Command="OnRelease stat fps",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[62]=(Name="NumPadZero",Command="MOBILE_ResetPrimitiveTracking",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[63]=(Name="NumPadOne",Command="MOBILE_IncrementTrackedPrimitive -1",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[64]=(Name="NumPadThree",Command="MOBILE_IncrementTrackedPrimitive 1",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[65]=(Name="WiiU_PointerX",Command="Axis aWiiUPointerX Speed=1.0",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[66]=(Name="WiiU_PointerY",Command="Axis aWiiUPointerY Speed=1.0",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[67]=(Name="R",Command="STARTMOVIECAPTURE",Control=false,Shift=false,Alt=true,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[68]=(Name="R",Command="STOPMOVIECAPTURE",Control=false,Shift=true,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[69]=(Name="GBA_MoveForward",Command="Axis aBaseY Speed=1.0",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[70]=(Name="GBA_Backward",Command="Axis aBaseY Speed=-1.0",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[71]=(Name="GBA_StrafeLeft",Command="Axis aStrafe Speed=-1.0",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[72]=(Name="GBA_StrafeRight",Command="Axis aStrafe Speed=+1.0",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[73]=(Name="GBA_TurnLeft",Command="Axis aBaseX Speed=-200.0 AbsoluteAxis=100",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[74]=(Name="GBA_TurnRight",Command="Axis aBaseX  Speed=+200.0 AbsoluteAxis=100",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[75]=(Name="GBA_LookUp",Command="Axis aLookup Speed=-.1 AbsoluteAxis=100",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[76]=(Name="GBA_LookDown",Command="Axis aLookup  Speed=+.1 AbsoluteAxis=100",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[77]=(Name="GBA_Jump",Command="Jump",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[78]=(Name="GBA_Duck",Command="Duck",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[79]=(Name="GBA_VehicleRise",Command="Axis aUp Speed=+1.0 AbsoluteAxis=100",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[80]=(Name="GBA_VehicleFall",Command="Axis aUp Speed=-1.0 AbsoluteAxis=100",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[81]=(Name="GBA_Fire",Command="StartFire | OnRelease StopFire | Button bFireButtonState",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[82]=(Name="GBA_RamAttack",Command="RamAttack",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[83]=(Name="GBA_LetGoOfLedge",Command="LetGoOfLedge",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[84]=(Name="GBA_ThrowGrenade",Command="ThrowGrenade",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[85]=(Name="GBA_UseAbility",Command="UseAbility",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[86]=(Name="GBA_AltFire",Command="StartAltFire | OnRelease StopAltFire",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[87]=(Name="GBA_Sprint",Command="Sprint",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[88]=(Name="GBA_Zoom",Command="EnableZoom | OnRelease DisableZoom",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[89]=(Name="GBA_ToggleZoom",Command="ToggleZoom",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[90]=(Name="GBA_CameraAim",Command="EnableCameraAim | OnRelease DisableCameraAim",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[91]=(Name="GBA_Use",Command="use",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[92]=(Name="GBA_SwitchToBestWeapon",Command="SwitchToBestWeapon",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[93]=(Name="GBA_PrevWeapon",Command="PrevWeapon",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[94]=(Name="GBA_NextWeapon",Command="NextWeapon",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[95]=(Name="GBA_SwitchWeapon1",Command="switchweapon 1",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[96]=(Name="GBA_SwitchWeapon2",Command="switchweapon 2",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[97]=(Name="GBA_SwitchWeapon3",Command="switchweapon 3",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[98]=(Name="GBA_SwitchWeapon4",Command="switchweapon 4",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[99]=(Name="GBA_SwitchWeapon5",Command="switchweapon 5",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[100]=(Name="GBA_SwitchWeapon6",Command="switchweapon 6",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[101]=(Name="GBA_SwitchWeapon7",Command="switchweapon 7",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[102]=(Name="GBA_SwitchWeapon8",Command="switchweapon 8",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[103]=(Name="GBA_SwitchWeapon9",Command="switchweapon 9",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[104]=(Name="GBA_SwitchWeapon10",Command="switchweapon 10",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[105]=(Name="GBA_Taunt1",Command="taunt 1",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[106]=(Name="GBA_Taunt2",Command="taunt 2",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[107]=(Name="GBA_Horn",Command="PlayVehicleHorn",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[108]=(Name="GBA_HaloHorn",Command="HonkHorn | OnRelease UnhonkHorn",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[109]=(Name="GBA_HaloBoost",Command="StartBoost | OnRelease StopBoost",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[110]=(Name="GBA_ShowMenu",Command="CloseEditorViewport | onrelease ShowMenu",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[111]=(Name="GBA_ShowCheatMenu",Command="ShowCheatMenu",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[112]=(Name="GBA_ShowCommandMenu",Command="ShowCommandMenu",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[113]=(Name="GBA_ShowScores",Command="SetShowScores true | Onrelease SetShowScores false",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[114]=(Name="GBA_ShowMap",Command="onrelease ShowObjectiveMap",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[115]=(Name="GBA_ToggleMinimap",Command="ToggleMinimap",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[116]=(Name="GBA_GrowHud",Command="GrowHud",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[117]=(Name="GBA_ShrinkHud",Command="ShrinkHud",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[118]=(Name="GBA_WeaponPicker",Command="PrevWeapon",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[119]=(Name="GBA_Jump_Gamepad",Command="SmartJump | Axis aUp Speed=1.0 AbsoluteAxis=100 | onRelease JumpReleased",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[120]=(Name="GBA_StrafeLeft_Gamepad",Command="Axis aStrafe Speed=1.0 DeadZone=0.2",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[121]=(Name="GBA_MoveForward_Gamepad",Command="Axis aBaseY Speed=1.0 DeadZone=0.2",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[122]=(Name="GBA_TurnLeft_Gamepad",Command="Axis aTurn Speed=1.0 DeadZone=0.2",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[123]=(Name="GBA_Look_Gamepad",Command="Axis aLookup Speed=0.65 DeadZone=0.2",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[124]=(Name="GBA_SwitchToBestWeapon_Gamepad",Command="SwitchToBestWeapon | Axis aUp Speed=-1.0 AbsoluteAxis=100",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[125]=(Name="GBA_SwapWeapons",Command="SwapWeapons",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[126]=(Name="GBA_ChooseCharacter",Command="ChooseCharacter",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[127]=(Name="GBA_ToggleTargetDesignator",Command="ToggleTargetDesignator",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[128]=(Name="GBA_CancelTargetDesignator",Command="CancelTargetDesignator",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[129]=(Name="GBA_Build",Command="StartBuilding | OnRelease StopBuilding",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[130]=(Name="GBA_NextCategoryItem",Command="NextCategoryItem",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[131]=(Name="GBA_PrevCategoryItem",Command="PrevCategoryItem",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[132]=(Name="GBA_VehicleAccel",Command="StartVehicleAccel | OnRelease StopVehicleAccel",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[133]=(Name="GBA_VehicleBrake",Command="StartVehicleBrake | OnRelease StopVehicleBrake",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[134]=(Name="GBA_VehicleStrafe",Command="StartVehicleStrafe | OnRelease StopVehicleStrafe",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[135]=(Name="GBA_CheatButton",Command="OnCheatButtonDown | onrelease OnCheatButtonUp",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[136]=(Name="GBA_CheatBloks",Command="AddBloksToBank 50",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[137]=(Name="GBA_CheatSuicide",Command="OnCheatSuicide",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[138]=(Name="GBA_CheatRun",Command="ToggleCheatRunSpeed",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[139]=(Name="GBA_CheatKillAllAI",Command="ActivateKillAllEnemiesCheat",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[140]=(Name="GBA_Use_Gamepad",Command="OnUseButtonPressed | OnRelease OnUseButtonReleased",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[141]=(Name="GBA_AltUse_Gamepad",Command="OnAltUseButtonPressed",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[142]=(Name="GBA_OpenHVCMenu",Command="OpenHVCMenu",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[143]=(Name="GBA_CloseHVCMenu",Command="CloseHVCMenu",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[144]=(Name="GBA_SelectHVCItem",Command="SelectCurrentCustomizationIndex",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[145]=(Name="GBA_HVCMenuPressUp",Command="HVCMenuPressUp",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[146]=(Name="GBA_HVCMenuPressDown",Command="HVCMenuPressDown",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[147]=(Name="GBA_HVCMenuPressLeft",Command="HVCMenuPressLeft",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[148]=(Name="GBA_HVCMenuPressRight",Command="HVCMenuPressRight",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[149]=(Name="GBA_Customize",Command="StartCustomizing | OnRelease StopCustomizing",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[150]=(Name="GBA_UseVehicleAbility",Command="UseVehicleAbility | OnRelease CancelVehicleAbility",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[151]=(Name="GBA_SelectPreviousConstructionPrimitive",Command="SelectPreviousConstructionPrimitive",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[152]=(Name="GBA_SelectNextConstructionPrimitive",Command="SelectNextConstructionPrimitive",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[153]=(Name="GBA_SelectConstructionPrimitive",Command="SelectConstructionPrimitive",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[154]=(Name="GBA_ConstructionCameraLeft",Command="ConstructionCameraLeft | OnRelease StopConstructionCamera",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[155]=(Name="GBA_ConstructionCameraRight",Command="ConstructionCameraRight | OnRelease StopConstructionCamera",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[156]=(Name="GBA_ExitConstructionMode",Command="ExitConstructionMode",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[157]=(Name="GBA_SelectNextConstructionPrimitive_UI",Command="SelectNextConstructionPrimitive_UI",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[158]=(Name="GBA_SelectPreviousConstructionPrimitive_UI",Command="SelectPreviousConstructionPrimitive_UI",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[159]=(Name="XboxTypeS_Back",Command="GBA_ShowCheatMenu",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[160]=(Name="XboxTypeS_Start",Command="GBA_ShowMenu",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[161]=(Name="XboxTypeS_A",Command="GBA_Jump_Gamepad | GBA_VehicleAccel | GBA_Build | GBA_VehicleRise | GBA_SelectHVCItem | GBA_SelectConstructionPrimitive",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[162]=(Name="XboxTypeS_B",Command="GBA_AltUse_Gamepad | GBA_LetGoOfLedge | GBA_VehicleBrake | GBA_VehicleFall | GBA_CloseHVCMenu | GBA_CancelTargetDesignator | GBA_ExitConstructionMode",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[163]=(Name="XboxTypeS_X",Command="GBA_Fire | GBA_HaloHorn | GBA_Build | GBA_Customize",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[164]=(Name="XboxTypeS_Y",Command="GBA_Use_Gamepad | GBA_CancelTargetDesignator",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[165]=(Name="XboxTypeS_LeftShoulder",Command="GBA_ThrowGrenade | GBA_PrevCategoryItem | GBA_HaloBoost | GBA_UseVehicleAbility | GBA_SelectPreviousConstructionPrimitive",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[166]=(Name="XboxTypeS_RightShoulder",Command="GBA_UseAbility | GBA_NextCategoryItem | GBA_OpenHVCMenu | GBA_SelectNextConstructionPrimitive",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[167]=(Name="XboxTypeS_LeftTrigger",Command="GBA_CameraAim | GBA_VehicleStrafe | GBA_ConstructionCameraLeft",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[168]=(Name="XboxTypeS_RightTrigger",Command="GBA_Fire | GBA_HaloHorn | GBA_Build | GBA_Customize | GBA_ConstructionCameraRight",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[169]=(Name="XboxTypeS_LeftX",Command="GBA_StrafeLeft_Gamepad",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[170]=(Name="XboxTypeS_LeftY",Command="GBA_MoveForward_Gamepad",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[171]=(Name="XboxTypeS_RightX",Command="GBA_TurnLeft_Gamepad",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[172]=(Name="XboxTypeS_RightY",Command="GBA_Look_Gamepad",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[173]=(Name="XboxTypeS_LeftThumbStick",Command="GBA_Sprint | GBA_HaloBoost",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[174]=(Name="XboxTypeS_RightThumbStick",Command="GBA_CheatButton",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[175]=(Name="XboxTypeS_DPad_Up",Command="GBA_CheatSuicide|GBA_HVCMenuPressUp",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[176]=(Name="XboxTypeS_DPad_Down",Command="GBA_CheatBloks|GBA_HVCMenuPressDown",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[177]=(Name="XboxTypeS_DPad_Left",Command="GBA_CheatRun|GBA_HVCMenuPressLeft|GBA_SelectPreviousConstructionPrimitive_UI",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[178]=(Name="XboxTypeS_DPad_Right",Command="GBA_CheatKillAllAI|GBA_HVCMenuPressRight|GBA_SelectNextConstructionPrimitive_UI",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[179]=(Name="LeftControl",Command="GBA_Jump",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[180]=(Name="Enter",Command="GBA_Use",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[181]=(Name="F10",Command="ToggleInventory",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[182]=(Name="SpaceBar",Command="GBA_Jump | GBA_HaloBoost",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[183]=(Name="W",Command="GBA_MoveForward | GBA_VehicleAccel",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[184]=(Name="S",Command="GBA_Backward | GBA_VehicleBrake",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[185]=(Name="A",Command="GBA_StrafeLeft",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[186]=(Name="D",Command="GBA_StrafeRight",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[187]=(Name="LeftShift",Command="GBA_Sprint",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[188]=(Name="LeftMouseButton",Command="GBA_Fire | GBA_Build | GBA_Customize",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[189]=(Name="Escape",Command="GBA_ShowMenu",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[190]=(Name="J",Command="GBA_Taunt1",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[191]=(Name="K",Command="GBA_Taunt2",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[192]=(Name="L",Command="GBA_HaloHorn",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[193]=(Name="F1",Command="GBA_ShowScores",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=true,bIgnoreAlt=false)
	Bindings[194]=(Name="F2",Command="GBA_ShowMap",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[195]=(Name="F3",Command="GBA_ToggleMinimap",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[196]=(Name="F6",Command="stat net",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[197]=(Name="G",Command="GBA_SwitchToBestWeapon",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[198]=(Name="F",Command="GBA_RamAttack | GBA_LetGoOfLedge | GBA_VehicleFall ",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[199]=(Name="Equals",Command="GBA_GrowHud",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[200]=(Name="Minus",Command="GBA_ShrinkHud",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[201]=(Name="V",Command="GBA_ShowCommandMenu",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[202]=(Name="B",Command="GBA_ToggleSpeaking",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[203]=(Name="E",Command="GBA_Use_Gamepad",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[204]=(Name="R",Command="GBA_ToggleTargetDesignator | GBA_VehicleRise | GBA_OpenHVCMenu",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[205]=(Name="Q",Command="GBA_ThrowGrenade",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[206]=(Name="Y",Command="GBA_SwapWeapons",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[207]=(Name="MouseScrollUp",Command="GBA_SwapWeapons",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[208]=(Name="MouseScrollDown",Command="GBA_SwapWeapons",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[209]=(Name="End",Command="GBA_CancelTargetDesignator | GBA_CloseHVCMenu",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[210]=(Name="PageUp",Command="GBA_NextCategoryItem",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[211]=(Name="PageDown",Command="GBA_PrevCategoryItem",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[212]=(Name="BackSpace",Command="GBA_AddBloksToBank",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[213]=(Name="one",Command="GBA_Jump",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[214]=(Name="two",Command="GBA_Jump",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[215]=(Name="three",Command="GBA_Jump",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[216]=(Name="four",Command="GBA_Jump",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[217]=(Name="five",Command="GBA_Jump",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[218]=(Name="six",Command="GBA_Jump",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[219]=(Name="seven",Command="GBA_Jump",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[220]=(Name="eight",Command="GBA_Jump",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[221]=(Name="nine",Command="GBA_Jump",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[222]=(Name="zero",Command="GBA_Jump",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[223]=(Name="F4",Command="Playersonly",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[224]=(Name="F5",Command="set D3DRenderDevice UsePostProcessEffects False",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[225]=(Name="F6",Command="set D3DRenderDevice UsePostProcessEffects True",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[226]=(Name="F7",Command="NextViewMode",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=true)
	Bindings[227]=(Name="F8",Command="PrevViewMode",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[228]=(Name="M",Command="BasePath 0",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
	Bindings[229]=(Name="N",Command="BasePath 1",Control=false,Shift=false,Alt=false,bIgnoreCtrl=false,bIgnoreShift=false,bIgnoreAlt=false)
}