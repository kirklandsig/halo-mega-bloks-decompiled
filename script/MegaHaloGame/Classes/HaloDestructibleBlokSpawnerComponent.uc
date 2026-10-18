class HaloDestructibleBlokSpawnerComponent extends ActorComponent;

struct HaloDestructibleBlokData
{
	var StaticMesh BlokMesh;
	var ParticleSystem BlokFX;
	var name BoneName;

	structdefaultproperties
	{
		BlokMesh=none
		BlokFX=none
		BoneName="None"
	}
};

struct HaloDestructibleBlokWaveData
{
	var bool bThrown;
	var float LifeSpan;
	var float RandomImpulseXScalar;
	var float RandomImpulseYScalar;
	var float RandomImpulseZScalar;
	var float BreakImpulseXScalar;
	var float BreakImpulseYScalar;
	var float BreakImpulseZScalar;
	var float MomentumXScalar;
	var float MomentumYScalar;
	var float MomentumZScalar;
	var float AngularVelocityXScalar;
	var float AngularVelocityYScalar;
	var float AngularVelocityZScalar;
	var float PercentHealthToThrowBloks;
	var array<HaloDestructibleBlokData> BlokData;

	structdefaultproperties
	{
		bThrown=false
		LifeSpan=5.0000000
		RandomImpulseXScalar=0.0000000
		RandomImpulseYScalar=0.0000000
		RandomImpulseZScalar=0.0000000
		BreakImpulseXScalar=0.0000000
		BreakImpulseYScalar=0.0000000
		BreakImpulseZScalar=0.0000000
		MomentumXScalar=0.0010000
		MomentumYScalar=0.0010000
		MomentumZScalar=0.0010000
		AngularVelocityXScalar=0.0000000
		AngularVelocityYScalar=0.0000000
		AngularVelocityZScalar=0.0000000
		PercentHealthToThrowBloks=0.0000000
		BlokData=none
	}
};

var array<HaloDestructibleBlokWaveData> WaveData;
var name AkObjectType;
//var delegate<SortFunc> __SortFunc__Delegate;

function SortWaves()
{
	WaveData.Sort(SortFunc);
	//return;	
}

delegate int SortFunc(HaloDestructibleBlokWaveData A, HaloDestructibleBlokWaveData B)
{
	return ((A.PercentHealthToThrowBloks >= B.PercentHealthToThrowBloks) ? 1 : -1);
	//return ReturnValue;	
}

function bool TryToThrowBloks(SkeletalMeshComponent Mesh, Vector Momentum, float HP)
{
	local int indexToThrow;

	indexToThrow = GetIndexToThrow(HP);
	// End:0x5E
	if(indexToThrow != -1)
	{
		ThrowWave(indexToThrow, Mesh, Momentum, HP);
	}
	return indexToThrow != -1;
	//return ReturnValue;	
}

