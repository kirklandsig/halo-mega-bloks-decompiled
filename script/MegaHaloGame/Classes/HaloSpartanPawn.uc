class HaloSpartanPawn extends HaloPawn
	config(Game);

var Vector JumpStartLoc;

function AddDefaultInventory()
{
	AddFragGrenadesToInventory(2);
	super.AddDefaultInventory();
	//return;	
}

function bool DoJump(bool bUpdating)
{
	// End:0x2A
	if(super.DoJump(bUpdating))
	{
		JumpStartLoc = Location;
	}
	return false;
	//return ReturnValue;	
}

simulated event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	// End:0x93
	if(HaloPlayerPawnController(Controller) != none)
	{
		// End:0x49
		if(int(Role) == int(ROLE_Authority))
		{
			CheckForLedgeGrab();
		}
		TickGravityLifts(DeltaTime);
		// End:0x93
		if(FootPlacement != none)
		{
			FootPlacement.Tick(DeltaTime);
		}
	}
	//return;	
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local bool shieldWasUp;

	shieldWasUp = (GetCurrentShield()) > float(0);
	// End:0x44
	if(shieldWasUp!)
	{
		PlayAkEvent(AkEvent'Dialog.Play_CHAR_Pain');
	}
	super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	// End:0xC1
	if(shieldWasUp && (GetCurrentShield()) == float(0))
	{
		NotifySucccessfulAttack(InstigatedBy);
	}
	// End:0xE9
	if(Health <= 0)
	{
		PlayAkEvent(AkEvent'Dialog.Play_CHAR_Die');
	}
	//return;	
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(0.5000000, true, 'BroadcastMeleeThreat');
	//return;	
}

simulated function BroadcastMeleeThreat()
{
	local HaloAIPawn enemyPawn;
	local CCSController enemyPawnController;

	// End:0x11B
	if(Health > 0)
	{
		// End:0x11A
		foreach WorldInfo.AllPawns(Class'MegaHaloGame.HaloAIPawn', enemyPawn, Location, 500.0000000)
		{
			// End:0x119
			if((enemyPawn != none) && int(enemyPawn.GetTeamNum()) != int(self.GetTeamNum()))
			{
				enemyPawnController = CCSController(enemyPawn.Controller);
				// End:0x119
				if(enemyPawnController != none)
				{
					enemyPawnController.NotifyThreatened(self, self.Velocity, 4);
				}
			}			
		}		
	}
	//return;	
}

