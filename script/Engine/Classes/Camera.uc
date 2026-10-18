class Camera extends Actor
	transient
	native
	notplaceable;

const MAX_ACTIVE_CAMERA_ANIMS = 8;

enum EViewTargetBlendFunction
{
	VTBlend_Linear,                 // 0
	VTBlend_Cubic,                  // 1
	VTBlend_EaseIn,                 // 2
	VTBlend_EaseOut,                // 3
	VTBlend_EaseInOut,              // 4
	VTBlend_MAX                     // 5
};

enum ECameraAnimPlaySpace
{
	CAPS_CameraLocal,               // 0
	CAPS_World,                     // 1
	CAPS_UserDefined,               // 2
	CAPS_MAX                        // 3
};

struct native TCameraCache
{
	var float TimeStamp;
	var TPOV POV;

	structdefaultproperties
	{
		TimeStamp=0.0000000
		POV=(Location=(X=0.0000000,Y=0.0000000,Z=0.0000000),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=90.0000000)
	}
};

struct native TViewTarget
{
	var Actor Target;
	var Controller Controller;
	var TPOV POV;
	var float AspectRatio;
	var PlayerReplicationInfo PRI;

	structdefaultproperties
	{
		Target=none
		Controller=none
		POV=(Location=(X=0.0000000,Y=0.0000000,Z=0.0000000),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=90.0000000)
		AspectRatio=0.0000000
		PRI=none
	}
};

struct native ViewTargetTransitionParams
{
	var float BlendTime;
	var Camera.EViewTargetBlendFunction BlendFunction;
	var float BlendExp;
	var bool bLockOutgoing;

	structdefaultproperties
	{
		BlendTime=0.0000000
		BlendFunction=EViewTargetBlendFunction.VTBlend_Cubic
		BlendExp=2.0000000
		bLockOutgoing=false
	}
};

var PlayerController PCOwner;
var name CameraStyle;
var float DefaultFOV;
var bool bLockedFOV;
var bool bConstrainAspectRatio;
var bool bEnableFading;
var bool bFadeAudio;
var transient bool bForceDisableTemporalAA;
var bool bEnableColorScaling;
var bool bEnableColorScaleInterp;
var bool bUseClientSideCameraUpdates;
var bool bDebugClientSideCamera;
var bool bShouldSendClientSideCameraUpdate;
var float LockedFOV;
var float ConstrainedAspectRatio;
var float DefaultAspectRatio;
var float OffAxisYawAngle;
var float OffAxisPitchAngle;
var Color FadeColor;
var float FadeAmount;
var float CamOverridePostProcessAlpha;
var PostProcessSettings CamPostProcessSettings;
var RenderingPerformanceOverrides RenderingOverrides;
var Vector ColorScale;
var Vector DesiredColorScale;
var Vector OriginalColorScale;
var float ColorScaleInterpDuration;
var float ColorScaleInterpStartTime;
var TCameraCache CameraCache;
var TCameraCache LastFrameCameraCache;
var TViewTarget ViewTarget;
var TViewTarget PendingViewTarget;
var float BlendTimeToGo;
var ViewTargetTransitionParams BlendParams;
var array<CameraModifier> ModifierList;
var float FreeCamDistance;
var Vector FreeCamOffset;
var Vector2D FadeAlpha;
var float FadeTime;
var float FadeTimeRemaining;
var protected transient array<EmitterCameraLensEffectBase> CameraLensEffects;
var editinline transient CameraModifier_CameraShake CameraShakeCamMod;
var protected Class<CameraModifier_CameraShake> CameraShakeCamModClass;
var protected CameraAnimInst AnimInstPool[8];
var protected array<CameraAnimInst> ActiveAnims;
var protected array<CameraAnimInst> FreeAnims;
var protected transient DynamicCameraActor AnimCameraActor;

protected function CameraModifier CreateCameraModifier(Class<CameraModifier> ModifierClass)
{
	local CameraModifier NewMod;

	NewMod = new (Outer) ModifierClass;
	NewMod.Init();
	NewMod.AddCameraModifier(self);
	return NewMod;
	//return ReturnValue;	
}

