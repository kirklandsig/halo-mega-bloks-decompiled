class PlayerStart extends NavigationPoint
	native
	notplaceable
	dependson(Canvas);

var bool bEnabled;
var bool bPrimaryStart;
var bool bBestStart;
var bool bClaimedAsPrimaryStart;
var int TeamIndex;
var int Score;
var int SelectionIndex;

simulated function OnToggle(SeqAct_Toggle Action)
{
	// End:0x46
	if(Action.InputLinks[0].bHasImpulse)
	{
		bEnabled = true;		
	}
	else
	{
		// End:0x8C
		if(Action.InputLinks[1].bHasImpulse)
		{
			bEnabled = false;			
		}
		else
		{
			// End:0xDB
			if(Action.InputLinks[2].bHasImpulse)
			{
				bEnabled = !bEnabled;
			}
		}
	}
	//return;	
}

simulated event PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
	local float NameXL, TextYL, YL, XL, textscale;

	local Vector ScreenLoc, ViewLoc;
	local Rotator ViewRot;
	local string ScreenName;
	local FontRenderInfo FontInfo;

	PC.GetPlayerViewPoint(ViewLoc, ViewRot);
	// End:0x5E
	if((Vector(ViewRot) Dot (Location - ViewLoc)) < 0.5000000)
	{
		return;
	}
	ScreenLoc = Canvas.Project(Location);
	// End:0x15E
	if((((ScreenLoc.X < float(0)) || ScreenLoc.X >= Canvas.ClipX) || ScreenLoc.Y < float(0)) || ScreenLoc.Y >= Canvas.ClipY)
	{
		return;
	}
	ScreenName = (("(" $ string(SelectionIndex)) $ ")") @ string(Score);
	Canvas.StrLen(ScreenName, NameXL, TextYL);
	XL = FMax(XL, NameXL);
	YL += TextYL;
	textscale = 1.0000000;
	// End:0x261
	if(bBestStart)
	{
		Canvas.DrawColor = Class'Engine.HUD'.default.GreenColor;
		textscale = 4.0000000;		
	}
	else
	{
		// End:0x2EA
		if(float(Score) == 10000000.0000000)
		{
			Canvas.DrawColor = Class'Engine.HUD'.default.WhiteColor;
			Canvas.DrawColor.B = 0;			
		}
		else
		{
			// End:0x3AD
			if(float(Score) == 0.0000000)
			{
				Canvas.DrawColor.R = 200;
				Canvas.DrawColor.G = 50;
				Canvas.DrawColor.B = 255;
				textscale = 0.5000000;				
			}
			else
			{
				Canvas.DrawColor = Class'Engine.HUD'.default.RedColor;
			}
		}
	}
	Canvas.SetPos(ScreenLoc.X - (0.5000000 * NameXL), ScreenLoc.Y - (1.7000000 * YL));
	FontInfo.bClipText = true;
	Canvas.DrawText(ScreenName, true, textscale, textscale, FontInfo);
	//return;	
}

defaultproperties
{
	bEnabled=true
	// Reference: CylinderComponent'Engine.Default__PlayerStart.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__NavigationPoint.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=80.0000000
		CollisionRadius=40.0000000
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=none
	Components[1]=none
	Components[2]=none
	Components[3]=CollisionCylinder
	Components[4]=none
	bCollideWhenPlacing=false
	bEdShouldSnap=true
	CollisionComponent=CollisionCylinder
}