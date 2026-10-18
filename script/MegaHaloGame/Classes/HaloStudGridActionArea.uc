class HaloStudGridActionArea extends Actor
	notplaceable;

var HaloStudGridActor AssociatedStudGrid;
var export editinline CylinderComponent TouchCylinder;

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	local Pawn touchingPawn;

	touchingPawn = Pawn(Other);
	// End:0x113
	if((((AssociatedStudGrid != none) && AssociatedStudGrid.StudComponent.HasOpenPegs()) && touchingPawn != none) && HaloPlayerPawnController(touchingPawn.Controller) != none)
	{
		HaloPlayerPawnController(touchingPawn.Controller).RegisterActionableStudGrid(AssociatedStudGrid);
		AssociatedStudGrid.SetActionableState(touchingPawn, true);
	}
	//return;	
}

simulated event UnTouch(Actor Other)
{
	local Pawn untouchingPawn;

	untouchingPawn = Pawn(Other);
	// End:0xDA
	if(((AssociatedStudGrid != none) && untouchingPawn != none) && HaloPlayerPawnController(untouchingPawn.Controller) != none)
	{
		HaloPlayerPawnController(untouchingPawn.Controller).UnregisterActionableStudGrid(AssociatedStudGrid);
		AssociatedStudGrid.SetActionableState(untouchingPawn, false);
	}
	//return;	
}

defaultproperties
{
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloStudGridActionArea.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	begin object name="CollisionCylinder" class=Engine.CylinderComponent
		CollisionHeight=250.0000000
		CollisionRadius=200.0000000
		ReplacementPrimitive=none
		CollideActors=true
		Translation=(X=-10.0000000,Y=0.0000000,Z=0.0000000)
	end object
	TouchCylinder=CollisionCylinder
	Components[0]=CollisionCylinder
	CollisionType=ECollisionType.COLLIDE_TouchAll
	bCollideActors=true
	CollisionComponent=CollisionCylinder
}