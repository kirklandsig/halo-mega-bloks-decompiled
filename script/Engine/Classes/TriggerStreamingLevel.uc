class TriggerStreamingLevel extends Trigger
	placeable;

struct LevelStreamingData
{
	var bool bShouldBeLoaded;
	var bool bShouldBeVisible;
	var bool bShouldBlockOnLoad;
	var LevelStreaming Level;

	structdefaultproperties
	{
		bShouldBeLoaded=false
		bShouldBeVisible=false
		bShouldBlockOnLoad=false
		Level=none
	}
};

var editinline array<editinline LevelStreamingData> Levels;

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	local PlayerController PlayerCon;
	local int Index;

	super.Touch(Other, OtherComp, HitLocation, HitNormal);
	Index = 0;
	J0x39:

	// End:0x2A6 [Loop If]
	if(Index < Levels.Length)
	{
		// End:0x1A4
		foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PlayerCon)
		{
			Levels[Index].Level.bShouldBlockOnLoad = Levels[Index].bShouldBlockOnLoad;
			PlayerCon.LevelStreamingStatusChanged(Levels[Index].Level, Levels[Index].bShouldBeLoaded, Levels[Index].bShouldBeVisible, Levels[Index].bShouldBlockOnLoad);			
		}		
		// End:0x298
		if(WorldInfo.Game != none)
		{
			WorldInfo.Game.LevelStreamingStatusChanged(Levels[Index].Level, Levels[Index].bShouldBeLoaded, Levels[Index].bShouldBeVisible, Levels[Index].bShouldBlockOnLoad);
		}
		Index++;
		// [Loop Continue]
		goto J0x39;
	}
	//return;	
}

defaultproperties
{
	// Reference: CylinderComponent'Engine.Default__TriggerStreamingLevel.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__Trigger.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	// Reference: SpriteComponent'Engine.Default__TriggerStreamingLevel.Sprite'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'Sprite'
	// Archetype: SpriteComponent'Engine.Default__Trigger.Sprite'
	begin object name="Sprite"
		ReplacementPrimitive=none
	end object
	Components[0]=Sprite
	Components[1]=CollisionCylinder
	CollisionComponent=CollisionCylinder
}