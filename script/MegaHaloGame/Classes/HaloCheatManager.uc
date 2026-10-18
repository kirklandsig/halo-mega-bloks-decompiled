class HaloCheatManager extends UTCheatManager within HaloPlayerPawnController
	config(Game);

struct HaloCheatManager_WeaponShortName
{
	var name ShortName;
	var Class<HaloWeapon> WeapClass;

	structdefaultproperties
	{
		ShortName="None"
		WeapClass=none
	}
};

struct HaloCheatManager_VehicleShortName
{
	var name ShortName;
	var name VehicleClassName;

	structdefaultproperties
	{
		ShortName="None"
		VehicleClassName="None"
	}
};

struct HaloCheatManager_CharacterPadShortName
{
	var name ShortName;
	var name ArchetypeName;

	structdefaultproperties
	{
		ShortName="None"
		ArchetypeName="None"
	}
};

var array<HaloCheatManager_WeaponShortName> WeaponShortNames;
var array<HaloCheatManager_VehicleShortName> VehicleShortNames;
var array<HaloCheatManager_CharacterPadShortName> CharacterPadShortNames;

exec function BigBucks()
{
	SetPCBank(9999, 0);
	SetPCBank(9999, 1);
	SetPCBank(9999, 2);
	SetPCBank(9999, 3);
	//return;	
}

exec function SetBank(int cash, optional int PlayerIndex)
{
	// End:0x33
	if(PlayerIndex != 0)
	{
		SetPCBank(cash, PlayerIndex - 1);		
	}
	else
	{
		SetPCBank(cash, 0);
		SetPCBank(cash, 1);
		SetPCBank(cash, 2);
		SetPCBank(cash, 3);
	}
	//return;	
}

exec function AddBank(int cash, optional int PlayerIndex)
{
	// End:0x33
	if(PlayerIndex != 0)
	{
		SetPCBank(cash, PlayerIndex - 1, true);		
	}
	else
	{
		SetPCBank(cash, 0, true);
		SetPCBank(cash, 1, true);
		SetPCBank(cash, 2, true);
		SetPCBank(cash, 3, true);
	}
	//return;	
}

function SetPCBank(int cash, int PlayerIndex, optional bool addToCurrent)
{
	local HaloPlayerPawnController PC;

	PC = GetPC(PlayerIndex);
	// End:0xB7
	if(PC != none)
	{
		// End:0x7A
		if(addToCurrent)
		{
			PC.BlokCollector.AddToBank(cash);			
		}
		else
		{
			PC.BlokCollector.Bank = cash;
		}
	}
	//return;	
}

exec function RefillInventory(optional int PlayerIndex)
{
	// End:0x29
	if(PlayerIndex != 0)
	{
		RefillPCInventory(PlayerIndex - 1);		
	}
	else
	{
		RefillPCInventory(0);
		RefillPCInventory(1);
		RefillPCInventory(2);
		RefillPCInventory(3);
	}
	//return;	
}

function RefillPCInventory(int PlayerIndex)
{
	local HaloPlayerPawnController PC;
	local HaloPawn HP;

	PC = GetPC(PlayerIndex);
	// End:0xCF
	if(PC != none)
	{
		HP = HaloPawn(PC.Pawn);
		// End:0xCF
		if(HP != none)
		{
			HP.AddFragGrenadesToInventory(10);
			HP.AddPlasmaGrenadesToInventory(10);
			HP.RefillAssaultRifle();
		}
	}
	//return;	
}

exec function Weapon GiveWeapon(string WeaponClassStr)
{
	local HaloPlayerInventoryManager invMgr;
	local HaloCheatManager_WeaponShortName weapShortName;
	local Class<HaloWeapon> WeapClass;

	// End:0x68
	if(WeaponClassStr == "list")
	{
		LogInternal("Weapon Names:");
		// End:0x65
		foreach WeaponShortNames(weapShortName)
		{
			LogInternal("* " $ string(weapShortName.ShortName));			
		}		
		return none;
	}
	invMgr = HaloPlayerInventoryManager(Outer.Pawn.InvManager);
	// End:0xD1
	if(invMgr == none)
	{
		return super(CheatManager).GiveWeapon(WeaponClassStr);
	}
	// End:0x142
	foreach WeaponShortNames(weapShortName)
	{
		// End:0x141
		if(Caps(string(weapShortName.ShortName)) == Caps(WeaponClassStr))
		{
			WeapClass = weapShortName.WeapClass;			
		}
		else
		{			
		}
	}	
	// End:0x182
	if(WeapClass == none)
	{
		WeapClass = Class<HaloWeapon>(DynamicLoadObject(WeaponClassStr, Class'Core.Class'));
	}
	// End:0x1BE
	if(WeapClass != none)
	{
		return invMgr.PickUpWeaponByClass(WeapClass, true);		
	}
	else
	{
		return super(CheatManager).GiveWeapon(WeaponClassStr);
	}
	//return ReturnValue;	
}

