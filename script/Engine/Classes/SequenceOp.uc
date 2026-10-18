class SequenceOp extends SequenceObject
	abstract
	native;

struct native SeqOpInputLink
{
	var string LinkDesc;
	var bool bHasImpulse;
	var int QueuedActivations;
	var bool bDisabled;
	var bool bDisabledPIE;
	var SequenceOp LinkedOp;
	var int DrawY;
	var bool bHidden;
	var float ActivateDelay;
	var editoronly transient bool bMoving;
	var bool bClampedMax;
	var bool bClampedMin;

	structdefaultproperties
	{
		LinkDesc=""
		bHasImpulse=false
		QueuedActivations=0
		bDisabled=false
		bDisabledPIE=false
		LinkedOp=none
		DrawY=0
		bHidden=false
		ActivateDelay=0.0000000
		bMoving=false
		bClampedMax=false
		bClampedMin=false
	}
};

struct native SeqOpOutputInputLink
{
	var SequenceOp LinkedOp;
	var int InputLinkIdx;

	structdefaultproperties
	{
		LinkedOp=none
		InputLinkIdx=0
	}
};

struct native SeqOpOutputLink
{
	var array<SeqOpOutputInputLink> Links;
	var string LinkDesc;
	var bool bHasImpulse;
	var bool bDisabled;
	var bool bDisabledPIE;
	var SequenceOp LinkedOp;
	var float ActivateDelay;
	var int DrawY;
	var bool bHidden;
	var editoronly transient bool bMoving;
	var bool bClampedMax;
	var bool bClampedMin;
	var noimport nontransactional editoronly transient bool bIsActivated;

	structdefaultproperties
	{
		Links=none
		LinkDesc=""
		bHasImpulse=false
		bDisabled=false
		bDisabledPIE=false
		LinkedOp=none
		ActivateDelay=0.0000000
		DrawY=0
		bHidden=false
		bMoving=false
		bClampedMax=false
		bClampedMin=false
		bIsActivated=false
	}
};

struct native SeqVarLink
{
	var Class<SequenceVariable> ExpectedType;
	var array<SequenceVariable> LinkedVariables;
	var string LinkDesc;
	var name LinkVar;
	var name PropertyName;
	var bool bWriteable;
	var bool bSequenceNeverReadsOnlyWritesToThisVar;
	var bool bModifiesLinkedObject;
	var bool bHidden;
	var int MinVars;
	var int MaxVars;
	var int DrawX;
	var const transient Property CachedProperty;
	var bool bAllowAnyType;
	var editoronly transient bool bMoving;
	var bool bClampedMax;
	var bool bClampedMin;

	structdefaultproperties
	{
		ExpectedType=Class'Engine.SequenceVariable'
		LinkedVariables=none
		LinkDesc=""
		LinkVar="None"
		PropertyName="None"
		bWriteable=false
		bSequenceNeverReadsOnlyWritesToThisVar=false
		bModifiesLinkedObject=false
		bHidden=false
		MinVars=1
		MaxVars=255
		DrawX=0
		CachedProperty=none
		bAllowAnyType=false
		bMoving=false
		bClampedMax=false
		bClampedMin=false
	}
};

struct native SeqEventLink
{
	var Class<SequenceEvent> ExpectedType;
	var array<SequenceEvent> LinkedEvents;
	var string LinkDesc;
	var int DrawX;
	var bool bHidden;
	var editoronly transient bool bMoving;
	var bool bClampedMax;
	var bool bClampedMin;

	structdefaultproperties
	{
		ExpectedType=Class'Engine.SequenceEvent'
		LinkedEvents=none
		LinkDesc=""
		DrawX=0
		bHidden=false
		bMoving=false
		bClampedMax=false
		bClampedMin=false
	}
};

