class Weapon extends Inventory
	abstract
	native
	config(Game)
	notplaceable;

enum EWeaponFireType
{
	EWFT_InstantHit,                // 0
	EWFT_Projectile,                // 1
	EWFT_Custom,                    // 2
	EWFT_None,                      // 3
	EWFT_MAX                        // 4
};

var byte CurrentFireMode;
var array<name> FiringStatesArray;
var array<Weapon.EWeaponFireType> WeaponFireTypes;
var array< Class<Projectile> > WeaponProjectiles;
var array<float> FireInterval;
var array<float> Spread;
var array<float> InstantHitDamage;
var array<float> InstantHitMomentum;
var array< Class<DamageType> > InstantHitDamageTypes;
var float EquipTime;
var float PutDownTime;
var Vector FireOffset;
var bool bWeaponPutDown;
var bool bCanThrow;
var bool bWasOptionalSet;
var bool bWasDoNotActivate;
var bool bInstantHit;
var bool bMeleeWeapon;
var float WeaponRange;
var export editinline MeshComponent Mesh;
var float DefaultAnimSpeed;
var config float Priority;
var AIController AIController;
var array<byte> ShouldFireOnRelease;
var float AIRating;
var float CachedMaxRange;

simulated event Destroyed()
{
	DetachWeapon();
	super.Destroyed();
	//return;	
}

