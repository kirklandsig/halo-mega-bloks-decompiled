class SkeletalMeshActor extends Actor
	native
	placeable;

struct CheckpointRecord
{
	var bool bReplicated;
	var bool bHidden;
	var bool bSavedPosition;
	var Vector Location;
	var Rotator Rotation;

	structdefaultproperties
	{
		bReplicated=false
		bHidden=false
		bSavedPosition=false
		Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		Rotation=(Pitch=0,Yaw=0,Roll=0)
	}
};

struct native SkelMeshActorControlTarget
{
	var name ControlName;
	var Actor TargetActor;

	structdefaultproperties
	{
		ControlName="None"
		TargetActor=none
	}
};

var bool bDamageAppliesImpulse;
var bool bShouldDoAnimNotifies;
var bool bForceSaveInCheckpoint;
var deprecated bool bCollideActors_OldValue;
var bool bShouldShadowParentAllAttachedActors;
var export editinline SkeletalMeshComponent SkeletalMeshComponent;
var const editconst export editinline LightEnvironmentComponent LightEnvironment;
var export editinline AudioComponent FacialAudioComp;
var repnotify transient SkeletalMesh ReplicatedMesh;
var repnotify MaterialInterface ReplicatedMaterial0;
var repnotify MaterialInterface ReplicatedMaterial1;
var array<SkelMeshActorControlTarget> ControlTargets;
var transient array<InterpGroup> InterpGroupList;
var private transient name SavedAnimSeqName;
var private transient float SavedCurrentTime;

replication
{
	// Pos:0x000
	if(int(Role) == int(ROLE_Authority))
		ReplicatedMaterial0, ReplicatedMaterial1, 
		ReplicatedMesh;
}

simulated event PostBeginPlay()
{
	// End:0x4D
	if((int(Role) == int(ROLE_Authority)) && SkeletalMeshComponent != none)
	{
		ReplicatedMesh = SkeletalMeshComponent.SkeletalMesh;
	}
	// End:0x76
	if(bShouldShadowParentAllAttachedActors)
	{
		SetShadowParentOnAllAttachedComponents(SkeletalMeshComponent, LightEnvironment);
	}
	// End:0xE9
	if((SkeletalMeshComponent != none) && SkeletalMeshComponent.PhysicsAssetInstance != none)
	{
		SkeletalMeshComponent.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(false, SkeletalMeshComponent);
	}
	// End:0x116
	if(bHidden)
	{
		SkeletalMeshComponent.SetClothFrozen(true);
	}
	//return;	
}

simulated event Destroyed()
{
	super.Destroyed();
	InterpGroupList.Length = 0;
	UpdateAnimSetList();
	//return;	
}

// Export USkeletalMeshActor::execUpdateAnimSetList(FFrame&, void* const)
native simulated function UpdateAnimSetList();

simulated event ReplicatedEvent(name VarName)
{
	// End:0x43
	if(VarName == 'ReplicatedMesh')
	{
		SkeletalMeshComponent.SetSkeletalMesh(ReplicatedMesh);		
	}
	else
	{
		// End:0x86
		if(VarName == 'ReplicatedMaterial0')
		{
			SkeletalMeshComponent.SetMaterial(0, ReplicatedMaterial0);			
		}
		else
		{
			// End:0xC9
			if(VarName == 'ReplicatedMaterial1')
			{
				SkeletalMeshComponent.SetMaterial(1, ReplicatedMaterial1);				
			}
			else
			{
				super.ReplicatedEvent(VarName);
			}
		}
	}
	//return;	
}

simulated function OnToggle(SeqAct_Toggle Action)
{
	local AnimNodeSequence SeqNode;

	SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
	// End:0x257
	if(SeqNode != none)
	{
		// End:0xFF
		if(Action.InputLinks[0].bHasImpulse)
		{
			// End:0xFC
			if(!SeqNode.bPlaying)
			{
				SeqNode.PlayAnim(SeqNode.bLooping, SeqNode.Rate, 0.0000000);
			}			
		}
		else
		{
			// End:0x17A
			if(Action.InputLinks[1].bHasImpulse)
			{
				// End:0x177
				if(SeqNode.bPlaying)
				{
					SeqNode.StopAnim();
				}				
			}
			else
			{
				// End:0x257
				if(Action.InputLinks[2].bHasImpulse)
				{
					// End:0x1F6
					if(SeqNode.bPlaying)
					{
						SeqNode.StopAnim();						
					}
					else
					{
						SeqNode.PlayAnim(SeqNode.bLooping, SeqNode.Rate, 0.0000000);
					}
				}
			}
		}
	}
	//return;	
}

