class UISceneClient extends UIRoot
	abstract
	transient
	native
	config(Engine);

const SCENEFILTER_None = 0x00000000;
const SCENEFILTER_IncludeTransient = 0x00000001;
const SCENEFILTER_InputProcessorOnly = 0x00000002;
const SCENEFILTER_PausersOnly = 0x00000004;
const SCENEFILTER_PrimitiveUsersOnly = 0x00000008;
const SCENEFILTER_UsesPostProcessing = 0x00000010;
const SCENEFILTER_ReceivesFocus = 0x00000020;
const SCENEFILTER_Any = 0xFFFFFFFF;

var private native const noexport Pointer VfTable_FExec;
var native const transient Pointer RenderViewport;
var const transient IntPoint MousePosition;
var const transient DataStoreClient DataStoreManager;
var const transient Matrix CanvasToScreen;
var const transient Matrix InvCanvasToScreen;
var transient PostProcessChain UIScenePostProcess;
var transient bool bEnablePostProcess;

// Export UUISceneClient::execIsUIActive(FFrame&, void* const)
native final function bool IsUIActive(optional int Flags = -1);

// Export UUISceneClient::execGetCanvasToScreen(FFrame&, void* const)
native final function Matrix GetCanvasToScreen();

// Export UUISceneClient::execGetInverseCanvasToScreen(FFrame&, void* const)
native final function Matrix GetInverseCanvasToScreen();

event InitializeSceneClient()
{
	//return;	
}

defaultproperties
{
	bEnablePostProcess=true
}