class Vehicle extends Pawn
	abstract
	native
	nativereplication
	config(Game)
	placeable;

var repnotify Pawn Driver;
var repnotify bool bDriving;
var bool bDriverIsVisible;
var bool bAttachDriver;
var bool bTurnInPlace;
var bool bSeparateTurretFocus;
var bool bFollowLookDir;
var bool bHasHandbrake;
var bool bScriptedRise;
var bool bDuckObstacles;
var bool bAvoidReversing;
var bool bRetryPathfindingWithDriver;
var bool bIgnoreStallZ;
var bool bDoExtraNetRelevancyTraces;
var array<Vector> ExitPositions;
var float ExitRadius;
var Vector ExitOffset;
var float Steering;
var float Throttle;
var float Rise;
var Vector TargetLocationAdjustment;
var float DriverDamageMult;
var float MomentumMult;
var Class<DamageType> CrushedDamageType;
var float MinCrushSpeed;
var float ForceCrushPenetration;
var byte StuckCount;
var float ThrottleTime;
var float StuckTime;
var float OldSteering;
var float OnlySteeringStartTime;
var float OldThrottle;
var const float AIMoveCheckTime;
var float VehicleMovingTime;
var float TurnTime;

replication
{
	// Pos:0x000
	if(bNetDirty && int(Role) == int(ROLE_Authority))
		bDriving;

	// Pos:0x020
	if((bNetDirty && (bNetOwner || Driver == none) || !Driver.bHidden) && int(Role) == int(ROLE_Authority))
		Driver;
}

simulated function NotifyTeamChanged()
{
	// End:0x3F
	if((PlayerReplicationInfo != none) && Driver != none)
	{
		Driver.NotifyTeamChanged();
	}
	//return;	
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local string DriverText;

	super.DisplayDebug(HUD, out_YL, out_YPos);
	HUD.Canvas.SetDrawColor(255, 255, 255);
	HUD.Canvas.DrawText((((("Steering " $ string(Steering)) $ " throttle ") $ string(Throttle)) $ " rise ") $ string(Rise));
	out_YPos += out_YL;
	HUD.Canvas.SetPos(4.0000000, out_YPos);
	HUD.Canvas.SetDrawColor(255, 0, 0);
	out_YPos += out_YL;
	HUD.Canvas.SetPos(4.0000000, out_YPos);
	// End:0x1F2
	if(Driver == none)
	{
		DriverText = "NO DRIVER";		
	}
	else
	{
		DriverText = (("Driver Mesh " $ string(Driver.Mesh)) $ " hidden ") $ string(Driver.bHidden);
	}
	HUD.Canvas.DrawText(DriverText);
	out_YPos += out_YL;
	HUD.Canvas.SetPos(4.0000000, out_YPos);
	//return;	
}

function Suicide()
{
	// End:0x3A
	if(Driver != none)
	{
		Driver.KilledBy(Driver);		
	}
	else
	{
		KilledBy(self);
	}
	//return;	
}

// Export UVehicle::execGetMaxRiseForce(FFrame&, void* const)
native function float GetMaxRiseForce();

// Export UVehicle::execGetTargetLocation(FFrame&, void* const)
native simulated function Vector GetTargetLocation(optional Actor RequestedBy, optional bool bRequestAlternateLoc);

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, Class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0000000)
{
	// End:0xD2
	if(int(Role) == int(ROLE_Authority))
	{
		super(Actor).TakeRadiusDamage(InstigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser, DamageFalloffExponent);
		// End:0xD2
		if(Health > 0)
		{
			DriverRadiusDamage(BaseDamage, DamageRadius, InstigatedBy, DamageType, Momentum, HurtOrigin, DamageCauser);
		}
	}
	//return;	
}

