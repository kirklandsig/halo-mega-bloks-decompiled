class HaloWinchGateActor extends Actor
	placeable;

var float MaxLockPullDistance;
var BlockingVolume BlockingVolume;
var export editinline SkeletalMeshComponent GateMeshComp;
var ParticleSystem GateBreakParticleSystem;
var ParticleSystem LockBreakParticleSystem;
var export editinline ParticleSystemComponent HUDDisplayEmitter;
var MaterialInterface HUDDisplayMI;
var MaterialInstanceConstant HUDDisplayMIC;
var float HUDDisplayMaxDistance;
var float SQMaxDist;
var archetype HaloDestructibleActor LeftPostArchetype;
var archetype HaloDestructibleActor RightPostArchetype;
var HaloDestructibleActor LeftPost;
var HaloDestructibleActor RightPost;
var SkeletalMesh LockMesh;
var PhysicsAsset LockPhysics;
var SkeletalMeshActorSpawnable Lock;
var name SkelControlName_AttachToLeftPostBone;
var name SkelControlName_AttachToRightPostBone;
var name SkelControlName_LockController;
var SkelControlSingleBone SkelControl_AttachToLeftBone;
var SkelControlSingleBone SkelControl_AttachToRightBone;
var SkelControlSingleBone SkelControl_LockController;
var ParticleSystem BeamTemplate;
var export editinline ParticleSystemComponent PSC_LeftBeam0;
var export editinline ParticleSystemComponent PSC_LeftBeam1;
var export editinline ParticleSystemComponent PSC_LeftBeam2;
var export editinline ParticleSystemComponent PSC_RightBeam0;
var export editinline ParticleSystemComponent PSC_RightBeam1;
var export editinline ParticleSystemComponent PSC_RightBeam2;
var bool bCreatedSparks;
var bool bSparksPlaying;
var export editinline array<export editinline ParticleSystemComponent> Sparks;

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super.PostInitAnimTree(SkelComp);
	// End:0xDB
	if(SkelComp == GateMeshComp)
	{
		SkelControl_AttachToLeftBone = SkelControlSingleBone(GateMeshComp.FindSkelControl(SkelControlName_AttachToLeftPostBone));
		SkelControl_AttachToRightBone = SkelControlSingleBone(GateMeshComp.FindSkelControl(SkelControlName_AttachToRightPostBone));
		SkelControl_LockController = SkelControlSingleBone(GateMeshComp.FindSkelControl(SkelControlName_LockController));
	}
	//return;	
}

event PostBeginPlay()
{
	local Vector ActorLocation;

	ActorLocation = GateMeshComp.GetBoneLocation('left_gate_wall_bone', 0);
	LeftPost = Spawn(LeftPostArchetype.Class,,, ActorLocation, Rotation, LeftPostArchetype, true);
	ActorLocation = GateMeshComp.GetBoneLocation('right_gate_wall_bone', 0);
	RightPost = Spawn(RightPostArchetype.Class,,, ActorLocation, Rotation, RightPostArchetype, true);
	ActorLocation = GateMeshComp.GetBoneLocation('gate_lock_root', 0);
	Lock = SpawnLock(ActorLocation);
	SetDrawScale3D(vect(1.0000000, 1.0000000, 1.0000000));
	// End:0x1DB
	if(SkelControl_AttachToLeftBone != none)
	{
		SkelControl_AttachToLeftBone.BoneTranslation = RightPost.SkeletalMeshComponent.GetBoneLocation('right_gate_pillar_bone', 0);
	}
	// End:0x247
	if(SkelControl_AttachToRightBone != none)
	{
		SkelControl_AttachToRightBone.BoneTranslation = LeftPost.SkeletalMeshComponent.GetBoneLocation('left_gate_pillar_bone', 0);
	}
	StartBeamPSC(PSC_RightBeam0, BeamTemplate, Lock.SkeletalMeshComponent, 'Elec_streamEND3', RightPost.SkeletalMeshComponent, 'Elec_streamSTART2');
	StartBeamPSC(PSC_RightBeam1, BeamTemplate, Lock.SkeletalMeshComponent, 'Elec_streamEND4', RightPost.SkeletalMeshComponent, 'Elec_streamSTART1');
	StartBeamPSC(PSC_RightBeam2, BeamTemplate, Lock.SkeletalMeshComponent, 'Elec_streamEND5', RightPost.SkeletalMeshComponent, 'Elec_streamSTART6');
	StartBeamPSC(PSC_LeftBeam0, BeamTemplate, Lock.SkeletalMeshComponent, 'Elec_streamEND2', LeftPost.SkeletalMeshComponent, 'Elec_streamSTART3');
	StartBeamPSC(PSC_LeftBeam1, BeamTemplate, Lock.SkeletalMeshComponent, 'Elec_streamEND1', LeftPost.SkeletalMeshComponent, 'Elec_streamSTART4');
	StartBeamPSC(PSC_LeftBeam2, BeamTemplate, Lock.SkeletalMeshComponent, 'Elec_streamEND6', LeftPost.SkeletalMeshComponent, 'Elec_streamSTART5');
	// End:0x598
	if(HUDDisplayEmitter != none)
	{
		Lock.AttachComponent(HUDDisplayEmitter);
		HUDDisplayMIC = new Class'Engine.MaterialInstanceConstant';
		// End:0x57A
		if(HUDDisplayMIC != none)
		{
			HUDDisplayMIC.SetParent(HUDDisplayMI);
			HUDDisplayEmitter.SetMaterialParameter('MainMaterial', HUDDisplayMIC);
		}
		SQMaxDist = HUDDisplayMaxDistance * HUDDisplayMaxDistance;
	}
	PlayAkEvent(AkEvent'Objects.Play_OBJ_Covenant_Barrier_Loop');
	super.PostBeginPlay();
	//return;	
}