exec function Vehicle GiveVehicle(string vehicleClassStr)
{
	local HaloCheatManager_VehicleShortName vehicleEntry;
	local string vehicleClassNameToLookup;
	local Class<HaloVehicle> vehicleClassToSpawn;
	local HaloVehicle SpawnedVehicle;
	local Vector vehicleSpawnOffset;

	// End:0x8D
	if(vehicleClassStr == "list")
	{
		LogInternal("Vehicle Names: (will spawn in front of the player)");
		// End:0x8A
		foreach VehicleShortNames(vehicleEntry)
		{
			LogInternal("* " $ string(vehicleEntry.ShortName));			
		}		
		return none;
	}
	// End:0x100
	foreach VehicleShortNames(vehicleEntry)
	{
		// End:0xFF
		if(Caps(string(vehicleEntry.ShortName)) == Caps(vehicleClassStr))
		{
			vehicleClassNameToLookup = string(vehicleEntry.VehicleClassName);			
		}
		else
		{			
		}
	}	
	vehicleClassToSpawn = Class<HaloVehicle>(FindObject(vehicleClassNameToLookup, Class'Core.Class'));
	// End:0x304
	if(vehicleClassToSpawn != none)
	{
		vehicleSpawnOffset = Vector(Outer.Pawn.Rotation);
		vehicleSpawnOffset.Z = 0.0000000;
		vehicleSpawnOffset = Normal(vehicleSpawnOffset);
		vehicleSpawnOffset *= 600.0000000;
		vehicleSpawnOffset.Z = 100.0000000;
		SpawnedVehicle = Outer.Spawn(vehicleClassToSpawn,,, Outer.Pawn.Location + vehicleSpawnOffset, Outer.Pawn.Rotation,, true);
		// End:0x2C2
		if(SpawnedVehicle == none)
		{
			WarnInternal("Failed to spawn cheat vehicle");			
		}
		else
		{
			SpawnedVehicle.Mesh.WakeRigidBody();
			return SpawnedVehicle;
		}		
	}
	else
	{
		WarnInternal(("GiveVehicle couldn't resolve class " $ vehicleClassNameToLookup) $ " (doesn't exist, or isn't preloaded!)");
	}
	return none;
	//return ReturnValue;	
}

exec function Actor GiveCharacter(string charClassStr)
{
	local HaloCheatManager_CharacterPadShortName charEntry;
	local string charArchetypeToLookup;
	local Actor charArchetypeToSpawn, spawnedPad;
	local Vector SpawnOffset;

	// End:0x93
	if(charClassStr == "list")
	{
		LogInternal("Character Names: (pod will spawn in front of the player)");
		// End:0x90
		foreach CharacterPadShortNames(charEntry)
		{
			LogInternal("* " $ string(charEntry.ShortName));			
		}		
		return none;
	}
	// End:0x106
	foreach CharacterPadShortNames(charEntry)
	{
		// End:0x105
		if(Caps(string(charEntry.ShortName)) == Caps(charClassStr))
		{
			charArchetypeToLookup = string(charEntry.ArchetypeName);			
		}
		else
		{			
		}
	}	
	charArchetypeToSpawn = Actor(FindObject(charArchetypeToLookup, Class'Engine.Actor'));
	// End:0x2F5
	if(charArchetypeToSpawn != none)
	{
		SpawnOffset = Vector(Outer.Pawn.Rotation);
		SpawnOffset.Z = 0.0000000;
		SpawnOffset = Normal(SpawnOffset);
		SpawnOffset *= 350.0000000;
		SpawnOffset.Z = 0.0000000;
		spawnedPad = Outer.Spawn(charArchetypeToSpawn.Class,,, Outer.Pawn.Location + SpawnOffset, Outer.Pawn.Rotation, charArchetypeToSpawn, true);
		// End:0x2E8
		if(spawnedPad == none)
		{
			WarnInternal("Failed to spawn cheat character pad");
		}
		return spawnedPad;		
	}
	else
	{
		WarnInternal(("GiveCharacter couldn't resolve class " $ charArchetypeToLookup) $ " (doesn't exist, or isn't preloaded!)");
	}
	return none;
	//return ReturnValue;	
}

