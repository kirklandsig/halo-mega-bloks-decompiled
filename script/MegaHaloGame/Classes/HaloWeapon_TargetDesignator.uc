class HaloWeapon_TargetDesignator extends UTBeamWeapon
	config(Deployables);

enum ETargetDesignatorCategory
{
	TDC_None,                       // 0
	TDC_Turrets,                    // 1
	TDC_Vehicles,                   // 2
	TDC_Walls,                      // 3
	TDC_Ground_Traps,               // 4
	TDC_Wall_Traps,                 // 5
	TDC_FreeObjects,                // 6
	TDC_MAX                         // 7
};

struct DeployableItemInfo
{
	var name Name;
	var int BlokCost;
	var bool Unlocked;
	var string IconPkgPath;
	var StaticMesh PreviewMesh;
	var bool RequiresPegs;
	var int PegsX;
	var int PegsY;
	var bool AlignWithWorldAxes;
	var bool AlignWithFloor;
	var float UpOffset;
	var name MagicMomentEventName;
	var Actor DeployArchetypeRef;
	var string DeployClassName;
	var Class<Actor> DeployClassRef;

	structdefaultproperties
	{
		Name="None"
		BlokCost=1
		Unlocked=true
		IconPkgPath=""
		PreviewMesh=none
		RequiresPegs=false
		PegsX=2
		PegsY=2
		AlignWithWorldAxes=false
		AlignWithFloor=false
		UpOffset=1.0000000
		MagicMomentEventName="None"
		DeployArchetypeRef=none
		DeployClassName=""
		DeployClassRef=none
	}
};

var config array<config DeployableItemInfo> DeployableTurretsArray;
var config array<config DeployableItemInfo> DeployableVehiclesArray;
var config array<config DeployableItemInfo> DeployableWallsArray;
var config array<config DeployableItemInfo> DeployableGroundTrapsArray;
var config array<config DeployableItemInfo> DeployableWallTrapsArray;
var config array<config DeployableItemInfo> DeployableFreeObjectsArray;
var bool bAllUnlockedItemsCanBeBuilt;
var bool bCheatToBuildVehiclesAnywhere;
var bool CurrentlyAimingOnPegs;
var bool CurrentAimPointOKToDeploy;
var float SoftLockMaxAngleDegrees;
var float SoftLockMaxHorizAngleDegrees;
var float SoftLockMinDistanceSq;
var float SoftLockMaxDistanceSq;
var float SoftLockHorzAngleWeight;
var float SoftLockVertAngleWeight;
var float SoftLockDistanceWeight;
var float SoftLockHorzAngleScalar;
var float SoftLockVertAngleScalar;
var Actor SoftLockTarget;
var int SoftLockSafetyCheck;
var float SoftLockCameraInterpRate;
var Actor ActionedLockedTarget;
var LinearColor GoodPlacementColor;
var LinearColor BadPlacementColor;
var HaloWeapon_TargetDesignator.ETargetDesignatorCategory CurrentTDCategory;
var byte CurrentTDItemIdx;
var byte CurrentTDItemMaxIdx;
var DeployableItemInfo CurrentDeployItemInfo;
var float SysTimeOfLastSelectionChange;
var const float SecsDisabledAfterChange;
var const float SecsRequiredToDeploy;
var Vector CurrentAimPoint;
var Vector CurrentDeployPoint;
var Vector CurrentAimDir;
var Rotator CurrentAimGridOrientation;
var export editinline HaloStudGridComponent CurrentStudBase;
var float CurrentDeployCountdown;
var Actor LastDeployedActor;
var AkEvent PlayTargetEvent;
var AkEvent StopTargetEvent;
var AkEvent PlayBuildEvent;
var AkEvent StopBuildEvent;

simulated function PostBeginPlay()
{
	SysTimeOfLastSelectionChange = WorldInfo.TimeSeconds;
	SoftLockMaxDistanceSq = WeaponRange * WeaponRange;
	SoftLockHorzAngleScalar = SoftLockMaxDistanceSq / SoftLockMaxHorizAngleDegrees;
	SoftLockVertAngleScalar = SoftLockMaxDistanceSq / SoftLockMaxAngleDegrees;
	ResolveDeployableReferences();
	super(UTWeapon).PostBeginPlay();
	//return;	
}

simulated function ResolveDeployableReferences()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0xC7 [Loop If]
	if(I < DeployableTurretsArray.Length)
	{
		// End:0xB9
		if(DeployableTurretsArray[I].DeployClassName != "")
		{
			DeployableTurretsArray[I].DeployClassRef = Class<Actor>(FindObject(DeployableTurretsArray[I].DeployClassName, Class'Core.Class'));
		}
		++I;
		// [Loop Continue]
		goto J0x0B;
	}
	I = 0;
	J0xD2:

	// End:0x18E [Loop If]
	if(I < DeployableVehiclesArray.Length)
	{
		// End:0x180
		if(DeployableVehiclesArray[I].DeployClassName != "")
		{
			DeployableVehiclesArray[I].DeployClassRef = Class<Actor>(FindObject(DeployableVehiclesArray[I].DeployClassName, Class'Core.Class'));
		}
		++I;
		// [Loop Continue]
		goto J0xD2;
	}
	I = 0;
	J0x199:

	// End:0x255 [Loop If]
	if(I < DeployableWallsArray.Length)
	{
		// End:0x247
		if(DeployableWallsArray[I].DeployClassName != "")
		{
			DeployableWallsArray[I].DeployClassRef = Class<Actor>(FindObject(DeployableWallsArray[I].DeployClassName, Class'Core.Class'));
		}
		++I;
		// [Loop Continue]
		goto J0x199;
	}
	I = 0;
	J0x260:

	// End:0x31C [Loop If]
	if(I < DeployableGroundTrapsArray.Length)
	{
		// End:0x30E
		if(DeployableGroundTrapsArray[I].DeployClassName != "")
		{
			DeployableGroundTrapsArray[I].DeployClassRef = Class<Actor>(FindObject(DeployableGroundTrapsArray[I].DeployClassName, Class'Core.Class'));
		}
		++I;
		// [Loop Continue]
		goto J0x260;
	}
	I = 0;
	J0x327:

	// End:0x3E3 [Loop If]
	if(I < DeployableWallTrapsArray.Length)
	{
		// End:0x3D5
		if(DeployableWallTrapsArray[I].DeployClassName != "")
		{
			DeployableWallTrapsArray[I].DeployClassRef = Class<Actor>(FindObject(DeployableWallTrapsArray[I].DeployClassName, Class'Core.Class'));
		}
		++I;
		// [Loop Continue]
		goto J0x327;
	}
	I = 0;
	J0x3EE:

	// End:0x4AA [Loop If]
	if(I < DeployableFreeObjectsArray.Length)
	{
		// End:0x49C
		if(DeployableFreeObjectsArray[I].DeployClassName != "")
		{
			DeployableFreeObjectsArray[I].DeployClassRef = Class<Actor>(FindObject(DeployableFreeObjectsArray[I].DeployClassName, Class'Core.Class'));
		}
		++I;
		// [Loop Continue]
		goto J0x3EE;
	}
	//return;	
}

simulated function float GetWeaponRating()
{
	return -1.0000000;
	//return ReturnValue;	
}

simulated function HaloWeapon_TargetDesignator.ETargetDesignatorCategory GetSelectedCategory()
{
	return CurrentTDCategory;
	//return ReturnValue;	
}

