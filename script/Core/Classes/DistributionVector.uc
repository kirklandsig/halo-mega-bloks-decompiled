class DistributionVector extends Component
	abstract
	native
	editinlinenew
	collapsecategories;

enum EDistributionVectorLockFlags
{
	EDVLF_None,                     // 0
	EDVLF_XY,                       // 1
	EDVLF_XZ,                       // 2
	EDVLF_YZ,                       // 3
	EDVLF_XYZ,                      // 4
	EDVLF_MAX                       // 5
};

enum EDistributionVectorMirrorFlags
{
	EDVMF_Same,                     // 0
	EDVMF_Different,                // 1
	EDVMF_Mirror,                   // 2
	EDVMF_MAX                       // 3
};

struct native RawDistributionVector extends RawDistribution
{
	var noclear export editinline DistributionVector Distribution;
};

var private native const noexport Pointer VfTable_FCurveEdInterface;
var bool bCanBeBaked;
var bool bIsDirty;

// Export UDistributionVector::execGetVectorValue(FFrame&, void* const)
native function Vector GetVectorValue(optional float F = 0.0000000, optional int LastExtreme = 0);

defaultproperties
{
	bCanBeBaked=true
	bIsDirty=true
}