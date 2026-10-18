class UDKVehicleBase extends GwNavVehicle
	abstract
	native
	config(GwNavEngine);

var bool bShouldEject;

simulated event HoldGameObject(UDKCarriedObject GameObj)
{
	//return;	
}

simulated function SwitchWeapon(byte NewGroup)
{
	ServerChangeSeat(int(NewGroup) - int(1));
	//return;	
}

simulated function AdjacentSeat(int Direction, Controller C)
{
	ServerAdjacentSeat(Direction, C);
	//return;	
}

reliable server function ServerAdjacentSeat(int Direction, Controller C)
{
	//return;	
}

reliable server function ServerChangeSeat(int RequestedSeat)
{
	//return;	
}

function float GetDamageScaling()
{
	// End:0x3E
	if(Driver != none)
	{
		return Driver.GetDamageScaling() * super(Pawn).GetDamageScaling();		
	}
	else
	{
		return super(Pawn).GetDamageScaling();
	}
	//return ReturnValue;	
}

function bool NeedToTurn(Vector targ)
{
	local UDKWeapon VWeapon;

	VWeapon = UDKWeapon(Weapon);
	// End:0x50
	if(VWeapon != none)
	{
		return VWeapon.IsAimCorrect()!;		
	}
	else
	{
		return super(Pawn).NeedToTurn(targ);
	}
	//return ReturnValue;	
}

simulated function DrivingStatusChanged()
{
	super(SVehicle).DrivingStatusChanged();
	// End:0x23
	if(bDriving!)
	{
		StopFiringWeapon();
	}
	//return;	
}

function bool DriverEnter(Pawn P)
{
	local AIController C;

	// End:0x9D
	if(super(Vehicle).DriverEnter(P))
	{
		// End:0x97
		foreach WorldInfo.AllControllers(Class'Engine.AIController', C)
		{
			// End:0x96
			if(C.Enemy == P)
			{
				C.Enemy = self;
			}			
		}		
		return true;		
	}
	else
	{
		return false;
	}
	//return ReturnValue;	
}

simulated function ApplyWeaponEffects(int OverlayFlags, optional int SeatIndex)
{
	//return;	
}

function name GetVehicleDrivingStatName()
{
	local name VehicleStatName;

	VehicleStatName = name(string('DRIVING_') $ string(Class.Name));
	return VehicleStatName;
	//return ReturnValue;	
}

function EjectDriver()
{
	local float Speed;
	local Rotator ExitRotation;

	// End:0x11
	if(Driver == none)
	{
		return;
	}
	// End:0x105
	if(PlayerController(Driver.Controller) != none)
	{
		ExitRotation = Rotation;
		ExitRotation.Pitch = -8192;
		ExitRotation.Roll = 0;
		Driver.Controller.SetRotation(ExitRotation);
		Driver.Controller.ClientSetRotation(ExitRotation);
	}
	Speed = VSize(Velocity);
	// End:0x1CA
	if((Speed < float(2600)) && Speed > float(0))
	{
		Driver.Velocity = ((-0.6000000 * (float(2600) - Speed)) * Velocity) / Speed;
		Driver.Velocity.Z = 600.0000000;		
	}
	else
	{
		Driver.Velocity = vect(0.0000000, 0.0000000, 600.0000000);
	}
	// End:0x28E
	if(UDKPawn(Driver) != none)
	{
		UDKPawn(Driver).CustomGravityScaling = 0.5000000;
		UDKPawn(Driver).bNotifyStopFalling = true;
		UDKPawn(Driver).MultiJumpRemaining = 0;
	}
	//return;	
}

simulated function DetachDriver(Pawn P)
{
	local UDKPawn UTP;

	super(Vehicle).DetachDriver(P);
	UTP = UDKPawn(P);
	// End:0x208
	if(UTP != none)
	{
		UTP.Mesh.UpdateRBBonesFromSpaceBases(true, true);
		// End:0x15F
		if(UTP.Mesh.PhysicsAssetInstance != none)
		{
			UTP.Mesh.PhysicsAssetInstance.SetAllBodiesFixed(true);
			UTP.Mesh.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(false, UTP.Mesh);
		}
		UTP.Mesh.bUpdateKinematicBonesFromAnimation = UTP.default.Mesh.bUpdateKinematicBonesFromAnimation;
		UTP.SetWeaponAttachmentVisibility(true);
		UTP.SetHandIKEnabled(true);
	}
	//return;	
}

