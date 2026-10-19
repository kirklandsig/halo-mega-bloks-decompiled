class HaloTrap_Wall_Hammer extends HaloTrap_Base
	placeable;

var protected export editinline SkeletalMeshComponent SkeletalMeshComponent;
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
Begin:

	Sleep(ExecuteDelay);
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
Begin:

	EnterState();
	Sleep(CooldownTime);
	Reactivate();
	stop;				
}

defaultproperties
{
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloTrap_Wall_Hammer.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0" class=Engine.SkeletalMeshComponent
		ReplacementPrimitive=none
		CollideActors=true
		BlockZeroExtent=true
		BlockNonZeroExtent=true
	end object
	SkeletalMeshComponent=SkeletalMeshComponent0
	TrapType=TRAP_Wall_Hammer
	BaseMeshComponent=SkeletalMeshComponent0
	Components[0]=SkeletalMeshComponent0
	CollisionType=COLLIDE_TouchAll
	bCollideActors=true
	CollisionComponent=SkeletalMeshComponent0
}