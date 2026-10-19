class HaloPlayerGroup extends Actor
	notplaceable;

var array<HaloPlayerPawnController> PlayerControllers;

simulated function int GetMaxPlayerPawnHeatLevel()
{
	local int maxHeat, I, S;
	local UDKVehicle playerVehicle;
	local editinline UDKTargetableComponent targetableComponent;

	maxHeat = 0;
	I = 0;
	J0x16:

	// End:0x28A [Loop If]
	if(I < PlayerControllers.Length)
	{
		// End:0x27C
		if(PlayerControllers[I].Pawn != none)
		{
			playerVehicle = UDKVehicle(PlayerControllers[I].Pawn);
			// End:0x1DE
			if(playerVehicle != none)
			{
				S = 0;
				J0xB1:

				// End:0x1DE [Loop If]
				if(S < playerVehicle.Seats.Length)
				{
					// End:0x1D0
					if(playerVehicle.Seats[S].StoragePawn != none)
					{
						targetableComponent = UDKTargetableComponent(playerVehicle.Seats[S].StoragePawn.GetComponentOfType(Class'UDKBase.UDKTargetableComponent'));
						// End:0x1D0
						if(targetableComponent != none)
						{
							maxHeat = Max(int(targetableComponent.CurAIHeat), maxHeat);
						}
					}
					++S;
					// [Loop Continue]
					goto J0xB1;
				}
			}
			targetableComponent = UDKTargetableComponent(PlayerControllers[I].Pawn.GetComponentOfType(Class'UDKBase.UDKTargetableComponent'));
			// End:0x27C
			if(targetableComponent != none)
			{
				maxHeat = Max(int(targetableComponent.CurAIHeat), maxHeat);
			}
		}
		++I;
		// [Loop Continue]
		goto J0x16;
	}
	return maxHeat;
	//return ReturnValue;	
}

simulated function bool IsAnyNearbyEnemyAlertedToPlayerPresence()
{
	local int I;
	local float enemyTestRange;

	enemyTestRange = 3000.0000000;
	I = 0;
	J0x1A:

	// End:0x77 [Loop If]
	if(I < PlayerControllers.Length)
	{
		// End:0x69
		if(PlayerControllers[I].IsAlertedEnemyInRange(enemyTestRange))
		{
			return true;
		}
		++I;
		// [Loop Continue]
		goto J0x1A;
	}
	return false;
	//return ReturnValue;	
}

simulated function bool IsAnyPlayerCameraInEncounterMode()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0xB6 [Loop If]
	if(I < PlayerControllers.Length)
	{
		// End:0xA8
		if((HaloPlayerCamera(PlayerControllers[I].PlayerCamera) != none) && HaloPlayerCamera(PlayerControllers[I].PlayerCamera).IsEncounterModeActive())
		{
			return true;
		}
		++I;
		// [Loop Continue]
		goto J0x0B;
	}
	return false;
	//return ReturnValue;	
}

simulated function bool IsControllerInGroup(Controller C)
{
	local int I;

	I = 0;
	J0x0B:

	// End:0x54 [Loop If]
	if(I < PlayerControllers.Length)
	{
		// End:0x46
		if(PlayerControllers[I] == C)
		{
			return true;
		}
		++I;
		// [Loop Continue]
		goto J0x0B;
	}
	return false;
	//return ReturnValue;	
}

simulated function bool IsPawnInGroup(Pawn P)
{
	local int I;

	// End:0x78
	if(P != none)
	{
		I = 0;
		J0x1A:

		// End:0x78 [Loop If]
		if(I < PlayerControllers.Length)
		{
			// End:0x6A
			if(PlayerControllers[I].Pawn == P)
			{
				return true;
			}
			++I;
			// [Loop Continue]
			goto J0x1A;
		}
	}
	return false;
	//return ReturnValue;	
}

simulated function AddPlayerController(HaloPlayerPawnController HPPC)
{
	// End:0x3F
	if((HPPC != none) && !IsControllerInGroup(HPPC))
	{
		PlayerControllers.AddItem(HPPC);
	}
	//return;	
}

simulated function RemovePlayerController(HaloPlayerPawnController HPPC)
{
	local int I;

	// End:0x11
	if(HPPC == none)
	{
		return;
	}
	I = 0;
	J0x1C:

	// End:0x7A [Loop If]
	if(I < PlayerControllers.Length)
	{
		// End:0x6C
		if(PlayerControllers[I] == HPPC)
		{
			PlayerControllers.Remove(I, 1);
			return;
		}
		++I;
		// [Loop Continue]
		goto J0x1C;
	}
	//return;	
}

defaultproperties
{
	CollisionType=ECollisionType.COLLIDE_CustomDefault
}