function OnSetMaterial(SeqAct_SetMaterial Action)
{
	SkeletalMeshComponent.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
	// End:0xB1
	if(Action.MaterialIndex == 0)
	{
		ReplicatedMaterial0 = Action.NewMaterial;
		ForceNetRelevant();
	}
	// End:0x107
	if(Action.MaterialIndex == 1)
	{
		ReplicatedMaterial1 = Action.NewMaterial;
		ForceNetRelevant();
	}
	//return;	
}

simulated event BeginAnimControl(InterpGroup InInterpGroup)
{
	MAT_BeginAnimControl(InInterpGroup);
	//return;	
}

// Export USkeletalMeshActor::execMAT_BeginAnimControl(FFrame&, void* const)
native function MAT_BeginAnimControl(InterpGroup InInterpGroup);

simulated event SetAnimPosition(name SlotName, int ChannelIndex, name InAnimSeqName, float InPosition, bool bFireNotifies, bool bLooping, bool bEnableRootMotion)
{
	local AnimNodeSequence SeqNode;

	SkeletalMeshComponent.LastRenderTime = WorldInfo.TimeSeconds;
	SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
	// End:0x153
	if(SeqNode != none)
	{
		// End:0xF7
		if((SeqNode.AnimSeqName != InAnimSeqName) || SeqNode.AnimSeq == none)
		{
			SeqNode.SetAnim(InAnimSeqName);
		}
		SeqNode.bLooping = bLooping;
		SeqNode.SetPosition(InPosition, bFireNotifies);
	}
	//return;	
}

simulated event FinishAnimControl(InterpGroup InInterpGroup)
{
	MAT_FinishAnimControl(InInterpGroup);
	//return;	
}

// Export USkeletalMeshActor::execMAT_FinishAnimControl(FFrame&, void* const)
native function MAT_FinishAnimControl(InterpGroup InInterpGroup);

simulated event bool PlayActorFaceFXAnim(FaceFXAnimSet AnimSet, string GroupName, string SeqName, SoundCue SoundCueToPlay, AkEvent AkEventToPlay)
{
	return SkeletalMeshComponent.PlayFaceFXAnim(AnimSet, SeqName, GroupName, SoundCueToPlay, AkEventToPlay);
	//return ReturnValue;	
}

simulated event StopActorFaceFXAnim()
{
	SkeletalMeshComponent.StopFaceFXAnim();
	//return;	
}

simulated event AudioComponent GetFaceFXAudioComponent()
{
	return FacialAudioComp;
	//return ReturnValue;	
}

simulated function OnPlayFaceFXAnim(SeqAct_PlayFaceFXAnim inAction)
{
	local PlayerController PC;

	SkeletalMeshComponent.PlayFaceFXAnim(inAction.FaceFXAnimSetRef, inAction.FaceFXAnimName, inAction.FaceFXGroupName, inAction.SoundCueToPlay, inAction.AkEventToPlay);
	// End:0x1CD
	foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
	{
		// End:0x1CC
		if(NetConnection(PC.Player) != none)
		{
			PC.ClientPlayActorFaceFXAnim(self, inAction.FaceFXAnimSetRef, inAction.FaceFXGroupName, inAction.FaceFXAnimName, inAction.SoundCueToPlay, inAction.AkEventToPlay);
		}		
	}	
	//return;	
}

simulated event FaceFXAsset GetActorFaceFXAsset()
{
	// End:0x81
	if((SkeletalMeshComponent.SkeletalMesh != none) && !SkeletalMeshComponent.bDisableFaceFX)
	{
		return SkeletalMeshComponent.SkeletalMesh.FaceFXAsset;		
	}
	else
	{
		return none;
	}
	//return ReturnValue;	
}

