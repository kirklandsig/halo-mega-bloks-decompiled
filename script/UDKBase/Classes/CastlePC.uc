class CastlePC extends SimplePC
	config(Game);

enum ETutorialStage
{
	ETS_None,                       // 0
	ETS_Tap,                        // 1
	ETS_Swipe,                      // 2
	ETS_Sticks,                     // 3
	ETS_Done,                       // 4
	ETS_MAX                         // 5
};

var config bool bSuppressSplash;
var bool bSplashHasBeenShown;
var bool bIsInAttractMode;
var bool bDoneInitialFade;
var bool bPauseMenuOpen;
var bool bAutoSlide;
var MobileMenuPause PauseMenu;
var MobileMenuDebug DebugMenu;
var float SliderStart;
var float SliderEnd;
var float SliderTravelTime;
var float SliderTravelDuration;
var float AutoAttractTime;
var SoundCue OpenMenuSound;
var SoundCue CloseMenuSound;
var MobileMenuControls TutMenu;
var float StuckThreshHold;
var float TapToMoveAutoPitchAmount;
var StaticMesh TapToMoveVisualMesh;
var float TapToMoveVisualMinDist;
var float TapToMoveVisualRotateSpeed;
var float TapToMoveVisualAnimDuration;
var Vector TapToMoveDestination;
var float LastDistToDestination;
var float TapToMoveVisualEffectStartTime;
var float TapToMoveVisualEffectEndTime;
var SoundCue TapToMoveSound;
var SoundCue InvalidTapToMoveSound;
var SoundCue TapToMoveStopSound;
var KActorSpawnable TapToMoveVisualActor;
var CastlePC.ETutorialStage TutorialStage;
var MobileInputZone TutorialLookZone;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	// End:0x31
	if(TapToMoveVisualActor != none)
	{
		TapToMoveVisualActor.Destroy();
	}
	TapToMoveVisualActor = Spawn(Class'Engine.KActorSpawnable', self,,,,, true);
	TapToMoveVisualActor.SetCollision(false, false, true);
	TapToMoveVisualActor.SetHidden(true);
	TapToMoveVisualActor.SetDrawScale3D(vect(1.0000000, 1.0000000, 5.0000000));
	TapToMoveVisualActor.StaticMeshComponent.SetStaticMesh(TapToMoveVisualMesh);
	TapToMoveVisualActor.SetPhysics(0);
	//return;	
}

event Destroyed()
{
	// End:0x27
	if(TapToMoveVisualActor != none)
	{
		TapToMoveVisualActor.Destroy();
	}
	super(PlayerController).Destroyed();
	//return;	
}

event OnEngineInitialTick()
{
	// End:0x69
	if(WorldInfo.IsPlayInPreview() || WorldInfo.IsPlayInEditor())
	{
		TutorialStage = 4;
		ActivateControlGroup();
		ResetMenu();		
	}
	else
	{
		CauseEvent('IntroCam');		
		ConsoleCommand("mobile playsong town_render");
	}
	//return;	
}

function SetupZones()
{
	local MobileInputZone Zone;
	local float Ratio;

	super.SetupZones();
	// End:0x52C
	if((MPI != none) && WorldInfo.GRI.GameClass != none)
	{
		Zone = MPI.FindZone("ExitAttractModeZone");
		// End:0xD1
		if(Zone != none)
		{
			Zone.__OnTapDelegate__Delegate = ExitAttractTap;
		}
		Zone = MPI.FindZone("TapTutorialZone");
		// End:0x14D
		if(Zone != none)
		{
			Zone.__OnTapDelegate__Delegate = TapToMoveTap;			
		}
		else
		{
			LogInternal("!!!WARNING!!!  Tutorial will be broken due to Tap");
		}
		TutorialLookZone = MPI.FindZone("SwipeTutorialZone");
		// End:0x206
		if(TutorialLookZone == none)
		{
			LogInternal("!!!WARNING!!!  Tutorial will be broken due to Swipe");
		}
		// End:0x332
		if(bSuppressSplash!)
		{
			PauseMenu = MobileMenuPause(MPI.OpenMenuScene(Class'UDKBase.MobileMenuPause'));
			SliderZone = MPI.FindZone("MenuSlider");
			// End:0x332
			if(SliderZone != none)
			{
				SliderZone.__OnTapDelegate__Delegate = MenuSliderTap;
				SliderZone.__OnProcessSlide__Delegate = ProcessMenuSlide;
				SliderZone.SizeY = PauseMenu.Height;
			}
		}
		Ratio = ViewportSize.Y / ViewportSize.X;
		Zone = MPI.FindZone("TapToMoveZone");
		// End:0x3ED
		if(Zone != none)
		{
			Zone.__OnTapDelegate__Delegate = TapToMoveTap;
		}
		// End:0x4D8
		if(FreeLookZone != none)
		{
			FreeLookZone.__OnTapDelegate__Delegate = TapToMoveTap;
			// End:0x4D8
			if((Ratio == 0.7500000) || ViewportSize.X <= float(480))
			{
				FreeLookZone.VertMultiplier *= 1.7500000;
				FreeLookZone.HorizMultiplier *= 3.2500000;
				FreeLookZone.Acceleration *= 0.5000000;
			}
		}
		SetTimer(60.0000000, true, 'SaveControllerStats');
		// End:0x52C
		if(MPI != none)
		{
			MPI.ActivateInputGroup("InitialFlybyGroup");
		}
	}
	//return;	
}

