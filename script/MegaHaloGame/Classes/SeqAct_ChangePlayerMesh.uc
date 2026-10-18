class SeqAct_ChangePlayerMesh extends SequenceAction;

var SkeletalMesh NewMesh;
var MaterialInterface defaultMaterial0;
var AnimTree newAnimTree;
var array<AnimSet> NewAnimSet;
var PhysicsAsset NewPhysicsAsset;

event Activated()
{
	local int I;
	local UTPlayerController PC;

	PC = UTPlayerController(GetWorldInfo().GetALocalPlayerController());
	PC.Pawn.Mesh.SetSkeletalMesh(NewMesh);
	PC.Pawn.Mesh.SetPhysicsAsset(NewPhysicsAsset);
	PC.Pawn.Mesh.AnimSets = NewAnimSet;
	PC.Pawn.Mesh.SetAnimTreeTemplate(newAnimTree);
	I = 0;
	J0x188:

	// End:0x25D [Loop If]
	if(I < PC.Pawn.Mesh.SkeletalMesh.Materials.Length)
	{
		PC.Pawn.Mesh.SetMaterial(I, defaultMaterial0);
		I++;
		// [Loop Continue]
		goto J0x188;
	}
	//return;	
}

defaultproperties
{
	VariableLinks=none
	ObjName="ChangePlayerMesh"
}