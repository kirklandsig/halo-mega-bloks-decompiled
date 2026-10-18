class TextureFlipBook extends Texture2D
	native;

enum TextureFlipBookMethod
{
	TFBM_UL_ROW,                    // 0
	TFBM_UL_COL,                    // 1
	TFBM_UR_ROW,                    // 2
	TFBM_UR_COL,                    // 3
	TFBM_LL_ROW,                    // 4
	TFBM_LL_COL,                    // 5
	TFBM_LR_ROW,                    // 6
	TFBM_LR_COL,                    // 7
	TFBM_RANDOM,                    // 8
	TFBM_MAX                        // 9
};

var private native const noexport Pointer VfTable_FTickableObject;
var const transient float TimeIntoMovie;
var const transient float TimeSinceLastFrame;
var const transient float HorizontalScale;
var const transient float VerticalScale;
var const bool bPaused;
var const bool bStopped;
var bool bLooping;
var bool bAutoPlay;
var int HorizontalImages;
var int VerticalImages;
var TextureFlipBook.TextureFlipBookMethod FBMethod;
var float FrameRate;
var private float FrameTime;
var const transient int CurrentRow;
var const transient int CurrentColumn;
var const transient float RenderOffsetU;
var const transient float RenderOffsetV;
var native const Pointer ReleaseResourcesFence;

// Export UTextureFlipBook::execPlay(FFrame&, void* const)
native function Play();

// Export UTextureFlipBook::execPause(FFrame&, void* const)
native function Pause();

// Export UTextureFlipBook::execStop(FFrame&, void* const)
native function Stop();

// Export UTextureFlipBook::execSetCurrentFrame(FFrame&, void* const)
native function SetCurrentFrame(int Row, int Col);

defaultproperties
{
	bLooping=true
	bAutoPlay=true
	HorizontalImages=1
	VerticalImages=1
	FrameRate=4.0000000
	FrameTime=0.2500000
	AddressX=TextureAddress.TA_Clamp
	AddressY=TextureAddress.TA_Clamp
}