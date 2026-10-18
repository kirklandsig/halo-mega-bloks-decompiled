class HaloFootPlacementComponent extends ActorComponent;

var name LeftFootBone;
var name RightFootBone;
var float TraceRange;
var float MeshOffset;
var float StepUpSpeed;
var float FallSpeed;
var float FallSpeedReset;
var float SoleThickness;

function float GetFloorLocationFromFoot(HaloPawn Pawn, name FootBoneName)
{
	local Vector FootLocation, TraceStart, TraceEnd;
	local Actor HitActor;
	local Vector HitLocation, HitNormal;

	FootLocation = Pawn.Mesh.GetBoneLocation(FootBoneName);
	TraceStart = FootLocation;
	TraceStart.Z = Pawn.Location.Z - Pawn.CylinderComponent.CollisionHeight;
	TraceEnd = TraceStart;
	TraceEnd.Z -= TraceRange;
	HitActor = Pawn.Trace(HitLocation, HitNormal, TraceEnd, TraceStart, true,,, Pawn.1);
	// End:0x1A3
	if(HitActor != none)
	{
		return HitLocation.Z;
	}
	return TraceStart.Z;
	//return ReturnValue;	
}

function Tick(float DeltaTime)
{
	local HaloPawn Pawn;
	local float LeftFloorLocation, RightFloorLocation, BestFloorLocation, DesiredMeshOffset;
	local Vector DesiredMeshTranslation;

	Pawn = HaloPawn(Owner);
	// End:0x79
	if(((Pawn == none) || Pawn.Mesh == none) || Pawn.CylinderComponent == none)
	{
		return;
	}
	// End:0x1B8
	if(int(Pawn.Physics) == int(1))
	{
		LeftFloorLocation = GetFloorLocationFromFoot(Pawn, LeftFootBone);
		RightFloorLocation = GetFloorLocationFromFoot(Pawn, RightFootBone);
		BestFloorLocation = FMin(LeftFloorLocation, RightFloorLocation);
		DesiredMeshOffset = BestFloorLocation - (Pawn.Location.Z - Pawn.CylinderComponent.CollisionHeight);
		DesiredMeshOffset = FMin(DesiredMeshOffset, 0.0000000);
		DesiredMeshOffset += SoleThickness;		
	}
	else
	{
		DesiredMeshOffset = 0.0000000;
	}
	// End:0x22C
	if(DesiredMeshOffset > MeshOffset)
	{
		MeshOffset = FInterpConstantTo(MeshOffset, DesiredMeshOffset, DeltaTime, StepUpSpeed);
		FallSpeed = FallSpeedReset;		
	}
	else
	{
		MeshOffset += (DeltaTime * (FallSpeed + ((0.5000000 * DeltaTime) * Pawn.GetGravityZ())));
		FallSpeed += (DeltaTime * Pawn.GetGravityZ());
		// End:0x2F0
		if(MeshOffset <= DesiredMeshOffset)
		{
			MeshOffset = DesiredMeshOffset;
			FallSpeed = FallSpeedReset;
		}
	}
	DesiredMeshTranslation = Pawn.Mesh.default.Translation;
	DesiredMeshTranslation.Z += MeshOffset;
	Pawn.Mesh.SetTranslation(DesiredMeshTranslation);
	//return;	
}

defaultproperties
{
	LeftFootBone="Bip001-L-Foot"
	RightFootBone="Bip001-R-Foot"
	TraceRange=75.0000000
	StepUpSpeed=400.0000000
	FallSpeed=-150.0000000
	FallSpeedReset=-150.0000000
	SoleThickness=7.0000000
}