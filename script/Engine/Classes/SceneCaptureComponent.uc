class SceneCaptureComponent extends ActorComponent
	abstract
	native;

enum ESceneCaptureViewMode
{
	SceneCapView_Lit,               // 0
	SceneCapView_Unlit,             // 1
	SceneCapView_LitNoShadows,      // 2
	SceneCapView_Wire,              // 3
	SceneCapView_MAX                // 4
};

var bool bEnabled;
var bool bEnablePostProcess;
var bool bEnableFog;
var bool bUseMainScenePostProcessSettings;
var bool bSkipUpdateIfTextureUsersOccluded;
var bool bSkipUpdateIfOwnerOccluded;
var bool bSkipRenderingDepthPrepass;
var const bool bAlwaysCapture;
var const bool bCaptureMainScene;
var Color ClearColor;
var SceneCaptureComponent.ESceneCaptureViewMode ViewMode;
var int SceneLOD;
var const float FrameRate;
var PostProcessChain PostProcess;
var float MaxUpdateDist;
var float MaxViewDistanceOverride;
var float MaxStreamingUpdateDist;
var private native const transient Pointer CaptureInfo;
var private native const transient Pointer ViewState;
var noimport duplicatetransient native const transient array<Pointer> PostProcessProxies;
var private native const transient Pointer CaptureScene;

// Export USceneCaptureComponent::execSetFrameRate(FFrame&, void* const)
native final function SetFrameRate(float NewFrameRate);

// Export USceneCaptureComponent::execSetEnabled(FFrame&, void* const)
native final simulated function SetEnabled(bool bEnable);

// Export USceneCaptureComponent::execAddComponent(FFrame&, void* const)
native final function AddComponent(ActorComponent InComponent, Rotator InWorldRot);

// Export USceneCaptureComponent::execRemoveComponent(FFrame&, void* const)
native final function RemoveComponent(ActorComponent InComponent);

defaultproperties
{
	bEnabled=true
	bSkipRenderingDepthPrepass=true
	bCaptureMainScene=true
	ClearColor=(R=0,G=0,B=255,A=0)
	ViewMode=ESceneCaptureViewMode.SceneCapView_LitNoShadows
	FrameRate=30.0000000
}