function PostBeginPlay()
{
	local int Idx;

	super.PostBeginPlay();
	// End:0x50
	if((CameraShakeCamMod == none) && CameraShakeCamModClass != none)
	{
		CameraShakeCamMod = CameraModifier_CameraShake(CreateCameraModifier(CameraShakeCamModClass));
	}
	Idx = 0;
	J0x5B:

	// End:0xC2 [Loop If]
	if(Idx < 8)
	{
		AnimInstPool[Idx] = new (self) Class'Engine.CameraAnimInst';
		FreeAnims[Idx] = AnimInstPool[Idx];
		Idx++;
		// [Loop Continue]
		goto J0x5B;
	}
	AnimCameraActor = Spawn(Class'Engine.DynamicCameraActor', self,,,,, true);
	//return;	
}

event Destroyed()
{
	AnimCameraActor.Destroy();
	super.Destroyed();
	//return;	
}

// Export UCamera::execApplyCameraModifiers(FFrame&, void* const)
native function ApplyCameraModifiers(float DeltaTime, out TPOV OutPOV);

function InitializeFor(PlayerController PC)
{
	CameraCache.POV.FOV = DefaultFOV;
	PCOwner = PC;
	SetViewTarget(PC.ViewTarget);
	SetDesiredColorScale(WorldInfo.DefaultColorScale, 5.0000000);
	UpdateCamera(0.0000000);
	//return;	
}

function float GetFOVAngle()
{
	// End:0x17
	if(bLockedFOV)
	{
		return LockedFOV;
	}
	return CameraCache.POV.FOV;
	//return ReturnValue;	
}

function SetFOV(float NewFOV)
{
	// End:0x33
	if((NewFOV < float(1)) || NewFOV > float(170))
	{
		bLockedFOV = false;
		return;
	}
	bLockedFOV = true;
	LockedFOV = NewFOV;
	//return;	
}

final function GetCameraViewPoint(out Vector OutCamLoc, out Rotator OutCamRot)
{
	OutCamLoc = CameraCache.POV.Location;
	OutCamRot = CameraCache.POV.Rotation;
	//return;	
}

final function Rotator GetCameraRotation()
{
	return CameraCache.POV.Rotation;
	//return ReturnValue;	
}

simulated function SetDesiredColorScale(Vector NewColorScale, float InterpTime)
{
	// End:0x81
	if(bEnableColorScaling!)
	{
		bEnableColorScaling = true;
		ColorScale.X = 1.0000000;
		ColorScale.Y = 1.0000000;
		ColorScale.Z = 1.0000000;
	}
	// End:0x105
	if(NewColorScale != ColorScale)
	{
		OriginalColorScale = ColorScale;
		DesiredColorScale = NewColorScale;
		ColorScaleInterpStartTime = WorldInfo.TimeSeconds;
		ColorScaleInterpDuration = InterpTime;
		bEnableColorScaleInterp = true;
	}
	//return;	
}

simulated event UpdateCamera(float DeltaTime)
{
	// End:0x17F
	if((PCOwner.IsLocalPlayerController() || bUseClientSideCameraUpdates!) || bDebugClientSideCamera)
	{
		DoUpdateCamera(DeltaTime);
		// End:0x17F
		if((int(WorldInfo.NetMode) == int(NM_Client)) && bShouldSendClientSideCameraUpdate)
		{
			PCOwner.ServerUpdateCamera(CameraCache.POV.Location, (CameraCache.POV.Rotation.Pitch & 65535) + ((CameraCache.POV.Rotation.Yaw & 65535) << 16));
			bShouldSendClientSideCameraUpdate = false;
		}
	}
	//return;	
}

