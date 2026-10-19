class HaloTrap_Ground_Mine extends HaloTrap_Base
	placeable;

var protected export editinline StaticMeshComponent StaticMeshComponent;
var protected int DamageAmount;

function Entered(Actor Actor)
{
	super.Entered(Actor);
	//return;	
}

function Exited(Actor Actor)
{
	super.Exited(Actor);
	//return;	
}

function bool CanDamage(HaloPawn Pawn)
{
	return (((int(GetTeamNum()) != int(Pawn.GetTeamNum())) && Pawn.bCanBeDamaged) && Pawn.IsAliveAndWell()) && !Pawn.bStatic;
	//return ReturnValue;	
}

function AddUpgradeXP(int xp)
{
	super.AddUpgradeXP(xp);
	//return;	
}

auto state Ready
{
	function EnterState()
	{
		super.EnterState();
		//return;		
	}

	function ExitState()
	{
		super.ExitState();
		//return;		
	}
	stop;	
}

state Activate
{
	function EnterState()
	{
		super.EnterState();
		//return;		
	}

	function ExitState()
	{
		super.ExitState();
		//return;		
	}
	stop;	
}

state Execute
{
	function EnterState()
	{
		local HaloPawn Pawn;

		// End:0x7E
		foreach TouchingActors(Class'MegaHaloGame.HaloPawn', Pawn)
		{
			// End:0x7D
			if(self.CanDamage(Pawn))
			{
				Pawn.TakeDamage(DamageAmount, none, Location, vect(0.0000000, 0.0000000, 1.0000000), none,, self);
			}			
		}		
		WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'WP_UNSC_GRENADE.Effects.WP_UNSC_GRENADE_XPLD', Location, Rotation);
		super.EnterState();
		//return;		
	}

	function ExitState()
	{
		super.ExitState();
		//return;		
	}
	stop;	
}

state Cooldown
{
	function EnterState()
	{
		super.EnterState();
		//return;		
	}

	function ExitState()
	{
		super.ExitState();
		//return;		
	}
	stop;	
}

defaultproperties
{
	// Reference: StaticMeshComponent'MegaHaloGame.Default__HaloTrap_Ground_Mine.StaticMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'StaticMeshComponent0'
	begin object name="StaticMeshComponent0" class=Engine.StaticMeshComponent
		ReplacementPrimitive=none
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
	end object
	StaticMeshComponent=StaticMeshComponent0
	BaseMeshComponent=StaticMeshComponent0
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloTrap_Ground_Mine.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	begin object name="CollisionCylinder" class=Engine.CylinderComponent
		CollisionHeight=60.0000000
		CollisionRadius=300.0000000
		ReplacementPrimitive=none
		CollideActors=true
		Translation=(X=30.0000000,Y=0.0000000,Z=0.0000000)
	end object
	Components[0]=CollisionCylinder
	Components[1]=StaticMeshComponent0
	CollisionType=COLLIDE_TouchAll
	bCollideActors=true
	CollisionComponent=CollisionCylinder
}