function DriverRadiusDamage(float DamageAmount, float DamageRadius, Controller EventInstigator, Class<DamageType> DamageType, float Momentum, Vector HitLocation, Actor DamageCauser, optional float DamageFalloffExponent = 1.0000000)
{
	// End:0xEC
	if(((((EventInstigator != none) && Driver != none) && bAttachDriver) && !Driver.bCollideActors) && !Driver.bBlockActors)
	{
		Driver.TakeRadiusDamage(EventInstigator, DamageAmount, DamageRadius, DamageType, Momentum, HitLocation, false, DamageCauser, DamageFalloffExponent);
	}
	//return;	
}

function PlayerChangedTeam()
{
	// End:0x3A
	if(Driver != none)
	{
		Driver.KilledBy(Driver);		
	}
	else
	{
		super.PlayerChangedTeam();
	}
	//return;	
}

simulated function SetBaseEyeheight()
{
	BaseEyeHeight = default.BaseEyeHeight;
	EyeHeight = BaseEyeHeight;
	//return;	
}

event PostBeginPlay()
{
	super.PostBeginPlay();
	// End:0x23
	if(!bDeleteMe)
	{
		AddDefaultInventory();
	}
	//return;	
}

function bool CheatWalk()
{
	return false;
	//return ReturnValue;	
}

function bool CheatGhost()
{
	return false;
	//return ReturnValue;	
}

function bool CheatFly()
{
	return false;
	//return ReturnValue;	
}

simulated event Destroyed()
{
	// End:0x19
	if(Driver != none)
	{
		Destroyed_HandleDriver();
	}
	super.Destroyed();
	//return;	
}

simulated function Destroyed_HandleDriver()
{
	local Pawn OldDriver;

	Driver.LastRenderTime = LastRenderTime;
	// End:0x95
	if(int(Role) == int(ROLE_Authority))
	{
		OldDriver = Driver;
		Driver = none;
		OldDriver.DrivenVehicle = none;
		OldDriver.Destroy();		
	}
	else
	{
		// End:0xD9
		if(Driver.DrivenVehicle == self)
		{
			Driver.StopDriving(self);
		}
	}
	//return;	
}

function bool CanEnterVehicle(Pawn P)
{
	return ((((((!bDeleteMe && AnySeatAvailable()) && !bAttachDriver || !P.bIsCrouched) && P.DrivenVehicle == none) && P.Controller != none) && P.Controller.bIsPlayer) && !P.IsA('Vehicle')) && Health > 0;
	//return ReturnValue;	
}

function bool AnySeatAvailable()
{
	return Driver == none;
	//return ReturnValue;	
}

function bool TryToDrive(Pawn P)
{
	// End:0x1A
	if(!CanEnterVehicle(P))
	{
		return false;
	}
	return DriverEnter(P);
	//return ReturnValue;	
}

function bool DriverEnter(Pawn P)
{
	local Controller C;

	C = P.Controller;
	Driver = P;
	Driver.StartDriving(self);
	// End:0x8C
	if(Driver.Health <= 0)
	{
		Driver = none;
		return false;
	}
	SetDriving(true);
	C.UnPossess();
	Driver.SetOwner(self);
	C.Possess(self, true);
	// End:0x17B
	if((PlayerController(C) != none) && !C.IsChildState(C.GetStateName(), LandMovementState))
	{
		PlayerController(C).GotoState(LandMovementState);
	}
	WorldInfo.Game.DriverEnteredVehicle(self, P);
	return true;
	//return ReturnValue;	
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	super.PossessedBy(C, bVehicleTransition);
	EntryAnnouncement(C);
	NetPriority = 3.0000000;
	NetUpdateFrequency = 100.0000000;
	ThrottleTime = WorldInfo.TimeSeconds;
	OnlySteeringStartTime = WorldInfo.TimeSeconds;
	//return;	
}

function EntryAnnouncement(Controller C)
{
	//return;	
}

