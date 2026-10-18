class GripBTObject extends Object
	abstract
	native;

enum BTNodeFamily
{
	NT_BEHAVIOR,                    // 0
	NT_CONTROL,                     // 1
	NT_CONDITION,                   // 2
	NT_MAX                          // 3
};

enum BTNodeExpandSymbol
{
	NS_NO_SIGN,                     // 0
	NS_PLUS,                        // 1
	NS_MINUS,                       // 2
	NS_MAX                          // 3
};

enum BTMenuType
{
	MT_BEHAVIOR,                    // 0
	MT_CONDITION,                   // 1
	MT_CONTROL,                     // 2
	MT_TEST,                        // 3
	MT_ROOT,                        // 4
	MT_HIDDEN,                      // 5
	MT_NUMOF,                       // 6
	MT_MAX                          // 7
};

struct native NodeChild
{
	var name Name;
	var export editinline GripBTNode Node;
	var float Weight;
	var int DrawY;

	structdefaultproperties
	{
		Name="None"
		Node=none
		Weight=0.0000000
		DrawY=0
	}
};

var int dummyVarJustSoTheClassDoesNotStartWithAnEnum;
var bool childrenCollapsed;
