class Teleporter extends NavigationPoint
	native
	placeable;

var string URL;
var name ProductRequired;
var bool bChangesVelocity;
var bool bChangesYaw;
var bool bReversesX;
var bool bReversesY;
var bool bReversesZ;
var bool bEnabled;
var bool bCanTeleportVehicles;
var Vector TargetVelocity;
var float LastFired;

replication
{
	// Pos:0x000
	if(int(Role) == int(ROLE_Authority))
		URL, bEnabled;

	// Pos:0x011
	if(bNetInitial && int(Role) == int(ROLE_Authority))
		TargetVelocity, bChangesVelocity, 
		bChangesYaw, bReversesX, 
		bReversesY, bReversesZ;
}

// Export UTeleporter::execCanTeleport(FFrame&, void* const)
native function bool CanTeleport(Actor A);

event PostBeginPlay()
{
	// End:0x16
	if(URL ComplementEqual "")
	{
		SetCollision(false, false);
	}
	super(Actor).PostBeginPlay();
	//return;	
}

simulated event bool Accept(Actor Incoming, Actor Source)
{
	local Rotator NewRot, oldRot;
	local float Mag;
	local Vector oldDir;
	local Controller C;

	// End:0x11
	if(Incoming == none)
	{
		return false;
	}
	Disable('Touch');
	NewRot = Incoming.Rotation;
	// End:0x14A
	if(bChangesYaw)
	{
		oldRot = Incoming.Rotation;
		NewRot.Yaw = Rotation.Yaw;
		// End:0x14A
		if(Source != none)
		{
			NewRot.Yaw += ((32768 + Incoming.Rotation.Yaw) - Source.Rotation.Yaw);
		}
	}
	// End:0x454
	if(Pawn(Incoming) != none)
	{
		// End:0x1F7
		if(int(Role) == int(ROLE_Authority))
		{
			// End:0x1F6
			foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
			{
				// End:0x1F5
				if(C.Enemy == Incoming)
				{
					C.EnemyJustTeleported();
				}				
			}			
		}
		// End:0x254
		if(Pawn(Incoming).SetLocation(Location)!)
		{
			LogInternal((string(self) $ " Teleport failed for ") $ string(Incoming));
			return false;
		}
		// End:0x36F
		if((int(Role) == int(ROLE_Authority)) || (WorldInfo.TimeSeconds - LastFired) > 0.5000000)
		{
			NewRot.Roll = 0;
			Pawn(Incoming).SetRotation(NewRot);
			Pawn(Incoming).SetViewRotation(NewRot);
			Pawn(Incoming).ClientSetRotation(NewRot);
			LastFired = WorldInfo.TimeSeconds;
		}
		// End:0x430
		if(Pawn(Incoming).Controller != none)
		{
			Pawn(Incoming).Controller.MoveTimer = -1.0000000;
			Pawn(Incoming).SetAnchor(self);
			Pawn(Incoming).SetMoveTarget(self);
		}
		Incoming.PlayTeleportEffect(false, true);		
	}
	else
	{
		// End:0x487
		if(Incoming.SetLocation(Location)!)
		{
			Enable('Touch');
			return false;
		}
		// End:0x4B5
		if(bChangesYaw)
		{
			Incoming.SetRotation(NewRot);
		}
	}
	Enable('Touch');
	// End:0x4F8
	if(bChangesVelocity)
	{
		Incoming.Velocity = TargetVelocity;		
	}
	else
	{
		// End:0x614
		if(bChangesYaw)
		{
			// End:0x54C
			if(int(Incoming.Physics) == int(1))
			{
				oldRot.Pitch = 0;
			}
			oldDir = Vector(oldRot);
			Mag = Incoming.Velocity Dot oldDir;
			Incoming.Velocity = (Incoming.Velocity - (Mag * oldDir)) + (Mag * Vector(Incoming.Rotation));
		}
		// End:0x659
		if(bReversesX)
		{
			Incoming.Velocity.X *= -1.0000000;
		}
		// End:0x69E
		if(bReversesY)
		{
			Incoming.Velocity.Y *= -1.0000000;
		}
		// End:0x6E3
		if(bReversesZ)
		{
			Incoming.Velocity.Z *= -1.0000000;
		}
	}
	Incoming.PostTeleport(self);
	return true;
	//return ReturnValue;	
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	// End:0x22
	if(bEnabled! || Other == none)
	{
		return;
	}
	// End:0xA7
	if((CanTeleport(Other)) && Other.PreTeleport(self)!)
	{
		PendingTouch = Other.PendingTouch;
		Other.PendingTouch = self;
	}
	//return;	
}

simulated event PostTouch(Actor Other)
{
	local Teleporter D, Dest[16];
	local int I;

	// End:0xFC
	if((InStr(URL, "/") >= 0) || InStr(URL, "#") >= 0)
	{
		// End:0xF9
		if(((int(Role) == int(ROLE_Authority)) && Pawn(Other) != none) && Pawn(Other).IsHumanControlled())
		{
			WorldInfo.Game.SendPlayer(PlayerController(Pawn(Other).Controller), URL);
		}		
	}
	else
	{
		// End:0x190
		foreach AllActors(Class'Engine.Teleporter', D)
		{
			// End:0x18F
			if((string(D.Tag) ComplementEqual URL) && D != self)
			{
				Dest[I] = D;
				I++;
				// End:0x18F
				if(I > 16)
				{
					// End:0x190
					break;
				}
			}			
		}		
		I = Rand(I);
		// End:0x236
		if(Dest[I] != none)
		{
			// End:0x203
			if(Other.IsA('Pawn'))
			{
				Other.PlayTeleportEffect(true, true);
			}
			Dest[I].Accept(Other, self);
		}
	}
	//return;	
}

event Actor SpecialHandling(Pawn Other)
{
	// End:0x116
	if(((bEnabled && Other.Controller.RouteCache.Length > 1) && Teleporter(Other.Controller.RouteCache[1]) != none) && string(Other.Controller.RouteCache[1].Tag) ComplementEqual URL)
	{
		// End:0x114
		if(IsOverlapping(Other))
		{
			PostTouch(Other);
		}
		return self;
	}
	return none;
	//return ReturnValue;	
}

defaultproperties
{
	bChangesYaw=true
	bEnabled=true
	// Reference: CylinderComponent'Engine.Default__Teleporter.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__NavigationPoint.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=80.0000000
		CollisionRadius=40.0000000
		ReplacementPrimitive=none
		CollideActors=true
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=none
	Components[1]=none
	Components[2]=none
	Components[3]=CollisionCylinder
	Components[4]=none
	RemoteRole=ENetRole.ROLE_SimulatedProxy
	bCollideActors=true
	CollisionComponent=CollisionCylinder
}