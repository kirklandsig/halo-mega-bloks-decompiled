class CCSBTSelectTarget extends GripBTNode
	native;

enum ECCSSelectTargetAlgorithm
{
	ECCSSelectTarget_Closest,       // 0
	ECCSSelectTarget_Closest_Objective,// 1
	ECCSSelectTarget_Closest_Reactive_Target,// 2
	ECCSSelectTarget_Specific_Tag,  // 3
	ECCSSelectTarget_HighestThreat, // 4
	ECCSSelectTarget_ClosestVehicle,// 5
	ECCSSelectTarget_None,          // 6
	ECCSSelectTarget_MAX            // 7
};

var CCSBTSelectTarget.ECCSSelectTargetAlgorithm TargetSelectionAlgorithm;
var string SpecificTargetName;

defaultproperties
{
	NodeDescription="Select a target using given selection algorithm."
	DefaultTitle="Select Target"
}