class UDKPlayerController extends GamePlayerController
	native
	config(Game);

struct native ObjectiveAnnouncementInfo
{
	var SoundNodeWave AnnouncementSound;
	var const localized string AnnouncementText;

	structdefaultproperties
	{
		AnnouncementSound=none
		AnnouncementText=""
	}
};

var CameraAnimInst CameraAnimPlayer;
var UDKEmitCameraEffect CameraEffect;
var bool bDedicatedServerSpectator;
var bool bAcuteHearing;
var bool bConsolePlayer;
var bool bPulseTeamColor;
var bool bUsePhysicsRotation;
var Vector ShakeOffset;
var Rotator ShakeRot;
var PostProcessSettings CamOverridePostProcess;
var PostProcessSettings PostProcessModifier;
var array<Actor> PotentiallyHiddenActors;
var float VehicleCheckRadiusScaling;
var float PulseTimer;

// Export UUDKPlayerController::execSetGamma(FFrame&, void* const)
native function SetGamma(float GammaValue);

// Export UUDKPlayerController::execSetHardwarePhysicsEnabled(FFrame&, void* const)
native function SetHardwarePhysicsEnabled(bool bEnabled);

// Export UUDKPlayerController::execIsKeyboardAvailable(FFrame&, void* const)
native simulated function bool IsKeyboardAvailable();

// Export UUDKPlayerController::execIsMouseAvailable(FFrame&, void* const)
native simulated function bool IsMouseAvailable();

function RemoveCameraEffect(UDKEmitCameraEffect CamEmitter)
{
	// End:0x22
	if(CameraEffect == CamEmitter)
	{
		CameraEffect = none;
	}
	//return;	
}

unreliable client simulated function ClientSpawnCameraEffect(Class<UDKEmitCameraEffect> CameraEffectClass)
{
	local Vector CamLoc;
	local Rotator CamRot;

	// End:0xC9
	if((CameraEffectClass != none) && CameraEffect == none)
	{
		CameraEffect = Spawn(CameraEffectClass, self);
		// End:0xC9
		if(CameraEffect != none)
		{
			GetPlayerViewPoint(CamLoc, CamRot);
			CameraEffect.RegisterCamera(self);
			CameraEffect.UpdateLocation(CamLoc, CamRot, FOVAngle);
		}
	}
	//return;	
}

function ClearCameraEffect()
{
	// End:0x32
	if(CameraEffect != none)
	{
		CameraEffect.Destroy();
		CameraEffect = none;
	}
	//return;	
}

// Export UUDKPlayerController::execGetTargetAdhesionFrictionTarget(FFrame&, void* const)
native function Pawn GetTargetAdhesionFrictionTarget(float MaxDistance, const out Vector CamLoc, const out Rotator CamRot);

// Export UUDKPlayerController::execIsAlertedEnemyInRange(FFrame&, void* const)
native function bool IsAlertedEnemyInRange(float Range);

// Export UUDKPlayerController::execFindPath(FFrame&, void* const)
native function bool FindPath(const Vector Destination, out array<Vector> PathPoints);

