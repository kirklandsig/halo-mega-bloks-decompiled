class HaloVehicleCustomizationPanel extends Trigger;

var SkeletalMesh RoomModel;
var SkeletalMesh CurrentVehicleModel;
var export editinline array<export editinline SkeletalMeshComponent> AttachedPreviewModels;
var float UndergroundOffset;
var Vector CameraOffset;
var float UICameraOffset;
var float CameraScale;
var bool bIsBeingLookedAt;
var bool bIsBeingActivated;
var SkeletalMeshActorSpawnable VehicleRoom;
var SkeletalMeshActorSpawnable VehiclePreview;
var Pawn MasterChiefModel;
var HaloConstructionMenuCamera myCamera;
var HaloPlayerPawnController PlayerController;
var HaloPlayerCamera playerCam;
var SkeletalMeshActorSpawnable VehicleBuildPad;
var HVCCInfo HVCCAddon_PreviewInfo;
var HVCCInfo HVCCSkin_PreviewInfo;
var SkeletalMeshActorSpawnable HVCCAddon_Preview;
var export editinline array<export editinline SkeletalMeshComponent> HVCCWheel_Previews;
var export editinline SkeletalMeshComponent BuildPadPreview;
var const localized string VehicleCustomizationInteractMessage;
var name ReturnState;
var float StoredDeltaTime;
var float cameraDefaultDeg;
var export editinline HaloBuildIndicatorComponent BuildIndicator;
var AkEvent ActivateSound;
var array<ExponentialHeightFog> GlobalFogVolumes;

simulated event PostBeginPlay()
{
	local ExponentialHeightFog theFog;

	VehicleBuildPad = Spawn(Class'Engine.SkeletalMeshActorSpawnable', self,, Location, Rotation);
	// End:0x3B0
	if(VehicleBuildPad != none)
	{
		BuildPadPreview.SetHidden(true);
		BuildPadPreview = none;
		VehicleBuildPad.SetCollision(true, true, true);
		VehicleBuildPad.SkeletalMeshComponent.SetSkeletalMesh(SkeletalMesh'UNSC_VehiclePad.Mesh.UNSC_VehiclePad');
		VehicleBuildPad.SkeletalMeshComponent.SetPhysicsAsset(PhysicsAsset'UNSC_VehiclePad.Mesh.UNSC_VehiclePad_Physics');
		VehicleBuildPad.SkeletalMeshComponent.SetRBChannel(0);
		VehicleBuildPad.SkeletalMeshComponent.SetActorCollision(true, true);
		VehicleBuildPad.SkeletalMeshComponent.SetTraceBlocking(true, true);
		VehicleBuildPad.SkeletalMeshComponent.SetHasPhysicsAssetInstance(true);
		VehicleBuildPad.SkeletalMeshComponent.bUpdateSkelWhenNotRendered = false;
		VehicleBuildPad.SkeletalMeshComponent.bTickAnimNodesWhenNotRendered = false;
		VehicleBuildPad.SkeletalMeshComponent.bIgnoreControllersWhenNotRendered = true;
		BuildIndicator.InitSystem();
		VehicleBuildPad.SkeletalMeshComponent.AttachComponentToSocket(BuildIndicator.StartParticleSystem, 'SignPos');
		VehicleBuildPad.SkeletalMeshComponent.AttachComponentToSocket(BuildIndicator.OnParticleSystem, 'SignPos');
		VehicleBuildPad.SkeletalMeshComponent.AttachComponentToSocket(BuildIndicator.StopParticleSystem, 'SignPos');
	}
	VehicleBuildPad.CollisionComponent = VehicleBuildPad.SkeletalMeshComponent;
	VehicleBuildPad.SetCollisionType(2);
	// End:0x455
	foreach AllActors(Class'Engine.ExponentialHeightFog', theFog)
	{
		// End:0x454
		if(theFog != none)
		{
			GlobalFogVolumes[GlobalFogVolumes.Length] = theFog;
		}		
	}	
	//return;	
}

