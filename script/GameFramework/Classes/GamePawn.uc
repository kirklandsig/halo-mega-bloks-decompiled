class GamePawn extends GwNavPawn
	abstract
	native
	nativereplication
	config(Game);

var transient bool bLastHitWasHeadShot;
var bool bRespondToExplosions;

replication
{
	// Pos:0x000
	if(int(Role) == int(ROLE_Authority))
		bLastHitWasHeadShot;
}

simulated event UpdateShadowSettings(bool bInWantShadow)
{
	local bool bNewCastShadow, bNewCastDynamicShadow;

	// End:0x16F
	if(Mesh != none)
	{
		bNewCastShadow = default.Mesh.CastShadow && bInWantShadow;
		bNewCastDynamicShadow = default.Mesh.bCastDynamicShadow && bInWantShadow;
		// End:0x16F
		if((bNewCastShadow != Mesh.CastShadow) || bNewCastDynamicShadow != Mesh.bCastDynamicShadow)
		{
			Mesh.CastShadow = bNewCastShadow;
			Mesh.bCastDynamicShadow = bNewCastDynamicShadow;
			// End:0x165
			if(WorldInfo.bAggressiveLOD == true)
			{
				ReattachMesh();				
			}
			else
			{
				ReattachMeshWithoutBeingSeen();
			}
		}
	}
	//return;	
}

simulated function ReattachMesh()
{
	ClearTimer('ReattachMeshWithoutBeingSeen');
	ReattachComponent(Mesh);
	//return;	
}

simulated function ReattachMeshWithoutBeingSeen()
{
	// End:0x54
	if(LastRenderTime > (WorldInfo.TimeSeconds - 1.0000000))
	{
		SetTimer(0.5000000 + (FRand() * 0.5000000), false, 'ReattachMeshWithoutBeingSeen');		
	}
	else
	{
		ReattachMesh();
	}
	//return;	
}

defaultproperties
{
	// Reference: GwNavBotHandle'GameFramework.Default__GamePawn.myGwNavBotHandle'
	// Archetype: GwNavBotHandle'GwNavEngine.Default__GwNavPawn.myGwNavBotHandle'
	begin object name="myGwNavBotHandle"
	end object
	myGwNavHandle=myGwNavBotHandle
	// Reference: CylinderComponent'GameFramework.Default__GamePawn.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'GwNavEngine.Default__GwNavPawn.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	Components[0]=none
	Components[1]=CollisionCylinder
	Components[2]=none
	Components[3]=myGwNavBotHandle
	bCanBeAdheredTo=true
	bCanBeFrictionedTo=true
	CollisionComponent=CollisionCylinder
}