simulated function DoUpdateCamera(float DeltaTime)
{
	local TPOV NewPOV;
	local float DurationPct, BlendPct;

	// End:0xA5
	if(bEnableColorScaleInterp)
	{
		BlendPct = FClamp((WorldInfo.TimeSeconds - ColorScaleInterpStartTime) / ColorScaleInterpDuration, 0.0000000, 1.0000000);
		ColorScale = VLerp(OriginalColorScale, DesiredColorScale, BlendPct);
		// End:0xA5
		if(BlendPct == 1.0000000)
		{
			bEnableColorScaleInterp = false;
		}
	}
	bConstrainAspectRatio = false;
	CamOverridePostProcessAlpha = 0.0000000;
	// End:0x135
	if((PendingViewTarget.Target == none) || BlendParams.bLockOutgoing!)
	{
		CheckViewTarget(ViewTarget);
		UpdateViewTarget(ViewTarget, DeltaTime);
	}
	NewPOV = ViewTarget.POV;
	ConstrainedAspectRatio = ViewTarget.AspectRatio;
	// End:0x4A5
	if(PendingViewTarget.Target != none)
	{
		BlendTimeToGo -= DeltaTime;
		bConstrainAspectRatio = false;
		CheckViewTarget(PendingViewTarget);
		UpdateViewTarget(PendingViewTarget, DeltaTime);
		// End:0x3EE
		if(BlendTimeToGo > float(0))
		{
			DurationPct = (BlendParams.BlendTime - BlendTimeToGo) / BlendParams.BlendTime;
			switch(BlendParams.BlendFunction)
			{
				// End:0x29F
				case 0:
					BlendPct = Lerp(0.0000000, 1.0000000, DurationPct);
					// End:0x3BC
					break;
				// End:0x2D8
				case 1:
					BlendPct = FCubicInterp(0.0000000, 0.0000000, 1.0000000, 0.0000000, DurationPct);
					// End:0x3BC
					break;
				// End:0x323
				case 2:
					BlendPct = FInterpEaseIn(0.0000000, 1.0000000, DurationPct, BlendParams.BlendExp);
					// End:0x3BC
					break;
				// End:0x36E
				case 3:
					BlendPct = FInterpEaseOut(0.0000000, 1.0000000, DurationPct, BlendParams.BlendExp);
					// End:0x3BC
					break;
				// End:0x3B9
				case 4:
					BlendPct = FInterpEaseInOut(0.0000000, 1.0000000, DurationPct, BlendParams.BlendExp);
					// End:0x3BC
					break;
				// End:0xFFFF
				default:
					break;
			}
			NewPOV = BlendViewTargets(ViewTarget, PendingViewTarget, BlendPct);			
		}
		else
		{
			ViewTarget = PendingViewTarget;
			PendingViewTarget.Target = none;
			PendingViewTarget.Controller = none;
			BlendTimeToGo = 0.0000000;
			NewPOV = PendingViewTarget.POV;
		}
		// End:0x4A5
		if(bConstrainAspectRatio)
		{
			ConstrainedAspectRatio = PendingViewTarget.AspectRatio;
		}
	}
	FillCameraCache(NewPOV);
	// End:0x5C5
	if(bEnableFading && FadeTimeRemaining > 0.0000000)
	{
		FadeTimeRemaining = FMax(FadeTimeRemaining - DeltaTime, 0.0000000);
		// End:0x591
		if(FadeTime > 0.0000000)
		{
			FadeAmount = FadeAlpha.X + ((1.0000000 - (FadeTimeRemaining / FadeTime)) * (FadeAlpha.Y - FadeAlpha.X));
		}
		// End:0x5C5
		if(bFadeAudio)
		{
			ApplyAudioFade();
			// End:0x5C5
			if(FadeAmount == float(0))
			{
				bFadeAudio = false;
			}
		}
	}
	//return;	
}

// Export UCamera::execApplyAudioFade(FFrame&, void* const)
native function ApplyAudioFade();

final function TPOV BlendViewTargets(const out TViewTarget A, const out TViewTarget B, float Alpha)
{
	local TPOV POV;

	POV.Location = VLerp(A.POV.Location, B.POV.Location, Alpha);
	POV.FOV = Lerp(A.POV.FOV, B.POV.FOV, Alpha);
	POV.Rotation = RLerp(A.POV.Rotation, B.POV.Rotation, Alpha, true);
	return POV;
	//return ReturnValue;	
}

final function FillCameraCache(const out TPOV NewPOV)
{
	// End:0x52
	if(CameraCache.TimeStamp != WorldInfo.TimeSeconds)
	{
		LastFrameCameraCache = CameraCache;
	}
	CameraCache.TimeStamp = WorldInfo.TimeSeconds;
	CameraCache.POV = NewPOV;
	//return;	
}

// Export UCamera::execCheckViewTarget(FFrame&, void* const)
native function CheckViewTarget(out TViewTarget VT);