function StartLookingAt(Controller Controller, Pawn Pawn)
{
	// End:0x5B
	if(HaloPawn(Pawn) != none)
	{
		LogInternal("HVCPanel Looked At");
		bIsBeingLookedAt = true;
		BuildIndicator.SetVisible(true);
	}
	//return;	
}

function StopLookingAt(Controller Controller, Pawn Pawn)
{
	bIsBeingLookedAt = false;
	BuildIndicator.SetVisible(false);
	//return;	
}

function StartActivation(Controller Controller, Pawn Pawn)
{
	local HaloGameDefault TheGame;

	TheGame = HaloGameDefault(WorldInfo.Game);
	// End:0x270
	if(((HaloPawn(Pawn) != none) && TheGame.TheCustomizationManager.IsActive()!) && TheGame.TheCustomizationManager.MagicMomentStack.Length == 0)
	{
		// End:0x270
		if(InUse()!)
		{
			LogInternal("HVCPanel Activated");
			bIsBeingActivated = true;
			// End:0x270
			if((HaloPlayerPawnController(Controller) != none) && ((HaloPlayerPawnController(Controller).DeployedVehicle == none) || HaloPlayerPawnController(Controller).DeployedVehicle.bHidden == false) || HaloPlayerPawnController(Controller).DeployedVehicle.Health <= 0)
			{
				PlayerController = HaloPlayerPawnController(Controller);
				// End:0x22C
				if(PlayerController != none)
				{
					PlayAkEvent(ActivateSound);
					PlayerController.GotoState('VehicleCustomizationBuildStateTransitionIn');					
				}
				else
				{
					LogInternal("Non-Playercontroller attempting to access a Vehicle build panel");
				}
			}
		}
	}
	//return;	
}

function FadeComplete()
{
	PlayerController.GotoState('VehicleBuilding');
	CreateVehicleRoom();
	PlayerController.OpenHVCMenu(self);
	GFxHaloHUD(PlayerController.myHUD).ToggleVCMenu();
	//return;	
}

function StopActivation(Controller Controller, Pawn Pawn)
{
	bIsBeingActivated = false;
	//return;	
}

function bool InUse()
{
	return PlayerController != none;
	//return ReturnValue;	
}

function CreateVehicleRoom()
{
	local Vector roomLoc, chiefLoc;
	local Rotator roomRot, chiefRot;
	local Class<Pawn> spartanClass;
	local int I;

	roomRot.Pitch = 0;
	roomRot.Yaw = 0;
	roomRot.Roll = 0;
	roomLoc = Location;
	roomLoc.Z -= UndergroundOffset;
	// End:0x551
	if(VehicleRoom == none)
	{
		VehicleRoom = Spawn(Class'Engine.SkeletalMeshActorSpawnable', self,, roomLoc, roomRot);
		// End:0x551
		if(VehicleRoom != none)
		{
			VehicleRoom.SkeletalMeshComponent.SetSkeletalMesh(RoomModel);
			// End:0x194
			if(VehiclePreview == none)
			{
				VehiclePreview = Spawn(Class'Engine.SkeletalMeshActorSpawnable', self,, VehicleRoom.SkeletalMeshComponent.GetBoneLocation('Bone_001', 0));
			}
			I = 0;
			J0x19F:

			// End:0x204 [Loop If]
			if(I < GlobalFogVolumes.Length)
			{
				GlobalFogVolumes[I].Component.SetEnabled(false);
				I++;
				// [Loop Continue]
				goto J0x19F;
			}
			// End:0x3CA
			if(myCamera == none)
			{
				myCamera = Spawn(Class'MegaHaloGame.HaloConstructionMenuCamera', self,, Location, Rotation);
				myCamera.HeightOffset = 1200.0000000;
				myCamera.DefaultDeg = cameraDefaultDeg;
				myCamera.XScale = CameraScale;
				myCamera.YScale = CameraScale;
				SwapCameras();
				myCamera.SetBounds(VehicleRoom.SkeletalMeshComponent.SkeletalMesh.Bounds, roomLoc, roomRot, VehicleRoom.SkeletalMeshComponent.SkeletalMesh.RotOrigin, PlayerController);
				FocusCamera(roomLoc);
			}
			// End:0x551
			if(MasterChiefModel == none)
			{
				VehicleRoom.SkeletalMeshComponent.GetSocketWorldLocationAndRotation('ChiefSocket', chiefLoc, chiefRot);
				spartanClass = ((PlayerController.PawnClass == none) ? PlayerController.Pawn.Class : PlayerController.PawnClass);
				MasterChiefModel = Spawn(spartanClass, self,, chiefLoc, chiefRot);
				MasterChiefModel.bIgnoreKillZ = true;
				MasterChiefModel.SetPhysics(4);
				HaloPawn(MasterChiefModel).PlayCustomAnimation('Master_Chief_Typing_2Hand',, true);
			}
		}
	}
	//return;	
}

