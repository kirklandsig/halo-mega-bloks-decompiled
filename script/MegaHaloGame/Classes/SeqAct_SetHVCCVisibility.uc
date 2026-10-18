class SeqAct_SetHVCCVisibility extends SequenceAction;

var array<Actor> Actors;
var bool IsVisible;

event Activated()
{
	local Actor Act;
	local HaloVCustomizationComponent HVCC;

	// End:0xA0
	foreach Actors(Act)
	{
		// End:0x9F
		if(Act != none)
		{
			HVCC = HaloVCustomizationComponent(Act);
			// End:0x9F
			if(HVCC != none)
			{
				// End:0x80
				if(IsVisible)
				{
					HVCC.show();					
				}
				else
				{
					HVCC.Hide();
				}
			}
		}		
	}	
	//return;	
}

defaultproperties
{
	IsVisible=true
	bCallHandler=false
	bAutoActivateOutputLinks=false
	OutputLinks=none
	VariableLinks[0]=(ExpectedType=Class'Engine.SeqVar_Object',LinkedVariables=none,LinkDesc="Customization Actor",LinkVar="None",PropertyName="Actors",bWriteable=false,bSequenceNeverReadsOnlyWritesToThisVar=false,bModifiesLinkedObject=false,bHidden=false,MinVars=0,MaxVars=255,DrawX=0,CachedProperty=none,bAllowAnyType=false,bMoving=false,bClampedMax=false,bClampedMin=false)
	ObjName="Set Halo Vehicle Customization Visibility"
}