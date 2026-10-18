class GwNavPawn extends Pawn
	abstract
	native
	config(GwNavEngine);

var export editinline GwNavHandle myGwNavHandle;
var GwNavNavdataFamily NavDataFamily;

// Export UGwNavPawn::execMoveToPosition(FFrame&, void* const)
native function MoveToPosition(Vector vTargetPosition);

// Export UGwNavPawn::execIsArrived(FFrame&, void* const)
native function bool IsArrived();

// Export UGwNavPawn::execIntializeNavigationBot(FFrame&, void* const)
native function IntializeNavigationBot(GwNavNavdataFamily Family, bool EnableAvoidance, bool EnableShortcut, int AllowedCanTraverseType);

defaultproperties
{
	// Reference: GwNavBotHandle'GwNavEngine.Default__GwNavPawn.myGwNavBotHandle'
	begin object name="myGwNavBotHandle" class=GwNavEngine.GwNavBotHandle
	end object
	myGwNavHandle=myGwNavBotHandle
	NavDataFamily=GwNavNavdataFamily'EngineGwNav.DefaultFamily'
	// Reference: CylinderComponent'GwNavEngine.Default__GwNavPawn.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__Pawn.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	PassiveObjectiveWeight=1.0000000
	PassiveSecondaryWeight=1.0000000
	AggressiveMobileWeight=1.0000000
	AggressiveStationaryWeight=1.0000000
	Components[0]=none
	Components[1]=CollisionCylinder
	Components[2]=none
	Components[3]=myGwNavBotHandle
	CollisionComponent=CollisionCylinder
}