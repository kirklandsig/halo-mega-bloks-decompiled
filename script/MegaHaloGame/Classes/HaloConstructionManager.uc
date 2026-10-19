class HaloConstructionManager extends Actor
	config(Construction)
	notplaceable
	implements(HaloSaveInterface);

enum EHaloConstructionTypes
{
	HCT_Footbridge,                 // 0
	HCT_Vehiclebridge,              // 1
	HCT_Elevator,                   // 2
	HCT_FRPowerSupply,              // 3
	HCT_FRTerminal,                 // 4
	HCT_CoveredBridge,              // 5
	HCT_VehicleBay,                 // 6
	HCT_ManCannon,                  // 7
	HCT_Fortification,              // 8
	HCT_Terminal,                   // 9
	HCT_None,                       // 10
	HCT_MAX                         // 11
};

enum EHaloConstructionPrimitiveTypes
{
	HCP_Panel,                      // 0
	HCP_Beam,                       // 1
	HCP_Pyramid,                    // 2
	HCP_Cylinder,                   // 3
	HCP_Wedge,                      // 4
	HCP_Wheel,                      // 5
	HCP_Pentagon,                   // 6
	HCP_None,                       // 7
	HCP_MAX                         // 8
};

struct HaloConstructionInfo
{
	var name Name;
	var int Cost;
	var bool Unlocked;
	var float CameraXScale;
	var float CameraYScale;
	var SkeletalMesh PrimitiveMesh;
	var SkeletalMesh SocketMesh;
	var StaticMesh DetailedMesh;
	var StaticMesh DetailedMeshFinal;
	var name MagicMomentAnim;
	var Texture2D TextureParameter;
	var string PreviewImagePath;
	var HaloConstructionObject CObj;

	structdefaultproperties
	{
		Name="None"
		Cost=0
		Unlocked=false
		CameraXScale=1.0000000
		CameraYScale=1.0000000
		PrimitiveMesh=none
		SocketMesh=none
		DetailedMesh=none
		DetailedMeshFinal=none
		MagicMomentAnim="None"
		TextureParameter=none
		PreviewImagePath=""
		CObj=none
	}
};

struct HaloConstructionMaterialInfo
{
	var MaterialInstance DistortionMaterialTemplate;
	var MaterialInstance PrimitiveClearMaterialTemplate;
	var MaterialInstance PrimitiveSolidMaterialTemplate;
	var MaterialInstance PrimitiveSelectedMaterialTemplate;
	var MaterialInstance HologramMaterialTemplate;
	var MaterialInstance SolidConstructionObjectMaterialTemplate;
	var MaterialInstance ErrorPrimitiveMaterialTemplate;

	structdefaultproperties
	{
		DistortionMaterialTemplate=none
		PrimitiveClearMaterialTemplate=none
		PrimitiveSolidMaterialTemplate=none
		PrimitiveSelectedMaterialTemplate=none
		HologramMaterialTemplate=none
		SolidConstructionObjectMaterialTemplate=none
		ErrorPrimitiveMaterialTemplate=none
	}
};

struct HaloConstructionPrimitiveInfo
{
	var name PrimitiveName;
	var string IconPkgPath;
	var SkeletalMesh PrimitiveMesh;
	var ParticleSystem TrailFX;
	var ParticleSystem SplashFX;
	var ParticleSystem ErrorTrailFX;
	var ParticleSystem ErrorSplashFX;
	var Texture2D PrimitiveTexture;
	var PhysicsAsset PhysicsAssetTemplate;

	structdefaultproperties
	{
		PrimitiveName="None"
		IconPkgPath=""
		PrimitiveMesh=none
		TrailFX=none
		SplashFX=none
		ErrorTrailFX=none
		ErrorSplashFX=none
		PrimitiveTexture=none
		PhysicsAssetTemplate=none
	}
};

struct HaloConstructionUIPrimitive
{
	var HaloConstructionManager.EHaloConstructionPrimitiveTypes Type;
	var string IconPkgPath;
	var int Count;

	structdefaultproperties
	{
		Type=HCP_Panel
		IconPkgPath=""
		Count=0
	}
};

struct HaloConstructionInventory
{
	var int Panels;
	var int Beams;
	var int Pyramids;
	var int Cylinders;
	var int Wedges;
	var int Wheels;
	var int Pentagons;

	structdefaultproperties
	{
		Panels=0
		Beams=0
		Pyramids=0
		Cylinders=0
		Wedges=0
		Wheels=0
		Pentagons=0
	}
};

struct BuildableRecipePrimitive
{
	var int BoneIndex;
	var HaloConstructionManager.EHaloConstructionPrimitiveTypes PrimitiveType;
	var bool bHasBeenPlaced;

	structdefaultproperties
	{
		BoneIndex=0
		PrimitiveType=HCP_Panel
		bHasBeenPlaced=false
	}
};

struct BuildableRecipe
{
	var string NameId;
	var HaloConstructionManager.EHaloConstructionTypes Type;
	var HaloConstructionInventory PrimitiveInventory;
	var array<HaloConstructionUIPrimitive> ConstructionUIPrimitives;
	var int CurrentUIPrimitiveIndex;
	var AkEvent CompletedSound;
	var HaloConstructionObject CObject;

