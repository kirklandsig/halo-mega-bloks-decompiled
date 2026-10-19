class DecalActorBase extends Actor
	abstract
	native
	notplaceable
	implements(EditorLinkSelectionInterface);

var const editconst export editinline DecalComponent Decal;

defaultproperties
{
	// Reference: DecalComponent'Engine.Default__DecalActorBase.NewDecalComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NewDecalComponent'
	begin object name="NewDecalComponent" class=Engine.DecalComponent
		bStaticDecal=true
		DecalTransform=DecalTransform_OwnerAbsolute
		ReplacementPrimitive=none
	end object
	Decal=NewDecalComponent
	Components[0]=NewDecalComponent
	Components[1]=none
	Components[2]=none
	CollisionType=COLLIDE_CustomDefault
	TickGroup=TG_DuringAsyncWork
	bStatic=true
	bMovable=false
}