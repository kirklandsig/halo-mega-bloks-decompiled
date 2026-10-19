class HaloTargetableComponent_Vehicle extends HaloTargetableComponent;

var name AimLocationSocket;
var UTVehicle Vehicle;
var HaloVehicleInterface VehicleInterface;

simulated function PostBeginPlay()
{
	Vehicle = UTVehicle(Owner);
	VehicleInterface = HaloVehicleInterface(Owner);
	//return;	
}

simulated function bool IsDead()
{
	return Vehicle.Health <= 0;
	//return ReturnValue;	
}

simulated function byte GetTeamNum()
{
	return byte(VehicleInterface.GetDriverTeamNum());
	//return ReturnValue;	
}

simulated function Vector GetAimLocation(Vector FromLoc)
{
	local Vector AimLoc;

	// End:0xB6
	if(AimLocationSocket != 'None')
	{
		// End:0xAC
		if(!Vehicle.Mesh.GetSocketWorldLocationAndRotation(AimLocationSocket, AimLoc))
		{
			AimLoc = Vehicle.Mesh.GetBoneLocation(AimLocationSocket);
		}
		return AimLoc;
	}
	return super.GetAimLocation(FromLoc);
	//return ReturnValue;	
}

simulated function HaloNeedleTargetComponent GetNeedleTargetComponent()
{
	return VehicleInterface.GetNeedleTargetComponent();
	//return ReturnValue;	
}

simulated function SkeletalMeshComponent GetSkeletalMesh()
{
	return Vehicle.Mesh;
	//return ReturnValue;	
}