function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
	local Vector Loc, pos, HitLocation, HitNormal;
	local Rotator Rot;
	local Actor HitActor;
	local CameraActor CamActor;
	local bool bDoNotApplyModifiers;
	local TPOV OrigPOV;
	local Pawn TPawn;

	// End:0x66
	if(((PendingViewTarget.Target != none) && OutVT == ViewTarget) && BlendParams.bLockOutgoing)
	{
		return;
	}
	OrigPOV = OutVT.POV;
	OutVT.POV.FOV = DefaultFOV;
	CamActor = CameraActor(OutVT.Target);
	// End:0x20E
	if(CamActor != none)
	{
		CamActor.GetCameraView(DeltaTime, OutVT.POV);
		bConstrainAspectRatio = bConstrainAspectRatio || CamActor.bConstrainAspectRatio;
		OutVT.AspectRatio = CamActor.AspectRatio;
		CamOverridePostProcessAlpha = CamActor.CamOverridePostProcessAlpha;
		CamPostProcessSettings = CamActor.CamOverridePostProcess;		
	}
	else
	{
		TPawn = Pawn(OutVT.Target);
		// End:0x7E9
		if((TPawn == none) || TPawn.CalcCamera(DeltaTime, OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV)!)
		{
			bDoNotApplyModifiers = true;
			switch(CameraStyle)
			{
				// End:0x35C
				case 'Fixed':
					OutVT.POV = OrigPOV;
					// End:0x7E9
					break;
				// End:0x368
				case 'ThirdPerson':
				// End:0x374
				case 'FreeCam':
				// End:0x645
				case 'FreeCam_Default':
					Loc = OutVT.Target.Location;
					Rot = OutVT.Target.Rotation;
					// End:0x4D2
					if((TPawn != none) && TPawn.Mesh != none)
					{
						Loc += ((TPawn.Mesh.Translation - TPawn.default.Mesh.Translation) >> OutVT.Target.Rotation);
					}
					// End:0x52A
					if((CameraStyle == 'FreeCam') || CameraStyle == 'FreeCam_Default')
					{
						Rot = PCOwner.Rotation;
					}
					Loc += (FreeCamOffset >> Rot);
					pos = Loc - (Vector(Rot) * FreeCamDistance);
					HitActor = Trace(HitLocation, HitNormal, pos, Loc, false, vect(12.0000000, 12.0000000, 12.0000000));
					OutVT.POV.Location = ((HitActor == none) ? pos : HitLocation);
					OutVT.POV.Rotation = Rot;
					// End:0x7E9
					break;
				// End:0x651
				case 'FirstPerson':
				// End:0xFFFF
				default:
					OutVT.Target.GetActorEyesViewPoint(OutVT.POV.Location, OutVT.POV.Rotation);
					// End:0x7E6
					if((TPawn != none) && TPawn.Mesh != none)
					{
						OutVT.POV.Location += ((TPawn.Mesh.Translation - TPawn.default.Mesh.Translation) >> OutVT.Target.Rotation);
					}
					// End:0x7E9
					break;
					break;
			}
		}
	}
	// End:0x827
	if(bDoNotApplyModifiers!)
	{
		ApplyCameraModifiers(DeltaTime, OutVT.POV);
	}
	//return;	
}

// Export UCamera::execSetViewTarget(FFrame&, void* const)
native final function SetViewTarget(Actor NewViewTarget, optional ViewTargetTransitionParams TransitionParams);

function ProcessViewRotation(float DeltaTime, out Rotator OutViewRotation, out Rotator OutDeltaRot)
{
	local int ModifierIdx;

	ModifierIdx = 0;
	J0x0B:

	// End:0xB0 [Loop If]
	if(ModifierIdx < ModifierList.Length)
	{
		// End:0xA2
		if(ModifierList[ModifierIdx] != none)
		{
			// End:0xA2
			if(ModifierList[ModifierIdx].ProcessViewRotation(ViewTarget.Target, DeltaTime, OutViewRotation, OutDeltaRot))
			{
				// [Explicit Break]
				goto J0xB0;
			}
		}
		ModifierIdx++;
		// [Loop Continue]
		goto J0x0B;
	}
	J0xB0:

	//return;	
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local Vector EyesLoc;
	local Rotator EyesRot;
	local Canvas Canvas;

	Canvas = HUD.Canvas;
	Canvas.SetDrawColor(255, 255, 255);
	Canvas.DrawText((("	Camera Style:" $ string(CameraStyle)) @ "main ViewTarget:") $ string(ViewTarget.Target));
	out_YPos += out_YL;
	Canvas.SetPos(4.0000000, out_YPos);
	Canvas.DrawText((((("   CamLoc:" $ string(CameraCache.POV.Location)) @ "CamRot:") $ string(CameraCache.POV.Rotation)) @ "FOV:") $ string(CameraCache.POV.FOV));
	out_YPos += out_YL;
	Canvas.SetPos(4.0000000, out_YPos);
	Canvas.DrawText("   AspectRatio:" $ string(ConstrainedAspectRatio));
	out_YPos += out_YL;
	Canvas.SetPos(4.0000000, out_YPos);
	// End:0x3A2
	if(ViewTarget.Target != none)
	{
		ViewTarget.Target.GetActorEyesViewPoint(EyesLoc, EyesRot);
		Canvas.DrawText((("   EyesLoc:" $ string(EyesLoc)) @ "EyesRot:") $ string(EyesRot));
		out_YPos += out_YL;
		Canvas.SetPos(4.0000000, out_YPos);
	}
	//return;	
}

