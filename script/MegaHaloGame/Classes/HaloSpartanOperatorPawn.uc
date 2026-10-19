class HaloSpartanOperatorPawn extends HaloSpartanPawn
	config(Game);

defaultproperties
{
	// Reference: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloSpartanOperatorPawn.CollectibleBlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollectibleBlokSpawnerComponent'
	// Archetype: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloSpartanPawn.CollectibleBlokSpawnerComponent'
	begin object name="CollectibleBlokSpawnerComponent"
	end object
	CollectibleBlokSpawner=CollectibleBlokSpawnerComponent
	// Reference: HaloSuitShieldComponent'MegaHaloGame.Default__HaloSpartanOperatorPawn.SuitShieldComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SuitShieldComponent'
	// Archetype: HaloSuitShieldComponent'MegaHaloGame.Default__HaloSpartanPawn.SuitShieldComponent'
	begin object name="SuitShieldComponent"
	end object
	SuitShield=SuitShieldComponent
	// Reference: HaloFootPlacementComponent'MegaHaloGame.Default__HaloSpartanOperatorPawn.FootPlacementComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'FootPlacementComponent'
	// Archetype: HaloFootPlacementComponent'MegaHaloGame.Default__HaloSpartanPawn.FootPlacementComponent'
	begin object name="FootPlacementComponent"
	end object
	FootPlacement=FootPlacementComponent
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloSpartanOperatorPawn.targetableComponent'
	// Archetype: UDKTargetableComponent'MegaHaloGame.Default__HaloSpartanPawn.targetableComponent'
	begin object name="targetableComponent"
	end object
	MyTargetableComponent=targetableComponent
	// Reference: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloSpartanOperatorPawn.HaloTargetableComponent'
	// Archetype: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloSpartanPawn.HaloTargetableComponent'
	begin object name="HaloTargetableComponent"
	end object
	MyHaloTargetableComponent=HaloTargetableComponent
	CharacterRole=CR_HEAVY
	AkCharacterType="Spartan_Operator"
	// Reference: HaloJumpComponent'MegaHaloGame.Default__HaloSpartanOperatorPawn.MyJumpComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyJumpComponent'
	// Archetype: HaloJumpComponent'MegaHaloGame.Default__HaloSpartanPawn.MyJumpComponent'
	begin object name="MyJumpComponent"
	end object
	JumpComponent=MyJumpComponent
	// Reference: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloSpartanOperatorPawn.NeedleTarget'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NeedleTarget'
	// Archetype: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloSpartanPawn.NeedleTarget'
	begin object name="NeedleTarget"
	end object
	NeedleTargetComponent=NeedleTarget
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloSpartanOperatorPawn.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloSpartanPawn.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloSpartanOperatorPawn.ForceFeedbackWaveformFall'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloSpartanPawn.ForceFeedbackWaveformFall'
	begin object name="ForceFeedbackWaveformFall"
	end object
	FallingDamageWaveForm=ForceFeedbackWaveformFall
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanOperatorPawn.OverlayMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'OverlayMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanPawn.OverlayMeshComponent0'
	begin object name="OverlayMeshComponent0"
		ReplacementPrimitive=none
	end object
	OverlayMesh=OverlayMeshComponent0
	// Refer[0]ence: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanOperatorPawn.FirstPersonArms'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanPawn.FirstPersonArms'
	begin object name="FirstPersonArms"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloSpartanOperatorPawn.FirstPersonArms.MeshSequenceA'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloSpartanPawn.FirstPersonArms.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanOperatorPawn.FirstPersonArms2'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanPawn.FirstPersonArms2'
	begin object name="FirstPersonArms2"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloSpartanOperatorPawn.FirstPersonArms2.MeshSequenceB'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloSpartanPawn.FirstPersonArms2.MeshSequenceB'
		begin object name="MeshSequenceB"
		end object
		Animations=MeshSequenceB
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms2
	// Reference: GwNavBotHandle'MegaHaloGame.Default__HaloSpartanOperatorPawn.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'MegaHaloGame.Default__HaloSpartanPawn.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanOperatorPawn.WPawnSkeletalMeshComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'WPawnSkeletalMeshComponent'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanPawn.WPawnSkeletalMeshComponent'
	begin object name="WPawnSkeletalMeshComponent"
		SkeletalMesh=SkeletalMesh'Spartan_Operator.Spartan_Operator'
		Materials[0]=MaterialInstanceConstant'Spartan_Operator.Materials.MIC.MI_UNSC_SpartanOperatorOperator_Mat'
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloSpartanOperatorPawn.MyLightEnvironment'
	end object
	Mesh=WPawnSkeletalMeshComponent
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloSpartanOperatorPawn.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloSpartanPawn.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	Components[1]=none
	Components[2]=myGwNavBotHandle
	Components[3]=MyLightEnvironment
	Components[4]=WPawnSkeletalMeshComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloSpartanOperatorPawn.AmbientSoundComponent'
	// Archetype: UTAmbientSoundComponent'MegaHaloGame.Default__HaloSpartanPawn.AmbientSoundComponent'
	begin object name="AmbientSoundComponent"
	end object
	Components[5]=AmbientSoundComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloSpartanOperatorPawn.AmbientSoundComponent2'
	// Archetype: UTAmbientSoundComponent'MegaHaloGame.Default__HaloSpartanPawn.AmbientSoundComponent2'
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