simulated function AttachDriver(Pawn P)
{
	// End:0x11
	if(!bAttachDriver)
	{
		return;
	}
	P.SetCollision(false, false);
	P.bCollideWorld = false;
	P.SetBase(none);
	P.SetHardAttach(true);
	P.SetPhysics(0);
	// End:0x115
	if((P.Mesh != none) && Mesh != none)
	{
		P.Mesh.SetShadowParent(Mesh);
	}
	// End:0x165
	if(!bDriverIsVisible)
	{
		P.SetHidden(true);
		P.SetLocation(Location);
	}
	P.SetBase(self);
	P.SetPhysics(0);
	//return;	
}

simulated function DetachDriver(Pawn P)
{
	//return;	
}

simulated function bool DisableVehicle()
{
	return true;
	//return ReturnValue;	
}

simulated function EnableVehicle()
{
	//return;	
}

event bool ContinueOnFoot()
{
	// End:0x27
	if(AIController(Controller) != none)
	{
		return DriverLeave(false);		
	}
	else
	{
		return false;
	}
	//return ReturnValue;	
}

function Rotator GetExitRotation(Controller C)
{
	local Rotator Rot;

	Rot.Yaw = C.Rotation.Yaw;
	return Rot;
	//return ReturnValue;	
}

event bool DriverLeave(bool bForceLeave)
{
	local Controller C;
	local PlayerController PC;
	local Rotator ExitRotation;

	// End:0x42
	if(int(Role) < int(ROLE_Authority))
	{
		WarnInternal("DriverLeave() called on client");
		ScriptTrace();
		return false;
	}
	// End:0x98
	if(!bForceLeave && !WorldInfo.Game.CanLeaveVehicle(self, Driver))
	{
		return false;
	}
	// End:0xA9
	if(Controller == none)
	{
		return false;
	}
	// End:0x1B8
	if(Driver != none)
	{
		Driver.SetHardAttach(false);
		Driver.bCollideWorld = true;
		Driver.SetCollision(true, true);
		// End:0x1B8
		if(!PlaceExitingDriver())
		{
			// End:0x194
			if(!bForceLeave)
			{
				Driver.SetHardAttach(true);
				Driver.bCollideWorld = false;
				Driver.SetCollision(false, false);
				return false;				
			}
			else
			{
				Driver.SetLocation(GetTargetLocation());
			}
		}
	}
	ExitRotation = GetExitRotation(Controller);
	SetDriving(false);
	C = Controller;
	// End:0x237
	if(C.RouteGoal == self)
	{
		C.RouteGoal = none;
	}
	// End:0x27B
	if(C.MoveTarget == self)
	{
		C.MoveTarget = none;
	}
	Controller.UnPossess();
	// End:0x3AE
	if((Driver != none) && Driver.Health > 0)
	{
		Driver.SetRotation(ExitRotation);
		Driver.SetOwner(C);
		C.Possess(Driver, true);
		PC = PlayerController(C);
		// End:0x38E
		if(PC != none)
		{
			PC.ClientSetViewTarget(Driver);
		}
		Driver.StopDriving(self);
	}
	// End:0x3D0
	if(C == Controller)
	{
		Controller = none;
	}
	WorldInfo.Game.DriverLeftVehicle(self, Driver);
	DriverLeft();
	return true;
	//return ReturnValue;	
}

simulated function SetInputs(float InForward, float InStrafe, float InUp)
{
	Throttle = InForward;
	Steering = InStrafe;
	Rise = InUp;
	//return;	
}

function DriverLeft()
{
	Driver = none;
	SetDriving(false);
	//return;	
}

