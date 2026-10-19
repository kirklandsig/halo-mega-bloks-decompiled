class CoverLink extends NavigationPoint
	native
	config(Game)
	placeable;

const COVERLINK_ExposureDot = 0.4f;
const COVERLINK_EdgeCheckDot = 0.25f;
const COVERLINK_EdgeExposureDot = 0.85f;
const COVERLINK_DangerDist = 1536.f;

enum ECoverAction
{
	CA_Default,                     // 0
	CA_BlindLeft,                   // 1
	CA_BlindRight,                  // 2
	CA_LeanLeft,                    // 3
	CA_LeanRight,                   // 4
	CA_PopUp,                       // 5
	CA_BlindUp,                     // 6
	CA_PeekLeft,                    // 7
	CA_PeekRight,                   // 8
	CA_PeekUp,                      // 9
	CA_MAX                          // 10
};

enum ECoverDirection
{
	CD_Default,                     // 0
	CD_Left,                        // 1
	CD_Right,                       // 2
	CD_Up,                          // 3
	CD_MAX                          // 4
};

enum ECoverType
{
	CT_None,                        // 0
	CT_Standing,                    // 1
	CT_MidLevel,                    // 2
	CT_MAX                          // 3
};

enum ECoverLocationDescription
{
	CoverDesc_None,                 // 0
	CoverDesc_InWindow,             // 1
	CoverDesc_InDoorway,            // 2
	CoverDesc_BehindCar,            // 3
	CoverDesc_BehindTruck,          // 4
	CoverDesc_OnTruck,              // 5
	CoverDesc_BehindBarrier,        // 6
	CoverDesc_BehindColumn,         // 7
	CoverDesc_BehindCrate,          // 8
	CoverDesc_BehindWall,           // 9
	CoverDesc_BehindStatue,         // 10
	CoverDesc_BehindSandbags,       // 11
	CoverDesc_MAX                   // 12
};

enum EFireLinkID
{
	FLI_FireLink,                   // 0
	FLI_RejectedFireLink,           // 1
	FLI_MAX                         // 2
};

struct native atomicwhencooked immutablewhencooked CoverReference extends ActorReference
{
	var int SlotIdx;
};

struct native atomicwhencooked immutablewhencooked CoverInfo
{
	var editconst CoverLink Link;
	var editconst int SlotIdx;

	structdefaultproperties
	{
		Link=none
		SlotIdx=0
	}
};

struct native atomicwhencooked immutablewhencooked CovPosInfo
{
	var CoverLink Link;
	var int LtSlotIdx;
	var int RtSlotIdx;
	var float LtToRtPct;
	var Vector Location;
	var Vector Normal;
	var Vector Tangent;

	structdefaultproperties
	{
		Link=none
		LtSlotIdx=-1
		RtSlotIdx=-1
		LtToRtPct=0.0000000
		Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		Normal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		Tangent=(X=0.0000000,Y=0.0000000,Z=0.0000000)
	}
};

struct native atomicwhencooked immutablewhencooked FireLinkItem
{
	var CoverLink.ECoverType SrcType;
	var CoverLink.ECoverAction SrcAction;
	var CoverLink.ECoverType DestType;
	var CoverLink.ECoverAction DestAction;

	structdefaultproperties
	{
		SrcType=ECoverType.CT_None
		SrcAction=ECoverAction.CA_Default
		DestType=ECoverType.CT_None
		DestAction=ECoverAction.CA_Default
	}
};

struct native atomicwhencooked immutablewhencooked FireLink
{
	var array<byte> Interactions;
	var private const int PackedProperties_CoverPairRefAndDynamicInfo;
	var private bool bFallbackLink;
	var private bool bDynamicIndexInited;

	structdefaultproperties
	{
		Interactions=none
		PackedProperties_CoverPairRefAndDynamicInfo=0
		bFallbackLink=false
		bDynamicIndexInited=false
	}
};

struct native atomicwhencooked immutablewhencooked DynamicLinkInfo
{
	var Vector LastTargetLocation;
	var Vector LastSrcLocation;

	structdefaultproperties
	{
		LastTargetLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		LastSrcLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
	}
};

struct native atomicwhencooked immutablewhencooked ExposedLink
{
	var const editconst CoverReference TargetActor;
	var byte ExposedScale;

