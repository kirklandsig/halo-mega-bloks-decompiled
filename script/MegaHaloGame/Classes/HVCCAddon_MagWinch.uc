class HVCCAddon_MagWinch extends HVCCAddon
	notplaceable;

var export editinline SkeletalMeshComponent BaseSkeletalMeshComponent;
var HaloMagWinchProjectile MagWinchProjectile;
var HaloWinchGateActor CurrentGateTarget;
var float MaxWinchRange;
var float MaxWinchRotDif;
var float ConeCheckTimer;
var const float MaxConeCheckTime;
var export editinline ParticleSystemComponent BeamEmitter;
var export editinline ParticleSystemComponent WaveBeamEmitter;
var name BeamSocket;
var name EndPointParamName;
var SkeletalMesh LockMesh;
var HaloWinchGateLockAsset LockAsset;
var float LockDropTimer;
var float LockPullTimer;
var const localized string MagWinchUseMessage;
var const localized string MagWinchPullMessage;
var name CurrentMagWinchMessage;

function OnAttach()
{
	ConeCheckTimer = MaxConeCheckTime;
	//return;	
}

function OnDetach()
{
	//return;	
}

function Hide()
{
	BaseSkeletalMeshComponent.SetHidden(true);
	// End:0x4F
	if(MagWinchProjectile != none)
	{
		MagWinchProjectile.SetHidden(true);
	}
	//return;	
}

function show()
{
	BaseSkeletalMeshComponent.SetHidden(false);
	// End:0x4F
	if(MagWinchProjectile != none)
	{
		MagWinchProjectile.SetHidden(false);
	}
	//return;	
}

function Tick(float DeltaTime)
{
	local Vector ToTarget, HitLocation, HitNormal, vehicleFoward;
	local Actor TraceActor;
	local float RotDotVel;

	super.Tick(DeltaTime);
	// End:0x4CB
	if(ParentVehicle.bDriving)
	{
		ConeCheckTimer -= DeltaTime;
		// End:0xCE
		if((ConeCheckTimer <= 0.0000000) && MagWinchProjectile == none)
		{
			CurrentGateTarget = FindWinchGateTarget();
			// End:0xA8
			if(CurrentGateTarget != none)
			{
				CurrentMagWinchMessage = name(MagWinchUseMessage);				
			}
			else
			{
				CurrentMagWinchMessage = 'None';
			}
			ConeCheckTimer = MaxConeCheckTime;
		}
		// End:0x4CB
		if(MagWinchProjectile != none)
		{
			ToTarget = CurrentGateTarget.GetWinchAttachLocation() - Location;
			// End:0x31C
			if(MagWinchProjectile.ContactMade! && (VSizeSq(ToTarget) > (MaxWinchRange * MaxWinchRange)) || RDiff(Rotator(ToTarget), Rotation) > MaxWinchRotDif)
			{
				TraceActor = Trace(HitLocation, HitNormal, CurrentGateTarget.GetWinchAttachLocation(), Location);
				// End:0x319
				if((TraceActor != none) && (((((TraceActor == CurrentGateTarget) || TraceActor == CurrentGateTarget.Lock) || TraceActor == CurrentGateTarget.LeftPost) || TraceActor == CurrentGateTarget.RightPost) || TraceActor == CurrentGateTarget.BlockingVolume) || (BlockingVolume(TraceActor) != none) && VSizeSq(CurrentGateTarget.GetWinchAttachLocation() - HitLocation) <= float(512 * 512))
				{
					CancelSpecialAbility();
				}				
			}
			else
			{
				// End:0x4CB
				if(MagWinchProjectile.ContactMade && MagWinchProjectile.FlyingBack!)
				{
					CurrentMagWinchMessage = name(MagWinchPullMessage);
					vehicleFoward = Vector(ParentVehicle.Rotation);
					RotDotVel = vehicleFoward Dot ParentVehicle.Velocity;
					// End:0x4CB
					if((ParentVehicle.Throttle < 0.0000000) && RotDotVel < 0.0000000)
					{
						LockPullTimer -= DeltaTime;
						UpdateLockController();
						MagWinchProjectile.SetLocation(CurrentGateTarget.GetWinchAttachLocation());
						// End:0x4CB
						if(LockPullTimer <= 0.0000000)
						{
							CurrentMagWinchMessage = 'None';
							MagWinchProjectile.StartFlyBack(true);
							OnProjectileReturning();
							LockPullTimer = default.LockPullTimer;
						}
					}
				}
			}
		}
	}
	// End:0x5DA
	if(MagWinchProjectile != none)
	{
		// End:0x55A
		if(BeamEmitter != none)
		{
			BeamEmitter.SetVectorParameter(EndPointParamName, MagWinchProjectile.Location + (MagWinchProjectile.Velocity * DeltaTime));
		}
		// End:0x5DA
		if(WaveBeamEmitter != none)
		{
			WaveBeamEmitter.SetVectorParameter(EndPointParamName, MagWinchProjectile.Location + (MagWinchProjectile.Velocity * DeltaTime));
		}
	}
	// End:0x651
	if((LockAsset != none) && LockAsset.Base != none)
	{
		LockDropTimer -= DeltaTime;
		// End:0x651
		if(LockDropTimer <= float(0))
		{
			DropLock();
			LockDropTimer = default.LockDropTimer;
		}
	}
	//return;	
}

