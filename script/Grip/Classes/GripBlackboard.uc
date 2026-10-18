class GripBlackboard extends Object
	native;

var native Pointer BB;

// Export UGripBlackboard::execContainState(FFrame&, void* const)
native function bool ContainState(string StateName);

// Export UGripBlackboard::execFlagStatesAsUsed(FFrame&, void* const)
native function FlagStatesAsUsed();
