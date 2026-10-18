class HaloConstructionBuildPadTrigger extends Trigger;

var export editinline HaloBuildIndicatorComponent BuildIndicator;
var private SkeletalMesh RoomModel;
var private export editinline SkeletalMeshComponent TriggerObj;
var private HaloConstructionBuildPad BuildPadObj;
var private array<BuildableRecipe> BuildableList;
var private BuildableRecipe CurrentBuildable;
var private HaloConstructionManager CManager;
var private array<Actor> HighlightableActors;
var private float ActivationRange;
var private float ActivationRangeSq;
var float ConstructionCompleteDelay;
var bool bIsBeingLookedAt;
var bool bIsBeingActivated;
var bool bIsInBuildMode;
var bool bIsComplete;
var bool bCameraFinishedInTransition;
var float ActivationPctProgress;
var float StoredDeltaTime;
var array<HaloPlayerPawnController> Viewers;
var HaloPlayerPawnController HPPCActivator;
var AkEvent ActivateSound;
var AkEvent DeactivateSound;
var AkEvent TouchSoundValid;
var AkEvent TouchSoundInvalid;
var const localized string InteractMessageActive;
var const localized string InteractMessageInactive;
var const localized string InteractMessageComplete;
var const localized string TypeMessageFootbridge;
var const localized string TypeMessageVehiclebridge;
var const localized string TypeMessageElevator;
var const localized string TypeMessageFRPowerSupply;
var const localized string TypeMessageFRTerminal;
var const localized string TypeMessageCoveredBridge;
var const localized string TypeMessageVehicleBay;
var const localized string TypeMessageManCannon;
var const localized string TypeMessageFortification;
var const localized string TypeMessageTerminal;
var float UndergroundOffset;
var private SkeletalMeshActorSpawnable ConstructionRoom;
var HaloConstructionMenuCamera ConstructionCamera;
var HaloPlayerCamera StoredPlayerCam;
var Vector ConstructionLocation;
var Rotator ConstructionRotation;
var float DefaultCameraDegree;
var Vector ConstructionLightDir;
var HaloConstructionLight ConstructionLightActor;

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	local HaloConstructionManager.EHaloConstructionTypes Type;
	local HaloPlayerPawnController HPPC;
	local HaloPawn HP;
	local int I;

	// End:0x12
	if((CanBeActivated()) == false)
	{
		return;
	}
	HP = HaloPawn(Other);
	// End:0x88
	if((HP != none) && CManager != none)
	{
		HPPC = HaloPlayerPawnController(HaloPawn(Other).Controller);
	}
	// End:0x403
	if(((CManager != none) && HPPC != none) && BuildPadObj != none)
	{
		Viewers.AddItem(HPPC);
		CManager.SetViewableBuildPadTrigger(self);
		I = 0;
		J0xFA:

		// End:0x2C0 [Loop If]
		if(I < BuildableList.Length)
		{
			CurrentBuildable = BuildableList[I];
			Type = CurrentBuildable.Type;
			// End:0x2B2
			if(CManager.IsBlueprintUnlockedFromType(Type))
			{
				CurrentBuildable.CObject = CManager.GetHaloConstructionObjectFromType(Type);
				// End:0x288
				if(CurrentBuildable.CObject != none)
				{
					CurrentBuildable.CObject.PositionDetailedMesh(BuildPadObj.Location, BuildPadObj.Rotation);
					CurrentBuildable.CObject.ShowDetailedHologramMesh(true);
				}
				// End:0x2B0
				if(TouchSoundValid != none)
				{
					PlayAkEvent(TouchSoundValid);
				}
				return;
			}
			I++;
			// [Loop Continue]
			goto J0xFA;
		}
		I = 0;
		J0x2CB:

		// End:0x403 [Loop If]
		if(I < BuildableList.Length)
		{
			Type = BuildableList[I].Type;
			// End:0x3F5
			if(CManager.IsBlueprintLockedFromType(Type))
			{
				CManager.PositionGlitchMesh(Type, BuildPadObj.Location, BuildPadObj.Rotation);
				CManager.ShowGlitchMesh(Type, true);
				// End:0x3F3
				if(TouchSoundInvalid != none)
				{
					PlayAkEvent(TouchSoundInvalid);
				}
				return;
			}
			I++;
			// [Loop Continue]
			goto J0x2CB;
		}
	}
	//return;	
}

