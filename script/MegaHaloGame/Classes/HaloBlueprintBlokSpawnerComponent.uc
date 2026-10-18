class HaloBlueprintBlokSpawnerComponent extends ActorComponent;

struct EPrimitiveData
{
	var HaloConstructionManager.EHaloConstructionPrimitiveTypes Type;
	var int Count;
	var float ImpulseXScalar;
	var float ImpulseYScalar;
	var float ImpulseZScalar;
	var float AngularVelocityXScalar;
	var float AngularVelocityYScalar;
	var float AngularVelocityZScalar;

	structdefaultproperties
	{
		Type=EHaloConstructionPrimitiveTypes.HCP_None
		Count=0
		ImpulseXScalar=75.0000000
		ImpulseYScalar=75.0000000
		ImpulseZScalar=200.0000000
		AngularVelocityXScalar=1.0000000
		AngularVelocityYScalar=1.0000000
		AngularVelocityZScalar=1.0000000
	}
};

var array<EPrimitiveData> PartsToSpawn;

function ThrowBloks()
{
	local int I, J;
	local Vector Impulse, AngularVelocity;
	local HaloBlueprintBlok Blok;
	local StaticMesh BlokStaticMesh;
	local HaloGameDefault Game;
	local HaloPlayerPawnController PC;

	Game = HaloGameDefault(Owner.WorldInfo.Game);
	// End:0x5E9
	if((Game != none) && Owner != none)
	{
		// End:0x5E8
		foreach Game.TheMainPlayerGroup.PlayerControllers(PC)
		{
			// End:0x5E7
			if(((PC != none) && PC.Pawn != none) && PC.BlokCollector != none)
			{
				I = 0;
				J0x10D:

				// End:0x5E7 [Loop If]
				if(I < PartsToSpawn.Length)
				{
					BlokStaticMesh = GetStaticMeshByPrimitiveType(PartsToSpawn[I].Type);
					// End:0x5D9
					if(BlokStaticMesh != none)
					{
						J = 0;
						J0x179:

						// End:0x5D9 [Loop If]
						if(J < PartsToSpawn[I].Count)
						{
							Blok = RequestBlok();
							// End:0x5CB
							if(Blok != none)
							{
								Blok.GotoState('Spawning');
								Blok.StaticMeshComponent.SetStaticMesh(BlokStaticMesh);
								Blok.Pawn = PC.Pawn;
								Blok.Collector = PC.BlokCollector;
								Blok.StaticMeshComponent.SetRBPosition(Owner.Location);
								Blok.StaticMeshComponent.SetRBRotation(RotRand());
								Impulse.X = RandRange(-1.0000000, 1.0000000) * PartsToSpawn[I].ImpulseXScalar;
								Impulse.Y = RandRange(-1.0000000, 1.0000000) * PartsToSpawn[I].ImpulseYScalar;
								Impulse.Z = RandRange(0.9000000, 1.0000000) * PartsToSpawn[I].ImpulseZScalar;
								Blok.StaticMeshComponent.AddImpulse(Impulse);
								AngularVelocity.X = RandRange(-1.0000000, 1.0000000) * PartsToSpawn[I].AngularVelocityXScalar;
								AngularVelocity.Y = RandRange(-1.0000000, 1.0000000) * PartsToSpawn[I].AngularVelocityYScalar;
								AngularVelocity.Z = RandRange(-1.0000000, 1.0000000) * PartsToSpawn[I].AngularVelocityZScalar;
								Blok.StaticMeshComponent.SetRBAngularVelocity(AngularVelocity, false);
							}
							J++;
							// [Loop Continue]
							goto J0x179;
						}
					}
					I++;
					// [Loop Continue]
					goto J0x10D;
				}
			}			
		}		
	}
	//return;	
}

function HaloBlueprintBlok RequestBlok()
{
	local HaloGameDefault Game;

	Game = HaloGameDefault(Owner.WorldInfo.Game);
	// End:0xC1
	if(Game != none)
	{
		// End:0xC1
		if(Game.TheRAM != none)
		{
			return HaloBlueprintBlok(Game.TheRAM.RequestActor(Class'MegaHaloGame.HaloBlueprintBlok', self));
		}
	}
	return none;
	//return ReturnValue;	
}

function StaticMesh GetStaticMeshByPrimitiveType(HaloConstructionManager.EHaloConstructionPrimitiveTypes Type)
{
	switch(Type)
	{
		// End:0x18
		case 0:
		// End:0x27
		case 1:
			return StaticMesh'Bridge_Collect_Shapes.Bridge_Square_Collect';
		// End:0x36
		case 2:
			return StaticMesh'Bridge_Collect_Shapes.Bridge_Pyramid_Collect';
		// End:0x3B
		case 4:
		// End:0x4A
		case 6:
			return StaticMesh'Bridge_Collect_Shapes.Bridge_Ramp_Collect';
		// End:0x4F
		case 3:
		// End:0x5E
		case 5:
			return StaticMesh'Bridge_Collect_Shapes.Bridge_Cylinder_Collect';
		// End:0xFFFF
		default:
			// End:0x64
			break;
			break;
	}
	return none;
	//return ReturnValue;	
}