	structdefaultproperties
	{
		TargetActor=/* ERROR: System.ArgumentException */
		ExposedScale=0
	}
};

struct native atomicwhencooked immutablewhencooked SlotMoveRef
{
	var PolyReference Poly;
	var BasedPosition Dest;
	var int Direction;

	structdefaultproperties
	{
		Poly=/* ERROR: System.ArgumentException */
		Dest=(Base=none,Position=(X=0.0000000,Y=0.0000000,Z=0.0000000),CachedBaseLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),CachedBaseRotation=(Pitch=0,Yaw=0,Roll=0),CachedTransPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000))
		Direction=0
	}
};

struct native atomicwhencooked immutablewhencooked CoverSlot
{
	var Pawn SlotOwner;
	var Pawn SlotOccupier;
	var transient float SlotValidAfterTime;
	var CoverLink.ECoverType ForceCoverType;
	var editconst CoverLink.ECoverType CoverType;
	var CoverLink.ECoverLocationDescription LocationDescription;
	var Vector LocationOffset;
	var Rotator RotationOffset;
	var array<CoverLink.ECoverAction> Actions;
	var editconst array<editconst FireLink> FireLinks;
	var editconst transient array<editconst FireLink> RejectedFireLinks;
	var private array<int> ExposedCoverPackedProperties;
	var private int TurnTargetPackedProperties;
	var array<SlotMoveRef> SlipRefs;
	var editconst array<editconst CoverInfo> OverlapClaimsList;
	var bool bLeanLeft;
	var bool bLeanRight;
	var bool bForceCanPopUp;
	var editconst bool bCanPopUp;
	var editconst bool bCanMantle;
	var editconst bool bCanClimbUp;
	var bool bForceCanCoverSlip_Left;
	var bool bForceCanCoverSlip_Right;
	var editconst bool bCanCoverSlip_Left;
	var editconst bool bCanCoverSlip_Right;
	var editconst bool bCanSwatTurn_Left;
	var editconst bool bCanSwatTurn_Right;
	var bool bEnabled;
	var bool bAllowPopup;
	var bool bAllowMantle;
	var bool bAllowCoverSlip;
	var bool bAllowClimbUp;
	var bool bAllowSwatTurn;
	var bool bForceNoGroundAdjust;
	var bool bPlayerOnly;
	var bool bPreferLeanOverPopup;
	var transient bool bDestructible;
	var transient bool bSelected;
	var editconst transient bool bFailedToFindSurface;

	structdefaultproperties
	{
		SlotOwner=none
		SlotOccupier=none
		SlotValidAfterTime=0.0000000
		ForceCoverType=ECoverType.CT_None
		CoverType=ECoverType.CT_None
		LocationDescription=ECoverLocationDescription.CoverDesc_None
		LocationOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
		RotationOffset=(Pitch=0,Yaw=0,Roll=0)
		Actions=none
		FireLinks=none
		RejectedFireLinks=none
		ExposedCoverPackedProperties=none
		TurnTargetPackedProperties=-1
		SlipRefs=none
		OverlapClaimsList=none
		bLeanLeft=false
		bLeanRight=false
		bForceCanPopUp=false
		bCanPopUp=false
		bCanMantle=true
		bCanClimbUp=false
		bForceCanCoverSlip_Left=false
		bForceCanCoverSlip_Right=false
		bCanCoverSlip_Left=true
		bCanCoverSlip_Right=true
		bCanSwatTurn_Left=true
		bCanSwatTurn_Right=true
		bEnabled=true
		bAllowPopup=true
		bAllowMantle=true
		bAllowCoverSlip=true
		bAllowClimbUp=false
		bAllowSwatTurn=true
		bForceNoGroundAdjust=false
		bPlayerOnly=false
		bPreferLeanOverPopup=false
		bDestructible=false
		bSelected=false
		bFailedToFindSurface=false
	}
};

