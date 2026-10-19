class SoundCue extends AkBaseSoundObject
	native
	dependson(AudioDevice);

struct native export SoundNodeEditorData
{
	var native const int NodePosX;
	var native const int NodePosY;
};

var name SoundClass;
var AudioDevice.ESoundClassName SoundClassName;
var bool bDebug;
var SoundNode FirstNode;
var native const map{VOID,VOID} EditorData;
var transient float MaxAudibleDistance;
var float VolumeMultiplier;
var float PitchMultiplier;
var float Duration;
var FaceFXAnimSet FaceFXAnimSetRef;
var string FaceFXGroupName;
var string FaceFXAnimName;
var int MaxConcurrentPlayCount;
var duplicatetransient const transient int CurrentPlayCount;
var deprecated name SoundGroup;

// Export USoundCue::execGetCueDuration(FFrame&, void* const)
native final function float GetCueDuration();

defaultproperties
{
	VolumeMultiplier=0.7500000
	PitchMultiplier=1.0000000
	MaxConcurrentPlayCount=16
}