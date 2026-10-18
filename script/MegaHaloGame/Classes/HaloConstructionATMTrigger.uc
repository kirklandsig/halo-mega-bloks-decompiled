class HaloConstructionATMTrigger extends Trigger;

var private export editinline SkeletalMeshComponent SkeletalMeshComponent;
var private array<HaloConstructionManager.EHaloConstructionTypes> BuyableTypeList;
var private HaloConstructionInventory StockPrimitives;
var private HaloConstructionManager CManager;

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	local HaloConstructionManager.EHaloConstructionTypes CType;
	local bool bFilled;

	// End:0x5F
	if(CManager != none)
	{
		// End:0x5E
		foreach BuyableTypeList(CType)
		{
			// End:0x5D
			if(CManager.IsBlueprintUnlockedFromType(CType))
			{
				bFilled = true;
			}			
		}		
	}
	// End:0x6F
	if(bFilled == false)
	{
	}
	//return;	
}

simulated event UnTouch(Actor Other)
{
	//return;	
}

simulated event PostBeginPlay()
{
	CManager = HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).GetConstructionManager();
	//return;	
}

defaultproperties
{
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloConstructionATMTrigger.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0" class=Engine.SkeletalMeshComponent
		ReplacementPrimitive=none
		CollideActors=true
		BlockActors=true
		BlockZeroExtent=true
		BlockNonZeroExtent=true
	end object
	SkeletalMeshComponent=SkeletalMeshComponent0
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloConstructionATMTrigger.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__Trigger.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	// Reference: SpriteComponent'MegaHaloGame.Default__HaloConstructionATMTrigger.Sprite'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'Sprite'
	// Archetype: SpriteComponent'Engine.Default__Trigger.Sprite'
	begin object name="Sprite"
		ReplacementPrimitive=none
	end object
	Components[0]=Sprite
	Components[1]=CollisionCylinder
	Components[2]=SkeletalMeshComponent0
	bHidden=false
	CollisionComponent=CollisionCylinder
}