simulated function int GetSelectedItemIdx()
{
	return int(CurrentTDItemIdx);
	//return ReturnValue;	
}

simulated function float GetDeployConfirmPct()
{
	// End:0x19
	if(CurrentDeployCountdown < 0.0000000)
	{
		return 0.0000000;
	}
	return 1.0000000 - FClamp(CurrentDeployCountdown / SecsRequiredToDeploy, 0.0000000, 1.0000000);
	//return ReturnValue;	
}

simulated function DeployableItemInfo GetDeployableItemInfo(byte categoryEnumByte, int itemIdx)
{
	switch(categoryEnumByte)
	{
		// End:0x47
		case 1:
			// End:0x44
			if(itemIdx < DeployableTurretsArray.Length)
			{
				return DeployableTurretsArray[itemIdx];
			}
			// End:0x14E
			break;
		// End:0x7B
		case 2:
			// End:0x78
			if(itemIdx < DeployableVehiclesArray.Length)
			{
				return DeployableVehiclesArray[itemIdx];
			}
			// End:0x14E
			break;
		// End:0xAF
		case 3:
			// End:0xAC
			if(itemIdx < DeployableWallsArray.Length)
			{
				return DeployableWallsArray[itemIdx];
			}
			// End:0x14E
			break;
		// End:0xE3
		case 4:
			// End:0xE0
			if(itemIdx < DeployableGroundTrapsArray.Length)
			{
				return DeployableGroundTrapsArray[itemIdx];
			}
			// End:0x14E
			break;
		// End:0x117
		case 5:
			// End:0x114
			if(itemIdx < DeployableWallTrapsArray.Length)
			{
				return DeployableWallTrapsArray[itemIdx];
			}
			// End:0x14E
			break;
		// End:0x14B
		case 6:
			// End:0x148
			if(itemIdx < DeployableFreeObjectsArray.Length)
			{
				return DeployableFreeObjectsArray[itemIdx];
			}
			// End:0x14E
			break;
		// End:0xFFFF
		default:
			break;
	}
	return DeployableFreeObjectsArray[0];
	//return ReturnValue;	
}

simulated function bool CanCategoryItemBeDeployed(byte categoryEnumByte, int itemIdx)
{
	switch(categoryEnumByte)
	{
		// End:0x5B
		case 1:
			// End:0x58
			if(itemIdx < DeployableTurretsArray.Length)
			{
				return DeployableTurretsArray[itemIdx].Unlocked;
			}
			// End:0x1C6
			break;
		// End:0xA3
		case 2:
			// End:0xA0
			if(itemIdx < DeployableVehiclesArray.Length)
			{
				return DeployableVehiclesArray[itemIdx].Unlocked;
			}
			// End:0x1C6
			break;
		// End:0xEB
		case 3:
			// End:0xE8
			if(itemIdx < DeployableWallsArray.Length)
			{
				return DeployableWallsArray[itemIdx].Unlocked;
			}
			// End:0x1C6
			break;
		// End:0x133
		case 4:
			// End:0x130
			if(itemIdx < DeployableGroundTrapsArray.Length)
			{
				return DeployableGroundTrapsArray[itemIdx].Unlocked;
			}
			// End:0x1C6
			break;
		// End:0x17B
		case 5:
			// End:0x178
			if(itemIdx < DeployableWallTrapsArray.Length)
			{
				return DeployableWallTrapsArray[itemIdx].Unlocked;
			}
			// End:0x1C6
			break;
		// End:0x1C3
		case 6:
			// End:0x1C0
			if(itemIdx < DeployableFreeObjectsArray.Length)
			{
				return DeployableFreeObjectsArray[itemIdx].Unlocked;
			}
			// End:0x1C6
			break;
		// End:0xFFFF
		default:
			break;
	}
	return false;
	//return ReturnValue;	
}

simulated function bool IsCategoryItemAffordable(byte categoryEnumByte, int itemIdx)
{
	local HaloPlayerPawnController Controller;
	local int playerBloks;

	Controller = HaloPlayerPawnController(Instigator.Controller);
	playerBloks = 0;
	// End:0xAF
	if((Controller != none) && Controller.BlokCollector != none)
	{
		playerBloks = Controller.BlokCollector.GetBankCount();
	}
	// End:0xBE
	if(bAllUnlockedItemsCanBeBuilt)
	{
		return true;
	}
	switch(categoryEnumByte)
	{
		// End:0x123
		case 1:
			// End:0x120
			if(itemIdx < DeployableTurretsArray.Length)
			{
				return DeployableTurretsArray[itemIdx].BlokCost <= playerBloks;
			}
			// End:0x2C0
			break;
		// End:0x175
		case 2:
			// End:0x172
			if(itemIdx < DeployableVehiclesArray.Length)
			{
				return DeployableVehiclesArray[itemIdx].BlokCost <= playerBloks;
			}
			// End:0x2C0
			break;
		// End:0x1C7
		case 3:
			// End:0x1C4
			if(itemIdx < DeployableWallsArray.Length)
			{
				return DeployableWallsArray[itemIdx].BlokCost <= playerBloks;
			}
			// End:0x2C0
			break;
		// End:0x219
		case 4:
			// End:0x216
			if(itemIdx < DeployableGroundTrapsArray.Length)
			{
				return DeployableGroundTrapsArray[itemIdx].BlokCost <= playerBloks;
			}
			// End:0x2C0
			break;
		// End:0x26B
		case 5:
			// End:0x268
			if(itemIdx < DeployableWallTrapsArray.Length)
			{
				return DeployableWallTrapsArray[itemIdx].BlokCost <= playerBloks;
			}
			// End:0x2C0
			break;
		// End:0x2BD
		case 6:
			// End:0x2BA
			if(itemIdx < DeployableFreeObjectsArray.Length)
			{
				return DeployableFreeObjectsArray[itemIdx].BlokCost <= playerBloks;
			}
			// End:0x2C0
			break;
		// End:0xFFFF
		default:
			break;
	}
	return false;
	//return ReturnValue;	
}

simulated function bool CurrentItemRequiresPegs()
{
	return CurrentDeployItemInfo.RequiresPegs;
	//return ReturnValue;	
}

simulated function bool CurrentItemShouldAlignToWorld()
{
	return CurrentDeployItemInfo.AlignWithWorldAxes;
	//return ReturnValue;	
}

simulated function bool CurrentItemShouldAlignWithFloor()
{
	return CurrentDeployItemInfo.AlignWithFloor;
	//return ReturnValue;	
}

simulated function bool IsCurrentItemUnlocked()
{
	return CurrentDeployItemInfo.Unlocked;
	//return ReturnValue;	
}

simulated function int GetCategoryItemCount(byte categoryByte)
{
	local HaloWeapon_TargetDesignator.ETargetDesignatorCategory Category;
	local int categoryCt;

	Category = categoryByte;
	categoryCt = 0;
	switch(Category)
	{
		// End:0x4D
		case 1:
			categoryCt = DeployableTurretsArray.Length;
			// End:0xDC
			break;
		// End:0x69
		case 2:
			categoryCt = DeployableVehiclesArray.Length;
			// End:0xDC
			break;
		// End:0x85
		case 4:
			categoryCt = DeployableGroundTrapsArray.Length;
			// End:0xDC
			break;
		// End:0xA1
		case 5:
			categoryCt = DeployableWallTrapsArray.Length;
			// End:0xDC
			break;
		// End:0xBD
		case 3:
			categoryCt = DeployableWallsArray.Length;
			// End:0xDC
			break;
		// End:0xD9
		case 6:
			categoryCt = DeployableFreeObjectsArray.Length;
			// End:0xDC
			break;
		// End:0xFFFF
		default:
			break;
	}
	return categoryCt;
	//return ReturnValue;	
}

