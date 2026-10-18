class SeqAct_GetAIAlive extends SeqAct_Latent;

var array< Class<Pawn> > SpecificPawnTypes;
var bool CountAllPawns;
var int TeamFilter;
var int TrueWhenLessThanOrEqualTo;

static event int GetObjClassVersion()
{
	return super(SequenceObject).GetObjClassVersion() + 0;
	//return ReturnValue;	
}

event Activated()
{
	DoCheckCount();
	//return;	
}

event bool Update(float DeltaTime)
{
	return DoCheckCount();
	//return ReturnValue;	
}

function bool DoCheckCount()
{
	local int PawnTypesIter, TotalAICount, I, ct;

	TotalAICount = 0;
	// End:0x4D
	if(CountAllPawns)
	{
		TotalAICount = Class'UDKBase.CCSNorman'.static.GetTotalBrainCount(TeamFilter);		
	}
	else
	{
		// End:0xCC
		if(SpecificPawnTypes.Length > 0)
		{
			PawnTypesIter = 0;
			J0x68:

			// End:0xCC [Loop If]
			if(PawnTypesIter < SpecificPawnTypes.Length)
			{
				TotalAICount += Class'UDKBase.CCSNorman'.static.GetBrainCountByPawnType(SpecificPawnTypes[PawnTypesIter]);
				PawnTypesIter += 1;
				// [Loop Continue]
				goto J0x68;
			}
		}
	}
	// End:0x1A7
	if(TotalAICount <= TrueWhenLessThanOrEqualTo)
	{
		ct = VariableLinks[0].LinkedVariables.Length;
		I = 0;
		J0x117:

		// End:0x184 [Loop If]
		if(I < ct)
		{
			SeqVar_Bool(VariableLinks[0].LinkedVariables[I]).bValue = 1;
			I++;
			// [Loop Continue]
			goto J0x117;
		}
		OutputLinks[0].bHasImpulse = true;
		return false;
	}
	return true;
	//return ReturnValue;	
}

defaultproperties
{
	TeamFilter=2
	bCallHandler=false
	OutputLinks[0]=(Links=none,LinkDesc="Finished",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,bIsActivated=false)
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Bool',LinkedVariables=none,LinkDesc="Target",LinkVar="None",PropertyName="Targets",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Get AI Alive"
}