function SaveControllerStats()
{
	// End:0x14C
	if(((StickLookZone != none) && StickMoveZone != none) && FreeLookZone != none)
	{		
		ConsoleCommand((((("mobile recordcontrolstats" @ string(StickMoveZone.TotalActiveTime)) @ string(StickLookZone.TotalActiveTime)) @ string(FreeLookZone.TotalActiveTime)) @ string(TotalTimeInTapToMove)) @ string(NoTapToMoves));
		StickMoveZone.TotalActiveTime = 0.0000000;
		StickLookZone.TotalActiveTime = 0.0000000;
		FreeLookZone.TotalActiveTime = 0.0000000;
	}
	TotalTimeInTapToMove = 0.0000000;
	NoTapToMoves = 0;
	//return;	
}

function CheckInactivity()
{
	// End:0x74
	if((CastleGame(WorldInfo.Game) == none) || CastleGame(WorldInfo.Game).bAllowAttractMode == false)
	{
		return;
	}
	// End:0x14E
	if((((LocalPlayer(Player).ViewportClient.bDisableWorldRendering || (PauseMenu != none) && bPauseMenuOpen) || bIsInAttractMode) || bCinematicMode) || (MPI.MobileMenuStack.Length > 1) && TutMenu == none)
	{
		MPI.MobileInactiveTime = 0.0000000;
	}
	// End:0x1A6
	if(((MPI.MobileInactiveTime > AutoAttractTime) && bIsInAttractMode!) && bCinematicMode!)
	{
		EnterAttractMode();
	}
	//return;	
}

simulated function Actor TraceForTapToMove(Pawn TraceOwner, out Vector HitLocation, out Vector HitNormal, Vector End, Vector Start)
{
	local Actor HitActor;
	local Vector HitLoc, HitNorm;
	local TraceHitInfo HitInfo;

	// End:0x108
	foreach TraceOwner.TraceActors(Class'Engine.Actor', HitActor, HitLoc, HitNorm, End, Start,, HitInfo, 1)
	{
		// End:0x107
		if((HitActor.bBlockActors || HitActor.bWorldGeometry) && (Volume(HitActor) == none) && Trigger(HitActor) == none)
		{
			HitLocation = HitLoc;
			HitNormal = HitNorm;			
			return HitActor;
		}		
	}	
	return none;
	//return ReturnValue;	
}

