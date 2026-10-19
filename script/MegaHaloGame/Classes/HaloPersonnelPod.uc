class HaloPersonnelPod extends SkeletalMeshActorSpawnable
	implements(IHaloDeployable);

var archetype HaloPawn CharacterArchetypeRef;
var Class<Actor> CharacterClassRef;
var SkeletalMesh GroundBaseMesh;
var StaticMesh PreviewMesh;
var float PreviewSpinDegsPerSec;
var float PreviewMeshHeightOffset;
var export editinline StaticMeshComponent PreviewMeshComponent;
var SkeletalMeshActorSpawnable GroundBaseActor;
var bool bSwitchScheduled;
var HaloPlayerPawnController ControllerToBeSwitched;
var HaloPawn PrevPawnControlled;
var HaloPawn NextPawnToControl;
var float NextPawnBaseModifiableThreatPct;
var HaloWeapon_TargetDesignator.ETargetDesignatorCategory DeployableCategory;
var name DeployableName;
var Actor DeployableBase;

simulated function SetCharacterArchetype(Actor hpArchetype)
{
	CharacterArchetypeRef = HaloPawn(hpArchetype);
	CharacterClassRef = none;
	//return;	
}

simulated function SetCharacterClass(Class<Actor> hpClass)
{
	CharacterClassRef = hpClass;
	CharacterArchetypeRef = none;
	//return;	
}

simulated function Destroyed()
{
	// End:0x27
	if(GroundBaseActor != none)
	{
		GroundBaseActor.Destroy();
	}
	//return;	
}

simulated function PostBeginPlay()
{
	local Vector previewMeshPos;

	super(SkeletalMeshActor).PostBeginPlay();
	// End:0xBB
	if(GroundBaseMesh != none)
	{
		GroundBaseActor = Spawn(Class'Engine.SkeletalMeshActorSpawnable', self,, Location, Rotation,, true);
		// End:0xBB
		if(GroundBaseActor != none)
		{
			GroundBaseActor.SkeletalMeshComponent.SetSkeletalMesh(GroundBaseMesh);
			GroundBaseActor.SetCollisionType(2);
		}
	}
	SetTimer(0.1000000, false, 'CreateNewCharacter');
	// End:0x168
	if(PreviewMesh != none)
	{
		PreviewMeshComponent.SetStaticMesh(PreviewMesh);
		previewMeshPos.Z += PreviewMeshHeightOffset;
		PreviewMeshComponent.SetTranslation(previewMeshPos);
		SetTimer(0.1000000, true, 'SpinPreview');
	}
	//return;	
}

simulated function SpinPreview()
{
	local Rotator orient;

	// End:0xF5
	if(PreviewMeshComponent != none)
	{
		orient = PreviewMeshComponent.GetRotation();
		orient.Roll = 0;
		orient.Pitch = 0;
		orient.Yaw += int((PreviewSpinDegsPerSec * 0.1000000) * 182.0444031);
		PreviewMeshComponent.SetAbsolute(,, true);
		PreviewMeshComponent.SetRotation(orient);
	}
	//return;	
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	local editinline UDKTargetableComponent targetComp;

	// End:0x24C
	if(((!bSwitchScheduled && HaloPawn(Other) != none) && NextPawnToControl != none) && HaloPlayerPawnController(HaloPawn(Other).Controller) != none)
	{
		ControllerToBeSwitched = HaloPlayerPawnController(HaloPawn(Other).Controller);
		PrevPawnControlled = HaloPawn(Other);
		bSwitchScheduled = true;
		NextPawnToControl.SetLocation(PrevPawnControlled.Location);
		NextPawnToControl.SetRotation(PrevPawnControlled.Rotation);
		NextPawnToControl.bIsIntendedForPlayerControl = true;
		NextPawnToControl.IntendedDeploymentController = ControllerToBeSwitched;
		targetComp = UDKTargetableComponent(NextPawnToControl.GetComponentOfType(Class'UDKBase.UDKTargetableComponent'));
		// End:0x1FB
		if(targetComp != none)
		{
			targetComp.ModifiableThreatPct = NextPawnBaseModifiableThreatPct;
		}
		NextPawnToControl.SetTimer(0.0100000, false, 'NotifyIntendedController');
		PlayAkEvent(AkEvent'Equipment.Play_Class_Swap');
		self.Destroy();
	}
	//return;	
}