function SwapCameras()
{
	// End:0x10C
	if(myCamera != none)
	{
		myCamera.InitializeFor(PlayerController);
		PlayerController.SetViewTarget(PlayerController.Pawn);
		myCamera.SetViewTarget(PlayerController.Pawn);
		playerCam = HaloPlayerCamera(PlayerController.PlayerCamera);
		PlayerController.PlayerCamera = myCamera;
	}
	//return;	
}

function DeactivatePanel()
{
	local GFxHaloHUD theHUD;
	local Vector Loc;
	local Rotator rota;
	local int I;

	theHUD = GFxHaloHUD(PlayerController.myHUD);
	theHUD.ToggleVCMenu();
	I = 0;
	J0x5B:

	// End:0xC0 [Loop If]
	if(I < GlobalFogVolumes.Length)
	{
		GlobalFogVolumes[I].Component.SetEnabled(true);
		I++;
		// [Loop Continue]
		goto J0x5B;
	}
	PlayerController.PlayerCamera = playerCam;
	PlayerController.GotoState(ReturnState);
	// End:0x301
	if(((HaloPawn(PlayerController.Pawn) != none) && PlayerController.DeployedVehicle != none) && PlayerController.DeployedVehicle.bHidden)
	{
		Loc = PlayerController.DeployedVehicle.Location;
		Loc.Z = PlayerController.Pawn.Location.Z;
		rota = Rotator(Loc - PlayerController.Pawn.Location);
		PlayerController.Pawn.SetRotation(rota);
		PlayerController.SetRotation(rota);
		PlayerController.CameraSetViewRotation(rota);
	}
	myCamera.Destroy();
	VehicleRoom.Destroy();
	VehiclePreview.Destroy();
	MasterChiefModel.Destroy();
	StopActivation(PlayerController, PlayerController.Pawn);
	ReturnState = 'None';
	MasterChiefModel = none;
	VehiclePreview = none;
	myCamera = none;
	VehicleRoom = none;
	PlayerController = none;
	//return;	
}

function SwapVehiclePreview(HVCCInfo VehicleInfo)
{
	local Vector PreviewPos;
	local Rotator PreviewRot;

	RemoveAllPreviewCustomizations();
	VehicleRoom.SkeletalMeshComponent.GetSocketWorldLocationAndRotation(VehicleInfo.PreviewSocketName, PreviewPos, PreviewRot);
	VehiclePreview.SkeletalMeshComponent.SetSkeletalMesh(VehicleInfo.PreviewMesh);
	VehiclePreview.SetLocation(PreviewPos);
	VehiclePreview.SetRotation(PreviewRot);
	//return;	
}

function AttachPreviewCustomization(HVCCInfo CustomizationInfo)
{
	// End:0x38
	if(CustomizationInfo.ClassToSpawn != none)
	{
		AttachPreviewCustomizationClass(CustomizationInfo);		
	}
	else
	{
		// End:0x9C
		if(CustomizationInfo.ArchetypeToSpawn != none)
		{
			AttachPreviewCustomizationArchetype(CustomizationInfo.ArchetypeToSpawn, CustomizationInfo.PreviewMesh);
		}
	}
	//return;	
}

