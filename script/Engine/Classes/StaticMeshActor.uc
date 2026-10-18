class StaticMeshActor extends StaticMeshActorBase
	native
	placeable;

var const editconst export editinline StaticMeshComponent StaticMeshComponent;
var editoronly bool bDisableAutoBaseOnProcBuilding;
var private bool bProxy;
var private bool bHiddenByProxy;
var private bool OldCastShadow;
var private bool OldAcceptsLights;

event PreBeginPlay()
{
	//return;	
}

defaultproperties
{
	// Reference: StaticMeshComponent'Engine.Default__StaticMeshActor.StaticMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'StaticMeshComponent0'
	begin object name="StaticMeshComponent0" class=Engine.StaticMeshComponent
		ReplacementPrimitive=none
		bAllowApproximateOcclusion=true
		bForceDirectLightMap=true
		bUsePrecomputedShadows=true
	end object
	StaticMeshComponent=StaticMeshComponent0
	Components[0]=StaticMeshComponent0
	CollisionComponent=StaticMeshComponent0
}