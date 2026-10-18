class GwNavWorldActor extends Actor
	native
	notplaceable;

var private Pointer NativeWorld;
var export editinline GwNavWorldRenderingComponent RenderingComp;
var export editinline GwNavWorldElementRenderingComponent WorldElementRenderingComp;
var array<int> DatabasesNavChangeCount;

defaultproperties
{
	// Reference: GwNavWorldRenderingComponent'GwNavEngine.Default__GwNavWorldActor.NavMeshComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NavMeshComponent'
	begin object name="NavMeshComponent" class=GwNavEngine.GwNavWorldRenderingComponent
		ReplacementPrimitive=none
	end object
	RenderingComp=NavMeshComponent
	// Reference: GwNavWorldElementRenderingComponent'GwNavEngine.Default__GwNavWorldActor.ElementRenderingComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ElementRenderingComponent'
	begin object name="ElementRenderingComponent" class=GwNavEngine.GwNavWorldElementRenderingComponent
		ReplacementPrimitive=none
	end object
	WorldElementRenderingComp=ElementRenderingComponent
	CollisionType=ECollisionType.COLLIDE_CustomDefault
}