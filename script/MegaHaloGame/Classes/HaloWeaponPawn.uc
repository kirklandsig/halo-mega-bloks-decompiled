class HaloWeaponPawn extends UTWeaponPawn
	config(GwNavEngine)
	implements(HaloVehicleInterface);

var export editinline HaloTargetableComponent_Vehicle HaloTargetableComponent;
var float CameraYawRate;

simulated event PostBeginPlay()
{
	super(SVehicle).PostBeginPlay();
	// End:0x38
	if(HaloTargetableComponent != none)
	{
		HaloTargetableComponent.PostBeginPlay();
	}
	//return;	
}

simulated function AttachDriver(Pawn P)
{
	local HaloVehicle V;

	V = HaloVehicle(MyVehicle);
	// End:0x5F
	if(V != none)
	{
		V.AttachDriverToSeat(P, MySeatIndex);		
	}
	else
	{
		super.AttachDriver(P);
	}
	//return;	
}

function AttachDriverNow(HaloPawn P)
{
	AttachDriver(P);
	//return;	
}

event bool DriverLeave(bool bForceLeave)
{
	local HaloPawn HaloDriver;
	local HaloVehicle MyHaloVehicle;
	local name AnimName;
	local int exitIndex;

	// End:0x18E
	if(bForceLeave!)
	{
		HaloDriver = HaloPawn(Driver);
		// End:0x18E
		if(HaloDriver != none)
		{
			MyHaloVehicle = HaloVehicle(MyVehicle);
			// End:0x15B
			if((MyHaloVehicle != none) && MyHaloVehicle.EntryPoints.Length > MySeatIndex)
			{
				exitIndex = MyHaloVehicle.GetValidExitPointIndex(MySeatIndex);
				exitIndex = ((exitIndex == -1) ? MyHaloVehicle.GetFirstEntryPoint(MySeatIndex) : exitIndex);
				AnimName = MyHaloVehicle.EntryPoints[exitIndex].ExitPawnAnimName;
			}
			HaloDriver.DriverLeave(AnimName, Controller);
			return true;
		}
	}
	return super.DriverLeave(bForceLeave);
	//return ReturnValue;	
}

function DriverLeaveNow()
{
	DriverLeave(false);
	//return;	
}

simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRotation)
{
	local int I;
	local bool doConstrainPitch, doConstrainYaw;
	local float MaxPitch, MinPitch, MaxYaw, MinYaw;
	local Vector X, Y, Z;
	local Vector2D aDistance;
	local float clampAngle;

	super.ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRotation);
	// End:0x550
	if(MyVehicle != none)
	{
		MinYaw = 180.0000000;
		MaxYaw = -180.0000000;
		MinPitch = 180.0000000;
		MaxPitch = -180.0000000;
		I = 0;
		J0x7B:

		// End:0x3BD [Loop If]
		if(I < MyVehicle.Seats[MySeatIndex].TurretControllers.Length)
		{
			// End:0x23A
			if(MyVehicle.Seats[MySeatIndex].TurretControllers[I].bConstrainPitch == true)
			{
				doConstrainPitch = true;
				MinPitch = FMin(MinPitch, float(MyVehicle.Seats[MySeatIndex].TurretControllers[I].MinAngle.PitchConstraint));
				MaxPitch = FMax(MaxPitch, float(MyVehicle.Seats[MySeatIndex].TurretControllers[I].MaxAngle.PitchConstraint));
			}
			// End:0x3AF
			if(MyVehicle.Seats[MySeatIndex].TurretControllers[I].bConstrainYaw == true)
			{
				doConstrainYaw = true;
				MinYaw = FMin(MinYaw, float(MyVehicle.Seats[MySeatIndex].TurretControllers[I].MinAngle.YawConstraint));
				MaxYaw = FMax(MaxYaw, float(MyVehicle.Seats[MySeatIndex].TurretControllers[I].MaxAngle.YawConstraint));
			}
			I++;
			// [Loop Continue]
			goto J0x7B;
		}
		GetAxes(MyVehicle.Rotation, X, Y, Z);
		GetAngularDistance(aDistance, Vector(out_ViewRotation), X, Y, Z);
		// End:0x4E8
		if(doConstrainPitch == true)
		{
			clampAngle = FClamp(aDistance.Y * 10430.3779297, MinPitch * 182.0444031, MaxPitch * 182.0444031);
			out_ViewRotation.Pitch += NormalizeRotAxis(int(clampAngle - (aDistance.Y * 10430.3779297)));
		}
		// End:0x4F8
		if(doConstrainYaw == true)
		{
		}
		out_ViewRotation.Pitch = Clamp(out_ViewRotation.Pitch, int(float(-85) * 182.0444031), int(float(85) * 182.0444031));
	}
	//return;	
}