exec function KillAllEnemies()
{
	local Pawn candidatePawn;
	local byte myTeamNum;

	myTeamNum = Outer.GetTeamNum();
	// End:0x15E
	foreach Outer.WorldInfo.AllPawns(Class'Engine.Pawn', candidatePawn)
	{
		// End:0x15D
		if(((candidatePawn.Controller != none) && PlayerController(candidatePawn.Controller) == none) && int(candidatePawn.GetTeamNum()) != int(myTeamNum))
		{
			candidatePawn.TakeDamage(1000000, Outer, candidatePawn.Location, vect(0.0000000, 0.0000000, 1.0000000), Class'Engine.DmgType_Crushed');
		}		
	}	
	//return;	
}

exec function ToggleFallingSaves()
{
	Outer.bTeleportToBreadcrumbOnFall = Outer.bTeleportToBreadcrumbOnFall!;
	//return;	
}

function HaloPlayerPawnController GetPC(int PlayerIndex)
{
	local HaloPlayerPawnController PC;
	local LocalPlayer LP;

	// End:0xE1
	foreach Class'Engine.WorldInfo'.static.GetWorldInfo().AllControllers(Class'MegaHaloGame.HaloPlayerPawnController', PC)
	{
		LP = LocalPlayer(PC.Player);
		// End:0xE0
		if(LP != none)
		{
			// End:0xE0
			if(PlayerIndex == Class'Engine.UIInteraction'.static.GetPlayerIndex(LP.ControllerId))
			{				
				return PC;
			}
		}		
	}	
	return none;
	//return ReturnValue;	
}

exec function WriteSaveGame()
{
	local array<byte> SaveData;
	local int Index;

	LogInternal("Calling WriteSaveGameData");
	SaveData.Length = 10;
	Index = 0;
	J0x36:

	// End:0x73 [Loop If]
	if(Index < 10)
	{
		SaveData[Index] = byte(Index);
		Index++;
		// [Loop Continue]
		goto J0x36;
	}
	// End:0x25A
	if(Outer.OnlineSub != none)
	{
		// End:0x25A
		if(NotEqual_InterfaceInterface(Outer.OnlineSub.ContentInterface, OnlineContentInterface(none)))
		{
			Outer.OnlineSub.ContentInterface.DeleteSaveGame(0, Outer.GetDeviceId(), "Test Data", "TestData.dat");
			Outer.OnlineSub.ContentInterface.AddWriteSaveGameDataComplete(0, OnWriteSaveGameDataComplete);
			Outer.OnlineSub.ContentInterface.WriteSaveGameData(0, Outer.GetDeviceId(), "Test Data", "TestData.dat", "TestSave1", SaveData);
		}
	}
	//return;	
}

function OnWriteSaveGameDataComplete(bool bWasSuccessful, byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName)
{
	// End:0x195
	if(Outer.OnlineSub != none)
	{
		// End:0x195
		if(NotEqual_InterfaceInterface(Outer.OnlineSub.ContentInterface, OnlineContentInterface(none)))
		{
			Outer.OnlineSub.ContentInterface.ClearWriteSaveGameDataComplete(0, OnWriteSaveGameDataComplete);
			LogInternal((((((((((("Write was successful " $ string(bWasSuccessful)) $ " for user ") $ string(LocalUserNum)) $ " on device ") $ string(DeviceID)) $ " for package ") $ FriendlyName) $ " with file ") $ Filename) $ " and save file ") $ SaveFileName);
			// End:0x195
			if(bWasSuccessful)
			{
				ReadSaveGame();
			}
		}
	}
	//return;	
}

exec function ReadSaveGame()
{
	LogInternal("Calling ReadSaveGameData");
	Outer.OnlineSub.ContentInterface.AddReadSaveGameDataComplete(0, OnReadSaveGameDataComplete);
	Outer.OnlineSub.ContentInterface.ReadSaveGameData(0, Outer.GetDeviceId(), "Test Data", "TestData.dat", "TestSave1");
	//return;	
}