function AttachLock()
{
	// End:0x108
	if((LockMesh != none) && MagWinchProjectile != none)
	{
		LockAsset = Spawn(Class'MegaHaloGame.HaloWinchGateLockAsset', self,, MagWinchProjectile.Location, MagWinchProjectile.Rotation,, false);
		LockAsset.SkeletalMeshComponent.bUseHaloDestructibleActorPhysics = 1;
		LockAsset.SetMeshAndPhysAsset(LockMesh, PhysicsAsset'Winch_Gate.gate_lock_Physics');
		LockAsset.SetBase(MagWinchProjectile);
	}
	//return;	
}

function DropLock()
{
	local Vector MoveDir;

	MoveDir = Normal(Location - LockAsset.Location);
	LockAsset.SetBase(none);
	LockAsset.SkeletalMeshComponent.SetRBRotation(LockAsset.Rotation);
	LockAsset.SkeletalMeshComponent.SetRBPosition(LockAsset.Location);
	LockAsset.SkeletalMeshComponent.WakeRigidBody();
	LockAsset.SkeletalMeshComponent.AddImpulse(MoveDir * 12000.0000000);
	LockAsset.GotoState('Dropping');
	//return;	
}

function DestroyLock()
{
	// End:0x32
	if(LockAsset != none)
	{
		LockAsset.Destroy();
		LockAsset = none;
	}
	//return;	
}

function UpdateLockController()
{
	local Vector toVehicle, pullVector;
	local float pullDownRatio, pullDistance;

	// End:0x117
	if(CurrentGateTarget != none)
	{
		toVehicle = Location - CurrentGateTarget.GetWinchAttachLocation();
		toVehicle = Normal(toVehicle);
		pullDownRatio = FClamp(1.0000000 - (LockPullTimer / default.LockPullTimer), 0.0000000, 1.0000000);
		pullDistance = CurrentGateTarget.MaxLockPullDistance * pullDownRatio;
		pullVector = toVehicle * pullDistance;
		CurrentGateTarget.SkelControl_LockController.BoneTranslation = pullVector;
	}
	//return;	
}

function UseSpecialAbility()
{
	// End:0x150
	if((CurrentGateTarget != none) && MagWinchProjectile == none)
	{
		MagWinchProjectile = Spawn(Class'MegaHaloGame.HaloMagWinchProjectile', self,, Location, Rotation,, false);
		MagWinchProjectile.TargetPosition = CurrentGateTarget.GetWinchAttachLocation();
		MagWinchProjectile.ParentWinch = self;
		MagWinchProjectile.TargetGate = CurrentGateTarget;
		// End:0x150
		if(WaveBeamEmitter != none)
		{
			WaveBeamEmitter.SetVectorParameter(EndPointParamName, MagWinchProjectile.Location);
			WaveBeamEmitter.SetActive(true);
		}
	}
	//return;	
}

function CancelSpecialAbility()
{
	// End:0xB4
	if(MagWinchProjectile != none)
	{
		// End:0x40
		if((LockAsset != none) && LockDropTimer <= 0.0000000)
		{
			DropLock();			
		}
		else
		{
			LockDropTimer = default.LockDropTimer;
			LockPullTimer = default.LockPullTimer;
			// End:0x94
			if(CurrentGateTarget != none)
			{
				CurrentGateTarget.ResetLockController();
			}
		}
		MagWinchProjectile.StartFlyBack(false);
	}
	//return;	
}

function OnProjectileReturning()
{
	WaveBeamEmitter.SetActive(false);
	// End:0x97
	if(BeamEmitter != none)
	{
		BeamEmitter.SetVectorParameter(EndPointParamName, MagWinchProjectile.Location);
		BeamEmitter.SetActive(true);
	}
	//return;	
}

