class CCSCover extends Object
	native;

struct native CCSCoverData
{
	var float TargetDist;
	var float DirectDistance;
	var bool ValidPath;
	var float PathDistance;
	var bool IsValid;
	var CoverLink CoverLink;
	var int SlotIdx;

	structdefaultproperties
	{
		TargetDist=0.0000000
		DirectDistance=0.0000000
		ValidPath=false
		PathDistance=0.0000000
		IsValid=false
		CoverLink=none
		SlotIdx=0
	}
};

static function bool IsLocked(CCSCoverData CoverData)
{
	local bool IsLocked;

	IsLocked = (CoverData.CoverLink.Slots[CoverData.SlotIdx].SlotOwner != none) && CoverData.CoverLink.Slots[CoverData.SlotIdx].SlotOwner.IsPendingKill()!;
	return IsLocked;
	//return ReturnValue;	
}

static function bool LockCover(CCSCoverData CoverData, Pawn ThePawn)
{
	// End:0x18
	if(IsLocked(CoverData))
	{
		return false;
	}
	CoverData.CoverLink.Slots[CoverData.SlotIdx].SlotOwner = ThePawn;
	return true;
	//return ReturnValue;	
}

static function bool UnlockCover(CCSCoverData CoverData, Pawn ThePawn)
{
	// End:0x71
	if(CoverData.CoverLink.Slots[CoverData.SlotIdx].SlotOwner != ThePawn)
	{
		return false;
	}
	CoverData.CoverLink.Slots[CoverData.SlotIdx].SlotOwner = none;
	return true;
	//return ReturnValue;	
}
