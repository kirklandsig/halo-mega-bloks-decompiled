class HaloProjectile_NeedlerNeedle extends HaloProjectile;

var export editinline SkeletalMeshComponent StickyTarget;
var export editinline HaloNeedleTargetComponent StickyGroup;
var name StickyBoneName;
var Vector StickyLocOffset;
var Rotator StickyRotOffset;
var ParticleSystem StickyFxTemplate;
var float ExplosionTimer;
var float WanderRandomness;
var float WanderRandomnessForAI;
var float WanderTargetDistance;
var float WanderTargetDistanceForAI;
var float WanderDurationScale;
var float WanderDurationScaleForAI;
var Vector WanderTarget;
var float WanderDuration;
var float WanderTimer;
var float StayOnBaseLineWeight;
var float BaseDirWeight;
var Vector BaseLineStart;
var Vector BaseLineDir;
var float SeekTargetMaxSpeed;
var float SeekTargetMaxSpeedForAI;
var Vector SeekTargetLocation;
var Vector SeekTargetPlaneNormal;

simulated function InitForAI(Actor weaponOwner)
{
	super.InitForAI(weaponOwner);
	WanderRandomness = default.WanderRandomnessForAI;
	WanderTargetDistance = default.WanderTargetDistanceForAI;
	WanderDurationScale = default.WanderDurationScaleForAI;
	SeekTargetMaxSpeed = default.SeekTargetMaxSpeedForAI;
	//return;	
}

function Init(Vector Direction)
{
	local Rotator baseRot, offsetRot;

	super.Init(Direction);
	// End:0x1C4
	if(SeekTarget != none)
	{
		baseRot = Rotator(Direction);
		offsetRot.Yaw = 0;
		offsetRot.Pitch = Rand((32768 * 30) / 180);
		offsetRot.Roll = 0;
		Direction = Vector(offsetRot);
		offsetRot.Pitch = 0;
		offsetRot.Roll = Rand(32768) - 16384;
		Direction = Direction >> offsetRot;
		Direction = Direction >> baseRot;
		SetRotation(Rotator(Direction));
		Velocity = Direction * Speed;
		SeekTargetLocation = SeekTarget.Location;
		SeekTargetPlaneNormal = Normal(SeekTarget.Location - Location);
	}
	WanderTarget = vect(1.0000000, 0.0000000, 0.0000000);
	// End:0x235
	if(SeekTarget != none)
	{
		WanderDuration = (WanderDurationScale * VSize(SeekTarget.Location - Location)) / Speed;
	}
	WanderTimer = 0.0000000;
	BaseLineStart = Location;
	BaseLineDir = Direction;
	//return;	
}

simulated function BeginReplay(Pawn NewInstigator, Vector NewLocation)
{
	ProjFlightTemplate = default.ProjFlightTemplate;
	super.BeginReplay(NewInstigator, NewLocation);
	//return;	
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	// End:0x5F
	if(!StickToActor(Other))
	{
		// End:0x3A
		if(Other == SeekTarget)
		{
			SeekTarget = none;
		}
		super.ProcessTouch(Other, HitLocation, HitNormal);
	}
	//return;	
}

simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	// End:0x3D
	if(!StickToActor(Wall))
	{
		super(Projectile).HitWall(HitNormal, Wall, WallComp);
	}
	//return;	
}

function ClearExplodeNowTimer()
{
	ClearTimer('ExplodeNow');
	//return;	
}

