class HaloStudGridComponent extends ActorComponent;

var Vector LocalOffset;
var int StudCtX;
var int StudCtY;
var float StudCadence;
var HaloWeapon_TargetDesignator.ETargetDesignatorCategory RequiredCategory;
var bool bCanBeBuiltOn;
var Actor PluggedInActor;
var float SysTimeOfLastPlugIn;

static final simulated function float StudNumToCoord(int studNum, float cadence)
{
	local float halfCadence;

	// DebugMode: 0
	assert(studNum != 0);
	halfCadence = cadence * 0.5000000;
	// End:0x5E
	if(studNum > 0)
	{
		return halfCadence + (float(studNum - 1) * cadence);
	}
	return halfCadence- + (float(studNum + 1) * cadence);
	//return ReturnValue;	
}

static final simulated function int StudCoordToNum(float localCoord, float cadence)
{
	// End:0x35
	if(localCoord >= 0.0000000)
	{
		return FFloor(localCoord / cadence) + 1;
	}
	return FFloor(localCoord / cadence);
	//return ReturnValue;	
}

static final simulated function Vector SnapLocalCoordsToStudCoords(Vector localCoords, float cadence)
{
	local Vector resultVec;

	resultVec.X = StudNumToCoord(StudCoordToNum(localCoords.X, cadence), cadence);
	resultVec.Y = StudNumToCoord(StudCoordToNum(localCoords.Y, cadence), cadence);
	resultVec.Z = localCoords.Z;
	return resultVec;
	//return ReturnValue;	
}

static final simulated function int ToIndexedRange(int startStudNum, int totalNumStuds)
{
	// DebugMode: 0
	assert((startStudNum != 0) && (totalNumStuds % 2) == 0);
	// End:0x53
	if(startStudNum > 0)
	{
		return (totalNumStuds / 2) + (startStudNum - 1);		
	}
	else
	{
		return int(float(totalNumStuds / 2) - Abs(float(startStudNum)));
	}
	//return ReturnValue;	
}

static final simulated function int ToStudRange(int startStudNum, int totalNumStuds)
{
	local int Result;

	// DebugMode: 0
	assert((startStudNum >= 0) && startStudNum < totalNumStuds);
	Result = (startStudNum + 1) - (totalNumStuds / 2);
	// End:0x68
	if(Result <= 0)
	{
		Result--;
	}
	return Result;
	//return ReturnValue;	
}

static final simulated function Vector GetLocalStudCoordCenterOfBounds(int firstStudNumX, int lastStudNumX, int firstStudNumY, int lastStudNumY, float cadence)
{
	local Vector centerPoint;

	centerPoint.X = (StudNumToCoord(firstStudNumX, cadence) + StudNumToCoord(lastStudNumX, cadence)) * 0.5000000;
	centerPoint.Y = (StudNumToCoord(firstStudNumY, cadence) + StudNumToCoord(lastStudNumY, cadence)) * 0.5000000;
	centerPoint.Z = 0.0000000;
	return centerPoint;
	//return ReturnValue;	
}

static final simulated function bool SuggestFittedStudNums(int boardWidth, int itemWidth, int centerStudNum, out int firstStudNum, out int lastStudNum)
{
	local int adjustDiff;

	// End:0x63
	if(Abs(float(centerStudNum)) > float(boardWidth / 2))
	{
		// End:0x4C
		if(centerStudNum < 0)
		{
			centerStudNum = boardWidth / 2-;			
		}
		else
		{
			centerStudNum = boardWidth / 2;
		}
	}
	// End:0xB0
	if(((itemWidth > boardWidth) || centerStudNum == 0) || Abs(float(centerStudNum)) > float(boardWidth / 2))
	{
		return false;
	}
	centerStudNum = ToIndexedRange(centerStudNum, boardWidth);
	lastStudNum = centerStudNum + (itemWidth / 2);
	firstStudNum = (centerStudNum + 1) - (itemWidth / 2);
	adjustDiff = 0;
	// End:0x163
	if(lastStudNum >= boardWidth)
	{
		adjustDiff = (boardWidth - lastStudNum) - 1;		
	}
	else
	{
		// End:0x18B
		if(firstStudNum < 0)
		{
			adjustDiff = int(Abs(float(firstStudNum)));
		}
	}
	firstStudNum += adjustDiff;
	centerStudNum += adjustDiff;
	lastStudNum += adjustDiff;
	firstStudNum = ToStudRange(firstStudNum, boardWidth);
	lastStudNum = ToStudRange(lastStudNum, boardWidth);
	return true;
	//return ReturnValue;	
}