function EmitterCameraLensEffectBase FindCameraLensEffect(Class<EmitterCameraLensEffectBase> LensEffectEmitterClass)
{
	local EmitterCameraLensEffectBase LensEffect;

	// End:0xF8
	foreach CameraLensEffects(LensEffect)
	{
		// End:0xF7
		if(LensEffect.bDeleteMe! && ((LensEffect.Class == LensEffectEmitterClass) || LensEffect.EmittersToTreatAsSame.Find(LensEffectEmitterClass) != -1) || LensEffectEmitterClass.default.EmittersToTreatAsSame.Find(LensEffect.Class) != -1)
		{			
			return LensEffect;
		}		
	}	
	return none;
	//return ReturnValue;	
}

function AddCameraLensEffect(Class<EmitterCameraLensEffectBase> LensEffectEmitterClass)
{
	local Vector CamLoc;
	local Rotator CamRot;
	local EmitterCameraLensEffectBase LensEffect;

	// End:0x16B
	if(LensEffectEmitterClass != none)
	{
		// End:0x7E
		if(LensEffectEmitterClass.default.bAllowMultipleInstances!)
		{
			LensEffect = FindCameraLensEffect(LensEffectEmitterClass);
			// End:0x7E
			if(LensEffect != none)
			{
				LensEffect.NotifyRetriggered();
			}
		}
		// End:0x16B
		if(LensEffect == none)
		{
			LensEffect = Spawn(LensEffectEmitterClass, PCOwner.GetViewTarget());
			// End:0x16B
			if(LensEffect != none)
			{
				GetCameraViewPoint(CamLoc, CamRot);
				LensEffect.UpdateLocation(CamLoc, CamRot, GetFOVAngle());
				LensEffect.RegisterCamera(self);
				CameraLensEffects.AddItem(LensEffect);
			}
		}
	}
	//return;	
}

function RemoveCameraLensEffect(EmitterCameraLensEffectBase Emitter)
{
	CameraLensEffects.RemoveItem(Emitter);
	//return;	
}

function ClearCameraLensEffects()
{
	local EmitterCameraLensEffectBase LensEffect;

	// End:0x30
	foreach CameraLensEffects(LensEffect)
	{
		LensEffect.Destroy();		
	}	
	CameraLensEffects.Length = 0;
	//return;	
}

function PlayCameraShake(CameraShake Shake, float Scale, optional Camera.ECameraAnimPlaySpace PlaySpace = 0, optional Rotator UserPlaySpaceRot)
{
	// End:0x59
	if(Shake != none)
	{
		CameraShakeCamMod.AddCameraShake(Shake, Scale, PlaySpace, UserPlaySpaceRot);
	}
	//return;	
}

function StopCameraShake(CameraShake Shake)
{
	// End:0x37
	if(Shake != none)
	{
		CameraShakeCamMod.RemoveCameraShake(Shake);
	}
	//return;	
}

static function float CalcRadialShakeScale(Camera Cam, Vector Epicenter, float InnerRadius, float OuterRadius, float Falloff)
{
	local Vector POVLoc;
	local float DistPct;

	POVLoc = Cam.Location;
	// End:0xBE
	if(InnerRadius < OuterRadius)
	{
		DistPct = (VSize(Epicenter - POVLoc) - InnerRadius) / (OuterRadius - InnerRadius);
		DistPct = 1.0000000 - FClamp(DistPct, 0.0000000, 1.0000000);
		return DistPct ** Falloff;		
	}
	else
	{
		return ((VSize(Epicenter - POVLoc) < InnerRadius) ? 1.0000000 : 0.0000000);
	}
	//return ReturnValue;	
}

