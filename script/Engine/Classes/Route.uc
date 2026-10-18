class Route extends Info
	native
	placeable
	implements(EditorLinkSelectionInterface);

enum ERouteFillAction
{
	RFA_Overwrite,                  // 0
	RFA_Add,                        // 1
	RFA_Remove,                     // 2
	RFA_Clear,                      // 3
	RFA_MAX                         // 4
};

enum ERouteDirection
{
	ERD_Forward,                    // 0
	ERD_Reverse,                    // 1
	ERD_MAX                         // 2
};

enum ERouteType
{
	ERT_Linear,                     // 0
	ERT_Loop,                       // 1
	ERT_Circle,                     // 2
	ERT_MAX                         // 3
};

var private native const noexport Pointer VfTable_IEditorLinkSelectionInterface;
var Route.ERouteType RouteType;
var array<ActorReference> RouteList;
var float FudgeFactor;
var int RouteIndexOffset;

// Export URoute::execResolveRouteIndex(FFrame&, void* const)
native final function int ResolveRouteIndex(int Idx, Route.ERouteDirection RouteDirection, out byte out_bComplete, out byte out_bReverse);

// Export URoute::execMoveOntoRoutePath(FFrame&, void* const)
native final function int MoveOntoRoutePath(Pawn P, optional Route.ERouteDirection RouteDirection = 0, optional float DistFudgeFactor = 1.0000000);

defaultproperties
{
	FudgeFactor=1.0000000
	Components[0]=none
	Components[1]=none
	Components[2]=none
	bStatic=true
}