function bool PlaceExitingDriver(optional Pawn ExitingDriver)
{
	local int I;
	local Vector tryPlace, Extent, HitLocation, HitNormal, ZOffset;

	// End:0x23
	if(ExitingDriver == none)
	{
		ExitingDriver = Driver;
	}
	// End:0x34
	if(ExitingDriver == none)
	{
		return false;
	}
	Extent = ExitingDriver.GetCollisionRadius() * vect(1.0000000, 1.0000000, 0.0000000);
	Extent.Z = ExitingDriver.GetCollisionHeight();
	ZOffset = Extent.Z * vect(0.0000000, 0.0000000, 1.0000000);
	// End:0x289
	if(ExitPositions.Length > 0)
	{
		I = 0;
		J0xF8:

		// End:0x286 [Loop If]
		if(I < ExitPositions.Length)
		{
			// End:0x170
			if(ExitPositions[0].Z != float(0))
			{
				ZOffset = vect(0.0000000, 0.0000000, 1.0000000) * ExitPositions[0].Z;				
			}
			else
			{
				ZOffset = ExitingDriver.CylinderComponent.default.CollisionHeight * vect(0.0000000, 0.0000000, 2.0000000);
			}
			tryPlace = (Location + ((ExitPositions[I] - ZOffset) >> Rotation)) + ZOffset;
			// End:0x24D
			if(Trace(HitLocation, HitNormal, tryPlace, Location + ZOffset, false, Extent) != none)
			{				
			}
			else
			{
				// End:0x276
				if(!ExitingDriver.SetLocation(tryPlace))
				{					
				}
				else
				{
					return true;
				}
			}
			I++;
			// [Loop Continue]
			goto J0xF8;
		}		
	}
	else
	{
		return FindAutoExit(ExitingDriver);
	}
	return false;
	//return ReturnValue;	
}

function bool FindAutoExit(Pawn ExitingDriver)
{
	local Vector FacingDir, CrossProduct;
	local float PlaceDist;

	FacingDir = Vector(Rotation);
	CrossProduct = Normal(FacingDir Cross vect(0.0000000, 0.0000000, 1.0000000));
	// End:0x7E
	if(ExitRadius == float(0))
	{
		ExitRadius = (GetCollisionRadius()) + ExitingDriver.VehicleCheckRadius;
	}
	PlaceDist = ExitRadius + ExitingDriver.GetCollisionRadius();
	return (((TryExitPos(ExitingDriver, ((GetTargetLocation()) + ExitOffset) + (PlaceDist * CrossProduct), false)) || TryExitPos(ExitingDriver, ((GetTargetLocation()) + ExitOffset) - (PlaceDist * CrossProduct), false)) || TryExitPos(ExitingDriver, ((GetTargetLocation()) + ExitOffset) - (PlaceDist * FacingDir), false)) || TryExitPos(ExitingDriver, ((GetTargetLocation()) + ExitOffset) + (PlaceDist * FacingDir), false);
	//return ReturnValue;	
}

function bool TryExitPos(Pawn ExitingDriver, Vector ExitPos, bool bMustFindGround)
{
	local Vector Slice, HitLocation, HitNormal, StartLocation, NewActorPos;

	local Actor HitActor;

	Slice = ExitingDriver.GetCollisionRadius() * vect(1.0000000, 1.0000000, 0.0000000);
	Slice.Z = 2.0000000;
	StartLocation = GetTargetLocation();
	// End:0xAB
	if(Trace(HitLocation, HitNormal, ExitPos, StartLocation, false, Slice) != none)
	{
		return false;
	}
	HitActor = Trace(HitLocation, HitNormal, ExitPos - (ExitingDriver.GetCollisionHeight() * vect(0.0000000, 0.0000000, 5.0000000)), ExitPos, true, Slice);
	// End:0x149
	if(HitActor == none)
	{
		// End:0x136
		if(bMustFindGround)
		{
			return false;
		}
		HitLocation = ExitPos;
	}
	NewActorPos = HitLocation + ((ExitingDriver.GetCollisionHeight() + ExitingDriver.MaxStepHeight) * vect(0.0000000, 0.0000000, 1.0000000));
	// End:0x1EC
	if(PointCheckComponent(Mesh, NewActorPos, ExitingDriver.GetCollisionExtent()))
	{
		return false;
	}
	return ExitingDriver.SetLocation(NewActorPos);
	//return ReturnValue;	
}

