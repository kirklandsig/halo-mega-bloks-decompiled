class GripDebugCameraHUD extends DebugCameraHUD
	transient
	config(Game);

event PostRender()
{
	local DebugCameraController DCC;

	super.PostRender();
	DCC = DebugCameraController(PlayerOwner);
	// End:0x5D
	if(DCC != none)
	{
		Class'Grip.GripDrawHUD'.static.DrawHUD(Canvas);
	}
	//return;	
}
