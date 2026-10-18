class UDKJumpPad extends NavigationPoint
	native;

var Vector JumpVelocity;
var Actor JumpTarget;
var SoundCue JumpSound;
var float JumpTime;
var float JumpAirControl;
var export editinline AudioComponent JumpAmbientSound;
var float CustomGravityScaling;

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	// End:0x45
	if((UDKPawn(Other) == none) || int(Other.Physics) == int(0))
	{
		return;
	}
	PendingTouch = Other.PendingTouch;
	Other.PendingTouch = self;
	//return;	
}

event PostTouch(Actor Other)
{
	local UDKPawn P;

	P = UDKPawn(Other);
	// End:0x7E
	if(((P == none) || int(P.Physics) == int(0)) || P.DrivenVehicle != none)
	{
		return;
	}
	// End:0xBF
	if(P.bNotifyStopFalling)
	{
		P.StoppedFalling();
	}
	// End:0x2B0
	if(UDKBot(P.Controller) != none)
	{
		// End:0x1B0
		if(Other.GetGravityZ() > WorldInfo.DefaultGravityZ)
		{
			UDKBot(P.Controller).Focus = UDKBot(P.Controller).FaceActor(2.0000000);			
		}
		else
		{
			P.Controller.Focus = JumpTarget;
		}
		P.Controller.MoveTarget = JumpTarget;
		// End:0x28C
		if(int(P.Physics) != int(4))
		{
			P.Controller.MoveTimer = 2.0000000;
		}
		P.DestinationOffset = 50.0000000;
	}
	// End:0x314
	if(int(P.Physics) == int(1))
	{
		P.SetPhysics(2);
		P.bReadyToDoubleJump = true;
	}
	P.Velocity = JumpVelocity;
	// End:0x422
	if((WorldInfo.WorldGravityZ != WorldInfo.DefaultGravityZ) && Other.GetGravityZ() == WorldInfo.WorldGravityZ)
	{
		P.Velocity *= Sqrt(Other.GetGravityZ() / WorldInfo.DefaultGravityZ);
	}
	P.AirControl = JumpAirControl;
	P.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
	// End:0x4B3
	if(JumpSound != none)
	{
		P.PlaySound(JumpSound);
	}
	//return;	
}

event bool SuggestMovePreparation(Pawn Other)
{
	local Vehicle V;

	V = Vehicle(Other);
	// End:0x4B
	if(V != none)
	{
		V.DriverLeave(false);
	}
	return false;
	//return ReturnValue;	
}

defaultproperties
{
	JumpTime=2.0000000
	JumpAirControl=0.0500000
	CustomGravityScaling=1.0000000
	bSpecialMove=true
	bDestinationOnly=true
	bBlockedForVehicles=true
	// Reference: CylinderComponent'UDKBase.Default__UDKJumpPad.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__NavigationPoint.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
		CollideActors=true
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=none
	Components[1]=CollisionCylinder
	Components[2]=none
	// Reference: DynamicLightEnvironmentComponent'UDKBase.Default__UDKJumpPad.JumpPadLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'JumpPadLightEnvironment'
	begin object name="JumpPadLightEnvironment" class=Engine.DynamicLightEnvironmentComponent
		bCastShadows=false
		bDynamic=false
	end object
	Components[3]=JumpPadLightEnvironment
	bStatic=false
	bMovable=false
	bCollideActors=true
	CollisionComponent=CollisionCylinder
}