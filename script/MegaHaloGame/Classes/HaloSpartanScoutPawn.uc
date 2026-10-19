class HaloSpartanScoutPawn extends HaloSpartanPawn
	config(Game);

var float CooldownReduction;
var export editinline HaloActiveCamoComponent ActiveCamo;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	// End:0x35
	if(ArmorAbility != none)
	{
		ActiveCamo = HaloActiveCamoComponent(ArmorAbility);
	}
	//return;	
}

function bool ActivateArmorAbility()
{
	// End:0x74
	if(ActiveCamo != none)
	{
		// End:0x54
		if(ActiveCamo.bActive)
		{
			return ActiveCamo.Deactivate();			
		}
		else
		{
			return ActiveCamo.Activate();
		}
	}
	return super(HaloPawn).ActivateArmorAbility();
	//return ReturnValue;	
}

function OnGrenadeThrow()
{
	// End:0x2E
	if(ActiveCamo != none)
	{
		ActiveCamo.Deactivate();
	}
	super(HaloPawn).OnGrenadeThrow();
	//return;	
}

function OnMelee()
{
	// End:0x2E
	if(ActiveCamo != none)
	{
		ActiveCamo.Deactivate();
	}
	super(HaloPawn).OnMelee();
	//return;	
}

function OnRam()
{
	// End:0x2E
	if(ActiveCamo != none)
	{
		ActiveCamo.Deactivate();
	}
	super(HaloPawn).OnRam();
	//return;	
}

function OnTakedown()
{
	// End:0x2E
	if(ActiveCamo != none)
	{
		ActiveCamo.Deactivate();
	}
	super(HaloPawn).OnTakedown();
	//return;	
}

function OnWeaponFire()
{
	// End:0x2E
	if(ActiveCamo != none)
	{
		ActiveCamo.Deactivate();
	}
	super(HaloPawn).OnWeaponFire();
	//return;	
}

function OnWeaponAttach()
{
	// End:0x2E
	if(ActiveCamo != none)
	{
		ActiveCamo.OnWeaponAttach();
	}
	super(HaloPawn).OnWeaponAttach();
	//return;	
}

function OnWeaponDetach()
{
	// End:0x2E
	if(ActiveCamo != none)
	{
		ActiveCamo.OnWeaponDetach();
	}
	super(HaloPawn).OnWeaponDetach();
	//return;	
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	// End:0x7D
	if(ActiveCamo != none)
	{
		// End:0x55
		if(ActiveCamo.bActive)
		{
			ActiveCamo.Deactivate();			
		}
		else
		{
			ActiveCamo.ReduceCooldown(CooldownReduction);
		}
	}
	super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	//return;	
}

simulated event Tick(float DeltaTime)
{
	// End:0x37
	if(ActiveCamo != none)
	{
		ActiveCamo.Tick(DeltaTime);
	}
	super.Tick(DeltaTime);
	//return;	
}