	structdefaultproperties
	{
		NameId=""
		Type=HCT_Footbridge
		PrimitiveInventory=(Panels=0,Beams=0,Pyramids=0,Cylinders=0,Wedges=0,Wheels=0,Pentagons=0)
		ConstructionUIPrimitives=none
		CurrentUIPrimitiveIndex=0
		CompletedSound=none
		CObject=none
	}
};

var config array<config HaloConstructionInfo> ConstructionInfoArray;
var config array<config HaloConstructionPrimitiveInfo> ConstructionPrimitiveInfoArray;
var config HaloConstructionMaterialInfo ConstructionMaterialInfo;
var HaloConstructionBuildPadTrigger CurrentBuildPadTrigger;
var HaloConstructionBuildPadTrigger ViewableBuildPadTrigger;
var float TimeSinceLastJoystickXInput;
var float TimeSinceLastJoystickYInput;
var const float JoystickInputDelay;
var bool JoystickInputRelease;
var private AkEvent AddPrimitiveSound;
var private AkEvent AddPrimitiveSuccessSound;
var private AkEvent AddPrimitiveErrorSound;
var private AkEvent ErrorSound;
var ForceFeedbackWaveform ErrorWaveForm;

function bool AddConstructionType(BuildableRecipe BObj, HaloConstructionBuildPadTrigger pad)
{
	local HaloConstructionObject CObj;

	// End:0x159
	if(ConstructionInfoArray[int(BObj.Type)].CObj == none)
	{
		CObj = Spawn(Class'MegaHaloGame.HaloConstructionObject', self,, pad.Location, pad.Rotation,, true);
		// End:0x159
		if(CObj != none)
		{
			CObj.InitConstructionObject(self, BObj.Type, ConstructionInfoArray[int(BObj.Type)]);
			ConstructionInfoArray[int(BObj.Type)].CObj = CObj;
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function HaloConstructionObject GetHaloConstructionObjectFromType(HaloConstructionManager.EHaloConstructionTypes Type)
{
	return ConstructionInfoArray[int(Type)].CObj;
	//return ReturnValue;	
}

function ShowDetailedMesh(HaloConstructionManager.EHaloConstructionTypes Type, bool show)
{
	ConstructionInfoArray[int(Type)].CObj.ShowDetailedMesh(show);
	//return;	
}

function ShowPrimitiveMesh(HaloConstructionManager.EHaloConstructionTypes Type, bool show)
{
	ConstructionInfoArray[int(Type)].CObj.ShowPrimitiveMesh(show);
	//return;	
}

function ShowDetailedHologramMesh(HaloConstructionManager.EHaloConstructionTypes Type, bool show)
{
	ConstructionInfoArray[int(Type)].CObj.ShowDetailedHologramMesh(show);
	//return;	
}

function ShowGlitchMesh(HaloConstructionManager.EHaloConstructionTypes Type, bool show)
{
	ConstructionInfoArray[int(Type)].CObj.ShowGlitchMesh(show);
	//return;	
}

function HideAllMeshes(HaloConstructionManager.EHaloConstructionTypes Type)
{
	ConstructionInfoArray[int(Type)].CObj.HideAllMeshes();
	//return;	
}

function PositionGlitchMesh(HaloConstructionManager.EHaloConstructionTypes Type, Vector meshLoc, Rotator meshRot)
{
	ConstructionInfoArray[int(Type)].CObj.PositionGlitchMesh(meshLoc, meshRot);
	//return;	
}

function int GetConstructionCostFromType(HaloConstructionManager.EHaloConstructionTypes Type)
{
	return ConstructionInfoArray[int(Type)].Cost;
	//return ReturnValue;	
}

function GetConstructionCameraScaleFromType(HaloConstructionManager.EHaloConstructionTypes Type, out Vector2D Scale)
{
	Scale.X = ConstructionInfoArray[int(Type)].CameraXScale;
	Scale.Y = ConstructionInfoArray[int(Type)].CameraYScale;
	//return;	
}

function SetCurrentBuildPadTrigger(HaloConstructionBuildPadTrigger pad)
{
	CurrentBuildPadTrigger = pad;
	//return;	
}

function SetViewableBuildPadTrigger(HaloConstructionBuildPadTrigger pad)
{
	ViewableBuildPadTrigger = pad;
	//return;	
}

function GetBuildPadLocationRotation(out Vector padLocation, out Rotator padRotation)
{
	// End:0x40
	if(CurrentBuildPadTrigger != none)
	{
		CurrentBuildPadTrigger.GetBuildPadLocationRotation(padLocation, padRotation);
	}
	//return;	
}

function SkeletalMesh GetPrimitiveMeshFromType(HaloConstructionManager.EHaloConstructionPrimitiveTypes Type)
{
	return ConstructionPrimitiveInfoArray[int(Type)].PrimitiveMesh;
	//return ReturnValue;	
}

function ParticleSystem GetPrimitiveTrailFXFromType(HaloConstructionManager.EHaloConstructionPrimitiveTypes Type)
{
	return ConstructionPrimitiveInfoArray[int(Type)].TrailFX;
	//return ReturnValue;	
}

function ParticleSystem GetPrimitiveSplashFXFromType(HaloConstructionManager.EHaloConstructionPrimitiveTypes Type)
{
	return ConstructionPrimitiveInfoArray[int(Type)].SplashFX;
	//return ReturnValue;	
}

function ParticleSystem GetPrimitiveErrorTrailFXFromType(HaloConstructionManager.EHaloConstructionPrimitiveTypes Type)
{
	return ConstructionPrimitiveInfoArray[int(Type)].ErrorTrailFX;
	//return ReturnValue;	
}

function ParticleSystem GetPrimitiveErrorSplashFXFromType(HaloConstructionManager.EHaloConstructionPrimitiveTypes Type)
{
	return ConstructionPrimitiveInfoArray[int(Type)].ErrorSplashFX;
	//return ReturnValue;	
}

function Texture2D GetPrimitiveTextureFromType(HaloConstructionManager.EHaloConstructionPrimitiveTypes Type)
{
	return ConstructionPrimitiveInfoArray[int(Type)].PrimitiveTexture;
	//return ReturnValue;	
}

function PhysicsAsset GetPhysicsAssetFromType(HaloConstructionManager.EHaloConstructionPrimitiveTypes Type)
{
	return ConstructionPrimitiveInfoArray[int(Type)].PhysicsAssetTemplate;
	//return ReturnValue;	
}

function HaloConstructionManager.EHaloConstructionPrimitiveTypes GetConstructionPrimitiveTypeFromString(string strType)
{
	strType = Caps(strType);
	// End:0x30
	if(strType == "PANEL")
	{
		return 0;		
	}
	else
	{
		// End:0x4A
		if(strType == "BEAM")
		{
			return 1;			
		}
		else
		{
			// End:0x67
			if(strType == "PYRAMID")
			{
				return 2;				
			}
			else
			{
				// End:0x85
				if(strType == "CYLINDER")
				{
					return 3;					
				}
				else
				{
					// End:0xA0
					if(strType == "WEDGE")
					{
						return 4;						
					}
					else
					{
						// End:0xBB
						if(strType == "WHEEL")
						{
							return 5;							
						}
						else
						{
							// End:0xD6
							if(strType == "PENTAGON")
							{
								return 6;
							}
						}
					}
				}
			}
		}
	}
	return 7;
	//return ReturnValue;	
}

function MaterialInstance GetDistortionMaterial()
{
	return ConstructionMaterialInfo.DistortionMaterialTemplate;
	//return ReturnValue;	
}

function MaterialInstance GetPrimitiveClearMaterial()
{
	return ConstructionMaterialInfo.PrimitiveClearMaterialTemplate;
	//return ReturnValue;	
}

function MaterialInstance GetPrimitiveSolidMaterial()
{
	return ConstructionMaterialInfo.PrimitiveSolidMaterialTemplate;
	//return ReturnValue;	
}

function MaterialInstance GetPrimitiveSelectedMaterial()
{
	return ConstructionMaterialInfo.PrimitiveSelectedMaterialTemplate;
	//return ReturnValue;	
}

function MaterialInstance GetHologramMaterial()
{
	return ConstructionMaterialInfo.HologramMaterialTemplate;
	//return ReturnValue;	
}

function MaterialInstance GetSolidConstructionObjectMaterial()
{
	return ConstructionMaterialInfo.SolidConstructionObjectMaterialTemplate;
	//return ReturnValue;	
}

function MaterialInstance GetErrorPrimitiveMaterial()
{
	return ConstructionMaterialInfo.ErrorPrimitiveMaterialTemplate;
	//return ReturnValue;	
}

function bool AddBlueprint(HaloConstructionBlueprintPickup blueprint)
{
	local bool wasLocked;

	wasLocked = ConstructionInfoArray[int(blueprint.ConstructionType)].Unlocked == false;
	ConstructionInfoArray[int(blueprint.ConstructionType)].Unlocked = true;
	return wasLocked;
	//return ReturnValue;	
}

function bool IsBlueprintLocked(HaloConstructionObject Object)
{
	return ConstructionInfoArray[int(Object.CType)].Unlocked == false;
	//return ReturnValue;	
}

function bool IsBlueprintUnlocked(HaloConstructionObject Object)
{
	return (IsBlueprintLocked(Object)) == false;
	//return ReturnValue;	
}

function bool IsBlueprintLockedFromClassName(Class<HaloConstructionObject> ClassName)
{
	local int Index;

	Index = GetBlueprintIndexFromClassName(ClassName);
	return ConstructionInfoArray[Index].Unlocked == false;
	//return ReturnValue;	
}

function bool IsBlueprintUnlockedFromClassName(Class<HaloConstructionObject> ClassName)
{
	return (IsBlueprintLockedFromClassName(ClassName)) == false;
	//return ReturnValue;	
}

function bool IsBlueprintUnlockedFromType(HaloConstructionManager.EHaloConstructionTypes Type)
{
	return ConstructionInfoArray[int(Type)].Unlocked;
	//return ReturnValue;	
}

function bool IsBlueprintLockedFromType(HaloConstructionManager.EHaloConstructionTypes Type)
{
	return ConstructionInfoArray[int(Type)].Unlocked == false;
	//return ReturnValue;	
}

function int GetBlueprintIndexFromClassName(Class<HaloConstructionObject> ClassName)
{
	switch(ClassName.Name)
	{
		// End:0x36
		case 'HaloConstructionObject_Footbridge':
			return 0;
		// End:0x44
		case 'HaloConstructionObject_Vehiclebridge':
			return 1;
		// End:0x53
		case 'HaloConstructionObject_Elevator':
			return 2;
		// End:0x62
		case 'HaloConstructionObject_FRPowerSupply':
			return 3;
		// End:0x71
		case 'HaloConstructionObject_FRTerminal':
			return 4;
		// End:0x80
		case 'HaloConstructionObject_CoveredBridge':
			return 5;
		// End:0x8F
		case 'HaloConstructionObject_VehicleBay':
			return 6;
		// End:0x9E
		case 'HaloConstructionObject_ManCannon':
			return 7;
		// End:0xAD
		case 'HaloConstructionObject_Fortification':
			return 8;
		// End:0xBC
		case 'HaloConstructionObject_Terminal':
			return 9;
		// End:0xFFFF
		default:
			WarnInternal("GetBlueprintIndexFromClassName: Invalid Construction Object name");
			return 0;
			break;
	}
	//return ReturnValue;	
}

event Tick(float DeltaTime)
{
	TimeSinceLastJoystickXInput += DeltaTime;
	// End:0x3E
	if(TimeSinceLastJoystickXInput >= JoystickInputDelay)
	{
		TimeSinceLastJoystickXInput = JoystickInputDelay;
	}
	TimeSinceLastJoystickYInput += DeltaTime;
	// End:0x7C
	if(TimeSinceLastJoystickYInput >= JoystickInputDelay)
	{
		TimeSinceLastJoystickYInput = JoystickInputDelay;
	}
	//return;	
}

function bool IsActive()
{
	// End:0x56
	if(CurrentBuildPadTrigger != none)
	{
		return CurrentBuildPadTrigger.bIsInBuildMode && CurrentBuildPadTrigger.bIsComplete == false;
	}
	return false;
	//return ReturnValue;	
}

function bool HasActiveBuildPadTrigger()
{
	return CurrentBuildPadTrigger != none;
	//return ReturnValue;	
}

function bool HasViewableBuildPadTrigger()
{
	return ViewableBuildPadTrigger != none;
	//return ReturnValue;	
}

function HaloConstructionManager.EHaloConstructionTypes GetActiveType()
{
	// End:0x2F
	if(CurrentBuildPadTrigger != none)
	{
		return CurrentBuildPadTrigger.GetCurrentBuildType();
	}
	return 10;
	//return ReturnValue;	
}

function HaloConstructionManager.EHaloConstructionTypes GetViewableType()
{
	// End:0x2F
	if(ViewableBuildPadTrigger != none)
	{
		return ViewableBuildPadTrigger.GetCurrentBuildType();
	}
	return 10;
	//return ReturnValue;	
}

function bool IsComplete()
{
	// End:0x32
	if(CurrentBuildPadTrigger != none)
	{
		return CurrentBuildPadTrigger.bIsComplete == true;
	}
	return false;
	//return ReturnValue;	
}

function string GetBuildName()
{
	// End:0x2F
	if(CurrentBuildPadTrigger != none)
	{
		return CurrentBuildPadTrigger.GetBuildName();
	}
	return "NOT A NAME";
	//return ReturnValue;	
}

function string GetPreviewImagePath()
{
	// End:0x4E
	if(CurrentBuildPadTrigger != none)
	{
		return ConstructionInfoArray[int(CurrentBuildPadTrigger.GetCurrentBuildType())].PreviewImagePath;
	}
	return "";
	//return ReturnValue;	
}

function bool GetPrimitiveAlreadyPlaced()
{
	// End:0x2F
	if(CurrentBuildPadTrigger != none)
	{
		return CurrentBuildPadTrigger.GetPrimitiveAlreadyPlaced();
	}
	//return ReturnValue;	
}

function int GetTotalPrimitives()
{
	// End:0x2F
	if(CurrentBuildPadTrigger != none)
	{
		return CurrentBuildPadTrigger.GetTotalPrimitives();
	}
	//return ReturnValue;	
}

function int GetUsedPrimitives()
{
	// End:0x2F
	if(CurrentBuildPadTrigger != none)
	{
		return CurrentBuildPadTrigger.GetUsedPrimitives();
	}
	//return ReturnValue;	
}

function array<HaloConstructionUIPrimitive> GetConstructionUIPrimitives()
{
	// End:0x2F
	if(CurrentBuildPadTrigger != none)
	{
		return CurrentBuildPadTrigger.GetConstructionUIPrimitives();
	}
	//return ReturnValue;	
}

function int GetConstructionUIPrimitivesIndex()
{
	// End:0x2F
	if(CurrentBuildPadTrigger != none)
	{
		return CurrentBuildPadTrigger.GetConstructionUIPrimitivesIndex();
	}
	return -1;
	//return ReturnValue;	
}

function IncrementPrimitiveSelection()
{
	// End:0x2E
	if(CurrentBuildPadTrigger != none)
	{
		CurrentBuildPadTrigger.IncrementPrimitiveSelection();
	}
	//return;	
}

function DecrementPrimitiveSelection()
{
	// End:0x2E
	if(CurrentBuildPadTrigger != none)
	{
		CurrentBuildPadTrigger.DecrementPrimitiveSelection();
	}
	//return;	
}

function float GetActivatorBuildTriggerDistanceRatio()
{
	// End:0x2F
	if(ViewableBuildPadTrigger != none)
	{
		return ViewableBuildPadTrigger.GetActivatorBuildTriggerDistanceRatio();
	}
	return 0.0000000;
	//return ReturnValue;	
}

function bool ActivatePrimitiveSelection()
{
	// End:0xA1
	if((CurrentBuildPadTrigger != none) && CurrentBuildPadTrigger.ContainsEmptyPrimitives())
	{
		// End:0x77
		if(CurrentBuildPadTrigger.AddPrimitive(CurrentBuildPadTrigger.GetCurrentPrimitiveType()))
		{			
		}
		else
		{
			ForceErrorRumble();
		}
		return CurrentBuildPadTrigger.ContainsEmptyPrimitives();
	}
	return false;
	//return ReturnValue;	
}

function ProcessJoyStickInput(float aBaseY, float aStrafe)
{
	// End:0x34
	if((aStrafe < 0.2000000) && aStrafe > -0.2000000)
	{
		JoystickInputRelease = true;
	}
	// End:0xE9
	if(JoystickInputRelease == true)
	{
		// End:0x98
		if((aStrafe > 0.5000000) && TimeSinceLastJoystickXInput >= JoystickInputDelay)
		{
			TimeSinceLastJoystickXInput = 0.0000000;
			IncrementPrimitiveSelection();
			JoystickInputRelease = false;			
		}
		else
		{
			// End:0xE9
			if((aStrafe < -0.5000000) && TimeSinceLastJoystickXInput >= JoystickInputDelay)
			{
				TimeSinceLastJoystickXInput = 0.0000000;
				DecrementPrimitiveSelection();
				JoystickInputRelease = false;
			}
		}
	}
	//return;	
}

function ForceErrorRumble()
{
	// End:0xB7
	if(((CurrentBuildPadTrigger != none) && CurrentBuildPadTrigger.HPPCActivator != none) && LocalPlayer(CurrentBuildPadTrigger.HPPCActivator.Player) != none)
	{
		CurrentBuildPadTrigger.HPPCActivator.ClientPlayForceFeedbackWaveform(ErrorWaveForm);
	}
	//return;	
}

function FocusConstructionCamera(Vector pos)
{
	// End:0x37
	if(CurrentBuildPadTrigger != none)
	{
		CurrentBuildPadTrigger.FocusConstructionCamera(pos);
	}
	//return;	
}

function CheatComplete()
{
	// End:0x2E
	if(CurrentBuildPadTrigger != none)
	{
		CurrentBuildPadTrigger.CheatComplete();
	}
	//return;	
}

function PlayAddPrimitiveSound()
{
	PlayAkEvent(AddPrimitiveSound);
	//return;	
}

function PlayAttachPrimitiveSuccessSound()
{
	PlayAkEvent(AddPrimitiveSuccessSound);
	//return;	
}

function PlayAttachPrimitiveErrorSound()
{
	PlayAkEvent(AddPrimitiveErrorSound);
	//return;	
}

function PlayErrorSound()
{
	PlayAkEvent(ErrorSound);
	//return;	
}

function JsonObject Serialize()
{
	local JsonObject Data;
	local HaloConstructionInfo construct;
	local int I, Type;

	Data = new Class'Engine.JsonObject';
	// End:0x19F
	if(Data != none)
	{
		Data.SetStringValue("Name", PathName(self));
		Data.SetStringValue("ObjectArchetype", PathName(ObjectArchetype));
		I = 0;
		Type = 0;
		// End:0x157
		foreach ConstructionInfoArray(construct)
		{
			// End:0x14B
			if(construct.Unlocked)
			{
				Data.SetIntValue(("UnlockedConstructionInfo_" $ string(I)) $ "_Type", Type);
				I++;
			}
			Type++;			
		}		
		Data.SetIntValue("UnlockedConstructionInfoCount", I);
	}
	return Data;
	//return ReturnValue;	
}

function Deserialize(JsonObject Data)
{
	local int I, constructCnt;
	local HaloConstructionManager.EHaloConstructionTypes Type;

	constructCnt = Data.GetIntValue("UnlockedConstructionInfoCount");
	I = 0;
	J0x53:

	// End:0x136 [Loop If]
	if(I < constructCnt)
	{
		Type = byte(Data.GetIntValue(("UnlockedConstructionInfo_" $ string(I)) $ "_Type"));
		ConstructionInfoArray[int(Type)].Unlocked = true;
		LogInternal("Unlocked blueprint construction type " $ string(Type));
		I++;
		// [Loop Continue]
		goto J0x53;
	}
	//return;	
}

defaultproperties
{
	ConstructionInfoArray[0]=(Name="Footbridge",Cost=75,Unlocked=false,CameraXScale=0.6500000,CameraYScale=0.6500000,PrimitiveMesh=SkeletalMesh'UNSC_FootBridge.Mesh.UNSC_FtBridge_S1_Proxy',SocketMesh=SkeletalMesh'Halo_Construction_Objects.SkeletalMesh.Construction_Footbridge',DetailedMesh=StaticMesh'UNSC_FootBridge.Mesh.UNSC_FtBridge_S3_Proxy',DetailedMeshFinal=StaticMesh'UNSC_FootBridge.Mesh.UNSC_FtBridge_S6_Persistent',MagicMomentAnim="BridgeMagicMoment",TextureParameter=Texture2D'UNSC_FootBridge.Textures.UNSC_FootBridge_Proxy_EDGE',PreviewImagePath="MainHUD.BlokConstructionIcons.BCPreview_Footbridge",CObj=none)
	ConstructionInfoArray[1]=(Name="Vehiclebridge",Cost=100,Unlocked=false,CameraXScale=1.0000000,CameraYScale=1.0000000,PrimitiveMesh=none,SocketMesh=none,DetailedMesh=none,DetailedMeshFinal=none,MagicMomentAnim="None",TextureParameter=none,PreviewImagePath="",CObj=none)
	ConstructionInfoArray[2]=(Name="Elevator",Cost=100,Unlocked=false,CameraXScale=1.0000000,CameraYScale=1.0000000,PrimitiveMesh=SkeletalMesh'UNSC_SmallElevator.Mesh.UNSC_ElevSmall_Primitive',SocketMesh=SkeletalMesh'Halo_Construction_Objects.SkeletalMesh.Construction_Elevator',DetailedMesh=StaticMesh'UNSC_SmallElevator.Mesh.UNSC_SmallElevatorProxy',DetailedMeshFinal=StaticMesh'UNSC_SmallElevator.Mesh.UNSC_SmallElevator',MagicMomentAnim="ElevatorMagicMoment",TextureParameter=Texture2D'UNSC_SmallElevator.Textures.Elevator_Stroke',PreviewImagePath="MainHUD.BlokConstructionIcons.BCPreview_Elevator",CObj=none)
	ConstructionInfoArray[3]=(Name="FRPowerSupply",Cost=200,Unlocked=false,CameraXScale=1.0000000,CameraYScale=1.0000000,PrimitiveMesh=SkeletalMesh'Constructs.Mesh.Skeletal.Forerunner_Power_Supply',SocketMesh=SkeletalMesh'Halo_Construction_Objects.SkeletalMesh.Construction_FRPowerSupply',DetailedMesh=StaticMesh'Constructs.Forerunner_Power_Supply',DetailedMeshFinal=StaticMesh'Constructs.Forerunner_Power_Supply',MagicMomentAnim="ElevatorMagicMomenta",TextureParameter=Texture2D'UNSC_SmallElevator.Textures.Elevator_Stroke',PreviewImagePath="",CObj=none)
	ConstructionInfoArray[4]=(Name="FRTerminal",Cost=100,Unlocked=false,CameraXScale=1.0000000,CameraYScale=1.0000000,PrimitiveMesh=SkeletalMesh'Constructs.Mesh.Skeletal.Forerunner_Terminal',SocketMesh=SkeletalMesh'Halo_Construction_Objects.SkeletalMesh.Construction_FRTerminal',DetailedMesh=StaticMesh'Constructs.Forerunner_Terminal',DetailedMeshFinal=StaticMesh'Constructs.Forerunner_Terminal',MagicMomentAnim="ElevatorMagicMomenta",TextureParameter=Texture2D'UNSC_SmallElevator.Textures.Elevator_Stroke',PreviewImagePath="",CObj=none)
	ConstructionInfoArray[5]=(Name="CoveredBridge",Cost=100,Unlocked=false,CameraXScale=1.0000000,CameraYScale=1.0000000,PrimitiveMesh=SkeletalMesh'Constructs.Mesh.Skeletal.Covered_Bridge',SocketMesh=SkeletalMesh'Halo_Construction_Objects.SkeletalMesh.Construction_CoveredBridge',DetailedMesh=StaticMesh'Constructs.Covered_Bridge',DetailedMeshFinal=StaticMesh'Constructs.Covered_Bridge',MagicMomentAnim="ElevatorMagicMomenta",TextureParameter=Texture2D'UNSC_SmallElevator.Textures.Elevator_Stroke',PreviewImagePath="",CObj=none)
	ConstructionInfoArray[6]=(Name="VehicleBay",Cost=100,Unlocked=false,CameraXScale=1.0000000,CameraYScale=1.0000000,PrimitiveMesh=SkeletalMesh'Constructs.Mesh.Skeletal.Vehicle_Bay',SocketMesh=SkeletalMesh'Halo_Construction_Objects.SkeletalMesh.Construction_VehicleBay',DetailedMesh=StaticMesh'Constructs.Vehicle_Bay',DetailedMeshFinal=StaticMesh'Constructs.Vehicle_Bay',MagicMomentAnim="ElevatorMagicMomenta",TextureParameter=Texture2D'UNSC_SmallElevator.Textures.Elevator_Stroke',PreviewImagePath="",CObj=none)
	ConstructionInfoArray[7]=(Name="ManCannon",Cost=150,Unlocked=false,CameraXScale=1.0000000,CameraYScale=1.0000000,PrimitiveMesh=SkeletalMesh'Constructs.Mesh.Skeletal.Man_Can',SocketMesh=SkeletalMesh'Halo_Construction_Objects.SkeletalMesh.Construction_ManCannon',DetailedMesh=StaticMesh'Constructs.Man_Cannon',DetailedMeshFinal=StaticMesh'Constructs.Man_Cannon',MagicMomentAnim="ElevatorMagicMomenta",TextureParameter=Texture2D'UNSC_SmallElevator.Textures.Elevator_Stroke',PreviewImagePath="",CObj=none)
	ConstructionInfoArray[8]=(Name="Fortification",Cost=125,Unlocked=false,CameraXScale=1.0000000,CameraYScale=1.0000000,PrimitiveMesh=SkeletalMesh'Constructs.Mesh.Skeletal.Fortifications',SocketMesh=SkeletalMesh'Halo_Construction_Objects.SkeletalMesh.Construction_Fortifications',DetailedMesh=StaticMesh'Constructs.Fortifications',DetailedMeshFinal=StaticMesh'Constructs.Fortifications',MagicMomentAnim="ElevatorMagicMomenta",TextureParameter=Texture2D'UNSC_SmallElevator.Textures.Elevator_Stroke',PreviewImagePath="",CObj=none)
	ConstructionInfoArray[9]=(Name="Terminal",Cost=50,Unlocked=false,CameraXScale=1.0000000,CameraYScale=1.0000000,PrimitiveMesh=SkeletalMesh'Constructs.Mesh.Skeletal.Terminal',SocketMesh=SkeletalMesh'Halo_Construction_Objects.SkeletalMesh.Construction_Terminal',DetailedMesh=StaticMesh'Constructs.Terminal',DetailedMeshFinal=StaticMesh'Constructs.Terminal',MagicMomentAnim="ElevatorMagicMomenta",TextureParameter=Texture2D'UNSC_SmallElevator.Textures.Elevator_Stroke',PreviewImagePath="",CObj=none)
	ConstructionPrimitiveInfoArray[0]=(PrimitiveName="Panel",IconPkgPath="MainHUD.BlokConstructionIcons.BCIcon_Panel",PrimitiveMesh=SkeletalMesh'Shared_Construction_Meshes.Mesh.SkeletalMesh.Construction_Primitives_PrismShort',TrailFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_RibbonTrail',SplashFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_PlaceDown_Digital',ErrorTrailFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_RibbonFailTrail',ErrorSplashFX=ParticleSystem'env_cov_crates_xpld.Effects.ENV_COV_CRATE_MED_XPLD',PrimitiveTexture=Texture2D'Shared_Construction_Meshes.Textures.PrismShort_EMIS',PhysicsAssetTemplate=PhysicsAsset'Shared_Construction_Meshes.Mesh.Physics.Construction_Primitives_PrismShort_Physics')
	ConstructionPrimitiveInfoArray[1]=(PrimitiveName="Beam",IconPkgPath="MainHUD.BlokConstructionIcons.BCIcon_Beam",PrimitiveMesh=SkeletalMesh'Shared_Construction_Meshes.Mesh.SkeletalMesh.Construction_Primitives_PrismTall',TrailFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_RibbonTrail',SplashFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_PlaceDown_Digital',ErrorTrailFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_RibbonFailTrail',ErrorSplashFX=ParticleSystem'env_cov_crates_xpld.Effects.ENV_COV_CRATE_MED_XPLD',PrimitiveTexture=Texture2D'Shared_Construction_Meshes.Textures.PrismTall_EMIS',PhysicsAssetTemplate=PhysicsAsset'Shared_Construction_Meshes.Mesh.Physics.Construction_Primitives_PrismTall_Physics')
	ConstructionPrimitiveInfoArray[2]=(PrimitiveName="Pyramid",IconPkgPath="MainHUD.BlokConstructionIcons.BCIcon_Pyramid",PrimitiveMesh=SkeletalMesh'Shared_Construction_Meshes.Mesh.SkeletalMesh.Construction_Primitives_PrismBase',TrailFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_RibbonTrail',SplashFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_PlaceDown_Digital',ErrorTrailFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_RibbonFailTrail',ErrorSplashFX=ParticleSystem'env_cov_crates_xpld.Effects.ENV_COV_CRATE_MED_XPLD',PrimitiveTexture=Texture2D'Shared_Construction_Meshes.Textures.PrismBase_EMIS',PhysicsAssetTemplate=PhysicsAsset'Shared_Construction_Meshes.Mesh.Physics.Construction_Primitives_PrismBase_Physics')
	ConstructionPrimitiveInfoArray[3]=(PrimitiveName="Cylinder",IconPkgPath="MainHUD.BlokConstructionIcons.BCIcon_Cylinder",PrimitiveMesh=SkeletalMesh'Shared_Construction_Meshes.Mesh.SkeletalMesh.Construction_Primitives_CylinderThin',TrailFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_RibbonTrail',SplashFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_PlaceDown_Digital',ErrorTrailFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_RibbonFailTrail',ErrorSplashFX=ParticleSystem'env_cov_crates_xpld.Effects.ENV_COV_CRATE_MED_XPLD',PrimitiveTexture=Texture2D'Shared_Construction_Meshes.Textures.CylinderThin_EMIS',PhysicsAssetTemplate=PhysicsAsset'Shared_Construction_Meshes.Mesh.Physics.Construction_Primitives_CylinderThin_Physics')
	ConstructionPrimitiveInfoArray[4]=(PrimitiveName="Wedge",IconPkgPath="MainHUD.BlokConstructionIcons.BCIcon_Wedge",PrimitiveMesh=SkeletalMesh'Shared_Construction_Meshes.Mesh.SkeletalMesh.Construction_Primitives_WedgeShort',TrailFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_RibbonTrail',SplashFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_PlaceDown_Digital',ErrorTrailFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_RibbonFailTrail',ErrorSplashFX=ParticleSystem'env_cov_crates_xpld.Effects.ENV_COV_CRATE_MED_XPLD',PrimitiveTexture=Texture2D'Shared_Construction_Meshes.Textures.WedgeShort_EMIS',PhysicsAssetTemplate=PhysicsAsset'Shared_Construction_Meshes.Mesh.Physics.Construction_Primitives_WedgeShort_Physics')
	ConstructionPrimitiveInfoArray[5]=(PrimitiveName="Wheel",IconPkgPath="mainhud.BlokConstructionIcons.BCIcon_Wheel",PrimitiveMesh=SkeletalMesh'Shared_Construction_Meshes.Mesh.SkeletalMesh.Construction_Primitives_CylinderShort',TrailFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_RibbonTrail',SplashFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_PlaceDown_Digital',ErrorTrailFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_RibbonFailTrail',ErrorSplashFX=ParticleSystem'env_cov_crates_xpld.Effects.ENV_COV_CRATE_MED_XPLD',PrimitiveTexture=Texture2D'Shared_Construction_Meshes.Textures.CylinderShort_EMIS',PhysicsAssetTemplate=PhysicsAsset'Shared_Construction_Meshes.Mesh.Physics.Construction_Primitives_CylinderShort_Physics')
	ConstructionPrimitiveInfoArray[6]=(PrimitiveName="Pentagon",IconPkgPath="mainhud.BlokConstructionIcons.BCIcon_Pentagon",PrimitiveMesh=SkeletalMesh'Shared_Construction_Meshes.Mesh.SkeletalMesh.Construction_Primitives_PrismShortCut',TrailFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_RibbonTrail',SplashFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_PlaceDown_Digital',ErrorTrailFX=ParticleSystem'MM_PUZZLEPARTS.Effects.MM_RibbonFailTrail',ErrorSplashFX=ParticleSystem'env_cov_crates_xpld.Effects.ENV_COV_CRATE_MED_XPLD',PrimitiveTexture=Texture2D'Shared_Construction_Meshes.Textures.PrismShortCut_EMIS',PhysicsAssetTemplate=PhysicsAsset'Shared_Construction_Meshes.Mesh.Physics.Construction_Primitives_PrismShortCut_Physics')
	ConstructionMaterialInfo=(DistortionMaterialTemplate=MaterialInstanceConstant'Shared_Construction_Materials.Materials.S1_Distortion.MI_Construct_Distortion_Mat',PrimitiveClearMaterialTemplate=MaterialInstanceConstant'Shared_Construction_Materials.Materials.S3_ConstructionProxy.MI_Construct_ConstructionClear_Mat',PrimitiveSolidMaterialTemplate=MaterialInstanceTimeVarying'Shared_Construction_Materials.Materials.S5_ConstructionSolid.MI_Construct_SolidCorrectPlacement_MITV',PrimitiveSelectedMaterialTemplate=MaterialInstanceConstant'Shared_Construction_Materials.Materials.S4_ConstructionSelection.Construct_ConstructionSelected_MIC',HologramMaterialTemplate=MaterialInstanceConstant'Shared_Construction_Materials.Materials.S2_Proxy.MI_Construct_Proxy_Mat',SolidConstructionObjectMaterialTemplate=MaterialInstanceConstant'Shared_Construction_Materials.Materials.S6_ConstructionFilled.Construct_ConstructionFilled_MIC',ErrorPrimitiveMaterialTemplate=MaterialInstanceTimeVarying'Shared_Construction_Materials.Materials.S5_ConstructionSolid.MI_Construct_SolidIncorrectPlacement_MITV')
	JoystickInputDelay=0.2000000
	AddPrimitiveSound=AkEvent'Builds.Play_Blok_Place_PreSnap'
	AddPrimitiveSuccessSound=AkEvent'Builds.Play_Blok_Place'
	AddPrimitiveErrorSound=AkEvent'Builds.Play_Blok_Place_Wrong'
	ErrorSound=AkEvent'Builds.Play_Blok_Place_Wrong'
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloConstructionManager.ForceFeedbackWaveFormError1'
	begin object name="ForceFeedbackWaveFormError1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=65,RightAmplitude=65,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.2500000)
	end object
	ErrorWaveForm=ForceFeedbackWaveFormError1
	CollisionType=COLLIDE_CustomDefault
}