function SkeletalMeshActorSpawnable SpawnLock(Vector ActorLocation)
{
	local SkeletalMeshActorSpawnable SMA;

	SMA = Spawn(Class'Engine.SkeletalMeshActorSpawnable',,, ActorLocation, Rotation,, true);
	// End:0x2EF
	if(SMA != none)
	{
		SMA.SetCollision(true, true, true);
		SMA.SkeletalMeshComponent.SetSkeletalMesh(LockMesh);
		SMA.SkeletalMeshComponent.SetPhysicsAsset(LockPhysics);
		SMA.SkeletalMeshComponent.SetRBChannel(GateMeshComp.RBChannel);
		SMA.SkeletalMeshComponent.SetRBCollisionChannels(GateMeshComp.RBCollideWithChannels);
		SMA.SkeletalMeshComponent.SetActorCollision(true, true);
		SMA.SkeletalMeshComponent.SetTraceBlocking(true, true);
		SMA.SkeletalMeshComponent.SetHasPhysicsAssetInstance(true);
		SMA.SkeletalMeshComponent.bUpdateSkelWhenNotRendered = false;
		SMA.SkeletalMeshComponent.bTickAnimNodesWhenNotRendered = false;
		SMA.SkeletalMeshComponent.bIgnoreControllersWhenNotRendered = true;
		SMA.SetBase(self,, GateMeshComp, 'gate_lock_root');
	}
	return SMA;
	//return ReturnValue;	
}

function StartBeamPSC(ParticleSystemComponent PSC, ParticleSystem Template, SkeletalMeshComponent StartMesh, name StartSocket, SkeletalMeshComponent EndMesh, name EndSocket)
{
	local Vector BeamEnd;

	StartMesh.AttachComponentToSocket(PSC, StartSocket);
	EndMesh.GetSocketWorldLocationAndRotation(EndSocket, BeamEnd,, 0);
	PSC.SetTemplate(Template);
	PSC.SetVectorParameter('WinchBeamEnd', BeamEnd);
	PSC.ActivateSystem();
	//return;	
}

simulated event Destroyed()
{
	PlayAkEvent(AkEvent'Objects.Play_OBJ_Covenant_Barrier_DeActivated');
	// End:0x32
	if(BlockingVolume != none)
	{
		ToggleBlockingVolume();
	}
	Lock.Destroy();
	SkelControl_AttachToLeftBone = none;
	SkelControl_AttachToRightBone = none;
	SkelControl_LockController = none;
	super.Destroyed();
	//return;	
}

function ToggleBlockingVolume()
{
	local SeqAct_Toggle Toggle;

	Toggle = new Class'Engine.SeqAct_Toggle';
	Toggle.InputLinks[1].bHasImpulse = true;
	BlockingVolume.OnToggle(Toggle);
	//return;	
}

function Vector GetWinchAttachLocation()
{
	return Lock.Location;
	//return ReturnValue;	
}

