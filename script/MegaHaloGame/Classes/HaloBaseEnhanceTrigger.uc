class HaloBaseEnhanceTrigger extends Trigger;

var string EnhancementName;
var const localized string InteractMessage;
var int BlokCost;
var bool bIsUnlocked;
var bool bPromptShouldShowCost;
var bool bIsBeingLookedAt;
var bool bIsBeingActivated;
var bool bWasAlreadyActivated;
var bool bHasGhostedTheMesh;
var float RequiredActivationTimeSecs;
var Actor VisualizationActor;
var MaterialInstance GhostedMaterialTemplate;
var float FadeTimeSecs;
var float MaxOpacity;
var float SightPct;
var float ActivationPctProgress;
var export editinline MeshComponent GhostedVisualizationMesh;
var AkEvent ActivateSound;
var AkEvent DeactivateSound;

function StartLookingAt(Controller Controller, Pawn Pawn)
{
	bIsBeingLookedAt = true;
	ActivationPctProgress = 0.0000000;
	//return;	
}

function StopLookingAt(Controller Controller, Pawn Pawn)
{
	bIsBeingLookedAt = false;
	ActivationPctProgress = 0.0000000;
	//return;	
}

function StartActivation(Controller Controller, Pawn Pawn)
{
	bIsBeingActivated = true;
	// End:0x34
	if(ActivateSound != none)
	{
		PlayAkEvent(ActivateSound);
	}
	//return;	
}

function StopActivation(Controller Controller, Pawn Pawn)
{
	bIsBeingActivated = false;
	// End:0x34
	if(DeactivateSound != none)
	{
		PlayAkEvent(DeactivateSound);
	}
	//return;	
}

function TickGhostedMesh(float DeltaTime)
{
	local int I;
	local MaterialInstanceConstant ghostedMaterial;

	// End:0x2BF
	if(VisualizationActor != none)
	{
		// End:0x1CE
		if(bHasGhostedTheMesh!)
		{
			// End:0xC2
			if(GhostedVisualizationMesh == none)
			{
				// End:0x79
				if(StaticMeshActor(VisualizationActor) != none)
				{
					GhostedVisualizationMesh = StaticMeshActor(VisualizationActor).StaticMeshComponent;					
				}
				else
				{
					// End:0xC2
					if(SkeletalMeshActor(VisualizationActor) != none)
					{
						GhostedVisualizationMesh = SkeletalMeshActor(VisualizationActor).SkeletalMeshComponent;
					}
				}
			}
			// End:0x1CE
			if((GhostedVisualizationMesh != none) && bHasGhostedTheMesh!)
			{
				I = 0;
				J0xED:

				// End:0x1C2 [Loop If]
				if(I < GhostedVisualizationMesh.GetNumElements())
				{
					ghostedMaterial = GhostedVisualizationMesh.CreateAndSetMaterialInstanceConstant(I);
					// End:0x1B4
					if(ghostedMaterial != none)
					{
						ghostedMaterial.SetParent(GhostedMaterialTemplate);
						GhostedVisualizationMesh.SetMaterial(I, ghostedMaterial);
					}
					I++;
					// [Loop Continue]
					goto J0xED;
				}
				bHasGhostedTheMesh = true;
			}
		}
		// End:0x2BF
		if(bHasGhostedTheMesh && GhostedVisualizationMesh != none)
		{
			I = 0;
			J0x1F7:

			// End:0x2BF [Loop If]
			if(I < GhostedVisualizationMesh.GetNumElements())
			{
				ghostedMaterial = MaterialInstanceConstant(GhostedVisualizationMesh.GetMaterial(I));
				// End:0x2B1
				if(ghostedMaterial != none)
				{
					ghostedMaterial.SetScalarParameterValue('Translucency', 1.0000000 - (SightPct * MaxOpacity));
				}
				I++;
				// [Loop Continue]
				goto J0x1F7;
			}
		}
	}
	//return;	
}

function Tick(float DeltaTime)
{
	local float prevSightPct;

	prevSightPct = SightPct;
	// End:0xAD
	if(bIsBeingLookedAt || bIsBeingActivated)
	{
		SightPct = FMin(1.0000000, SightPct + ((1.0000000 / FadeTimeSecs) * DeltaTime));
		// End:0xAA
		if((prevSightPct <= 0.0000000) && VisualizationActor != none)
		{
			VisualizationActor.SetHidden(false);
		}		
	}
	else
	{
		// End:0x13B
		if(SightPct > 0.0000000)
		{
			SightPct = FMax(0.0000000, SightPct - ((1.0000000 / FadeTimeSecs) * DeltaTime));
			// End:0x13B
			if((SightPct <= 0.0000000) && VisualizationActor != none)
			{
				VisualizationActor.SetHidden(true);
			}
		}
	}
	// End:0x161
	if(SightPct >= 0.0000000)
	{
		TickGhostedMesh(DeltaTime);
	}
	// End:0x1F3
	if(bIsBeingActivated)
	{
		// End:0x1F0
		if(ActivationPctProgress < 1.0000000)
		{
			// End:0x1CE
			if(RequiredActivationTimeSecs > 0.0000000)
			{
				ActivationPctProgress = FMin(1.0000000, ActivationPctProgress + ((1.0000000 / RequiredActivationTimeSecs) * DeltaTime));				
			}
			else
			{
				ActivationPctProgress = 1.0000000;
			}
			// End:0x1F0
			if(ActivationPctProgress >= 1.0000000)
			{
			}
		}		
	}
	else
	{
		ActivationPctProgress = 0.0000000;
	}
	super(Actor).Tick(DeltaTime);
	//return;	
}

defaultproperties
{
	EnhancementName="unnamed"
	InteractMessage="Interact [MainHUD.InlineInputIcons.inputIcon_y]"
	bIsUnlocked=true
	GhostedMaterialTemplate=MaterialInstanceConstant'Shared_MagicMoment_Lib.Proxy.Materials.MI_FX_Glass_Hologram_Mat'
	FadeTimeSecs=2.0000000
	MaxOpacity=0.5000000
	// Reference: CylinderComponent'MegaHaloGame.Default__HaloBaseEnhanceTrigger.CollisionCylinder'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'CollisionCylinder'
	// Archetype: CylinderComponent'Engine.Default__Trigger.CollisionCylinder'
	begin object name="CollisionCylinder"
		ReplacementPrimitive=none
	end object
	CylinderComponent=CollisionCylinder
	// Reference: SpriteComponent'MegaHaloGame.Default__HaloBaseEnhanceTrigger.Sprite'
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