simulated function bool StickToActor(Actor HitActor)
{
	local editinline HaloTargetableComponent Target;
	local int hitTeamNum;
	local editinline HaloNeedleTargetComponent hitGroup;
	local editinline SkeletalMeshComponent hitMesh;
	local array<ImpactInfo> ImpactList;
	local Vector DirTrace, StartTrace, EndTrace;

	Target = HaloTargetableComponent(HitActor.GetComponentOfType(Class'MegaHaloGame.HaloTargetableComponent'));
	// End:0x4C
	if(Target == none)
	{
		return false;
	}
	// End:0x70
	if(Target.IsDead())
	{
		return false;
	}
	hitTeamNum = int(Target.GetTeamNum());
	// End:0xC7
	if((hitTeamNum <= 0) || hitTeamNum == int(TeamNum))
	{
		return false;
	}
	// End:0xF4
	if(VSizeSq(Velocity) > 0.0000001)
	{
		DirTrace = Normal(Velocity);		
	}
	else
	{
		DirTrace = HitActor.Location - Location;
		// End:0x154
		if(VSizeSq(DirTrace) > 0.0000001)
		{
			DirTrace = Normal(DirTrace);			
		}
		else
		{
			DirTrace = Vector(Rotation);
		}
	}
	HitActor.TakeDamage(int(Damage), InstigatorController, Location, MomentumTransfer * DirTrace, MyDamageType,, self);
	// End:0x1E8
	if(Target.IsDead())
	{
		return false;
	}
	hitGroup = Target.GetNeedleTargetComponent();
	// End:0x222
	if(hitGroup == none)
	{
		return false;
	}
	hitMesh = Target.GetSkeletalMesh();
	// End:0x25C
	if(hitMesh == none)
	{
		return false;
	}
	StartTrace = Location - (100.0000000 * DirTrace);
	EndTrace = Location + (300.0000000 * DirTrace);
	// End:0x31E
	if(!TraceAllPhysicsAssetInteractions(hitMesh, EndTrace, StartTrace, ImpactList))
	{
		TraceAllPhysicsAssetInteractions(hitMesh, HitActor.Location, StartTrace, ImpactList);
	}
	// End:0x3E2
	if(ImpactList.Length > 0)
	{
		StickyBoneName = ImpactList[0].HitInfo.BoneName;
		StickyTarget = hitMesh;
		StickyTarget.TransformToBoneSpace(StickyBoneName, ImpactList[0].HitLocation, Rotator(DirTrace), StickyLocOffset, StickyRotOffset);		
	}
	else
	{
		StickyTarget = hitMesh;
		StickyBoneName = 'None';
		StickyLocOffset = vect(0.0000000, 0.0000000, 0.0000000);
		StickyRotOffset = Rotation - HitActor.Rotation;
	}
	Velocity = vect(0.0000000, 0.0000000, 0.0000000);
	SetPhysics(0);
	LifeSpan = 0.0000000;
	SetTimer(ExplosionTimer, false, 'ExplodeNow');
	ChangeFlightEffects(StickyFxTemplate);
	SeekTarget = none;
	StickyGroup = hitGroup;
	// End:0x4F5
	if(StickyGroup != none)
	{
		StickyGroup.AddNeedle(self);
	}
	return true;
	//return ReturnValue;	
}

simulated function UpdateStickyAttachment()
{
	local Vector NewLoc;
	local Rotator NewRot;

	// End:0x190
	if(StickyTarget != none)
	{
		// End:0x8D
		if(StickyBoneName != 'None')
		{
			StickyTarget.TransformFromBoneSpace(StickyBoneName, StickyLocOffset, StickyRotOffset, NewLoc, NewRot);
			SetLocation(NewLoc);
			SetRotation(NewRot);			
		}
		else
		{
			// End:0x190
			if(StickyTarget.Owner != none)
			{
				NewLoc = StickyTarget.Owner.Location + (StickyLocOffset >> StickyTarget.Owner.Rotation);
				NewRot = StickyTarget.Owner.Rotation + StickyRotOffset;
				SetLocation(NewLoc);
				SetRotation(NewRot);
			}
		}
	}
	//return;	
}

function ChangeFlightEffects(ParticleSystem FX)
{
	// End:0x39
	if(ProjEffects != none)
	{
		ProjEffects.DeactivateSystem();
		ProjEffects = none;
	}
	ProjFlightTemplate = FX;
	SpawnFlightEffects();
	//return;	
}

function FindTargetActor()
{
	super.FindTargetActor();
	// End:0x4D
	if(SeekTarget != none)
	{
		SeekTargetOffset = SeekTargetOffset << SeekTarget.Rotation;
	}
	//return;	
}

