class GripActionFramework extends Object
	native;

var native Pointer NativeFramework;

// Export UGripActionFramework::execExecute(FFrame&, void* const)
native function bool Execute(GripAFActionHandle Action);

// Export UGripActionFramework::execGetStatus(FFrame&, void* const)
native function GripAFActionHandle.GripAFActionStatus GetStatus(GripAFActionHandle Handle);
