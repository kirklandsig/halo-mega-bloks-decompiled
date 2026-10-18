class HaloWeaponCloset extends Trigger
	abstract;

var private Class<HaloWeapon> WeaponType;
var private Class<HaloProjectile_Grenade> GrenadeType;
var private int NumberOfGrenades;
var private AkEvent ActivateSound;
var private AkEvent DeactivateSound;

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	local HaloPawn Pawn;
	local HaloPlayerInventoryManager InvManager;
	local HaloPlayerPawnController HPPController;

	Pawn = HaloPawn(Other);
	// End:0x1EC
	if(Pawn != none)
	{
		// End:0x108
		if(WeaponType != none)
		{
			InvManager = HaloPlayerInventoryManager(Pawn.InvManager);
			// End:0x108
			if(InvManager != none)
			{
				// End:0x108
				if(InvManager.RefillWeapon(WeaponType) == false)
				{
					HPPController = HaloPlayerPawnController(Pawn.Controller);
					// End:0x108
					if(HPPController != none)
					{
						HPPController.SetActiveWeaponCloset(self);
					}
				}
			}
		}
		// End:0x1C4
		if(GrenadeType != none)
		{
			// End:0x16F
			if(GrenadeType.Name == 'HaloProjectile_Grenade')
			{
				Pawn.AddFragGrenadesToInventory(NumberOfGrenades);				
			}
			else
			{
				// End:0x1C4
				if(GrenadeType.Name == 'HaloProjectile_PlasmaGrenade')
				{
					Pawn.AddPlasmaGrenadesToInventory(NumberOfGrenades);
				}
			}
		}
		// End:0x1EC
		if(ActivateSound != none)
		{
			PlayAkEvent(ActivateSound);
		}
	}
	//return;	
}

simulated event UnTouch(Actor Other)
{
	local HaloPawn Pawn;
	local HaloPlayerPawnController HPPController;

	Pawn = HaloPawn(Other);
	// End:0x8B
	if(Pawn != none)
	{
		HPPController = HaloPlayerPawnController(Pawn.Controller);
		// End:0x8B
		if(HPPController != none)
		{
			HPPController.SetActiveWeaponCloset(none);
		}
	}
	// End:0xB3
	if(DeactivateSound != none)
	{
		PlayAkEvent(DeactivateSound);
	}
	//return;	
}

function Class<HaloWeapon> GetWeaponType()
{
	return WeaponType;
	//return ReturnValue;	
}

defaultproperties
{
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloWeaponCloset.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__Trigger.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	// Reference: SpriteComponent'MegaHaloGame.Default__HaloWeaponCloset.Sprite'
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