class UTTeamStaticMesh extends StaticMeshActor;

var array<MaterialInterface> TeamMaterials;
var Material NeutralMaterial;

simulated event PreBeginPlay()
{
	local UTGameObjective O, Best;
	local float Distance, BestDistance;

	// End:0x11E
	if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		BestDistance = 1000000.0000000;
		// End:0xDF
		foreach WorldInfo.AllNavigationPoints(Class'UTGame.UTGameObjective', O)
		{
			Distance = VSize(Location - O.Location);
			// End:0xDE
			if(Distance < BestDistance)
			{
				BestDistance = Distance;
				Best = O;
			}			
		}		
		// End:0x112
		if(Best != none)
		{
			Best.AddTeamStaticMesh(self);			
		}
		else
		{
			SetTeamNum(255);
		}
	}
	//return;	
}

simulated event ScriptSetTeamNum(byte NewTeam)
{
	// End:0xCE
	if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		// End:0x96
		if(int(NewTeam) < TeamMaterials.Length)
		{
			// End:0x93
			if(TeamMaterials[int(NewTeam)] != none)
			{
				StaticMeshComponent.SetMaterial(0, TeamMaterials[int(NewTeam)]);
			}			
		}
		else
		{
			// End:0xCE
			if(NeutralMaterial != none)
			{
				StaticMeshComponent.SetMaterial(0, NeutralMaterial);
			}
		}
	}
	//return;	
}

defaultproperties
{
	TeamMaterials[0]=none
	TeamMaterials[1]=none
	// Reference: StaticMeshComponent'UTGame.Default__UTTeamStaticMesh.StaticMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'StaticMeshComponent0'
	// Archetype: StaticMeshComponent'Engine.Default__StaticMeshActor.StaticMeshComponent0'
	begin object name="StaticMeshComponent0"
		ReplacementPrimitive=none
	end object
	StaticMeshComponent=StaticMeshComponent0
	Components[0]=StaticMeshComponent0
	bStatic=false
	bTickIsDisabled=true
	CollisionComponent=StaticMeshComponent0
}