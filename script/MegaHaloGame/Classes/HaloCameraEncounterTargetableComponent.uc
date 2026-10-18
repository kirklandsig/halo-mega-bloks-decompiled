class HaloCameraEncounterTargetableComponent extends ActorComponent;

var HaloPlayerCamera.EEncounterPriorityLevel PriorityLevel;

simulated function Tick(float DeltaTime)
{
	local PlayerController PC;

	// End:0xC6
	foreach Owner.WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
	{
		// End:0xC5
		if(HaloPlayerCamera(PC.PlayerCamera) != none)
		{
			HaloPlayerCamera(PC.PlayerCamera).EncounterTarget(Owner, PriorityLevel);
		}		
	}	
	//return;	
}
