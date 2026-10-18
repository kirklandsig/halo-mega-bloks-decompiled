class SeqAct_ControlMovieTexture extends SequenceAction;

enum EMovieControlType
{
	MCT_Play,                       // 0
	MCT_Stop,                       // 1
	MCT_Pause,                      // 2
	MCT_MAX                         // 3
};

var TextureMovie MovieTexture;

event Activated()
{
	local PlayerController PC;
	local SeqAct_ControlMovieTexture.EMovieControlType Mode;

	// End:0x1B7
	if(MovieTexture != none)
	{
		// End:0x40
		if(InputLinks[0].bHasImpulse)
		{
			Mode = 0;			
		}
		else
		{
			// End:0x71
			if(InputLinks[1].bHasImpulse)
			{
				Mode = 1;				
			}
			else
			{
				// End:0xA0
				if(InputLinks[2].bHasImpulse)
				{
					Mode = 2;
				}
			}
		}
		// End:0x1B6
		foreach GetWorldInfo().AllControllers(Class'Engine.PlayerController', PC)
		{
			// End:0x1B5
			if(((LocalPlayer(PC.Player) != none) && PC.IsPrimaryPlayer()) || (NetConnection(PC.Player) != none) && ChildConnection(PC.Player) == none)
			{
				PC.ClientControlMovieTexture(MovieTexture, Mode);
			}			
		}		
	}
	//return;	
}

defaultproperties
{
	bCallHandler=false
	InputLinks[0]=(LinkDesc="Play",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	InputLinks[1]=(LinkDesc="Stop",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	InputLinks[2]=(LinkDesc="Pause",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false)
	VariableLinks=none
	ObjName="Control Movie Texture"
}