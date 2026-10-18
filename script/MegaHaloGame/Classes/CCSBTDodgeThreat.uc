class CCSBTDodgeThreat extends CCSBTScriptBehavior;

var float BlendInTime;
var float BlendOutTime;
var name DodgeBlendName;
var name DodgeSequenceNames[4];
var AnimNodeBlendList DodgeBlend;
var AnimNodeSequence DodgeSequences[4];
var Rotator InitialRotation;
var int activeAnimIndex;
var float initialDistFromFloor;

function FlagUsedBBMembers(GripBlackboard Blackboard)
{
	local CCSBlackboard CCSBB;

	CCSBB = CCSBlackboard(Blackboard);
	// End:0x2D
	if(CCSBB == none)
	{
		return;
	}
	CCSBB.FlagThreatLocationAsUsed();
	//return;	
}

function Initialize()
{
	super.Initialize();
	DodgeBlend = AnimNodeBlendList(Controller.Pawn.Mesh.FindAnimNode(DodgeBlendName));
	DodgeSequences[0] = AnimNodeSequence(Controller.Pawn.Mesh.FindAnimNode(DodgeSequenceNames[0]));
	DodgeSequences[1] = AnimNodeSequence(Controller.Pawn.Mesh.FindAnimNode(DodgeSequenceNames[1]));
	DodgeSequences[2] = AnimNodeSequence(Controller.Pawn.Mesh.FindAnimNode(DodgeSequenceNames[2]));
	DodgeSequences[3] = AnimNodeSequence(Controller.Pawn.Mesh.FindAnimNode(DodgeSequenceNames[3]));
	//return;	
}

function bool ComputeCondition(GripBTInterface BTInterface)
{
	return DodgeBlend != none;
	//return ReturnValue;	
}