function TickTargetSeeking(float DeltaTime)
{
	local Vector wanderDir, Offset, toTarg;
	local float Move;
	local Vector closest, toClosest;
	local float T;
	local Vector offsetTargLoc;

	// End:0x11
	if(StickyTarget != none)
	{
		return;
	}
	WanderTarget.X += RandRange(-WanderRandomness, WanderRandomness);
	WanderTarget.Y += RandRange(-WanderRandomness, WanderRandomness);
	WanderTarget.Z += RandRange(-WanderRandomness, WanderRandomness);
	WanderTarget = Normal(WanderTarget);
	wanderDir = WanderTarget;
	wanderDir.X += WanderTargetDistance;
	wanderDir = wanderDir >> Rotation;
	wanderDir = Normal(wanderDir);
	// End:0x191
	if((SeekTargetsComponent != none) && SeekTargetsComponent.IsDead())
	{
		SeekTarget = none;
		SeekTargetsComponent = none;
	}
	// End:0x43F
	if(SeekTarget != none)
	{
		offsetTargLoc = SeekTarget.Location + (SeekTargetOffset >> SeekTarget.Rotation);
		// End:0x21D
		if(SeekTargetMaxSpeed <= 0.0000000)
		{
			SeekTargetLocation = offsetTargLoc;			
		}
		else
		{
			Offset = offsetTargLoc - SeekTargetLocation;
			Move = SeekTargetMaxSpeed * DeltaTime;
			// End:0x293
			if(VSizeSq(Offset) <= (Move * Move))
			{
				SeekTargetLocation = offsetTargLoc;				
			}
			else
			{
				SeekTargetLocation += (Move * Normal(Offset));
				SeekTargetLocation -= offsetTargLoc;
				SeekTargetLocation -= ((SeekTargetPlaneNormal Dot SeekTargetLocation) * SeekTargetPlaneNormal);
				SeekTargetLocation += offsetTargLoc;
			}
		}
		toTarg = SeekTargetLocation - Location;
		// End:0x390
		if(VSizeSq(toTarg) < (SeekTarget.GetCollisionRadius() * SeekTarget.GetCollisionRadius()))
		{
			SeekTarget = none;
			SetRotation(Rotator(wanderDir));			
		}
		else
		{
			WanderTimer += DeltaTime;
			T = FMin(1.0000000, WanderTimer / WanderDuration);
			SetRotation(RLerp(Rotator(wanderDir), Rotator(toTarg), T, true));
		}
		BaseLineStart = Location;
		BaseLineDir = Vector(Rotation);
		Velocity = BaseLineDir * Speed;		
	}
	else
	{
		closest = ((BaseLineDir Dot (Location - BaseLineStart)) * BaseLineDir) + BaseLineStart;
		toClosest = closest - Location;
		SetRotation(Rotator((wanderDir + (StayOnBaseLineWeight * toClosest)) + (BaseDirWeight * BaseLineDir)));
		Velocity = Vector(Rotation) * Speed;
	}
	//return;	
}

simulated state Inactive
{
	simulated event BeginState(name NextStateName)
	{
		// End:0x3A
		if(StickyGroup != none)
		{
			StickyGroup.RemoveNeedle(self);
			StickyGroup = none;
		}
		StickyTarget = none;
		super.BeginState(NextStateName);
		//return;		
	}
	stop;	
}

defaultproperties
{
	StickyFxTemplate=ParticleSystem'WP_COV_NEEDLER.Effects.WP_COV_NEEDLER_SPLINT'
	ExplosionTimer=3.0000000
	WanderRandomness=0.2000000
	WanderRandomnessForAI=0.2000000
	WanderTargetDistance=10.0000000
	WanderTargetDistanceForAI=10.0000000
	WanderDurationScale=2.0000000
	WanderDurationScaleForAI=2.0000000
	StayOnBaseLineWeight=0.0000500
	BaseDirWeight=0.1000000
	SeekTargetMaxSpeedForAI=250.0000000
	TargetSearchMode=ETargetSearchMode.TargetSearchMode_Cone
	TargetSearchModeOverrideForAI=ETargetSearchMode.TargetSearchMode_Cone
	TargetSearchRange=4000.0000000
	TargetAngularSearchRange=50.0000000
	SeekingTurnRate=20000.0000000
	ExplodeSoundEvent=AkEvent'Weapons.Play_Projectile_Detonate'
	akWeaponType="COV_Needler"
	ProjFlightTemplate=ParticleSystem'WP_COV_NEEDLER.Effects.WP_COV_NEEDLER_PRT'
	ProjExplosionTemplate=ParticleSystem'WP_COV_NEEDLER.Effects.WP_COV_NEEDLER_Hit'
	MaxEffectDistance=5000.0000000
	ProjectileLightClass=Class'UTGame.UTShockBallLight'
	CheckRadius=40.0000000
	Speed=3000.0000000
	MaxSpeed=3000.0000000
	Damage=3.0000000
	MomentumTransfer=5000.0000000
	MyDamageType=Class'MegaHaloGame.HaloDamageType_NeedlerNeedle'
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloProjectile_NeedlerNeedle.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloProjectile.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	AISpeedOverride=2000.0000000
	Components[0]=CollisionCylinder
	bCollideComplex=false
	LifeSpan=3.0000000
	CollisionComponent=CollisionCylinder
}