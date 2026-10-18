class HaloMission extends Object
	implements(HaloSaveInterface);

var name missionName;
var bool bIsPrimaryMission;
var bool bIsTimed;
var float TimeLimit;
var PlayerStart StartPoint;
var ObjectiveRewardData Reward;
var string DisplayName;
var string DisplayDescription;
var float DisplayTime;
var name DisplayImagePath;
var AkEvent OnStartSound;
var AkEvent OnCompleteSound;
var AkEvent OnFailSound;
var float Timer;
var array<HaloObjective> Objectives;
var array<HaloObjective> DeadObjectives;
var array<HaloObjective> CompletedObjectives;
var HaloGameDefault GameOwner;
var SeqAct_StartMission KismetOwner;
//var delegate<PCDelegate> __PCDelegate__Delegate;

delegate PCDelegate(HaloPlayerPawnController PC, Object param1)
{
	//return;	
}

function Start()
{
	GameOwner = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0xDA
	if(GameOwner != none)
	{
		// End:0xD7
		if(GameOwner.SetMission(self, bIsPrimaryMission))
		{
			LogInternal("Starting Mission: " $ string(missionName));
			AnnounceMission();
			PlaySound(OnStartSound);
			Timer = TimeLimit;
		}		
	}
	else
	{
		WarnInternal(("Game is not of type HaloGameDefault: " $ string(missionName)) $ " will not be started");
	}
	//return;	
}

function Complete()
{
	LogInternal("Completed Mission: " $ string(missionName));
	GameOwner.CompletedMissions.AddItem(self);
	GiveReward();
	PlaySound(OnCompleteSound);
	SendStatusEvent(name(string(missionName) $ "_Complete"));
	Term();
	//return;	
}

function Fail()
{
	LogInternal("Failed Mission: " $ string(missionName));
	PlaySound(OnFailSound);
	SendStatusEvent(name(string(missionName) $ "_Failed"));
	Term();
	//return;	
}

static function bool SendStatusEvent(name EventName)
{
	local array<SequenceObject> AllSeqEvents;
	local WorldInfo WorldInfo;
	local Sequence GameSeq;
	local int I;

	WorldInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
	GameSeq = WorldInfo.GetGameSequence();
	// End:0x144
	if(GameSeq != none)
	{
		GameSeq.FindSeqObjectsByClass(Class'Engine.SeqEvent_RemoteEvent', true, AllSeqEvents);
		I = 0;
		J0x9E:

		// End:0x144 [Loop If]
		if(I < AllSeqEvents.Length)
		{
			// End:0x136
			if(SeqEvent_RemoteEvent(AllSeqEvents[I]).EventName == EventName)
			{
				SeqEvent_RemoteEvent(AllSeqEvents[I]).CheckActivate(WorldInfo, none);
				return true;
			}
			I++;
			// [Loop Continue]
			goto J0x9E;
		}
	}
	return false;
	//return ReturnValue;	
}