var globalconfig bool GLOBAL_bUseSlotMarkers;
var bool bDisabled;
var bool bClaimAllSlots;
var bool bAutoSort;
var bool bAutoAdjust;
var bool bCircular;
var bool bLooped;
var bool bPlayerOnly;
var bool bDynamicCover;
var bool bFractureOnTouch;
var bool bDebug_FireLinks;
var bool bDebug_ExposedLinks;
var bool bDebug_CoverGen;
var bool bDoAutoSlotDensityFixup;
var const Actor DestructibleCoverActor;
var CoverLink NextDestructibleCoverLink;
var float LeanTraceDist;
var editinline array<editinline CoverSlot> Slots;
var array<DynamicLinkInfo> DynamicLinkInfos;
var array<Pawn> Claims;
var float InvalidateDistance;
var float MaxFireLinkDist;
var const Vector CircularOrigin;
var const float CircularRadius;
var const float AlignDist;
var const float AutoCoverSlotInterval;
var const float StandHeight;
var const float MidHeight;
var const Vector StandingLeanOffset;
var const Vector CrouchLeanOffset;
var const Vector PopupOffset;
var const float SlipDist;
var const float TurnDist;
var float DangerScale;
var const CoverLink NextCoverLink;
var const CoverLink.ECoverLocationDescription LocationDescription;

// Export UCoverLink::execGetFireLinkTargetCoverInfo(FFrame&, void* const)
native simulated function bool GetFireLinkTargetCoverInfo(int SlotIdx, int FireLinkIdx, out CoverInfo out_Info, optional CoverLink.EFireLinkID ArrayID);

// Export UCoverLink::execPackFireLinkInteractionInfo(FFrame&, void* const)
native static simulated function byte PackFireLinkInteractionInfo(CoverLink.ECoverType SrcType, CoverLink.ECoverAction SrcAction, CoverLink.ECoverType DestType, CoverLink.ECoverAction DestAction);

// Export UCoverLink::execUnPackFireLinkInteractionInfo(FFrame&, void* const)
native static simulated function UnPackFireLinkInteractionInfo(const byte PackedByte, out CoverLink.ECoverType SrcType, out CoverLink.ECoverAction SrcAction, out CoverLink.ECoverType DestType, out CoverLink.ECoverAction DestAction);

// Export UCoverLink::execGetSlotLocation(FFrame&, void* const)
native final simulated function Vector GetSlotLocation(int SlotIdx, optional bool bForceUseOffset);

// Export UCoverLink::execGetSlotRotation(FFrame&, void* const)
native final simulated function Rotator GetSlotRotation(int SlotIdx, optional bool bForceUseOffset);

// Export UCoverLink::execGetSlotViewPoint(FFrame&, void* const)
native final simulated function Vector GetSlotViewPoint(int SlotIdx, optional CoverLink.ECoverType Type, optional CoverLink.ECoverAction Action);

// Export UCoverLink::execIsExposedTo(FFrame&, void* const)
native final simulated function bool IsExposedTo(int SlotIdx, CoverInfo ChkSlot, out float out_ExposedScale);

final simulated event SetInvalidUntil(int SlotIdx, float TimeToBecomeValid)
{
	Slots[SlotIdx].SlotValidAfterTime = TimeToBecomeValid;
	NotifySlotOwnerCoverDisabled(SlotIdx);
	//return;	
}

