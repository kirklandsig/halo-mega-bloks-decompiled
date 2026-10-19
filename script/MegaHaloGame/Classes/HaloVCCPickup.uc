class HaloVCCPickup extends HaloDroppedItemPickup;

var export editinline SkeletalMeshComponent FloatingMeshComponent;
var export editinline ParticleSystemComponent FloatingParticlesComponent;
var AnimNodeSlot FloatingAnimNode;
var name FloatingAnimNodeName;
var ParticleSystem PickedUpEffect;
var name FloatingAnimName;
var name ReceiverControllerClass;
var archetype HaloVCustomizationComponent CustomizationPickupArchetype;
var Class<HaloVCustomizationComponent> CustomizationPickupClass;

function DroppedFrom(Pawn P)
{
	//return;	
}

function PostBeginPlay()
{
	super(UTDroppedItemPickup).PostBeginPlay();
	SetPickupMesh(FloatingMeshComponent);
	SetPickupParticles(FloatingParticlesComponent);
	//return;	
}

function Destroyed()
{
	super(UTDroppedItemPickup).Destroyed();
	//return;	
}

function GiveTo(Pawn P)
{
	local GFxHaloHUD HUD;
	local HaloPlayerPawnController PC;
	local string LocalizedMessage, UnlockStringID;

	PC = HaloPlayerPawnController(P.Controller);
	// End:0x212
	if(PC != none)
	{
		HUD = GFxHaloHUD(PC.myHUD);
		// End:0x212
		if(HUD != none)
		{
			// End:0x212
			if(HUD.HudMovie != none)
			{
				// End:0xDE
				if(CustomizationPickupArchetype != none)
				{
					UnlockStringID = CustomizationPickupArchetype.UnlockStringID;					
				}
				else
				{
					// End:0x115
					if(CustomizationPickupClass != none)
					{
						UnlockStringID = CustomizationPickupClass.default.UnlockStringID;
					}
				}
				LocalizedMessage = ((UnlockStringID == "") ? "" : Localize("HaloVehicle", UnlockStringID, "MegaHaloGame"));
				HUD.HudMovie.ShowGameMessage(LocalizedMessage, "", 2.0000000);
				WorldInfo.MyEmitterPool.SpawnEmitter(PickedUpEffect, Location, Rotation, self);
				PlayAkEvent(AkEvent'UIHUD.Play_UI_HUD_Pickup_Upgrade');
			}
		}
	}
	HaloGameDefault(Class'Engine.WorldInfo'.static.GetWorldInfo().Game).TheCustomizationManager.UnlockUpgrade(CustomizationPickupArchetype, CustomizationPickupClass);
	PickedUpBy(P);
	//return;	
}

function float BotDesireability(Pawn Bot, Controller C)
{
	return MaxDesireability;
	//return ReturnValue;	
}

function PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	// End:0xA4
	if(SkelComp == FloatingMeshComponent)
	{
		// End:0xA4
		if(FloatingAnimNodeName != 'None')
		{
			FloatingAnimNode = AnimNodeSlot(FloatingMeshComponent.FindAnimNode(FloatingAnimNodeName));
			FloatingAnimNode.PlayCustomAnim(FloatingAnimName, 1.0000000, 0.0000000, 0.0000000, true);
		}
	}
	//return;	
}

auto state Pickup
{
	function bool ValidTouch(Pawn Other)
	{
		return (Other.Controller != none) && Other.Controller.IsA(ReceiverControllerClass);
		//return ReturnValue;		
	}
	stop;	
}

defaultproperties
{
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloVCCPickup.FloatingMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'FloatingMeshComponent0'
	begin object name="FloatingMeshComponent0" class=Engine.SkeletalMeshComponent
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloVCCPickup.DroppedPickupLightEnvironment'
		MaxDrawDistance=20000.0000000
		CachedMaxDrawDistance=20000.0000000
		CastShadow=false
		bForceDirectLightMap=true
		bCastDynamicShadow=false
		CanBlockCamera=false
		bBlockFootPlacement=false
	end object
	FloatingMeshComponent=FloatingMeshComponent0
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloVCCPickup.FloatingParticlesComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'FloatingParticlesComponent0'
	begin object name="FloatingParticlesComponent0" class=Engine.ParticleSystemComponent
		bAutoActivate=false
		ReplacementPrimitive=none
		MaxDrawDistance=20000.0000000
		CachedMaxDrawDistance=20000.0000000
	end object
	FloatingParticlesComponent=FloatingParticlesComponent0
	FloatingAnimNodeName="FullBodySlot"
	FloatingAnimName="Winch_Medallion_MM"
	ReceiverControllerClass="HaloPlayerPawnController"
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloVCCPickup.DroppedPickupLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'DroppedPickupLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloDroppedItemPickup.DroppedPickupLightEnvironment'
	begin object name="DroppedPickupLightEnvironment"
	end object
	MyLightEnvironment=DroppedPickupLightEnvironment
	Components[0]=none
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloVCCPickup.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'MegaHaloGame.Default__HaloDroppedItemPickup.CollisionCylinder'
	begin object name="CollisionCylinder"
		CollisionHeight=230.0000000
		CollisionRadius=190.0000000
		ReplacementPrimitive=none
		CanBlockCamera=false
	end object
	Components[1]=CollisionCylinder
	Components[2]=DroppedPickupLightEnvironment
	Components[3]=FloatingMeshComponent0
	Components[4]=FloatingParticlesComponent0
	CollisionType=COLLIDE_TouchAll
	bIgnoreEncroachers=true
	bNoEncroachCheck=true
	bEdShouldSnap=true
	LifeSpan=0.0000000
	CollisionComponent=CollisionCylinder
}