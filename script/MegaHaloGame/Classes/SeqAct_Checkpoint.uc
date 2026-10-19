class SeqAct_Checkpoint extends SequenceAction;

var float CheckpointId;
var bool bPlayCheckpointReachedSound;
var bool bShowCheckpointReachedMessage;
var AkEvent CheckpointReachedSound;
var float CheckpointReachedMessageDuration;
var const localized string CheckpointReachedMessage;

event Activated()
{
	local GFxHaloHUD HUD;
	local HaloGameConquest Game;
	local HaloPlayerPawnController PC;

	LogInternal("Activated checkpoint " $ string(CheckpointId));
	Game = HaloGameConquest(GetWorldInfo().Game);
	// End:0x256
	if(Game != none)
	{
		// End:0x1CB
		foreach Game.TheMainPlayerGroup.PlayerControllers(PC)
		{
			// End:0x1CA
			if(PC != none)
			{
				// End:0x104
				if(bPlayCheckpointReachedSound && CheckpointReachedSound != none)
				{
					PC.PlayAkEvent(CheckpointReachedSound);
				}
				// End:0x1CA
				if(bShowCheckpointReachedMessage)
				{
					HUD = GFxHaloHUD(PC.myHUD);
					// End:0x1CA
					if((HUD != none) && HUD.HudMovie != none)
					{
						HUD.HudMovie.ShowUpdateMessage(CheckpointReachedMessage, CheckpointReachedMessageDuration, "checkpoint");
					}
				}
			}			
		}		
		Game.CheckpointRespawnPoint = Game.CurrentRespawnPoint;
		// End:0x256
		if(!Game.bIsDemoMode)
		{
			Game.SaveCheckpoint(CheckpointId);
		}
	}
	OutputLinks[0].bHasImpulse = true;
	//return;	
}

defaultproperties
{
	bPlayCheckpointReachedSound=true
	bShowCheckpointReachedMessage=true
	CheckpointReachedMessageDuration=3.0000000
	bCallHandler=false
	bAutoActivateOutputLinks=false
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Float',LinkedVariables=none,LinkDesc="Checkpoint",LinkVar="None",PropertyName="CheckpointId",bWriteable=true,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=1,MaxVars=1,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Checkpoint"
}