final simulated event bool Claim(Pawn NewClaim, int SlotIdx)
{
	local int Idx;
	local bool bResult, bDoClaim;
	local PlayerController PC;
	local Pawn PreviousOwner;
	local int NumClaims;
	local array<int> SlotList;
	local string Str;

	// End:0x5A
	if(bDebug)
	{
		LogInternal((((((string(self) @ "Claim Slot") @ string(SlotIdx)) @ "For") @ string(NewClaim)) @ "(All?)") @ string(bClaimAllSlots));
	}
	// End:0x6B
	if(SlotIdx < 0)
	{
		return false;
	}
	bDoClaim = true;
	// End:0x176
	if(Slots[SlotIdx].SlotOwner != none)
	{
		bResult = Slots[SlotIdx].SlotOwner == NewClaim;
		bDoClaim = false;
		// End:0x176
		if(!bResult)
		{
			PC = PlayerController(NewClaim.Controller);
			// End:0x176
			if(PC != none)
			{
				PreviousOwner = Slots[SlotIdx].SlotOwner;
				bDoClaim = true;
			}
		}
	}
	// End:0x335
	if(bDoClaim)
	{
		// End:0x24A
		if(bClaimAllSlots)
		{
			Idx = 0;
			J0x19B:

			// End:0x247 [Loop If]
			if(Idx < Slots.Length)
			{
				// End:0x239
				if(Slots[Idx].SlotOwner == none)
				{
					Claims[Claims.Length] = NewClaim;
					Slots[Idx].SlotOwner = NewClaim;
					bResult = true;
				}
				Idx++;
				// [Loop Continue]
				goto J0x19B;
			}			
		}
		else
		{
			Claims[Claims.Length] = NewClaim;
			Slots[SlotIdx].SlotOwner = NewClaim;
			bResult = true;
		}
		// End:0x335
		if((PreviousOwner != none) && PreviousOwner.Controller != none)
		{
			PreviousOwner.Controller.NotifyCoverClaimViolation(NewClaim.Controller, self, SlotIdx);
		}
	}
	// End:0x4EE
	if(bDebug)
	{
		Idx = 0;
		J0x34D:

		// End:0x39F [Loop If]
		if(Idx < Claims.Length)
		{
			// End:0x391
			if(Claims[Idx] == NewClaim)
			{
				NumClaims++;
			}
			Idx++;
			// [Loop Continue]
			goto J0x34D;
		}
		Idx = 0;
		J0x3AA:

		// End:0x422 [Loop If]
		if(Idx < Slots.Length)
		{
			// End:0x414
			if(Slots[Idx].SlotOwner == NewClaim)
			{
				SlotList[SlotList.Length] = Idx;
			}
			Idx++;
			// [Loop Continue]
			goto J0x3AA;
		}
		// End:0x445
		if(SlotList.Length == 0)
		{
			Str = "None";			
		}
		else
		{
			Idx = 0;
			J0x450:

			// End:0x4A0 [Loop If]
			if(Idx < SlotList.Length)
			{
				Str = Str @ string(SlotList[Idx]);
				Idx++;
				// [Loop Continue]
				goto J0x450;
			}
		}
		LogInternal(((((string(self) @ "Claims from") @ string(NewClaim)) @ string(NumClaims)) @ "Slots:") @ Str);
		ScriptTrace();
	}
	return bResult;
	//return ReturnValue;	
}

final simulated event bool UnClaim(Pawn OldClaim, int SlotIdx, bool bUnclaimAll)
{
	local int Idx, NumReleased;
	local bool bResult;
	local int NumClaims;
	local array<int> SlotList;
	local string Str;

	// End:0xA8
	if(bDebug)
	{
		LogInternal(((((((((((((string(self) @ "UnClaim") @ "OldClaim:'") $ string(OldClaim)) $ "'") @ "SlotIdx:'") $ string(SlotIdx)) $ "'") @ "bUnclaimAll:'") $ string(bUnclaimAll)) $ "'") @ "bClaimAllSlots:'") $ string(bClaimAllSlots)) $ "'");
	}
	// End:0xCA
	if(!bUnclaimAll && SlotIdx < 0)
	{
		return false;
	}
	// End:0x17E
	if(bUnclaimAll)
	{
		Idx = 0;
		J0xE2:

		// End:0x17B [Loop If]
		if(Idx < Slots.Length)
		{
			// End:0x16D
			if(Slots[Idx].SlotOwner == OldClaim)
			{
				Slots[Idx].SlotOwner = none;
				NumReleased++;
				bResult = true;
			}
			Idx++;
			// [Loop Continue]
			goto J0xE2;
		}		
	}
	else
	{
		// End:0x202
		if(!bClaimAllSlots && Slots[SlotIdx].SlotOwner == OldClaim)
		{
			Slots[SlotIdx].SlotOwner = none;
			NumReleased++;
			bResult = true;
		}
	}
	J0x202:

	// End:0x266 [Loop If]
	if(NumReleased > 0)
	{
		Idx = Claims.Find(OldClaim);
		// End:0x243
		if(Idx < 0)
		{
			// [Explicit Break]
			goto J0x266;
		}
		Claims.Remove(Idx, 1);
		NumReleased--;
		// [Loop Continue]
		goto J0x202;
	}
	J0x266:

	// End:0x446
	if(bDebug)
	{
		Idx = 0;
		J0x27E:

		// End:0x2D0 [Loop If]
		if(Idx < Claims.Length)
		{
			// End:0x2C2
			if(Claims[Idx] == OldClaim)
			{
				NumClaims++;
			}
			Idx++;
			// [Loop Continue]
			goto J0x27E;
		}
		Idx = 0;
		J0x2DB:

		// End:0x353 [Loop If]
		if(Idx < Slots.Length)
		{
			// End:0x345
			if(Slots[Idx].SlotOwner == OldClaim)
			{
				SlotList[SlotList.Length] = Idx;
			}
			Idx++;
			// [Loop Continue]
			goto J0x2DB;
		}
		// End:0x376
		if(SlotList.Length == 0)
		{
			Str = "None";			
		}
		else
		{
			Idx = 0;
			J0x381:

			// End:0x3D1 [Loop If]
			if(Idx < SlotList.Length)
			{
				Str = Str @ string(SlotList[Idx]);
				Idx++;
				// [Loop Continue]
				goto J0x381;
			}
		}
		LogInternal(((((((((string(self) @ "Claims from") @ "OldClaim:'") $ string(OldClaim)) $ "'") @ "NumClaims:'") $ string(NumClaims)) $ "'") @ "Slots:") @ Str);
		ScriptTrace();
	}
	return bResult;
	//return ReturnValue;	
}

