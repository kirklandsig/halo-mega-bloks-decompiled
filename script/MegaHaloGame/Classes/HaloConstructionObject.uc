class HaloConstructionObject extends DynamicSMActor_Spawnable;

enum EHaloSocketPrimitiveState
{
	SPS_Distortion,                 // 0
	SPS_PrimitiveClear,             // 1
	SPS_PrimitiveSelected,          // 2
	SPS_PrimitiveSolid,             // 3
	SPS_None,                       // 4
	SPS_MAX                         // 5
};

struct HaloSocketPrimitive
{
	var SkeletalMeshActorSpawnable Actor;
	var HaloConstructionManager.EHaloConstructionPrimitiveTypes PrimitiveType;
	var bool bHasBeenPlaced;
	var HaloConstructionObject.EHaloSocketPrimitiveState PrimitiveState;
	var int SocketIndex;
	var bool bIsSliding_Z;
	var bool bIsSliding_XY;
	var float SlidingHalfHeight;
	var Vector BaseScale;
	var float ScaleTime;
	var int MinCameraDegree;
	var int MaxCameraDegree;
	var bool bShowPrimitive;
	var float FadePct;
	var array<MaterialInstanceConstant> PrimitiveClearMICs;
	var array<MaterialInstanceTimeVarying> SuccessMITVs;

	structdefaultproperties
	{
		Actor=none
		PrimitiveType=EHaloConstructionPrimitiveTypes.HCP_Panel
		bHasBeenPlaced=false
		PrimitiveState=EHaloSocketPrimitiveState.SPS_Distortion
		SocketIndex=0
		bIsSliding_Z=false
		bIsSliding_XY=false
		SlidingHalfHeight=0.0000000
		BaseScale=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		ScaleTime=0.0000000
		MinCameraDegree=-1
		MaxCameraDegree=-1
		bShowPrimitive=true
		FadePct=1.0000000
		PrimitiveClearMICs=none
		SuccessMITVs=none
	}
};

struct HaloSocketErrorPrimitive
{
	var SkeletalMeshActorSpawnable Actor;
	var HaloConstructionManager.EHaloConstructionPrimitiveTypes PrimitiveType;
	var bool bIsSliding_Z;
	var bool bIsSliding_XY;
	var float SlidingHalfHeight;
	var array<MaterialInstanceTimeVarying> ErrorMITVs;

	structdefaultproperties
	{
		Actor=none
		PrimitiveType=EHaloConstructionPrimitiveTypes.HCP_Panel
		bIsSliding_Z=false
		bIsSliding_XY=false
		SlidingHalfHeight=0.0000000
		ErrorMITVs=none
	}
};

var HaloConstructionManager.EHaloConstructionTypes CType;
var HaloConstructionInfo CInfo;
var HaloConstructionManager CManager;
var SkeletalMeshActorSpawnable PrimitiveMesh;
var private bool bShowPrimitiveMesh;
var private bool bShowDetailedMesh;
var bool bLockControls;
var bool bUseZFormFallIn;
var private float PrimitiveMeshFadePct;
var private name PrimitiveScalarParamFadeTimeName;
var private name PrimitiveScalarParamFadeDistName;
var HaloDynamicSMActor_Spawnable DetailedMesh;
var private float DetailedMeshFadePct;
var private name DetailedScalarParamFadeTimeName;
var private name DetailedScalarParamFadeDistName;
var private name PrimitiveVectorParamColorName;
var private float FadeTimeInSec;
var private float MITVTimeInSec;
var private float MITVErrorTimeInSec;
var private float PrimitiveFadeInSec;
var private float PrimitiveFadeOutSec;
var private array<MaterialInstanceConstant> DistortionMICs;
var private array<MaterialInstanceConstant> HologramMICs;
var private array<MaterialInstanceConstant> ClearMICs;
var private array<MaterialInstanceConstant> SolidMICs;
var SkeletalMeshActorSpawnable SocketMesh;
var private array<HaloSocketPrimitive> SocketPrimitives;
var private array<HaloSocketPrimitive> SocketPrimitivesSolid;
var private array<HaloSocketErrorPrimitive> SocketErrorPrimitives;
var private int SocketPrimitiveIndex;
var private int SocketPreviousPrimitiveIndex;
var export editinline ParticleSystemComponent TrailFX;
var export editinline ParticleSystemComponent SplashFX;
var export editinline ParticleSystemComponent ErrorTrailFX;
var export editinline ParticleSystemComponent ErrorSplashFX;
var HaloDynamicSMActor_Spawnable WorldObj;
var LightingChannelContainer NewLightingChannels;
var LightingChannelContainer DefaultLightingChannels;
var export editinline DynamicLightEnvironmentComponent ConstructionLightEnvironment;

function InitConstructionObject(HaloConstructionManager man, HaloConstructionManager.EHaloConstructionTypes Type, HaloConstructionInfo Info)
{
	local int I;
	local MaterialInstanceConstant MIC;

	CManager = man;
	CType = Type;
	CInfo = Info;
	PrimitiveScalarParamFadeTimeName = 'FadeByTime';
	DetailedScalarParamFadeTimeName = 'FadeByTime';
	PrimitiveScalarParamFadeDistName = 'FadeByDistance';
	DetailedScalarParamFadeDistName = 'FadeByDistance';
	PrimitiveVectorParamColorName = 'selectColor';
	PrimitiveMesh = Spawn(Class'Engine.SkeletalMeshActorSpawnable', self,, Location, Rotation,, true);
	PrimitiveMesh.SkeletalMeshComponent.SetSkeletalMesh(CInfo.PrimitiveMesh);
	PrimitiveMesh.SetHidden(true);
	I = 0;
	J0x148:

	// End:0x23E [Loop If]
	if(I < PrimitiveMesh.SkeletalMeshComponent.GetNumElements())
	{
		PrimitiveMesh.SkeletalMeshComponent.SetMaterial(I, CManager.GetDistortionMaterial());
		DistortionMICs.AddItem(PrimitiveMesh.SkeletalMeshComponent.CreateAndSetMaterialInstanceConstant(I));
		++I;
		// [Loop Continue]
		goto J0x148;
	}
	DetailedMesh = Spawn(Class'MegaHaloGame.HaloDynamicSMActor_Spawnable', self,, Location, Rotation,, true);
	DetailedMesh.StaticMeshComponent.SetStaticMesh(CInfo.DetailedMesh);
	DetailedMesh.SetHidden(true);
	DetailedMesh.SetCollisionType(1);
	DefaultLightingChannels = DetailedMesh.StaticMeshComponent.LightingChannels;
	I = 0;
	J0x34C:

	// End:0x499 [Loop If]
	if(I < DetailedMesh.StaticMeshComponent.GetNumElements())
	{
		DetailedMesh.StaticMeshComponent.SetMaterial(I, CManager.GetHologramMaterial());
		MIC = DetailedMesh.StaticMeshComponent.CreateAndSetMaterialInstanceConstant(I);
		HologramMICs.AddItem(MIC);
		MIC.SetTextureParameterValue('EMIS_Texture', CInfo.TextureParameter);
		++I;
		// [Loop Continue]
		goto J0x34C;
	}
	I = 0;
	J0x4A4:

	// End:0x5F1 [Loop If]
	if(I < DetailedMesh.StaticMeshComponent.GetNumElements())
	{
		DetailedMesh.StaticMeshComponent.SetMaterial(I, CManager.GetPrimitiveClearMaterial());
		MIC = DetailedMesh.StaticMeshComponent.CreateAndSetMaterialInstanceConstant(I);
		ClearMICs.AddItem(MIC);
		MIC.SetTextureParameterValue('EMIS_Texture', CInfo.TextureParameter);
		++I;
		// [Loop Continue]
		goto J0x4A4;
	}
	I = 0;
	J0x5FC:

	// End:0x749 [Loop If]
	if(I < DetailedMesh.StaticMeshComponent.GetNumElements())
	{
		DetailedMesh.StaticMeshComponent.SetMaterial(I, CManager.GetSolidConstructionObjectMaterial());
		MIC = DetailedMesh.StaticMeshComponent.CreateAndSetMaterialInstanceConstant(I);
		SolidMICs.AddItem(MIC);
		MIC.SetTextureParameterValue('EMIS_Texture', CInfo.TextureParameter);
		++I;
		// [Loop Continue]
		goto J0x5FC;
	}
	SocketMesh = Spawn(Class'Engine.SkeletalMeshActorSpawnable', self,, Location, Rotation,, true);
	SocketMesh.SkeletalMeshComponent.SkeletalMesh = CInfo.SocketMesh;
	SocketMesh.SetHidden(true);
	//return;	
}

