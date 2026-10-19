class USSWeaponAttachment extends Actor
	abstract
	notplaceable;

struct USSMaterialImpactEffect
{
	var SoundCue Sound;
	var ParticleSystem ParticleTemplate;

	structdefaultproperties
	{
		Sound=none
		ParticleTemplate=none
	}
};

var export editinline SkeletalMeshComponent WeapMeshComp;
var name MuzzleFlashSocketName;
var export editinline StaticMeshComponent MuzzleFlashMesh;
var bool MuzzleFlashAttached;
var float MuzzleFlashDuration;
var USSMaterialImpactEffect DefaultImpactEffect;

simulated function AttachTo(Pawn OwnerPawn)
{
	//return;	
}

simulated function DetachFrom(SkeletalMeshComponent MeshCpnt)
{
	DetachMuzzleFlash();
	//return;	
}

simulated function USSMaterialImpactEffect GetImpactEffect(PhysicalMaterial HitMaterial)
{
	return DefaultImpactEffect;
	//return ReturnValue;	
}

simulated function PlayImpactEffects(Vector HitLocation)
{
	local Vector NewHitLoc, HitNormal;
	local Actor HitActor;
	local TraceHitInfo HitInfo;
	local USSMaterialImpactEffect ImpactEffect;
	local Pawn P;

	P = Pawn(Owner);
	// End:0x2D
	if(P == none)
	{
		return;
	}
	HitNormal = Normal(Owner.Location - HitLocation);
	HitActor = Trace(NewHitLoc, HitNormal, HitLocation - (HitNormal * float(32)), HitLocation + (HitNormal * float(32)), true,, HitInfo, 1);
	// End:0x127
	if(Pawn(HitActor) != none)
	{
		CheckHitInfo(HitInfo, Pawn(HitActor).Mesh, -HitNormal, NewHitLoc);
	}
	ImpactEffect = GetImpactEffect(HitInfo.PhysMaterial);
	// End:0x1AD
	if(ImpactEffect.Sound != none)
	{
		PlaySound(ImpactEffect.Sound, true,,, HitLocation);
	}
	// End:0x1E1
	if((Pawn(HitActor) != none) || Vehicle(HitActor) != none)
	{
		return;
	}
	// End:0x273
	if(ImpactEffect.ParticleTemplate != none)
	{
		WorldInfo.MyEmitterPool.SpawnEmitter(ImpactEffect.ParticleTemplate, HitLocation, Rotator(HitNormal), HitActor);
	}
	//return;	
}

simulated function CauseMuzzleFlash()
{
	// End:0x19
	if(!MuzzleFlashAttached)
	{
		AttachMuzzleFlash();
	}
	MuzzleFlashMesh.SetHidden(false);
	SetTimer(MuzzleFlashDuration, false, 'MuzzleFlashTimer');
	//return;	
}

simulated function AttachMuzzleFlash()
{
	MuzzleFlashAttached = true;
	// End:0x4C
	if(WeapMeshComp != none)
	{
		WeapMeshComp.AttachComponentToSocket(MuzzleFlashMesh, MuzzleFlashSocketName);
	}
	//return;	
}

simulated function DetachMuzzleFlash()
{
	// End:0x37
	if(WeapMeshComp != none)
	{
		WeapMeshComp.DetachComponent(MuzzleFlashMesh);
	}
	MuzzleFlashAttached = false;
	//return;	
}

simulated function StopMuzzleFlash()
{
	ClearTimer('MuzzleFlashTimer');
	MuzzleFlashTimer();
	//return;	
}

simulated event MuzzleFlashTimer()
{
	MuzzleFlashMesh.SetHidden(true);
	//return;	
}

defaultproperties
{
	MuzzleFlashSocketName="MuzzleFlashSocket"
	MuzzleFlashDuration=0.0500000
	CollisionType=ECollisionType.COLLIDE_CustomDefault
}