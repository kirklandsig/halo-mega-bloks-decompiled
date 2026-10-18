class SeqAct_StartObjective extends SequenceAction
	abstract;

var name ObjectiveName;
var bool bIsPrimaryObjective;
var bool bIsTimed;
var bool bUseNavigation;
var bool bShowStartMessage;
var bool bShowCompleteMessage;
var float TimeLimit;
var byte Priority;
var ObjectiveRewardData Reward;
var string NameId;
var string RepeatedNameID;
var string DescriptionID;
var float DisplayTime;
var AkEvent OnStartSound;
var AkEvent OnCompleteSound;
var AkEvent OnFailSound;
var HaloObjective Objective;

event Activated()
{
	// End:0x30
	if(Objective == none)
	{
		CreateObjective();
		SetObjectiveProperties();
		StartObjective();		
	}
	else
	{
		WarnInternal(string(ObjectiveName) $ " is still pending completion and will not be restarted");
	}
	//return;	
}

function CreateObjective()
{
	Objective = new Class'MegaHaloGame.HaloObjective';
	//return;	
}

function SetObjectiveProperties()
{
	Objective.ObjectiveName = ObjectiveName;
	Objective.bIsPrimaryObjective = bIsPrimaryObjective;
	Objective.bIsTimed = bIsTimed;
	Objective.TimeLimit = TimeLimit;
	Objective.bUseNavigation = bUseNavigation;
	Objective.Priority = Priority;
	Objective.Reward = Reward;
	Objective.DisplayName = ((NameId == "") ? "" : Localize("HaloObjective", NameId, "MegaHaloGame"));
	Objective.RedisplayName = ((RepeatedNameID == "") ? "" : Localize("HaloObjective", RepeatedNameID, "MegaHaloGame"));
	Objective.DisplayDescription = ((DescriptionID == "") ? "" : Localize("HaloObjective", DescriptionID, "MegaHaloGame"));
	Objective.DisplayTime = DisplayTime;
	Objective.bShowStartMessage = bShowStartMessage;
	Objective.bShowCompleteMessage = bShowCompleteMessage;
	Objective.OnStartSound = OnStartSound;
	Objective.OnCompleteSound = OnCompleteSound;
	Objective.OnFailSound = OnFailSound;
	Objective.KismetOwner = self;
	//return;	
}

function StartObjective()
{
	Objective.Start();
	//return;	
}

function Complete()
{
	ForceActivateOutput(0);
	Objective = none;
	//return;	
}

function Fail()
{
	ForceActivateOutput(1);
	Objective = none;
	//return;	
}

function Abort()
{
	Objective = none;
	//return;	
}

defaultproperties
{
	ObjectiveName="Objective"
	bIsPrimaryObjective=true
	bUseNavigation=true
	bShowStartMessage=true
	NameId="Mission_Objective_Generic"
	RepeatedNameID="Mission_Objective_Repeat"
	DisplayTime=3.0000000
	bCallHandler=false
	bAutoActivateOutputLinks=false
	OutputLinks[0]=(Links=none,LinkDesc="Complete",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	OutputLinks[1]=(Links=none,LinkDesc="Failed",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Objective",LinkVar="None",PropertyName="Objective",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Start Objective"
}