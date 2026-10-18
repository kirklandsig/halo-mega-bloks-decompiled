class SeqAct_StartMission extends SequenceAction;

var name missionName;
var bool bIsPrimaryMission;
var bool bIsTimed;
var float TimeLimit;
var PlayerStart StartPoint;
var ObjectiveRewardData Reward;
var string NameId;
var string DescriptionID;
var float DisplayTime;
var Texture2D DisplayImage;
var AkEvent OnStartSound;
var AkEvent OnCompleteSound;
var AkEvent OnFailSound;
var HaloMission mission;

event Activated()
{
	// End:0x30
	if(mission == none)
	{
		CreateMission();
		SetMissionProperties();
		StartMission();		
	}
	else
	{
		WarnInternal(string(missionName) $ " is still pending completion and will not be restarted");
	}
	//return;	
}

function WarpPlayers()
{
	local HaloPlayerPawnController PC;

	// End:0x111
	if(StartPoint != none)
	{
		// End:0x110
		foreach GetWorldInfo().AllControllers(Class'MegaHaloGame.HaloPlayerPawnController', PC)
		{
			// End:0x10F
			if((PC != none) && PC.Pawn != none)
			{
				PC.Pawn.SetLocation(StartPoint.Location);
				PC.Pawn.SetRotation(StartPoint.Rotation);
			}			
		}		
	}
	//return;	
}

function CreateMission()
{
	mission = new Class'MegaHaloGame.HaloMission';
	//return;	
}

function SetMissionProperties()
{
	mission.missionName = missionName;
	mission.bIsPrimaryMission = bIsPrimaryMission;
	mission.bIsTimed = bIsTimed;
	mission.TimeLimit = TimeLimit;
	mission.StartPoint = StartPoint;
	mission.Reward = Reward;
	mission.DisplayName = ((NameId == "") ? "" : Localize("HaloMission", NameId, "MegaHaloGame"));
	mission.DisplayDescription = ((DescriptionID == "") ? "" : Localize("HaloMission", DescriptionID, "MegaHaloGame"));
	mission.DisplayTime = DisplayTime;
	mission.DisplayImagePath = ((DisplayImage == none) ? name("") : name(PathName(DisplayImage)));
	mission.OnStartSound = OnStartSound;
	mission.OnCompleteSound = OnCompleteSound;
	mission.OnFailSound = OnFailSound;
	mission.KismetOwner = self;
	//return;	
}

function StartMission()
{
	mission.Start();
	//return;	
}

function EndMission()
{
	mission = none;
	//return;	
}

defaultproperties
{
	missionName="mission"
	bIsPrimaryMission=true
	DisplayTime=3.0000000
	bCallHandler=false
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Mission",LinkVar="None",PropertyName="mission",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Start Mission"
}