function bool ExecutePre(GripBTInterface BTInterface)
{
	local Vector ThreatLocation, ThreatDirection, threatDirectionToMe, directions[4], testVector, junk,
		testPos, testPosHigh, testPosLow;

	local CCSBlackboard CCSBB;
	local int I, bestIndex;
	local float BestDot, testDot;
	local Actor TraceHitActor;
	local HaloAIPawn HaloPawn;
	local CCSBlackboard.EThreatType ThreatType;
	local float Side, thisside, testdiff;

	directions[0] = vect(1.0000000, 0.0000000, 0.0000000);
	directions[1] = vect(0.0000000, 1.0000000, 0.0000000);
	directions[2] = vect(-1.0000000, 0.0000000, 0.0000000);
	directions[3] = vect(0.0000000, -1.0000000, 0.0000000);
	CCSBB = CCSBlackboard(BTInterface.Blackboard);
	// End:0xA8
	if(CCSBB == none)
	{
		return false;
	}
	ThreatLocation = CCSBB.GetThreatLocation();
	HaloPawn = HaloAIPawn(Controller.Pawn);
	ThreatType = CCSBB.GetThreatType();
	// End:0x162
	if(HaloPawn != none)
	{
		HaloPawn.NotifyDodgingThreat(ThreatType);
	}
	ThreatDirection = CCSBB.GetThreatDirection();
	threatDirectionToMe = Controller.Pawn.Location - ThreatLocation;
	Side = (ThreatDirection.X * threatDirectionToMe.Y) - (ThreatDirection.Y * threatDirectionToMe.X);
	bestIndex = -1;
	BestDot = 10000000.0000000;
	I = 0;
	J0x27C:

	// End:0x8BE [Loop If]
	if(I < 4)
	{
		// End:0x8B0
		if(DodgeSequences[I] != none)
		{
			testVector = directions[I] >> Controller.Pawn.Rotation;
			testPos = Controller.Pawn.Location + (testVector * 800.0000000);
			testPosHigh = testPos + vect(0.0000000, 0.0000000, 100.0000000);
			testPosLow = testPos + vect(0.0000000, 0.0000000, -200.0000000);
			switch(ThreatType)
			{
				// End:0x3A3
				case 2:
				// End:0x747
				case 3:
					testDot = testVector Dot ThreatDirection;
					testDot = Abs(testDot);
					testdiff = testDot - BestDot;
					// End:0x53B
					if(testdiff < -0.0000100)
					{
						TraceHitActor = Controller.Pawn.Trace(junk, junk, testPos, Controller.Pawn.Location, false);
						// End:0x538
						if(TraceHitActor == none)
						{
							TraceHitActor = Controller.Pawn.Trace(junk, junk, testPosLow, testPosHigh, false);
							// End:0x538
							if(TraceHitActor != none)
							{
								bestIndex = I;
								BestDot = testDot;
							}
						}						
					}
					else
					{
						// End:0x744
						if(testdiff < 0.0000100)
						{
							thisside = (ThreatDirection.X * testVector.Y) - (ThreatDirection.Y * testVector.X);
							// End:0x744
							if(((Side >= float(0)) && thisside >= float(0)) || (Side <= float(0)) && thisside <= float(0))
							{
								TraceHitActor = Controller.Pawn.Trace(junk, junk, testPos, Controller.Pawn.Location, false);
								// End:0x744
								if(TraceHitActor == none)
								{
									TraceHitActor = Controller.Pawn.Trace(junk, junk, testPosLow, testPosHigh, false);
									// End:0x744
									if(TraceHitActor != none)
									{
										bestIndex = I;
										BestDot = testDot;
									}
								}
							}
						}
					}
					// End:0x8B0
					break;
				// End:0xFFFF
				default:
					testDot = testVector Dot threatDirectionToMe-;
					// End:0x8AD
					if(testDot < BestDot)
					{
						TraceHitActor = Controller.Pawn.Trace(junk, junk, testPos, Controller.Pawn.Location, false);
						// End:0x8AD
						if(TraceHitActor == none)
						{
							TraceHitActor = Controller.Pawn.Trace(junk, junk, testPosLow, testPosHigh, false);
							// End:0x8AD
							if(TraceHitActor != none)
							{
								bestIndex = I;
								BestDot = testDot;
							}
						}
					}
					// End:0x8B0
					break;
					break;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x27C;
	}
	// End:0x8CF
	if(bestIndex < 0)
	{
		return false;
	}
	activeAnimIndex = bestIndex;
	InitialRotation = Controller.Pawn.Rotation;
	Controller.Pawn.Mesh.RootMotionMode = 3;
	DodgeBlend.SetActiveChild(int(float(activeAnimIndex) + 1.0000000), BlendInTime);
	DodgeSequences[activeAnimIndex].PlayAnim();
	initialDistFromFloor = Controller.Pawn.Location.Z - Controller.Pawn.WalkableFloorZ;
	return true;
	//return ReturnValue;	
}

function GripBTNode.BTExecutionResult Execute(GripBTInterface BTInterface, bool PushToFinish)
{
	local GripBTNode.BTExecutionResult ExecRes;

	ExecRes = 2;
	Controller.Pawn.SetRotation(InitialRotation);
	// End:0x9B
	if(DodgeSequences[activeAnimIndex].bPlaying!)
	{
		// End:0x8C
		if(PushToFinish)
		{
			ExecRes = 4;			
		}
		else
		{
			ExecRes = 0;
		}		
	}
	else
	{
		// End:0xB4
		if(PushToFinish)
		{
			ExecRes = 3;
		}
	}
	return ExecRes;
	//return ReturnValue;	
}

function ExecutePost(GripBTInterface BTInterface)
{
	DodgeSequences[activeAnimIndex].StopAnim();
	DodgeBlend.SetActiveChild(0, BlendOutTime);
	Controller.Pawn.Mesh.RootMotionMode = 2;
	Controller.Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
	//return;	
}

defaultproperties
{
	BlendInTime=0.1000000
	BlendOutTime=0.1000000
	DodgeBlendName="DodgeBlend"
	DodgeSequenceNames[0]="DodgeForward"
	DodgeSequenceNames[1]="DodgeRight"
	DodgeSequenceNames[2]="DodgeBackward"
	DodgeSequenceNames[3]="DodgeLeft"
	NodeDescription="Force the NPC to Dodge. Succeeds after Dodge animation is completed. Not interruptible."
	DefaultTitle="Dodge Threat"
}