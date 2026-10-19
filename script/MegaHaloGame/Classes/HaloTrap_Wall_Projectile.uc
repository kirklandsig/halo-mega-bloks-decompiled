class HaloTrap_Wall_Projectile extends HaloTrap_Base
	placeable;

var protected export editinline SkeletalMeshComponent SkeletalMeshComponent;
var protected name FirePointSocketNames[9];
var private Class<Projectile> ProjectileClass;
var protected int NumberOfBursts;
var protected float FireDelay;
var private float ForceTransfer;
var private int loopvar;

function Class<Projectile> GetProjectileClass()
{
	return ProjectileClass;
	//return ReturnValue;	
}

function FireBurst()
{
	local int I;
	local Vector fireLoc;
	local Rotator FireRot;
	local Projectile Proj;

	// End:0x134
	if(SkeletalMeshComponent != none)
	{
		I = 0;
		J0x1A:

		// End:0x134 [Loop If]
		if(I < 9)
		{
			// End:0x126
			if(SkeletalMeshComponent.GetSocketWorldLocationAndRotation(FirePointSocketNames[I], fireLoc, FireRot))
			{
				Proj = Class'Engine.WorldInfo'.static.GetWorldInfo().Spawn(GetProjectileClass(),,, fireLoc);
				Proj.Init(GetRotatorAxis(FireRot, 2));
				Proj.MomentumTransfer = ForceTransfer;
			}
			I++;
			// [Loop Continue]
			goto J0x1A;
		}
	}
	//return;	
}

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

function bool HasLOS(HaloPawn Pawn)
{
	local Vector HitLocation, HitNormal;
	local Actor CollisionActor;
	local bool bHasLOS;

	CollisionActor = Trace(HitLocation, HitNormal, Pawn.Location);
	bHasLOS = CollisionActor == Pawn;
	// End:0x87
	if(!bHasLOS)
	{
		SetTimer(LineOfSightRecheckTime, false, 'RecheckLOS');
	}
	return bHasLOS;
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
	loopvar = 0;
	J0x17:

	// End:0x52 [Loop If]
	if(loopvar < NumberOfBursts)
	{
		FireBurst();
		Sleep(FireDelay);
		loopvar++;
		// [Loop Continue]
		goto J0x17;
	}
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
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloTrap_Wall_Projectile.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0" class=Engine.SkeletalMeshComponent
		ReplacementPrimitive=none
		CollideActors=true
		BlockZeroExtent=true
		BlockNonZeroExtent=true
	end object
	SkeletalMeshComponent=SkeletalMeshComponent0
	FirePointSocketNames[0]="Shot01"
	FirePointSocketNames[1]="Shot02"
	FirePointSocketNames[2]="Shot03"
	FirePointSocketNames[3]="Shot04"
	FirePointSocketNames[4]="Shot05"
	FirePointSocketNames[5]="Shot06"
	FirePointSocketNames[6]="Shot07"
	FirePointSocketNames[7]="Shot08"
	FirePointSocketNames[8]="Shot09"
	NumberOfBursts=1
	FireDelay=0.2500000
	ForceTransfer=25000.0000000
	TrapType=TRAP_Wall_Projectile
	BaseMeshComponent=SkeletalMeshComponent0
	Components[0]=SkeletalMeshComponent0
	CollisionType=COLLIDE_TouchAll
	bCollideActors=true
	CollisionComponent=SkeletalMeshComponent0
}