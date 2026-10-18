class HaloCollectibleBlokSpawnerComponent extends ActorComponent;

struct HaloCollectibleBlokData
{
	var int Value;
	var array< Class<HaloCollectibleBlok> > Bloks;

	structdefaultproperties
	{
		Value=0
		Bloks=none
	}
};

struct HaloCollectibleBlokWaveData
{
	var bool bThrown;
	var float PercentHealthToThrowBloks;
	var int MinTotalValue;
	var int MaxTotalValue;

	structdefaultproperties
	{
		bThrown=false
		PercentHealthToThrowBloks=0.0000000
		MinTotalValue=5
		MaxTotalValue=15
	}
};

var float ImpulseXScalar;
var float ImpulseYScalar;
var float ImpulseZScalar;
var float AngularVelocityXScalar;
var float AngularVelocityYScalar;
var float AngularVelocityZScalar;
var array<HaloCollectibleBlokWaveData> WaveData;
var array<HaloCollectibleBlokData> CollectibleBlokData;

function TryToThrowBloks(float HP)
{
	local int indexToThrow;

	indexToThrow = GetWaveIndexToThrow(HP);
	// End:0x73
	if(indexToThrow != -1)
	{
		J0x30:

		ThrowWave(indexToThrow);
		indexToThrow = GetWaveIndexToThrow(HP);
		// End:0x30
		if(!(indexToThrow == -1))
			goto J0x30;
	}
	//return;	
}

function ThrowWave(int indexToThrow)
{
	local int minValueToThrow, maxValueToThrow, totalValueToThrow;
	local HaloCollectibleBlokWaveData waveToThrow;

	waveToThrow = WaveData[indexToThrow];
	minValueToThrow = waveToThrow.MinTotalValue;
	maxValueToThrow = waveToThrow.MaxTotalValue;
	totalValueToThrow = minValueToThrow + Rand(maxValueToThrow - minValueToThrow);
	ThrowBloks(totalValueToThrow);
	WaveData[indexToThrow].bThrown = true;
	//return;	
}

function ThrowBloks(int Amount)
{
	local Vector Impulse, AngularVelocity;
	local HaloCollectibleBlok Blok;
	local HaloCollectibleBlokData BlokData;
	local Class<HaloCollectibleBlok> BlokClass;

	// End:0x3A6
	if(Owner != none)
	{
		J0x0F:

		// End:0x3A6 [Loop If]
		if(Amount != 0)
		{
			BlokData = GetBlokDataByMaxValue(Amount);
			BlokClass = GetRandomBlokClass(BlokData);
			Blok = RequestBlok(BlokClass);
			// End:0x37C
			if(Blok != none)
			{
				Blok.GotoState('Spawning');
				Blok.Value = BlokData.Value;
				Blok.StaticMeshComponent.SetRBPosition(Owner.CollisionComponent.Bounds.Origin);
				Blok.StaticMeshComponent.SetRBRotation(RotRand());
				Impulse.X = RandRange(-1.0000000, 1.0000000) * ImpulseXScalar;
				Impulse.Y = RandRange(-1.0000000, 1.0000000) * ImpulseYScalar;
				Impulse.Z = RandRange(0.9000000, 1.0000000) * ImpulseZScalar;
				Blok.StaticMeshComponent.AddImpulse(Impulse);
				AngularVelocity.X = RandRange(-1.0000000, 1.0000000) * AngularVelocityXScalar;
				AngularVelocity.Y = RandRange(-1.0000000, 1.0000000) * AngularVelocityYScalar;
				AngularVelocity.Z = RandRange(-1.0000000, 1.0000000) * AngularVelocityZScalar;
				Blok.StaticMeshComponent.SetRBAngularVelocity(AngularVelocity, false);
			}
			Amount -= BlokData.Value;
			// [Loop Continue]
			goto J0x0F;
		}
	}
	//return;	
}

function HaloCollectibleBlok RequestBlok(Class<HaloCollectibleBlok> BlokType)
{
	local HaloGameDefault Game;

	Game = HaloGameDefault(Owner.WorldInfo.Game);
	// End:0xC1
	if(Game != none)
	{
		// End:0xC1
		if(Game.TheRAM != none)
		{
			return HaloCollectibleBlok(Game.TheRAM.RequestActor(BlokType, self));
		}
	}
	return none;
	//return ReturnValue;	
}

function int GetWaveIndexToThrow(float Health)
{
	local int I, indexToThrow;
	local float Found, maxFound;

	indexToThrow = -1;
	maxFound = -1000.0000000;
	I = 0;
	J0x29:

	// End:0x100 [Loop If]
	if(I < WaveData.Length)
	{
		// End:0xF2
		if(WaveData[I].bThrown == false)
		{
			Found = WaveData[I].PercentHealthToThrowBloks;
			// End:0xF2
			if(Health <= Found)
			{
				// End:0xF2
				if(Found > maxFound)
				{
					maxFound = Found;
					indexToThrow = I;
				}
			}
		}
		I++;
		// [Loop Continue]
		goto J0x29;
	}
	return indexToThrow;
	//return ReturnValue;	
}

function HaloCollectibleBlokData GetRandomBlokData(int MaxValue)
{
	local int I, maxIndex, randIndex;

	I = 0;
	J0x0B:

	// End:0x7E [Loop If]
	if(I < CollectibleBlokData.Length)
	{
		// End:0x6D
		if(CollectibleBlokData[I].Value <= MaxValue)
		{
			maxIndex = I;			
		}
		else
		{
			// [Explicit Break]
			goto J0x7E;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	J0x7E:

	randIndex = Rand(maxIndex + 1);
	return CollectibleBlokData[randIndex];
	//return ReturnValue;	
}

function HaloCollectibleBlokData GetBlokDataByMaxValue(int MaxValue)
{
	local int I, maxIndex;

	I = 0;
	J0x0B:

	// End:0x7E [Loop If]
	if(I < CollectibleBlokData.Length)
	{
		// End:0x6D
		if(CollectibleBlokData[I].Value <= MaxValue)
		{
			maxIndex = I;			
		}
		else
		{
			// [Explicit Break]
			goto J0x7E;
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	J0x7E:

	return CollectibleBlokData[maxIndex];
	//return ReturnValue;	
}

function Class<HaloCollectibleBlok> GetRandomBlokClass(HaloCollectibleBlokData BlokData)
{
	local int I;

	I = Rand(BlokData.Bloks.Length);
	return BlokData.Bloks[I];
	//return ReturnValue;	
}

defaultproperties
{
	ImpulseXScalar=25.0000000
	ImpulseYScalar=25.0000000
	ImpulseZScalar=100.0000000
	AngularVelocityXScalar=1.0000000
	AngularVelocityYScalar=1.0000000
	AngularVelocityZScalar=1.0000000
	CollectibleBlokData[0]=(Value=1,Bloks=(Class'MegaHaloGame.HaloCollectibleBlok_1Peg_Std_Bronze'))
	CollectibleBlokData[1]=(Value=5,Bloks=(Class'MegaHaloGame.HaloCollectibleBlok_1Peg_Std_Silver'))
	CollectibleBlokData[2]=(Value=10,Bloks=(Class'MegaHaloGame.HaloCollectibleBlok_1Peg_Std_Gold'))
}