simulated function bool IsActorPlayingFaceFXAnim()
{
	return (SkeletalMeshComponent != none) && SkeletalMeshComponent.IsPlayingFaceFXAnim();
	//return ReturnValue;	
}

event OnSetMesh(SeqAct_SetMesh Action)
{
	// End:0xF6
	if(int(Action.MeshType) == int(1))
	{
		// End:0xF6
		if((Action.NewSkeletalMesh != none) && Action.NewSkeletalMesh != SkeletalMeshComponent.SkeletalMesh)
		{
			SkeletalMeshComponent.SetSkeletalMesh(Action.NewSkeletalMesh);
			ReplicatedMesh = Action.NewSkeletalMesh;
		}
	}
	//return;	
}

simulated event OnUpdatePhysBonesFromAnim(SeqAct_UpdatePhysBonesFromAnim Action)
{
	// End:0x99
	if(Action.InputLinks[0].bHasImpulse)
	{
		SkeletalMeshComponent.ForceSkelUpdate();
		SkeletalMeshComponent.UpdateRBBonesFromSpaceBases(true, true);
		SkeletalMeshComponent.ForceApexClothingTeleportAndReset();		
	}
	else
	{
		// End:0x12C
		if(Action.InputLinks[1].bHasImpulse)
		{
			// End:0x129
			if(SkeletalMeshComponent.PhysicsAssetInstance != none)
			{
				SkeletalMeshComponent.PhysicsAssetInstance.SetAllBodiesFixed(true);
			}			
		}
		else
		{
			// End:0x1C6
			if(Action.InputLinks[2].bHasImpulse)
			{
				// End:0x1C6
				if(SkeletalMeshComponent.PhysicsAssetInstance != none)
				{
					SkeletalMeshComponent.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(false, SkeletalMeshComponent);
				}
			}
		}
	}
	//return;	
}

simulated event OnSetSkelControlTarget(SeqAct_SetSkelControlTarget Action)
{
	local int I;

	// End:0x55
	if((Action.SkelControlName == 'None') || Action.TargetActors.Length == 0)
	{
		return;
	}
	I = 0;
	J0x60:

	// End:0x141 [Loop If]
	if(I < ControlTargets.Length)
	{
		// End:0x133
		if(ControlTargets[I].ControlName == Action.SkelControlName)
		{
			ControlTargets[I].TargetActor = Actor(Action.TargetActors[Rand(Action.TargetActors.Length)]);
			return;
		}
		I++;
		// [Loop Continue]
		goto J0x60;
	}
	ControlTargets.Length = ControlTargets.Length + 1;
	ControlTargets[ControlTargets.Length - 1].ControlName = Action.SkelControlName;
	ControlTargets[ControlTargets.Length - 1].TargetActor = Actor(Action.TargetActors[Rand(Action.TargetActors.Length)]);
	//return;	
}

