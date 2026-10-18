class HaloTrigger extends Trigger
	implements(HaloSaveInterface);

var bool Persisted;
var bool Enabled;

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	// End:0x3B
	if(Enabled)
	{
		super.Touch(Other, OtherComp, HitLocation, HitNormal);
	}
	//return;	
}

function JsonObject Serialize()
{
	local JsonObject Data;

	// End:0x11A
	if(Persisted)
	{
		LogInternal("SAVING: " $ string(self));
		Data = new Class'Engine.JsonObject';
		// End:0x117
		if(Data != none)
		{
			Data.SetStringValue("Name", PathName(self));
			Data.SetStringValue("ObjectArchetype", PathName(ObjectArchetype));
			Data.SetBoolValue("Enabled", Enabled);
			LogInternal((string(self) $ ": Saving Enabled to ") $ string(Enabled));
		}		
	}
	else
	{
		LogInternal("IGNORING: " $ string(self));
	}
	return Data;
	//return ReturnValue;	
}

function Deserialize(JsonObject Data)
{
	Enabled = Data.GetBoolValue("Enabled");
	LogInternal((string(self) $ ": Setting Enabled to ") $ string(Enabled));
	//return;	
}

defaultproperties
{
	Enabled=true
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloTrigger.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__Trigger.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	// Reference: SpriteComponent'MegaHaloGame.Default__HaloTrigger.Sprite'
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