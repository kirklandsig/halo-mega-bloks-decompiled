class HaloProjectile_NeedlerNeedle_Trap extends HaloProjectile_NeedlerNeedle;

simulated function bool StickToActor(Actor HitActor)
{
	HitActor.TakeDamage(0, InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType,, self);
	return super.StickToActor(HitActor);
	//return ReturnValue;	
}

defaultproperties
{
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloProjectile_NeedlerNeedle_Trap.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloProjectile_NeedlerNeedle.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	CollisionComponent=CollisionCylinder
}