class GFxHaloCrosshair extends GFxObject within GFxMoviePlayer;

enum CrosshairTargetType
{
	CTT_None,                       // 0
	CTT_LockOn,                     // 1
	CTT_Vehicle,                    // 2
	CTT_Ghost,                      // 3
	CTT_Turret,                     // 4
	CTT_MAX                         // 5
};

var WorldInfo ThisWorld;
var PlayerController PlayerOwner;
var GFxHaloMinimapHUD HUD;
var GFxObject Crosshairs;
var GFxObject DBGTF;
var GFxObject DBG2TF;
var GFxHaloCrosshair.CrosshairTargetType Last_CrosshairType;
var bool Last_bTargeting;
var bool Last_bExtendedTarget;
var float MinTargetScale;
var float MaxTargetDistance;
var float MinTargetDistance;

function Init(string baseClip, GFxHaloMinimapHUD HudMovie)
{
	ThisWorld = Outer.GetPC().WorldInfo;
	HUD = HudMovie;
	Crosshairs = GetObject("crosshairs");
	DBGTF = GetObject("DBGTF");
	DBG2TF = GetObject("DBG2TF");
	//return;	
}

function Update(float DeltaTime)
{
	local GFxHaloCrosshair.CrosshairTargetType currentType;
	local string crosshairFrame;
	local bool bTypeChange, bTargeting;
	local Actor Target;
	local float DistToTarget, NewScale;
	local Vector screenPosition;
	local ASDisplayInfo DI;
	local ASColorTransform cxform;
	local bool bExtendedTarget;
	local Vector theLocationIsALie;

	// End:0x26
	if(PlayerOwner.Pawn == none)
	{
		return;
	}
	// End:0x100
	if((PlayerOwner.Pawn.IsA('HaloVehicle_ArcadeWartHog_Content') || PlayerOwner.Pawn.IsA('HaloVehicle_ArcadeMongoose_Content')) || PlayerOwner.Pawn.IsA('HaloVehicle_ArcadeScorpion_Content'))
	{
		currentType = 2;
		crosshairFrame = "vehicle";
		bTargeting = false;		
	}
	else
	{
		// End:0x164
		if(PlayerOwner.Pawn.IsA('HaloVehicle_Ghost_Content'))
		{
			currentType = 3;
			crosshairFrame = "ghost";
			bTargeting = false;			
		}
		else
		{
			// End:0x226
			if(HaloVehicleWeapon(PlayerOwner.Pawn.Weapon) != none)
			{
				currentType = 4;
				crosshairFrame = "turretMG";
				bTargeting = HaloVehicleWeapon(PlayerOwner.Pawn.Weapon).bCrosshairIsOverValidTarget;				
			}
			else
			{
				currentType = 1;
				crosshairFrame = "kidFriendly";
				bTargeting = HaloPlayerPawnController(PlayerOwner).TargetLocked();
			}
		}
	}
	// End:0x44A
	if(int(Last_CrosshairType) != int(currentType))
	{
		bTypeChange = true;
		Crosshairs.GotoAndStop(crosshairFrame);
		Last_CrosshairType = currentType;
		// End:0x447
		if(int(currentType) != int(1))
		{
			DI.hasVisible = true;
			DI.hasX = true;
			DI.hasY = true;
			DI.hasXScale = true;
			DI.hasYScale = true;
			DI.Visible = true;
			DI.XScale = 100.0000000;
			DI.YScale = 100.0000000;
			DI.X = 640.0000000;
			DI.Y = 360.0000000;
			SetDisplayInfo(DI);
		}		
	}
	else
	{
		bTypeChange = false;
	}
	bExtendedTarget = false;
	// End:0x8A0
	if(int(currentType) == int(1))
	{
		DI.hasVisible = true;
		Target = HaloPlayerPawnController(PlayerOwner).GetCameraAutoAimTarget();
		// End:0x51F
		if(Target == none)
		{
			Target = HaloPlayerPawnController(PlayerOwner).GetCameraAutoAimExtendedTarget();
			bExtendedTarget = Target != none;
		}
		theLocationIsALie = Class'MegaHaloGame.HaloPawn'.static.GetRealLocationOf(Target);
		// End:0x86E
		if(((Target != none) && HUD.IsInfrontOfCamera(theLocationIsALie)) && HaloPlayerPawnController(PlayerOwner).bMarkAutoAimTargets || bTargeting)
		{
			DI.Visible = true;
			DI.hasX = true;
			DI.hasY = true;
			DI.hasXScale = true;
			DI.hasYScale = true;
			HUD.ProjectToScreenSpace(theLocationIsALie, true, screenPosition);
			DistToTarget = VSize(PlayerOwner.Pawn.Location - theLocationIsALie);
			// End:0x73E
			if(DistToTarget <= MinTargetDistance)
			{
				DI.XScale = 100.0000000;
				DI.YScale = 100.0000000;				
			}
			else
			{
				// End:0x7F9
				if(DistToTarget <= MaxTargetDistance)
				{
					NewScale = MinTargetScale + ((1.0000000 - ((DistToTarget - MinTargetDistance) / (MaxTargetDistance - MinTargetDistance))) * (100.0000000 - MinTargetScale));
					DI.XScale = NewScale;
					DI.YScale = NewScale;
				}
			}
			DI.X = screenPosition.X;
			DI.Y = screenPosition.Y;			
		}
		else
		{
			DI.Visible = false;
		}
		SetDisplayInfo(DI);
	}
	// End:0x8DA
	if(Last_bExtendedTarget != bExtendedTarget)
	{
		bTypeChange = true;
		Last_bExtendedTarget = bExtendedTarget;
	}
	// End:0xBF2
	if((Last_bTargeting != bTargeting) || bTypeChange)
	{
		// End:0x9B1
		if(bTargeting)
		{
			cxform.Multiply.R = 1.0000000;
			cxform.Multiply.G = 0.1000000;
			cxform.Multiply.B = 0.1000000;			
		}
		else
		{
			// End:0xB16
			if(int(currentType) == int(1))
			{
				// End:0xA74
				if(bExtendedTarget)
				{
					cxform.Multiply.R = 0.4500000;
					cxform.Multiply.G = 0.4500000;
					cxform.Multiply.B = 0.4000000;					
				}
				else
				{
					cxform.Multiply.R = 1.0000000;
					cxform.Multiply.G = 1.0000000;
					cxform.Multiply.B = 1.0000000;
				}				
			}
			else
			{
				cxform.Multiply.R = 0.4706000;
				cxform.Multiply.G = 0.8235000;
				cxform.Multiply.B = 1.0000000;
			}
		}
		Crosshairs.SetColorTransform(cxform);
		Last_bTargeting = bTargeting;
	}
	//return;	
}

defaultproperties
{
	MinTargetScale=30.0000000
	MaxTargetDistance=3500.0000000
	MinTargetDistance=1000.0000000
}