function RemovePreviewCustomization(HVCCInfo CustomizationInfo)
{
	// End:0x4B
	if(CustomizationInfo.ClassToSpawn != none)
	{
		RemovePreviewCustomizationClass(CustomizationInfo.ClassToSpawn);		
	}
	else
	{
		// End:0x93
		if(CustomizationInfo.ArchetypeToSpawn != none)
		{
			RemovePreviewCustomizationArchetype(CustomizationInfo.ArchetypeToSpawn);
		}
	}
	//return;	
}

function AttachPreviewCustomizationClass(HVCCInfo CustomizationInfo)
{
	local Class<HVCCSkin> SkinClass;
	local Class<HaloVCustomizationComponent> HVCC_Class;

	HVCC_Class = CustomizationInfo.ClassToSpawn;
	// End:0x1EA
	if(ClassIsChildOf(HVCC_Class, Class'MegaHaloGame.HVCCAddon'))
	{
		// End:0x129
		if(HVCCAddon_Preview == none)
		{
			HVCCAddon_Preview = Spawn(Class'Engine.SkeletalMeshActorSpawnable', VehiclePreview,, VehiclePreview.SkeletalMeshComponent.GetBoneLocation(HVCC_Class.default.HVCParentBoneName, 0) + HVCC_Class.default.HVCAttachmentOffset, VehiclePreview.Rotation + HVCC_Class.default.HVCAttachmentRotation,, false);
		}
		// End:0x1E7
		if(HVCCAddon_Preview != none)
		{
			HVCCAddon_Preview.SkeletalMeshComponent.SetSkeletalMesh(CustomizationInfo.PreviewMesh);
			HVCCAddon_Preview.SetBase(VehiclePreview,, VehiclePreview.SkeletalMeshComponent, HVCC_Class.default.HVCParentBoneName);
		}		
	}
	else
	{
		// End:0x342
		if(ClassIsChildOf(HVCC_Class, Class'MegaHaloGame.HVCCSkin'))
		{
			SkinClass = Class<HVCCSkin>(HVCC_Class);
			// End:0x342
			if((((VehiclePreview != none) && VehiclePreview.SkeletalMeshComponent != none) && SkinClass.default.MeshElementIndex >= 0) && SkinClass.default.MeshElementIndex < VehiclePreview.SkeletalMeshComponent.GetNumElements())
			{
				VehiclePreview.SkeletalMeshComponent.SetMaterial(SkinClass.default.MeshElementIndex, SkinClass.default.SkinMaterial);
			}
		}
	}
	//return;	
}

function RemovePreviewCustomizationClass(Class<HaloVCustomizationComponent> HVCC_Class)
{
	local Class<HVCCSkin> SkinClass;

	// End:0x4D
	if(ClassIsChildOf(HVCC_Class, Class'MegaHaloGame.HVCCAddon'))
	{
		// End:0x4A
		if(HVCCAddon_Preview != none)
		{
			HVCCAddon_Preview.Destroy();
			HVCCAddon_Preview = none;
		}		
	}
	else
	{
		// End:0x109
		if(ClassIsChildOf(HVCC_Class, Class'MegaHaloGame.HVCCSkin'))
		{
			SkinClass = Class<HVCCSkin>(HVCC_Class);
			// End:0x109
			if((VehiclePreview != none) && VehiclePreview.SkeletalMeshComponent != none)
			{
				VehiclePreview.SkeletalMeshComponent.SetMaterial(SkinClass.default.MeshElementIndex, none);
			}
		}
	}
	//return;	
}

