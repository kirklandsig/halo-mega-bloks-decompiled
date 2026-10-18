class GFxHaloMainMenu_VSlice extends GFxHaloMainMenu
	config(Levels);

function LoadVerticalSliceLevel()
{
	ConsoleCommand("open VerticalSlicePersistent?GameType=Conquest?NumPlayers=1?MissionToJumpTo=Demo_Missions?SpawnPointToJumpTo=?StartingPawnClass=");
	//return;	
}

defaultproperties
{
	MovieInfo=SwfMovie'MainMenu.GFx_MainMenu_VSlice'
}