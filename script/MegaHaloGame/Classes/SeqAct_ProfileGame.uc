class SeqAct_ProfileGame extends SequenceAction
	config(AutomateLevels);

var bool Stats_SnapShot;
var bool Stats_StartRecord;
var bool Stats_StopRecord;
var config bool GrabScreenShot;
var config bool WriteOutStatFile;
var config bool WriteOutPixDump;
var config bool FullProfile;
var config int FullProfile_Time;

event Activated()
{
	local WorldInfo WI;
	local PlayerController PC;

	WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
	// End:0x2BC
	foreach WI.AllControllers(Class'Engine.PlayerController', PC)
	{
		// End:0x2BB
		if(PC.bIsPlayer && PC.IsLocalPlayerController())
		{
			// End:0x191
			if(Stats_SnapShot)
			{				
				PC.ConsoleCommand("haloprofile record");
				// End:0x13D
				if(FullProfile)
				{					
					PC.ConsoleCommand("ProfileHalo" @ string(FullProfile_Time));
				}
				// End:0x184
				if(WriteOutPixDump)
				{					
					PC.ConsoleCommand("haloprofile pix");
				}
				// End:0x191
				if(GrabScreenShot)
				{
				}
			}
			// End:0x220
			if(Stats_StartRecord)
			{
				// End:0x1E4
				if(WriteOutStatFile)
				{					
					PC.ConsoleCommand("stat startfile");
				}				
				PC.ConsoleCommand("haloprofile start");
			}
			// End:0x2BB
			if(Stats_StopRecord)
			{
				// End:0x27C
				if(WriteOutStatFile)
				{					
					PC.ConsoleCommand("stat stopfilenoautoopen");
				}				
				PC.ConsoleCommand("haloprofile complete");
			}
		}		
	}	
	//return;	
}

defaultproperties
{
	FullProfile_Time=1
	ObjName="Profile Game"
}