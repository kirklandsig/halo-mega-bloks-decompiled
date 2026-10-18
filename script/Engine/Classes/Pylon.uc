class Pylon extends NavigationPoint
	native
	placeable
	implements(EditorLinkSelectionInterface,Interface_NavigationHandle);

enum ENavMeshEdgeType
{
	NAVEDGE_Normal,                 // 0
	NAVEDGE_Mantle,                 // 1
	NAVEDGE_Coverslip,              // 2
	NAVEDGE_SwatTurn,               // 3
	NAVEDGE_DropDown,               // 4
	NAVEDGE_PathObject,             // 5
	NAVEDGE_BackRefDummy,           // 6
	NAVEDGE_Jump,                   // 7
	NAVEDGE_MAX                     // 8
};

struct native atomicwhencooked immutablewhencooked PolyReference
{
	var ActorReference OwningPylon;
	var private int PolyId;
	var private native Pointer CachedPoly;

	structdefaultproperties
	{
		OwningPylon=/* ERROR: System.ArgumentException */
		PolyId=0
	}
};

var private native const noexport Pointer VfTable_IEditorLinkSelectionInterface;
var private native const noexport Pointer VfTable_IInterface_NavigationHandle;
var native const Pointer NavMeshPtr;
var native const Pointer ObstacleMesh;
var native const Pointer DynamicObstacleMesh;
var native const transient Pointer WorkingSetPtr;
var private native const transient Pointer PathObjectsThatAffectThisPylon;
var const transient array<Vector> NextPassSeedList;
var native const OctreeElementId OctreeId;
var native const Pointer OctreeIWasAddedTo;
var const Pylon NextPylon;
var array<Volume> ExpansionVolumes;
var float ExpansionRadius;
var const float MaxExpansionRadius;
var export editinline DrawPylonRadiusComponent PylonRadiusPreview;
var bool bImportedMesh;
var bool bUseExpansionSphereOverride;
var bool bNeedsCostCheck;
var transient bool bPylonInHighLevelPath;
var bool bUseRecast;
var transient bool bAllowRecastGenerator;
var bool bDrawEdgePolys;
var bool bDrawPolyBounds;
var bool bRenderInShowPaths;
var bool bDrawWalkableSurface;
var bool bDrawObstacleSurface;
var bool bSolidObstaclesInGame;
var transient bool bBuildThisPylon;
var bool bDisabled;
var bool bForceObstacleMeshCollision;
var Vector ExpansionSphereCenter;
var export editinline NavMeshRenderingComponent RenderingComp;
var const export editinline transient SpriteComponent BrokenSprite;
var array<Pylon> ImposterPylons;
var array<Actor> OnBuild_DisableCollisionForThese;
var array<Actor> OnBuild_EnableCollisionForThese;
var float MaxPolyHeight_Optional;
var byte NavMeshGenerator;
var transient array<KAggregateGeom> VoxelFilterBounds;
var transient array<Matrix> VoxelFilterTM;
var int DebugEdgeCount;
var transient Vector DebugPathExtent;
var transient Vector DebugPathStartLocation;

// Export UPylon::execOnPylonStatusChange(FFrame&, void* const)
native function OnPylonStatusChange();

// Export UPylon::execUpdateMeshForPreExistingNavMeshObstacles(FFrame&, void* const)
native function UpdateMeshForPreExistingNavMeshObstacles();

// Export UPylon::execFlushDynamicEdges(FFrame&, void* const)
native function FlushDynamicEdges();

function Vector GetTestPathExtent()
{
	local Class<Scout> ScoutClass;
	local Vector Extent;

	ScoutClass = Class<Scout>(DynamicLoadObject(Class'Engine.Engine'.default.ScoutClassName, Class'Core.Class'));
	Extent.X = ScoutClass.default.PathSizes[0].Radius;
	Extent.Y = ScoutClass.default.PathSizes[0].Radius;
	Extent.Z = ScoutClass.default.PathSizes[0].Height;
	return Extent;
	//return ReturnValue;	
}

