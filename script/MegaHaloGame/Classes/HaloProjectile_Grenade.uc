class HaloProjectile_Grenade extends HaloProjectile;

var float TimePassedSinceThrown;
var float ExplodingNowDelay;
var float ExplodeFromTouchDelay;
var float LateTouchDelay;
var float ExplodeFromLateTouchDelay;
var float ExplodeFromStickyTouchDelay;
var float WallBounce;
var float PawnBounce;
var float WallFriction;
var float PawnFriction;
var bool bSticksToPawns;
var bool bBroadcastThreat;
var export editinline SkeletalMeshComponent StickyTarget;
var int StickyBoneIndex;
var Vector StickyLocOffset;
var float MaxGrenadeFeedbackDistance;
var float GrenadeFeedbackMultiplier;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(LateTouchDelay, false, 'LateTouchTimerDone');
	RandSpin(100000.0000000);
	//return;	
}

function Init(Vector Direction)
{
	SetRotation(Rotator(Direction));
	Velocity = Speed * Direction;
	HaloGameDefault(WorldInfo.Game).ActiveGrenades.AddItem(self);
	//return;	
}

simulated function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	UpdateVelocityFromGravity(DeltaTime);
	UpdateStickyAttachment();
	BroadcastThreat();
	// End:0x68
	if(IsTimerActive('ExplodeNow'))
	{
		TimePassedSinceThrown += DeltaTime;		
	}
	else
	{
		TimePassedSinceThrown = -1.0000000;
	}
	//return;	
}

simulated function LateTouchTimerDone()
{
	ExplodeFromTouchDelay = ExplodeFromLateTouchDelay;
	//return;	
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
	HaloGameDefault(WorldInfo.Game).ActiveGrenades.RemoveItem(self);
	PlayForceFeedback();
	super(UTProjectile).Explode(HitLocation, HitNormal);
	//return;	
}

simulated function ExplodeNow()
{
	local Rotator fxRot;

	fxRot.Yaw = -NormalizeRotAxis(Rotation.Yaw);
	Explode(Location, Vector(fxRot));
	//return;	
}

function PlayForceFeedback()
{
	local PlayerController PC;
	local HaloPlayerPawnController HPPC;
	local Pawn P;
	local float Dist, magnitude, Orientation, RightOrientation, LeftMagnitude, RightMagnitude;

	// End:0x212
	foreach WorldInfo.LocalPlayerControllers(Class'Engine.PlayerController', PC)
	{
		HPPC = HaloPlayerPawnController(PC);
		// End:0x211
		if(HPPC != none)
		{
			P = HPPC.Pawn;
			Dist = VSize(P.Location - Location);
			// End:0x211
			if(Dist <= MaxGrenadeFeedbackDistance)
			{
				magnitude = ((MaxGrenadeFeedbackDistance - Dist) / MaxGrenadeFeedbackDistance) * GrenadeFeedbackMultiplier;
				Orientation = (Vector(P.GetViewRotation()) Cross vect(0.0000000, 0.0000000, 1.0000000)) Dot Normal(P.Location - Location);
				RightOrientation = (Orientation + 1.0000000) / 2.0000000;
				LeftMagnitude = FMin(magnitude * (1.0000000 - RightOrientation), 100.0000000);
				RightMagnitude = FMin(magnitude * RightOrientation, 100.0000000);
				HPPC.PlayGrenadeForceFeedback(LeftMagnitude, RightMagnitude);
			}
		}		
	}	
	//return;	
}

simulated function HandleCollision(Actor Other, Vector HitNormal)
{
	local float VdotN;
	local Pawn HitPawn;
	local name Material;

	VdotN = Velocity Dot HitNormal;
	// End:0x1E2
	if(VdotN < 0.0000000)
	{
		HitPawn = Pawn(Other);
		// End:0xDF
		if(HitPawn != none)
		{
			// End:0xA5
			if(bSticksToPawns)
			{
				StickToPawn(HitPawn);
				NotifyGrenadeStuck(HitPawn);
				ExplodeFromTouchDelay = ExplodeFromStickyTouchDelay;				
			}
			else
			{
				BounceOffActor(Other, HitNormal, VdotN, PawnBounce, PawnFriction);
			}			
		}
		else
		{
			BounceOffActor(Other, HitNormal, VdotN, WallBounce, WallFriction);
		}
		// End:0x174
		if(!IsTimerActive('ExplodeNow'))
		{
			TimePassedSinceThrown = 0.0000000;
			ExplodingNowDelay = ExplodeFromTouchDelay;
			SetTimer(ExplodeFromTouchDelay, false, 'ExplodeNow');
			bBroadcastThreat = true;
		}
		// End:0x1D6
		if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
		{
			// End:0x1D6
			if(VdotN < -400.0000000)
			{
				Material = 'Concrete';
				PlayBounceSound(Material);
			}
		}
		bBlockedByInstigator = true;
	}
	//return;	
}

simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	HandleCollision(Wall, HitNormal);
	//return;	
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	HandleCollision(Other, HitNormal);
	//return;	
}

simulated function BounceOffActor(Actor Other, Vector HitNormal, float VdotN, float Bounce, float Fric)
{
	local Vector VProj, VPerp;

	VProj = VdotN * HitNormal;
	VPerp = Velocity - VProj;
	VProj *= -Bounce;
	// End:0x90
	if(VSizeSq(VPerp) < (Fric * Fric))
	{
		VPerp = vect(0.0000000, 0.0000000, 0.0000000);		
	}
	else
	{
		VPerp -= (Fric * Normal(VPerp));
	}
	Velocity = VProj + VPerp;
	Speed = VSize(Velocity);
	//return;	
}