function ItemRemovedFromInvManager()
{
	LogInternal((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "", 'Inventory');
	GotoState('Inactive');
	ForceEndFire();
	DetachWeapon();
	ClientWeaponThrown();
	super.ItemRemovedFromInvManager();
	// End:0xFF
	if((Instigator != none) && Instigator.Weapon == self)
	{
		Instigator.Weapon = none;
	}
	//return;	
}

function HolderDied()
{
	ServerStopFire(CurrentFireMode);
	//return;	
}

simulated function bool DoOverrideNextWeapon()
{
	return false;
	//return ReturnValue;	
}

simulated function bool DoOverridePrevWeapon()
{
	return false;
	//return ReturnValue;	
}

function DropFrom(Vector StartLocation, Vector StartVelocity)
{
	// End:0x11
	if(!CanThrow())
	{
		return;
	}
	GotoState('Inactive');
	ForceEndFire();
	DetachWeapon();
	super.DropFrom(StartLocation, StartVelocity);
	AIController = none;
	//return;	
}

simulated function bool CanThrow()
{
	return bCanThrow;
	//return ReturnValue;	
}

reliable client simulated function ClientWeaponThrown()
{
	LogInternal((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "", 'Inventory');
	// End:0x114
	if(int(WorldInfo.NetMode) == int(NM_Client))
	{
		GotoState('Inactive');
		// End:0x100
		if((Instigator != none) && Instigator.Weapon == self)
		{
			Instigator.Weapon = none;
		}
		ForceEndFire();
		DetachWeapon();
	}
	//return;	
}

simulated event bool IsFiring()
{
	return false;
	//return ReturnValue;	
}

simulated function bool DenyClientWeaponSet()
{
	return false;
	//return ReturnValue;	
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	local array<string> DebugInfo;
	local int I;

	GetWeaponDebug(DebugInfo);
	HUD.Canvas.SetDrawColor(0, 255, 0);
	I = 0;
	J0x59:

	// End:0x127 [Loop If]
	if(I < DebugInfo.Length)
	{
		HUD.Canvas.DrawText("  " @ DebugInfo[I]);
		out_YPos += out_YL;
		HUD.Canvas.SetPos(4.0000000, out_YPos);
		I++;
		// [Loop Continue]
		goto J0x59;
	}
	//return;	
}

simulated function GetWeaponDebug(out array<string> DebugInfo)
{
	local string T;
	local int I;

	DebugInfo[DebugInfo.Length] = (((((("Weapon:" $ (GetItemName(string(self)))) @ "State:") $ string(GetStateName())) @ "Instigator:") $ string(Instigator)) @ "Owner:") $ string(Owner);
	DebugInfo[DebugInfo.Length] = (((("IsFiring():" $ string(IsFiring())) @ "CurrentFireMode:") $ string(CurrentFireMode)) @ "bWeaponPutDown:") $ string(bWeaponPutDown);
	// End:0x19A
	if(Instigator != none)
	{
		DebugInfo[DebugInfo.Length] = (((("ShotCount:" $ string(Instigator.ShotCount)) @ "FlashCount:") $ string(Instigator.FlashCount)) @ "FlashLocation:") $ string(Instigator.FlashLocation);
	}
	T = "PendingFires:";
	I = 0;
	J0x1BE:

	// End:0x213 [Loop If]
	if(I < GetPendingFireLength())
	{
		T = (T $ string(PendingFire(I))) $ " ";
		I++;
		// [Loop Continue]
		goto J0x1BE;
	}
	DebugInfo[DebugInfo.Length] = T;
	// End:0x36B
	if(Timers.Length > 0)
	{
		I = 0;
		J0x24C:

		// End:0x36B [Loop If]
		if(I < Timers.Length)
		{
			DebugInfo[DebugInfo.Length] = (((("Timer" @ string(Timers[I].FuncName)) @ string(Timers[I].Count)) @ string(Timers[I].Rate)) @ string(int((Timers[I].Count / Timers[I].Rate) * float(100)))) $ "%";
			I++;
			// [Loop Continue]
			goto J0x24C;
		}
	}
	//return;	
}

function ConsumeAmmo(byte FireModeNum)
{
	//return;	
}

function int AddAmmo(int Amount)
{
	//return ReturnValue;	
}

simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
	return true;
	//return ReturnValue;	
}

simulated function bool HasAnyAmmo()
{
	return true;
	//return ReturnValue;	
}

final simulated function int GetPendingFireLength()
{
	// End:0x30
	if(InvManager != none)
	{
		return InvManager.GetPendingFireLength(self);
	}
	return 0;
	//return ReturnValue;	
}

final simulated function bool PendingFire(int FireMode)
{
	// End:0x39
	if(InvManager != none)
	{
		return InvManager.IsPendingFire(self, FireMode);
	}
	return false;
	//return ReturnValue;	
}

final simulated function SetPendingFire(int FireMode)
{
	// End:0x38
	if(InvManager != none)
	{
		InvManager.SetPendingFire(self, FireMode);
	}
	//return;	
}

final simulated function ClearPendingFire(int FireMode)
{
	// End:0x38
	if(InvManager != none)
	{
		InvManager.ClearPendingFire(self, FireMode);
	}
	//return;	
}

function Class<Projectile> GetProjectileClass()
{
	return ((int(CurrentFireMode) < WeaponProjectiles.Length) ? WeaponProjectiles[int(CurrentFireMode)] : none);
	//return ReturnValue;	
}

simulated function Rotator AddSpread(Rotator BaseAim)
{
	local Vector X, Y, Z;
	local float CurrentSpread, RandY, RandZ;

	CurrentSpread = Spread[int(CurrentFireMode)];
	// End:0x3D
	if(CurrentSpread == float(0))
	{
		return BaseAim;		
	}
	else
	{
		GetAxes(BaseAim, X, Y, Z);
		RandY = FRand() - 0.5000000;
		RandZ = Sqrt(0.5000000 - Square(RandY)) * (FRand() - 0.5000000);
		return Rotator((X + ((RandY * CurrentSpread) * Y)) + ((RandZ * CurrentSpread) * Z));
	}
	//return ReturnValue;	
}

simulated function float MaxRange()
{
	local int I;

	// End:0x1B
	if(CachedMaxRange > float(0))
	{
		return CachedMaxRange;
	}
	// End:0x3B
	if(bInstantHit)
	{
		CachedMaxRange = WeaponRange;
	}
	I = 0;
	J0x46:

	// End:0xC3 [Loop If]
	if(I < WeaponProjectiles.Length)
	{
		// End:0xB5
		if(WeaponProjectiles[I] != none)
		{
			CachedMaxRange = FMax(CachedMaxRange, WeaponProjectiles[I].static.GetRange());
		}
		I++;
		// [Loop Continue]
		goto J0x46;
	}
	return CachedMaxRange;
	//return ReturnValue;	
}

function float GetAIRating()
{
	return AIRating;
	//return ReturnValue;	
}

simulated function float GetWeaponRating()
{
	// End:0x30
	if(InvManager != none)
	{
		return InvManager.GetWeaponRatingFor(self);
	}
	// End:0x45
	if(!HasAnyAmmo())
	{
		return -1.0000000;
	}
	return 1.0000000;
	//return ReturnValue;	
}

function bool CanAttack(Actor Other)
{
	return true;
	//return ReturnValue;	
}

function bool FireOnRelease()
{
	return (ShouldFireOnRelease.Length > 0) && int(ShouldFireOnRelease[int(CurrentFireMode)]) != int(0);
	//return ReturnValue;	
}

simulated function AnimNodeSequence GetWeaponAnimNodeSeq()
{
	local AnimTree Tree;
	local AnimNodeSequence AnimSeq;
	local editinline SkeletalMeshComponent SkelMesh;

	SkelMesh = SkeletalMeshComponent(Mesh);
	// End:0xEF
	if(SkelMesh != none)
	{
		Tree = AnimTree(SkelMesh.Animations);
		// End:0xB4
		if(Tree != none)
		{
			AnimSeq = AnimNodeSequence(Tree.Children[0].Anim);			
		}
		else
		{
			AnimSeq = AnimNodeSequence(SkelMesh.Animations);
		}
		return AnimSeq;
	}
	return none;
	//return ReturnValue;	
}

simulated function PlayWeaponAnimation(name Sequence, float fDesiredDuration, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
	local AnimNodeSequence WeapNode;
	local AnimTree Tree;

	// End:0x2D
	if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
	{
		return;
	}
	// End:0x58
	if(SkelMesh == none)
	{
		SkelMesh = SkeletalMeshComponent(Mesh);
	}
	// End:0x7B
	if((SkelMesh == none) || (GetWeaponAnimNodeSeq()) == none)
	{
		return;
	}
	// End:0xCF
	if(fDesiredDuration > 0.0000000)
	{
		SkelMesh.PlayAnim(Sequence, fDesiredDuration, bLoop);		
	}
	else
	{
		Tree = AnimTree(SkelMesh.Animations);
		// End:0x158
		if(Tree != none)
		{
			WeapNode = AnimNodeSequence(Tree.Children[0].Anim);			
		}
		else
		{
			WeapNode = AnimNodeSequence(SkelMesh.Animations);
		}
		WeapNode.SetAnim(Sequence);
		WeapNode.PlayAnim(bLoop, DefaultAnimSpeed);
	}
	//return;	
}

simulated function StopWeaponAnimation()
{
	local AnimNodeSequence AnimSeq;

	// End:0x2B
	if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
	{
		return;
	}
	AnimSeq = GetWeaponAnimNodeSeq();
	// End:0x6D
	if(AnimSeq != none)
	{
		AnimSeq.StopAnim();
	}
	//return;	
}

simulated function PlayFireEffects(byte FireModeNum, optional Vector HitLocation)
{
	//return;	
}

simulated function StopFireEffects(byte FireModeNum)
{
	//return;	
}

simulated function float GetFireInterval(byte FireModeNum)
{
	return ((FireInterval[int(FireModeNum)] > float(0)) ? FireInterval[int(FireModeNum)] : 0.0100000);
	//return ReturnValue;	
}

simulated function TimeWeaponFiring(byte FireModeNum)
{
	// End:0x3A
	if(!IsTimerActive('RefireCheckTimer'))
	{
		SetTimer(GetFireInterval(FireModeNum), true, 'RefireCheckTimer');
	}
	//return;	
}

simulated function RefireCheckTimer()
{
	//return;	
}

simulated function TimeWeaponPutDown()
{
	SetTimer(((PutDownTime > float(0)) ? PutDownTime : 0.0100000), false, 'WeaponIsDown');
	//return;	
}

simulated function TimeWeaponEquipping()
{
	SetTimer(((EquipTime > float(0)) ? EquipTime : 0.0100000), false, 'WeaponEquipped');
	//return;	
}

simulated function Activate()
{
	// End:0x1D
	if(!IsFiring())
	{
		GotoState('WeaponEquipping');
	}
	//return;	
}

simulated function PutDownWeapon()
{
	GotoState('WeaponPuttingDown');
	//return;	
}

function bool DenyPickupQuery(Class<Inventory> ItemClass, Actor Pickup)
{
	// End:0x19
	if(ItemClass == Class)
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

simulated function WeaponEmpty()
{
	//return;	
}

simulated function IncrementFlashCount()
{
	// End:0x38
	if(Instigator != none)
	{
		Instigator.IncrementFlashCount(self, CurrentFireMode);
	}
	//return;	
}

simulated function ClearFlashCount()
{
	// End:0x2F
	if(Instigator != none)
	{
		Instigator.ClearFlashCount(self);
	}
	//return;	
}

function SetFlashLocation(Vector HitLocation)
{
	// End:0x41
	if(Instigator != none)
	{
		Instigator.SetFlashLocation(self, CurrentFireMode, HitLocation);
	}
	//return;	
}

function ClearFlashLocation()
{
	// End:0x2F
	if(Instigator != none)
	{
		Instigator.ClearFlashLocation(self);
	}
	//return;	
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
	//return;	
}

simulated function DetachWeapon()
{
	//return;	
}

reliable client simulated function ClientGivenTo(Pawn NewOwner, bool bDoNotActivate)
{
	super.ClientGivenTo(NewOwner, bDoNotActivate);
	ClientWeaponSet(true, bDoNotActivate);
	//return;	
}

reliable client simulated function ClientWeaponSet(bool bOptionalSet, optional bool bDoNotActivate)
{
	LogInternal(((((((((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "bOptionalSet:") @ string(bOptionalSet)) @ "bDoNotActivate:") @ string(bDoNotActivate)) @ "Instigator:") @ string(Instigator)) @ "InvManager:") @ string(InvManager), 'Inventory');
	bWasOptionalSet = bOptionalSet;
	bWasDoNotActivate = bDoNotActivate;
	// End:0x1D9
	if(Instigator == none)
	{
		LogInternal((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "Instigator == None, going to PendingClientWeaponSet", 'Inventory');
		GotoState('PendingClientWeaponSet');
		return;
	}
	// End:0x29F
	if(InvManager == none)
	{
		LogInternal((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "InvManager == None, going to PendingClientWeaponSet", 'Inventory');
		GotoState('PendingClientWeaponSet');
		return;
	}
	InvManager.ClientWeaponSet(self, bOptionalSet, bDoNotActivate);
	//return;	
}

simulated function StartFire(byte FireModeNum)
{
	// End:0x6F
	if((Instigator == none) || !Instigator.bNoWeaponFiring)
	{
		// End:0x5C
		if(int(Role) < int(ROLE_Authority))
		{
			ServerStartFire(FireModeNum);
		}
		BeginFire(FireModeNum);
	}
	//return;	
}

reliable server function ServerStartFire(byte FireModeNum)
{
	// End:0x48
	if((Instigator == none) || !Instigator.bNoWeaponFiring)
	{
		BeginFire(FireModeNum);
	}
	//return;	
}

simulated function BeginFire(byte FireModeNum)
{
	LogInternal(((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "FireModeNum:") @ string(FireModeNum), 'Inventory');
	SetPendingFire(int(FireModeNum));
	//return;	
}

simulated function StopFire(byte FireModeNum)
{
	EndFire(FireModeNum);
	// End:0x3A
	if(int(Role) < int(ROLE_Authority))
	{
		ServerStopFire(FireModeNum);
	}
	//return;	
}

reliable server function ServerStopFire(byte FireModeNum)
{
	EndFire(FireModeNum);
	//return;	
}

simulated function EndFire(byte FireModeNum)
{
	ClearPendingFire(int(FireModeNum));
	//return;	
}

simulated function ForceEndFire()
{
	local int I, Num;

	// End:0x7E
	if(InvManager != none)
	{
		Num = GetPendingFireLength();
		I = 0;
		J0x2E:

		// End:0x7E [Loop If]
		if(I < Num)
		{
			// End:0x70
			if(PendingFire(I))
			{
				EndFire(byte(I));
			}
			I++;
			// [Loop Continue]
			goto J0x2E;
		}
	}
	//return;	
}

simulated function SendToFiringState(byte FireModeNum)
{
	// End:0xA3
	if(int(FireModeNum) >= FiringStatesArray.Length)
	{
		LogInternal((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "Invalid FireModeNum", 'Inventory');
		return;
	}
	// End:0xEA
	if((FiringStatesArray[int(FireModeNum)] == 'None') || int(WeaponFireTypes[int(FireModeNum)]) == int(3))
	{
		return;
	}
	SetCurrentFireMode(FireModeNum);
	LogInternal((((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ string(FireModeNum)) @ "Sending to state:") @ string(FiringStatesArray[int(FireModeNum)]), 'Inventory');
	GotoState(FiringStatesArray[int(FireModeNum)]);
	//return;	
}

simulated function SetCurrentFireMode(byte FiringModeNum)
{
	CurrentFireMode = FiringModeNum;
	// End:0x4B
	if(Instigator != none)
	{
		Instigator.SetFiringMode(self, FiringModeNum);
	}
	//return;	
}

simulated function FireModeUpdated(byte FiringMode, bool bViaReplication)
{
	//return;	
}

simulated function FireAmmunition()
{
	ConsumeAmmo(CurrentFireMode);
	switch(WeaponFireTypes[int(CurrentFireMode)])
	{
		// End:0x44
		case 0:
			InstantFire();
			// End:0x6B
			break;
		// End:0x56
		case 1:
			ProjectileFire();
			// End:0x6B
			break;
		// End:0x68
		case 2:
			CustomFire();
			// End:0x6B
			break;
		// End:0xFFFF
		default:
			break;
	}
	NotifyWeaponFired(CurrentFireMode);
	//return;	
}

simulated function Rotator GetAdjustedAim(Vector StartFireLoc)
{
	local Rotator R;

	// End:0x42
	if(Instigator != none)
	{
		R = Instigator.GetAdjustedAimFor(self, StartFireLoc);
	}
	return AddSpread(R);
	//return ReturnValue;	
}

simulated event float GetTraceRange()
{
	return WeaponRange;
	//return ReturnValue;	
}

simulated function Actor GetTraceOwner()
{
	return ((Instigator != none) ? Instigator : self);
	//return ReturnValue;	
}

simulated function ImpactInfo CalcWeaponFire(Vector StartTrace, Vector EndTrace, optional out array<ImpactInfo> ImpactList, optional Vector Extent)
{
	local Vector HitLocation, HitNormal, Dir;
	local Actor HitActor;
	local TraceHitInfo HitInfo;
	local ImpactInfo CurrentImpact;
	local PortalTeleporter Portal;
	local float HitDist;
	local bool bOldBlockActors, bOldCollideActors;

	HitActor = GetTraceOwner().Trace(HitLocation, HitNormal, EndTrace, StartTrace, true, Extent, HitInfo, 1);
	// End:0x7F
	if(HitActor == none)
	{
		HitLocation = EndTrace;
	}
	CurrentImpact.HitActor = HitActor;
	CurrentImpact.HitLocation = HitLocation;
	CurrentImpact.HitNormal = HitNormal;
	CurrentImpact.RayDir = Normal(EndTrace - StartTrace);
	CurrentImpact.StartTrace = StartTrace;
	CurrentImpact.HitInfo = HitInfo;
	ImpactList[ImpactList.Length] = CurrentImpact;
	// End:0x4A9
	if(HitActor != none)
	{
		// End:0x35A
		if(PassThroughDamage(HitActor))
		{
			HitActor.bProjTarget = false;
			bOldCollideActors = HitActor.bCollideActors;
			bOldBlockActors = HitActor.bBlockActors;
			// End:0x2A0
			if(HitActor.IsA('Pawn'))
			{
				HitActor.SetCollision(false, false);				
				CalcWeaponFire(HitLocation, EndTrace, ImpactList, Extent);				
			}
			else
			{
				// End:0x2D1
				if(bOldBlockActors)
				{
					HitActor.SetCollision(bOldCollideActors, false);
				}
				CurrentImpact = CalcWeaponFire(HitLocation, EndTrace, ImpactList, Extent);
			}
			HitActor.bProjTarget = true;
			HitActor.SetCollision(bOldCollideActors, bOldBlockActors);			
		}
		else
		{
			Portal = PortalTeleporter(HitActor);
			// End:0x4A9
			if((Portal != none) && Portal.SisterPortal != none)
			{
				Dir = EndTrace - StartTrace;
				HitDist = VSize(HitLocation - StartTrace);
				StartTrace = Portal.TransformHitLocation(HitLocation);
				EndTrace = StartTrace + Portal.TransformVectorDir(Normal(Dir) * (VSize(Dir) - HitDist));				
				CalcWeaponFire(StartTrace, EndTrace, ImpactList, Extent);
			}
		}
	}
	return CurrentImpact;
	//return ReturnValue;	
}

static simulated function bool PassThroughDamage(Actor HitActor)
{
	return (!HitActor.bBlockActors && HitActor.IsA('Trigger') || HitActor.IsA('TriggerVolume')) || HitActor.IsA('InteractiveFoliageActor');
	//return ReturnValue;	
}

simulated function InstantFire()
{
	local Vector StartTrace, EndTrace;
	local array<ImpactInfo> ImpactList;
	local int Idx;
	local ImpactInfo RealImpact;

	StartTrace = Instigator.GetWeaponStartTraceLocation();
	EndTrace = StartTrace + (Vector(GetAdjustedAim(StartTrace)) * (GetTraceRange()));
	RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);
	// End:0xCA
	if(int(Role) == int(ROLE_Authority))
	{
		SetFlashLocation(RealImpact.HitLocation);
	}
	Idx = 0;
	J0xD5:

	// End:0x122 [Loop If]
	if(Idx < ImpactList.Length)
	{
		ProcessInstantHit(CurrentFireMode, ImpactList[Idx]);
		Idx++;
		// [Loop Continue]
		goto J0xD5;
	}
	//return;	
}

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
	local int TotalDamage;
	local KActorFromStatic NewKActor;
	local editinline StaticMeshComponent HitStaticMesh;

	// End:0x252
	if(Impact.HitActor != none)
	{
		NumHits = Max(NumHits, 1);
		TotalDamage = int(InstantHitDamage[int(CurrentFireMode)] * float(NumHits));
		// End:0x178
		if(Impact.HitActor.bWorldGeometry)
		{
			HitStaticMesh = StaticMeshComponent(Impact.HitInfo.HitComponent);
			// End:0x178
			if((HitStaticMesh != none) && HitStaticMesh.CanBecomeDynamic())
			{
				NewKActor = Class'Engine.KActorFromStatic'.static.MakeDynamic(HitStaticMesh);
				// End:0x178
				if(NewKActor != none)
				{
					Impact.HitActor = NewKActor;
				}
			}
		}
		Impact.HitActor.TakeDamage(TotalDamage, Instigator.Controller, Impact.HitLocation, InstantHitMomentum[int(FiringMode)] * Impact.RayDir, InstantHitDamageTypes[int(FiringMode)], Impact.HitInfo, self);
	}
	//return;	
}

simulated function Projectile ProjectileFire()
{
	local Vector StartTrace, EndTrace, RealStartLoc, AimDir;
	local ImpactInfo TestImpact;
	local Projectile SpawnedProjectile;

	IncrementFlashCount();
	// End:0x1B4
	if(int(Role) == int(ROLE_Authority))
	{
		StartTrace = Instigator.GetWeaponStartTraceLocation();
		AimDir = Vector(GetAdjustedAim(StartTrace));
		RealStartLoc = GetPhysicalFireStartLoc(AimDir);
		// End:0x120
		if(StartTrace != RealStartLoc)
		{
			EndTrace = StartTrace + (AimDir * (GetTraceRange()));
			TestImpact = CalcWeaponFire(StartTrace, EndTrace);
			AimDir = Normal(TestImpact.HitLocation - RealStartLoc);
		}
		SpawnedProjectile = Spawn(GetProjectileClass(), self,, RealStartLoc);
		// End:0x1AA
		if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
		{
			SpawnedProjectile.Init(AimDir);
		}
		return SpawnedProjectile;
	}
	return none;
	//return ReturnValue;	
}

simulated function CustomFire()
{
	//return;	
}

simulated event Vector GetMuzzleLoc()
{
	// End:0x5C
	if(Instigator != none)
	{
		return Instigator.GetPawnViewLocation() + (FireOffset >> Instigator.GetViewRotation());
	}
	return Location;
	//return ReturnValue;	
}

// Export UWeapon::execGetPhysicalFireStartLoc(FFrame&, void* const)
native simulated event Vector GetPhysicalFireStartLoc(optional Vector AimDir);

simulated function bool TryPutDown()
{
	bWeaponPutDown = true;
	return true;
	//return ReturnValue;	
}

simulated function HandleFinishedFiring()
{
	GotoState('Active');
	//return;	
}

function NotifyWeaponFired(byte FireMode)
{
	// End:0x38
	if(AIController != none)
	{
		AIController.NotifyWeaponFired(self, FireMode);
	}
	//return;	
}

function NotifyWeaponFinishedFiring(byte FireMode)
{
	// End:0x38
	if(AIController != none)
	{
		AIController.NotifyWeaponFinishedFiring(self, FireMode);
	}
	//return;	
}

simulated function bool ShouldRefire()
{
	// End:0x1B
	if(!HasAmmo(CurrentFireMode))
	{
		return false;
	}
	return StillFiring(CurrentFireMode);
	//return ReturnValue;	
}

simulated function bool StillFiring(byte FireMode)
{
	return PendingFire(int(FireMode));
	//return ReturnValue;	
}

simulated function WeaponIsDown()
{
	//return;	
}

simulated function CacheAIController()
{
	// End:0x1D
	if(Instigator == none)
	{
		AIController = none;		
	}
	else
	{
		AIController = AIController(Instigator.Controller);
	}
	//return;	
}

simulated function float GetTargetDistance()
{
	local float VeryFar;
	local Vector HitLocation, HitNormal, projStart, TargetLoc, X, Y,
		Z;

	local Rotator CameraRot;
	local PlayerController PC;

	VeryFar = 32768.0000000;
	PC = PlayerController(Instigator.Controller);
	PC.GetPlayerViewPoint(projStart, CameraRot);
	GetAxes(CameraRot, X, Y, Z);
	TargetLoc = projStart + (X * VeryFar);
	// End:0x111
	if(none == GetTraceOwner().Trace(HitLocation, HitNormal, TargetLoc, projStart, true,,, 1))
	{
		return VeryFar;
	}
	return (HitLocation - projStart) Dot X;
	//return ReturnValue;	
}

auto state Inactive
{
	ignores StartFire, BeginState;

	reliable server function ServerStartFire(byte FireModeNum)
	{
		global.ServerStartFire(FireModeNum);
		WarnInternal((string(WorldInfo.TimeSeconds) @ string(Instigator)) @ "received ServerStartFire in Inactive State!!!");
		// End:0xFC
		if((Instigator != none) && Instigator.Weapon == self)
		{
			WarnInternal(" - I'm the current weapon, so gotostate active and start firing");
			GotoState('Active');			
		}
		else
		{
			// End:0x35B
			if((InvManager != none) && InvManager.PendingWeapon == self)
			{
				// End:0x1FA
				if(Instigator.Weapon.IsInState('WeaponPuttingDown'))
				{
					WarnInternal(" - I'm the pending weapon, and current weapon is being put down, so force switch now");
					Instigator.Weapon.WeaponIsDown();					
				}
				else
				{
					WarnInternal(" - I'm the pending weapon, but current weapon is NOT being put down, so resync client and server");
					InvManager.SetCurrentWeapon(self);
					InvManager.ServerSetCurrentWeapon(self);
					// End:0x358
					if(((Instigator.Weapon != self) && InvManager.PendingWeapon == self) && Instigator.Weapon.IsInState('WeaponPuttingDown'))
					{
						Instigator.Weapon.WeaponIsDown();
					}
				}				
			}
			else
			{
				// End:0x4A1
				if(Instigator != none)
				{
					WarnInternal(" - I'm just in the inventory, so resync client and server");
					InvManager.SetCurrentWeapon(self);
					InvManager.ServerSetCurrentWeapon(self);
					// End:0x4A1
					if(((Instigator.Weapon != self) && InvManager.PendingWeapon == self) && Instigator.Weapon.IsInState('WeaponPuttingDown'))
					{
						Instigator.Weapon.WeaponIsDown();
					}
				}
			}
		}
		//return;		
	}

	reliable server function ServerStopFire(byte FireModeNum)
	{
		ClearPendingFire(int(FireModeNum));
		//return;		
	}

	simulated function bool TryPutDown()
	{
		return false;
		//return ReturnValue;		
	}
	stop;	
}

simulated state Active
{
	ignores Activate;

	simulated event BeginState(name PreviousStateName)
	{
		local int I;

		// End:0x1E
		if(int(Role) == int(ROLE_Authority))
		{
			CacheAIController();
		}
		// End:0xE8
		if(bWeaponPutDown)
		{
			LogInternal((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "Weapon put down requested during transition, put it down now", 'Inventory');
			PutDownWeapon();			
		}
		else
		{
			// End:0x104
			if(!HasAnyAmmo())
			{
				WeaponEmpty();				
			}
			else
			{
				I = 0;
				J0x10F:

				// End:0x163 [Loop If]
				if(I < GetPendingFireLength())
				{
					// End:0x155
					if(PendingFire(I))
					{
						BeginFire(byte(I));
						// [Explicit Break]
						goto J0x163;
					}
					I++;
					// [Loop Continue]
					goto J0x10F;
				}
			}
		}
		J0x163:

		//return;		
	}

	simulated function BeginFire(byte FireModeNum)
	{
		// End:0x77
		if(!bDeleteMe && Instigator != none)
		{
			global.BeginFire(FireModeNum);
			// End:0x77
			if(PendingFire(int(FireModeNum)) && HasAmmo(FireModeNum))
			{
				SendToFiringState(FireModeNum);
			}
		}
		//return;		
	}

	simulated function bool ReadyToFire(bool bFinished)
	{
		return true;
		//return ReturnValue;		
	}

	simulated function bool TryPutDown()
	{
		PutDownWeapon();
		return true;
		//return ReturnValue;		
	}
	stop;	
}

simulated state WeaponFiring
{
	simulated event bool IsFiring()
	{
		return true;
		//return ReturnValue;		
	}

	simulated function RefireCheckTimer()
	{
		// End:0xC3
		if(bWeaponPutDown)
		{
			LogInternal((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "Weapon put down requested during fire, put it down now", 'Inventory');
			PutDownWeapon();
			return;
		}
		// End:0xDC
		if(ShouldRefire())
		{
			FireAmmunition();
			return;
		}
		HandleFinishedFiring();
		//return;		
	}

	simulated event BeginState(name PreviousStateName)
	{
		LogInternal(((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "PreviousStateName:") @ string(PreviousStateName), 'Inventory');
		FireAmmunition();
		TimeWeaponFiring(CurrentFireMode);
		//return;		
	}

	simulated event EndState(name NextStateName)
	{
		LogInternal(((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "NextStateName:") @ string(NextStateName), 'Inventory');
		ClearFlashCount();
		ClearFlashLocation();
		ClearTimer('RefireCheckTimer');
		NotifyWeaponFinishedFiring(CurrentFireMode);
		//return;		
	}
	stop;	
}

simulated state WeaponEquipping
{
	ignores Activate;

	simulated event BeginState(name PreviousStateName)
	{
		LogInternal((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "", 'Inventory');
		TimeWeaponEquipping();
		bWeaponPutDown = false;
		//return;		
	}

	simulated event EndState(name NextStateName)
	{
		ClearTimer('WeaponEquipped');
		//return;		
	}

	simulated function WeaponEquipped()
	{
		// End:0x19
		if(bWeaponPutDown)
		{
			PutDownWeapon();
			return;
		}
		GotoState('Active');
		//return;		
	}
	stop;	
}

simulated state WeaponPuttingDown
{
	simulated event BeginState(name PreviousStateName)
	{
		LogInternal((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "", 'Inventory');
		TimeWeaponPutDown();
		bWeaponPutDown = false;
		ForceEndFire();
		//return;		
	}

	simulated function WeaponIsDown()
	{
		// End:0x24
		if(InvManager.CancelWeaponChange())
		{
			return;
		}
		LogInternal((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "", 'Inventory');
		DetachWeapon();
		GotoState('Inactive');
		InvManager.ChangedWeapon();
		//return;		
	}

	simulated function bool TryPutDown()
	{
		return false;
		//return ReturnValue;		
	}

	reliable client simulated function ClientWeaponThrown()
	{
		WeaponIsDown();
		global.ClientWeaponThrown();
		//return;		
	}

	simulated event EndState(name NextStateName)
	{
		LogInternal((((((((string(WorldInfo.TimeSeconds) @ "Self:") @ string(self)) @ "Instigator:") @ string(Instigator)) @ string(GetStateName())) $ "::") $ string(GetFuncName())) @ "", 'Inventory');
		ClearTimer('WeaponIsDown');
		//return;		
	}
	stop;	
}

state PendingClientWeaponSet
{
	simulated function PendingWeaponSetTimer()
	{
		ClientWeaponSet(bWasOptionalSet, bWasDoNotActivate);
		//return;		
	}

	simulated event BeginState(name PreviousStateName)
	{
		SetTimer(0.0300000, true, 'PendingWeaponSetTimer');
		//return;		
	}

	simulated event EndState(name NextStateName)
	{
		ClearTimer('PendingWeaponSetTimer');
		//return;		
	}
	stop;	
}

defaultproperties
{
	EquipTime=0.3300000
	PutDownTime=0.3300000
	bCanThrow=true
	WeaponRange=16384.0000000
	DefaultAnimSpeed=1.0000000
	Priority=-1.0000000
	AIRating=0.5000000
	ItemName="Weapon"
	RespawnTime=30.0000000
	Components=none
	bReplicateInstigator=true
	bOnlyDirtyReplication=false
}