defaultproperties
{
	KnockdownBehaviors[0]=(DamageType=none,AnimName="Spartan_Knock_Down_Left",MinRecoverTime=0.7500000,MaxRecoverTime=0.7500000,bIsDirectional=true,AnimHitDirection=-90.0000000,bSnapDirection=true,rDirection=(Pitch=0,Yaw=0,Roll=0))
	KnockdownBehaviors[1]=(DamageType=none,AnimName="Spartan_Knock_Down_Front",MinRecoverTime=0.7500000,MaxRecoverTime=0.7500000,bIsDirectional=true,AnimHitDirection=0.0000000,bSnapDirection=true,rDirection=(Pitch=0,Yaw=0,Roll=0))
	KnockdownBehaviors[2]=(DamageType=none,AnimName="Spartan_Knock_Down_Right",MinRecoverTime=0.7500000,MaxRecoverTime=0.7500000,bIsDirectional=true,AnimHitDirection=90.0000000,bSnapDirection=true,rDirection=(Pitch=0,Yaw=0,Roll=0))
	KnockdownBehaviors[3]=(DamageType=none,AnimName="Spartan_Knock_Down_Back",MinRecoverTime=0.7500000,MaxRecoverTime=0.7500000,bIsDirectional=true,AnimHitDirection=180.0000000,bSnapDirection=true,rDirection=(Pitch=0,Yaw=0,Roll=0))
	// Reference: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloSpartanPawn.CollectibleBlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollectibleBlokSpawnerComponent'
	// Archetype: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloPawn.CollectibleBlokSpawnerComponent'
	begin object name="CollectibleBlokSpawnerComponent"
		WaveData[0]=(bThrown=false,PercentHealthToThrowBloks=0.0000000,MinTotalValue=0,MaxTotalValue=0)
	end object
	CollectibleBlokSpawner=CollectibleBlokSpawnerComponent
	// Reference: HaloSuitShieldComponent'MegaHaloGame.Default__HaloSpartanPawn.SuitShieldComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SuitShieldComponent'
	begin object name="SuitShieldComponent" class=MegaHaloGame.HaloSuitShieldComponent
	end object
	SuitShield=SuitShieldComponent
	// Reference: HaloFootPlacementComponent'MegaHaloGame.Default__HaloSpartanPawn.FootPlacementComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'FootPlacementComponent'
	begin object name="FootPlacementComponent" class=MegaHaloGame.HaloFootPlacementComponent
	end object
	FootPlacement=FootPlacementComponent
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloSpartanPawn.targetableComponent'
	// Archetype: UDKTargetableComponent'MegaHaloGame.Default__HaloPawn.targetableComponent'
	begin object name="targetableComponent"
	end object
	MyTargetableComponent=targetableComponent
	// Reference: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloSpartanPawn.HaloTargetableComponent'
	// Archetype: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloPawn.HaloTargetableComponent'
	begin object name="HaloTargetableComponent"
	end object
	MyHaloTargetableComponent=HaloTargetableComponent
	TeamNum=1
	DefaultWeaponClass=Class'MegaHaloGame.HaloWeapon_AssaultRifle'
	SprintGroundSpeed=700.0000000
	AkCharacterType="Master_Chief"
	DoubleJumpSoundEvent=AkEvent'Foley.Play_Movement_DoubleJump'
	TeleportSoundEvent=AkEvent'FX_sounds.Play_FX_Teleport'
	SpawnSoundEvent=AkEvent'UIHUD.Play_Player_Respawn'
	TeleportOutEffect=ParticleSystem'MM_ONI_TELEPORTER.Effects.MM_ONI_TELEPORTER_BigBurst_Out'
	ZoneCaptureRate=2.0000000
	// Reference: HaloJumpComponent'MegaHaloGame.Default__HaloSpartanPawn.MyJumpComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyJumpComponent'
	begin object name="MyJumpComponent" class=MegaHaloGame.HaloJumpComponent
	end object
	JumpComponent=MyJumpComponent
	DoubleJumpCooldown=0.2000000
	LandFxTemplate=ParticleSystem'FX_Char_HitsGround.Effects.FX_Char_HitsGround'
	EventBroadcastClass=Class'MegaHaloGame.HaloSpartanPawn'
	GibMesh=SkeletalMesh'Halo_Master_Chief.MC_Frag'
	RamSpeed=3000.0000000
	RamDistance=600.0000000
	RamTargetRange=600.0000000
	RamTargetAngle=60.0000000
	RamToFallSpeedScale=0.3000000
	RamMissDuration=0.2500000
	RamLoopAnimName="Charge_Loop"
	RamWhileAirborneLoopAnimName="Charge_Air"
	RamHitActorAnimName="Charge_Exit"
	RamHitWallAnimName="Charge_HardExit"
	RamDamage=100
	RamDamageMomentum=100000.0000000
	RamHitWallBounce=0.5000000
	RamHitWallImpulseZ=100.0000000
	RamSoundEvent=AkEvent'Foley.Play_Movement_Charge'
	RamHitSoundEvent=AkEvent'Foley.Play_Melee_Charge_Impact'
	RamFxTemplate=ParticleSystem'FX_UNSC_JUMPJET.Effects.FX_UNSC_JUMPJET'
	TakedownDescs[0]=(TargetClass=Class'MegaHaloGame.HaloAIGruntPawn',MaxRange=250.0000000,MaxAngleOffset=60.0000000,MaxBackAngleOffset=60.0000000,TargetDistance=127.5000000,MyRightOffset=0.0000000,MyAnimName="Punt",TargetAnimName="Grunt_Punt_Behind",BlendInTime=0.1000000,BlendOutTime=0.1000000,LerpTime=0.1500000,bTargetUsesRootMotionOnZAxis=true)
	TakedownDescs[1]=(TargetClass=Class'MegaHaloGame.HaloAIElitePawn',MaxRange=250.0000000,MaxAngleOffset=60.0000000,MaxBackAngleOffset=60.0000000,TargetDistance=141.6399994,MyRightOffset=0.0000000,MyAnimName="TakeDown_Var2_Spartan",TargetAnimName="TakeDown_Var2_Elite",BlendInTime=0.1000000,BlendOutTime=0.1000000,LerpTime=0.1500000,bTargetUsesRootMotionOnZAxis=false)
	TakedownDescs[2]=(TargetClass=Class'MegaHaloGame.HaloAIHunterPawn',MaxRange=500.0000000,MaxAngleOffset=60.0000000,MaxBackAngleOffset=60.0000000,TargetDistance=352.6400146,MyRightOffset=-2.2279999,MyAnimName="hunter_fight_01",TargetAnimName="spartan_fight_01",BlendInTime=0.1000000,BlendOutTime=0.1000000,LerpTime=0.1500000,bTargetUsesRootMotionOnZAxis=false)
	// Reference: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloSpartanPawn.NeedleTarget'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NeedleTarget'
	// Archetype: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloPawn.NeedleTarget'
	begin object name="NeedleTarget"
	end object
	NeedleTargetComponent=NeedleTarget
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloSpartanPawn.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloPawn.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	TakeHitPhysicsFixedBones[0]="Bip001-L-Thigh"
	TakeHitPhysicsFixedBones[1]="Bip001-L-Calf"
	TakeHitPhysicsFixedBones[2]="Bip001-L-Foot"
	TakeHitPhysicsFixedBones[3]="Bip001-L-Toe0"
	TakeHitPhysicsFixedBones[4]="Bip001-R-Thigh"
	TakeHitPhysicsFixedBones[5]="Bip001-R-Calf"
	TakeHitPhysicsFixedBones[6]="Bip001-R-Foot"
	TakeHitPhysicsFixedBones[7]="Bip001-R-Toe0"
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloSpartanPawn.ForceFeedbackWaveformFall'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloPawn.ForceFeedbackWaveformFall'
	begin object name="ForceFeedbackWaveformFall"
	end object
	FallingDamageWaveForm=ForceFeedbackWaveformFall
	DefaultMeshScale=1.0000000
	bEnableFootPlacement=false
	CustomGravityScaling=3.0000000
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanPawn.OverlayMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'OverlayMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloPawn.OverlayMeshComponent0'
	begin object name="OverlayMeshComponent0"
		ReplacementPrimitive=none
	end object
	OverlayMesh=OverlayMeshComponent0
	LeftFootBone="Bip001-L-Foot"
	RightFootBone="Bip001-R-Foot"
	BaseTranslationOffset=7.0000000
	TakeHitPhysicsBlendOutSpeed=2.0000000
	// Refer[0]ence: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanPawn.FirstPersonArms'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloPawn.FirstPersonArms'
	begin object name="FirstPersonArms"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloSpartanPawn.FirstPersonArms.MeshSequenceA'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloPawn.FirstPersonArms.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanPawn.FirstPersonArms2'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloPawn.FirstPersonArms2'
	begin object name="FirstPersonArms2"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloSpartanPawn.FirstPersonArms2.MeshSequenceB'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloPawn.FirstPersonArms2.MeshSequenceB'
		begin object name="MeshSequenceB"
		end object
		Animations=MeshSequenceB
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms2
	MaxYawAim=12000
	// Reference: GwNavBotHandle'MegaHaloGame.Default__HaloSpartanPawn.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'MegaHaloGame.Default__HaloPawn.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	GroundSpeed=600.0000000
	JumpZ=1600.0000000
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanPawn.WPawnSkeletalMeshComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'WPawnSkeletalMeshComponent'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloPawn.WPawnSkeletalMeshComponent'
	begin object name="WPawnSkeletalMeshComponent"
		SkeletalMesh=SkeletalMesh'Halo_Master_Chief.Master_Chief'
		AnimTreeTemplate=AnimTree'Halo_Spartan_Anim.Spartan_AnimTree'
		PhysicsAsset=PhysicsAsset'Halo_Master_Chief.MC_Frag_Physics'
		AnimSets[0]=AnimSet'Halo_Spartan_Anim.Spartan_AnimSet'
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloSpartanPawn.MyLightEnvironment'
	end object
	Mesh=WPawnSkeletalMeshComponent
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloSpartanPawn.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloPawn.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=104.0000000
		CollisionRadius=50.0000000
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	Components[1]=none
	Components[2]=myGwNavBotHandle
	Components[3]=MyLightEnvironment
	Components[4]=WPawnSkeletalMeshComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloSpartanPawn.AmbientSoundComponent'
	// Archetype: UTAmbientSoundComponent'MegaHaloGame.Default__HaloPawn.AmbientSoundComponent'
	begin object name="AmbientSoundComponent"
	end object
	Components[5]=AmbientSoundComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloSpartanPawn.AmbientSoundComponent2'
	// Archetype: UTAmbientSoundComponent'MegaHaloGame.Default__HaloPawn.AmbientSoundComponent2'
	begin object name="AmbientSoundComponent2"
	end object
	Components[6]=AmbientSoundComponent2
	Components[7]=targetableComponent
	Components[8]=HaloTargetableComponent
	Components[9]=CollectibleBlokSpawnerComponent
	Components[10]=NeedleTarget
	Components[11]=MyJumpComponent
	Components[12]=SuitShieldComponent
	Components[13]=FootPlacementComponent
	CollisionComponent=CollisionCylinder
}