simulated event byte ScriptGetTeamNum()
{
	return MyVehicle.GetTeamNum();
	//return ReturnValue;	
}

simulated event Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
	local Vector SocketLocation;
	local Rotator SocketRotation;

	MyVehicle.Mesh.GetSocketWorldLocationAndRotation(MyVehicle.Seats[MySeatIndex].GunSocket[MyVehicle.GetBarrelIndex(MySeatIndex)], SocketLocation, SocketRotation);
	return SocketLocation;
	//return ReturnValue;	
}

simulated function int GetDriverTeamNum()
{
	local HaloVehicle V;

	V = HaloVehicle(MyVehicle);
	// End:0x4B
	if(V != none)
	{
		return V.GetDriverTeamNum();
	}
	return 0;
	//return ReturnValue;	
}

simulated function HaloNeedleTargetComponent GetNeedleTargetComponent()
{
	local HaloVehicle V;

	V = HaloVehicle(MyVehicle);
	// End:0x4B
	if(V != none)
	{
		return V.GetNeedleTargetComponent();
	}
	return none;
	//return ReturnValue;	
}

defaultproperties
{
	// Reference: HaloTargetableComponent_Vehicle'MegaHaloGame.Default__HaloWeaponPawn.MyHaloTargetableComponent'
	begin object name="MyHaloTargetableComponent" class=MegaHaloGame.HaloTargetableComponent_Vehicle
	end object
	HaloTargetableComponent=MyHaloTargetableComponent
	CameraYawRate=100.0000000
	// Reference: GwNavBotHandle'MegaHaloGame.Default__HaloWeaponPawn.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'UTGame.Default__UTWeaponPawn.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	// Reference: RB_StayUprightSetup'MegaHaloGame.Default__HaloWeaponPawn.MyStayUprightSetup'
	// Archetype: RB_StayUprightSetup'UTGame.Default__UTWeaponPawn.MyStayUprightSetup'
	begin object name="MyStayUprightSetup"
	end object
	StayUprightConstraintSetup=MyStayUprightSetup
	// Reference: RB_ConstraintInstance'MegaHaloGame.Default__HaloWeaponPawn.MyStayUprightConstraintInstance'
	// Archetype: RB_ConstraintInstance'UTGame.Default__UTWeaponPawn.MyStayUprightConstraintInstance'
	begin object name="MyStayUprightConstraintInstance"
	end object
	StayUprightConstraintInstance=MyStayUprightConstraintInstance
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponPawn.SVehicleMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SVehicleMesh'
	// Archetype: SkeletalMeshComponent'UTGame.Default__UTWeaponPawn.SVehicleMesh'
	begin object name="SVehicleMesh"
		ReplacementPrimitive=none
	end object
	Mesh=SVehicleMesh
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloWeaponPawn.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'UTGame.Default__UTWeaponPawn.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	Components[1]=SVehicleMesh
	Components[2]=myGwNavBotHandle
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloWeaponPawn.targetableComponent'
	begin object name="targetableComponent" class=UDKBase.UDKTargetableComponent
		BaseThreatVal=5000
	end object
	Components[3]=targetableComponent
	Components[4]=MyHaloTargetableComponent
	CollisionComponent=SVehicleMesh
}