defaultproperties
{
	CooldownReduction=2.0000000
	// Reference: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloSpartanScoutPawn.CollectibleBlokSpawnerComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollectibleBlokSpawnerComponent'
	// Archetype: HaloCollectibleBlokSpawnerComponent'MegaHaloGame.Default__HaloSpartanPawn.CollectibleBlokSpawnerComponent'
	begin object name="CollectibleBlokSpawnerComponent"
	end object
	CollectibleBlokSpawner=CollectibleBlokSpawnerComponent
	// Reference: HaloSuitShieldComponent'MegaHaloGame.Default__HaloSpartanScoutPawn.SuitShieldComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SuitShieldComponent'
	// Archetype: HaloSuitShieldComponent'MegaHaloGame.Default__HaloSpartanPawn.SuitShieldComponent'
	begin object name="SuitShieldComponent"
	end object
	SuitShield=SuitShieldComponent
	// Reference: HaloFootPlacementComponent'MegaHaloGame.Default__HaloSpartanScoutPawn.FootPlacementComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'FootPlacementComponent'
	// Archetype: HaloFootPlacementComponent'MegaHaloGame.Default__HaloSpartanPawn.FootPlacementComponent'
	begin object name="FootPlacementComponent"
	end object
	FootPlacement=FootPlacementComponent
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloSpartanScoutPawn.targetableComponent'
	// Archetype: UDKTargetableComponent'MegaHaloGame.Default__HaloSpartanPawn.targetableComponent'
	begin object name="targetableComponent"
	end object
	MyTargetableComponent=targetableComponent
	// Reference: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloSpartanScoutPawn.HaloTargetableComponent'
	// Archetype: HaloTargetableComponent_Pawn'MegaHaloGame.Default__HaloSpartanPawn.HaloTargetableComponent'
	begin object name="HaloTargetableComponent"
	end object
	MyHaloTargetableComponent=HaloTargetableComponent
	CharacterRole=CR_SCOUT
	PawnType=PPT_Scout
	DefaultWeaponClass=Class'MegaHaloGame.HaloWeapon_BattleRifle'
	AkCharacterType="Spartan_Recruit"
	// Reference: HaloJumpComponent'MegaHaloGame.Default__HaloSpartanScoutPawn.MyJumpComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyJumpComponent'
	// Archetype: HaloJumpComponent'MegaHaloGame.Default__HaloSpartanPawn.MyJumpComponent'
	begin object name="MyJumpComponent"
	end object
	JumpComponent=MyJumpComponent
	// Reference: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloSpartanScoutPawn.NeedleTarget'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'NeedleTarget'
	// Archetype: HaloNeedleTargetComponent'MegaHaloGame.Default__HaloSpartanPawn.NeedleTarget'
	begin object name="NeedleTarget"
	end object
	NeedleTargetComponent=NeedleTarget
	ArmorAbilityClass=Class'MegaHaloGame.HaloActiveCamoComponent'
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloSpartanScoutPawn.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloSpartanPawn.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloSpartanScoutPawn.ForceFeedbackWaveformFall'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloSpartanPawn.ForceFeedbackWaveformFall'
	begin object name="ForceFeedbackWaveformFall"
	end object
	FallingDamageWaveForm=ForceFeedbackWaveformFall
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanScoutPawn.OverlayMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'OverlayMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanPawn.OverlayMeshComponent0'
	begin object name="OverlayMeshComponent0"
		ReplacementPrimitive=none
	end object
	OverlayMesh=OverlayMeshComponent0
	// Refer[0]ence: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanScoutPawn.FirstPersonArms'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanPawn.FirstPersonArms'
	begin object name="FirstPersonArms"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloSpartanScoutPawn.FirstPersonArms.MeshSequenceA'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloSpartanPawn.FirstPersonArms.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanScoutPawn.FirstPersonArms2'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanPawn.FirstPersonArms2'
	begin object name="FirstPersonArms2"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloSpartanScoutPawn.FirstPersonArms2.MeshSequenceB'
		// Archetype: AnimNodeSequence'MegaHaloGame.Default__HaloSpartanPawn.FirstPersonArms2.MeshSequenceB'
		begin object name="MeshSequenceB"
		end object
		Animations=MeshSequenceB
		ReplacementPrimitive=none
	end object
	ArmsMesh=FirstPersonArms2
	// Reference: GwNavBotHandle'MegaHaloGame.Default__HaloSpartanScoutPawn.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'MegaHaloGame.Default__HaloSpartanPawn.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanScoutPawn.WPawnSkeletalMeshComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'WPawnSkeletalMeshComponent'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloSpartanPawn.WPawnSkeletalMeshComponent'
	begin object name="WPawnSkeletalMeshComponent"
		SkeletalMesh=SkeletalMesh'Spartan_Scout.Scout'
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloSpartanScoutPawn.MyLightEnvironment'
	end object
	Mesh=WPawnSkeletalMeshComponent
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloSpartanScoutPawn.CollisionCylinder'
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
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloSpartanScoutPawn.AmbientSoundComponent'
	// Archetype: UTAmbientSoundComponent'MegaHaloGame.Default__HaloSpartanPawn.AmbientSoundComponent'
	begin object name="AmbientSoundComponent"
	end object
	Components[5]=AmbientSoundComponent
	// Reference: UTAmbientSoundComponent'MegaHaloGame.Default__HaloSpartanScoutPawn.AmbientSoundComponent2'
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