function OnReadSaveGameDataComplete(bool bWasSuccessful, byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName)
{
	local array<byte> SaveData;
	local int Index;
	local byte bIsValid;

	// End:0x300
	if(Outer.OnlineSub != none)
	{
		// End:0x300
		if(NotEqual_InterfaceInterface(Outer.OnlineSub.ContentInterface, OnlineContentInterface(none)))
		{
			Outer.OnlineSub.ContentInterface.ClearReadSaveGameDataComplete(0, OnReadSaveGameDataComplete);
			LogInternal((((((((((("Read was successful " $ string(bWasSuccessful)) $ " for user ") $ string(LocalUserNum)) $ " on device ") $ string(DeviceID)) $ " for package ") $ FriendlyName) $ " with file ") $ Filename) $ " and save file ") $ SaveFileName);
			Outer.OnlineSub.ContentInterface.GetSaveGameData(LocalUserNum, DeviceID, FriendlyName, Filename, SaveFileName, bIsValid, SaveData);
			LogInternal("SaveData bIsValid = " $ string(bool(bIsValid)));
			LogInternal("SaveData.Length = " $ string(SaveData.Length));
			Index = 0;
			J0x25E:

			// End:0x2B2 [Loop If]
			if(Index < SaveData.Length)
			{
				LogInternal("SaveData[Index] = " $ string(SaveData[Index]));
				Index++;
				// [Loop Continue]
				goto J0x25E;
			}
			Outer.OnlineSub.ContentInterface.ClearContentList(0, 1);
		}
	}
	//return;	
}

exec function DeleteSaveGame()
{
	LogInternal("Calling DeleteSaveGameData");
	Outer.OnlineSub.ContentInterface.DeleteSaveGame(0, Outer.GetDeviceId(), "Test Data", "TestData.dat");
	//return;	
}

defaultproperties
{
	WeaponShortNames[0]=(ShortName="AssaultRifle",WeapClass=Class'MegaHaloGame.HaloWeapon_AssaultRifle')
	WeaponShortNames[1]=(ShortName="BattleRifle",WeapClass=Class'MegaHaloGame.HaloWeapon_BattleRifle')
	WeaponShortNames[2]=(ShortName="Carbine",WeapClass=Class'MegaHaloGame.HaloWeapon_Carbine')
	WeaponShortNames[3]=(ShortName="EnergySword",WeapClass=Class'MegaHaloGame.HaloWeapon_EnergySword_Content')
	WeaponShortNames[4]=(ShortName="FuelRodCannon",WeapClass=Class'MegaHaloGame.HaloWeapon_FuelRodCannon')
	WeaponShortNames[5]=(ShortName="Needler",WeapClass=Class'MegaHaloGame.HaloWeapon_Needler')
	WeaponShortNames[6]=(ShortName="PlasmaPistol",WeapClass=Class'MegaHaloGame.HaloWeapon_Pistol')
	WeaponShortNames[7]=(ShortName="Shotgun",WeapClass=Class'MegaHaloGame.HaloWeapon_Shotgun')
	WeaponShortNames[8]=(ShortName="StormRifle",WeapClass=Class'MegaHaloGame.HaloWeapon_StormRifle')
	WeaponShortNames[9]=(ShortName="UnscPistol",WeapClass=Class'MegaHaloGame.HaloWeapon_UnscPistol')
	WeaponShortNames[10]=(ShortName="RocketLauncher",WeapClass=Class'MegaHaloGame.HaloWeapon_UnscRocketLauncher_Content')
	VehicleShortNames[0]=(ShortName="Warthog",VehicleClassName="MegaHaloGameContent.HaloVehicle_ArcadeWartHog_Content")
	VehicleShortNames[1]=(ShortName="Mongoose",VehicleClassName="MegaHaloGameContent.HaloVehicle_ArcadeMongoose_Content")
	VehicleShortNames[2]=(ShortName="Scorpion",VehicleClassName="MegaHaloGameContent.HaloVehicle_ArcadeScorpion_Content")
	VehicleShortNames[3]=(ShortName="Ghost",VehicleClassName="MegaHaloGameContent.HaloVehicle_Ghost_Content")
	VehicleShortNames[4]=(ShortName="343_Warthog1",VehicleClassName="MegaHaloGameContent.Testhog_v1")
	VehicleShortNames[5]=(ShortName="343_Warthog2",VehicleClassName="MegaHaloGameContent.Testhog_v2")
	VehicleShortNames[6]=(ShortName="343_Warthog3",VehicleClassName="MegaHaloGameContent.Testhog_v3")
	VehicleShortNames[7]=(ShortName="SEP_Warthog",VehicleClassName="MegaHaloGameContent.HaloVehicle_SEP_WartHog_Content")
	CharacterPadShortNames[0]=(ShortName="Soldier",ArchetypeName="PlayerClasses.HaloPersonnelPod_Soldier")
	CharacterPadShortNames[1]=(ShortName="Scout",ArchetypeName="PlayerClasses.HaloPersonnelPod_Scout")
	CharacterPadShortNames[2]=(ShortName="Engineer",ArchetypeName="PlayerClasses.HaloPersonnelPod_Engineer")
}