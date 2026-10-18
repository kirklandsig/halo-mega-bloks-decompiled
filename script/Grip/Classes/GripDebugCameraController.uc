class GripDebugCameraController extends DebugCameraController
	config(Input);

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	// End:0x31
	if(myHUD != none)
	{
		myHUD.Destroy();
	}
	myHUD = Spawn(Class'Grip.GripDebugCameraHUD', self);
	//return;	
}

exec function GripDebugViewNPCFromBrainID(int BrainID)
{
	Class'Grip.GripDebug'.static.GripDebugViewNPCFromBrainID(BrainID);
	//return;	
}

defaultproperties
{
	InputClass=Class'Grip.GripDebugCameraInput'
	// Reference: CylinderComponent'Grip.Default__GripDebugCameraController.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'GameFramework.Default__DebugCameraController.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	CollisionComponent=CollisionCylinder
}