function AttachPreviewCustomizationArchetype(HaloVCustomizationComponent HVCC_Arhcetype, SkeletalMesh PreviewMesh)
{
	local HVCCSkin SkinArchetype;

	// End:0x1C6
	if(ClassIsChildOf(HVCC_Arhcetype.Class, Class'MegaHaloGame.HVCCAddon'))
	{
		// End:0x118
		if(HVCCAddon_Preview == none)
		{
			HVCCAddon_Preview = Spawn(Class'Engine.SkeletalMeshActorSpawnable', VehiclePreview,, VehiclePreview.SkeletalMeshComponent.GetBoneLocation(HVCC_Arhcetype.HVCParentBoneName, 0) + HVCC_Arhcetype.HVCAttachmentOffset, VehiclePreview.Rotation + HVCC_Arhcetype.HVCAttachmentRotation,, false);
		}
		// End:0x1C3
		if(HVCCAddon_Preview != none)
		{
			HVCCAddon_Preview.SkeletalMeshComponent.SetSkeletalMesh(PreviewMesh);
			HVCCAddon_Preview.SetBase(VehiclePreview,, VehiclePreview.SkeletalMeshComponent, HVCC_Arhcetype.HVCParentBoneName);
		}		
	}
	else
	{
		// End:0x333
		if(ClassIsChildOf(HVCC_Arhcetype.Class, Class'MegaHaloGame.HVCCSkin'))
		{
			SkinArchetype = HVCCSkin(HVCC_Arhcetype);
			// End:0x333
			if((((VehiclePreview != none) && VehiclePreview.SkeletalMeshComponent != none) && SkinArchetype.MeshElementIndex >= 0) && SkinArchetype.MeshElementIndex < VehiclePreview.SkeletalMeshComponent.GetNumElements())
			{
				VehiclePreview.SkeletalMeshComponent.SetMaterial(SkinArchetype.MeshElementIndex, SkinArchetype.SkinMaterial);
			}
		}
	}
	//return;	
}

function RemovePreviewCustomizationArchetype(HaloVCustomizationComponent HVCC_Arhcetype)
{
	local HVCCSkin SkinArchetype;

	// End:0x62
	if(ClassIsChildOf(HVCC_Arhcetype.Class, Class'MegaHaloGame.HVCCAddon'))
	{
		// End:0x5F
		if(HVCCAddon_Preview != none)
		{
			HVCCAddon_Preview.Destroy();
			HVCCAddon_Preview = none;
		}		
	}
	else
	{
		// End:0x133
		if(ClassIsChildOf(HVCC_Arhcetype.Class, Class'MegaHaloGame.HVCCSkin'))
		{
			SkinArchetype = HVCCSkin(HVCC_Arhcetype);
			// End:0x133
			if((VehiclePreview != none) && VehiclePreview.SkeletalMeshComponent != none)
			{
				VehiclePreview.SkeletalMeshComponent.SetMaterial(SkinArchetype.MeshElementIndex, none);
			}
		}
	}
	//return;	
}

function RemoveAllPreviewCustomizations()
{
	HVCCAddon_Preview.Destroy();
	HVCCAddon_Preview = none;
	//return;	
}

function NotifyTriggered()
{
	LogInternal("HVCPanel Triggered");
	bRecentlyTriggered = true;
	SetTimer(AITriggerDelay, false, 'UnTrigger');
	//return;	
}

function RotateMeshRight()
{
	// End:0x3E
	if(myCamera != none)
	{
		myCamera.UpdatePosition(-70.0000000 * StoredDeltaTime);
	}
	//return;	
}

function RotateMeshLeft()
{
	// End:0x3E
	if(myCamera != none)
	{
		myCamera.UpdatePosition(70.0000000 * StoredDeltaTime);
	}
	//return;	
}

function FocusCamera(Vector pos)
{
	// End:0x3A
	if(myCamera != none)
	{
		myCamera.UpdateFocusPos(pos);
	}
	//return;	
}