static function PlayWorldCameraShake(CameraShake Shake, Actor ShakeInstigator, Vector Epicenter, float InnerRadius, float OuterRadius, float Falloff, bool bTryForceFeedback, optional bool bOrientShakeTowardsEpicenter)
{
	local PlayerController PC;
	local float ShakeScale;
	local Rotator CamRot;
	local Vector CamLoc;

	// End:0x1CC
	if(ShakeInstigator != none)
	{
		// End:0x1CB
		foreach ShakeInstigator.LocalPlayerControllers(Class'Engine.PlayerController', PC)
		{
			// End:0x1CA
			if(PC.PlayerCamera != none)
			{
				ShakeScale = CalcRadialShakeScale(PC.PlayerCamera, Epicenter, InnerRadius, OuterRadius, Falloff);
				// End:0x18D
				if(bOrientShakeTowardsEpicenter && PC.Pawn != none)
				{
					PC.PlayerCamera.GetCameraViewPoint(CamLoc, CamRot);
					PC.ClientPlayCameraShake(Shake, ShakeScale, bTryForceFeedback, 2, Rotator(Epicenter - CamLoc));
					// End:0x1CA
					continue;
				}
				PC.ClientPlayCameraShake(Shake, ShakeScale, bTryForceFeedback);
			}			
		}		
	}
	//return;	
}

function ClearAllCameraShakes()
{
	CameraShakeCamMod.RemoveAllCameraShakes();
	//return;	
}

// Export UCamera::execPlayCameraAnim(FFrame&, void* const)
native simulated function CameraAnimInst PlayCameraAnim(CameraAnim Anim, optional float Rate = 1.0000000, optional float Scale = 1.0000000, optional float BlendInTime, optional float BlendOutTime, optional bool bLoop, optional bool bRandomStartTime, optional float Duration, optional bool bSingleInstance);

// Export UCamera::execStopAllCameraAnims(FFrame&, void* const)
native simulated function StopAllCameraAnims(optional bool bImmediate);

// Export UCamera::execStopAllCameraAnimsByType(FFrame&, void* const)
native simulated function StopAllCameraAnimsByType(CameraAnim Anim, optional bool bImmediate);

// Export UCamera::execStopCameraAnim(FFrame&, void* const)
native simulated function StopCameraAnim(CameraAnimInst AnimInst, optional bool bImmediate);