simulated function PhysicsVolumeChange(PhysicsVolume NewVolume)
{
	// End:0x28
	if(WaterVolume(NewVolume) != none)
	{
		Velocity *= 0.2500000;
	}
	super(Actor).PhysicsVolumeChange(NewVolume);
	//return;	
}

simulated function StickToPawn(Pawn HitPawn)
{
	local array<ImpactInfo> ImpactList;
	local Vector DirTrace, StartTrace, EndTrace;
	local Matrix BoneMtx;

	// End:0x1FD
	if(HitPawn.Mesh != none)
	{
		// End:0x51
		if(VSizeSq(Velocity) > 0.1000000)
		{
			DirTrace = Normal(Velocity);			
		}
		else
		{
			DirTrace = vect(0.0000000, 0.0000000, -1.0000000);
		}
		StartTrace = Location - (100.0000000 * DirTrace);
		EndTrace = Location + (100.0000000 * DirTrace);
		// End:0x1FD
		if(TraceAllPhysicsAssetInteractions(HitPawn.Mesh, EndTrace, StartTrace, ImpactList))
		{
			// End:0x1FD
			if(ImpactList.Length > 0)
			{
				StickyTarget = HitPawn.Mesh;
				StickyBoneIndex = StickyTarget.MatchRefBone(ImpactList[0].HitInfo.BoneName);
				BoneMtx = StickyTarget.GetBoneMatrix(StickyBoneIndex);
				StickyLocOffset = InverseTransformVector(BoneMtx, ImpactList[0].HitLocation);
				SetPhysics(0);
			}
		}
	}
	//return;	
}

simulated function UpdateStickyAttachment()
{
	local Matrix BoneMtx;

	// End:0x60
	if(StickyTarget != none)
	{
		BoneMtx = StickyTarget.GetBoneMatrix(StickyBoneIndex);
		SetLocation(TransformVector(BoneMtx, StickyLocOffset));
	}
	//return;	
}

simulated function BroadcastThreat()
{
	local HaloAIPawn enemyPawn;
	local CCSController enemyPawnController;

	// End:0xDC
	if(bBroadcastThreat)
	{
		// End:0xDB
		foreach WorldInfo.AllPawns(Class'MegaHaloGame.HaloAIPawn', enemyPawn, Location, DamageRadius)
		{
			// End:0xDA
			if(enemyPawn != none)
			{
				enemyPawnController = CCSController(enemyPawn.Controller);
				// End:0xDA
				if(enemyPawnController != none)
				{
					enemyPawnController.NotifyThreatened(self, self.Velocity, 1);
				}
			}			
		}		
	}
	//return;	
}

simulated function NotifyGrenadeStuck(Pawn Pawn)
{
	local HaloAIPawn enemyPawn;
	local CCSController enemyPawnController;

	// End:0x9A
	if(Pawn != none)
	{
		enemyPawn = HaloAIPawn(Pawn);
		// End:0x9A
		if(enemyPawn != none)
		{
			enemyPawnController = CCSController(enemyPawn.Controller);
			// End:0x9A
			if(enemyPawnController != none)
			{
				enemyPawnController.NotifyGrenadeStuck(self);
			}
		}
	}
	//return;	
}

simulated function UpdateVelocityFromGravity(float DeltaTime)
{
	// End:0x47
	if(int(Physics) == int(6))
	{
		Velocity.Z += ((GetGravityZ()) * DeltaTime);
	}
	//return;	
}

defaultproperties
{
	ExplodeFromTouchDelay=1.0000000
	LateTouchDelay=4.0000000
	ExplodeFromLateTouchDelay=0.5000000
	WallBounce=0.1500000
	WallFriction=1200.0000000
	PawnFriction=10000.0000000
	MaxGrenadeFeedbackDistance=3500.0000000
	GrenadeFeedbackMultiplier=125.0000000
	BounceSoundEvent=AkEvent'Objects.Play_Object_Impact'
	ExplodeSoundEvent=AkEvent'Foley.Play_Explosion'
	AkExplosionType="Explosion_Concussive"
	AkExplosionSize="Explosion_Small"
	akWeaponType="UNSC_Grenade"
	AkObjectType="UNSC_Grenade"
	ProjFlightTemplate=ParticleSystem'WP_UNSC_GRENADE.Effects.WP_UNSC_GRENADE_TRAIL'
	ProjExplosionTemplate=ParticleSystem'WP_UNSC_GRENADE.Effects.WP_UNSC_GRENADE_XPLD'
	ExplosionDecal=MaterialInstanceTimeVarying'WP_RocketLauncher.Decals.MITV_WP_RocketLauncher_Impact_Decal01'
	DecalWidth=128.0000000
	DecalHeight=128.0000000
	ExplosionLightClass=Class'UTGame.UTRocketExplosionLight'
	CheckRadius=36.0000000
	CustomGravityScaling=5.0000000
	Speed=4000.0000000
	MaxSpeed=4000.0000000
	bSwitchToZeroCollision=false
	Damage=300.0000000
	DamageRadius=800.0000000
	MomentumTransfer=50000.0000000
	MyDamageType=Class'MegaHaloGame.HaloDamageType_Grenade'
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloProjectile_Grenade.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloProjectile.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=15.0000000
		CollisionRadius=8.0000000
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	bNetTemporary=false
	bCollideComplex=false
	bBounce=true
	LifeSpan=0.0000000
	CollisionComponent=CollisionCylinder
}