class HaloGrabbableLedge extends Actor
	placeable;

var export editinline SkeletalMeshComponent Mesh;
var export editinline CylinderComponent CylinderCollision;
var name EndPointSocketNames[2];

function GetEdgeVertices(float Radius, out Vector startPt, out Vector endPt, out Vector Edge)
{
	local Vector trim;

	// End:0x118
	if(Mesh != none)
	{
		Mesh.GetSocketWorldLocationAndRotation(EndPointSocketNames[0], startPt);
		Mesh.GetSocketWorldLocationAndRotation(EndPointSocketNames[1], endPt);
		Edge = endPt - startPt;
		// End:0x118
		if((Radius > 0.0001000) && VSizeSq(Edge) > (Radius * Radius))
		{
			trim = Radius * Normal(Edge);
			startPt += trim;
			endPt -= trim;
		}
	}
	//return;	
}

function float GetClosestGrabPoint(float Radius, Vector From, out Vector closest, optional out Vector Edge)
{
	local Vector startPt, endPt;

	GetEdgeVertices(Radius, startPt, endPt, Edge);
	return PointDistToSegment(From, startPt, endPt, closest);
	//return ReturnValue;	
}

defaultproperties
{
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloGrabbableLedge.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0" class=Engine.SkeletalMeshComponent
		SkeletalMesh=SkeletalMesh'WhiteBox_Alex.SM.GrabLedge'
		ReplacementPrimitive=none
	end object
	Mesh=SkeletalMeshComponent0
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloGrabbableLedge.CylinderComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CylinderComponent0'
	begin object name="CylinderComponent0" class=Engine.CylinderComponent
		CollisionHeight=500.0000000
		CollisionRadius=300.0000000
		ReplacementPrimitive=none
		CollideActors=true
		BlockZeroExtent=false
		BlockNonZeroExtent=false
	end object
	CylinderCollision=CylinderComponent0
	EndPointSocketNames[0]="Left_Side"
	EndPointSocketNames[1]="Right_Side"
	Components[0]=SkeletalMeshComponent0
	Components[1]=CylinderComponent0
	CollisionType=ECollisionType.COLLIDE_CustomDefault
	bStatic=true
	bHidden=true
	bTickIsDisabled=true
	bMovable=false
	bCollideActors=true
	bEdShouldSnap=true
	CollisionComponent=CylinderComponent0
}