function ThrowWave(int indexToThrow, SkeletalMeshComponent Mesh, Vector Momentum, float HP)
{
	local int I;
	local Rotator Rotation;
	local Vector Location, bX, bY, bZ, X, Y,
		Z, Impulse, AngularVelocity;

	local HaloDestructibleBlok Blok;
	local HaloDestructibleBlokData BlokData;
	local HaloDestructibleBlokWaveData waveToThrow;

	waveToThrow = WaveData[indexToThrow];
	I = 0;
	J0x28:

	// End:0x90E [Loop If]
	if(I < waveToThrow.BlokData.Length)
	{
		BlokData = waveToThrow.BlokData[I];
		// End:0x172
		if((Mesh != none) && Mesh.MatchRefBone(BlokData.BoneName) != -1)
		{
			Location = Mesh.GetBoneLocation(BlokData.BoneName, 0);
			Rotation = QuatToRotator(Mesh.GetBoneQuaternion(BlokData.BoneName, 0));			
		}
		else
		{
			Location = Owner.Location;
			Rotation = Owner.Rotation;
		}
		Blok = RequestBlok(Mesh.LightEnvironment);
		// End:0x900
		if(Blok != none)
		{
			Blok.AkObjectType = AkObjectType;
			Blok.GotoState('Spawning');
			Blok.ExpirationTime = waveToThrow.LifeSpan;
			Blok.DestructibleOwner = Owner;
			Blok.StaticMeshComponent.SetLightEnvironment(Mesh.LightEnvironment);
			Blok.StaticMeshComponent.SetStaticMesh(BlokData.BlokMesh);
			Blok.StaticMeshComponent.SetRBPosition(Location);
			Blok.StaticMeshComponent.SetRBRotation(Rotation);
			// End:0x477
			if(BlokData.BlokFX != none)
			{
				Blok.ParticleComponent.SetTemplate(BlokData.BlokFX);
				Blok.ParticleComponent.ActivateSystem();
			}
			GetAxes(Rotation, bX, bY, bZ);
			X = (bX * RandRange(-1.0000000, 1.0000000)) * waveToThrow.RandomImpulseXScalar;
			Y = (bY * RandRange(-1.0000000, 1.0000000)) * waveToThrow.RandomImpulseYScalar;
			Z = (bZ * RandRange(0.0000000, 1.0000000)) * waveToThrow.RandomImpulseZScalar;
			X += (bX * waveToThrow.BreakImpulseXScalar);
			Y += (bY * waveToThrow.BreakImpulseYScalar);
			Z += (bZ * waveToThrow.BreakImpulseZScalar);
			X += ((bX * (Momentum Dot bX)) * waveToThrow.MomentumXScalar);
			Y += ((bY * (Momentum Dot bY)) * waveToThrow.MomentumYScalar);
			Z += ((bZ * (Momentum Dot bZ)) * waveToThrow.MomentumZScalar);
			Impulse = (X + Y) + Z;
			Blok.StaticMeshComponent.AddImpulse(Impulse);
			Blok.SetSwitch('Object_Type', AkObjectType);
			Blok.SetRTPCValue('Impulse_Value', 40.0000000);
			Blok.PlayAkEvent(AkEvent'Objects.Play_Object_Destroyed');
			AngularVelocity.X = RandRange(-1.0000000, 1.0000000) * waveToThrow.AngularVelocityXScalar;
			AngularVelocity.Y = RandRange(-1.0000000, 1.0000000) * waveToThrow.AngularVelocityYScalar;
			AngularVelocity.Z = RandRange(-1.0000000, 1.0000000) * waveToThrow.AngularVelocityZScalar;
			Blok.StaticMeshComponent.SetRBAngularVelocity(AngularVelocity, false);
		}
		I++;
		// [Loop Continue]
		goto J0x28;
	}
	WaveData[indexToThrow].bThrown = true;
	//return;	
}

function HaloDestructibleBlok RequestBlok(LightEnvironmentComponent LightEnv)
{
	local HaloGameDefault Game;
	local HaloDestructibleBlok HDB;

	Game = HaloGameDefault(Owner.WorldInfo.Game);
	// End:0x13A
	if(Game != none)
	{
		// End:0x13A
		if(Game.TheRAM != none)
		{
			HDB = HaloDestructibleBlok(Game.TheRAM.RequestActor(Class'MegaHaloGame.HaloDestructibleBlok', self));
			// End:0x130
			if((HDB != none) && LightEnv != none)
			{
				Game.TheRAM.AddComponentRef(LightEnv, HDB);
			}
			return HDB;
		}
	}
	return none;
	//return ReturnValue;	
}

function int GetIndexToThrow(float CurrentHP)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x9C [Loop If]
	if(I < WaveData.Length)
	{
		// End:0x8E
		if(WaveData[I].bThrown == false)
		{
			// End:0x8E
			if(CurrentHP <= WaveData[I].PercentHealthToThrowBloks)
			{
				return I;
			}
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	return -1;
	//return ReturnValue;	
}