// Export UCoverLink::execIsValidClaim(FFrame&, void* const)
native final function bool IsValidClaim(Pawn ChkClaim, int SlotIdx, optional bool bSkipTeamCheck, optional bool bSkipOverlapCheck);

// Export UCoverLink::execIsValidClaimBetween(FFrame&, void* const)
native final function bool IsValidClaimBetween(Pawn ChkClaim, int StartSlotIdx, int EndSlotIdx, optional bool bSkipTeamCheck, optional bool bSkipOverlapCheck);

final simulated function bool IsStationarySlot(int SlotIdx)
{
	return !bCircular && IsEdgeSlot(SlotIdx, false);
	//return ReturnValue;	
}

// Export UCoverLink::execFindSlots(FFrame&, void* const)
native final simulated function bool FindSlots(Vector CheckLocation, float MaxDistance, out int LeftSlotIdx, out int RightSlotIdx);

// Export UCoverLink::execIsEdgeSlot(FFrame&, void* const)
native final simulated function bool IsEdgeSlot(int SlotIdx, optional bool bIgnoreLeans);

// Export UCoverLink::execIsLeftEdgeSlot(FFrame&, void* const)
native final simulated function bool IsLeftEdgeSlot(int SlotIdx, bool bIgnoreLeans);

// Export UCoverLink::execIsRightEdgeSlot(FFrame&, void* const)
native final simulated function bool IsRightEdgeSlot(int SlotIdx, bool bIgnoreLeans);

// Export UCoverLink::execGetSlotIdxToLeft(FFrame&, void* const)
native final simulated function int GetSlotIdxToLeft(int SlotIdx, optional int Cnt = 1);

// Export UCoverLink::execGetSlotIdxToRight(FFrame&, void* const)
native final simulated function int GetSlotIdxToRight(int SlotIdx, optional int Cnt = 1);

final simulated function bool AllowRightTransition(int SlotIdx)
{
	local int NextSlotIdx;

	NextSlotIdx = GetSlotIdxToRight(SlotIdx);
	// End:0x55
	if(NextSlotIdx >= 0)
	{
		return Slots[NextSlotIdx].bEnabled;
	}
	return false;
	//return ReturnValue;	
}

final simulated function bool AllowLeftTransition(int SlotIdx)
{
	local int NextSlotIdx;

	NextSlotIdx = GetSlotIdxToLeft(SlotIdx);
	// End:0x55
	if(NextSlotIdx >= 0)
	{
		return Slots[NextSlotIdx].bEnabled;
	}
	return false;
	//return ReturnValue;	
}

// Export UCoverLink::execGetFireLinkTo(FFrame&, void* const)
native function bool GetFireLinkTo(int SlotIdx, CoverInfo ChkCover, CoverLink.ECoverAction ChkAction, CoverLink.ECoverType ChkType, out int out_FireLinkIdx, out array<int> out_Items);

// Export UCoverLink::execHasFireLinkTo(FFrame&, void* const)
native function bool HasFireLinkTo(int SlotIdx, CoverInfo ChkCover, optional bool bAllowFallbackLinks);

// Export UCoverLink::execGetSlotActions(FFrame&, void* const)
native final function GetSlotActions(int SlotIdx, out array<CoverLink.ECoverAction> Actions);

