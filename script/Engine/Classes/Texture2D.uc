class Texture2D extends Texture
	native;

struct native Texture2DMipMap
{
	var native UntypedBulkData_Mirror Data;
	var native int SizeX;
	var native int SizeY;
};

struct TextureLinkedListMirror
{
	var native const Pointer Element;
	var native const Pointer Next;
	var native const Pointer PrevLink;
};

var native const IndirectArray_Mirror Mips;
var native const IndirectArray_Mirror CachedPVRTCMips;
var native const IndirectArray_Mirror CachedATITCMips;
var native const int CachedFlashMipsMaxResolution;
var native const UntypedBulkData_Mirror CachedFlashMips;
var const int SizeX;
var const int SizeY;
var const int OriginalSizeX;
var const int OriginalSizeY;
var const Texture.EPixelFormat Format;
var Texture.TextureAddress AddressX;
var Texture.TextureAddress AddressY;
var const transient bool bIsStreamable;
var const transient bool bHasCancelationPending;
var const transient bool bHasBeenLoadedFromPersistentArchive;
var transient bool bForceMiplevelsToBeResident;
var const bool bGlobalForceMipLevelsToBeResident;
var const bool bIsCompositingSource;
var bool bHasBeenPaintedInEditor;
var private transient float ForceMipLevelsToBeResidentTimestamp;
var name TextureFileCacheName;
var native const Guid TextureFileCacheGuid;
var const transient int RequestedMips;
var const transient int ResidentMips;
var int MipsToRemoveOnCompress;
var native const transient ThreadSafeCounter PendingMipChangeRequestStatus;
var private array<byte> SystemMemoryData;
var private noimport duplicatetransient native const TextureLinkedListMirror StreamableTexturesLink;
var private duplicatetransient const transient int StreamingIndex;
var const int MipTailBaseIdx;
var private native const transient Pointer ResourceMem;
var private const int FirstResourceMemMip;
var private native const transient float Timer;

// Export UTexture2D::execSetForceMipLevelsToBeResident(FFrame&, void* const)
native final function SetForceMipLevelsToBeResident(float Seconds, optional int CinematicTextureGroups = 0);

// Export UTexture2D::execCreate(FFrame&, void* const)
native static final function Texture2D Create(int InSizeX, int InSizeY, optional Texture.EPixelFormat InFormat = 2);

defaultproperties
{
	StreamingIndex=-1
}