simulated event UnTouch(Actor Other)
{
	local HaloConstructionManager.EHaloConstructionTypes Type;
	local HaloPawn HP;
	local HaloPlayerPawnController HPPC;
	local int I;

	HP = HaloPawn(Other);
	// End:0x5C
	if(HP != none)
	{
		HPPC = HaloPlayerPawnController(HP.Controller);
	}
	// End:0x15B
	if((CManager != none) && HPPC != none)
	{
		I = 0;
		J0x87:

		// End:0x105 [Loop If]
		if(I < BuildableList.Length)
		{
			Type = BuildableList[I].Type;
			CManager.HideAllMeshes(Type);
			I++;
			// [Loop Continue]
			goto J0x87;
		}
		HPPC.ActiveConstructionTrigger = none;
		HPPC.InactiveConstructionTrigger = none;
		Viewers.RemoveItem(HPPC);
	}
	//return;	
}

simulated event OnControllerDeath(HaloPlayerPawnController HPPC)
{
	Viewers.RemoveItem(HPPC);
	CManager.SetViewableBuildPadTrigger(none);
	//return;	
}

event Tick(float DeltaTime)
{
	local HaloPlayerPawnController HPPC;
	local float DistSq;
	local bool bShow;

	StoredDeltaTime = DeltaTime;
	bShow = false;
	// End:0x1AB
	foreach Viewers(HPPC)
	{
		DistSq = VSizeSq(Location - HPPC.Pawn.Location);
		// End:0x16A
		if(DistSq <= ActivationRangeSq)
		{
			// End:0x11B
			if(CManager.IsBlueprintUnlockedFromType(CurrentBuildable.Type) == true)
			{
				HPPC.ActiveConstructionTrigger = self;
				HPPC.InactiveConstructionTrigger = none;				
			}
			else
			{
				HPPC.ActiveConstructionTrigger = none;
				HPPC.InactiveConstructionTrigger = self;
			}
			bShow = true;			
		}
		else
		{
			HPPC.ActiveConstructionTrigger = none;
			HPPC.InactiveConstructionTrigger = none;
		}		
	}	
	BuildIndicator.SetVisible(bShow);
	// End:0x27D
	if((bCameraFinishedInTransition == false) && ConstructionCamera != none)
	{
		// End:0x27D
		if((ConstructionCamera.IsMoveable() == true) && CurrentBuildable.CObject != none)
		{
			CurrentBuildable.CObject.ConstructionStart();
			bCameraFinishedInTransition = true;
		}
	}
	//return;	
}

simulated event PostBeginPlay()
{
	local HaloConstructionUIPrimitive CPrim;
	local int I;

	CManager = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).GetConstructionManager();
	// End:0xA22
	if(CManager != none)
	{
		I = 0;
		J0x77:

		// End:0xA22 [Loop If]
		if(I < BuildableList.Length)
		{
			// End:0xA14
			if(CManager.AddConstructionType(BuildableList[I], self) == true)
			{
				// End:0x21C
				if(BuildableList[I].PrimitiveInventory.Panels > 0)
				{
					CPrim.Type = 0;
					CPrim.IconPkgPath = CManager.ConstructionPrimitiveInfoArray[int(CPrim.Type)].IconPkgPath;
					CPrim.Count = BuildableList[I].PrimitiveInventory.Panels;
					BuildableList[I].ConstructionUIPrimitives.AddItem(CPrim);
				}
				// End:0x370
				if(BuildableList[I].PrimitiveInventory.Beams > 0)
				{
					CPrim.Type = 1;
					CPrim.IconPkgPath = CManager.ConstructionPrimitiveInfoArray[int(CPrim.Type)].IconPkgPath;
					CPrim.Count = BuildableList[I].PrimitiveInventory.Beams;
					BuildableList[I].ConstructionUIPrimitives.AddItem(CPrim);
				}
				// End:0x4C4
				if(BuildableList[I].PrimitiveInventory.Pyramids > 0)
				{
					CPrim.Type = 2;
					CPrim.IconPkgPath = CManager.ConstructionPrimitiveInfoArray[int(CPrim.Type)].IconPkgPath;
					CPrim.Count = BuildableList[I].PrimitiveInventory.Pyramids;
					BuildableList[I].ConstructionUIPrimitives.AddItem(CPrim);
				}
				// End:0x618
				if(BuildableList[I].PrimitiveInventory.Cylinders > 0)
				{
					CPrim.Type = 3;
					CPrim.IconPkgPath = CManager.ConstructionPrimitiveInfoArray[int(CPrim.Type)].IconPkgPath;
					CPrim.Count = BuildableList[I].PrimitiveInventory.Cylinders;
					BuildableList[I].ConstructionUIPrimitives.AddItem(CPrim);
				}
				// End:0x76C
				if(BuildableList[I].PrimitiveInventory.Wedges > 0)
				{
					CPrim.Type = 4;
					CPrim.IconPkgPath = CManager.ConstructionPrimitiveInfoArray[int(CPrim.Type)].IconPkgPath;
					CPrim.Count = BuildableList[I].PrimitiveInventory.Wedges;
					BuildableList[I].ConstructionUIPrimitives.AddItem(CPrim);
				}
				// End:0x8C0
				if(BuildableList[I].PrimitiveInventory.Wheels > 0)
				{
					CPrim.Type = 5;
					CPrim.IconPkgPath = CManager.ConstructionPrimitiveInfoArray[int(CPrim.Type)].IconPkgPath;
					CPrim.Count = BuildableList[I].PrimitiveInventory.Wheels;
					BuildableList[I].ConstructionUIPrimitives.AddItem(CPrim);
				}
				// End:0xA14
				if(BuildableList[I].PrimitiveInventory.Pentagons > 0)
				{
					CPrim.Type = 6;
					CPrim.IconPkgPath = CManager.ConstructionPrimitiveInfoArray[int(CPrim.Type)].IconPkgPath;
					CPrim.Count = BuildableList[I].PrimitiveInventory.Pentagons;
					BuildableList[I].ConstructionUIPrimitives.AddItem(CPrim);
				}
			}
			I++;
			// [Loop Continue]
			goto J0x77;
		}
	}
	ActivationRangeSq = Square(ActivationRange);
	ConstructionLightActor = Spawn(Class'MegaHaloGame.HaloConstructionLight', self,, Location,,, true);
	ConstructionLightActor.LightingComponent.SetEnabled(false);
	ConstructionLightActor.SetDirection(ConstructionLightDir);
	//return;	
}