final simulated function bool FindBestPlacement(Vector HitLocation, int itemStudsX, int itemStudsY, out Vector outSnappedWorldLocation, out Rotator outSnappedWorldOrientation)
{
	local Vector gridCenterLocation;
	local Rotator gridCenterOrient;
	local Vector localStudLocation, localSnappedStudLocation, globalSnappedStudLocation;
	local int aimStudX, aimStudY, firstFitStudX, firstFitStudY, lastFitStudX, lastFitStudY;

	// End:0x11
	if(CheckSanity()!)
	{
		return false;
	}
	gridCenterLocation = Owner.Location + (LocalOffset >> Owner.Rotation);
	gridCenterOrient = Owner.Rotation;
	localStudLocation = HitLocation - gridCenterLocation;
	localStudLocation = localStudLocation << gridCenterOrient;
	aimStudX = StudCoordToNum(localStudLocation.X, StudCadence);
	aimStudY = StudCoordToNum(localStudLocation.Y, StudCadence);
	// End:0x24E
	if(SuggestFittedStudNums(StudCtX, itemStudsX, aimStudX, firstFitStudX, lastFitStudX) && SuggestFittedStudNums(StudCtY, itemStudsY, aimStudY, firstFitStudY, lastFitStudY))
	{
		localSnappedStudLocation = GetLocalStudCoordCenterOfBounds(firstFitStudX, lastFitStudX, firstFitStudY, lastFitStudY, StudCadence);
		globalSnappedStudLocation = localSnappedStudLocation >> gridCenterOrient;
		globalSnappedStudLocation += gridCenterLocation;
		outSnappedWorldLocation = globalSnappedStudLocation;
		outSnappedWorldOrientation = gridCenterOrient;
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function bool IsCompatibleWithCategory(byte desiredCategoryByte)
{
	local HaloWeapon_TargetDesignator.ETargetDesignatorCategory desiredCategory;

	desiredCategory = desiredCategoryByte;
	// End:0x76
	if(((int(desiredCategory) == int(self.RequiredCategory)) || int(desiredCategory) == int(0)) || int(self.RequiredCategory) == int(0))
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function bool HasOpenPegs()
{
	// End:0x87
	if(((PluggedInActor != none) && PluggedInActor.IsPendingKill()) || (Pawn(PluggedInActor) != none) && Pawn(PluggedInActor).Health < 0)
	{
		PluggedInActor = none;
	}
	return (PluggedInActor == none) && bCanBeBuiltOn;
	//return ReturnValue;	
}

simulated function float GetApproxRadius()
{
	local float maxStudCt;

	maxStudCt = float(Max(StudCtX, StudCtY));
	return (StudCadence * maxStudCt) * 0.5000000;
	//return ReturnValue;	
}

simulated function SetPluggedInActor(Actor newPluggedInActor)
{
	local Actor prevPluggedInActor;

	prevPluggedInActor = PluggedInActor;
	// End:0xBD
	if(PluggedInActor != none)
	{
		WarnInternal((("Setting a new plugged-in actor " $ string(newPluggedInActor.Name)) $ " on a HaloStudGridComponent already occupied by ") $ string(PluggedInActor.Name));
	}
	PluggedInActor = newPluggedInActor;
	SysTimeOfLastPlugIn = Owner.WorldInfo.TimeSeconds;
	// End:0x178
	if((prevPluggedInActor != newPluggedInActor) && HaloStudGridActor(Owner) != none)
	{
		HaloStudGridActor(Owner).NotifyOfPluggedInActorChange(newPluggedInActor, prevPluggedInActor);
	}
	// End:0x1B1
	if((int(RequiredCategory) == int(2)) && HaloVehicle(newPluggedInActor) != none)
	{
		PluggedInActor = none;
	}
	//return;	
}

simulated function bool CheckSanity()
{
	// End:0x50
	if(Owner == none)
	{
		WarnInternal(("HaloStudGridComponent named " $ string(Name)) $ " has no owner!");
		return false;
	}
	// End:0xC7
	if(StudCadence <= 0.0000000)
	{
		WarnInternal((("HaloStudGridComponent on " $ string(Owner.Name)) $ " has bad cadence: ") $ string(StudCadence));
		return false;
	}
	// End:0x1A2
	if((((StudCtX < 2) || StudCtY < 2) || (StudCtX % 2) != 0) || (StudCtY % 2) != 0)
	{
		WarnInternal((((("HaloStudGridComponent on " $ string(Owner.Name)) $ " has non-positive or non-even stud counts: ") $ string(StudCtX)) $ "x") $ string(StudCtY));
		return false;
	}
	return true;
	//return ReturnValue;	
}

defaultproperties
{
	StudCtX=2
	StudCtY=2
	StudCadence=36.0000000
	bCanBeBuiltOn=true
}