function bool TapToMoveTap(MobileInputZone Zone, Interaction.ETouchType EventType, Vector2D TouchLocation)
{
	local Vector2D RelLocation;
	local Vector Origin, Direction, Destination, HitLocation, HitNormal;

	local Actor HitActor;
	local bool bWantReverse, bValidDestination;

	// End:0x5E7
	if((bIsInAttractMode! && bCinematicMode!) && int(StickMoveZone.State) == int(0))
	{
		RelLocation.X = TouchLocation.X / ViewportSize.X;
		RelLocation.Y = TouchLocation.Y / ViewportSize.Y;
		bWantReverse = false;
		// End:0x1AE
		if(bWantReverse && IsInState('PlayerTapToMove'))
		{
			MobileHUDExt(myHUD).StartTapToMoveEffect(TouchLocation.X, TouchLocation.Y);
			PlaySound(TapToMoveStopSound);
			GotoState('PlayerWalking');			
		}
		else
		{
			NoTapToMoves++;
			// End:0x206
			if(bWantReverse)
			{
				RelLocation.X = 1.0000000 - RelLocation.X;
			}
			LocalPlayer(Player).DeProject(RelLocation, Origin, Direction);
			// End:0x2A2
			if(bWantReverse)
			{
				Direction.Z = 0.0000000;
				Destination = Origin - (Direction * float(512));				
			}
			else
			{
				Destination = Origin + (Direction * float(10240));
			}
			HitActor = TraceForTapToMove(Pawn, HitLocation, HitNormal, Destination, Origin);
			// End:0x35E
			if(HitActor != none)
			{
				Destination = HitLocation + ((HitNormal * Pawn.GetCollisionHeight()) * float(2));
			}
			// End:0x444
			if(PointReachable(Destination)!)
			{
				Origin = Destination;
				Destination.Z = -65535.0000000;
				HitActor = TraceForTapToMove(Pawn, HitLocation, HitNormal, Destination, Origin);
				// End:0x444
				if(HitActor != none)
				{
					Destination = HitLocation;
					Destination.Z += Pawn.GetCollisionHeight();
				}
			}
			// End:0x460
			if(bWantReverse)
			{
				bValidDestination = true;				
			}
			else
			{
				bValidDestination = (Normal(Destination - Pawn.Location) Dot Vector(Pawn.Rotation)) > 0.2500000;
			}
			// End:0x508
			if(VSize2D(Destination - Pawn.Location) < 128.0000000)
			{
				bValidDestination = false;
			}
			// End:0x5B0
			if(bValidDestination)
			{
				PlaySound(TapToMoveSound);
				MobileHUDExt(myHUD).StartTapToMoveEffect(TouchLocation.X, TouchLocation.Y);
				DoTapToMove(Destination, bWantReverse!);				
			}
			else
			{
				PlaySound(InvalidTapToMoveSound);
				// End:0x5E7
				if(IsInState('PlayerTapToMove'))
				{
					GotoState('PlayerWalking');
				}
			}
		}
	}
	return true;
	//return ReturnValue;	
}

function DoTapToMove(Vector NewDestination, bool bShouldLookAtDestination)
{
	TapToMoveVisualActor.SetLocation(NewDestination + vect(0.0000000, 0.0000000, 6.0000000));
	TapToMoveVisualActor.SetHidden(false);
	TapToMoveVisualEffectStartTime = WorldInfo.RealTimeSeconds;
	TapToMoveDestination = NewDestination;
	LastDistToDestination = VSize(Pawn.Location - TapToMoveDestination);
	// End:0xD7
	if(bShouldLookAtDestination)
	{
		PlayerLookAtDestination();
	}
	GotoState('PlayerTapToMove');
	//return;	
}

function PlayerLookAtDestination()
{
	// End:0x1B
	if(bLookAtDestination!)
	{
		bLookAtDestination = true;
	}
	TimeOfLastUserViewChange = 0.0000000;
	//return;	
}

function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, Rotator DeltaRot)
{
	local float AnimProgress;
	local Vector NewDrawScale;

	// End:0x53
	if(bLookAtDestination)
	{
		LookAtDestination = TapToMoveDestination - Pawn.Location;
		LookAtDestAutoPitchAmount = TapToMoveAutoPitchAmount;
	}
	super.ProcessViewRotation(DeltaTime, out_ViewRotation, DeltaRot);
	// End:0x182
	if(TapToMoveVisualEffectEndTime < TapToMoveVisualEffectStartTime)
	{
		AnimProgress = 1.0000000 - FMin((WorldInfo.RealTimeSeconds - TapToMoveVisualEffectStartTime) / TapToMoveVisualAnimDuration, 1.0000000);
		AnimProgress = FInterpEaseInOut(0.0000000, 1.0000000, AnimProgress, 1.5000000);
		TapToMoveVisualActor.SetRotation(TapToMoveVisualActor.Rotation + MakeRotator(0, int(DeltaTime * (TapToMoveVisualRotateSpeed + ((8.0000000 * AnimProgress) * TapToMoveVisualRotateSpeed))), 0));		
	}
	else
	{
		AnimProgress = FMin((WorldInfo.RealTimeSeconds - TapToMoveVisualEffectEndTime) / TapToMoveVisualAnimDuration, 1.0000000);
		AnimProgress = FInterpEaseInOut(0.0000000, 1.0000000, AnimProgress, 1.5000000);
		TapToMoveVisualActor.SetRotation(TapToMoveVisualActor.Rotation + MakeRotator(0, int((DeltaTime * (1.0000000 - AnimProgress)) * TapToMoveVisualRotateSpeed), 0));
		// End:0x293
		if(AnimProgress >= 1.0000000)
		{
			TapToMoveVisualActor.SetHidden(true);
		}
	}
	NewDrawScale.X = 1.0000000 - (AnimProgress * 1.0000000);
	NewDrawScale.Y = 1.0000000 + (AnimProgress * 0.5000000);
	NewDrawScale.Z = 1.2500000 - (AnimProgress * 1.2500000);
	TapToMoveVisualActor.SetDrawScale3D(NewDrawScale);
	//return;	
}