event Destroyed()
{
	// End:0x32
	if(ConstructionLightActor != none)
	{
		ConstructionLightActor.Destroy();
		ConstructionLightActor = none;
	}
	//return;	
}

function bool CurrentConstructionUnlocked()
{
	// End:0x4B
	if(CManager != none)
	{
		return CManager.IsBlueprintUnlockedFromType(CurrentBuildable.Type);
	}
	return false;
	//return ReturnValue;	
}

function StartLookingAt(Controller Controller, Pawn Pawn)
{
	bIsBeingLookedAt = true;
	ActivationPctProgress = 0.0000000;
	//return;	
}

function StopLookingAt(Controller Controller, Pawn Pawn)
{
	bIsBeingLookedAt = false;
	ActivationPctProgress = 0.0000000;
	//return;	
}

function StartActivation(Controller Controller, Pawn Pawn)
{
	bIsBeingActivated = true;
	//return;	
}

function StopActivation(Controller Controller, Pawn Pawn)
{
	bIsBeingActivated = false;
	//return;	
}

function EnterBuildMode(HaloPlayerPawnController HPPC)
{
	// End:0x35C
	if((CurrentBuildable.CObject != none) && CManager != none)
	{
		HPPCActivator = HPPC;
		CreateConstructionRoom();
		CreateConstructionCamera();
		bIsInBuildMode = true;
		bCameraFinishedInTransition = false;
		CManager.SetCurrentBuildPadTrigger(self);
		// End:0x35C
		if((ConstructionRoom != none) && ConstructionCamera != none)
		{
			CurrentBuildable.CObject.PositionPrimitiveMesh(ConstructionLocation, ConstructionRotation);
			CurrentBuildable.CurrentUIPrimitiveIndex = 0;
			CurrentBuildable.CObject.InitSocketPrimitives();
			ConstructionCamera.SetBounds(CurrentBuildable.CObject.GetPrimitiveMeshBounds(), ConstructionLocation, ConstructionRotation, CurrentBuildable.CObject.GetPrimitiveMeshOriginRotation(), HPPCActivator);
			CManager.FocusConstructionCamera(CurrentBuildable.CObject.GetSelectedPrimitiveLocation());
			CurrentBuildable.CObject.ShowPrimitiveMesh(false);
			CurrentBuildable.CObject.PositionDetailedMesh(ConstructionLocation, ConstructionRotation);
			CurrentBuildable.CObject.ShowDetailedPrimitiveClearMesh(true);
			CurrentBuildable.CObject.ConstructionLightEnvironment.SetEnabled(true);
			ConstructionLightActor.LightingComponent.SetEnabled(true);
		}
	}
	//return;	
}

