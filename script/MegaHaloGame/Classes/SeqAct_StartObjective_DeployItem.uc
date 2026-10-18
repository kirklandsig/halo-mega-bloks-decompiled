class SeqAct_StartObjective_DeployItem extends SeqAct_StartObjective;

var HaloObjective.EObjectiveMarker Marker;
var bool bDraw;
var bool bShowHealth;
var bool bShowDistance;
var bool bClampToScreen;
var float RepathDelay;
var array<DeployableInfo> DeployableItems;
var int MinDeploys;

function CreateObjective()
{
	Objective = new Class'MegaHaloGame.HaloObjective_DeployItem';
	//return;	
}

function SetObjectiveProperties()
{
	local int I;
	local HaloObjective_DeployItem DeployItem;
	local DeployableObjective DeployObjective;

	DeployItem = HaloObjective_DeployItem(Objective);
	// End:0x2E8
	if(DeployItem != none)
	{
		I = 0;
		J0x36:

		// End:0x232 [Loop If]
		if(I < DeployableItems.Length)
		{
			DeployObjective.DeployMarker.Actor = DeployableItems[I].Location;
			DeployObjective.DeployMarker.Marker = Marker;
			DeployObjective.DeployMarker.bDraw = bDraw;
			DeployObjective.DeployMarker.bShowHealth = bShowHealth;
			DeployObjective.DeployMarker.bShowDistance = bShowDistance;
			DeployObjective.DeployMarker.bClampToScreen = bClampToScreen;
			DeployObjective.HDM = CreateDeploymentMonitor(I);
			DeployItem.DeployableObjectives.AddItem(DeployObjective);
			I++;
			// [Loop Continue]
			goto J0x36;
		}
		MinDeploys = Clamp(MinDeploys, 0, DeployableItems.Length);
		DeployItem.MinDeploys = ((MinDeploys == 0) ? DeployableItems.Length : MinDeploys);
		DeployItem.RepathTimer = RepathDelay;
		DeployItem.RepathDelay = RepathDelay;		
	}
	else
	{
		WarnInternal("Error creating new Objective -- not of type HaloObjective_DeployItem");
	}
	super.SetObjectiveProperties();
	//return;	
}

function HaloDeploymentMonitor CreateDeploymentMonitor(int Idx)
{
	local HaloGameDefault HGD;
	local HaloDeploymentMonitor HDM;
	local HaloPlayerPawnController HPPC;

	HDM = new Class'MegaHaloGame.HaloDeploymentMonitor';
	HDM.DeployableItem = DeployableItems[Idx];
	HDM.ParentObj = HaloObjective_DeployItem(Objective);
	HGD = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
	// End:0x14B
	if(HGD != none)
	{
		// End:0x14A
		foreach HGD.TheMainPlayerGroup.PlayerControllers(HPPC)
		{
			// End:0x149
			if(HPPC != none)
			{
				HPPC.AddDeploymentMonitor(HDM);
			}			
		}		
	}
	return HDM;
	//return ReturnValue;	
}

defaultproperties
{
	Marker=EObjectiveMarker.OMN_Use
	bDraw=true
	bShowDistance=true
	bClampToScreen=true
	RepathDelay=5.0000000
	ObjectiveName="Deploy Item"
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Objective",LinkVar="None",PropertyName="Objective",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks[1]=(ExpectedType=Class'Engine.SeqVar_Int',LinkedVariables=none,LinkDesc="Min Deploys",LinkVar="None",PropertyName="MinDeploys",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Start Deploy Item Objective"
}