function HaloWinchGateActor FindWinchGateTarget()
{
	local HaloWinchGateActor potentialTarget, BestTarget;
	local Vector ToTarget, HitLocation, HitNormal;
	local float bestRange, testRange;
	local Actor TraceActor;

	BestTarget = none;
	bestRange = MaxWinchRange * MaxWinchRange;
	// End:0x2BE
	foreach ParentVehicle.OverlappingActors(Class'MegaHaloGame.HaloWinchGateActor', potentialTarget, MaxWinchRange, ParentVehicle.Location, true)
	{
		ToTarget = potentialTarget.GetWinchAttachLocation() - Location;
		testRange = VSizeSq(ToTarget);
		// End:0x2BD
		if(testRange < bestRange)
		{
			// End:0x2BD
			if(RDiff(Rotator(ToTarget), Rotation) < MaxWinchRotDif)
			{
				TraceActor = Trace(HitLocation, HitNormal, potentialTarget.GetWinchAttachLocation(), Location);
				// End:0x2BD
				if((TraceActor != none) && (((((TraceActor == potentialTarget) || TraceActor == potentialTarget.Lock) || TraceActor == potentialTarget.LeftPost) || TraceActor == potentialTarget.RightPost) || TraceActor == CurrentGateTarget.BlockingVolume) || (BlockingVolume(TraceActor) != none) && VSizeSq(potentialTarget.GetWinchAttachLocation() - HitLocation) <= float(512 * 512))
				{
					BestTarget = potentialTarget;
					bestRange = testRange;
				}
			}
		}		
	}	
	return BestTarget;
	//return ReturnValue;	
}

function DestroyProjectile()
{
	// End:0x30
	if(BeamEmitter != none)
	{
		BeamEmitter.SetActive(false);
	}
	// End:0x60
	if(WaveBeamEmitter != none)
	{
		WaveBeamEmitter.SetActive(false);
	}
	// End:0xC9
	if(((LockAsset != none) && LockAsset.GetStateName() != 'Dropping') && LockAsset.GetStateName() != 'Dying')
	{
		DropLock();
	}
	// End:0xFB
	if(MagWinchProjectile != none)
	{
		MagWinchProjectile.Destroy();
		MagWinchProjectile = none;
	}
	//return;	
}

event Destroyed()
{
	// End:0x19
	if(MagWinchProjectile != none)
	{
		DestroyProjectile();
	}
	DestroyLock();
	super(Actor).Destroyed();
	//return;	
}

defaultproperties
{
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HVCCAddon_MagWinch.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0" class=Engine.SkeletalMeshComponent
		SkeletalMesh=SkeletalMesh'Winch_Addon.Winch_Addon'
		ReplacementPrimitive=none
		RBChannel=ERBCollisionChannel.RBCC_Untitled3
		ScriptRigidBodyCollisionThreshold=0.0010000
	end object
	BaseSkeletalMeshComponent=SkeletalMeshComponent0
	MaxWinchRange=4000.0000000
	MaxWinchRotDif=27.5000000
	MaxConeCheckTime=0.7500000
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HVCCAddon_MagWinch.ParticleSystemComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent0'
	begin object name="ParticleSystemComponent0" class=Engine.ParticleSystemComponent
		Template=ParticleSystem'V_UNSC_Warthog_FX.Effects.FX_Winch_BeamRetract'
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=5000.0000000
		CachedMaxDrawDistance=5000.0000000
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	BeamEmitter=ParticleSystemComponent0
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HVCCAddon_MagWinch.ParticleSystemComponent1'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent1'
	begin object name="ParticleSystemComponent1" class=Engine.ParticleSystemComponent
		Template=ParticleSystem'V_UNSC_Warthog_FX.Effects.FX_Winch_BeamSend'
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=5000.0000000
		CachedMaxDrawDistance=5000.0000000
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	WaveBeamEmitter=ParticleSystemComponent1
	EndPointParamName="WinchBeamEnd"
	LockDropTimer=0.4000000
	LockPullTimer=0.7500000
	MagWinchUseMessage="Hold [MainHUD.InlineInputIcons.inputIcon_lb] to activate the warthog winch"
	MagWinchPullMessage="Hold [MainHUD.InlineInputIcons.inputIcon_b] to tear down the gate."
	HVCParentBoneName="Addon_front"
	UnlockStringID="WinchUpgradeReceived"
	Components[0]=SkeletalMeshComponent0
	Components[1]=ParticleSystemComponent1
	Components[2]=ParticleSystemComponent0
	CollisionComponent=SkeletalMeshComponent0
}