function ExitBuildMode()
{
	local int I;
	local Actor highlightActor;
	local editinline MeshComponent highlightMeshComp;
	local MaterialInstanceConstant highlightMaterial;

	// End:0x47A
	if((CurrentBuildable.CObject != none) && BuildPadObj != none)
	{
		PlayAkEvent(DeactivateSound);
		// End:0x260
		if(bIsComplete)
		{
			CurrentBuildable.CObject.ForceHideAllMeshes();
			// End:0xD8
			if(Viewers.Length > 0)
			{
				TriggerEventClass(Class'Engine.SeqEvent_Used', Viewers[0].Pawn, -1);				
			}
			else
			{
				WarnInternal("Exited Build Mode with no viewers.  Cannot trigger used event.");
			}
			Viewers.Length = 0;
			CManager.SetViewableBuildPadTrigger(none);
			// End:0x25C
			foreach HighlightableActors(highlightActor)
			{
				highlightMeshComp = MeshComponent(highlightActor.GetComponentOfType(Class'Engine.MeshComponent'));
				// End:0x25B
				if(highlightMeshComp != none)
				{
					I = 0;
					J0x1B2:

					// End:0x25B [Loop If]
					if(I < highlightMeshComp.GetNumElements())
					{
						highlightMaterial = highlightMeshComp.CreateAndSetMaterialInstanceConstant(I);
						// End:0x24D
						if(highlightMaterial != none)
						{
							highlightMaterial.SetScalarParameterValue('GlintIntensity', 0.0000000);
						}
						I++;
						// [Loop Continue]
						goto J0x1B2;
					}
				}				
			}						
		}
		else
		{
			CurrentBuildable.CObject.HideAllMeshes();
			GFxHaloHUD(HPPCActivator.myHUD).BCMovie.PlayMenuSound("back");
			CurrentBuildable.CObject.PositionDetailedMesh(BuildPadObj.Location, BuildPadObj.Rotation);
			CurrentBuildable.CObject.ShowDetailedHologramMesh(true);
			ResetCurrentBuildable();
		}
		bIsInBuildMode = false;
		CManager.SetCurrentBuildPadTrigger(none);
		DestroyConstructionRoom();
		CurrentBuildable.CObject.DestroySocketPrimitives();
		CurrentBuildable.CObject.ConstructionLightEnvironment.SetEnabled(false);
		ConstructionLightActor.LightingComponent.SetEnabled(false);
	}
	//return;	
}

function SelectNextConstructionPrimitive()
{
	local Vector camFocus;

	// End:0x101
	if((CurrentBuildable.CObject != none) && ConstructionCamera != none)
	{
		// End:0x101
		if(ConstructionCamera.IsMoveable() == true)
		{
			// End:0x101
			if(CurrentBuildable.CObject.IncrementSocketPrimitive(camFocus))
			{
				FocusConstructionCamera(camFocus);
				GFxHaloHUD(HPPCActivator.myHUD).BCMovie.PlayMenuSound("left");
			}
		}
	}
	//return;	
}

function SelectPreviousConstructionPrimitive()
{
	local Vector camFocus;

	// End:0x102
	if((CurrentBuildable.CObject != none) && ConstructionCamera != none)
	{
		// End:0x102
		if(ConstructionCamera.IsMoveable() == true)
		{
			// End:0x102
			if(CurrentBuildable.CObject.DecrementSocketPrimitive(camFocus))
			{
				FocusConstructionCamera(camFocus);
				GFxHaloHUD(HPPCActivator.myHUD).BCMovie.PlayMenuSound("right");
			}
		}
	}
	//return;	
}