function InitSocketPrimitives()
{
	InitSuccessSocketPrimitives();
	InitErrorSocketPrimitives();
	// End:0x37
	if(int(CType) == int(0))
	{
		SocketPrimitiveIndex = 4;		
	}
	else
	{
		SocketPrimitiveIndex = 0;
	}
	SetMaterialSocketPrimitiveClearSelected(SocketPrimitiveIndex);
	SocketMesh.SetHidden(true);
	//return;	
}

function InitSuccessSocketPrimitives()
{
	local SkeletalMeshSocket Socket;
	local HaloConstructionManager.EHaloConstructionPrimitiveTypes PrimitiveType;
	local array<string> strs, Params;
	local string Type;
	local int Index, numValidSockets;
	local Vector primLoc;
	local Rotator primRot;
	local Matrix primMat, meshMat;
	local int I;
	local MaterialInstanceTimeVarying MITV;
	local MaterialInstanceConstant MIC;

	// End:0x11
	if(CManager == none)
	{
		return;
	}
	// End:0x106
	foreach SocketMesh.SkeletalMeshComponent.SkeletalMesh.Sockets(Socket)
	{
		strs = SplitString(string(Socket.SocketName), "_", true);
		Type = strs[1];
		PrimitiveType = CManager.GetConstructionPrimitiveTypeFromString(Type);
		// End:0x105
		if(int(PrimitiveType) != int(7))
		{
			numValidSockets++;
		}		
	}	
	SocketPrimitives.Length = numValidSockets;
	SocketPrimitivesSolid.Length = numValidSockets;
	// End:0x14B5
	foreach SocketMesh.SkeletalMeshComponent.SkeletalMesh.Sockets(Socket)
	{
		strs = SplitString(string(Socket.SocketName), "_", true);
		Index = int(strs[0]);
		Index--;
		Type = strs[1];
		PrimitiveType = CManager.GetConstructionPrimitiveTypeFromString(Type);
		// End:0x23E
		if(int(PrimitiveType) == int(7))
		{
			continue;			
		}
		else
		{
			// End:0x39E
			if(strs.Length > 2)
			{
				Params = SplitString(strs[2], "(", true);
				Params = SplitString(Params[0], ")", true);
				Params = SplitString(Params[0], ",", true);
				I = 0;
				J0x2C4:

				// End:0x39E [Loop If]
				if(I < Params.Length)
				{
					// End:0x390
					if(Params[I] != "#")
					{
						switch(I)
						{
							// End:0x34D
							case 0:
								SocketPrimitives[Index].MinCameraDegree = int(Params[I]);
								// End:0x390
								break;
							// End:0x38D
							case 1:
								SocketPrimitives[Index].MaxCameraDegree = int(Params[I]);
							// End:0xFFFF
							default:
								break;
						}
					}
					else
					{
						I++;
						// [Loop Continue]
						goto J0x2C4;
					}/* !MISMATCHING REMOVE, tried Loop got Type:Else Position:0x390! */
				}/* !MISMATCHING REMOVE, tried If got Type:Loop Position:0x2C4! */
				SocketPrimitives[Index].Actor = Spawn(Class'Engine.SkeletalMeshActorSpawnable', self,,, Socket.RelativeRotation,, true);
				SocketPrimitives[Index].Actor.SkeletalMeshComponent.SetSkeletalMesh(CManager.GetPrimitiveMeshFromType(PrimitiveType));
				SocketPrimitives[Index].Actor.SkeletalMeshComponent.SetScale3D(Socket.RelativeScale);
				SocketPrimitives[Index].Actor.SkeletalMeshComponent.SetPhysicsAsset(CManager.GetPhysicsAssetFromType(PrimitiveType), true);
				SocketPrimitives[Index].Actor.SkeletalMeshComponent.SetLightingChannels(NewLightingChannels);
				SocketPrimitives[Index].Actor.AttachComponent(ConstructionLightEnvironment);
				SocketPrimitives[Index].Actor.SkeletalMeshComponent.SetLightEnvironment(ConstructionLightEnvironment);
				SocketPrimitives[Index].Actor.SetPhysics(7);
				SocketPrimitives[Index].BaseScale = Socket.RelativeScale;
				SocketPrimitives[Index].Actor.SetLocation(Socket.RelativeLocation);
				primMat = MakeRotationTranslationMatrix(SocketPrimitives[Index].Actor.Location, SocketPrimitives[Index].Actor.Rotation);
				meshMat = MakeRotationMatrix(SocketMesh.Rotation);
				primMat = Multiply_MatrixMatrix(primMat, meshMat);
				primRot = MatrixGetRotator(primMat);
				SocketPrimitives[Index].Actor.SetRotation(primRot);
				primLoc = MatrixGetOrigin(primMat);
				SocketPrimitives[Index].Actor.SetLocation(primLoc);
				primLoc = SocketPrimitives[Index].Actor.Location;
				primLoc += SocketMesh.Location;
				SocketPrimitives[Index].Actor.SetLocation(primLoc);
				I = 0;
				J0x976:

				// End:0xB52 [Loop If]
				if(I < SocketPrimitives[Index].Actor.SkeletalMeshComponent.GetNumElements())
				{
					SocketPrimitives[Index].Actor.SkeletalMeshComponent.SetMaterial(I, CManager.GetPrimitiveSelectedMaterial());
					MIC = SocketPrimitives[Index].Actor.SkeletalMeshComponent.CreateAndSetMaterialInstanceConstant(I);
					// End:0xB44
					if(MIC != none)
					{
						MIC.SetTextureParameterValue('EMIS_Texture', CManager.GetPrimitiveTextureFromType(PrimitiveType));
						SocketPrimitives[Index].PrimitiveClearMICs.AddItem(MIC);
					}
					I++;
					// [Loop Continue]
					goto J0x976;
				}
				SocketPrimitives[Index].SocketIndex = Index;
				SocketPrimitives[Index].PrimitiveType = PrimitiveType;
				SocketPrimitives[Index].Actor.SetHidden(true);
				strs = SplitString(string(Socket.SocketName), "_", true);
				Index = int(strs[0]);
				Index--;
				Type = strs[1];
				PrimitiveType = CManager.GetConstructionPrimitiveTypeFromString(Type);
				// End:0xCA8
				if(int(PrimitiveType) == int(7))
				{
					continue;					
				}
				else
				{
					SocketPrimitivesSolid[Index].Actor = Spawn(Class'Engine.SkeletalMeshActorSpawnable', self,,, Socket.RelativeRotation,, true);
					SocketPrimitivesSolid[Index].Actor.SkeletalMeshComponent.SetSkeletalMesh(CManager.GetPrimitiveMeshFromType(PrimitiveType));
					SocketPrimitivesSolid[Index].Actor.SkeletalMeshComponent.SetScale3D(Socket.RelativeScale);
					SocketPrimitivesSolid[Index].Actor.SkeletalMeshComponent.SetPhysicsAsset(CManager.GetPhysicsAssetFromType(PrimitiveType), true);
					SocketPrimitivesSolid[Index].Actor.SkeletalMeshComponent.SetLightingChannels(NewLightingChannels);
					SocketPrimitivesSolid[Index].Actor.SkeletalMeshComponent.SetLightEnvironment(ConstructionLightEnvironment);
					SocketPrimitivesSolid[Index].Actor.AttachComponent(ConstructionLightEnvironment);
					SocketPrimitivesSolid[Index].Actor.SetPhysics(7);
					SocketPrimitivesSolid[Index].Actor.SetLocation(Socket.RelativeLocation);
					primMat = MakeRotationTranslationMatrix(SocketPrimitivesSolid[Index].Actor.Location, SocketPrimitivesSolid[Index].Actor.Rotation);
					meshMat = MakeRotationMatrix(SocketMesh.Rotation);
					primMat = Multiply_MatrixMatrix(primMat, meshMat);
					primRot = MatrixGetRotator(primMat);
					SocketPrimitivesSolid[Index].Actor.SetRotation(primRot);
					primLoc = MatrixGetOrigin(primMat);
					SocketPrimitivesSolid[Index].Actor.SetLocation(primLoc);
					primLoc = SocketPrimitivesSolid[Index].Actor.Location;
					primLoc += SocketMesh.Location;
					SocketPrimitivesSolid[Index].Actor.SetLocation(primLoc);
					I = 0;
					J0x123B:

					// End:0x1417 [Loop If]
					if(I < SocketPrimitivesSolid[Index].Actor.SkeletalMeshComponent.GetNumElements())
					{
						SocketPrimitivesSolid[Index].Actor.SkeletalMeshComponent.SetMaterial(I, CManager.GetPrimitiveSolidMaterial());
						MITV = SocketPrimitivesSolid[Index].Actor.SkeletalMeshComponent.CreateAndSetMaterialInstanceTimeVarying(I);
						// End:0x1409
						if(MITV != none)
						{
							MITV.SetTextureParameterValue('EMIS_Texture', CManager.GetPrimitiveTextureFromType(PrimitiveType));
							SocketPrimitivesSolid[Index].SuccessMITVs.AddItem(MITV);
						}
						I++;
						// [Loop Continue]
						goto J0x123B;
					}
					SocketPrimitivesSolid[Index].SocketIndex = Index;
					SocketPrimitivesSolid[Index].PrimitiveType = PrimitiveType;
					SocketPrimitivesSolid[Index].Actor.SetHidden(true);					
				}
			}/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x23E! */
		}/* !MISMATCHING REMOVE, tried ForEach got Type:Else Position:0x23E! */		
		//return;		
	}/* !MISMATCHING REMOVE, tried Else got Type:ForEach Position:0x12F! */
}

