class HaloTrap_Ground_Slow extends HaloTrap_Base
	placeable;

var protected export editinline StaticMeshComponent StaticMeshComponent;
var protected float GroundSpeedPercentage;

function bool SlowTarget(HaloPawn Pawn)
{
	// End:0x71
	if((Pawn != none) && CanSlow(Pawn))
	{
		Pawn.GroundSpeed = Pawn.default.GroundSpeed * GroundSpeedPercentage;
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool CanSlow(HaloPawn Pawn)
{
	return (IsValidTarget(Pawn)) && Pawn.GroundSpeed >= Pawn.default.GroundSpeed;
	//return ReturnValue;	
}

function Entered(Actor Actor)
{
	// End:0x2C
	if(IsInState('Execute'))
	{
		SlowTarget(HaloPawn(Actor));
	}
	super.Entered(Actor);
	//return;	
}

function Exited(Actor Actor)
{
	local HaloPawn Pawn;

	Pawn = HaloPawn(Actor);
	// End:0x79
	if(TargetPawns.Find(Pawn) != -1)
	{
		Pawn.GroundSpeed = Pawn.default.GroundSpeed;
	}
	super.Exited(Actor);
	//return;	
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
		super.EnterState();
		//return;		
	}

	function ExitState()
	{
		super.ExitState();
		//return;		
	}

	function SlowInitialTargets()
	{
		local HaloPawn Pawn;

		// End:0x2C
		foreach TouchingActors(Class'MegaHaloGame.HaloPawn', Pawn)
		{
			SlowTarget(Pawn);			
		}		
		//return;		
	}
Begin:

	Sleep(ExecuteDelay);
	SlowInitialTargets();
	goto 'IsActive';
IsActive:


	// End:0x45
	if(TargetPawns.Length > 0)
	{
		Sleep(0.7500000);
		goto 'IsActive';		
	}
	else
	{
		goto 'ExitState';
	}
	J0x4F:

	EnterState();
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
	// Reference: StaticMeshComponent'MegaHaloGame.Default__HaloTrap_Ground_Slow.StaticMeshComponent0'
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
	GroundSpeedPercentage=0.5000000
	TrapType=TRAP_Ground_Slow
	BaseMeshComponent=StaticMeshComponent0
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloTrap_Ground_Slow.CollisionCylinder'
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