function bool AddPrimitive(HaloConstructionManager.EHaloConstructionPrimitiveTypes Type)
{
	// End:0x3BC
	if((CurrentBuildable.CObject != none) && CManager != none)
	{
		// End:0x2E8
		if(CurrentBuildable.CObject.AddSocketPrimitive(Type))
		{
			// End:0x81
			if(ContainsEmptyPrimitives())
			{				
			}
			else
			{
				bIsComplete = true;
				// End:0xDB
				if(CurrentBuildable.CompletedSound != none)
				{
					PlayAkEvent(CurrentBuildable.CompletedSound);
				}
			}
			CurrentBuildable.ConstructionUIPrimitives[CurrentBuildable.CurrentUIPrimitiveIndex].Count--;
			// End:0x212
			if(CurrentBuildable.ConstructionUIPrimitives[CurrentBuildable.CurrentUIPrimitiveIndex].Count <= 0)
			{
				CurrentBuildable.ConstructionUIPrimitives.Remove(CurrentBuildable.CurrentUIPrimitiveIndex, 1);
				CurrentBuildable.CurrentUIPrimitiveIndex = Clamp(CurrentBuildable.CurrentUIPrimitiveIndex, 0, CurrentBuildable.ConstructionUIPrimitives.Length - 1);
			}
			// End:0x2E6
			if(((HPPCActivator != none) && GFxHaloHUD(HPPCActivator.myHUD) != none) && GFxHaloHUD(HPPCActivator.myHUD).BCMovie != none)
			{
				GFxHaloHUD(HPPCActivator.myHUD).BCMovie.PlacementSuccess();
			}
			return true;
		}
		// End:0x3BC
		if(((HPPCActivator != none) && GFxHaloHUD(HPPCActivator.myHUD) != none) && GFxHaloHUD(HPPCActivator.myHUD).BCMovie != none)
		{
			GFxHaloHUD(HPPCActivator.myHUD).BCMovie.PlacementError();
		}
	}
	return false;
	//return ReturnValue;	
}

function bool ContainsEmptyPrimitives()
{
	// End:0x55
	if(CurrentBuildable.CObject != none)
	{
		return CurrentBuildable.CObject.ContainsEmptySocketPrimitives();
	}
	return false;
	//return ReturnValue;	
}

function BuildConstructionObject()
{
	// End:0x60
	if(CurrentBuildable.CObject != none)
	{
		CurrentBuildable.CObject.BuildConstructionObject();
		bIsComplete = true;
	}
	//return;	
}

function Actor GetConstructionBuildTarget()
{
	// End:0x19
	if(BuildPadObj != none)
	{
		return BuildPadObj;
	}
	return self;
	//return ReturnValue;	
}

function Vector GetConstructionBuildTargetLocation()
{
	// End:0x2E
	if(BuildPadObj != none)
	{
		return BuildPadObj.Location;
	}
	//return ReturnValue;	
}

function Rotator GetConstructionBuildTargetRotation()
{
	// End:0x2E
	if(BuildPadObj != none)
	{
		return BuildPadObj.Rotation;
	}
	//return ReturnValue;	
}

function CreateConstructionRoom()
{
	local Vector roomLoc;
	local Rotator roomRot;

	roomLoc = GetConstructionBuildTargetLocation();
	roomLoc.Z -= UndergroundOffset;
	roomRot = GetConstructionBuildTargetRotation();
	// End:0x92
	if(ConstructionRoom == none)
	{
		ConstructionRoom = Spawn(Class'Engine.SkeletalMeshActorSpawnable', self,, roomLoc, roomRot);
	}
	// End:0x29F
	if(ConstructionRoom != none)
	{
		ConstructionLocation = ConstructionRoom.Location;
		ConstructionRotation = ConstructionRoom.Rotation;
		ConstructionRoom.SkeletalMeshComponent.SetSkeletalMesh(RoomModel);
		ConstructionRoom.SkeletalMeshComponent.GetSocketWorldLocationAndRotation('ConstructionRoomSocket', ConstructionLocation, ConstructionRotation);
		ConstructionRoom.SkeletalMeshComponent.SetLightingChannels(CurrentBuildable.CObject.NewLightingChannels);
		ConstructionRoom.SkeletalMeshComponent.SetLightEnvironment(CurrentBuildable.CObject.ConstructionLightEnvironment);
		// End:0x29F
		if(CurrentBuildable.CObject != none)
		{
			CurrentBuildable.CObject.SetLocation(ConstructionLocation);
		}
	}
	//return;	
}

function CreateConstructionCamera()
{
	local Vector CamLoc;
	local Rotator CamRot;
	local Vector2D camScale;
	local Vector CamOffset;

	// End:0x43
	if(ConstructionCamera == none)
	{
		ConstructionCamera = Spawn(Class'MegaHaloGame.HaloConstructionMenuCamera', self,, ConstructionLocation, ConstructionRotation);
	}
	// End:0x304
	if((ConstructionCamera != none) && HPPCActivator != none)
	{
		ConstructionCamera.InitializeFor(HPPCActivator);
		CManager.GetConstructionCameraScaleFromType(CurrentBuildable.Type, camScale);
		ConstructionCamera.XScale = camScale.X;
		ConstructionCamera.YScale = camScale.Y;
		ConstructionCamera.bLocked = true;
		ConstructionCamera.bUseStartLocation = true;
		HPPCActivator.PlayerCamera.GetCameraViewPoint(CamLoc, CamRot);
		CamOffset = CamLoc - BuildPadObj.Location;
		ConstructionCamera.StartLocation = ConstructionLocation + CamOffset;
		ConstructionCamera.StartRotation = CamRot;
		ConstructionCamera.DefaultDeg = DefaultCameraDegree;
		ConstructionCamera.ActivateSound = ActivateSound;
		StoredPlayerCam = HaloPlayerCamera(HPPCActivator.PlayerCamera);
		HPPCActivator.PlayerCamera = ConstructionCamera;
	}
	//return;	
}