defaultproperties
{
	CamOverridePostProcess=(bOverride_EnableBloom=true,bOverride_EnableDOF=true,bOverride_EnableMotionBlur=true,bOverride_EnableSceneEffect=true,bOverride_AllowAmbientOcclusion=true,bOverride_OverrideRimShaderColor=true,bOverride_Bloom_Scale=true,bOverride_Bloom_Threshold=true,bOverride_Bloom_Tint=true,bOverride_Bloom_ScreenBlendThreshold=true,bOverride_Bloom_InterpolationDuration=true,bOverride_DOF_FalloffExponent=true,bOverride_DOF_BlurKernelSize=true,bOverride_DOF_BlurBloomKernelSize=true,bOverride_DOF_MaxNearBlurAmount=true,bOverride_DOF_MinBlurAmount=false,bOverride_DOF_MaxFarBlurAmount=true,bOverride_DOF_FocusType=true,bOverride_DOF_FocusInnerRadius=true,bOverride_DOF_FocusDistance=true,bOverride_DOF_FocusPosition=true,bOverride_DOF_InterpolationDuration=true,bOverride_DOF_BokehTexture=false,bOverride_MotionBlur_MaxVelocity=false,bOverride_MotionBlur_Amount=false,bOverride_MotionBlur_FullMotionBlur=false,bOverride_MotionBlur_CameraRotationThreshold=false,bOverride_MotionBlur_CameraTranslationThreshold=false,bOverride_MotionBlur_InterpolationDuration=false,bOverride_Scene_Desaturation=true,bOverride_Scene_Colorize=false,bOverride_Scene_TonemapperScale=false,bOverride_Scene_ImageGrainScale=false,bOverride_Scene_HighLights=true,bOverride_Scene_MidTones=true,bOverride_Scene_Shadows=true,bOverride_Scene_InterpolationDuration=true,bOverride_Scene_ColorGradingLUT=false,bOverride_RimShader_Color=true,bOverride_RimShader_InterpolationDuration=true,bOverride_MobileColorGrading=false,bEnableBloom=true,bEnableDOF=false,bEnableMotionBlur=true,bEnableSceneEffect=true,bAllowAmbientOcclusion=true,bOverrideRimShaderColor=false,Bloom_Scale=1.0000000,Bloom_Threshold=1.0000000,Bloom_Tint=(R=255,G=255,B=0,A=255),Bloom_ScreenBlendThreshold=10.0000000,Bloom_InterpolationDuration=1.0000000,DOF_BlurBloomKernelSize=16.0000000,DOF_FalloffExponent=4.0000000,DOF_BlurKernelSize=16.0000000,DOF_MaxNearBlurAmount=1.0000000,DOF_MinBlurAmount=0.0000000,DOF_MaxFarBlurAmount=1.0000000,DOF_FocusType=EFocusType.FOCUS_Distance,DOF_FocusInnerRadius=2000.0000000,DOF_FocusDistance=0.0000000,DOF_FocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),DOF_InterpolationDuration=1.0000000,DOF_BokehTexture=none,MotionBlur_MaxVelocity=1.0000000,MotionBlur_Amount=0.5000000,MotionBlur_FullMotionBlur=true,MotionBlur_CameraRotationThreshold=45.0000000,MotionBlur_CameraTranslationThreshold=10000.0000000,MotionBlur_InterpolationDuration=1.0000000,Scene_Desaturation=0.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_TonemapperScale=1.0000000,Scene_ImageGrainScale=0.0000000,Scene_HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Scene_InterpolationDuration=1.0000000,RimShader_Color=(R=1.0000000,G=0.8277260,B=0.5859730,A=0.4704400),RimShader_InterpolationDuration=1.0000000,ColorGrading_LookupTable=none,ColorGradingLUT=(LUTTextures=none,LUTWeights=none),MobileColorGrading=(TransitionTime=1.0000000,Blend=0.0000000,Desaturation=0.0000000,HighLights=(R=1.0000000,G=0.7000000,B=0.7000000,A=0.7000000),MidTones=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000),Shadows=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000)),MobilePostProcess=(bOverride_Mobile_BlurAmount=false,bOverride_Mobile_TransitionTime=false,bOverride_Mobile_Bloom_Scale=false,bOverride_Mobile_Bloom_Threshold=false,bOverride_Mobile_Bloom_Tint=false,bOverride_Mobile_DOF_Distance=false,bOverride_Mobile_DOF_MinRange=false,bOverride_Mobile_DOF_MaxRange=false,bOverride_Mobile_DOF_NearBlurFactor=false,bOverride_Mobile_DOF_FarBlurFactor=false,Mobile_BlurAmount=16.0000000,Mobile_TransitionTime=1.0000000,Mobile_Bloom_Scale=6.0000000,Mobile_Bloom_Threshold=0.5000000,Mobile_Bloom_Tint=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000),Mobile_DOF_Distance=1500.0000000,Mobile_DOF_MinRange=600.0000000,Mobile_DOF_MaxRange=1200.0000000,Mobile_DOF_NearBlurFactor=1.0000000,Mobile_DOF_FarBlurFactor=1.0000000))
	// Reference: CylinderComponent'UDKBase.Default__UDKPlayerController.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'GameFramework.Default__GamePlayerController.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	CollisionComponent=CollisionCylinder
}