simulated function CheckDistanceToDestination(float DistToDestination)
{
	// End:0x56
	if(DistToDestination < TapToMoveVisualMinDist)
	{
		// End:0x56
		if(TapToMoveVisualEffectEndTime < TapToMoveVisualEffectStartTime)
		{
			TapToMoveVisualEffectEndTime = WorldInfo.RealTimeSeconds;
		}
	}
	//return;	
}

event NotifyDirectorControl(bool bNowControlling, SeqAct_Interp CurrentMatinee)
{
	super.NotifyDirectorControl(bNowControlling, CurrentMatinee);
	// End:0x4A
	if(bNowControlling)
	{
		TapToMoveVisualActor.SetHidden(true);
	}
	//return;	
}

exec function EnterAttractMode()
{
	// End:0x1E
	if(IsInState('PlayerTapToMove'))
	{
		GotoState('PlayerWalking');
	}
	// End:0xB5
	if(TutMenu != none)
	{
		TutMenu.FadeOut();
		TutMenu = none;
		MPI.ActivateInputGroup("UberGroup");
		MobileHUDExt(myHUD).FlashSticks();
		TutorialStage = 4;
	}
	// End:0xE3
	if(PauseMenu != none)
	{
		PauseMenu.ReleaseHelp();
	}
	CauseEvent('PlayMatinee');
	bIsInAttractMode = true;
	ResetMenu();
	MPI.ActivateInputGroup("AttractGroup");
	//return;	
}

exec function ExitAttractMode()
{
	bIsInAttractMode = false;
	MPI.MobileInactiveTime = 0.0000000;
	CauseEvent('StopMatinee');
	ActivateControlGroup();
	ResetMenu();
	//return;	
}

function bool ExitAttractTap(MobileInputZone Zone, Interaction.ETouchType EventType, Vector2D TouchLocation)
{
	ExitAttractMode();
	return true;
	//return ReturnValue;	
}

function AutoSlide(float Destination)
{
	SliderStart = SliderZone.CurrentLocation.Y;
	SliderEnd = Destination;
	SliderTravelTime = 0.0000000;
	bAutoSlide = true;
	//return;	
}

function ResetMenu()
{
	// End:0x79
	if(bPauseMenuOpen)
	{
		PauseMenu.OnResetMenu();
		AutoSlide(SliderZone.Y);
		bPauseMenuOpen = false;
		PlaySound(CloseMenuSound);
	}
	//return;	
}

function OpenMenu()
{
	// End:0x5C
	if(bPauseMenuOpen!)
	{
		bPauseMenuOpen = true;
		AutoSlide(PauseMenu.ShownSize);
		PlaySound(OpenMenuSound);
	}
	//return;	
}

function bool MenuSliderTap(MobileInputZone Zone, Interaction.ETouchType EventType, Vector2D TouchLocation)
{
	// End:0x1A
	if(bPauseMenuOpen)
	{
		ResetMenu();		
	}
	else
	{
		OpenMenu();
	}
	return true;
	//return ReturnValue;	
}

function bool ProcessMenuSlide(MobileInputZone Zone, Interaction.ETouchType EventType, int SlideValue, Vector2D ViewportSizes)
{
	PauseMenu.Top = Zone.CurrentLocation.Y - PauseMenu.Height;
	// End:0x11E
	if((int(EventType) == int(3)) && bPauseMenuOpen!)
	{
		// End:0xF6
		if(Zone.CurrentLocation.Y >= PauseMenu.ShownSize)
		{
			OpenMenu();			
		}
		else
		{
			AutoSlide(SliderZone.Y);
		}
	}
	return true;
	//return ReturnValue;	
}