function DoKismetAttachment(Actor Attachment, SeqAct_AttachToActor Action)
{
	local bool bOldCollideActors, bOldBlockActors, bValidBone, bValidSocket;

	// End:0x19E
	if((SkeletalMeshComponent != none) && Action.BoneName != 'None')
	{
		bValidSocket = SkeletalMeshComponent.GetSocketByName(Action.BoneName) != none;
		bValidBone = SkeletalMeshComponent.MatchRefBone(Action.BoneName) != -1;
		// End:0x19E
		if(!bValidBone && !bValidSocket)
		{
			LogInternal((((((((string(WorldInfo.TimeSeconds) @ string(Class)) @ string(GetFuncName())) @ "bone or socket") @ string(Action.BoneName)) @ "not found on actor") @ string(self)) @ "with mesh") @ string(SkeletalMeshComponent));
		}
	}
	// End:0x4EF
	if(bValidBone || bValidSocket)
	{
		bOldCollideActors = Attachment.bCollideActors;
		bOldBlockActors = Attachment.bBlockActors;
		Attachment.SetCollision(false, false);
		Attachment.SetHardAttach(Action.bHardAttach);
		// End:0x37F
		if(bValidBone && !bValidSocket)
		{
			// End:0x2FD
			if(Action.bUseRelativeOffset)
			{
				Attachment.SetLocation(SkeletalMeshComponent.GetBoneLocation(Action.BoneName));
			}
			// End:0x37F
			if(Action.bUseRelativeRotation)
			{
				Attachment.SetRotation(QuatToRotator(SkeletalMeshComponent.GetBoneQuaternion(Action.BoneName)));
			}
		}
		Attachment.SetBase(self,, SkeletalMeshComponent, Action.BoneName);
		// End:0x440
		if(Action.bUseRelativeRotation)
		{
			Attachment.SetRelativeRotation(Attachment.RelativeRotation + Action.RelativeRotation);
		}
		// End:0x4BF
		if(Action.bUseRelativeOffset)
		{
			Attachment.SetRelativeLocation(Attachment.RelativeLocation + Action.RelativeOffset);
		}
		Attachment.SetCollision(bOldCollideActors, bOldBlockActors);		
	}
	else
	{
		super.DoKismetAttachment(Attachment, Action);
	}
	//return;	
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local Vector ApplyImpulse;

	super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	// End:0x181
	if(bDamageAppliesImpulse && DamageType.default.KDamageImpulse > float(0))
	{
		// End:0xC9
		if(VSize(Momentum) < 0.0010000)
		{
			LogInternal("Zero momentum to SkeletalMeshActor.TakeDamage");
			return;
		}
		ApplyImpulse = Normal(Momentum) * DamageType.default.KDamageImpulse;
		// End:0x181
		if(HitInfo.HitComponent != none)
		{
			HitInfo.HitComponent.AddImpulse(ApplyImpulse, HitLocation, HitInfo.BoneName);
		}
	}
	//return;	
}

function bool ShouldSaveForCheckpoint()
{
	return ((int(RemoteRole) != int(ROLE_None)) || bForceSaveInCheckpoint) || IsInPersistentLevel(true);
	//return ReturnValue;	
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
	Record.bReplicated = int(RemoteRole) != int(ROLE_None);
	Record.bHidden = bHidden;
	// End:0xDF
	if(bForceSaveInCheckpoint || IsInPersistentLevel(true))
	{
		Record.bSavedPosition = true;
		Record.Location = Location;
		Record.Rotation = Rotation;
	}
	//return;	
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
	SetHidden(Record.bHidden);
	// End:0x85
	if(Record.bSavedPosition)
	{
		SetLocation(Record.Location);
		SetRotation(Record.Rotation);
	}
	// End:0xEC
	if(Record.bReplicated)
	{
		ForceNetRelevant();
		// End:0xEC
		if(int(RemoteRole) != int(ROLE_None))
		{
			SetForcedInitialReplicatedProperty(BoolProperty'Engine.Actor.bHidden', bHidden == default.bHidden);
		}
	}
	//return;	
}