defaultproperties
{
	RoomModel=SkeletalMesh'Halo_Construction.Vehicle_Build_Pad_Room'
	UndergroundOffset=50000.0000000
	CameraOffset=(X=1600.0000000,Y=-600.0000000,Z=-700.0000000)
	UICameraOffset=-550.0000000
	CameraScale=0.0250000
	HVCCAddon_PreviewInfo=(Name="None",Unlocked=true,IconPkgPath="",PreviewMesh=none,PreviewSocketName="None",TargetVehicleClassName="",TargetVehicleClass=none,MagicMomentEventName="None",UnlockRemoteEventName="None",ArchetypeToSpawn=none,ClassToSpawnName="",ClassToSpawn=none,DefaultAddonIdx=255,DefaultWheelSetIdx=255,DefaultWeaponIdx=255,DefaultSkinIdx=0,DefaultDecalIdx=255)
	HVCCSkin_PreviewInfo=(Name="None",Unlocked=true,IconPkgPath="",PreviewMesh=none,PreviewSocketName="None",TargetVehicleClassName="",TargetVehicleClass=none,MagicMomentEventName="None",UnlockRemoteEventName="None",ArchetypeToSpawn=none,ClassToSpawnName="",ClassToSpawn=none,DefaultAddonIdx=255,DefaultWheelSetIdx=255,DefaultWeaponIdx=255,DefaultSkinIdx=0,DefaultDecalIdx=255)
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloVehicleCustomizationPanel.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0" class=Engine.SkeletalMeshComponent
		SkeletalMesh=SkeletalMesh'UNSC_VehiclePad.Mesh.UNSC_VehiclePad'
		ReplacementPrimitive=none
	end object
	BuildPadPreview=SkeletalMeshComponent0
	VehicleCustomizationInteractMessage="Press [MainHUD.InlineInputIcons.inputIcon_y] To Open Vehicle Customization"
	cameraDefaultDeg=15.0000000
	// Reference: HaloBuildIndicatorComponent'MegaHaloGame.Default__HaloVehicleCustomizationPanel.HaloBuildIndicatorComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'HaloBuildIndicatorComponent0'
	begin object name="HaloBuildIndicatorComponent0" class=MegaHaloGame.HaloBuildIndicatorComponent
		// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloVehicleCustomizationPanel.HaloBuildIndicatorComponent0.ParticleSystemComponent0'
		// TemplateOwnerClass: none
		// TemplateOwnerName: 'ParticleSystemComponent0'
		// Archetype: ParticleSystemComponent'MegaHaloGame.Default__HaloBuildIndicatorComponent.ParticleSystemComponent0'
		begin object name="ParticleSystemComponent0"
			ReplacementPrimitive=none
		end object
		StartParticleSystem=ParticleSystemComponent0
		// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloVehicleCustomizationPanel.HaloBuildIndicatorComponent0.ParticleSystemComponent1'
		// TemplateOwnerClass: none
		// TemplateOwnerName: 'ParticleSystemComponent1'
		// Archetype: ParticleSystemComponent'MegaHaloGame.Default__HaloBuildIndicatorComponent.ParticleSystemComponent1'
		begin object name="ParticleSystemComponent1"
			ReplacementPrimitive=none
		end object
		OnParticleSystem=ParticleSystemComponent1
		// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloVehicleCustomizationPanel.HaloBuildIndicatorComponent0.ParticleSystemComponent2'
		// TemplateOwnerClass: none
		// TemplateOwnerName: 'ParticleSystemComponent2'
		// Archetype: ParticleSystemComponent'MegaHaloGame.Default__HaloBuildIndicatorComponent.ParticleSystemComponent2'
		begin object name="ParticleSystemComponent2"
			ReplacementPrimitive=none
		end object
		StopParticleSystem=ParticleSystemComponent2
		IconTexture=Texture2D'BuildPadIndicator.Textures.BuildPadIcon_VehicleCustomization'
	end object
	BuildIndicator=HaloBuildIndicatorComponent0
	ActivateSound=AkEvent'Global.Play_UI_Construction_Enter'
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloVehicleCustomizationPanel.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__Trigger.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=144.6999969
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	// Reference: SpriteComponent'MegaHaloGame.Default__HaloVehicleCustomizationPanel.Sprite'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'Sprite'
	// Archetype: SpriteComponent'Engine.Default__Trigger.Sprite'
	begin object name="Sprite"
		ReplacementPrimitive=none
	end object
	Components[0]=Sprite
	Components[1]=CollisionCylinder
	Components[2]=SkeletalMeshComponent0
	Components[3]=HaloBuildIndicatorComponent0
	bHidden=false
	bEdShouldSnap=true
	CollisionComponent=CollisionCylinder
}