simulated event SetDisabled(bool bNewDisabled)
{
	local int SlotIdx;
	local CoverReplicator CoverReplicator;

	bDisabled = bNewDisabled;
	// End:0x67
	if(bDisabled)
	{
		SlotIdx = 0;
		J0x2D:

		// End:0x67 [Loop If]
		if(SlotIdx < Slots.Length)
		{
			NotifySlotOwnerCoverDisabled(SlotIdx);
			SlotIdx++;
			// [Loop Continue]
			goto J0x2D;
		}
	}
	// End:0xE8
	if(int(Role) == int(ROLE_Authority))
	{
		CoverReplicator = WorldInfo.Game.GetCoverReplicator();
		// End:0xE8
		if(CoverReplicator != none)
		{
			CoverReplicator.NotifyLinkDisabledStateChange(self);
		}
	}
	//return;	
}

simulated event SetSlotEnabled(int SlotIdx, bool bEnable)
{
	Slots[SlotIdx].bEnabled = bEnable;
	// End:0x55
	if(!bEnable)
	{
		NotifySlotOwnerCoverDisabled(SlotIdx);
	}
	//return;	
}

simulated function NotifySlotOwnerCoverDisabled(int SlotIdx, optional bool bAIOnly)
{
	local int LeftIdx, RightIdx;

	// End:0x129
	if(((Slots[SlotIdx].SlotOwner != none) && Slots[SlotIdx].SlotOwner.Controller != none) && !bAIOnly || PlayerController(Slots[SlotIdx].SlotOwner.Controller) == none)
	{
		Slots[SlotIdx].SlotOwner.Controller.NotifyCoverDisabled(self, SlotIdx, false);
	}
	LeftIdx = GetSlotIdxToLeft(SlotIdx);
	// End:0x280
	if((((LeftIdx >= 0) && Slots[LeftIdx].SlotOwner != none) && Slots[LeftIdx].SlotOwner.Controller != none) && !bAIOnly || PlayerController(Slots[LeftIdx].SlotOwner.Controller) == none)
	{
		Slots[LeftIdx].SlotOwner.Controller.NotifyCoverDisabled(self, SlotIdx, true);
	}
	RightIdx = GetSlotIdxToRight(SlotIdx);
	// End:0x3D7
	if((((RightIdx >= 0) && Slots[RightIdx].SlotOwner != none) && Slots[RightIdx].SlotOwner.Controller != none) && !bAIOnly || PlayerController(Slots[RightIdx].SlotOwner.Controller) == none)
	{
		Slots[RightIdx].SlotOwner.Controller.NotifyCoverDisabled(self, SlotIdx, true);
	}
	//return;	
}

simulated event SetSlotPlayerOnly(int SlotIdx, bool bInPlayerOnly)
{
	Slots[SlotIdx].bPlayerOnly = bInPlayerOnly;
	// End:0x70
	if(Slots[SlotIdx].bPlayerOnly)
	{
		NotifySlotOwnerCoverDisabled(SlotIdx, true);
	}
	//return;	
}

