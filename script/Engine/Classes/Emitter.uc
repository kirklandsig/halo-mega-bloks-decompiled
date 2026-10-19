class Emitter extends Actor
	native
	placeable;

struct CheckpointRecord
{
	var bool bIsActive;

	structdefaultproperties
	{
		bIsActive=false
	}
};

var const editconst export editinline ParticleSystemComponent ParticleSystemComponent;
var const editconst export editinline DynamicLightEnvironmentComponent LightEnvironment;
var bool bDestroyOnSystemFinish;
var bool bPostUpdateTickGroup;
var repnotify bool bCurrentlyActive;

replication
{
	// Pos:0x000
	if(bNoDelete)
		bCurrentlyActive;
}

// Export UEmitter::execSetTemplate(FFrame&, void* const)
native event SetTemplate(ParticleSystem NewTemplate, optional bool bDestroyOnFinish);

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	// End:0x67
	if((WorldInfo.NetMode == NM_DedicatedServer) && (RemoteRole == ROLE_None) || bNetTemporary)
	{
		LifeSpan = 0.2000000;
	}
	// End:0xD0
	if(ParticleSystemComponent != none)
	{
		ParticleSystemComponent.__OnSystemFinished__Delegate = OnParticleSystemFinished;
		bCurrentlyActive = ParticleSystemComponent.bAutoActivate;
	}
	//return;	
}

simulated event ReplicatedEvent(name VarName)
{
	// End:0x44
	if(VarName == 'bCurrentlyActive')
	{
		ParticleSystemComponent.SetActive(bCurrentlyActive);		
	}
	else
	{
		super.ReplicatedEvent(VarName);
	}
	//return;	
}

simulated function OnParticleSystemFinished(ParticleSystemComponent FinishedComponent)
{
	// End:0x1C
	if(bDestroyOnSystemFinish)
	{
		LifeSpan = 0.0001000;
	}
	bCurrentlyActive = false;
	//return;	
}

function OnToggle(SeqAct_Toggle Action)
{
	// End:0x66
	if(Action.InputLinks[0].bHasImpulse)
	{
		ParticleSystemComponent.ActivateSystem();
		bCurrentlyActive = true;		
	}
	else
	{
		// End:0xCB
		if(Action.InputLinks[1].bHasImpulse)
		{
			ParticleSystemComponent.DeactivateSystem();
			bCurrentlyActive = false;			
		}
		else
		{
			// End:0x190
			if(Action.InputLinks[2].bHasImpulse)
			{
				// End:0x165
				if(ParticleSystemComponent.bSuppressSpawning || !bCurrentlyActive)
				{
					ParticleSystemComponent.ActivateSystem();
					bCurrentlyActive = true;					
				}
				else
				{
					ParticleSystemComponent.DeactivateSystem();
					bCurrentlyActive = false;
				}
			}
		}
	}
	ParticleSystemComponent.LastRenderTime = WorldInfo.TimeSeconds;
	ForceNetRelevant();
	// End:0x214
	if(RemoteRole != ROLE_None)
	{
		SetForcedInitialReplicatedProperty(BoolProperty'Engine.Emitter.bCurrentlyActive', bCurrentlyActive == default.bCurrentlyActive);
	}
	//return;	
}

function OnParticleEventGenerator(SeqAct_ParticleEventGenerator Action)
{
	//return;	
}

simulated function ShutDown()
{
	super.ShutDown();
	bCurrentlyActive = false;
	//return;	
}

simulated function SetFloatParameter(name ParameterName, float Param)
{
	// End:0x43
	if(ParticleSystemComponent != none)
	{
		ParticleSystemComponent.SetFloatParameter(ParameterName, Param);		
	}
	else
	{
		LogInternal(("Warning: Attempting to set a parameter on " $ string(self)) $ " when the PSC does not exist");
	}
	//return;	
}

simulated function SetVectorParameter(name ParameterName, Vector Param)
{
	// End:0x43
	if(ParticleSystemComponent != none)
	{
		ParticleSystemComponent.SetVectorParameter(ParameterName, Param);		
	}
	else
	{
		LogInternal(("Warning: Attempting to set a parameter on " $ string(self)) $ " when the PSC does not exist");
	}
	//return;	
}

