class DecalActorBase extends Actor
	abstract
	native
	notplaceable
	implements(EditorLinkSelectionInterface);

var private native const noexport Pointer VfTable_IEditorLinkSelectionInterface;
var const editconst export editinline DecalComponent Decal;

defaultproperties
{
	// Reference: DecalComponent'Engine.Default__DecalActorBase.NewDecalComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NewDecalComponent'
	begin object name="NewDecalComponent" class=Engine.DecalComponent
		bStaticDecal=true
		DecalTransform=EDecalTransform.DecalTransform_OwnerAbsolute
		ReplacementPrimitive=none
	end object
	Decal=NewDecalComponent
	Components[0]=NewDecalComponent
	Components[1]=none
	Components[2]=none
	CollisionType=ECollisionType.COLLIDE_CustomDefault
	TickGroup=ETickingGroup.TG_DuringAsyncWork
	bStatic=true
	bMovable=false
}