function Term()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x73 [Loop If]
	if(I < Objectives.Length)
	{
		// End:0x65
		if(Objectives[I] != none)
		{
			Objectives[I].Term();
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	Objectives.Length = 0;
	DeadObjectives.Length = 0;
	// End:0xCF
	if(GameOwner != none)
	{
		GameOwner.SetMission(none, bIsPrimaryMission);
		GameOwner = none;
	}
	// End:0x108
	if(KismetOwner != none)
	{
		KismetOwner.EndMission();
		KismetOwner = none;
	}
	bIsTimed = false;
	//return;	
}

function Tick(float DeltaTime)
{
	TickObjectives(DeltaTime);
	TickTimer(DeltaTime);
	RemoveDeadObjectives();
	//return;	
}

function TickObjectives(float DeltaTime)
{
	local int I;
	local HaloObjective Objective;

	I = 0;
	J0x0B:

	// End:0xCD [Loop If]
	if(I < Objectives.Length)
	{
		Objective = Objectives[I];
		// End:0x7A
		if(Objective != none)
		{
			Objective.Tick(DeltaTime);			
		}
		else
		{
			WarnInternal("Removing NULL objective from " $ string(missionName));
			Objectives.Remove(I--, 1);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function TickTimer(float DeltaTime)
{
	// End:0x3E
	if(bIsTimed)
	{
		Timer -= DeltaTime;
		// End:0x3E
		if(Timer <= 0.0000000)
		{
			Fail();
		}
	}
	//return;	
}

function RemoveDeadObjectives()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x51 [Loop If]
	if(I < DeadObjectives.Length)
	{
		Objectives.RemoveItem(DeadObjectives[I]);
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	DeadObjectives.Length = 0;
	//return;	
}

function bool HasCompletedObjective(HaloObjective NewObjective)
{
	return CompletedObjectives.Find(NewObjective) != -1;
	//return ReturnValue;	
}

function bool AddObjective(HaloObjective NewObjective)
{
	local HaloObjective Obj;

	// End:0x17B
	if(NewObjective != none)
	{
		// End:0xB1
		foreach Objectives(Obj)
		{
			// End:0xB0
			if(Obj.ObjectiveName == NewObjective.ObjectiveName)
			{
				LogInternal((string(missionName) $ " already contains ") $ string(NewObjective.ObjectiveName));				
				return false;
			}			
		}		
		// End:0x15F
		foreach CompletedObjectives(Obj)
		{
			// End:0x15E
			if(Obj.ObjectiveName == NewObjective.ObjectiveName)
			{
				LogInternal((string(missionName) $ " already completed objective ") $ string(NewObjective.ObjectiveName));				
				return false;
			}			
		}		
		Objectives.AddItem(NewObjective);
		return true;		
	}
	else
	{
		WarnInternal("NULL Objective will not be added to " $ string(missionName));
	}
	return false;
	//return ReturnValue;	
}

function QueueObjectiveForRemoval(HaloObjective deadObjective)
{
	// End:0x45
	if(deadObjective != none)
	{
		// End:0x45
		if(DeadObjectives.Find(deadObjective) == -1)
		{
			DeadObjectives.AddItem(deadObjective);
		}
	}
	//return;	
}

function bool GetHighestPriorityNavigationPoint(out Actor NavPoint)
{
	local HaloObjective HPObjective;

	HPObjective = GetHighestPriorityObjective();
	// End:0x6C
	if(HPObjective != none)
	{
		NavPoint = HPObjective.GetNavigationPoint();
		return HPObjective.bUseNavigation;
	}
	NavPoint = none;
	return false;
	//return ReturnValue;	
}

function HaloObjective GetHighestPriorityObjective()
{
	local byte HPValue;
	local HaloObjective Objective, HPObjective;

	HPValue = 255;
	HPObjective = none;
	// End:0x9A
	foreach Objectives(Objective)
	{
		// End:0x99
		if(int(Objective.Priority) < int(HPValue))
		{
			HPObjective = Objective;
			HPValue = Objective.Priority;
		}		
	}	
	return HPObjective;
	//return ReturnValue;	
}

function CallDelegateOnAllPCs(optional Object param1 = none)
{
	local HaloPlayerPawnController PC;

	// End:0x75
	foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'MegaHaloGame.HaloPlayerPawnController', PC)
	{
		PCDelegate(PC, param1);		
	}	
	//return;	
}

function GiveReward()
{
	__PCDelegate__Delegate = GiveRewardToPC;
	CallDelegateOnAllPCs();
	//return;	
}

function GiveRewardToPC(HaloPlayerPawnController PC, Object NotUsed)
{
	// End:0xB0
	if(PC != none)
	{
		LogInternal((((("Giving Reward for " $ string(missionName)) $ ": ") $ string(Reward.BlokTotal)) $ " Bloks to ") $ string(PC));
		PC.AddBloksToBank(Reward.BlokTotal, true);
	}
	//return;	
}

function PlaySound(AkEvent Sound)
{
	// End:0x3D
	if(Sound != none)
	{
		__PCDelegate__Delegate = PlaySoundOnPC;
		CallDelegateOnAllPCs(Sound);
	}
	//return;	
}

function PlaySoundOnPC(HaloPlayerPawnController PC, Object SoundToPlay)
{
	// End:0x46
	if(PC != none)
	{
		PC.PlayAkEvent(AkEvent(SoundToPlay));
	}
	//return;	
}

function AnnounceMission()
{
	// End:0x36
	if(DisplayName != "")
	{
		__PCDelegate__Delegate = AnnounceMissionToPC;
		CallDelegateOnAllPCs();
	}
	//return;	
}

function AnnounceMissionToPC(HaloPlayerPawnController PC, Object NotUsed)
{
	local GFxHaloHUD HUD;

	// End:0xB9
	if(PC != none)
	{
		HUD = GFxHaloHUD(PC.myHUD);
		// End:0xB9
		if(HUD != none)
		{
			// End:0xB9
			if(HUD.HudMovie != none)
			{
				HUD.HudMovie.ShowMissionMessage(DisplayName, DisplayTime);
			}
		}
	}
	//return;	
}

function JsonObject Serialize()
{
	local JsonObject Data;

	Data = new Class'Engine.JsonObject';
	// End:0x105
	if(Data != none)
	{
		Data.SetStringValue("Name", PathName(self));
		Data.SetStringValue("ObjectArchetype", PathName(ObjectArchetype));
		Data.SetStringValue("MissionName", string(missionName));
		Data.SetBoolValue("IsPrimary", bIsPrimaryMission);
	}
	return Data;
	//return ReturnValue;	
}

function Deserialize(JsonObject Data)
{
	missionName = name(Data.GetStringValue("MissionName"));
	bIsPrimaryMission = Data.GetBoolValue("IsPrimary");
	//return;	
}

defaultproperties
{
	missionName="mission"
	bIsPrimaryMission=true
	DisplayTime=3.0000000
}