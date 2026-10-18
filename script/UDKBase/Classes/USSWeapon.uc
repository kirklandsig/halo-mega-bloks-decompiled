class USSWeapon extends Weapon
	config(Game);

var name WeaponSocketName;
var name MuzzleFlashSocketName;
var array<int> ShotPerFireBurst;
var float AimingTolerance;
var private int ShotInBurstCount;
var Class<USSWeaponAttachment> WeaponAttachmentClass;
var CCSController CCSController;

simulated function CacheAIController()
{
	super.CacheAIController();
	// End:0x27
	if(Instigator == none)
	{
		CCSController = none;		
	}
	else
	{
		CCSController = CCSController(Instigator.Controller);
	}
	//return;	
}

simulated function TimeWeaponEquipping()
{
	super.TimeWeaponEquipping();
	AttachWeaponTo(Instigator.Mesh, WeaponSocketName);
	//return;	
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
	local USSPawn USSPawn;

	super.AttachWeaponTo(MeshCpnt, SocketName);
	USSPawn = USSPawn(Instigator);
	// End:0x8F
	if(USSPawn != none)
	{
		USSPawn.CurrentWeaponAttachmentClass = WeaponAttachmentClass;
		USSPawn.WeaponAttachmentChanged();
	}
	SetHidden(false);
	MeshCpnt.AttachComponentToSocket(Mesh, SocketName);
	//return;	
}

simulated function DetachWeapon()
{
	local USSPawn USSPawn;

	super.DetachWeapon();
	USSPawn = USSPawn(Instigator);
	// End:0x74
	if(USSPawn != none)
	{
		USSPawn.CurrentWeaponAttachmentClass = none;
		USSPawn.WeaponAttachmentChanged();
	}
	DetachComponent(Mesh);
	SetHidden(true);
	//return;	
}

function bool CanAttack(Actor Other)
{
	local Vector WeaponEndLocation;
	local Rotator WeaponEndRotation, InstigatorAim, Delta;
	local editinline SkeletalMeshComponent WeapMeshComp;

	WeapMeshComp = SkeletalMeshComponent(Mesh);
	// End:0x178
	if((WeapMeshComp != none) && WeapMeshComp.bRecentlyRendered)
	{
		WeapMeshComp.GetSocketWorldLocationAndRotation(MuzzleFlashSocketName, WeaponEndLocation, WeaponEndRotation);
		WeaponEndLocation = Instigator.GetWeaponStartTraceLocation();
		InstigatorAim = Instigator.GetAdjustedAimFor(self, WeaponEndLocation);
		Delta = Normalize(InstigatorAim - WeaponEndRotation);
		// End:0x173
		if((Abs(float(Delta.Yaw)) <= AimingTolerance) && Abs(float(Delta.Pitch)) <= AimingTolerance)
		{
			return true;			
		}
		else
		{
			return false;
		}		
	}
	else
	{
		return super.CanAttack(Other);
	}
	//return ReturnValue;	
}

simulated function StartFire(byte FireModeNum)
{
	ShotInBurstCount = 0;
	super.StartFire(FireModeNum);
	//return;	
}

function NotifyWeaponFired(byte FireMode)
{
	ShotInBurstCount++;
	super.NotifyWeaponFired(FireMode);
	// End:0x84
	if(ShotInBurstCount >= ShotPerFireBurst[int(FireMode)])
	{
		// End:0x79
		if(CCSController != none)
		{
			CCSController.NotifyBurstFinished(self, FireMode);
		}
		ShotInBurstCount = 0;
	}
	//return;	
}

defaultproperties
{
	MuzzleFlashSocketName="MuzzleFlashSocket"
	ShotPerFireBurst[0]=1
	AimingTolerance=1092.0000000
}