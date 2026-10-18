class GwNavNavdataFamily extends Object
	native;

enum DistanceMapMetric
{
	MANHATTAN_METRIC,               // 0
	CHESSBOARD_METRIC,              // 1
	DistanceMapMetric_MAX           // 2
};

struct native MaterialFlag
{
	var int NavTagValue;
	var array<Material> Materials;
	var array<PhysicalMaterial> PhysicalMaterials;

	structdefaultproperties
	{
		NavTagValue=-1
		Materials=none
		PhysicalMaterials=none
	}
};

var float Height;
var float Radius;
var float StepMax;
var float SlopeMax;
var int NavTagValue;
var bool BackFacesWalkable;
var editoronly transient bool bShowInEditor;
var float Precision;
var float CellSize;
var float AltitudeTolerance;
var int DoUseAltitudeTolerance;
var float EarClippingTolerance;
var float AltitudeToleranceSamplingStep;
var float MinConnectedSurface;
var float NavTagRasterMergeTolerance;
var int NavTagMinPixelArea;
var GwNavNavdataFamily.DistanceMapMetric NavRasterDistanceMapMetric;
var Color DisplayColor;
var Material DisplayMaterial;
var Material WireFrameDisplayMaterial;
var Color WireFrameDisplayColor;

defaultproperties
{
	Height=2.0000000
	Radius=0.4000000
	StepMax=0.6000000
	SlopeMax=50.0000000
	NavTagValue=-1
	Precision=0.2000000
	CellSize=20.0000000
	AltitudeTolerance=0.5000000
	DoUseAltitudeTolerance=1
	AltitudeToleranceSamplingStep=0.3000000
	MinConnectedSurface=10.0000000
	NavTagRasterMergeTolerance=0.1000000
	NavTagMinPixelArea=6
	DisplayMaterial=Material'EngineGwNav.DebugRenderMaterial'
	WireFrameDisplayMaterial=Material'EngineGwNav.DebugWireFrameRenderMaterial'
}