event bool PlayParticleEffect(const AnimNotify_PlayParticleEffect AnimNotifyData)
{
	local Vector Loc;
	local Rotator Rot;
	local editinline ParticleSystemComponent PSC;
	local bool bPlayNonExtreme;

	// End:0x6C
	if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
	{
		LogInternal("(SkeletalMeshActor): PlayParticleEffect on dedicated server!");
		return true;
	}
	bPlayNonExtreme = (AnimNotifyData.bIsExtremeContent == true) && WorldInfo.GRI.ShouldShowGore() == false;
	// End:0x11C
	if((bShouldDoAnimNotifies == false) || bPlayNonExtreme && AnimNotifyData.PSNonExtremeContentTemplate == none)
	{
		return true;
	}
	// End:0x320
	if(AnimNotifyData.bAttach == true)
	{
		PSC = new (self) Class'Engine.ParticleSystemComponent';
		// End:0x1A6
		if(bPlayNonExtreme)
		{
			PSC.SetTemplate(AnimNotifyData.PSNonExtremeContentTemplate);			
		}
		else
		{
			PSC.SetTemplate(AnimNotifyData.PSTemplate);
		}
		// End:0x258
		if(AnimNotifyData.SocketName != 'None')
		{
			SkeletalMeshComponent.AttachComponentToSocket(PSC, AnimNotifyData.SocketName);			
		}
		else
		{
			// End:0x2CD
			if(AnimNotifyData.BoneName != 'None')
			{
				SkeletalMeshComponent.AttachComponent(PSC, AnimNotifyData.BoneName);
			}
		}
		PSC.ActivateSystem();
		PSC.__OnSystemFinished__Delegate = SkelMeshActorOnParticleSystemFinished;		
	}
	else
	{
		// End:0x39F
		if(AnimNotifyData.SocketName != 'None')
		{
			SkeletalMeshComponent.GetSocketWorldLocationAndRotation(AnimNotifyData.SocketName, Loc, Rot);			
		}
		else
		{
			// End:0x468
			if(AnimNotifyData.BoneName != 'None')
			{
				Loc = SkeletalMeshComponent.GetBoneLocation(AnimNotifyData.BoneName);
				Rot = QuatToRotator(SkeletalMeshComponent.GetBoneQuaternion(AnimNotifyData.BoneName));				
			}
			else
			{
				Loc = Location;
				Rot = rot(0, 0, 1);
			}
		}
		PSC = WorldInfo.MyEmitterPool.SpawnEmitter(AnimNotifyData.PSTemplate, Loc, Rot);
	}
	// End:0x57F
	if((PSC != none) && AnimNotifyData.BoneSocketModuleActorName != 'None')
	{
		PSC.SetActorParameter(AnimNotifyData.BoneSocketModuleActorName, self);
	}
	return true;
	//return ReturnValue;	
}

simulated function SkelMeshActorOnParticleSystemFinished(ParticleSystemComponent PSC)
{
	SkeletalMeshComponent.DetachComponent(PSC);
	//return;	
}

event bool CreateForceField(const AnimNotify_ForceField AnimNotifyData)
{
	local editinline NxForceFieldComponent NewForceFieldComponent;

	NewForceFieldComponent = new (SkeletalMeshComponent) AnimNotifyData.ForceFieldComponent.Class (AnimNotifyData.ForceFieldComponent);
	NewForceFieldComponent.DoInitRBPhys();
	// End:0xFB
	if(AnimNotifyData.SocketName != 'None')
	{
		SkeletalMeshComponent.AttachComponentToSocket(NewForceFieldComponent, AnimNotifyData.SocketName);		
	}
	else
	{
		// End:0x170
		if(AnimNotifyData.BoneName != 'None')
		{
			SkeletalMeshComponent.AttachComponent(NewForceFieldComponent, AnimNotifyData.BoneName);
		}
	}
	return true;
	//return ReturnValue;	
}

defaultproperties
{
	bShouldDoAnimNotifies=true
	// Reference: SkeletalMeshComponent'Engine.Default__SkeletalMeshActor.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0" class=Engine.SkeletalMeshComponent
		Animations=AnimNodeSequence'Engine.Default__SkeletalMeshActor.AnimNodeSeq0'
		bUpdateSkelWhenNotRendered=false
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'Engine.Default__SkeletalMeshActor.MyLightEnvironment'
		RBChannel=ERBCollisionChannel.RBCC_GameplayPhysics
		CollideActors=true
		BlockZeroExtent=true
		RBCollideWithChannels=(Default=true,GameplayPhysics=true,EffectPhysics=true,BlockingVolume=true)
	end object
	SkeletalMeshComponent=SkeletalMeshComponent0
	// Reference: DynamicLightEnvironmentComponent'Engine.Default__SkeletalMeshActor.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	begin object name="MyLightEnvironment" class=Engine.DynamicLightEnvironmentComponent
	end object
	LightEnvironment=MyLightEnvironment
	// Reference: AudioComponent'Engine.Default__SkeletalMeshActor.FaceAudioComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'FaceAudioComponent'
	begin object name="FaceAudioComponent" class=Engine.AudioComponent
	end object
	FacialAudioComp=FaceAudioComponent
	Components[0]=MyLightEnvironment
	Components[1]=SkeletalMeshComponent0
	Components[2]=FaceAudioComponent
	bNoDelete=true
	bProjTarget=true
	bNoEncroachCheck=true
	bEdShouldSnap=true
	CollisionComponent=SkeletalMeshComponent0
}