function UnlockConstructionCamera()
{
	// End:0x2E
	if(ConstructionCamera != none)
	{
		ConstructionCamera.CalculateAndInterpToNearestStartDegree();
	}
	//return;	
}

function bool IsConstructionCameraLocked()
{
	// End:0x2F
	if(ConstructionCamera != none)
	{
		return ConstructionCamera.bLocked;
	}
	//return ReturnValue;	
}

function DestroyConstructionRoom()
{
	HPPCActivator.PlayerCamera = StoredPlayerCam;
	ConstructionCamera.Destroy();
	ConstructionRoom.Destroy();
	ConstructionCamera = none;
	StoredPlayerCam = none;
	ConstructionRoom = none;
	HPPCActivator = none;
	//return;	
}

function ResetCurrentBuildable()
{
	local HaloConstructionManager.EHaloConstructionTypes Type;
	local int I;

	I = 0;
	J0x0B:

	// End:0x141 [Loop If]
	if(I < BuildableList.Length)
	{
		CurrentBuildable = BuildableList[I];
		Type = CurrentBuildable.Type;
		// End:0x133
		if(CManager.IsBlueprintUnlockedFromType(Type))
		{
			CurrentBuildable.CObject = CManager.GetHaloConstructionObjectFromType(Type);
			CurrentBuildable.CObject.ShowDetailedHologramMesh(true);
			// End:0x131
			if(TouchSoundValid != none)
			{
				PlayAkEvent(TouchSoundValid);
			}
			return;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	I = 0;
	J0x14C:

	// End:0x220 [Loop If]
	if(I < BuildableList.Length)
	{
		Type = BuildableList[I].Type;
		// End:0x212
		if(CManager.IsBlueprintLockedFromType(Type))
		{
			CManager.ShowGlitchMesh(Type, true);
			// End:0x210
			if(TouchSoundInvalid != none)
			{
				PlayAkEvent(TouchSoundInvalid);
			}
			return;
		}
		I++;
		// [Loop Continue]
		goto J0x14C;
	}
	//return;	
}

function GetBuildPadLocationRotation(out Vector padLocation, out Rotator padRotation)
{
	// End:0x5F
	if(BuildPadObj != none)
	{
		padLocation = BuildPadObj.Location;
		padRotation = BuildPadObj.Rotation;
	}
	//return;	
}

function HaloConstructionManager.EHaloConstructionTypes GetCurrentBuildType()
{
	return CurrentBuildable.Type;
	//return ReturnValue;	
}

function int GetTotalPrimitives()
{
	// End:0x55
	if(CurrentBuildable.CObject != none)
	{
		return CurrentBuildable.CObject.GetTotalSocketPrimitives();
	}
	return 0;
	//return ReturnValue;	
}

function int GetUsedPrimitives()
{
	// End:0x55
	if(CurrentBuildable.CObject != none)
	{
		return CurrentBuildable.CObject.GetUsedSocketPrimitives();
	}
	//return ReturnValue;	
}

function string GetBuildName()
{
	return ((CurrentBuildable.NameId == "NO NAME ID") ? "" : Localize("HaloConstructionBuildPadTrigger", CurrentBuildable.NameId, "MegaHaloGame"));
	//return ReturnValue;	
}

function bool GetPrimitiveAlreadyPlaced()
{
	// End:0x55
	if(CurrentBuildable.CObject != none)
	{
		return CurrentBuildable.CObject.GetCurrentSocketPrimitiveAlreadyPlaced();
	}
	//return ReturnValue;	
}

function array<HaloConstructionUIPrimitive> GetConstructionUIPrimitives()
{
	return CurrentBuildable.ConstructionUIPrimitives;
	//return ReturnValue;	
}

function int GetConstructionUIPrimitivesIndex()
{
	return CurrentBuildable.CurrentUIPrimitiveIndex;
	//return ReturnValue;	
}

function int GetConstructionCost()
{
	// End:0x4B
	if(CManager != none)
	{
		return CManager.GetConstructionCostFromType(CurrentBuildable.Type);
	}
	return 0;
	//return ReturnValue;	
}

function bool CanBeActivated()
{
	return (bIsInBuildMode == false) && bIsComplete == false;
	//return ReturnValue;	
}

function IncrementPrimitiveSelection()
{
	CurrentBuildable.CurrentUIPrimitiveIndex++;
	// End:0x7A
	if(CurrentBuildable.CurrentUIPrimitiveIndex >= CurrentBuildable.ConstructionUIPrimitives.Length)
	{
		CurrentBuildable.CurrentUIPrimitiveIndex = 0;
	}
	GFxHaloHUD(HPPCActivator.myHUD).BCMovie.PlayMenuSound("right");
	//return;	
}

function DecrementPrimitiveSelection()
{
	CurrentBuildable.CurrentUIPrimitiveIndex--;
	// End:0x7D
	if(CurrentBuildable.CurrentUIPrimitiveIndex < 0)
	{
		CurrentBuildable.CurrentUIPrimitiveIndex = CurrentBuildable.ConstructionUIPrimitives.Length - 1;
	}
	GFxHaloHUD(HPPCActivator.myHUD).BCMovie.PlayMenuSound("left");
	//return;	
}

function float GetActivatorBuildTriggerDistanceRatio()
{
	local float distRatio, tempRatio;
	local int I;

	distRatio = 1.0000000;
	// End:0x19F
	if(((Viewers.Length != 0) && CylinderComponent != none) && CylinderComponent.CollisionRadius != 0.0000000)
	{
		I = 0;
		J0x65:

		// End:0x19C [Loop If]
		if(I < Viewers.Length)
		{
			// End:0x18E
			if(Viewers[I].Pawn != none)
			{
				tempRatio = VSizeSq(Viewers[I].Pawn.Location - Location) / (CylinderComponent.CollisionRadius * CylinderComponent.CollisionRadius);
				distRatio = ((tempRatio < distRatio) ? tempRatio : distRatio);
				distRatio = 1.0000000 - distRatio;
			}
			I++;
			// [Loop Continue]
			goto J0x65;
		}		
	}
	else
	{
		distRatio = 0.0000000;
	}
	return distRatio;
	//return ReturnValue;	
}

function HaloConstructionManager.EHaloConstructionPrimitiveTypes GetCurrentPrimitiveType()
{
	return CurrentBuildable.ConstructionUIPrimitives[CurrentBuildable.CurrentUIPrimitiveIndex].Type;
	//return ReturnValue;	
}

function string GetTypeMessage()
{
	switch(CurrentBuildable.Type)
	{
		// End:0x35
		case 0:
			return TypeMessageFootbridge;
		// End:0x44
		case 1:
			return TypeMessageVehiclebridge;
		// End:0x53
		case 2:
			return TypeMessageElevator;
		// End:0x62
		case 3:
			return TypeMessageFRPowerSupply;
		// End:0x71
		case 4:
			return TypeMessageFRTerminal;
		// End:0x80
		case 5:
			return TypeMessageCoveredBridge;
		// End:0x8F
		case 6:
			return TypeMessageVehicleBay;
		// End:0x9E
		case 7:
			return TypeMessageManCannon;
		// End:0xAD
		case 8:
			return TypeMessageFortification;
		// End:0xBC
		case 9:
			return TypeMessageTerminal;
		// End:0xFFFF
		default:
			return "ERROR: Invalid Buildable Type";
			break;
	}
	//return ReturnValue;	
}

function PrintBuildable(BuildableRecipe B)
{
	local int I;

	LogInternal("BUILDABLE -----------------------------------------");
	LogInternal("NameId: " $ B.NameId);
	LogInternal("Type: " $ string(B.Type));
	LogInternal("Primitive Inventory: Panel: ");
	LogInternal("Primitive Inventory: Cylinder: ");
	LogInternal("Primitive Inventory: Beam: ");
	LogInternal("Primitive Inventory: Pyramid: ");
	LogInternal("Primitive Inventory: Wedge: ");
	LogInternal("--ConstructionPrimitives:");
	I = 0;
	J0x160:

	// End:0x22A [Loop If]
	if(I < B.ConstructionUIPrimitives.Length)
	{
		LogInternal((("Type: " $ string(B.ConstructionUIPrimitives[I].Type)) $ " Count: ") $ string(B.ConstructionUIPrimitives[I].Count));
		I++;
		// [Loop Continue]
		goto J0x160;
	}
	LogInternal("CurrentPrimitiveIndex: " $ string(B.CurrentUIPrimitiveIndex));
	//return;	
}

function RotateMeshRight()
{
	// End:0x3E
	if(ConstructionCamera != none)
	{
		ConstructionCamera.UpdatePosition(-70.0000000 * StoredDeltaTime);
	}
	//return;	
}

function RotateMeshLeft()
{
	// End:0x3E
	if(ConstructionCamera != none)
	{
		ConstructionCamera.UpdatePosition(70.0000000 * StoredDeltaTime);
	}
	//return;	
}

function FocusConstructionCamera(Vector pos)
{
	local float Min, Max;

	// End:0xB2
	if((ConstructionCamera != none) && CurrentBuildable.CObject != none)
	{
		CurrentBuildable.CObject.GetSelectedPrimitiveCameraMinMax(Min, Max);
		ConstructionCamera.UpdateFocusPos(pos, true, Min, Max);
	}
	//return;	
}

function StartMagicMoment()
{
	// End:0x54
	if(CurrentBuildable.CObject != none)
	{
		CurrentBuildable.CObject.StartMagicMoment();
	}
	//return;	
}

function bool UsedBy(Pawn User)
{
	return false;
	//return ReturnValue;	
}

function CheatComplete()
{
	bIsComplete = true;
	bIsInBuildMode = true;
	ConstructionCompleteDelay = 1.0000000;
	//return;	
}

defaultproperties
{
	// Reference: HaloBuildIndicatorComponent'MegaHaloGame.Default__HaloConstructionBuildPadTrigger.HaloBuildIndicatorComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'HaloBuildIndicatorComponent0'
	begin object name="HaloBuildIndicatorComponent0" class=MegaHaloGame.HaloBuildIndicatorComponent
		// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloConstructionBuildPadTrigger.HaloBuildIndicatorComponent0.ParticleSystemComponent0'
		// TemplateOwnerClass: none
		// TemplateOwnerName: 'ParticleSystemComponent0'
		// Archetype: ParticleSystemComponent'MegaHaloGame.Default__HaloBuildIndicatorComponent.ParticleSystemComponent0'
		begin object name="ParticleSystemComponent0"
			ReplacementPrimitive=none
		end object
		StartParticleSystem=ParticleSystemComponent0
		// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloConstructionBuildPadTrigger.HaloBuildIndicatorComponent0.ParticleSystemComponent1'
		// TemplateOwnerClass: none
		// TemplateOwnerName: 'ParticleSystemComponent1'
		// Archetype: ParticleSystemComponent'MegaHaloGame.Default__HaloBuildIndicatorComponent.ParticleSystemComponent1'
		begin object name="ParticleSystemComponent1"
			ReplacementPrimitive=none
		end object
		OnParticleSystem=ParticleSystemComponent1
		// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloConstructionBuildPadTrigger.HaloBuildIndicatorComponent0.ParticleSystemComponent2'
		// TemplateOwnerClass: none
		// TemplateOwnerName: 'ParticleSystemComponent2'
		// Archetype: ParticleSystemComponent'MegaHaloGame.Default__HaloBuildIndicatorComponent.ParticleSystemComponent2'
		begin object name="ParticleSystemComponent2"
			ReplacementPrimitive=none
		end object
		StopParticleSystem=ParticleSystemComponent2
	end object
	BuildIndicator=HaloBuildIndicatorComponent0
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloConstructionBuildPadTrigger.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0" class=Engine.SkeletalMeshComponent
		ReplacementPrimitive=none
		CollideActors=true
		BlockActors=true
		BlockZeroExtent=true
		BlockNonZeroExtent=true
	end object
	TriggerObj=SkeletalMeshComponent0
	ActivationRange=300.0000000
	ActivateSound=AkEvent'Global.Play_UI_Construction_Enter'
	DeactivateSound=AkEvent'Global.Play_UI_Construction_Exit'
	InteractMessageActive="Press [MainHUD.InlineInputIcons.inputIcon_y] to Build"
	InteractMessageInactive="Blueprint Needed"
	InteractMessageComplete="Construction Complete!"
	TypeMessageFootbridge="Footbridge"
	TypeMessageElevator="Elevator"
	UndergroundOffset=-40000.0000000
	ConstructionLightDir=(X=-1.0000000,Y=0.0000000,Z=0.2500000)
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloConstructionBuildPadTrigger.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__Trigger.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	// Reference: SpriteComponent'MegaHaloGame.Default__HaloConstructionBuildPadTrigger.Sprite'
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
	CollisionComponent=SkeletalMeshComponent0
}