function VerifyTopLevelConnections()
{
	local NavigationHandle DebugHandle;
	local int I, PtIdx;
	local Pylon NeighborPylon;
	local array<Vector> pts, Dst_Pts;
	local bool bFoundPath;

	DebugHandle = new (self) Class'Engine.NavigationHandle';
	DebugPathStartLocation = Location;
	DebugPathExtent = GetTestPathExtent();
	DebugHandle.GetValidPositionsForBox(Location, DebugPathExtent.X * float(10), DebugPathExtent, false, pts, 5);
	// End:0x131
	if(pts.Length == 0)
	{
		LogInternal(("PATH CONNECTION FAILURE!" @ string(self)) @ "Could not get valid start path location");
		DrawDebugLine(Location, Location + vect(0.0000000, 0.0000000, 100.0000000), 255, 255, 0, true);
		return;
	}
	I = 0;
	J0x13C:

	// End:0x4D9 [Loop If]
	if(I < PathList.Length)
	{
		NeighborPylon = Pylon(PathList[I].End.Actor);
		// End:0x4CB
		if(NeighborPylon != none)
		{
			DebugHandle.GetValidPositionsForBox(NeighborPylon.Location, DebugPathExtent.X * float(10), DebugPathExtent, false, Dst_Pts, 1);
			// End:0x2F2
			if(Dst_Pts.Length < 1)
			{
				LogInternal((("PATH CONNECTION FAILURE!" @ string(self)) @ "Could not get valid dest path location to ") @ string(NeighborPylon));
				DrawDebugLine(NeighborPylon.Location, NeighborPylon.Location + vect(0.0000000, 0.0000000, 100.0000000), 255, 255, 0, true);				
			}
			else
			{
				bFoundPath = false;
				PtIdx = 0;
				J0x309:

				// End:0x3E8 [Loop If]
				if(PtIdx < pts.Length)
				{
					DebugPathStartLocation = pts[PtIdx];
					Class'Engine.NavMeshPath_Toward'.static.TowardPoint(DebugHandle, Dst_Pts[0]);
					Class'Engine.NavMeshGoal_At'.static.AtLocation(DebugHandle, Dst_Pts[0]);
					// End:0x3DA
					if(DebugHandle.FindPath())
					{
						bFoundPath = true;
						// [Explicit Break]
						goto J0x3E8;
					}
					PtIdx++;
					// [Loop Continue]
					goto J0x309;
				}
				J0x3E8:

				// End:0x4CB
				if(bFoundPath!)
				{
					LogInternal((((((((("PATH CONNECTION FAILURE!" @ string(self)) @ "Location:'") $ string(Location)) $ "'") @ "failed to path to ") @ string(NeighborPylon)) @ "Dst_Pts[0]:'") $ string(Dst_Pts[0])) $ "'");
					DrawDebugLine(Location, Dst_Pts[0], 255, 0, 0, true);
					DrawDebugCoordinateSystem(Location, rot(0, 0, 0), 15.0000000, true);
				}
			}
		}
		I++;
		// [Loop Continue]
		goto J0x13C;
	}
	//return;	
}

event NotifyPathChanged()
{
	//return;	
}

function PostBeginPlay()
{
	super(Actor).PostBeginPlay();
	SetEnabled(bBlocked!);
	//return;	
}

event SetEnabled(bool bEnabled)
{
	bDisabled = bEnabled!;
	bForceObstacleMeshCollision = bDisabled;
	OnPylonStatusChange();
	//return;	
}

event bool IsEnabled()
{
	return bDisabled!;
	//return ReturnValue;	
}

function OnToggle(SeqAct_Toggle Action)
{
	// End:0x45
	if(Action.InputLinks[0].bHasImpulse)
	{
		SetEnabled(true);		
	}
	else
	{
		// End:0x8A
		if(Action.InputLinks[1].bHasImpulse)
		{
			SetEnabled(false);			
		}
		else
		{
			// End:0xD8
			if(Action.InputLinks[2].bHasImpulse)
			{
				SetEnabled(IsEnabled()!);
			}
		}
	}
	//return;	
}

// Export UPylon::execCanReachPylon(FFrame&, void* const)
native function bool CanReachPylon(Pylon DestPylon, Controller C);

defaultproperties
{
	ExpansionRadius=2048.0000000
	MaxExpansionRadius=7168.0000000
	bRenderInShowPaths=true
	bDrawWalkableSurface=true
	bDrawObstacleSurface=true
	DebugEdgeCount=-1
	bDestinationOnly=true
	// Reference: CylinderComponent'Engine.Default__Pylon.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__NavigationPoint.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=none
	Components[1]=none
	Components[2]=none
	Components[3]=CollisionCylinder
	Components[4]=none
	Components[5]=none
	Components[6]=none
	Components[7]=none
	CollisionComponent=CollisionCylinder
}