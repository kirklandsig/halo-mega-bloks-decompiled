class HaloSkelControl_Damage extends UDKSkelControl_Damage;

var name BoneName;

simulated event BreakApart(Vector PartLocation, bool bIsVisible)
{
	local HaloGib Gib;
	local HaloPawn OwnerPawn;

	OwnerPawn = HaloPawn(SkelComponent.Owner);
	// End:0x8B
	if(((!bOnDamageActive || BreakMesh == none) || OwnerPawn == none) || bIsBroken)
	{
		bIsBreaking = false;
		bIsBroken = true;
		return;
	}
	// End:0x178
	if(bIsVisible && int(OwnerPawn.WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		Gib = SpawnGib(PartLocation, OwnerPawn.Rotation, BreakMesh, PartLocation, true, DefaultBreakDir, PS_DamageOnBreak, PS_DamageTrail);
		// End:0x178
		if(Gib != none)
		{
			Gib.SetDrawScale3D(DamageScale);
		}
	}
	BoneScale = DamageBoneScale;
	bIsBreaking = false;
	bIsBroken = true;
	//return;	
}

simulated event BreakApartAtBone()
{
	local HaloGib Gib;
	local HaloPawn OwnerPawn;

	OwnerPawn = HaloPawn(SkelComponent.Owner);
	// End:0x8B
	if(((!bOnDamageActive || BreakMesh == none) || OwnerPawn == none) || bIsBroken)
	{
		bIsBreaking = false;
		bIsBroken = true;
		return;
	}
	// End:0x1FD
	if(int(OwnerPawn.WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		Gib = SpawnGib(OwnerPawn.Mesh.GetBoneLocation(BoneName), QuatToRotator(OwnerPawn.Mesh.GetBoneQuaternion(BoneName)), BreakMesh, OwnerPawn.Mesh.GetBoneLocation(BoneName), true, DefaultBreakDir, PS_DamageOnBreak, PS_DamageTrail);
		// End:0x1FD
		if(Gib != none)
		{
			Gib.SetDrawScale3D(DamageScale);
		}
	}
	BoneScale = DamageBoneScale;
	bIsBreaking = false;
	bIsBroken = true;
	//return;	
}

simulated function HaloGib SpawnGib(Vector SpawnLocation, Rotator SpawnRotation, StaticMesh TheMesh, Vector HitLocation, bool bSpinGib, Vector ImpulseDirection, ParticleSystem PS_OnBreak, ParticleSystem PS_Trail)
{
	local HaloGib Gib;
	local float GibPerterbation;
	local Rotator VelRotation;
	local Vector X, Y, Z;
	local HaloPawn OwnerPawn;

	OwnerPawn = HaloPawn(SkelComponent.Owner);
	Gib = OwnerPawn.Spawn(Class'MegaHaloGame.HaloGib', OwnerPawn,, SpawnLocation, SpawnRotation,, true);
	// End:0x69A
	if(Gib != none)
	{
		Gib.SetGibStaticMesh(TheMesh);
		Gib.GibMeshComp.SetBlockRigidBody(false);
		Gib.GibMeshComp.SetRBChannel(1);
		Gib.GibMeshComp.SetRBCollidesWithChannel(0, false);
		Gib.GibMeshComp.SetRBCollidesWithChannel(2, false);
		Gib.GibMeshComp.SetRBCollidesWithChannel(3, false);
		Gib.GibMeshComp.SetRBCollidesWithChannel(5, false);
		Gib.GibMeshComp.SetRBCollidesWithChannel(6, false);
		Gib.SetTimer(0.1000000, false, 'TurnOnCollision');
		GibPerterbation = 30000.0000000;
		VelRotation = Rotator(Gib.Location - HitLocation);
		VelRotation.Pitch += int(((FRand() * 2.0000000) * GibPerterbation) - GibPerterbation);
		VelRotation.Yaw += int(((FRand() * 2.0000000) * GibPerterbation) - GibPerterbation);
		VelRotation.Roll += int(((FRand() * 2.0000000) * GibPerterbation) - GibPerterbation);
		GetAxes(VelRotation, X, Y, Z);
		// End:0x3E6
		if(VSize(ImpulseDirection) > 100.0000000)
		{
			Gib.Velocity = OwnerPawn.Velocity + ImpulseDirection;			
		}
		else
		{
			// End:0x474
			if(VSize(OwnerPawn.Velocity) > 10.0000000)
			{
				Gib.Velocity = (OwnerPawn.Velocity + (Z * (FRand() * float(100)))) + vect(0.0000000, 0.0000000, 1000.0000000);				
			}
			else
			{
				Gib.Velocity = (((vect(1.0000000, 0.0000000, 0.0000000) * (FRand() * float(400))) + (vect(0.0000000, 1.0000000, 0.0000000) * (FRand() * float(400)))) + (Z * (FRand() * float(300)))) + vect(0.0000000, 0.0000000, 1000.0000000);
			}
		}
		Gib.GibMeshComp.WakeRigidBody();
		Gib.GibMeshComp.SetRBLinearVelocity(Gib.Velocity, false);
		// End:0x5C5
		if(bSpinGib)
		{
			Gib.GibMeshComp.SetRBAngularVelocity(VRand() * float(500), false);
		}
		Gib.LifeSpan = Gib.LifeSpan + (2.0000000 * FRand());
		// End:0x644
		if(PS_OnBreak != none)
		{
			Gib.PS_GibExplosionEffect = PS_OnBreak;
		}
		// End:0x67B
		if(PS_Trail != none)
		{
			Gib.PS_GibTrailEffect = PS_Trail;
		}
		Gib.ActivateGibExplosionEffect();
	}
	return Gib;
	//return ReturnValue;	
}