function InitErrorSocketPrimitives()
{
	local array<HaloConstructionManager.EHaloConstructionPrimitiveTypes> primitiveTypes;
	local HaloConstructionManager.EHaloConstructionPrimitiveTypes PrimitiveType;
	local MaterialInstanceTimeVarying MITV;
	local int I;

	// End:0x11
	if(CManager == none)
	{
		return;
	}
	primitiveTypes.AddItem(0);
	primitiveTypes.AddItem(1);
	primitiveTypes.AddItem(2);
	primitiveTypes.AddItem(3);
	primitiveTypes.AddItem(4);
	primitiveTypes.AddItem(5);
	primitiveTypes.AddItem(6);
	SocketErrorPrimitives.Length = primitiveTypes.Length;
	// End:0x548
	foreach primitiveTypes(PrimitiveType)
	{
		SocketErrorPrimitives[int(PrimitiveType)].Actor = Spawn(Class'Engine.SkeletalMeshActorSpawnable', self,,,,, true);
		SocketErrorPrimitives[int(PrimitiveType)].Actor.SkeletalMeshComponent.SetSkeletalMesh(CManager.GetPrimitiveMeshFromType(PrimitiveType));
		SocketErrorPrimitives[int(PrimitiveType)].Actor.SkeletalMeshComponent.SetPhysicsAsset(CManager.GetPhysicsAssetFromType(PrimitiveType), true);
		SocketErrorPrimitives[int(PrimitiveType)].Actor.SetPhysics(7);
		SocketErrorPrimitives[int(PrimitiveType)].Actor.SkeletalMeshComponent.SetLightingChannels(NewLightingChannels);
		SocketErrorPrimitives[int(PrimitiveType)].Actor.SkeletalMeshComponent.SetLightEnvironment(ConstructionLightEnvironment);
		SocketErrorPrimitives[int(PrimitiveType)].Actor.AttachComponent(ConstructionLightEnvironment);
		I = 0;
		J0x324:

		// End:0x508 [Loop If]
		if(I < SocketErrorPrimitives[int(PrimitiveType)].Actor.SkeletalMeshComponent.GetNumElements())
		{
			SocketErrorPrimitives[int(PrimitiveType)].Actor.SkeletalMeshComponent.SetMaterial(I, CManager.GetErrorPrimitiveMaterial());
			MITV = SocketErrorPrimitives[int(PrimitiveType)].Actor.SkeletalMeshComponent.CreateAndSetMaterialInstanceTimeVarying(I);
			// End:0x4FA
			if(MITV != none)
			{
				MITV.SetTextureParameterValue('EMIS_Texture', CManager.GetPrimitiveTextureFromType(PrimitiveType));
				SocketErrorPrimitives[int(PrimitiveType)].ErrorMITVs.AddItem(MITV);
			}
			I++;
			// [Loop Continue]
			goto J0x324;
		}
		SocketErrorPrimitives[int(PrimitiveType)].Actor.SetHidden(true);		
	}	
	//return;	
}

function DestroySocketPrimitives()
{
	local HaloSocketPrimitive Obj;

	TrailFX.DetachFromAny();
	ErrorTrailFX.DetachFromAny();
	// End:0xC1
	foreach SocketPrimitives(Obj)
	{
		// End:0xC0
		if(Obj.Actor != none)
		{
			Obj.Actor.Destroy();
			Obj.Actor = none;
		}		
	}	
	SocketPrimitives.Remove(0, SocketPrimitives.Length);
	// End:0x15B
	foreach SocketPrimitivesSolid(Obj)
	{
		// End:0x15A
		if(Obj.Actor != none)
		{
			Obj.Actor.Destroy();
			Obj.Actor = none;
		}		
	}	
	SocketPrimitivesSolid.Remove(0, SocketPrimitivesSolid.Length);
	//return;	
}

function ConstructionStart()
{
	SocketPrimitiveIndex = 0;
	SetMaterialSocketPrimitiveClearSelected(SocketPrimitiveIndex, false);
	// End:0x88
	if(CManager != none)
	{
		CManager.FocusConstructionCamera(SocketPrimitives[SocketPrimitiveIndex].Actor.Location);
	}
	//return;	
}

function HideAllMeshes()
{
	ShowGlitchMesh(false);
	ShowPrimitiveMesh(false);
	ShowDetailedMesh(false);
	//return;	
}

function ForceHideAllMeshes()
{
	SocketMesh.SetHidden(true);
	PrimitiveMesh.SetHidden(true);
	DetailedMesh.SetHidden(true);
	bShowPrimitiveMesh = false;
	PrimitiveMeshFadePct = 0.0000000;
	bShowDetailedMesh = false;
	DetailedMeshFadePct = 0.0000000;
	//return;	
}

function ShowGlitchMesh(bool show)
{
	local int I;

	// End:0xEE
	if(CManager != none)
	{
		// End:0xEE
		if(PrimitiveMesh != none)
		{
			// End:0xD9
			if(show == true)
			{
				I = 0;
				J0x39:

				// End:0xD9 [Loop If]
				if(I < PrimitiveMesh.SkeletalMeshComponent.GetNumElements())
				{
					PrimitiveMesh.SkeletalMeshComponent.SetMaterial(I, DistortionMICs[I]);
					I++;
					// [Loop Continue]
					goto J0x39;
				}
			}
			bShowPrimitiveMesh = show;
		}
	}
	//return;	
}

function PositionGlitchMesh(Vector glitchLocation, Rotator glitchRotation)
{
	// End:0x51
	if(PrimitiveMesh != none)
	{
		PrimitiveMesh.SetLocation(glitchLocation);
		PrimitiveMesh.SetRotation(glitchRotation);
	}
	// End:0xA2
	if(SocketMesh != none)
	{
		SocketMesh.SetLocation(glitchLocation);
		SocketMesh.SetRotation(glitchRotation);
	}
	//return;	
}