var noimport nontransactional duplicatetransient editoronly transient bool bIsActivated;
var noimport nontransactional duplicatetransient editoronly transient bool bIsCurrentDebuggerOp;
var bool bActive;
var const bool bLatentExecution;
var bool bAutoActivateOutputLinks;
var editoronly transient bool bHaveMovingVarConnector;
var editoronly transient bool bHaveMovingInputConnector;
var editoronly transient bool bHaveMovingOutputConnector;
var editoronly transient bool bPendingVarConnectorRecalc;
var editoronly transient bool bPendingInputConnectorRecalc;
var editoronly transient bool bPendingOutputConnectorRecalc;
var bool bIsBreakpointSet;
var noimport nontransactional duplicatetransient editoronly transient bool bIsHiddenBreakpointSet;
var array<SeqOpInputLink> InputLinks;
var array<SeqOpOutputLink> OutputLinks;
var array<SeqVarLink> VariableLinks;
var array<SeqEventLink> EventLinks;
var noimport transient int PlayerIndex;
var noimport transient byte GamepadID;
var transient int ActivateCount;
var protected duplicatetransient const transient int SearchTag;

// Export USequenceOp::execHasLinkedOps(FFrame&, void* const)
native final function bool HasLinkedOps(optional bool bConsiderInputLinks);

// Export USequenceOp::execGetLinkedObjects(FFrame&, void* const)
native final function GetLinkedObjects(out array<SequenceObject> out_Objects, optional Class<SequenceObject> ObjectType, optional bool bRecurse);

// Export USequenceOp::execGetObjectVars(FFrame&, void* const)
native final function GetObjectVars(out array<Object> objVars, optional string inDesc);

// Export USequenceOp::execGetInterpDataVars(FFrame&, void* const)
native final function GetInterpDataVars(out array<InterpData> outIData, optional string inDesc);

// Export USequenceOp::execGetBoolVars(FFrame&, void* const)
native final function GetBoolVars(out array<byte> boolVars, optional string inDesc);

// Export USequenceOp::execLinkedVariables(FFrame&, void* const)
native final iterator function LinkedVariables(Class<SequenceVariable> VarClass, out SequenceVariable OutVariable, optional string inDesc);

// Export USequenceOp::execActivateOutputLink(FFrame&, void* const)
native final function bool ActivateOutputLink(int OutputIdx);

// Export USequenceOp::execActivateNamedOutputLink(FFrame&, void* const)
native final function bool ActivateNamedOutputLink(string LinkDesc);

event Activated()
{
	//return;	
}

event Deactivated()
{
	//return;	
}

event VersionUpdated(int OldVersion, int NewVersion)
{
	//return;	
}

// Export USequenceOp::execPopulateLinkedVariableValues(FFrame&, void* const)
native final function PopulateLinkedVariableValues();

// Export USequenceOp::execPublishLinkedVariableValues(FFrame&, void* const)
native final function PublishLinkedVariableValues();

function Reset()
{
	//return;	
}

function Pawn GetPawn(Actor TheActor)
{
	local Pawn P;
	local Controller C;

	P = Pawn(TheActor);
	// End:0x38
	if(P != none)
	{
		return P;		
	}
	else
	{
		C = Controller(TheActor);
		return ((C != none) ? C.Pawn : none);
	}
	//return ReturnValue;	
}

function Controller GetController(Actor TheActor)
{
	local Pawn P;
	local Controller C;

	C = Controller(TheActor);
	// End:0x38
	if(C != none)
	{
		return C;		
	}
	else
	{
		P = Pawn(TheActor);
		return ((P != none) ? P.Controller : none);
	}
	//return ReturnValue;	
}

// Export USequenceOp::execForceActivateInput(FFrame&, void* const)
native final function ForceActivateInput(int InputIdx);

// Export USequenceOp::execForceActivateOutput(FFrame&, void* const)
native final function ForceActivateOutput(int OutputIdx);

defaultproperties
{
	bAutoActivateOutputLinks=true
	InputLinks[0]=(LinkDesc="In",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	OutputLinks[0]=(Links=none,LinkDesc="Out",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	PlayerIndex=-1
	GamepadID=255
}