function OnModifyCover(SeqAct_ModifyCover Action)
{
	local array<int> SlotIndices;
	local int Idx, SlotIdx;
	local CoverReplicator CoverReplicator;

	// End:0x50
	if(Action.Slots.Length > 0)
	{
		SlotIndices = Action.Slots;		
	}
	else
	{
		Idx = 0;
		J0x5B:

		// End:0x9F [Loop If]
		if(Idx < Slots.Length)
		{
			SlotIndices[SlotIndices.Length] = Idx;
			Idx++;
			// [Loop Continue]
			goto J0x5B;
		}
	}
	Idx = 0;
	J0xAA:

	// End:0x473 [Loop If]
	if(Idx < SlotIndices.Length)
	{
		SlotIdx = SlotIndices[Idx];
		// End:0x465
		if((SlotIdx >= 0) && SlotIdx < Slots.Length)
		{
			// End:0x156
			if(Action.InputLinks[0].bHasImpulse)
			{
				SetSlotEnabled(SlotIdx, true);				
			}
			else
			{
				// End:0x1A4
				if(Action.InputLinks[1].bHasImpulse)
				{
					SetSlotEnabled(SlotIdx, false);					
				}
				else
				{
					// End:0x2B8
					if(Action.InputLinks[2].bHasImpulse)
					{
						// End:0x2B5
						if((AutoAdjustSlot(SlotIdx, false) && Slots[SlotIdx].SlotOwner != none) && Slots[SlotIdx].SlotOwner.Controller != none)
						{
							Slots[SlotIdx].SlotOwner.Controller.NotifyCoverAdjusted();
						}						
					}
					else
					{
						// End:0x465
						if(Action.InputLinks[3].bHasImpulse)
						{
							// End:0x41E
							if(int(Action.ManualCoverType) != int(0))
							{
								Slots[SlotIdx].CoverType = Action.ManualCoverType;
								// End:0x41E
								if((Slots[SlotIdx].SlotOwner != none) && Slots[SlotIdx].SlotOwner.Controller != none)
								{
									Slots[SlotIdx].SlotOwner.Controller.NotifyCoverAdjusted();
								}
							}
							Slots[SlotIdx].bPlayerOnly = Action.bManualAdjustPlayersOnly;
						}
					}
				}
			}
		}
		Idx++;
		// [Loop Continue]
		goto J0xAA;
	}
	CoverReplicator = WorldInfo.Game.GetCoverReplicator();
	// End:0x669
	if(CoverReplicator != none)
	{
		// End:0x523
		if(Action.InputLinks[0].bHasImpulse)
		{
			CoverReplicator.NotifyEnabledSlots(self, SlotIndices);			
		}
		else
		{
			// End:0x586
			if(Action.InputLinks[1].bHasImpulse)
			{
				CoverReplicator.NotifyDisabledSlots(self, SlotIndices);				
			}
			else
			{
				// End:0x5EA
				if(Action.InputLinks[2].bHasImpulse)
				{
					CoverReplicator.NotifyAutoAdjustSlots(self, SlotIndices);					
				}
				else
				{
					// End:0x669
					if(Action.InputLinks[3].bHasImpulse)
					{
						CoverReplicator.NotifySetManualCoverTypeForSlots(self, SlotIndices, Action.ManualCoverType);
					}
				}
			}
		}
	}
	//return;	
}

// Export UCoverLink::execAutoAdjustSlot(FFrame&, void* const)
native final function bool AutoAdjustSlot(int SlotIdx, bool bOnlyCheckLeans);

// Export UCoverLink::execIsEnabled(FFrame&, void* const)
native final function bool IsEnabled();

function OnToggle(SeqAct_Toggle inAction)
{
	local CoverReplicator CoverReplicator;
	local int SlotIdx;

	super.OnToggle(inAction);
	// End:0x59
	if(inAction.InputLinks[0].bHasImpulse)
	{
		bDisabled = false;		
	}
	else
	{
		// End:0x9F
		if(inAction.InputLinks[1].bHasImpulse)
		{
			bDisabled = true;			
		}
		else
		{
			bDisabled = !bDisabled;
		}
	}
	SlotIdx = 0;
	J0xC1:

	// End:0x106 [Loop If]
	if(SlotIdx < Slots.Length)
	{
		SetSlotEnabled(SlotIdx, !bDisabled);
		++SlotIdx;
		// [Loop Continue]
		goto J0xC1;
	}
	CoverReplicator = WorldInfo.Game.GetCoverReplicator();
	// End:0x173
	if(CoverReplicator != none)
	{
		CoverReplicator.NotifyLinkDisabledStateChange(self);
	}
	//return;	
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
	super.CreateCheckpointRecord(Record);
	Record.bDisabled = bDisabled;
	//return;	
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
	local CoverReplicator CoverReplicator;

	super.ApplyCheckpointRecord(Record);
	bDisabled = Record.bDisabled;
	CoverReplicator = WorldInfo.Game.GetCoverReplicator();
	// End:0xA8
	if(CoverReplicator != none)
	{
		CoverReplicator.NotifyLinkDisabledStateChange(self);
	}
	//return;	
}

simulated event ShutDown()
{
	RemoveFromNorman();
	super.ShutDown();
	bDisabled = true;
	//return;	
}

// Export UCoverLink::execGetSwatTurnTarget(FFrame&, void* const)
native simulated function bool GetSwatTurnTarget(int SlotIdx, int Direction, out CoverInfo out_Info);