function ShowPrimitiveMesh(bool show)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x8C [Loop If]
	if(I < SocketPrimitives.Length)
	{
		SetMaterialSocketPrimitiveClear(I);
		SocketPrimitives[I].Actor.SetHidden(!show);
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function PositionPrimitiveMesh(Vector primitiveLocation, Rotator primitiveRotation)
{
	PositionGlitchMesh(primitiveLocation, primitiveRotation);
	//return;	
}

function TickPrimitiveMeshFade(float DeltaTime)
{
	local float prevPct;
	local bool fadeUpdate;
	local int I;
	local MaterialInstanceConstant Mat;

	// End:0x388
	if((PrimitiveMesh != none) && CManager != none)
	{
		prevPct = PrimitiveMeshFadePct;
		// End:0xD1
		if((bShowPrimitiveMesh == true) && PrimitiveMeshFadePct < 1.0000000)
		{
			PrimitiveMeshFadePct = FMin(1.0000000, PrimitiveMeshFadePct + ((1.0000000 / FadeTimeInSec) * DeltaTime));
			// End:0xC2
			if(prevPct <= 0.0000000)
			{
				PrimitiveMesh.SetHidden(false);
			}
			fadeUpdate = true;			
		}
		else
		{
			// End:0x18C
			if((bShowPrimitiveMesh == false) && PrimitiveMeshFadePct > 0.0000000)
			{
				PrimitiveMeshFadePct = FMax(0.0000000, PrimitiveMeshFadePct - ((1.0000000 / FadeTimeInSec) * DeltaTime));
				// End:0x180
				if(PrimitiveMeshFadePct <= 0.0000000)
				{
					PrimitiveMesh.SetHidden(true);
					CManager.SetViewableBuildPadTrigger(none);
				}
				fadeUpdate = true;
			}
		}
		// End:0x287
		if(fadeUpdate == true)
		{
			I = 0;
			J0x1A7:

			// End:0x287 [Loop If]
			if(I < PrimitiveMesh.SkeletalMeshComponent.GetNumElements())
			{
				Mat = MaterialInstanceConstant(PrimitiveMesh.SkeletalMeshComponent.GetMaterial(I));
				// End:0x279
				if(Mat != none)
				{
					Mat.SetScalarParameterValue(PrimitiveScalarParamFadeTimeName, PrimitiveMeshFadePct);
				}
				++I;
				// [Loop Continue]
				goto J0x1A7;
			}
		}
		I = 0;
		J0x292:

		// End:0x388 [Loop If]
		if(I < PrimitiveMesh.SkeletalMeshComponent.GetNumElements())
		{
			Mat = MaterialInstanceConstant(PrimitiveMesh.SkeletalMeshComponent.GetMaterial(I));
			// End:0x37A
			if(Mat != none)
			{
				Mat.SetScalarParameterValue(PrimitiveScalarParamFadeDistName, CManager.GetActivatorBuildTriggerDistanceRatio());
			}
			++I;
			// [Loop Continue]
			goto J0x292;
		}
	}
	//return;	
}

function BoxSphereBounds GetPrimitiveMeshBounds()
{
	// End:0x58
	if(PrimitiveMesh != none)
	{
		return PrimitiveMesh.SkeletalMeshComponent.SkeletalMesh.Bounds;
	}
	//return ReturnValue;	
}

function Rotator GetPrimitiveMeshOriginRotation()
{
	// End:0x58
	if(PrimitiveMesh != none)
	{
		return PrimitiveMesh.SkeletalMeshComponent.SkeletalMesh.RotOrigin;
	}
	//return ReturnValue;	
}

function ShowDetailedHologramMesh(bool show)
{
	local int I;

	// End:0x11C
	if(DetailedMesh != none)
	{
		// End:0x107
		if(show == true)
		{
			I = 0;
			J0x2A:

			// End:0xCA [Loop If]
			if(I < DetailedMesh.StaticMeshComponent.GetNumElements())
			{
				DetailedMesh.StaticMeshComponent.SetMaterial(I, HologramMICs[I]);
				I++;
				// [Loop Continue]
				goto J0x2A;
			}
			DetailedMesh.StaticMeshComponent.SetLightingChannels(DefaultLightingChannels);
		}
		bShowDetailedMesh = show;
	}
	//return;	
}

function ShowDetailedPrimitiveClearMesh(bool show)
{
	local int I;

	// End:0x12D
	if((DetailedMesh != none) && CManager != none)
	{
		// End:0x118
		if(show == true)
		{
			I = 0;
			J0x3B:

			// End:0xDB [Loop If]
			if(I < DetailedMesh.StaticMeshComponent.GetNumElements())
			{
				DetailedMesh.StaticMeshComponent.SetMaterial(I, ClearMICs[I]);
				I++;
				// [Loop Continue]
				goto J0x3B;
			}
			DetailedMesh.StaticMeshComponent.SetLightingChannels(NewLightingChannels);
		}
		bShowDetailedMesh = show;
	}
	//return;	
}

function ShowDetailedMesh(bool show)
{
	local int I;

	// End:0x146
	if(DetailedMesh != none)
	{
		// End:0x131
		if(show == true)
		{
			I = 0;
			J0x2A:

			// End:0xF4 [Loop If]
			if(I < DetailedMesh.StaticMeshComponent.GetNumElements())
			{
				DetailedMesh.StaticMeshComponent.SetMaterial(I, default.DetailedMesh.StaticMeshComponent.GetMaterial(I));
				I++;
				// [Loop Continue]
				goto J0x2A;
			}
			DetailedMesh.StaticMeshComponent.SetLightingChannels(DefaultLightingChannels);
		}
		bShowDetailedMesh = show;
	}
	//return;	
}

function PositionDetailedMesh(Vector detailedLocation, Rotator detailedRotation)
{
	// End:0x51
	if(DetailedMesh != none)
	{
		DetailedMesh.SetLocation(detailedLocation);
		DetailedMesh.SetRotation(detailedRotation);
	}
	//return;	
}

function TickDetailedMeshFade(float DeltaTime)
{
	local float prevPct;
	local bool fadeUpdate;
	local int I;
	local MaterialInstanceConstant Mat;

	// End:0x388
	if((DetailedMesh != none) && CManager != none)
	{
		prevPct = DetailedMeshFadePct;
		// End:0xD1
		if((bShowDetailedMesh == true) && DetailedMeshFadePct < 1.0000000)
		{
			DetailedMeshFadePct = FMin(1.0000000, DetailedMeshFadePct + ((1.0000000 / FadeTimeInSec) * DeltaTime));
			// End:0xC2
			if(prevPct <= 0.0000000)
			{
				DetailedMesh.SetHidden(false);
			}
			fadeUpdate = true;			
		}
		else
		{
			// End:0x18C
			if((bShowDetailedMesh == false) && DetailedMeshFadePct > 0.0000000)
			{
				DetailedMeshFadePct = FMax(0.0000000, DetailedMeshFadePct - ((1.0000000 / FadeTimeInSec) * DeltaTime));
				// End:0x180
				if(DetailedMeshFadePct <= 0.0000000)
				{
					DetailedMesh.SetHidden(true);
					CManager.SetViewableBuildPadTrigger(none);
				}
				fadeUpdate = true;
			}
		}
		// End:0x287
		if(fadeUpdate == true)
		{
			I = 0;
			J0x1A7:

			// End:0x287 [Loop If]
			if(I < DetailedMesh.StaticMeshComponent.GetNumElements())
			{
				Mat = MaterialInstanceConstant(DetailedMesh.StaticMeshComponent.GetMaterial(I));
				// End:0x279
				if(Mat != none)
				{
					Mat.SetScalarParameterValue(DetailedScalarParamFadeTimeName, DetailedMeshFadePct);
				}
				++I;
				// [Loop Continue]
				goto J0x1A7;
			}
		}
		I = 0;
		J0x292:

		// End:0x388 [Loop If]
		if(I < DetailedMesh.StaticMeshComponent.GetNumElements())
		{
			Mat = MaterialInstanceConstant(DetailedMesh.StaticMeshComponent.GetMaterial(I));
			// End:0x37A
			if(Mat != none)
			{
				Mat.SetScalarParameterValue(DetailedScalarParamFadeDistName, CManager.GetActivatorBuildTriggerDistanceRatio());
			}
			++I;
			// [Loop Continue]
			goto J0x292;
		}
	}
	//return;	
}

function SetMeshMaterial(MeshComponent MeshComp, MaterialInstance materialTemplate, bool bAll, optional int ElementIndex)
{
	local int I;

	// End:0xA8
	if(bAll)
	{
		// End:0xA5
		if((MeshComp != none) && materialTemplate != none)
		{
			I = 0;
			J0x39:

			// End:0xA5 [Loop If]
			if(I < MeshComp.GetNumElements())
			{
				MeshComp.SetMaterial(I, materialTemplate);
				I++;
				// [Loop Continue]
				goto J0x39;
			}
		}		
	}
	else
	{
		// End:0xF9
		if((MeshComp != none) && materialTemplate != none)
		{
			MeshComp.SetMaterial(ElementIndex, materialTemplate);
		}
	}
	//return;	
}

simulated function Vector GetDimensionsForPrimitive(Actor primitiveBlokActor, Vector BaseScale)
{
	local Vector dimensions;
	local editinline MeshComponent MeshComp;

	MeshComp = MeshComponent(primitiveBlokActor.GetComponentOfType(Class'Engine.MeshComponent'));
	// End:0x1C7
	if(MeshComp != none)
	{
		dimensions.X = MeshComp.Bounds.BoxExtent.X * BaseScale.X;
		dimensions.Y = MeshComp.Bounds.BoxExtent.Y * BaseScale.Y;
		dimensions.Z = MeshComp.Bounds.BoxExtent.Z * BaseScale.Z;
	}
	return dimensions;
	//return ReturnValue;	
}

function BuildConstructionObject()
{
	local Vector padLocation;
	local Rotator padRotation;

	// End:0x40
	if(CManager != none)
	{
		CManager.GetBuildPadLocationRotation(padLocation, padRotation);
	}
	WorldObj = Spawn(Class'MegaHaloGame.HaloDynamicSMActor_Spawnable', self,, padLocation, padRotation,, true);
	WorldObj.SetStaticMesh(CInfo.DetailedMeshFinal);
	// End:0x142
	if(WorldObj.StaticMeshComponent != none)
	{
		WorldObj.StaticMeshComponent.SetRBCollidesWithChannel(2, true);
		WorldObj.StaticMeshComponent.SetBlockRigidBody(true);
	}
	// End:0x170
	if(int(CType) == int(2))
	{
		WorldObj.SetPhysics(7);
	}
	//return;	
}

simulated function StartMagicMoment()
{
	PlayMagicMoment(CInfo.MagicMomentAnim, WorldObj);
	WorldObj = none;
	//return;	
}

simulated function bool PlayMagicMoment2(name MMAnim, SkeletalMeshActorSpawnable Mesh)
{
	local AnimNodeSequence Node;

	// End:0xD1
	if((Mesh != none) && MMAnim != 'None')
	{
		Node = AnimNodeSequence(Mesh.SkeletalMeshComponent.Animations);
		// End:0xD1
		if(Node != none)
		{
			Node.SetAnim(MMAnim);
			Node.PlayAnim(false, 1.0000000, 0.0000000);
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

simulated function bool PlayMagicMoment(name MagicMomentEventName, Actor spawnedObj)
{
	local array<SequenceObject> AllSeqEvents;
	local Sequence GameSeq;
	local int I;

	GameSeq = WorldInfo.GetGameSequence();
	// End:0x129
	if(GameSeq != none)
	{
		GameSeq.FindSeqObjectsByClass(Class'Engine.SeqEvent_RemoteEvent', true, AllSeqEvents);
		I = 0;
		J0x75:

		// End:0x129 [Loop If]
		if(I < AllSeqEvents.Length)
		{
			// End:0x11B
			if(SeqEvent_RemoteEvent(AllSeqEvents[I]).EventName == MagicMomentEventName)
			{
				// End:0x118
				if(SeqEvent_RemoteEvent(AllSeqEvents[I]).CheckActivate(WorldInfo, spawnedObj))
				{
					return true;
				}
				// [Explicit Break]
				goto J0x129;
			}
			I++;
			// [Loop Continue]
			goto J0x75;
		}
	}
	J0x129:

	return false;
	//return ReturnValue;	
}

function Tick(float DeltaTime)
{
	// End:0x190
	if((CManager != none) && CManager.HasActiveBuildPadTrigger() || CManager.HasViewableBuildPadTrigger())
	{
		// End:0x126
		if((((CManager.IsActive() == false) && int(CManager.GetViewableType()) == int(CType)) && CManager.HasActiveBuildPadTrigger() == false) && CManager.IsComplete() == false)
		{
			TickPrimitiveMeshFade(DeltaTime);
			TickDetailedMeshFade(DeltaTime);			
		}
		else
		{
			// End:0x190
			if(int(CManager.GetActiveType()) == int(CType))
			{
				TickSelectedSocketPrimitive(DeltaTime);
				TickPrimitiveSliding(DeltaTime);
				TickErrorPrimitiveSliding(DeltaTime);
			}
		}
	}
	//return;	
}

function TickPrimitiveSliding(float DeltaTime)
{
	local int I;
	local Vector NewPos, targetPos, fxBlockScale;

	I = 0;
	J0x0B:

	// End:0xC26 [Loop If]
	if(I < SocketPrimitivesSolid.Length)
	{
		// End:0x893
		if(SocketPrimitivesSolid[I].bIsSliding_Z == true)
		{
			// End:0x33B
			if(SocketPrimitivesSolid[I].SlidingHalfHeight > 0.0000000)
			{
				NewPos = SocketPrimitivesSolid[I].Actor.Location;
				NewPos.Z = Lerp(NewPos.Z, SocketPrimitivesSolid[I].SlidingHalfHeight, DeltaTime * 15.0000000);
				SocketPrimitivesSolid[I].Actor.SetLocation(NewPos);
				// End:0x338
				if((SocketPrimitivesSolid[I].Actor.Location.Z - SocketPrimitivesSolid[I].SlidingHalfHeight) < 25.0000000)
				{
					NewPos = SocketPrimitivesSolid[I].Actor.Location;
					NewPos.Z = SocketPrimitivesSolid[I].SlidingHalfHeight;
					SocketPrimitivesSolid[I].Actor.SetLocation(NewPos);
					SocketPrimitivesSolid[I].bIsSliding_Z = false;
					SocketPrimitivesSolid[I].bIsSliding_XY = true;
					SocketPrimitivesSolid[I].SlidingHalfHeight = 0.0000000;
				}				
			}
			else
			{
				NewPos = SocketPrimitivesSolid[I].Actor.Location;
				NewPos.Z = FInterpEaseOut(NewPos.Z, SocketPrimitives[I].Actor.Location.Z, DeltaTime * 5.0000000, 1.1000000);
				SocketPrimitivesSolid[I].Actor.SetLocation(NewPos);
				// End:0x890
				if((SocketPrimitivesSolid[I].Actor.Location.Z - SocketPrimitives[I].Actor.Location.Z) < 50.0000000)
				{
					NewPos = SocketPrimitivesSolid[I].Actor.Location;
					NewPos.Z = SocketPrimitives[I].Actor.Location.Z;
					SocketPrimitivesSolid[I].Actor.SetLocation(NewPos);
					CManager.PlayAttachPrimitiveSuccessSound();
					SocketPrimitivesSolid[I].bIsSliding_Z = false;
					// End:0x670
					if(CManager != none)
					{
						CManager.ForceErrorRumble();
					}
					TrailFX.SetActive(false);
					fxBlockScale = GetDimensionsForPrimitive(SocketPrimitives[SocketPrimitiveIndex].Actor, SocketPrimitives[SocketPrimitiveIndex].BaseScale);
					SplashFX.SetVectorParameter('BlockScale', fxBlockScale);
					SplashFX.SetAbsolute(true, true, true);
					SplashFX.SetTranslation(SocketPrimitives[SocketPrimitiveIndex].Actor.Location);
					SplashFX.SetActive(true, false);
					SocketPrimitivesSolid[I].Actor.SetHidden(true);
					SocketPrimitives[SocketPrimitiveIndex].bShowPrimitive = true;
					bLockControls = false;
					// End:0x890
					if(DetailedMesh != none)
					{
						DetailedMesh.StaticMeshComponent.SetMaterial(I, SolidMICs[I]);
					}
				}
			}			
		}
		else
		{
			// End:0xC18
			if(SocketPrimitivesSolid[I].bIsSliding_XY == true)
			{
				targetPos = SocketPrimitives[I].Actor.Location;
				targetPos.Z = SocketPrimitivesSolid[I].Actor.Location.Z;
				NewPos = VInterpTo(SocketPrimitivesSolid[I].Actor.Location, targetPos, DeltaTime * 9.5000000, 1.2000000);
				SocketPrimitivesSolid[I].Actor.SetLocation(NewPos);
				// End:0xC18
				if(VSize(targetPos - SocketPrimitivesSolid[I].Actor.Location) < 25.0000000)
				{
					NewPos = SocketPrimitivesSolid[I].Actor.Location;
					NewPos.X = SocketPrimitives[I].Actor.Location.X;
					NewPos.Y = SocketPrimitives[I].Actor.Location.Y;
					SocketPrimitivesSolid[I].Actor.SetLocation(NewPos);
					SocketPrimitivesSolid[I].bIsSliding_XY = false;
					SocketPrimitivesSolid[I].bIsSliding_Z = true;
				}
			}
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function TickErrorPrimitiveSliding(float DeltaTime)
{
	local int I;
	local Vector NewPos, targetPos;

	I = 0;
	J0x0B:

	// End:0xA6B [Loop If]
	if(I < SocketErrorPrimitives.Length)
	{
		// End:0x6D8
		if(SocketErrorPrimitives[I].bIsSliding_Z == true)
		{
			// End:0x33B
			if(SocketErrorPrimitives[I].SlidingHalfHeight > 0.0000000)
			{
				NewPos = SocketErrorPrimitives[I].Actor.Location;
				NewPos.Z = Lerp(NewPos.Z, SocketErrorPrimitives[I].SlidingHalfHeight, DeltaTime * 15.0000000);
				SocketErrorPrimitives[I].Actor.SetLocation(NewPos);
				// End:0x338
				if((SocketErrorPrimitives[I].Actor.Location.Z - SocketErrorPrimitives[I].SlidingHalfHeight) < 25.0000000)
				{
					NewPos = SocketErrorPrimitives[I].Actor.Location;
					NewPos.Z = SocketErrorPrimitives[I].SlidingHalfHeight;
					SocketErrorPrimitives[I].Actor.SetLocation(NewPos);
					SocketErrorPrimitives[I].bIsSliding_Z = false;
					SocketErrorPrimitives[I].bIsSliding_XY = true;
					SocketErrorPrimitives[I].SlidingHalfHeight = 0.0000000;
				}				
			}
			else
			{
				NewPos = SocketErrorPrimitives[I].Actor.Location;
				NewPos.Z = FInterpEaseOut(NewPos.Z, SocketPrimitives[I].Actor.Location.Z, DeltaTime * 5.0000000, 1.1000000);
				SocketErrorPrimitives[I].Actor.SetLocation(NewPos);
				// End:0x6D5
				if((SocketErrorPrimitives[I].Actor.Location.Z - SocketPrimitives[I].Actor.Location.Z) < 50.0000000)
				{
					NewPos = SocketErrorPrimitives[I].Actor.Location;
					NewPos.Z = SocketPrimitives[I].Actor.Location.Z;
					SocketErrorPrimitives[I].Actor.SetLocation(NewPos);
					CManager.PlayAttachPrimitiveErrorSound();
					SocketErrorPrimitives[I].bIsSliding_Z = false;
					ErrorTrailFX.SetActive(false);
					SocketErrorPrimitives[I].Actor.SetHidden(true);
					SocketPrimitives[SocketPrimitiveIndex].bShowPrimitive = true;
					bLockControls = false;
				}
			}			
		}
		else
		{
			// End:0xA5D
			if(SocketErrorPrimitives[I].bIsSliding_XY == true)
			{
				targetPos = SocketPrimitives[I].Actor.Location;
				targetPos.Z = SocketErrorPrimitives[I].Actor.Location.Z;
				NewPos = VInterpTo(SocketErrorPrimitives[I].Actor.Location, targetPos, DeltaTime * 9.5000000, 1.2000000);
				SocketErrorPrimitives[I].Actor.SetLocation(NewPos);
				// End:0xA5D
				if(VSize(targetPos - SocketErrorPrimitives[I].Actor.Location) < 25.0000000)
				{
					NewPos = SocketErrorPrimitives[I].Actor.Location;
					NewPos.X = SocketPrimitives[I].Actor.Location.X;
					NewPos.Y = SocketPrimitives[I].Actor.Location.Y;
					SocketErrorPrimitives[I].Actor.SetLocation(NewPos);
					SocketErrorPrimitives[I].bIsSliding_XY = false;
					SocketErrorPrimitives[I].bIsSliding_Z = true;
				}
			}
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function TickSelectedSocketPrimitive(float DeltaTime)
{
	local Vector NewScale;
	local float prevPct;
	local bool needFadeUpdate, needColorUpdate;
	local int I;
	local MaterialInstanceConstant MIC;
	local LinearColor newColor;

	// End:0x805
	if(SocketPrimitiveIndex < SocketPrimitives.Length)
	{
		// End:0x26A
		if(SocketPrimitives[SocketPrimitiveIndex].Actor != none)
		{
			SocketPrimitives[SocketPrimitiveIndex].ScaleTime += DeltaTime;
			NewScale = SocketPrimitives[SocketPrimitiveIndex].BaseScale;
			NewScale.X += ((Sin(SocketPrimitives[SocketPrimitiveIndex].ScaleTime * 5.0000000) * 0.1000000) + (NewScale.X * 0.2500000));
			NewScale.Y += ((Sin(SocketPrimitives[SocketPrimitiveIndex].ScaleTime * 5.0000000) * 0.1000000) + (NewScale.Y * 0.2500000));
			NewScale.Z += ((Sin(SocketPrimitives[SocketPrimitiveIndex].ScaleTime * 5.0000000) * 0.1000000) + (NewScale.Y * 0.2500000));
			SocketPrimitives[SocketPrimitiveIndex].Actor.SkeletalMeshComponent.SetScale3D(NewScale);
		}
		prevPct = SocketPrimitives[SocketPrimitiveIndex].FadePct;
		// End:0x3D5
		if((SocketPrimitives[SocketPrimitiveIndex].bShowPrimitive == true) && SocketPrimitives[SocketPrimitiveIndex].FadePct < 1.0000000)
		{
			SocketPrimitives[SocketPrimitiveIndex].FadePct = FMin(1.0000000, SocketPrimitives[SocketPrimitiveIndex].FadePct + ((1.0000000 / PrimitiveFadeInSec) * DeltaTime));
			// End:0x3C6
			if(prevPct <= 0.0000000)
			{
				SocketPrimitives[SocketPrimitiveIndex].Actor.SetHidden(false);
				needColorUpdate = true;
			}
			needFadeUpdate = true;			
		}
		else
		{
			// End:0x52A
			if((SocketPrimitives[SocketPrimitiveIndex].bShowPrimitive == false) && SocketPrimitives[SocketPrimitiveIndex].FadePct > 0.0000000)
			{
				SocketPrimitives[SocketPrimitiveIndex].FadePct = FMax(0.0000000, SocketPrimitives[SocketPrimitiveIndex].FadePct - ((1.0000000 / PrimitiveFadeOutSec) * DeltaTime));
				// End:0x51E
				if(SocketPrimitives[SocketPrimitiveIndex].FadePct <= 0.0000000)
				{
					SocketPrimitives[SocketPrimitiveIndex].Actor.SetHidden(true);
					needColorUpdate = true;
				}
				needFadeUpdate = true;
			}
		}
		// End:0x67C
		if(needFadeUpdate == true)
		{
			I = 0;
			J0x545:

			// End:0x67C [Loop If]
			if(I < SocketPrimitives[SocketPrimitiveIndex].Actor.SkeletalMeshComponent.GetNumElements())
			{
				MIC = MaterialInstanceConstant(SocketPrimitives[SocketPrimitiveIndex].Actor.SkeletalMeshComponent.GetMaterial(I));
				// End:0x66E
				if(MIC != none)
				{
					MIC.SetScalarParameterValue(PrimitiveScalarParamFadeTimeName, SocketPrimitives[SocketPrimitiveIndex].FadePct);
				}
				++I;
				// [Loop Continue]
				goto J0x545;
			}
		}
		// End:0x805
		if((needColorUpdate == true) && SocketPrimitives[SocketPrimitiveIndex].bHasBeenPlaced)
		{
			newColor = MakeLinearColor(0.0000000, 1.0000000, 0.4710000, 1.0000000);
			I = 0;
			J0x6EB:

			// End:0x805 [Loop If]
			if(I < SocketPrimitives[SocketPrimitiveIndex].Actor.SkeletalMeshComponent.GetNumElements())
			{
				MIC = MaterialInstanceConstant(SocketPrimitives[SocketPrimitiveIndex].Actor.SkeletalMeshComponent.GetMaterial(I));
				// End:0x7F7
				if(MIC != none)
				{
					MIC.SetVectorParameterValue(PrimitiveVectorParamColorName, newColor);
				}
				++I;
				// [Loop Continue]
				goto J0x6EB;
			}
		}
	}
	//return;	
}

function bool IncrementSocketPrimitive(out Vector newFocus)
{
	local bool bSelected;

	// End:0x2F
	if(((SocketPrimitiveIndex + 1) >= SocketPrimitives.Length) || bLockControls == true)
	{
		return false;
	}
	SocketPreviousPrimitiveIndex = SocketPrimitiveIndex;
	SocketPrimitiveIndex++;
	J0x4D:

	// End:0xD0 [Loop If]
	if(bSelected == false)
	{
		// End:0x80
		if(SocketPrimitiveIndex >= SocketPrimitives.Length)
		{
			SocketPrimitiveIndex = 0;
		}
		// End:0xC2
		if((SocketPrimitives[SocketPrimitiveIndex].bHasBeenPlaced == false) || true)
		{
			bSelected = true;			
		}
		else
		{
			SocketPrimitiveIndex++;
		}
		// [Loop Continue]
		goto J0x4D;
	}
	SetMaterialSocketPrimitiveClear(SocketPreviousPrimitiveIndex);
	SetMaterialSocketPrimitiveClearSelected(SocketPrimitiveIndex);
	newFocus = SocketPrimitives[SocketPrimitiveIndex].Actor.Location;
	return true;
	//return ReturnValue;	
}

function bool DecrementSocketPrimitive(out Vector newFocus)
{
	local bool bSelected;

	// End:0x26
	if(((SocketPrimitiveIndex - 1) < 0) || bLockControls == true)
	{
		return false;
	}
	SocketPreviousPrimitiveIndex = SocketPrimitiveIndex;
	SocketPrimitiveIndex--;
	J0x44:

	// End:0xCA [Loop If]
	if(bSelected == false)
	{
		// End:0x7A
		if(SocketPrimitiveIndex < 0)
		{
			SocketPrimitiveIndex = SocketPrimitives.Length - 1;
		}
		// End:0xBC
		if((SocketPrimitives[SocketPrimitiveIndex].bHasBeenPlaced == false) || true)
		{
			bSelected = true;			
		}
		else
		{
			SocketPrimitiveIndex--;
		}
		// [Loop Continue]
		goto J0x44;
	}
	SetMaterialSocketPrimitiveClear(SocketPreviousPrimitiveIndex);
	SetMaterialSocketPrimitiveClearSelected(SocketPrimitiveIndex);
	newFocus = SocketPrimitives[SocketPrimitiveIndex].Actor.Location;
	return true;
	//return ReturnValue;	
}

function SetMaterialSocketPrimitiveClear(int Index)
{
	// End:0xD6
	if((Index < SocketPrimitives.Length) && SocketPrimitives[Index].Actor != none)
	{
		SocketPrimitives[Index].Actor.SkeletalMeshComponent.SetDepthPriorityGroup(1);
		SocketPrimitives[Index].Actor.SetHidden(true);
	}
	//return;	
}

function SetMaterialSocketPrimitiveClearSelected(int Index, optional bool hardSetFadeToOn = true)
{
	local int I;
	local MaterialInstanceConstant MIC;

	// End:0x303
	if((Index < SocketPrimitives.Length) && SocketPrimitives[Index].Actor != none)
	{
		SocketPrimitives[Index].PrimitiveState = 2;
		SocketPrimitives[Index].Actor.SkeletalMeshComponent.SetDepthPriorityGroup(2);
		SocketPrimitives[Index].Actor.SetHidden(false);
		// End:0x2AE
		if(hardSetFadeToOn == true)
		{
			SocketPrimitives[Index].bShowPrimitive = true;
			SocketPrimitives[Index].FadePct = 1.0000000;
			I = 0;
			J0x174:

			// End:0x2AB [Loop If]
			if(I < SocketPrimitives[Index].Actor.SkeletalMeshComponent.GetNumElements())
			{
				MIC = MaterialInstanceConstant(SocketPrimitives[Index].Actor.SkeletalMeshComponent.GetMaterial(I));
				// End:0x29D
				if(MIC != none)
				{
					MIC.SetScalarParameterValue(PrimitiveScalarParamFadeTimeName, SocketPrimitives[Index].FadePct);
				}
				++I;
				// [Loop Continue]
				goto J0x174;
			}			
		}
		else
		{
			SocketPrimitives[Index].bShowPrimitive = true;
			SocketPrimitives[Index].FadePct = 0.0000000;
		}
	}
	//return;	
}

function HaloConstructionManager.EHaloConstructionPrimitiveTypes GetCurrentPrimitiveType()
{
	return SocketPrimitives[SocketPrimitiveIndex].PrimitiveType;
	//return ReturnValue;	
}

function bool GetCurrentSocketPrimitiveAlreadyPlaced()
{
	return SocketPrimitives[SocketPrimitiveIndex].bHasBeenPlaced == true;
	//return ReturnValue;	
}

function bool AddSocketPrimitive(HaloConstructionManager.EHaloConstructionPrimitiveTypes Type)
{
	local Vector slideOffset;
	local Rotator errorRotOffset;
	local int I;
	local Vector fxBlockScale;

	// End:0x23
	if((bLockControls == true) || CManager == none)
	{
		return false;
	}
	// End:0xBD
	if(bUseZFormFallIn == true)
	{
		slideOffset.X = float(Rand(1600) - 800);
		slideOffset.Y = float(Rand(1600) - 800);
		slideOffset.Z = float(Rand(550) + 800);		
	}
	else
	{
		slideOffset.X = 0.0000000;
		slideOffset.Y = 0.0000000;
		slideOffset.Z = 3200.0000000;
	}
	// End:0xDA0
	if(SocketPrimitives[SocketPrimitiveIndex].bHasBeenPlaced == false)
	{
		CManager.PlayAddPrimitiveSound();
		// End:0x76C
		if(int(SocketPrimitives[SocketPrimitiveIndex].PrimitiveType) == int(Type))
		{
			bLockControls = true;
			SocketPrimitives[SocketPrimitiveIndex].bHasBeenPlaced = true;
			SocketPrimitives[SocketPrimitiveIndex].bShowPrimitive = false;
			SocketPrimitivesSolid[SocketPrimitiveIndex].bHasBeenPlaced = true;
			SocketPrimitivesSolid[SocketPrimitiveIndex].bIsSliding_Z = true;
			SocketPrimitivesSolid[SocketPrimitiveIndex].bIsSliding_XY = false;
			SocketPrimitivesSolid[SocketPrimitiveIndex].Actor.SetLocation(SocketPrimitivesSolid[SocketPrimitiveIndex].Actor.Location + slideOffset);
			// End:0x3A4
			if(bUseZFormFallIn == true)
			{
				SocketPrimitivesSolid[SocketPrimitiveIndex].SlidingHalfHeight = SocketPrimitivesSolid[SocketPrimitiveIndex].Actor.Location.Z - (slideOffset.Z / float(2));
			}
			SocketPrimitivesSolid[SocketPrimitiveIndex].Actor.SetHidden(false);
			I = 0;
			J0x3EC:

			// End:0x568 [Loop If]
			if(I < SocketPrimitivesSolid[SocketPrimitiveIndex].Actor.SkeletalMeshComponent.GetNumElements())
			{
				// End:0x55A
				if(SocketPrimitivesSolid[SocketPrimitiveIndex].SuccessMITVs[I] != none)
				{
					SocketPrimitivesSolid[SocketPrimitiveIndex].Actor.SkeletalMeshComponent.SetMaterial(I, SocketPrimitivesSolid[SocketPrimitiveIndex].SuccessMITVs[I]);
					SocketPrimitivesSolid[SocketPrimitiveIndex].SuccessMITVs[I].SetDuration(MITVTimeInSec);
				}
				I++;
				// [Loop Continue]
				goto J0x3EC;
			}
			TrailFX.SetTemplate(CManager.GetPrimitiveTrailFXFromType(SocketPrimitivesSolid[SocketPrimitiveIndex].PrimitiveType));
			TrailFX.DetachFromAny();
			SocketPrimitivesSolid[SocketPrimitiveIndex].Actor.AttachComponent(TrailFX);
			fxBlockScale = GetDimensionsForPrimitive(SocketPrimitives[SocketPrimitiveIndex].Actor, SocketPrimitives[SocketPrimitiveIndex].BaseScale);
			TrailFX.SetVectorParameter('BlockScale', fxBlockScale);
			TrailFX.SetActive(true, true);
			SplashFX.SetTemplate(CManager.GetPrimitiveSplashFXFromType(SocketPrimitivesSolid[SocketPrimitiveIndex].PrimitiveType));
			SplashFX.SetActive(false, false);
			return true;			
		}
		else
		{
			bLockControls = true;
			SocketPrimitives[SocketPrimitiveIndex].bShowPrimitive = false;
			SocketErrorPrimitives[int(Type)].bIsSliding_Z = true;
			SocketErrorPrimitives[int(Type)].bIsSliding_XY = false;
			SocketErrorPrimitives[int(Type)].Actor.SetLocation(SocketPrimitives[SocketPrimitiveIndex].Actor.Location + slideOffset);
			SocketErrorPrimitives[int(Type)].Actor.SkeletalMeshComponent.SetScale3D(SocketPrimitives[SocketPrimitiveIndex].Actor.SkeletalMeshComponent.Scale3D);
			errorRotOffset = SocketErrorPrimitives[int(Type)].Actor.Rotation;
			errorRotOffset.Yaw = Rand(64000);
			SocketErrorPrimitives[int(Type)].Actor.SetRotation(errorRotOffset);
			// End:0xA6F
			if(bUseZFormFallIn == true)
			{
				SocketErrorPrimitives[int(Type)].SlidingHalfHeight = SocketErrorPrimitives[int(Type)].Actor.Location.Z - (slideOffset.Z / float(2));
			}
			SocketErrorPrimitives[int(Type)].Actor.SetHidden(false);
			I = 0;
			J0xAB9:

			// End:0xC3F [Loop If]
			if(I < SocketErrorPrimitives[int(Type)].Actor.SkeletalMeshComponent.GetNumElements())
			{
				// End:0xC31
				if(SocketErrorPrimitives[int(Type)].ErrorMITVs[I] != none)
				{
					SocketErrorPrimitives[int(Type)].Actor.SkeletalMeshComponent.SetMaterial(I, SocketErrorPrimitives[int(Type)].ErrorMITVs[I]);
					SocketErrorPrimitives[int(Type)].ErrorMITVs[I].SetDuration(MITVErrorTimeInSec);
				}
				I++;
				// [Loop Continue]
				goto J0xAB9;
			}
			ErrorTrailFX.SetTemplate(CManager.GetPrimitiveErrorTrailFXFromType(Type));
			ErrorTrailFX.DetachFromAny();
			SocketErrorPrimitives[int(Type)].Actor.AttachComponent(ErrorTrailFX);
			fxBlockScale = GetDimensionsForPrimitive(SocketPrimitives[SocketPrimitiveIndex].Actor, SocketPrimitives[SocketPrimitiveIndex].BaseScale);
			ErrorTrailFX.SetVectorParameter('BlockScale', fxBlockScale);
			ErrorTrailFX.SetActive(true, true);
			return false;
		}
	}
	CManager.PlayErrorSound();
	return false;
	//return ReturnValue;	
}

function bool ContainsEmptySocketPrimitives()
{
	local int I;
	local bool bFoundEmpty;

	I = 0;
	J0x0B:

	// End:0x6D [Loop If]
	if(I < SocketPrimitives.Length)
	{
		// End:0x5F
		if(SocketPrimitives[I].bHasBeenPlaced == false)
		{
			bFoundEmpty = true;
			// [Explicit Break]
			goto J0x6D;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	J0x6D:

	return bFoundEmpty;
	//return ReturnValue;	
}

function int GetTotalSocketPrimitives()
{
	return SocketPrimitives.Length;
	//return ReturnValue;	
}

function int GetUsedSocketPrimitives()
{
	local int I, numUsed;

	I = 0;
	J0x0B:

	// End:0x69 [Loop If]
	if(I < SocketPrimitives.Length)
	{
		// End:0x5B
		if(SocketPrimitives[I].bHasBeenPlaced == true)
		{
			numUsed++;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return numUsed;
	//return ReturnValue;	
}

function Vector GetSelectedPrimitiveLocation()
{
	// End:0x68
	if(SocketPrimitives[SocketPrimitiveIndex].Actor != none)
	{
		return SocketPrimitives[SocketPrimitiveIndex].Actor.Location;
	}
	//return ReturnValue;	
}

function GetSelectedPrimitiveCameraMinMax(out float Min, out float Max)
{
	// End:0x7C
	if(SocketPrimitiveIndex < SocketPrimitives.Length)
	{
		Min = float(SocketPrimitives[SocketPrimitiveIndex].MinCameraDegree);
		Max = float(SocketPrimitives[SocketPrimitiveIndex].MaxCameraDegree);
	}
	//return;	
}

function HaloConstructionInventory GetPrimitiveInventory()
{
	local HaloConstructionInventory Inventory;
	local SkeletalMeshSocket Socket;
	local array<string> strs;
	local string Type;
	local HaloConstructionManager.EHaloConstructionPrimitiveTypes PrimitiveType;

	// End:0x256
	if(SocketMesh != none)
	{
		// End:0x255
		foreach SocketMesh.SkeletalMeshComponent.SkeletalMesh.Sockets(Socket)
		{
			strs = SplitString(string(Socket.SocketName), "_", true);
			Type = strs[1];
			PrimitiveType = CManager.GetConstructionPrimitiveTypeFromString(Type);
			// End:0x119
			if(int(PrimitiveType) == int(0))
			{
				Inventory.Panels++;				
			}
			else
			{
				// End:0x14E
				if(int(PrimitiveType) == int(1))
				{
					Inventory.Beams++;					
				}
				else
				{
					// End:0x183
					if(int(PrimitiveType) == int(2))
					{
						Inventory.Pyramids++;						
					}
					else
					{
						// End:0x1B8
						if(int(PrimitiveType) == int(3))
						{
							Inventory.Cylinders++;							
						}
						else
						{
							// End:0x1ED
							if(int(PrimitiveType) == int(4))
							{
								Inventory.Wedges++;								
							}
							else
							{
								// End:0x222
								if(int(PrimitiveType) == int(5))
								{
									Inventory.Wheels++;									
								}
								else
								{
									// End:0x254
									if(int(PrimitiveType) == int(6))
									{
										Inventory.Pentagons++;
									}
								}
							}
						}
					}
				}
			}			
		}		
	}
	return Inventory;
	//return ReturnValue;	
}

defaultproperties
{
	CInfo=(Name="None",Cost=0,Unlocked=false,CameraXScale=1.0000000,CameraYScale=1.0000000,PrimitiveMesh=none,SocketMesh=none,DetailedMesh=none,DetailedMeshFinal=none,MagicMomentAnim="None",TextureParameter=none,PreviewImagePath="",CObj=none)
	FadeTimeInSec=2.0000000
	MITVTimeInSec=0.4000000
	MITVErrorTimeInSec=1.0000000
	PrimitiveFadeInSec=3.0000000
	PrimitiveFadeOutSec=0.1500000
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloConstructionObject.Particle0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'Particle0'
	begin object name="Particle0" class=Engine.ParticleSystemComponent
		Template=ParticleSystem'v_cov_wraith_fx.Effects.V_COV_WRAITH_Part_Trails'
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=30000.0000000
		CachedMaxDrawDistance=30000.0000000
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	TrailFX=Particle0
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloConstructionObject.Particle1'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'Particle1'
	begin object name="Particle1" class=Engine.ParticleSystemComponent
		Template=ParticleSystem'emp_minesweep_xpld.Effects.EMP_MineSwep_XPLD'
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=30000.0000000
		CachedMaxDrawDistance=30000.0000000
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	SplashFX=Particle1
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloConstructionObject.Particle3'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'Particle3'
	begin object name="Particle3" class=Engine.ParticleSystemComponent
		Template=ParticleSystem'v_cov_wraith_fx.Effects.V_COV_WRAITH_Part_Trails'
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=30000.0000000
		CachedMaxDrawDistance=30000.0000000
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	ErrorTrailFX=Particle3
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloConstructionObject.Particle2'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'Particle2'
	begin object name="Particle2" class=Engine.ParticleSystemComponent
		Template=ParticleSystem'env_cov_crates_xpld.Effects.ENV_COV_CRATE_MED_XPLD'
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=30000.0000000
		CachedMaxDrawDistance=30000.0000000
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	ErrorSplashFX=Particle2
	NewLightingChannels=(bInitialized=true,BSP=false,Static=false,Dynamic=false,CompositeDynamic=false,Skybox=false,Unnamed_1=false,Unnamed_2=true,Unnamed_3=false,Unnamed_4=false,Unnamed_5=false,Unnamed_6=false,Cinematic_1=false,Cinematic_2=false,Cinematic_3=false,Cinematic_4=false,Cinematic_5=false,Cinematic_6=false,Cinematic_7=false,Cinematic_8=false,Cinematic_9=false,Cinematic_10=false,Gameplay_1=false,Gameplay_2=false,Gameplay_3=false,Gameplay_4=false,Crowd=false)
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloConstructionObject.Light'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'Light'
	begin object name="Light" class=Engine.DynamicLightEnvironmentComponent
		InvisibleUpdateTime=1.0000000
		MinTimeBetweenFullUpdates=0.2000000
		AmbientShadowColor=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000)
		AmbientGlow=(R=1.0000000,G=0.8000000,B=0.8000000,A=0.8000000)
		LightDistance=6.0000000
		ShadowDistance=6.0000000
		bCompositeShadowsFromDynamicLights=false
		bUseBooleanEnvironmentShadowing=false
		bSynthesizeSHLight=true
		bIsCharacterLightEnvironment=true
		ModShadowFadeoutExponent=1.0000000
		MinShadowAngle=0.0000000
	end object
	ConstructionLightEnvironment=Light
	// Reference: StaticMeshComponent'MegaHaloGame.Default__HaloConstructionObject.StaticMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'StaticMeshComponent0'
	// Archetype: StaticMeshComponent'Engine.Default__DynamicSMActor_Spawnable.StaticMeshComponent0'
	begin object name="StaticMeshComponent0"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloConstructionObject.MyLightEnvironment'
	end object
	StaticMeshComponent=StaticMeshComponent0
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloConstructionObject.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'Engine.Default__DynamicSMActor_Spawnable.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	Components[0]=MyLightEnvironment
	Components[1]=StaticMeshComponent0
	Components[2]=Particle0
	Components[3]=Particle1
	Components[4]=Particle2
	Components[5]=Particle3
	Components[6]=Light
	CollisionComponent=StaticMeshComponent0
}