static final simulated function bool ScanActorForPegData(Actor HitActor, Vector HitLocation, int itemPegsX, int itemPegsY, out Vector outBestFitPegLocation, out Rotator outBestFitOrientation)
{
	local editinline HaloStudGridComponent gridComponent;

	// End:0xAC
	if(HitActor != none)
	{
		gridComponent = HaloStudGridComponent(HitActor.GetComponentOfType(Class'MegaHaloGame.HaloStudGridComponent'));
		// End:0xAC
		if((gridComponent != none) && gridComponent.FindBestPlacement(HitLocation, itemPegsX, itemPegsY, outBestFitPegLocation, outBestFitOrientation))
		{
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

static final simulated function bool DoesActorHavePegs(Actor HitActor, optional int MinX, optional int MinY, optional byte categoryTypeByte)
{
	local editinline HaloStudGridComponent gridComponent;
	local HaloWeapon_TargetDesignator.ETargetDesignatorCategory desiredCategory;

	desiredCategory = categoryTypeByte;
	// End:0xFA
	if(HitActor != none)
	{
		gridComponent = HaloStudGridComponent(HitActor.GetComponentOfType(Class'MegaHaloGame.HaloStudGridComponent'));
		// End:0xFA
		if((((gridComponent != none) && gridComponent.StudCtX > MinX) && gridComponent.StudCtY > MinY) && gridComponent.IsCompatibleWithCategory(desiredCategory))
		{
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

static final simulated function bool DoesActorHaveUnoccupiedPegs(Actor HitActor)
{
	local editinline HaloStudGridComponent gridComponent;

	// End:0x7F
	if(HitActor != none)
	{
		gridComponent = HaloStudGridComponent(HitActor.GetComponentOfType(Class'MegaHaloGame.HaloStudGridComponent'));
		// End:0x7F
		if((gridComponent != none) && gridComponent.HasOpenPegs())
		{
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

static final simulated function HaloWeapon_TargetDesignator.ETargetDesignatorCategory GetActorStudCategory(Actor HitActor)
{
	local editinline HaloStudGridComponent gridComponent;

	// End:0x78
	if(HitActor != none)
	{
		gridComponent = HaloStudGridComponent(HitActor.GetComponentOfType(Class'MegaHaloGame.HaloStudGridComponent'));
		// End:0x78
		if(gridComponent != none)
		{
			return gridComponent.RequiredCategory;
		}
	}
	return 0;
	//return ReturnValue;	
}

simulated function Actor SearchForSoftLockPeggedActors(Vector StartPos, Rotator StartOrientation, float maxVertAngleDeg, float maxHorzAngleDeg, float minDistSq, float maxDistSq, float horzAngleWeight, float vertAngleWeight, float distanceWeight, optional int minStudsX, optional int minStudsY, optional bool discardOccupiedActors)
{
	local float horzAngleScalar, vertAngleScalar;

	horzAngleScalar = maxDistSq / maxHorzAngleDeg;
	vertAngleScalar = maxDistSq / maxVertAngleDeg;
	return FindSoftLockActor(StartPos, StartOrientation, maxVertAngleDeg, maxHorzAngleDeg, minDistSq, maxDistSq, horzAngleWeight, vertAngleWeight, distanceWeight, horzAngleScalar, vertAngleScalar, minStudsX, minStudsY, discardOccupiedActors, false);
	//return ReturnValue;	
}

simulated function Actor SearchForSoftLockPeggedActorsDefault(Vector StartPos, Rotator StartOrientation, optional int minStudsX, optional int minStudsY, optional bool discardOccupiedActors)
{
	return FindSoftLockActor(StartPos, StartOrientation, SoftLockMaxAngleDegrees, SoftLockMaxHorizAngleDegrees, SoftLockMinDistanceSq, SoftLockMaxDistanceSq, SoftLockHorzAngleWeight, SoftLockVertAngleWeight, SoftLockDistanceWeight, SoftLockHorzAngleScalar, SoftLockVertAngleScalar, minStudsX, minStudsY, discardOccupiedActors, false);
	//return ReturnValue;	
}

private final simulated function Actor FindSoftLockActor(Vector StartPos, Rotator StartOrientation, float maxVertAngleDeg, float maxHorzAngleDeg, float minDistSq, float maxDistSq, float vertAngleWeight, float horzAngleWeight, float distanceWeight, float horzAngleScalar, float vertAngleScalar, int minStudsX, int minStudsY, bool discardOccupiedActors, optional bool showdebugtext = false)
{
	local HaloStudGridActor candidateActor;
	local float candidateAimAngleDegsVert, candidateAimAngleDegsHoriz, candidateWeight, candidateDistSq;
	local HaloStudGridActor softTarget;
	local float smallestWeight;
	local Vector flatFwd, fwd, startToObj, targetPos;

	// End:0x7A9
	if(Owner != none)
	{
		// End:0x64
		if(showdebugtext)
		{
			LogInternal("==============================================================");
		}
		fwd = Vector(StartOrientation);
		flatFwd = fwd;
		flatFwd.Z = 0.0000000;
		flatFwd = Normal(flatFwd);
		smallestWeight = (((maxHorzAngleDeg * horzAngleScalar) * horzAngleWeight) + ((maxVertAngleDeg * vertAngleScalar) * vertAngleWeight)) + (maxDistSq * distanceWeight);
		// End:0x152
		if(showdebugtext)
		{
			LogInternal("smallestWeight: " $ string(smallestWeight));
		}
		// End:0x7A8
		foreach GetTraceOwner().OverlappingActors(Class'MegaHaloGame.HaloStudGridActor', candidateActor, WeaponRange, Owner.Location, true)
		{
			// End:0x7A7
			if(DoesActorHavePegs(candidateActor, minStudsX, minStudsY) && !discardOccupiedActors || DoesActorHaveUnoccupiedPegs(candidateActor))
			{
				// End:0x24F
				if(showdebugtext)
				{
					LogInternal(("__________" @ string(candidateActor.Name)) @ "____________");
				}
				candidateDistSq = VSizeSq(candidateActor.Location - Owner.Location);
				// End:0x2C9
				if(showdebugtext)
				{
					LogInternal("candidateDistSq: " $ string(candidateDistSq));
				}
				candidateWeight = candidateDistSq * distanceWeight;
				// End:0x313
				if(showdebugtext)
				{
					LogInternal("dist weight: " $ string(candidateWeight));
				}
				// End:0x747
				if((candidateDistSq >= minDistSq) && candidateDistSq <= maxDistSq)
				{
					startToObj = Normal(candidateActor.Location - StartPos);
					candidateAimAngleDegsVert = Acos(fwd Dot startToObj) * 57.2957802;
					candidateWeight += ((candidateAimAngleDegsVert * vertAngleScalar) * vertAngleWeight);
					// End:0x469
					if(showdebugtext)
					{
						LogInternal("candidateAimAngleDegsVert: " $ string(candidateAimAngleDegsVert));
						LogInternal("vertAngleScalar: " $ string(vertAngleScalar));
						LogInternal("vert angle weight: " $ string((candidateAimAngleDegsVert * vertAngleScalar) * vertAngleWeight));
					}
					startToObj.Z = 0.0000000;
					startToObj = Normal(startToObj);
					candidateAimAngleDegsHoriz = Acos(flatFwd Dot startToObj) * 57.2957802;
					candidateWeight += ((candidateAimAngleDegsHoriz * horzAngleScalar) * horzAngleWeight);
					// End:0x592
					if(showdebugtext)
					{
						LogInternal("candidateAimAngleDegsHoriz: " $ string(candidateAimAngleDegsHoriz));
						LogInternal("horzAngleScalar: " $ string(horzAngleScalar));
						LogInternal("horz angle weight: " $ string((candidateAimAngleDegsHoriz * horzAngleScalar) * horzAngleWeight));
					}
					// End:0x6BA
					if((candidateAimAngleDegsVert <= maxVertAngleDeg) && candidateAimAngleDegsHoriz <= maxHorzAngleDeg)
					{
						// End:0x689
						if(candidateWeight <= smallestWeight)
						{
							targetPos = candidateActor.Location;
							targetPos.Z += 200.0000000;
							// End:0x66A
							if(FastTrace(targetPos, StartPos,, true) == true)
							{
								smallestWeight = candidateWeight;
								softTarget = candidateActor;								
							}
							else
							{
								// End:0x686
								if(showdebugtext)
								{
									LogInternal("Failed LOS");
								}
							}							
						}
						else
						{
							// End:0x6B7
							if(showdebugtext)
							{
								LogInternal("Failed Weight: " $ string(candidateWeight));
							}
						}						
					}
					else
					{
						// End:0x744
						if(showdebugtext)
						{
							LogInternal((("Failed Max Angle: vert: " $ string(candidateAimAngleDegsVert)) $ " horz: ") $ string(candidateAimAngleDegsHoriz));
							LogInternal((("Max Angle: vert: " $ string(maxVertAngleDeg)) $ " horz: ") $ string(maxHorzAngleDeg));
						}
					}
					// End:0x7A7
					continue;
				}
				// End:0x7A7
				if(showdebugtext)
				{
					LogInternal((((("Failed Dist - min: " $ string(minDistSq)) $ " max: ") $ string(maxDistSq)) $ " act: ") $ string(candidateDistSq));
				}
			}			
		}		
	}
	// End:0x82A
	if(showdebugtext && softTarget != none)
	{
		LogInternal(("<<<<<<<<<<<<<< Found Target: " @ string(softTarget.Name)) @ " >>>>>>>>>>>>>>>>>>>>>>>");		
	}
	else
	{
		// End:0x887
		if(showdebugtext)
		{
			LogInternal("==================== Setting SoftLockTarget to NONE =======================");
		}
	}
	SoftLockTarget = softTarget;
	return softTarget;
	//return ReturnValue;	
}

simulated function ProcessBeamHit(Vector StartTrace, Vector AimDir, out ImpactInfo TestImpact, float DeltaTime)
{
	local HaloWeapon_TargetDesignator.ETargetDesignatorCategory aimedAtCategory;
	local Actor aimedAtActor;
	local editinline HaloStudGridComponent aimedAtStudGrid;
	local Vector aimedAtLocation, aimedAtNormal;
	local Quat orientQuat;
	local Pawn blockingPawn;
	local float blockingObjectCheckRadius;
	local Vector deployPoint;
	local Rotator aimOrientation;
	local Vector gridAdjustedAimPoint;
	local Rotator gridOrientation;
	local DeployableItemInfo proposedItemInfo;
	local Actor altSoftLockPegBoard;

	CurrentAimPoint = TestImpact.HitLocation;
	CurrentDeployPoint = TestImpact.HitLocation;
	CurrentAimDir = AimDir;
	CurrentAimPointOKToDeploy = true;
	CurrentlyAimingOnPegs = false;
	CurrentStudBase = none;
	aimOrientation = Rotator(CurrentAimDir);
	proposedItemInfo = GetDeployableItemInfo(CurrentTDCategory, int(CurrentTDItemIdx));
	aimedAtActor = TestImpact.HitActor;
	aimedAtLocation = TestImpact.HitLocation;
	aimedAtNormal = TestImpact.HitNormal;
	aimedAtCategory = GetActorStudCategory(TestImpact.HitActor);
	// End:0x2A7
	if((Pawn(Owner) != none) && Pawn(Owner).Controller.IsInState('TargetDesignatorTransitionIn') == false)
	{
		// End:0x203
		if((int(aimedAtCategory) != int(0)) && DoesActorHaveUnoccupiedPegs(TestImpact.HitActor))
		{			
		}
		else
		{
			altSoftLockPegBoard = SearchForSoftLockPeggedActorsDefault(StartTrace, aimOrientation,,, true);
			// End:0x2A7
			if(altSoftLockPegBoard != none)
			{
				aimedAtCategory = GetActorStudCategory(altSoftLockPegBoard);
				// End:0x2A7
				if(int(aimedAtCategory) != int(0))
				{
					aimedAtActor = altSoftLockPegBoard;
					aimedAtLocation = altSoftLockPegBoard.Location;
				}
			}
		}
	}
	// End:0x2F1
	if(aimedAtActor != none)
	{
		aimedAtStudGrid = HaloStudGridComponent(aimedAtActor.GetComponentOfType(Class'MegaHaloGame.HaloStudGridComponent'));
	}
	// End:0x33E
	if((int(aimedAtCategory) == int(0)) && ActionedLockedTarget == none)
	{
		// End:0x332
		if(bCheatToBuildVehiclesAnywhere)
		{
			aimedAtCategory = 2;			
		}
		else
		{
			aimedAtCategory = 6;
		}
	}
	// End:0x36F
	if(int(aimedAtCategory) != int(CurrentTDCategory))
	{
		ChooseCategory(aimedAtCategory, true);
		return;
	}
	// End:0xA28
	if(((aimedAtActor != none) && proposedItemInfo.Unlocked) && proposedItemInfo.RequiresPegs || (aimedAtNormal Dot vect(0.0000000, 0.0000000, 1.0000000)) > 0.7070000)
	{
		CurrentAimGridOrientation.Pitch = 0;
		CurrentAimGridOrientation.Yaw = 0;
		CurrentAimGridOrientation.Roll = 0;
		// End:0x537
		if(((aimedAtActor != none) && proposedItemInfo.RequiresPegs) && ScanActorForPegData(aimedAtActor, aimedAtLocation, proposedItemInfo.PegsX, proposedItemInfo.PegsY, gridAdjustedAimPoint, gridOrientation) == true)
		{
			CurrentDeployPoint = gridAdjustedAimPoint;
			CurrentAimGridOrientation = gridOrientation;
			CurrentStudBase = aimedAtStudGrid;
			CurrentlyAimingOnPegs = true;
			aimOrientation = gridOrientation;
		}
		// End:0x5B1
		if(proposedItemInfo.AlignWithWorldAxes)
		{
			CurrentAimGridOrientation.Pitch = 0;
			CurrentAimGridOrientation.Yaw = 0;
			CurrentAimGridOrientation.Roll = 0;
		}
		// End:0x63C
		if(proposedItemInfo.AlignWithFloor && !proposedItemInfo.RequiresPegs)
		{
			orientQuat = QuatFindBetween(vect(0.0000000, 0.0000000, 1.0000000), aimedAtNormal);
			CurrentAimGridOrientation = QuatToRotator(orientQuat);
		}
		// End:0xA19
		if(((WorldInfo.TimeSeconds - SysTimeOfLastSelectionChange) > SecsDisabledAfterChange) && IsCategoryItemAffordable(CurrentTDCategory, int(CurrentTDItemIdx)))
		{
			// End:0x6FA
			if((proposedItemInfo.RequiresPegs && !CurrentlyAimingOnPegs) && (int(CurrentTDCategory) != int(2)) || !bCheatToBuildVehiclesAnywhere)
			{
				CurrentAimPointOKToDeploy = false;
			}
			// End:0x7C8
			if((proposedItemInfo.RequiresPegs && CurrentStudBase != none) && CurrentStudBase.Owner != none)
			{
				// End:0x7C4
				foreach CurrentStudBase.Owner.TouchingActors(Class'Engine.Pawn', blockingPawn)
				{
					// End:0x7C3
					if(blockingPawn.Health > 0)
					{
						CurrentAimPointOKToDeploy = false;
					}					
				}								
			}
			else
			{
				blockingObjectCheckRadius = 350.0000000;
				// End:0x7FA
				if(int(CurrentTDCategory) == int(1))
				{
					blockingObjectCheckRadius = 150.0000000;
				}
				// End:0x867
				foreach CollidingActors(Class'Engine.Pawn', blockingPawn, blockingObjectCheckRadius, CurrentDeployPoint + vect(0.0000000, 0.0000000, 50.0000000))
				{
					// End:0x866
					if(blockingPawn.Health > 0)
					{
						CurrentAimPointOKToDeploy = false;
					}					
				}				
			}
			deployPoint = CurrentDeployPoint;
			deployPoint.Z += proposedItemInfo.UpOffset;
			// End:0x97F
			if((!proposedItemInfo.RequiresPegs && proposedItemInfo.DeployArchetypeRef != none) && Spawn(proposedItemInfo.DeployArchetypeRef.Class,,, deployPoint, aimOrientation, proposedItemInfo.DeployArchetypeRef,, true) == none)
			{
				CurrentAimPointOKToDeploy = false;				
			}
			else
			{
				// End:0xA16
				if((!proposedItemInfo.RequiresPegs && proposedItemInfo.DeployClassRef != none) && Spawn(proposedItemInfo.DeployClassRef,,, deployPoint, aimOrientation,,, true) == none)
				{
					CurrentAimPointOKToDeploy = false;
				}
			}			
		}
		else
		{
			CurrentAimPointOKToDeploy = false;
		}		
	}
	else
	{
		CurrentAimPointOKToDeploy = false;
	}
	// End:0xACA
	if(int(Role) == int(ROLE_Authority))
	{
		// End:0xAA4
		if((Owner != none) && HaloPawn(Owner) != none)
		{
			HaloPawn(Owner).bIsOKToDeployTDItem = CurrentAimPointOKToDeploy;
		}
		SetCurrentFireMode(CurrentFireMode);
		SetFlashLocation(CurrentDeployPoint);
	}
	//return;	
}

simulated function ChooseCategory(byte newCategory, optional bool resetItemIndex = false)
{
	local HaloWeapon_TargetDesignator.ETargetDesignatorCategory prevCategory;

	prevCategory = CurrentTDCategory;
	CurrentTDCategory = newCategory;
	// End:0x61
	if((int(prevCategory) != int(CurrentTDCategory)) && resetItemIndex)
	{
		CurrentTDItemIdx = 0;
	}
	CurrentTDItemMaxIdx = byte(Max(0, (GetCategoryItemCount(CurrentTDCategory)) - 1));
	DeployableItemSelectionChanged();
	//return;	
}

simulated function ChooseNextItem()
{
	local int prevIdx;

	prevIdx = int(CurrentTDItemIdx);
	CurrentTDItemIdx++;
	// End:0x47
	if(int(CurrentTDItemIdx) > int(CurrentTDItemMaxIdx))
	{
		CurrentTDItemIdx = 0;
	}
	// End:0x6A
	if(int(CurrentTDItemIdx) != prevIdx)
	{
		DeployableItemSelectionChanged();
	}
	//return;	
}

simulated function ChoosePrevItem()
{
	local int prevIdx;

	prevIdx = int(CurrentTDItemIdx);
	// End:0x3F
	if(int(CurrentTDItemIdx) == int(0))
	{
		CurrentTDItemIdx = CurrentTDItemMaxIdx;		
	}
	else
	{
		CurrentTDItemIdx--;
	}
	// End:0x6D
	if(int(CurrentTDItemIdx) != prevIdx)
	{
		DeployableItemSelectionChanged();
	}
	//return;	
}

simulated function DeployableItemSelectionChanged()
{
	SysTimeOfLastSelectionChange = WorldInfo.TimeSeconds;
	CurrentDeployItemInfo = GetDeployableItemInfo(CurrentTDCategory, int(CurrentTDItemIdx));
	UpdateDeployablePreviewMesh();
	//return;	
}

simulated function UpdateDeployablePreviewMesh()
{
	// End:0xF6
	if((Owner != none) && HaloPawn(Owner) != none)
	{
		// End:0x9C
		if(CurrentDeployItemInfo.PreviewMesh != none)
		{
			HaloPawn(Owner).DeployTDPreviewMeshPath = PathName(CurrentDeployItemInfo.PreviewMesh);			
		}
		else
		{
			HaloPawn(Owner).DeployTDPreviewMeshPath = "";
		}
		// End:0xF6
		if(int(Role) != int(ROLE_Authority))
		{
			ServerUpdateDeployablePreviewMesh(CurrentTDCategory, CurrentTDItemIdx);
		}
	}
	//return;	
}

reliable server function ServerUpdateDeployablePreviewMesh(byte Category, byte Index)
{
	CurrentTDCategory = Category;
	CurrentTDItemIdx = Index;
	CurrentDeployItemInfo = GetDeployableItemInfo(CurrentTDCategory, int(CurrentTDItemIdx));
	UpdateDeployablePreviewMesh();
	//return;	
}

simulated function StartPullingTrigger()
{
	CurrentDeployCountdown = SecsRequiredToDeploy;
	//return;	
}

simulated function ReleaseTrigger()
{
	CurrentDeployCountdown = -1.0000000;
	StopBuildSoundLoop();
	//return;	
}

simulated function bool AttemptToPlaceChosenItem()
{
	local Vector deployPosOffset;
	local Rotator deployedRotation;
	local IHaloDeployable deployable;
	local HaloPlayerPawnController Controller;

	LastDeployedActor = none;
	// End:0x4C
	if(((CurrentItemRequiresPegs()) || CurrentItemShouldAlignToWorld()) || CurrentItemShouldAlignWithFloor())
	{
		deployedRotation = CurrentAimGridOrientation;		
	}
	else
	{
		deployedRotation = Rotator(CurrentAimDir);
		deployedRotation.Pitch = 0;
		deployedRotation.Roll = 0;
	}
	deployPosOffset.Z = CurrentDeployItemInfo.UpOffset;
	// End:0x4FC
	if(CurrentAimPointOKToDeploy)
	{
		// End:0x19F
		if(CurrentDeployItemInfo.DeployArchetypeRef != none)
		{
			LastDeployedActor = Spawn(CurrentDeployItemInfo.DeployArchetypeRef.Class,,, Instigator.FlashLocation + deployPosOffset, deployedRotation, CurrentDeployItemInfo.DeployArchetypeRef);			
		}
		else
		{
			// End:0x244
			if(CurrentDeployItemInfo.DeployClassRef != none)
			{
				LastDeployedActor = HaloPawn(Instigator).NetworkSpawn(CurrentDeployItemInfo.DeployClassRef, Instigator.FlashLocation + deployPosOffset, deployedRotation);				
			}
			else
			{
				WarnInternal("Somehow none of our Deployables table references are kosher - check DefaultDeployables.INI file!");
			}
		}
		// End:0x33B
		if(LastDeployedActor != none)
		{
			LastDeployedActor.SetTeamNum(Owner.GetTeamNum());
			// End:0x33B
			if((CurrentItemRequiresPegs()) && CurrentStudBase != none)
			{
				CurrentStudBase.SetPluggedInActor(LastDeployedActor);
			}
		}
		// End:0x4FA
		if(LastDeployedActor != none)
		{
			deployable = IHaloDeployable(LastDeployedActor);
			// End:0x4B2
			if(NotEqual_InterfaceInterface(deployable, IHaloDeployable(none)))
			{
				deployable.SetDeployableCategory(CurrentTDCategory);
				deployable.SetDeployableName(CurrentDeployItemInfo.Name);
				// End:0x438
				if(CurrentStudBase != none)
				{
					deployable.SetDeployableBase(CurrentStudBase.Owner);
				}
				// End:0x478
				if(Controller == none)
				{
					Controller = HaloPlayerPawnController(Instigator.Controller);
				}
				// End:0x4AF
				if(Controller != none)
				{
					Controller.NotifyOfDeployment(deployable);
				}				
			}
			else
			{
				WarnInternal(("Deploying " @ string(LastDeployedActor)) @ " which does not implement IHaloDeployable");
			}
		}
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function PlayMagicMoment(name MagicMomentEventName)
{
	local array<SequenceObject> AllSeqEvents;
	local Sequence GameSeq;
	local int I;

	GameSeq = WorldInfo.GetGameSequence();
	// End:0x147
	if(GameSeq != none)
	{
		GameSeq.FindSeqObjectsByClass(Class'Engine.SeqEvent_RemoteEvent', true, AllSeqEvents);
		I = 0;
		J0x75:

		// End:0x147 [Loop If]
		if(I < AllSeqEvents.Length)
		{
			// End:0x139
			if(SeqEvent_RemoteEvent(AllSeqEvents[I]).EventName == MagicMomentEventName)
			{
				// End:0x136
				if(SeqEvent_RemoteEvent(AllSeqEvents[I]).CheckActivate(WorldInfo, LastDeployedActor))
				{
					LastDeployedActor.SetHidden(true);
				}
				// [Explicit Break]
				goto J0x147;
			}
			I++;
			// [Loop Continue]
			goto J0x75;
		}
	}
	J0x147:

	//return;	
}

simulated function UpdateDeploymentTrigger(float DeltaTime)
{
	local HaloPlayerPawnController Controller;
	local bool itemWasPlaced;
	local DeployableItemInfo itemDeployInfo;

	// End:0x1E8
	if(CurrentDeployCountdown > 0.0000000)
	{
		// End:0x42
		if(!CurrentAimPointOKToDeploy)
		{
			CurrentDeployCountdown = SecsRequiredToDeploy;
			StopBuildSoundLoop();			
		}
		else
		{
			// End:0x63
			if(CurrentDeployCountdown >= SecsRequiredToDeploy)
			{
				PlayBuildSoundLoop();
			}
			CurrentDeployCountdown -= DeltaTime;
			// End:0x1E8
			if(CurrentDeployCountdown <= 0.0000000)
			{
				Controller = HaloPlayerPawnController(Instigator.Controller);
				itemWasPlaced = AttemptToPlaceChosenItem();
				// End:0x1CF
				if(itemWasPlaced && Controller != none)
				{
					itemDeployInfo = GetDeployableItemInfo(CurrentTDCategory, int(CurrentTDItemIdx));
					PlayMagicMoment(itemDeployInfo.MagicMomentEventName);
					// End:0x1B0
					if(Controller.BlokCollector != none)
					{
						Controller.BlokCollector.RemoveFromBank(itemDeployInfo.BlokCost);
					}
					Controller.NotifyOfTargetDesignatorDeploy();
				}
				CurrentDeployCountdown = -1.0000000;
				StopBuildSoundLoop();
			}
		}
	}
	//return;	
}

simulated function TimeWeaponPutDown()
{
	local name AnimName;
	local HaloWeapon PendingHaloWeapon;
	local UTPawn.EWeapAnimType NextWeapAnimType;

	// End:0x117
	if((Instigator != none) && Instigator.InvManager != none)
	{
		PendingHaloWeapon = HaloWeapon(Instigator.InvManager.PendingWeapon);
		// End:0x117
		if(PendingHaloWeapon != none)
		{
			NextWeapAnimType = PendingHaloWeapon.AttachmentClass.default.WeapAnimType;
			AnimName = PendingHaloWeapon.GetSwapWeaponAnimName(AttachmentClass.default.WeapAnimType, NextWeapAnimType);
		}
	}
	// End:0x169
	if((PendingHaloWeapon == none) || PendingHaloWeapon.PlayTopHalfAnim(AnimName) <= 0.0000000)
	{
		super(UTWeapon).TimeWeaponPutDown();
	}
	//return;	
}

simulated function PlayTargetSoundLoop()
{
	// End:0x28
	if(PlayTargetEvent != none)
	{
		PlayAkEvent(PlayTargetEvent);
	}
	//return;	
}

simulated function StopTargetSoundLoop()
{
	// End:0x28
	if(StopTargetEvent != none)
	{
		PlayAkEvent(StopTargetEvent);
	}
	//return;	
}

simulated function PlayBuildSoundLoop()
{
	// End:0x28
	if(PlayBuildEvent != none)
	{
		PlayAkEvent(PlayBuildEvent);
	}
	//return;	
}

simulated function StopBuildSoundLoop()
{
	// End:0x28
	if(StopBuildEvent != none)
	{
		PlayAkEvent(StopBuildEvent);
	}
	//return;	
}

simulated state WeaponBeamFiring
{
	function SetFlashLocation(Vector HitLocation)
	{
		global.SetFlashLocation(HitLocation);
		SetCurrentFireMode(CurrentFireMode);
		//return;		
	}

	simulated function Tick(float DeltaTime)
	{
		UpdateBeam(DeltaTime);
		UpdateDeploymentTrigger(DeltaTime);
		//return;		
	}

	simulated function bool CanViewAccelerationWhenFiring()
	{
		return true;
		//return ReturnValue;		
	}
Begin:

	UpdateDeployablePreviewMesh();
	stop;		
}

simulated state WeaponEquipping
{
	simulated function BeginState(name PreviousStateName)
	{
		CurrentAimPointOKToDeploy = false;
		CurrentDeployCountdown = -1.0000000;
		PlayTargetSoundLoop();
		super.BeginState(PreviousStateName);
		//return;		
	}
	stop;	
}

simulated state WeaponPuttingDown
{
	simulated function BeginState(name PreviousStateName)
	{
		CurrentTDCategory = 0;
		CurrentTDItemIdx = 0;
		CurrentAimPointOKToDeploy = false;
		CurrentDeployCountdown = -1.0000000;
		ActionedLockedTarget = none;
		StopTargetSoundLoop();
		StopBuildSoundLoop();
		super.BeginState(PreviousStateName);
		//return;		
	}
	stop;	
}

defaultproperties
{
	DeployableTurretsArray[0]=(Name="Heavy Machine Gun",BlokCost=60,Unlocked=true,IconPkgPath="MainHUD.TDItem_Turret_MachineGun",PreviewMesh=StaticMesh'MG_Turret_Lvl01.Turret_01_proxy',RequiresPegs=true,PegsX=4,PegsY=6,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=40.0000000,MagicMomentEventName="TurretMagicMoment",DeployArchetypeRef=none,DeployClassName="MegaHaloGameContent.HaloTurret_MachineGun_Content",DeployClassRef=none)
	DeployableTurretsArray[1]=(Name="Mortar",BlokCost=75,Unlocked=true,IconPkgPath="MainHUD.TDItem_Turret_Grenade",PreviewMesh=StaticMesh'MG_Turret.MG_Turret_Static',RequiresPegs=true,PegsX=4,PegsY=6,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=40.0000000,MagicMomentEventName="TurretMagicMoment",DeployArchetypeRef=none,DeployClassName="MegaHaloGameContent.HaloTurret_Mortar_Content",DeployClassRef=none)
	DeployableTurretsArray[2]=(Name="Grenade Launcher",BlokCost=150,Unlocked=false,IconPkgPath="MainHUD.TDItem_Turret_Grenade",PreviewMesh=none,RequiresPegs=true,PegsX=4,PegsY=4,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=2.0000000,MagicMomentEventName="None",DeployArchetypeRef=none,DeployClassName="",DeployClassRef=none)
	DeployableTurretsArray[3]=(Name="Missile Pod",BlokCost=300,Unlocked=false,IconPkgPath="MainHUD.TDItem_Turret_Rocket",PreviewMesh=none,RequiresPegs=true,PegsX=4,PegsY=4,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=2.0000000,MagicMomentEventName="None",DeployArchetypeRef=none,DeployClassName="",DeployClassRef=none)
	DeployableTurretsArray[4]=(Name="Gauss Cannon",BlokCost=350,Unlocked=false,IconPkgPath="MainHUD.TDItem_Turret_GaussCannon",PreviewMesh=none,RequiresPegs=true,PegsX=4,PegsY=4,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=2.0000000,MagicMomentEventName="None",DeployArchetypeRef=none,DeployClassName="",DeployClassRef=none)
	DeployableVehiclesArray[0]=(Name="Warthog",BlokCost=200,Unlocked=true,IconPkgPath="MainHUD.TDItem_Vehicle_Warthog",PreviewMesh=StaticMesh'Warthog.Warthog_Hologram',RequiresPegs=true,PegsX=10,PegsY=10,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=250.0000000,MagicMomentEventName="WarthogMagicMoment",DeployArchetypeRef=none,DeployClassName="MegaHaloGameContent.HaloVehicle_ArcadeWartHog_Content",DeployClassRef=none)
	DeployableVehiclesArray[1]=(Name="Mongoose",BlokCost=150,Unlocked=true,IconPkgPath="MainHUD.TDItem_Vehicle_Mongoose",PreviewMesh=StaticMesh'Mongoose.Mongoose_Hologram',RequiresPegs=true,PegsX=8,PegsY=8,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=60.0000000,MagicMomentEventName="None",DeployArchetypeRef=none,DeployClassName="MegaHaloGameContent.HaloVehicle_ArcadeMongoose_Content",DeployClassRef=none)
	DeployableVehiclesArray[2]=(Name="Scorpion",BlokCost=375,Unlocked=true,IconPkgPath="MainHUD.TDItem_Vehicle_Scorpion",PreviewMesh=StaticMesh'Scorpion.Scorpion_Hologram',RequiresPegs=true,PegsX=16,PegsY=16,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=150.0000000,MagicMomentEventName="ScorpionMagicMoment",DeployArchetypeRef=none,DeployClassName="MegaHaloGameContent.HaloVehicle_ArcadeScorpion_Content",DeployClassRef=none)
	DeployableVehiclesArray[3]=(Name="Cobra",BlokCost=425,Unlocked=false,IconPkgPath="MainHUD.TDItem_Vehicle_Mantis",PreviewMesh=none,RequiresPegs=false,PegsX=2,PegsY=2,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=250.0000000,MagicMomentEventName="None",DeployArchetypeRef=none,DeployClassName="",DeployClassRef=none)
	DeployableVehiclesArray[4]=(Name="Cyclops",BlokCost=500,Unlocked=false,IconPkgPath="MainHUD.TDItem_Vehicle_Mantis",PreviewMesh=none,RequiresPegs=false,PegsX=2,PegsY=2,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=250.0000000,MagicMomentEventName="None",DeployArchetypeRef=none,DeployClassName="",DeployClassRef=none)
	DeployableWallsArray[0]=(Name="Wall",BlokCost=20,Unlocked=true,IconPkgPath="MainHUD.TDItem_Support_Wall",PreviewMesh=StaticMesh'UNSC_BlockWall_01.Mesh.UNSC_BlockWall_01_proxy',RequiresPegs=true,PegsX=4,PegsY=12,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=1.0000000,MagicMomentEventName="BlokWallMagicMoment",DeployArchetypeRef=none,DeployClassName="MegaHaloGame.HaloDeployableWall",DeployClassRef=none)
	DeployableGroundTrapsArray[0]=(Name="Mine Trap",BlokCost=30,Unlocked=true,IconPkgPath="MainHUD.TDItem_Support_LandMine",PreviewMesh=StaticMesh'Damage_Test_Objects.Mesh.SM_FloorTrap_Hologram',RequiresPegs=true,PegsX=4,PegsY=4,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=15.0000000,MagicMomentEventName="None",DeployArchetypeRef=HaloTrap_Ground_Mine'HaloTraps_Ground_Mine.HaloTraps_Ground_Mine_Archetype',DeployClassName="",DeployClassRef=none)
	DeployableGroundTrapsArray[1]=(Name="Slowdown Trap",BlokCost=30,Unlocked=true,IconPkgPath="MainHUD.TDItem_Support_LandMine",PreviewMesh=StaticMesh'Damage_Test_Objects.Mesh.SM_FloorTrap_Hologram',RequiresPegs=true,PegsX=4,PegsY=4,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=15.0000000,MagicMomentEventName="None",DeployArchetypeRef=HaloTrap_Ground_Slow'HaloTraps_Ground_Slow.HaloTraps_Ground_Slow_Archetype',DeployClassName="",DeployClassRef=none)
	DeployableWallTrapsArray[0]=(Name="Needler Projectile Trap",BlokCost=50,Unlocked=true,IconPkgPath="MainHUD.TDItem_Support_LandMine",PreviewMesh=StaticMesh'Damage_Test_Objects.Mesh.SM_FloorTrap_Hologram',RequiresPegs=true,PegsX=4,PegsY=4,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=15.0000000,MagicMomentEventName="None",DeployArchetypeRef=HaloTrap_Wall_Projectile'HaloTraps_Wall_Projectile.HaloTraps_Wall_Projectile_Archetype',DeployClassName="",DeployClassRef=none)
	DeployableWallTrapsArray[1]=(Name="Carbine Projectile Trap",BlokCost=50,Unlocked=true,IconPkgPath="MainHUD.TDItem_Support_LandMine",PreviewMesh=StaticMesh'Damage_Test_Objects.Mesh.SM_FloorTrap_Hologram',RequiresPegs=true,PegsX=4,PegsY=4,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=15.0000000,MagicMomentEventName="None",DeployArchetypeRef=HaloTrap_Wall_Projectile'HaloTraps_Wall_Projectile.HaloTraps_Wall_Projectile_Archetype2',DeployClassName="",DeployClassRef=none)
	DeployableWallTrapsArray[2]=(Name="Hammer Trap",BlokCost=50,Unlocked=true,IconPkgPath="MainHUD.TDItem_Support_LandMine",PreviewMesh=StaticMesh'Damage_Test_Objects.Mesh.SM_FloorTrap_Hologram',RequiresPegs=true,PegsX=4,PegsY=4,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=15.0000000,MagicMomentEventName="None",DeployArchetypeRef=HaloTrap_Wall_Hammer'HaloTraps_Wall_Hammer.HaloTraps_Wall_Hammer_Archetype',DeployClassName="",DeployClassRef=none)
	DeployableFreeObjectsArray[0]=(Name="Soldier",BlokCost=100,Unlocked=true,IconPkgPath="MainHUD.TDItem_Character_Spartan_Green",PreviewMesh=StaticMesh'ONI_Teleporter.Mesh.ONI_teleporter_proxy',RequiresPegs=true,PegsX=2,PegsY=2,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=1.0000000,MagicMomentEventName="CharacterTeleporterMagicMoment",DeployArchetypeRef=HaloPersonnelPod'PlayerClasses.HaloPersonnelPod_Soldier',DeployClassName="",DeployClassRef=none)
	DeployableFreeObjectsArray[1]=(Name="Scout",BlokCost=100,Unlocked=true,IconPkgPath="MainHUD.TDItem_Character_Spartan_Red",PreviewMesh=StaticMesh'ONI_Teleporter.Mesh.ONI_teleporter_proxy',RequiresPegs=true,PegsX=2,PegsY=2,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=1.0000000,MagicMomentEventName="CharacterTeleporterMagicMoment",DeployArchetypeRef=HaloPersonnelPod'PlayerClasses.HaloPersonnelPod_Scout',DeployClassName="",DeployClassRef=none)
	DeployableFreeObjectsArray[2]=(Name="Engineer",BlokCost=100,Unlocked=true,IconPkgPath="MainHUD.TDItem_Character_Spartan_Black",PreviewMesh=StaticMesh'ONI_Teleporter.Mesh.ONI_teleporter_proxy',RequiresPegs=true,PegsX=2,PegsY=2,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=1.0000000,MagicMomentEventName="CharacterTeleporterMagicMoment",DeployArchetypeRef=HaloPersonnelPod'PlayerClasses.HaloPersonnelPod_Engineer',DeployClassName="",DeployClassRef=none)
	SoftLockMaxAngleDegrees=20.0000000
	SoftLockMaxHorizAngleDegrees=20.0000000
	SoftLockMinDistanceSq=30000.0000000
	SoftLockHorzAngleWeight=0.5500000
	SoftLockVertAngleWeight=0.0500000
	SoftLockDistanceWeight=0.4000000
	GoodPlacementColor=(R=1.0000000,G=0.4800000,B=1.0000000,A=0.0650000)
	BadPlacementColor=(R=1.0000000,G=0.1500000,B=0.1000000,A=1.0000000)
	CurrentDeployItemInfo=(Name="None",BlokCost=1,Unlocked=true,IconPkgPath="",PreviewMesh=none,RequiresPegs=false,PegsX=2,PegsY=2,AlignWithWorldAxes=false,AlignWithFloor=false,UpOffset=1.0000000,MagicMomentEventName="None",DeployArchetypeRef=none,DeployClassName="",DeployClassRef=none)
	SecsRequiredToDeploy=1.0000000
	CurrentDeployCountdown=-1.0000000
	PlayTargetEvent=AkEvent'UIHUD.Play_UI_HUD_TargetDesignator_ON'
	StopTargetEvent=AkEvent'UIHUD.Play_UI_HUD_TargetDesignator_OFF'
	PlayBuildEvent=AkEvent'UIHUD.Play_UI_HUD_BuildBar_Loop'
	StopBuildEvent=AkEvent'UIHUD.Stop_UI_HUD_BuildBar_Loop'
	BeamTemplate[1]=ParticleSystem'FX_TargetDesignate.Effects.P_FX_TargetDesignate'
	BeamSockets[1]="MuzzleFlashSocket02"
	EndPointParamName="LinkBeamEnd"
	BeamPreFireAnim[1]="WeaponAltFireStart"
	BeamFireAnim[1]="WeaponAltFire"
	BeamPostFireAnim[1]="WeaponAltFireEnd"
	bUsePlayerControllerCameraPoint=true
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_TargetDesignator.BeamForceFeedbackWaveform1'
	begin object name="BeamForceFeedbackWaveform1" class=Engine.ForceFeedbackWaveform
		bIsLooping=true
		Samples[0]=(LeftAmplitude=20,RightAmplitude=10,LeftFunction=EWaveformFunction.WF_Constant,RightFunction=EWaveformFunction.WF_Constant,Duration=0.1000000)
	end object
	BeamWeaponFireWaveForm=BeamForceFeedbackWaveform1
	bShouldDrawCrosshairDropShadow=false
	LockerAmmoCount=1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_TargetDesignator.ForceFeedbackWaveformShooting1'
	// Archetype: ForceFeedbackWaveform'UTGame.Default__UTBeamWeapon.ForceFeedbackWaveformShooting1'
	begin object name="ForceFeedbackWaveformShooting1"
	end object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	IconX=412
	IconY=82
	iconWidth=40
	iconHeight=36
	IconCoordinates=(U=453.0000000,V=467.0000000,UL=147.0000000,VL=41.0000000)
	CrossHairCoordinates=(U=256.0000000,V=0.0000000)
	CrosshairImage=Texture2D'mainhud.Crosshairs'
	HUDFrameName="targetDesignator"
	InventoryGroup=3
	AttachmentClass=Class'MegaHaloGame.HaloWeaponAttachment_TargetDesignator'
	WeaponColor=(R=0,G=0,B=255,A=255)
	PlayerViewOffset=(X=-18.0000000,Y=-18.0000000,Z=16.0000000)
	LockerRotation=(Pitch=-16384,Yaw=0,Roll=0)
	AmmoCount=1
	FiringStatesArray[0]="WeaponBeamFiring"
	FiringStatesArray[1]="WeaponFiring"
	WeaponFireTypes[0]=0
	WeaponFireTypes[1]=0
	FireInterval[0]=0.2400000
	FireInterval[1]=0.3500000
	WeaponRange=2000.0000000
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_TargetDesignator.FirstPersonMesh'
	// Archetype: UDKSkeletalMeshComponent'UTGame.Default__UTBeamWeapon.FirstPersonMesh'
	begin object name="FirstPersonMesh"
		ReplacementPrimitive=none
	end object
	Mesh=FirstPersonMesh
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_TargetDesignator.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	// Archetype: SkeletalMeshComponent'UTGame.Default__UTBeamWeapon.PickupMesh'
	begin object name="PickupMesh"
		ReplacementPrimitive=none
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
}