simulated function SetColorParameter(name ParameterName, Color Param)
{
	// End:0x43
	if(ParticleSystemComponent != none)
	{
		ParticleSystemComponent.SetColorParameter(ParameterName, Param);		
	}
	else
	{
		LogInternal(("Warning: Attempting to set a parameter on " $ string(self)) $ " when the PSC does not exist");
	}
	//return;	
}

simulated function SetExtColorParameter(name ParameterName, byte Red, byte Green, byte Blue, byte Alpha)
{
	local Color C;

	// End:0xDB
	if(ParticleSystemComponent != none)
	{
		C.R = Red;
		C.G = Green;
		C.B = Blue;
		C.A = Alpha;
		ParticleSystemComponent.SetColorParameter(ParameterName, C);		
	}
	else
	{
		LogInternal(("Warning: Attempting to set a parameter on " $ string(self)) $ " when the PSC does not exist");
	}
	//return;	
}

simulated function SetActorParameter(name ParameterName, Actor Param)
{
	// End:0x43
	if(ParticleSystemComponent != none)
	{
		ParticleSystemComponent.SetActorParameter(ParameterName, Param);		
	}
	else
	{
		LogInternal(("Warning: Attempting to set a parameter on " $ string(self)) $ " when the PSC does not exist");
	}
	//return;	
}

simulated function OnSetParticleSysParam(SeqAct_SetParticleSysParam Action)
{
	local int Idx, ParamIdx;

	// End:0x267
	if((ParticleSystemComponent != none) && Action.InstanceParameters.Length > 0)
	{
		Idx = 0;
		J0x41:

		// End:0x267 [Loop If]
		if(Idx < Action.InstanceParameters.Length)
		{
			// End:0x259
			if(int(Action.InstanceParameters[Idx].ParamType) != 0)
			{
				ParamIdx = ParticleSystemComponent.InstanceParameters.Find('Name', Action.InstanceParameters[Idx].Name);
				// End:0x18C
				if(ParamIdx == -1)
				{
					ParamIdx = ParticleSystemComponent.InstanceParameters.Length;
					ParticleSystemComponent.InstanceParameters.Length = ParamIdx + 1;
				}
				ParticleSystemComponent.InstanceParameters[ParamIdx] = Action.InstanceParameters[Idx];
				// End:0x259
				if(Action.bOverrideScalar)
				{
					ParticleSystemComponent.InstanceParameters[ParamIdx].Scalar = Action.ScalarValue;
				}
			}
			Idx++;
			// [Loop Continue]
			goto J0x41;
		}
	}
	//return;	
}

function bool ShouldSaveForCheckpoint()
{
	return bNoDelete && RemoteRole != ROLE_None;
	//return ReturnValue;	
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
	Record.bIsActive = bCurrentlyActive;
	//return;	
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
	bCurrentlyActive = Record.bIsActive;
	// End:0x58
	if(bCurrentlyActive)
	{
		ParticleSystemComponent.ActivateSystem();		
	}
	else
	{
		ParticleSystemComponent.DeactivateSystem();
	}
	ForceNetRelevant();
	//return;	
}

simulated function HideSelf()
{
	//return;	
}

defaultproperties
{
	// Reference: ParticleSystemComponent'Engine.Default__Emitter.ParticleSystemComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent0'
	begin object name="ParticleSystemComponent0" class=Engine.ParticleSystemComponent
		ReplacementPrimitive=none
	end object
	ParticleSystemComponent=ParticleSystemComponent0
	Components[0]=none
	Components[1]=ParticleSystemComponent0
	Components[2]=none
	CollisionType=COLLIDE_CustomDefault
	TickGroup=TG_DuringAsyncWork
	bNoDelete=true
	bHardAttach=true
	bGameRelevant=true
	bEdShouldSnap=true
	SupportedEvents[0]=Class'Engine.SeqEvent_Touch'
	SupportedEvents[1]=Class'Engine.SeqEvent_Destroyed'
	SupportedEvents[2]=Class'Engine.SeqEvent_TakeDamage'
	SupportedEvents[3]=Class'Engine.SeqEvent_HitWall'
	SupportedEvents[4]=Class'Engine.SeqEvent_AnimNotify'
	SupportedEvents[5]=Class'Engine.SeqEvent_MobileTouch'
	SupportedEvents[6]=Class'Engine.SeqEvent_ParticleEvent'
}