function byte ChooseFireMode()
{
	// End:0x41
	if(UDKWeapon(Weapon) != none)
	{
		return UDKWeapon(Weapon).BestMode();
	}
	return 0;
	//return ReturnValue;	
}

function bool BotFire(bool bFinished)
{
	local UDKBot Bot;

	Bot = UDKBot(Controller);
	// End:0x81
	if((Bot != none) && int(Bot.ScriptedFireMode) != int(255))
	{
		StartFire(Bot.ScriptedFireMode);		
	}
	else
	{
		StartFire(ChooseFireMode());
	}
	return true;
	//return ReturnValue;	
}

simulated function StopFiringWeapon()
{
	// End:0x2E
	if(Weapon != none)
	{
		Weapon.ForceEndFire();
	}
	//return;	
}

function DriverLeft()
{
	local AIController C;

	// End:0x81
	foreach WorldInfo.AllControllers(Class'Engine.AIController', C)
	{
		// End:0x80
		if(C.Enemy == self)
		{
			C.Enemy = Driver;
		}		
	}	
	// End:0xA5
	if(bShouldEject)
	{
		EjectDriver();
		bShouldEject = false;
	}
	super(Vehicle).DriverLeft();
	//return;	
}

function HandleDeadVehicleDriver()
{
	local Pawn OldDriver;
	local UDKVehicle VehicleBase;

	// End:0x275
	if(Driver != none)
	{
		VehicleBase = UDKVehicle(self);
		// End:0x4F
		if(VehicleBase == none)
		{
			VehicleBase = UDKVehicle(GetVehicleBase());
		}
		// End:0x21F
		if((((VehicleBase != none) && VehicleBase.bEjectKilledBodies) && (WorldInfo.TimeSeconds - LastRenderTime) < 1.0000000) && bDriverIsVisible || (int(WorldInfo.GetDetailMode()) != int(0)) && WorldInfo.bDropDetail!)
		{
			// End:0x177
			if(bDriverIsVisible! && PlaceExitingDriver())
			{
				Driver.StopDriving(self);
				Driver.DrivenVehicle = self;
			}
			Driver.TearOffMomentum = Velocity * 0.2500000;
			Driver.SetOwner(none);
			Driver.Died(none, VehicleBase.GetRanOverDamageType(), Driver.Location);			
		}
		else
		{
			OldDriver = Driver;
			Driver = none;
			OldDriver.DrivenVehicle = none;
			OldDriver.Destroy();
		}
	}
	//return;	
}

event int GetFirstAvailableSeat()
{
	return -1;
	//return ReturnValue;	
}

defaultproperties
{
	// Reference: GwNavBotHandle'UDKBase.Default__UDKVehicleBase.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'GwNavEngine.Default__GwNavVehicle.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	// Reference: RB_StayUprightSetup'UDKBase.Default__UDKVehicleBase.MyStayUprightSetup'
	// Archetype: RB_StayUprightSetup'GwNavEngine.Default__GwNavVehicle.MyStayUprightSetup'
	begin object name="MyStayUprightSetup"
	end object
	StayUprightConstraintSetup=MyStayUprightSetup
	// Reference: RB_ConstraintInstance'UDKBase.Default__UDKVehicleBase.MyStayUprightConstraintInstance'
	// Archetype: RB_ConstraintInstance'GwNavEngine.Default__GwNavVehicle.MyStayUprightConstraintInstance'
	begin object name="MyStayUprightConstraintInstance"
	end object
	StayUprightConstraintInstance=MyStayUprightConstraintInstance
	AwareRadius=12000.0000000
	SightRadius=12000.0000000
	// Reference: SkeletalMeshComponent'UDKBase.Default__UDKVehicleBase.SVehicleMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SVehicleMesh'
	// Archetype: SkeletalMeshComponent'GwNavEngine.Default__GwNavVehicle.SVehicleMesh'
	begin object name="SVehicleMesh"
		ReplacementPrimitive=none
	end object
	Mesh=SVehicleMesh
	// Reference: CylinderComponent'UDKBase.Default__UDKVehicleBase.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'GwNavEngine.Default__GwNavVehicle.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=CollisionCylinder
	Components[1]=SVehicleMesh
	Components[2]=myGwNavBotHandle
	bCanBeAdheredTo=true
	bCanBeFrictionedTo=true
	CollisionComponent=SVehicleMesh
}