function PlayerTick(float DeltaTime)
{
	super.PlayerTick(DeltaTime);
	// End:0xD8
	if(int(TutorialStage) == int(2))
	{
		// End:0xD8
		if(int(TutorialLookZone.State) != int(0))
		{
			TutMenu.FadeOut();
			TutMenu = none;
			MPI.ActivateInputGroup("UberGroup");
			MobileHUDExt(myHUD).FlashSticks();
			TutorialStage = 4;
		}
	}
	// End:0xF3
	if(bDoneInitialFade!)
	{
		bDoneInitialFade = true;
	}
	// End:0x249
	if(bAutoSlide)
	{
		SliderZone.CurrentLocation.Y = FInterpEaseInOut(SliderStart, SliderEnd, SliderTravelTime / SliderTravelDuration, 3.0000000);
		SliderTravelTime += DeltaTime;
		// End:0x1D9
		if(SliderTravelTime >= SliderTravelDuration)
		{
			SliderZone.CurrentLocation.Y = SliderEnd;
			bAutoSlide = false;
		}
		PauseMenu.Top = SliderZone.CurrentLocation.Y - PauseMenu.Height;
	}
	//return;	
}

exec function ShowSplash()
{
	MPI.ActivateInputGroup("TapTutorialGroup");
	// End:0x97
	if((bSplashHasBeenShown! && bSuppressSplash!) && MPI != none)
	{
		bSplashHasBeenShown = true;
		MPI.OpenMenuScene(Class'UDKBase.MobileMenuSplash');
	}
	//return;	
}

exec function FlashHelp(float Duration)
{
	// End:0x37
	if(bPauseMenuOpen!)
	{
		PauseMenu.FlashHelp(Duration);
	}
	//return;	
}

function StartTutorials()
{
	TutMenu = MobileMenuControls(MPI.OpenMenuScene(Class'UDKBase.MobileMenuControls'));
	TutMenu.Setup(true);
	TutorialStage = 1;
	//return;	
}

exec function SetFootstepsToStone()
{
	//return;	
}

exec function SetFootstepsToSnow()
{
	//return;	
}

state PlayerTapToMove
{
	event BeginState(name PreviousStateName)
	{
		super(Object).BeginState(PreviousStateName);
		LastEnteredTapToMove = WorldInfo.RealTimeSeconds;
		// End:0x109
		if(int(TutorialStage) == int(1))
		{
			TutMenu.FadeOut();
			TutMenu = MobileMenuControls(MPI.OpenMenuScene(Class'UDKBase.MobileMenuControls'));
			TutMenu.Setup(false);
			MPI.ActivateInputGroup("SwipeTutorialGroup");
			TutorialStage = 2;
		}
		//return;		
	}

	event EndState(name NextStateName)
	{
		TotalTimeInTapToMove += (WorldInfo.RealTimeSeconds - LastEnteredTapToMove);
		super(Object).EndState(NextStateName);
		ClearTimer('CheckIfStuck');
		bLookAtDestination = false;
		// End:0xA6
		if(TapToMoveVisualEffectEndTime < TapToMoveVisualEffectStartTime)
		{
			TapToMoveVisualEffectEndTime = WorldInfo.RealTimeSeconds;
		}
		//return;		
	}

	event CheckIfStuck()
	{
		local float DistToDestination;

		DistToDestination = VSize(Pawn.Location - TapToMoveDestination);
		// End:0x68
		if((LastDistToDestination - DistToDestination) < StuckThreshHold)
		{
			GotoState('PlayerWalking');			
		}
		else
		{
			LastDistToDestination = DistToDestination;
		}
		//return;		
	}

	function PlayerTick(float DeltaTime)
	{
		// End:0x1B
		if(IsStickMoveActive())
		{
			GotoState('PlayerWalking');
		}
		global.PlayerTick(DeltaTime);
		//return;		
	}
Begin:

	SetTimer(0.5000000, true, 'CheckIfStuck');
	J0x13:

	// End:0x6F [Loop If]
	if((Pawn != none) && Pawn.ReachedPoint(TapToMoveDestination, none)!)
	{
		MoveToDirectNonPathPos(TapToMoveDestination,, 1.0000000, true);
		// [Loop Continue]
		goto J0x13;
	}
	GotoState('PlayerWalking');
	stop;			
}

defaultproperties
{
	SliderTravelDuration=0.3000000
	AutoAttractTime=45.0000000
	StuckThreshHold=25.0000000
	TapToMoveAutoPitchAmount=0.2500000
	TapToMoveVisualMesh=StaticMesh'CastleEffects.TouchToMoveArrow'
	TapToMoveVisualMinDist=230.0000000
	TapToMoveVisualRotateSpeed=100000.0000000
	TapToMoveVisualAnimDuration=0.3000000
	// Reference: CylinderComponent'UDKBase.Default__CastlePC.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'UDKBase.Default__SimplePC.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	CollisionComponent=CollisionCylinder
}