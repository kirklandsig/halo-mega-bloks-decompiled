class HaloRespawnVolume extends Volume;

var HaloPlayerSpawnPoint RespawnPoint;

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	local HaloGameDefault haloGame;
	local Pawn toucherPawn;

	haloGame = HaloGameDefault(WorldInfo.Game);
	toucherPawn = Pawn(Other);
	// End:0x20C
	if((((haloGame != none) && toucherPawn != none) && toucherPawn.Controller != none) && toucherPawn.Controller.bIsPlayer)
	{
		// End:0x189
		if(RespawnPoint != none)
		{
			haloGame.CurrentRespawnPoint = RespawnPoint;
			LogInternal((("HaloRespawnVolume::Touched by " $ string(Other.Name)) $ " and set respawn point: ") $ string(RespawnPoint.Name));			
		}
		else
		{
			WarnInternal(((("HaloRespawnVolume " $ string(self.Name)) $ " (") $ string(self.Outer.Name)) $ ") has no RespawnPoint set!");
		}
	}
	//return;	
}

defaultproperties
{
	// Reference: BrushComponent'MegaHaloGame.Default__HaloRespawnVolume.BrushComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'BrushComponent0'
	// Archetype: BrushComponent'Engine.Default__Volume.BrushComponent0'
	begin object name="BrushComponent0"
		ReplacementPrimitive=none
	end object
	BrushComponent=BrushComponent0
	Components[0]=BrushComponent0
	CollisionComponent=BrushComponent0
}