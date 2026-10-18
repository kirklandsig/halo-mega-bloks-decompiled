class HaloVehicleFactory_BansheeAI extends HaloVehicleFactory_Banshee;

var Route AIRoute;
var bool bUseSpline;
var SplineActor SplineStart;
var float ConstantSplineSpeed;
var HaloAIFlightController.EAIFlightSplineType SplineType;

function PathStarted()
{
	TriggerEventClass(Class'MegaHaloGame.SeqEvent_FlightAI', none, 5);
	//return;	
}

function PathFinished()
{
	TriggerEventClass(Class'MegaHaloGame.SeqEvent_FlightAI', none, 6);
	//return;	
}

function ThreatTriggered(HaloAIFlightController.EAIFlightThreats threat)
{
	TriggerEventClass(Class'MegaHaloGame.SeqEvent_FlightAI_Threat', none, int(threat));
	//return;	
}

simulated function OnToggle(SeqAct_Toggle Action)
{
	local HaloAIFlightController Controller;

	Controller = HaloAIFlightController(ChildVehicle.Controller);
	// End:0x174
	if(Controller != none)
	{
		// End:0x9A
		if(Action.InputLinks[0].bHasImpulse)
		{
			Controller.ActiveNotify(true);			
		}
		else
		{
			// End:0xF4
			if(Action.InputLinks[1].bHasImpulse)
			{
				Controller.ActiveNotify(false);				
			}
			else
			{
				// End:0x174
				if(Action.InputLinks[2].bHasImpulse)
				{
					Controller.ActiveNotify(((Controller.GetIsActive() == true) ? false : true));
				}
			}
		}
	}
	//return;	
}

function SetFlightRoute(Route newRoute)
{
	local HaloAIFlightController Controller;

	Controller = HaloAIFlightController(ChildVehicle.Controller);
	// End:0x83
	if((Controller != none) && newRoute != none)
	{
		AIRoute = newRoute;
		Controller.StartNewFlightPath();
	}
	//return;	
}

function SetFlightSpline(HaloAIFlightNode Start)
{
	local HaloAIFlightController Controller;

	Controller = HaloAIFlightController(ChildVehicle.Controller);
	// End:0x83
	if((Controller != none) && Start != none)
	{
		SplineStart = Start;
		Controller.StartNewFlightPath();
	}
	//return;	
}

defaultproperties
{
	VehicleClassPath="MegaHaloGameContent.HaloVehicle_BansheeAI_Content"
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloVehicleFactory_BansheeAI.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloVehicleFactory_Banshee.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=none
	Components[1]=CollisionCylinder
	Components[2]=none
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloVehicleFactory_BansheeAI.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloVehicleFactory_Banshee.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	Components[3]=MyLightEnvironment
	Components[4]=none
	CollisionComponent=CollisionCylinder
	SupportedEvents=/* ERROR: System.ArgumentOutOfRangeException */
}