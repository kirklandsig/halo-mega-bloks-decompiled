class GwNavVolume extends Volume
	abstract
	native;

simulated function bool StopsProjectile(Projectile P)
{
	return false;
	//return ReturnValue;	
}

defaultproperties
{
	// Reference: BrushComponent'GwNavEngine.Default__GwNavVolume.BrushComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'BrushComponent0'
	// Archetype: BrushComponent'Engine.Default__Volume.BrushComponent0'
	begin object name="BrushComponent0"
		ReplacementPrimitive=none
	end object
	BrushComponent=BrushComponent0
	Components[0]=BrushComponent0
	bCollideActors=false
	CollisionComponent=BrushComponent0
	SupportedEvents=none
}