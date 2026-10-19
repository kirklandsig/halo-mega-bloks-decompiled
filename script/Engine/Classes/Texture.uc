class Texture extends Surface
	abstract
	native;

enum TextureCompressionSettings
{
	TC_Default,                     // 0
	TC_Normalmap,                   // 1
	TC_Displacementmap,             // 2
	TC_NormalmapAlpha,              // 3
	TC_Grayscale,                   // 4
	TC_HighDynamicRange,            // 5
	TC_OneBitAlpha,                 // 6
	TC_NormalmapUncompressed,       // 7
	TC_NormalmapBC5,                // 8
	TC_OneBitMonochrome,            // 9
	TC_SimpleLightmapModification,  // 10
	TC_VectorDisplacementmap,       // 11
	TC_MAX                          // 12
};

enum EPixelFormat
{
	PF_Unknown,                     // 0
	PF_A32B32G32R32F,               // 1
	PF_A8R8G8B8,                    // 2
	PF_G8,                          // 3
	PF_G16,                         // 4
	PF_DXT1,                        // 5
	PF_DXT3,                        // 6
	PF_DXT5,                        // 7
	PF_UYVY,                        // 8
	PF_FloatRGB,                    // 9
	PF_FloatRGBA,                   // 10
	PF_DepthStencil,                // 11
	PF_ShadowDepth,                 // 12
	PF_FilteredShadowDepth,         // 13
	PF_R32F,                        // 14
	PF_G16R16,                      // 15
	PF_G16R16F,                     // 16
	PF_G16R16F_FILTER,              // 17
	PF_G32R32F,                     // 18
	PF_A2B10G10R10,                 // 19
	PF_A16B16G16R16,                // 20
	PF_D24,                         // 21
	PF_R16F,                        // 22
	PF_R16F_FILTER,                 // 23
	PF_BC5,                         // 24
	PF_V8U8,                        // 25
	PF_A1,                          // 26
	PF_FloatR11G11B10,              // 27
	PF_A4R4G4B4,                    // 28
	PF_MAX                          // 29
};

enum TextureFilter
{
	TF_Nearest,                     // 0
	TF_Linear,                      // 1
	TF_MAX                          // 2
};

enum TextureAddress
{
	TA_Wrap,                        // 0
	TA_Clamp,                       // 1
	TA_Mirror,                      // 2
	TA_MAX                          // 3
};

enum TextureGroup
{
	TEXTUREGROUP_World,             // 0
	TEXTUREGROUP_WorldNormalMap,    // 1
	TEXTUREGROUP_WorldSpecular,     // 2
	TEXTUREGROUP_Character,         // 3
	TEXTUREGROUP_CharacterNormalMap,// 4
	TEXTUREGROUP_CharacterSpecular, // 5
	TEXTUREGROUP_Weapon,            // 6
	TEXTUREGROUP_WeaponNormalMap,   // 7
	TEXTUREGROUP_WeaponSpecular,    // 8
	TEXTUREGROUP_Vehicle,           // 9
	TEXTUREGROUP_VehicleNormalMap,  // 10
	TEXTUREGROUP_VehicleSpecular,   // 11
	TEXTUREGROUP_Cinematic,         // 12
	TEXTUREGROUP_Effects,           // 13
	TEXTUREGROUP_EffectsNotFiltered,// 14
	TEXTUREGROUP_Skybox,            // 15
	TEXTUREGROUP_UI,                // 16
	TEXTUREGROUP_Lightmap,          // 17
	TEXTUREGROUP_RenderTarget,      // 18
	TEXTUREGROUP_MobileFlattened,   // 19
	TEXTUREGROUP_ProcBuilding_Face, // 20
	TEXTUREGROUP_ProcBuilding_LightMap,// 21
	TEXTUREGROUP_Shadowmap,         // 22
	TEXTUREGROUP_ColorLookupTable,  // 23
	TEXTUREGROUP_Terrain_Heightmap, // 24
	TEXTUREGROUP_Terrain_Weightmap, // 25
	TEXTUREGROUP_ImageBasedReflection,// 26
	TEXTUREGROUP_Bokeh,             // 27
	TEXTUREGROUP_MAX                // 28
};

enum TextureMipGenSettings
{
	TMGS_FromTextureGroup,          // 0
	TMGS_SimpleAverage,             // 1
	TMGS_Sharpen0,                  // 2
	TMGS_Sharpen1,                  // 3
	TMGS_Sharpen2,                  // 4
	TMGS_Sharpen3,                  // 5
	TMGS_Sharpen4,                  // 6
	TMGS_Sharpen5,                  // 7
	TMGS_Sharpen6,                  // 8
	TMGS_Sharpen7,                  // 9
	TMGS_Sharpen8,                  // 10
	TMGS_Sharpen9,                  // 11
	TMGS_Sharpen10,                 // 12
	TMGS_NoMipmaps,                 // 13
	TMGS_LeaveExistingMips,         // 14
	TMGS_Blur1,                     // 15
	TMGS_Blur2,                     // 16
	TMGS_Blur3,                     // 17
	TMGS_Blur4,                     // 18
	TMGS_Blur5,                     // 19
	TMGS_MAX                        // 20
};

enum ETextureMipCount
{
	TMC_ResidentMips,               // 0
	TMC_AllMips,                    // 1
	TMC_AllMipsBiased,              // 2
	TMC_MAX                         // 3
};

