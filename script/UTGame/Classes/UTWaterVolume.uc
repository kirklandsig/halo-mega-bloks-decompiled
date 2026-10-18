class UTWaterVolume extends WaterVolume;

var ParticleSystem PS_EnterWaterEffect_Pawn;
var ParticleSystem PS_EnterWaterEffect_Vehicle;
var ParticleSystem ProjectileEntryEffect;

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	local ParticleSystem PS_WaterEffect;
	local editinline ParticleSystemComponent PSC_WaterEffect;
	local float MaxSpeed, Vel, ParamValue;
	local Actor.EMoveDir MoveDir;
	local Vector ParticleVect;
	local UTPawn UTP;

	super.Touch(Other, OtherComp, HitLocation, HitNormal);
	// End:0x450
	if(((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && (WorldInfo.TimeSeconds - Other.LastRenderTime) < 0.2000000) && Pawn(Other) != none)
	{
		UTP = UTPawn(Other);
		// End:0x189
		if(UTP != none)
		{
			// End:0x13C
			if((int(UTP.Physics) == int(1)) || int(UTP.Physics) == int(3))
			{
				return;
			}
			PS_WaterEffect = PS_EnterWaterEffect_Pawn;
			ParamValue = 1.0000000;
			MaxSpeed = UTP.GroundSpeed;			
		}
		else
		{
			// End:0x1E8
			if(UTVehicle(Other) != none)
			{
				PS_WaterEffect = PS_EnterWaterEffect_Vehicle;
				MaxSpeed = UTVehicle(Other).GroundSpeed;				
			}
			else
			{
				PS_WaterEffect = PS_EnterWaterEffect_Vehicle;
				ParamValue = 1.0000000;
				MaxSpeed = Class'Engine.Pawn'.default.GroundSpeed;
			}
		}
		PSC_WaterEffect = WorldInfo.MyEmitterPool.SpawnEmitter(PS_WaterEffect, HitLocation, Rotator(HitNormal), self);
		// End:0x450
		if(PSC_WaterEffect != none)
		{
			MoveDir = Other.MovingWhichWay(Vel);
			// End:0x30A
			if(ParamValue == 0.0000000)
			{
				ParamValue = (5.0000000 * Vel) / MaxSpeed;
			}
			switch(MoveDir)
			{
				// End:0x347
				case 1:
					ParticleVect = vect(1.0000000, 0.0000000, 0.0000000) * ParamValue;
					// End:0x41F
					break;
				// End:0x371
				case 2:
					ParticleVect = vect(-1.0000000, 0.0000000, 0.0000000) * ParamValue;
					// End:0x41F
					break;
				// End:0x39B
				case 3:
					ParticleVect = vect(0.0000000, -1.0000000, 0.0000000) * ParamValue;
					// End:0x41F
					break;
				// End:0x3C5
				case 4:
					ParticleVect = vect(0.0000000, 1.0000000, 0.0000000) * ParamValue;
					// End:0x41F
					break;
				// End:0x3EF
				case 6:
					ParticleVect = vect(1.0000000, 0.0000000, 0.0000000) * ParamValue;
					// End:0x41F
					break;
				// End:0x419
				case 5:
					ParticleVect = vect(1.0000000, 0.0000000, 0.0000000) * ParamValue;
					// End:0x41F
					break;
				// End:0xFFFF
				default:
					// End:0x41F
					break;
					break;
			}
			PSC_WaterEffect.SetVectorParameter('Direction', ParticleVect);
		}
	}
	//return;	
}

simulated function PlayEntrySplash(Actor Other)
{
	// End:0x7F
	if(EntrySound != none)
	{
		Other.PlaySound(EntrySound);
		// End:0x7F
		if(Other.Instigator != none)
		{
			Other.MakeNoise(1.0000000);
		}
	}
	// End:0x1F9
	if(((((WorldInfo.bDropDetail! && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && Other.IsA('Projectile')) && Other.Instigator != none) && Other.Instigator.IsPlayerPawn()) && Other.Instigator.IsLocallyControlled())
	{
		WorldInfo.MyEmitterPool.SpawnEmitter(ProjectileEntryEffect, Other.Location, Rotator(vect(0.0000000, 0.0000000, 1.0000000)));
	}
	//return;	
}

defaultproperties
{
	PS_EnterWaterEffect_Pawn=ParticleSystem'Envy_Level_Effects_2.Vehicle_Water_Effects.P_Player_Water_Impact'
	PS_EnterWaterEffect_Vehicle=ParticleSystem'Envy_Level_Effects_2.Vehicle_Water_Effects.P_General_VH_Water_Impact'
	ProjectileEntryEffect=ParticleSystem'Envy_Effects.Particles.P_WP_Water_Splash_Small'
	TerminalVelocity=1500.0000000
	// Reference: BrushComponent'UTGame.Default__UTWaterVolume.BrushComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'BrushComponent0'
	// Archetype: BrushComponent'Engine.Default__WaterVolume.BrushComponent0'
	begin object name="BrushComponent0"
		ReplacementPrimitive=none
	end object
	BrushComponent=BrushComponent0
	Components[0]=BrushComponent0
	CollisionComponent=BrushComponent0
}