event CreateNewCharacter()
{
	local Vector createPos;
	local Rotator createRot;
	local editinline UDKTargetableComponent targetComp;

	NextPawnToControl = none;
	// End:0x6D
	if(PrevPawnControlled != none)
	{
		createPos = PrevPawnControlled.Location;
		createRot = PrevPawnControlled.Rotation;		
	}
	else
	{
		createPos = self.Location;
		createRot = self.Rotation;
	}
	// End:0x110
	if(CharacterArchetypeRef != none)
	{
		NextPawnToControl = Spawn(CharacterArchetypeRef.Class,,, createPos, createRot, CharacterArchetypeRef, true);		
	}
	else
	{
		// End:0x15C
		if(CharacterClassRef != none)
		{
			NextPawnToControl = HaloPawn(Spawn(CharacterClassRef,,, createPos, createRot,, true));
		}
	}
	// End:0x2DA
	if(NextPawnToControl != none)
	{
		NextPawnToControl.SetHidden(true);
		NextPawnToControl.SetCollisionType(1);
		NextPawnToControl.bIsIntendedForPlayerControl = true;
		NextPawnToControl.IntendedDeploymentController = ControllerToBeSwitched;
		WorldInfo.Game.AddDefaultInventory(NextPawnToControl);
		targetComp = UDKTargetableComponent(NextPawnToControl.GetComponentOfType(Class'UDKBase.UDKTargetableComponent'));
		// End:0x2CB
		if(targetComp != none)
		{
			NextPawnBaseModifiableThreatPct = targetComp.ModifiableThreatPct;
			targetComp.ModifiableThreatPct = 0.0000000;			
		}
		else
		{
			NextPawnBaseModifiableThreatPct = 1.0000000;
		}
	}
	//return;	
}

event Tick(float DeltaTime)
{
	super(Actor).Tick(DeltaTime);
	// End:0x7B
	if((GroundBaseActor != none) && bHidden != GroundBaseActor.bHidden)
	{
		GroundBaseActor.SetHidden(bHidden);
	}
	//return;	
}

function HaloWeapon_TargetDesignator.ETargetDesignatorCategory GetDeployableCategory()
{
	return DeployableCategory;
	//return ReturnValue;	
}

function SetDeployableCategory(HaloWeapon_TargetDesignator.ETargetDesignatorCategory newCategory)
{
	DeployableCategory = newCategory;
	//return;	
}

function name GetDeployableName()
{
	return DeployableName;
	//return ReturnValue;	
}

function SetDeployableName(name NewName)
{
	DeployableName = NewName;
	//return;	
}

function Actor GetDeployableBase()
{
	return DeployableBase;
	//return ReturnValue;	
}

function SetDeployableBase(Actor NewBase)
{
	DeployableBase = NewBase;
	//return;	
}

function Actor GetDeployable()
{
	return self;
	//return ReturnValue;	
}

function array< Class<HaloVCustomizationComponent> > GetCustomizations()
{
	local array< Class<HaloVCustomizationComponent> > returnArr;

	returnArr.Length = 0;
	return returnArr;
	//return ReturnValue;	
}

function SetCustomizations(array< Class<HaloVCustomizationComponent> > Customizations)
{
	//return;	
}

defaultproperties
{
	GroundBaseMesh=SkeletalMesh'ONI_Teleporter.Mesh.ONI_Teleporter'
	PreviewMesh=StaticMesh'Halo_Master_Chief.NS_Master_Chief_Hologram'
	PreviewSpinDegsPerSec=20.0000000
	PreviewMeshHeightOffset=70.0000000
	// Reference: StaticMeshComponent'MegaHaloGame.Default__HaloPersonnelPod.PreviewSMComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PreviewSMComponent'
	begin object name="PreviewSMComponent" class=Engine.StaticMeshComponent
		ReplacementPrimitive=none
		CastShadow=false
		bCastDynamicShadow=false
		CollideActors=false
		BlockActors=false
		BlockRigidBody=false
	end object
	PreviewMeshComponent=PreviewSMComponent
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloPersonnelPod.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	// Archetype: SkeletalMeshComponent'Engine.Default__SkeletalMeshActorSpawnable.SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0"
		// Reference: AnimNodeSequence'MegaHaloGame.Default__HaloPersonnelPod.SkeletalMeshComponent0.AnimNodeSeq0'
		// Archetype: AnimNodeSequence'Engine.Default__SkeletalMeshActorSpawnable.SkeletalMeshComponent0.AnimNodeSeq0'
		begin object name="AnimNodeSeq0"
		end object
		Animations=AnimNodeSeq0
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloPersonnelPod.MyLightEnvironment'
	end object
	SkeletalMeshComponent=SkeletalMeshComponent0
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloPersonnelPod.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'Engine.Default__SkeletalMeshActorSpawnable.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	// Reference: AudioComponent'MegaHaloGame.Default__HaloPersonnelPod.FaceAudioComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'FaceAudioComponent'
	// Archetype: AudioComponent'Engine.Default__SkeletalMeshActorSpawnable.FaceAudioComponent'
	begin object name="FaceAudioComponent"
	end object
	FacialAudioComp=FaceAudioComponent
	Components[0]=MyLightEnvironment
	Components[1]=SkeletalMeshComponent0
	Components[2]=FaceAudioComponent
	Components[3]=PreviewSMComponent
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloPersonnelPod.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	begin object name="CollisionCylinder" class=Engine.CylinderComponent
		CollisionHeight=70.0000000
		CollisionRadius=20.0000000
		ReplacementPrimitive=none
		CollideActors=true
		Translation=(X=35.0000000,Y=0.0000000,Z=0.0000000)
	end object
	Components[4]=CollisionCylinder
	CollisionType=ECollisionType.COLLIDE_TouchAll
	bCollideActors=true
	bProjTarget=false
	CollisionComponent=CollisionCylinder
}