class AnimSequence extends Object
	native;

enum AnimationCompressionFormat
{
	ACF_None,                       // 0
	ACF_Float96NoW,                 // 1
	ACF_Fixed48NoW,                 // 2
	ACF_IntervalFixed32NoW,         // 3
	ACF_Fixed32NoW,                 // 4
	ACF_Float32NoW,                 // 5
	ACF_Identity,                   // 6
	ACF_MAX                         // 7
};

enum AnimationKeyFormat
{
	AKF_ConstantKeyLerp,            // 0
	AKF_VariableKeyLerp,            // 1
	AKF_PerTrackCompression,        // 2
	AKF_MAX                         // 3
};

struct native AnimNotifyEvent
{
	var float Time;
	var export editinline AnimNotify Notify;
	var float Duration;

	structdefaultproperties
	{
		Time=0.0000000
		Notify=none
		Duration=0.0000000
	}
};

struct RawAnimSequenceTrack
{
	var array<Vector> PosKeys;
	var array<Quat> RotKeys;

	structdefaultproperties
	{
		PosKeys=none
		RotKeys=none
	}
};

struct native TimeModifier
{
	var float Time;
	var float TargetStrength;

	structdefaultproperties
	{
		Time=0.0000000
		TargetStrength=0.0000000
	}
};

struct native SkelControlModifier
{
	var name SkelControlName;
	var editinline array<editinline TimeModifier> Modifiers;

	structdefaultproperties
	{
		SkelControlName="None"
		Modifiers=none
	}
};

struct native TranslationTrack
{
	var array<Vector> PosKeys;
	var array<float> Times;

	structdefaultproperties
	{
		PosKeys=none
		Times=none
	}
};

struct native RotationTrack
{
	var array<Quat> RotKeys;
	var array<float> Times;

	structdefaultproperties
	{
		RotKeys=none
		Times=none
	}
};

struct native CurveTrack
{
	var name CurveName;
	var array<float> CurveWeights;

	structdefaultproperties
	{
		CurveName="None"
		CurveWeights=none
	}
};

struct native CompressedTrack
{
	var array<byte> ByteStream;
	var array<float> Times;
	var float Mins[3];
	var float Ranges[3];

	structdefaultproperties
	{
		ByteStream=none
		Times=none
		Mins[0]=0.0000000
		Mins[1]=0.0000000
		Mins[2]=0.0000000
		Ranges[0]=0.0000000
		Ranges[1]=0.0000000
		Ranges[2]=0.0000000
	}
};

var name SequenceName;
var editinline array<editinline AnimNotifyEvent> Notifies;
var export editinline array<export editinline AnimMetaData> MetaData;
var editinline deprecated array<editinline deprecated SkelControlModifier> BoneControlModifiers;
var float SequenceLength;
var int NumFrames;
var float RateScale;
var bool bNoLoopingInterpolation;
var const bool bIsAdditive;
var bool bAdditiveBuiltLooping;
var editoronly const bool bDoNotOverrideCompression;
var const transient bool bHasBeenUsed;
var bool bWasCompressedWithoutTranslations;
var private const deprecated array<deprecated RawAnimSequenceTrack> RawAnimData;
var private native const array<RawAnimSequenceTrack> RawAnimationData;
var const transient array<TranslationTrack> TranslationData;
var const transient array<RotationTrack> RotationData;
var const array<CurveTrack> CurveData;
var const AnimSequence.AnimationCompressionFormat TranslationCompressionFormat;
var const AnimSequence.AnimationCompressionFormat RotationCompressionFormat;
var const AnimSequence.AnimationKeyFormat KeyEncodingFormat;
var array<int> CompressedTrackOffsets;
var native array<byte> CompressedByteStream;
var private native transient Pointer TranslationCodec;
var private native transient Pointer RotationCodec;
var const deprecated array<deprecated BoneAtom> AdditiveRefPose;
var const array<RawAnimSequenceTrack> AdditiveBasePose;
var const int EncodingPkgVersion;
var const transient float UseScore;

// Export UAnimSequence::execGetNotifyTimeByClass(FFrame&, void* const)
native function float GetNotifyTimeByClass(Class<AnimNotify> NotifyClass, optional float PlayRate = 1.0000000, optional float StartPosition = -1.0000000, optional out AnimNotify out_Notify, optional out float out_Duration);

defaultproperties
{
	RateScale=1.0000000
}