function UnPossessed()
{
	NetPriority = default.NetPriority;
	bForceNetUpdate = true;
	NetUpdateFrequency = 8.0000000;
	super.UnPossessed();
	//return;	
}

function Controller SetKillInstigator(Controller InstigatedBy, Class<DamageType> DamageType)
{
	return InstigatedBy;
	//return ReturnValue;	
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	bForceNetUpdate = true;
	// End:0x7C
	if(DamageType != none)
	{
		Damage *= DamageType.static.VehicleDamageScalingFor(self);
		Momentum *= (DamageType.default.VehicleMomentumScaling * MomentumMult);
	}
	super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	//return;	
}

function AdjustDriverDamage(out int Damage, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, Class<DamageType> DamageType)
{
	// End:0x1B
	if(InGodMode())
	{
		Damage = 0;		
	}
	else
	{
		Damage *= DriverDamageMult;
	}
	//return;	
}

function ThrowActiveWeapon(optional bool bDestroyWeap)
{
	//return;	
}

function bool Died(Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
	// End:0x38
	if(super.Died(Killer, DamageType, HitLocation))
	{
		SetDriving(false);
		return true;		
	}
	else
	{
		return false;
	}
	//return ReturnValue;	
}

function DriverDied(Class<DamageType> DamageType)
{
	local Controller C;
	local PlayerReplicationInfo RealPRI;

	// End:0x11
	if(Driver == none)
	{
		return;
	}
	WorldInfo.Game.DiscardInventory(Driver);
	C = Controller;
	Driver.StopDriving(self);
	Driver.Controller = C;
	Driver.DrivenVehicle = self;
	// End:0xDB
	if(Controller == none)
	{
		return;
	}
	// End:0x178
	if(PlayerController(Controller) != none)
	{
		Controller.SetLocation(Location);
		PlayerController(Controller).SetViewTarget(Driver);
		PlayerController(Controller).ClientSetViewTarget(Driver);
	}
	Controller.UnPossess();
	// End:0x1B9
	if(Controller == C)
	{
		Controller = none;
	}
	C.Pawn = Driver;
	RealPRI = Driver.PlayerReplicationInfo;
	// End:0x255
	if(RealPRI == none)
	{
		Driver.PlayerReplicationInfo = C.PlayerReplicationInfo;
	}
	WorldInfo.Game.DriverLeftVehicle(self, Driver);
	Driver.PlayerReplicationInfo = RealPRI;
	DriverLeft();
	//return;	
}

simulated function PlayDying(Class<DamageType> DamageType, Vector HitLoc, optional Controller Killer)
{
	//return;	
}

simulated function name GetDefaultCameraMode(PlayerController RequestedBy)
{
	// End:0x82
	if(((RequestedBy != none) && RequestedBy.PlayerCamera != none) && RequestedBy.PlayerCamera.CameraStyle == 'Fixed')
	{
		return 'Fixed';
	}
	return 'ThirdPerson';
	//return ReturnValue;	
}

simulated function FaceRotation(Rotator NewRotation, float DeltaTime)
{
	//return;	
}

event EncroachedBy(Actor Other)
{
	//return;	
}

function Controller GetCollisionDamageInstigator()
{
	// End:0x1C
	if(Controller != none)
	{
		return Controller;		
	}
	else
	{
		return ((Instigator != none) ? Instigator.Controller : none);
	}
	//return ReturnValue;	
}

