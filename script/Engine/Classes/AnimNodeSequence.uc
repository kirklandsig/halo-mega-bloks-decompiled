class AnimNodeSequence extends AnimNode
	native;

enum ERootBoneAxis
{
	RBA_Default,                    // 0
	RBA_Discard,                    // 1
	RBA_Translate,                  // 2
	RBA_MAX                         // 3
};

enum ERootRotationOption
{
	RRO_Default,                    // 0
	RRO_Discard,                    // 1
	RRO_Extract,                    // 2
	RRO_MAX                         // 3
};

var const name AnimSeqName;
var float Rate;
var bool bPlaying;
var bool bLooping;
var bool bCauseActorAnimEnd;
var bool bCauseActorAnimPlay;
var bool bZeroRootRotation;
var bool bZeroRootTranslation;
var bool bDisableWarningWhenAnimNotFound;
var const bool bSkipNextTick;
var bool bNoNotifies;
var bool bForceRefposeWhenNotPlaying;
var bool bIsIssuingNotifies;
var bool bForceAlwaysSlave;
var const bool bSynchronize;
var const bool bReverseSync;
var bool bShowTimeLineSlider;
var bool bLoopCameraAnim;
var bool bRandomizeCameraAnimLoopStartTime;
var const bool bEditorOnlyAddRefPoseToAdditiveAnimation;
var transient bool bCheckForFinishAnimEarly;
var transient bool bBlendingOut;
var const float CurrentTime;
var const transient float PreviousTime;
var const transient float EndTime;
var const transient AnimSequence AnimSeq;
var const transient int AnimLinkupIndex;
var float NotifyWeightThreshold;
var const name SynchGroupName;
var float SynchPosOffset;
var CameraAnim CameraAnim;
var transient CameraAnimInst ActiveCameraAnimInstance;
var float CameraAnimScale;
var float CameraAnimPlayRate;
var float CameraAnimBlendInTime;
var float CameraAnimBlendOutTime;
var const AnimNodeSequence.ERootBoneAxis RootBoneOption[3];
var const AnimNodeSequence.ERootRotationOption RootRotationOption[3];
var const transient array<SkelControlBase> MetaDataSkelControlList;

// Export UAnimNodeSequence::execSetAnim(FFrame&, void* const)
native function SetAnim(name Sequence);

// Export UAnimNodeSequence::execPlayAnim(FFrame&, void* const)
native function PlayAnim(optional bool bLoop = false, optional float InRate = 1.0000000, optional float StartTime = 0.0000000);

// Export UAnimNodeSequence::execStopAnim(FFrame&, void* const)
native function StopAnim();

// Export UAnimNodeSequence::execReplayAnim(FFrame&, void* const)
native function ReplayAnim();

// Export UAnimNodeSequence::execSetPosition(FFrame&, void* const)
native function SetPosition(float NewTime, bool bFireNotifies);

// Export UAnimNodeSequence::execGetNormalizedPosition(FFrame&, void* const)
native function float GetNormalizedPosition();

// Export UAnimNodeSequence::execFindGroupRelativePosition(FFrame&, void* const)
native function float FindGroupRelativePosition(float GroupRelativePosition);

// Export UAnimNodeSequence::execFindGroupPosition(FFrame&, void* const)
native function float FindGroupPosition(float GroupRelativePosition);

// Export UAnimNodeSequence::execGetGroupRelativePosition(FFrame&, void* const)
native function float GetGroupRelativePosition();

// Export UAnimNodeSequence::execGetGlobalPlayRate(FFrame&, void* const)
native function float GetGlobalPlayRate();

// Export UAnimNodeSequence::execGetAnimPlaybackLength(FFrame&, void* const)
native function float GetAnimPlaybackLength();

// Export UAnimNodeSequence::execGetTimeLeft(FFrame&, void* const)
native function float GetTimeLeft();

// Export UAnimNodeSequence::execSetRootBoneAxisOption(FFrame&, void* const)
native final function SetRootBoneAxisOption(optional AnimNodeSequence.ERootBoneAxis AxisX = 0, optional AnimNodeSequence.ERootBoneAxis AxisY = 0, optional AnimNodeSequence.ERootBoneAxis AxisZ = 0);

// Export UAnimNodeSequence::execSetRootBoneRotationOption(FFrame&, void* const)
native final function SetRootBoneRotationOption(optional AnimNodeSequence.ERootRotationOption AxisX = 0, optional AnimNodeSequence.ERootRotationOption AxisY = 0, optional AnimNodeSequence.ERootRotationOption AxisZ = 0);

defaultproperties
{
	Rate=1.0000000
	bSynchronize=true
	CameraAnimScale=1.0000000
	CameraAnimPlayRate=1.0000000
	CameraAnimBlendInTime=0.2000000
	CameraAnimBlendOutTime=0.2000000
}