class HaloSpartanRecruitPawn extends HaloAIPawn
	config(Game);

defaultproperties
{
	DefaultWeapon=Class'MegaHaloGame.HaloWeapon_AssaultRifle'
	// Reference: HaloCameraEncounterTargetableComponent'MegaHaloGame.Default__HaloSpartanRecruitPawn.HaloCameraEncounterTargetableComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'HaloCameraEncounterTargetableComponent0'
	// Archetype: HaloCameraEncounterTargetableComponent'MegaHaloGame.Default__HaloAIPawn.HaloCameraEncounterTargetableComponent0'
	begin object name="HaloCameraEncounterTargetableComponent0"
	end object
	CameraEncounterTargetableComponent=HaloCameraEncounterTargetableComponent0
	// Reference: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloSpartanRecruitPawn.CollectibleBlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollectibleBlokSpawnerComponent'
	// Archetype: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloAIPawn.CollectibleBlokSpawnerComponent'
	begin object name="CollectibleBlokSpawnerComponent"
	end object
	CollectibleBlokSpawner=CollectibleBlokSpawnerComponent
	// Reference: HaloSuitShieldComponent'MegaHaloGame.Default__HaloSpartanRecruitPawn.SuitShieldComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SuitShieldComponent'
	begin object name="SuitShieldComponent" class=MegaHaloGame.HaloSuitShieldComponent
	end object
	SuitShield=SuitShieldComponent
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloSpartanRecruitPawn.targetableComponent'
	// Archetype: UDKTargetableComponent'MegaHaloGame.Default__HaloAIPawn.targetableComponent'
	begin object name="targetableComponent"
	end object
	MyTargetableComponent=targetableComponent
	// Reference: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloSpartanRecruitPawn.HaloTargetableComponent'
	// Archetype: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloAIPawn.HaloTargetableComponent'
	begin object name="HaloTargetableComponent"
	end object
	MyHaloTargetableComponent=HaloTargetableComponent
	TeamNum=1
	GibMesh=SkeletalMesh'Halo_Master_Chief.MC_Frag'
	// Reference: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloSpartanRecruitPawn.NeedleTarget'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NeedleTarget'
	// Archetype: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloAIPawn.NeedleTarget'
	begin object name="NeedleTarget"
	end object
	NeedleTargetComponent=NeedleTarget
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloSpartanRecruitPawn.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloAIPawn.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloSpartanRecruitPawn.ForceFeedbackWaveformFall'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloAIPawn.ForceFeedbackWaveformFall'
	begin object name="ForceFeedbackWaveformFall"
	end object
	FallingDamageWaveForm=ForceFeedbackWaveformFall
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanRecruitPawn.OverlayMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'OverlayMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.OverlayMeshComponent0'
	begin object name="OverlayMeshComponent0"
		ReplacementPrimitive=none
	end object
	OverlayMesh=OverlayMeshComponent0
	// Refer[0]ence: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanRecruitPawn.FirstPersonArms'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms'
	begin object name="FirstPersonArms"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloSpartanRecruitPawn.FirstPersonArms.MeshSequenceA'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanRecruitPawn.FirstPersonArms2'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms2'
	begin object name="FirstPersonArms2"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloSpartanRecruitPawn.FirstPersonArms2.MeshSequenceB'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloAIPawn.FirstPersonArms2.MeshSequenceB'
		begin object name="MeshSequenceB"
		end object
		Animations=MeshSequenceB
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms2
	// Reference: GwNavBotHandle'MegaHaloGame.Default__HaloSpartanRecruitPawn.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'MegaHaloGame.Default__HaloAIPawn.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanRecruitPawn.WPawnSkeletalMeshComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'WPawnSkeletalMeshComponent'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloAIPawn.WPawnSkeletalMeshComponent'
	begin object name="WPawnSkeletalMeshComponent"
		SkeletalMesh=SkeletalMesh'Spartan_Recruit.Spartan_Recruit'
		AnimTreeTemplate=AnimTree'Halo_Spartan_Anim.Spartan_AnimTree'
		PhysicsAsset=PhysicsAsset'Halo_Master_Chief.MC_Frag_Physics'
		AnimSets[0]=AnimSet'Halo_Spartan_Anim.Spartan_AnimSet'
		Materials[0]=MaterialInstanceConstant'Spartan_Recruit.Materials.MIC.MI_UNSC_SpartanGreyRecruit_Mat'
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloSpartanRecruitPawn.MyLightEnvironment'
	end object
	Mesh=WPawnSkeletalMeshComponent
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloSpartanRecruitPawn.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloAIPawn.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	Components[1]=none
	Components[2]=myGwNavBotHandle
	Components[3]=MyLightEnvironment
	Components[4]=WPawnSkeletalMeshComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloSpartanRecruitPawn.AmbientSoundComponent'
	// Archetype: UTAmbientSoundComponent'MegaHaloGame.Default__HaloAIPawn.AmbientSoundComponent'
	begin object name="AmbientSoundComponent"
	end object
	Components[5]=AmbientSoundComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloSpartanRecruitPawn.AmbientSoundComponent2'
	// Archetype: UTAmbientSoundComponent'MegaHaloGame.Default__HaloAIPawn.AmbientSoundComponent2'
	begin object name="AmbientSoundComponent2"
	end object
	Components[6]=AmbientSoundComponent2
	Components[7]=targetableComponent
	Components[8]=HaloTargetableComponent
	Components[9]=CollectibleBlokSpawnerComponent
	Components[10]=NeedleTarget
	Components[11]=HaloCameraEncounterTargetableComponent0
	Components[12]=SuitShieldComponent
	CollisionComponent=CollisionCylinder
}