function SkeletalMesh TearDown()
{
	// End:0x34
	if(GateBreakParticleSystem != none)
	{
		SpawnParticleSystem(GateBreakParticleSystem, Location, Rotation);
	}
	// End:0x92
	if(LockBreakParticleSystem != none)
	{
		SpawnParticleSystem(LockBreakParticleSystem, Lock.Location, Lock.Rotation);
	}
	// End:0x115
	if(LeftPost != none)
	{
		LeftPost.TakeDamage(LeftPost.Health, none, LeftPost.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Crushed');
	}
	// End:0x198
	if(RightPost != none)
	{
		RightPost.TakeDamage(RightPost.Health, none, RightPost.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Crushed');
	}
	ResetLockController();
	Destroy();
	return self.Class.default.LockMesh;
	//return ReturnValue;	
}

function ResetLockController()
{
	local Vector zero;

	// End:0x37
	if(SkelControl_LockController != none)
	{
		SkelControl_LockController.BoneTranslation = zero;
	}
	//return;	
}

function Tick(float DeltaTime)
{
	local HaloPlayerPawnController PC;
	local HaloVehicle HV;
	local HaloGameDefault Game;
	local HVCCAddon_MagWinch TheWinch;
	local bool playerInRange, playerIsTargettingMe;

	// End:0x343
	if((HUDDisplayEmitter != none) && HUDDisplayMI != none)
	{
		Game = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game);
		playerInRange = false;
		// End:0x235
		foreach Game.TheMainPlayerGroup.PlayerControllers(PC)
		{
			// End:0x234
			if(PC.Pawn != none)
			{
				// End:0x234
				if(VSizeSq(PC.Pawn.Location - (GetWinchAttachLocation())) < SQMaxDist)
				{
					playerInRange = true;
					HV = HaloVehicle(PC.Pawn);
					// End:0x234
					if(((HV != none) && HV.HVCC_AttachedAddon != none) && HV.HVCC_AttachedAddon.IsA('HVCCAddon_MagWinch'))
					{
						TheWinch = HVCCAddon_MagWinch(HV.HVCC_AttachedAddon);
						// End:0x234
						if(TheWinch.CurrentGateTarget == self)
						{
							playerIsTargettingMe = true;
						}
					}
				}
			}			
		}		
		HUDDisplayEmitter.SetActive(playerInRange);
		// End:0x343
		if(HUDDisplayMIC != none)
		{
			// End:0x2AC
			if(playerIsTargettingMe)
			{
				HUDDisplayMIC.SetScalarParameterValue('bUnlocked', 1.0000000);				
			}
			else
			{
				HUDDisplayMIC.SetScalarParameterValue('bUnlocked', 0.0000000);
			}
			// End:0x316
			if(playerIsTargettingMe)
			{
				HUDDisplayEmitter.SetFloatParameter('ActivateMaterial', 1.0000000);				
			}
			else
			{
				HUDDisplayEmitter.SetFloatParameter('ActivateMaterial', 0.0000000);
			}
		}
	}
	// End:0x38E
	if(IsZero(SkelControl_LockController.BoneTranslation))
	{
		// End:0x38B
		if(bSparksPlaying)
		{
			SetSparksActive(false);
			bSparksPlaying = false;
		}		
	}
	else
	{
		// End:0x3D2
		if(bSparksPlaying == false)
		{
			// End:0x3BB
			if(bCreatedSparks == false)
			{
				SpawnSparks();				
			}
			else
			{
				SetSparksActive(true);
			}
			bSparksPlaying = true;
		}
	}
	//return;	
}

function SetSparksActive(bool bActive)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x65 [Loop If]
	if(I < Sparks.Length)
	{
		Sparks[I].SetActive(bActive);
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function SpawnSparks()
{
	local ParticleSystem Template;

	Sparks.Length = 6;
	Template = ParticleSystem'FX_COV_ShieldBarrier.Effects.FX_WinchLockSparks';
	Sparks[0] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(Template, Lock.SkeletalMeshComponent, 'Elec_streamEND1', true);
	Sparks[1] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(Template, Lock.SkeletalMeshComponent, 'Elec_streamEND2', true);
	Sparks[2] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(Template, Lock.SkeletalMeshComponent, 'Elec_streamEND3', true);
	Sparks[3] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(Template, Lock.SkeletalMeshComponent, 'Elec_streamEND4', true);
	Sparks[4] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(Template, Lock.SkeletalMeshComponent, 'Elec_streamEND5', true);
	Sparks[5] = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(Template, Lock.SkeletalMeshComponent, 'Elec_streamEND6', true);
	//return;	
}

function SpawnParticleSystem(ParticleSystem PS, Vector PSLoc, Rotator PSRot)
{
	local editinline ParticleSystemComponent PSC;

	PSC = WorldInfo.MyEmitterPool.SpawnEmitter(PS, PSLoc, PSRot);
	PSC.CastShadow = false;
	PSC.bCastDynamicShadow = false;
	PSC.bCastStaticShadow = false;
	PSC.bAcceptsDynamicDominantLightShadows = false;
	//return;	
}

defaultproperties
{
	MaxLockPullDistance=800.0000000
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWinchGateActor.GateMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'GateMesh'
	begin object name="GateMesh" class=Engine.SkeletalMeshComponent
		SkeletalMesh=SkeletalMesh'Winch_Gate.FX_WinchShield'
		AnimTreeTemplate=AnimTree'Winch_Gate.gate_wall_anim_tree'
		PhysicsAsset=PhysicsAsset'Winch_Gate.gate_wall_Physics'
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=true
		bTickAnimNodesWhenNotRendered=false
		bHasPhysicsAssetInstance=true
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloWinchGateActor.DynamicLightEnvironment'
		CollideActors=true
		BlockActors=true
		BlockZeroExtent=true
		BlockNonZeroExtent=true
		BlockRigidBody=true
		RBCollideWithChannels=(Default=true,Pawn=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true,Untitled1=true,Untitled2=true,Untitled3=true,Untitled4=true,FracturedMeshPart=true,BlockingVolume=true,DeadPawn=true)
	end object
	GateMeshComp=GateMesh
	GateBreakParticleSystem=ParticleSystem'FX_COV_ShieldBarrier.Effects.FX_WinchShield_BREAK'
	LockBreakParticleSystem=ParticleSystem'FX_COV_ShieldBarrier.Effects.FX_BarrierShield_Shatter'
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloWinchGateActor.ParticleSystemComponent15'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent15'
	begin object name="ParticleSystemComponent15" class=Engine.ParticleSystemComponent
		Template=ParticleSystem'mainhud.VehicleAddOnMarker.VehicleAddOnMarker_Particle'
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=6000.0000000
		CachedMaxDrawDistance=6000.0000000
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	HUDDisplayEmitter=ParticleSystemComponent15
	HUDDisplayMI=Material'mainhud.VehicleAddOnMarker.VehicleAddOnMarker_Mat'
	HUDDisplayMaxDistance=4800.0000000
	LeftPostArchetype=HaloDestructibleActor'Winch_Gate.Destructible.Archetype.COV_DEST_Shield_Barrier_Pillar_L'
	RightPostArchetype=HaloDestructibleActor'Winch_Gate.Destructible.Archetype.COV_DEST_Shield_Barrier_Pillar_R'
	LockMesh=SkeletalMesh'Winch_Gate.gate_lock'
	LockPhysics=PhysicsAsset'Winch_Gate.gate_lock_Physics'
	SkelControlName_AttachToLeftPostBone="left_gate"
	SkelControlName_AttachToRightPostBone="right_gate"
	SkelControlName_LockController="LockController"
	BeamTemplate=ParticleSystem'FX_COV_ShieldBarrier.Effects.FX_ElectricalStream'
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloWinchGateActor.ParticleSystemComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent0'
	begin object name="ParticleSystemComponent0" class=Engine.ParticleSystemComponent
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=15000.0000000
		CachedMaxDrawDistance=15000.0000000
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	PSC_LeftBeam0=ParticleSystemComponent0
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloWinchGateActor.ParticleSystemComponent1'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent1'
	begin object name="ParticleSystemComponent1" class=Engine.ParticleSystemComponent
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=15000.0000000
		CachedMaxDrawDistance=15000.0000000
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	PSC_LeftBeam1=ParticleSystemComponent1
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloWinchGateActor.ParticleSystemComponent2'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent2'
	begin object name="ParticleSystemComponent2" class=Engine.ParticleSystemComponent
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=15000.0000000
		CachedMaxDrawDistance=15000.0000000
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	PSC_LeftBeam2=ParticleSystemComponent2
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloWinchGateActor.ParticleSystemComponent3'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent3'
	begin object name="ParticleSystemComponent3" class=Engine.ParticleSystemComponent
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=15000.0000000
		CachedMaxDrawDistance=15000.0000000
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	PSC_RightBeam0=ParticleSystemComponent3
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloWinchGateActor.ParticleSystemComponent4'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent4'
	begin object name="ParticleSystemComponent4" class=Engine.ParticleSystemComponent
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=15000.0000000
		CachedMaxDrawDistance=15000.0000000
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	PSC_RightBeam1=ParticleSystemComponent4
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloWinchGateActor.ParticleSystemComponent5'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent5'
	begin object name="ParticleSystemComponent5" class=Engine.ParticleSystemComponent
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=15000.0000000
		CachedMaxDrawDistance=15000.0000000
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	PSC_RightBeam2=ParticleSystemComponent5
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloWinchGateActor.DynamicLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'DynamicLightEnvironment'
	begin object name="DynamicLightEnvironment" class=Engine.DynamicLightEnvironmentComponent
	end object
	Components[0]=DynamicLightEnvironment
	Components[1]=GateMesh
	Components[2]=ParticleSystemComponent0
	Components[3]=ParticleSystemComponent1
	Components[4]=ParticleSystemComponent2
	Components[5]=ParticleSystemComponent3
	Components[6]=ParticleSystemComponent4
	Components[7]=ParticleSystemComponent5
	CollisionType=ECollisionType.COLLIDE_CustomDefault
	BlockRigidBody=true
	bCollideActors=true
	bBlockActors=true
	bBlocksTeleport=true
	CollisionComponent=GateMesh
}