simulated function BreakFracturedMeshes(Vector Origin, float Radius, float RBStrength, Class<DamageType> DamageType)
{
	local FracturedStaticMeshActor FracActor;
	local byte bWantPhysChunksAndParticles;

	// End:0x11
	if(!bFractureOnTouch)
	{
		return;
	}
	// End:0x11C
	foreach CollidingActors(Class'Engine.FracturedStaticMeshActor', FracActor, Radius, Origin, true)
	{
		// End:0x11B
		if((int(FracActor.Physics) == int(0)) && FracActor.IsFracturedByDamageType(DamageType))
		{
			// End:0x11B
			if(FracActor.FractureEffectIsRelevant(false, Instigator, bWantPhysChunksAndParticles))
			{
				FracActor.BreakOffPartsInRadius(Origin, Radius, RBStrength, ((int(bWantPhysChunksAndParticles) == int(1)) ? true : false));
			}
		}		
	}	
	//return;	
}

simulated event Tick(float DeltaTime)
{
	local int SlotIdx;
	local CoverSlot Slot;
	local Vector OwnerLoc;
	local byte R, G, B;

	// End:0x17F
	if(bDebug)
	{
		SlotIdx = 0;
		J0x18:

		// End:0x17F [Loop If]
		if(SlotIdx < Slots.Length)
		{
			Slot = Slots[SlotIdx];
			// End:0x171
			if(Slot.SlotOwner != none)
			{
				// End:0xF3
				if(Slot.SlotOwner != none)
				{
					OwnerLoc = Slot.SlotOwner.Location;
					R = 166;
					G = 236;
					B = 17;					
				}
				else
				{
					OwnerLoc = vect(0.0000000, 0.0000000, 0.0000000);
					R = 170;
					G = 0;
					B = 0;
				}
				DrawDebugLine(GetSlotLocation(SlotIdx), OwnerLoc, R, G, B);
			}
			SlotIdx++;
			// [Loop Continue]
			goto J0x18;
		}
	}
	//return;	
}

// Export UCoverLink::execAddCoverSlot(FFrame&, void* const)
native final function int AddCoverSlot(Vector SlotLocation, Rotator SlotRotation, optional int SlotIdx = -1, optional bool bForceSlotUpdate, optional Scout Scout);

final simulated event string GetDebugString(int SlotIdx)
{
	return (("L:" $ GetRightMost(string(self))) @ "S:") $ string(SlotIdx);
	//return ReturnValue;	
}

// Export UCoverLink::execGetLocationDescription(FFrame&, void* const)
native final simulated function CoverLink.ECoverLocationDescription GetLocationDescription(int SlotIdx);

simulated event string GetDebugAbbrev()
{
	return "CL";
	//return ReturnValue;	
}

// Export UCoverLink::execAddToNorman(FFrame&, void* const)
native final function AddToNorman();

// Export UCoverLink::execRemoveFromNorman(FFrame&, void* const)
native final function RemoveFromNorman();

event PreBeginPlay()
{
	super(Actor).PreBeginPlay();
	AddToNorman();
	//return;	
}

event Destroyed()
{
	RemoveFromNorman();
	super(Actor).Destroyed();
	//return;	
}

event Reset()
{
	RemoveFromNorman();
	super(Actor).Reset();
	//return;	
}

defaultproperties
{
	bAutoSort=true
	bAutoAdjust=true
	LeanTraceDist=64.0000000
	Slots[0]=()
	InvalidateDistance=64.0000000
	MaxFireLinkDist=2048.0000000
	AlignDist=100.0000000
	AutoCoverSlotInterval=175.0000000
	StandHeight=160.0000000
	MidHeight=70.0000000
	StandingLeanOffset=(X=69.0000000,Y=78.0000000,Z=0.0000000)
	CrouchLeanOffset=(X=19.0000000,Y=70.0000000,Z=0.0000000)
	PopupOffset=(X=70.0000000,Y=0.0000000,Z=0.0000000)
	SlipDist=60.0000000
	TurnDist=512.0000000
	DangerScale=2.0000000
	bSpecialMove=true
	bDestinationOnly=true
	bBuildLongPaths=false
	// Reference: CylinderComponent'Engine.Default__CoverLink.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__NavigationPoint.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=58.0000000
		CollisionRadius=48.0000000
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=none
	Components[1]=none
	Components[2]=CollisionCylinder
	Components[3]=none
	CollisionComponent=CollisionCylinder
}