class GwNavVehicle extends SVehicle
	abstract
	native
	config(GwNavEngine);

enum EHaloVehicleCommand
{
	HVC_BOOST,                      // 0
	HVC_STOPBOOST,                  // 1
	HVC_FORCEFIRE,                  // 2
	HVC_STOPFIRE,                   // 3
	HVC_MAX                         // 4
};

var export editinline GwNavHandle myGwNavHandle;
var GwNavNavdataFamily NavDataFamily;
var float CircleDistance;
var bool CircleLeft;
var bool bLookSteerOnAllPlatforms;
var bool IsOccupied;

// Export UGwNavVehicle::execMoveToPosition(FFrame&, void* const)
native function MoveToPosition(Vector vTargetPosition);

// Export UGwNavVehicle::execIsArrived(FFrame&, void* const)
native function bool IsArrived();

// Export UGwNavVehicle::execIntializeNavigationBot(FFrame&, void* const)
native function IntializeNavigationBot(GwNavNavdataFamily Family, bool EnableAvoidance, bool EnableShortcut, int AllowedCanTraverseType);

event ExecuteVehicleCommand(GwNavVehicle.EHaloVehicleCommand HVC)
{
	//return;	
}

defaultproperties
{
	// Reference: GwNavBotHandle'GwNavEngine.Default__GwNavVehicle.myGwNavBotHandle'
	begin object name="myGwNavBotHandle" class=GwNavEngine.GwNavBotHandle
	end object
	myGwNavHandle=myGwNavBotHandle
	NavDataFamily=GwNavNavdataFamily'EngineGwNav.VehicleFamily'
	CircleDistance=1200.0000000
	// Reference: RB_StayUprightSetup'GwNavEngine.Default__GwNavVehicle.MyStayUprightSetup'
	// Archetype: RB_StayUprightSetup'Engine.Default__SVehicle.MyStayUprightSetup'
	begin object name="MyStayUprightSetup"
	end object
	StayUprightConstraintSetup=MyStayUprightSetup
	// Reference: RB_ConstraintInstance'GwNavEngine.Default__GwNavVehicle.MyStayUprightConstraintInstance'
	// Archetype: RB_ConstraintInstance'Engine.Default__SVehicle.MyStayUprightConstraintInstance'
	begin object name="MyStayUprightConstraintInstance"
	end object
	StayUprightConstraintInstance=MyStayUprightConstraintInstance
	// Reference: SkeletalMeshComponent'GwNavEngine.Default__GwNavVehicle.SVehicleMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SVehicleMesh'
	// Archetype: SkeletalMeshComponent'Engine.Default__SVehicle.SVehicleMesh'
	begin object name="SVehicleMesh"
		ReplacementPrimitive=none
	end object
	Mesh=SVehicleMesh
	// Reference: CylinderComponent'GwNavEngine.Default__GwNavVehicle.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__SVehicle.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	PassiveObjectiveWeight=1.0000000
	PassiveSecondaryWeight=1.0000000
	AggressiveMobileWeight=1.0000000
	AggressiveStationaryWeight=1.0000000
	Components[0]=CollisionCylinder
	Components[1]=SVehicleMesh
	Components[2]=myGwNavBotHandle
	CollisionComponent=SVehicleMesh
}