defaultproperties
{
	DefaultFOV=90.0000000
	bUseClientSideCameraUpdates=true
	DefaultAspectRatio=1.3333300
	CamPostProcessSettings=(bOverride_EnableBloom=true,bOverride_EnableDOF=true,bOverride_EnableMotionBlur=true,bOverride_EnableSceneEffect=true,bOverride_AllowAmbientOcclusion=true,bOverride_OverrideRimShaderColor=true,bOverride_Bloom_Scale=true,bOverride_Bloom_Threshold=true,bOverride_Bloom_Tint=true,bOverride_Bloom_ScreenBlendThreshold=true,bOverride_Bloom_InterpolationDuration=true,bOverride_DOF_FalloffExponent=true,bOverride_DOF_BlurKernelSize=true,bOverride_DOF_BlurBloomKernelSize=true,bOverride_DOF_MaxNearBlurAmount=true,bOverride_DOF_MinBlurAmount=false,bOverride_DOF_MaxFarBlurAmount=true,bOverride_DOF_FocusType=true,bOverride_DOF_FocusInnerRadius=true,bOverride_DOF_FocusDistance=true,bOverride_DOF_FocusPosition=true,bOverride_DOF_InterpolationDuration=true,bOverride_DOF_BokehTexture=false,bOverride_MotionBlur_MaxVelocity=false,bOverride_MotionBlur_Amount=false,bOverride_MotionBlur_FullMotionBlur=false,bOverride_MotionBlur_CameraRotationThreshold=false,bOverride_MotionBlur_CameraTranslationThreshold=false,bOverride_MotionBlur_InterpolationDuration=false,bOverride_Scene_Desaturation=true,bOverride_Scene_Colorize=false,bOverride_Scene_TonemapperScale=false,bOverride_Scene_ImageGrainScale=false,bOverride_Scene_HighLights=true,bOverride_Scene_MidTones=true,bOverride_Scene_Shadows=true,bOverride_Scene_InterpolationDuration=true,bOverride_Scene_ColorGradingLUT=false,bOverride_RimShader_Color=true,bOverride_RimShader_InterpolationDuration=true,bOverride_MobileColorGrading=false,bEnableBloom=true,bEnableDOF=false,bEnableMotionBlur=true,bEnableSceneEffect=true,bAllowAmbientOcclusion=true,bOverrideRimShaderColor=false,Bloom_Scale=1.0000000,Bloom_Threshold=1.0000000,Bloom_Tint=(R=255,G=255,B=0,A=255),Bloom_ScreenBlendThreshold=10.0000000,Bloom_InterpolationDuration=1.0000000,DOF_BlurBloomKernelSize=16.0000000,DOF_FalloffExponent=4.0000000,DOF_BlurKernelSize=16.0000000,DOF_MaxNearBlurAmount=1.0000000,DOF_MinBlurAmount=0.0000000,DOF_MaxFarBlurAmount=1.0000000,DOF_FocusType=EFocusType.FOCUS_Distance,DOF_FocusInnerRadius=2000.0000000,DOF_FocusDistance=0.0000000,DOF_FocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),DOF_InterpolationDuration=1.0000000,DOF_BokehTexture=none,MotionBlur_MaxVelocity=1.0000000,MotionBlur_Amount=0.5000000,MotionBlur_FullMotionBlur=true,MotionBlur_CameraRotationThreshold=45.0000000,MotionBlur_CameraTranslationThreshold=10000.0000000,MotionBlur_InterpolationDuration=1.0000000,Scene_Desaturation=0.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_TonemapperScale=1.0000000,Scene_ImageGrainScale=0.0000000,Scene_HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Scene_InterpolationDuration=1.0000000,RimShader_Color=(R=1.0000000,G=0.8277260,B=0.5859730,A=0.4704400),RimShader_InterpolationDuration=1.0000000,ColorGrading_LookupTable=none,ColorGradingLUT=(LUTTextures=none,LUTWeights=none),MobileColorGrading=(TransitionTime=1.0000000,Blend=0.0000000,Desaturation=0.0000000,HighLights=(R=1.0000000,G=0.7000000,B=0.7000000,A=0.7000000),MidTones=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000),Shadows=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000)),MobilePostProcess=(bOverride_Mobile_BlurAmount=false,bOverride_Mobile_TransitionTime=false,bOverride_Mobile_Bloom_Scale=false,bOverride_Mobile_Bloom_Threshold=false,bOverride_Mobile_Bloom_Tint=false,bOverride_Mobile_DOF_Distance=false,bOverride_Mobile_DOF_MinRange=false,bOverride_Mobile_DOF_MaxRange=false,bOverride_Mobile_DOF_NearBlurFactor=false,bOverride_Mobile_DOF_FarBlurFactor=false,Mobile_BlurAmount=16.0000000,Mobile_TransitionTime=1.0000000,Mobile_Bloom_Scale=6.0000000,Mobile_Bloom_Threshold=0.5000000,Mobile_Bloom_Tint=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000),Mobile_DOF_Distance=1500.0000000,Mobile_DOF_MinRange=600.0000000,Mobile_DOF_MaxRange=1200.0000000,Mobile_DOF_NearBlurFactor=1.0000000,Mobile_DOF_FarBlurFactor=1.0000000))
	RenderingOverrides=(bAllowAmbientOcclusion=true,bAllowDominantWholeSceneDynamicShadows=true,bAllowMotionBlurSkinning=true,bAllowTemporalAA=true,bAllowLightShafts=true)
	CameraCache=(TimeStamp=0.0000000,POV=(Location=(X=0.0000000,Y=0.0000000,Z=0.0000000),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=90.0000000))
	LastFrameCameraCache=(TimeStamp=0.0000000,POV=(Location=(X=0.0000000,Y=0.0000000,Z=0.0000000),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=90.0000000))
	ViewTarget=(Target=none,Controller=none,POV=(Location=(X=0.0000000,Y=0.0000000,Z=0.0000000),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=90.0000000),AspectRatio=0.0000000,PRI=none)
	PendingViewTarget=(Target=none,Controller=none,POV=(Location=(X=0.0000000,Y=0.0000000,Z=0.0000000),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=90.0000000),AspectRatio=0.0000000,PRI=none)
	BlendParams=(BlendTime=0.0000000,BlendFunction=EViewTargetBlendFunction.VTBlend_Cubic,BlendExp=2.0000000,bLockOutgoing=false)
	FreeCamDistance=256.0000000
	CameraShakeCamModClass=Class'Engine.CameraModifier_CameraShake'
	CollisionType=ECollisionType.COLLIDE_CustomDefault
	bHidden=true
}