event bool EncroachingOn(Actor Other)
{
	local Pawn P;
	local Vector PushVelocity, CheckExtent;
	local bool bSlowEncroach, bDeepEncroach;

	P = Pawn(Other);
	// End:0x2D
	if(P == none)
	{
		return false;
	}
	bSlowEncroach = VSize(Velocity) < MinCrushSpeed;
	// End:0x18F
	if(bSlowEncroach)
	{
		CheckExtent.X = P.CylinderComponent.CollisionRadius - ForceCrushPenetration;
		CheckExtent.Y = CheckExtent.X;
		CheckExtent.Z = P.CylinderComponent.CollisionHeight - ForceCrushPenetration;
		bDeepEncroach = PointCheckComponent(CollisionComponent, P.Location, CheckExtent);
	}
	// End:0x353
	if((((((Other == Instigator) && !bDeepEncroach) || Vehicle(Other) != none) || int(Other.Role) != int(ROLE_Authority)) || !Other.bCollideActors && !Other.bBlockActors) || bSlowEncroach && !bDeepEncroach)
	{
		// End:0x351
		if((P.Velocity Dot (Location - P.Location)) > float(0))
		{
			PushVelocity = Normal(P.Location - Location) * float(200);
			PushVelocity.Z = 100.0000000;
			P.AddVelocity(PushVelocity, Location, CrushedDamageType);
		}
		return false;
	}
	// End:0x3F3
	if(P.Base == self)
	{
		RanInto(P);
		// End:0x3CD
		if(P.Base != none)
		{
			P.JumpOffPawn();
		}
		// End:0x3F3
		if(P.Base == none)
		{
			return false;
		}
	}
	PancakeOther(P);
	return false;
	//return ReturnValue;	
}

function PancakeOther(Pawn Other)
{
	Other.TakeDamage(10000, GetCollisionDamageInstigator(), Other.Location, Velocity * Other.Mass, CrushedDamageType);
	//return;	
}

function CrushedBy(Pawn OtherPawn)
{
	//return;	
}

simulated event Vector GetEntryLocation()
{
	return Location;
	//return ReturnValue;	
}

simulated function SetDriving(bool B)
{
	// End:0x38
	if(bDriving != B)
	{
		bDriving = B;
		DrivingStatusChanged();
	}
	//return;	
}

simulated function DrivingStatusChanged()
{
	// End:0x3C
	if(!bDriving)
	{
		Throttle = 0.0000000;
		Steering = 0.0000000;
		Rise = 0.0000000;
	}
	//return;	
}

simulated event ReplicatedEvent(name VarName)
{
	// End:0x24
	if(VarName == 'bDriving')
	{
		DrivingStatusChanged();		
	}
	else
	{
		// End:0x7D
		if(VarName == 'Driver')
		{
			// End:0x7A
			if((PlayerReplicationInfo != none) && Driver != none)
			{
				Driver.NotifyTeamChanged();
			}			
		}
		else
		{
			super.ReplicatedEvent(VarName);
		}
	}
	//return;	
}

simulated event bool GwNavBotEnterVehicle(Pawn Bot)
{
	return false;
	//return ReturnValue;	
}

simulated event bool GwNavBotExitVehicle(Pawn WeaponPawn)
{
	return false;
	//return ReturnValue;	
}

function NotifyDriverTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, Class<DamageType> DamageType, Vector Momentum)
{
	//return;	
}

simulated function ZeroMovementVariables()
{
	super.ZeroMovementVariables();
	Steering = 0.0000000;
	Rise = 0.0000000;
	Throttle = 0.0000000;
	//return;	
}

defaultproperties
{
	bAttachDriver=true
	bRetryPathfindingWithDriver=true
	bDoExtraNetRelevancyTraces=true
	MomentumMult=1.0000000
	CrushedDamageType=Class'Engine.DmgType_Crushed'
	MinCrushSpeed=20.0000000
	ForceCrushPenetration=10.0000000
	TurnTime=2.0000000
	bCanBeBaseForPawns=true
	bDontPossess=true
	bPathfindsAsVehicle=true
	bReplicateHealthToAll=true
	LandMovementState="PlayerDriving"
	// Reference: CylinderComponent'Engine.Default__Vehicle.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__Pawn.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	CollisionComponent=CollisionCylinder
}