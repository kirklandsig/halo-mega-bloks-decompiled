class HaloDeployableWall extends Actor
	placeable
	implements(IHaloDeployable);

var archetype Actor WallArchetypeRef;
var int NumSections;
var float LengthPerSection;
var float PivotHeightOffset;
var array<HaloDestructibleActor> SpawnedWalls;
var bool bChildWallsAreHidden;
var byte TeamNum;
var HaloWeapon_TargetDesignator.ETargetDesignatorCategory DeployableCategory;
var name DeployableName;
var Actor DeployableBase;

simulated function PostBeginPlay()
{
	local Vector rightWorldspaceOffset, upWorldspaceOffset;
	local int I;
	local float offsetMult;
	local HaloDestructibleActor SpawnedWall;

	super.PostBeginPlay();
	rightWorldspaceOffset = vect(0.0000000, 0.0000000, 0.0000000);
	rightWorldspaceOffset.Y = LengthPerSection;
	rightWorldspaceOffset = rightWorldspaceOffset >> self.Rotation;
	upWorldspaceOffset = vect(0.0000000, 0.0000000, 0.0000000);
	upWorldspaceOffset.Z = PivotHeightOffset;
	// End:0x29A
	if((NumSections % 2) == 1)
	{
		SpawnedWall = HaloDestructibleActor(Spawn(WallArchetypeRef.Class, self,, self.Location + upWorldspaceOffset, self.Rotation, WallArchetypeRef, true));
		SpawnedWalls.AddItem(SpawnedWall);
		I = 0;
		J0x163:

		// End:0x297 [Loop If]
		if(I < (NumSections - 1))
		{
			// End:0x1B6
			if((I % 2) == 0)
			{
				offsetMult = 1.0000000 + (float(I) * 0.5000000);				
			}
			else
			{
				offsetMult = -1.0000000 + (float(I - 1) * 0.5000000);
			}
			SpawnedWall = HaloDestructibleActor(Spawn(WallArchetypeRef.Class, self,, (self.Location + (rightWorldspaceOffset * offsetMult)) + upWorldspaceOffset, self.Rotation, WallArchetypeRef, true));
			SpawnedWalls.AddItem(SpawnedWall);
			++I;
			// [Loop Continue]
			goto J0x163;
		}		
	}
	else
	{
		I = 0;
		J0x2A5:

		// End:0x3D6 [Loop If]
		if(I < NumSections)
		{
			// End:0x2F5
			if((I % 2) == 0)
			{
				offsetMult = 0.5000000 + (float(I) * 0.5000000);				
			}
			else
			{
				offsetMult = -0.5000000 + (float(I - 1) * 0.5000000);
			}
			SpawnedWall = HaloDestructibleActor(Spawn(WallArchetypeRef.Class, self,, (self.Location + (rightWorldspaceOffset * offsetMult)) + upWorldspaceOffset, self.Rotation, WallArchetypeRef, true));
			SpawnedWalls.AddItem(SpawnedWall);
			++I;
			// [Loop Continue]
			goto J0x2A5;
		}
	}
	//return;	
}

event Tick(float DeltaTime)
{
	local int I, liveChildWalls;

	// End:0x104
	if(bHidden != bChildWallsAreHidden)
	{
		I = 0;
		J0x24:

		// End:0xEF [Loop If]
		if(I < SpawnedWalls.Length)
		{
			// End:0xE1
			if((Children[I] != none) && Children[I].IsA(WallArchetypeRef.Class.Name))
			{
				Children[I].SetHidden(bHidden);
			}
			++I;
			// [Loop Continue]
			goto J0x24;
		}
		bChildWallsAreHidden = bHidden;
	}
	I = 0;
	J0x10F:

	// End:0x190 [Loop If]
	if(I < SpawnedWalls.Length)
	{
		// End:0x182
		if((SpawnedWalls[I] != none) && float(SpawnedWalls[I].Health) > 0.0000000)
		{
			liveChildWalls += 1;
		}
		++I;
		// [Loop Continue]
		goto J0x10F;
	}
	// End:0x1AE
	if(liveChildWalls == 0)
	{
		LifeSpan = -1.0000000;
	}
	//return;	
}

simulated event ScriptSetTeamNum(byte newTeamNum)
{
	local int I;

	TeamNum = newTeamNum;
	I = 0;
	J0x1E:

	// End:0xE8 [Loop If]
	if(I < Children.Length)
	{
		// End:0xDA
		if((Children[I] != none) && Children[I].IsA(WallArchetypeRef.Class.Name))
		{
			Children[I].SetTeamNum(newTeamNum);
		}
		++I;
		// [Loop Continue]
		goto J0x1E;
	}
	//return;	
}

simulated event byte ScriptGetTeamNum()
{
	return TeamNum;
	//return ReturnValue;	
}

function HaloWeapon_TargetDesignator.ETargetDesignatorCategory GetDeployableCategory()
{
	return DeployableCategory;
	//return ReturnValue;	
}

function SetDeployableCategory(HaloWeapon_TargetDesignator.ETargetDesignatorCategory newCategory)
{
	DeployableCategory = newCategory;
	//return;	
}

function name GetDeployableName()
{
	return DeployableName;
	//return ReturnValue;	
}

function SetDeployableName(name NewName)
{
	DeployableName = NewName;
	//return;	
}

function Actor GetDeployableBase()
{
	return DeployableBase;
	//return ReturnValue;	
}

function SetDeployableBase(Actor NewBase)
{
	DeployableBase = NewBase;
	//return;	
}

function Actor GetDeployable()
{
	return self;
	//return ReturnValue;	
}

function array< Class<HaloVCustomizationComponent> > GetCustomizations()
{
	local array< Class<HaloVCustomizationComponent> > returnArr;

	returnArr.Length = 0;
	return returnArr;
	//return ReturnValue;	
}

function SetCustomizations(array< Class<HaloVCustomizationComponent> > Customizations)
{
	//return;	
}

defaultproperties
{
	WallArchetypeRef=HaloDestructibleActor'UNSC_BlockWall_01.Wall_Archetype'
	NumSections=3
	LengthPerSection=145.0000000
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloDeployableWall.targetableComponent'
	begin object name="targetableComponent" class=UDKBase.UDKTargetableComponent
		InnerThreatRadius=2000.0000000
		OutterThreatRadius=5000.0000000
		AITargetType=HaloTargetType.TARGET_PASSIVE_SECONDARY
		bAITargetable=true
	end object
	Components[0]=targetableComponent
}