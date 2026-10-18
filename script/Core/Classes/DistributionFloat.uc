class DistributionFloat extends Component
	abstract
	native
	editinlinenew
	collapsecategories;

struct native RawDistributionFloat extends RawDistribution
{
	var noclear export editinline DistributionFloat Distribution;
};

struct native MatineeRawDistributionFloat extends RawDistributionFloat
{
	var float MatineeValue;
	var bool bInMatinee;
};

var private native const noexport Pointer VfTable_FCurveEdInterface;
var bool bCanBeBaked;
var bool bIsDirty;

// Export UDistributionFloat::execGetFloatValue(FFrame&, void* const)
native function float GetFloatValue(optional float F = 0.0000000);

defaultproperties
{
	bCanBeBaked=true
	bIsDirty=true
}