struct native TextureGroupContainer
{
	var const bool TEXTUREGROUP_World;
	var const bool TEXTUREGROUP_WorldNormalMap;
	var const bool TEXTUREGROUP_WorldSpecular;
	var const bool TEXTUREGROUP_Character;
	var const bool TEXTUREGROUP_CharacterNormalMap;
	var const bool TEXTUREGROUP_CharacterSpecular;
	var const bool TEXTUREGROUP_Weapon;
	var const bool TEXTUREGROUP_WeaponNormalMap;
	var const bool TEXTUREGROUP_WeaponSpecular;
	var const bool TEXTUREGROUP_Vehicle;
	var const bool TEXTUREGROUP_VehicleNormalMap;
	var const bool TEXTUREGROUP_VehicleSpecular;
	var const bool TEXTUREGROUP_Cinematic;
	var const bool TEXTUREGROUP_Effects;
	var const bool TEXTUREGROUP_EffectsNotFiltered;
	var const bool TEXTUREGROUP_Skybox;
	var const bool TEXTUREGROUP_UI;
	var const bool TEXTUREGROUP_Lightmap;
	var const bool TEXTUREGROUP_RenderTarget;
	var const bool TEXTUREGROUP_MobileFlattened;
	var const bool TEXTUREGROUP_ProcBuilding_Face;
	var const bool TEXTUREGROUP_ProcBuilding_LightMap;
	var const bool TEXTUREGROUP_Shadowmap;
	var const bool TEXTUREGROUP_ColorLookupTable;
	var const bool TEXTUREGROUP_Terrain_Heightmap;
	var const bool TEXTUREGROUP_Terrain_Weightmap;
	var const bool TEXTUREGROUP_ImageBasedReflection;
	var const bool TEXTUREGROUP_Bokeh;

	structdefaultproperties
	{
		TEXTUREGROUP_World=false
		TEXTUREGROUP_WorldNormalMap=false
		TEXTUREGROUP_WorldSpecular=false
		TEXTUREGROUP_Character=false
		TEXTUREGROUP_CharacterNormalMap=false
		TEXTUREGROUP_CharacterSpecular=false
		TEXTUREGROUP_Weapon=false
		TEXTUREGROUP_WeaponNormalMap=false
		TEXTUREGROUP_WeaponSpecular=false
		TEXTUREGROUP_Vehicle=false
		TEXTUREGROUP_VehicleNormalMap=false
		TEXTUREGROUP_VehicleSpecular=false
		TEXTUREGROUP_Cinematic=false
		TEXTUREGROUP_Effects=false
		TEXTUREGROUP_EffectsNotFiltered=false
		TEXTUREGROUP_Skybox=false
		TEXTUREGROUP_UI=false
		TEXTUREGROUP_Lightmap=false
		TEXTUREGROUP_RenderTarget=false
		TEXTUREGROUP_MobileFlattened=false
		TEXTUREGROUP_ProcBuilding_Face=false
		TEXTUREGROUP_ProcBuilding_LightMap=false
		TEXTUREGROUP_Shadowmap=false
		TEXTUREGROUP_ColorLookupTable=false
		TEXTUREGROUP_Terrain_Heightmap=false
		TEXTUREGROUP_Terrain_Weightmap=false
		TEXTUREGROUP_ImageBasedReflection=false
		TEXTUREGROUP_Bokeh=false
	}
};

var bool SRGB;
var bool RGBE;
var bool bIsSourceArtUncompressed;
var bool CompressionNoAlpha;
var bool CompressionNone;
var deprecated bool CompressionNoMipmaps;
var bool CompressionFullDynamicRange;
var bool DeferCompression;
var bool NeverStream;
var bool bDitherMipMapAlpha;
var bool bPreserveBorderR;
var bool bPreserveBorderG;
var bool bPreserveBorderB;
var bool bPreserveBorderA;
var const bool bNoTiling;
var bool bForcePVRTC4;
var private const transient bool bAsyncResourceReleaseHasBeenStarted;
var private const transient bool bUseCinematicMipLevels;
var float UnpackMin[4];
var float UnpackMax[4];
var native const UntypedBulkData_Mirror SourceArt;
var Texture.TextureCompressionSettings CompressionSettings;
var Texture.TextureFilter Filter;
var Texture.TextureGroup LODGroup;
var private transient Texture.TextureGroup CachedLODGroup;
var Texture.TextureMipGenSettings MipGenSettings;
var int LODBias;
var transient int CachedCombinedLODBias;
var int NumCinematicMipLevels;
var native const Pointer Resource;
var float AdjustBrightness;
var float AdjustBrightnessCurve;
var float AdjustVibrance;
var float AdjustSaturation;
var float AdjustRGBCurve;
var float AdjustHue;
var const int InternalFormatLODBias;

defaultproperties
{
	SRGB=true
	UnpackMax[0]=1.0000000
	UnpackMax[1]=1.0000000
	UnpackMax[2]=1.0000000
	UnpackMax[3]=1.0000000
	Filter=TF_Linear
	AdjustBrightness=1.0000000
	AdjustBrightnessCurve=1.0000000
	AdjustSaturation=1.0000000
	AdjustRGBCurve=1.0000000
}