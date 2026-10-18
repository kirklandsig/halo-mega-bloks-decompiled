class HaloActiveCamoComponent extends HaloArmorAbilityComponent;

var float TransitionDuration;
var float TransitionTimer;
var float TransitionProgress;
var bool bIsTransitioning;
var MaterialInstance CamoMaterial_All;
var MaterialInstance TransitionMaterial_SpartanSuit;
var MaterialInstance TransitionMaterial_SpartanVisor;
var MaterialInstance TransitionMaterial_UNSCWeapon;
var MaterialInstance TransitionMaterial_CovenantWeapon;
var MaterialInstance ParentMaterial_SpartanSuit;
var MaterialInstance ParentMaterial_SpartanVisor;
var MaterialInstance ParentMaterial_UNSCWeapon;
var MaterialInstance ParentMaterial_CovenantWeapon;
var array<MaterialInstance> BaseMaterials_Pawn;
var array<MaterialInstance> BaseMaterials_Weapon;
var array<MaterialInstance> TransitionMaterials_Pawn;
var array<MaterialInstance> TransitionMaterials_Weapon;
var array<MaterialInstance> CamoMaterials_Pawn;
var array<MaterialInstance> CamoMaterials_Weapon;
var export editinline MeshComponent PawnMesh;
var export editinline MeshComponent WeaponMesh;
var ParticleSystem ActivateCamoFX;
var ParticleSystem DeactivateCamoFX;

function bool Activate()
{
	// End:0x1DF
	if(super.Activate())
	{
		HaloPawn(Owner).SetSwitch('Equipment_Type', 'Camo');
		HaloPawn(Owner).PlayAkEvent(AkEvent'Equipment.Play_Equipment_Activate');
		GatherMeshes();
		GatherBaseMaterials();
		CreateTransitionMaterials();
		CreateCamoMaterials();
		SwitchToTransitionMaterials();
		// End:0x13B
		if(HaloPawn(Owner) != none)
		{
			HaloPawn(Owner).Camo = 1.0000000;
			HaloPawn(Owner).CamoVanishingPoint = Owner.Location;
		}
		Owner.WorldInfo.MyEmitterPool.SpawnEmitter(ActivateCamoFX, Owner.Location, Owner.Rotation, Owner, Owner);
		return true;
	}
	return false;
	//return ReturnValue;	
}

function bool Deactivate()
{
	// End:0x137
	if(super.Deactivate())
	{
		HaloPawn(Owner).PlayAkEvent(AkEvent'Equipment.Play_Equipment_Deactivate');
		SwitchToTransitionMaterials();
		// End:0x93
		if(HaloPawn(Owner) != none)
		{
			HaloPawn(Owner).Camo = 0.0000000;
		}
		Owner.WorldInfo.MyEmitterPool.SpawnEmitter(DeactivateCamoFX, Owner.Location, Owner.Rotation, Owner, Owner);
		return true;
	}
	return false;
	//return ReturnValue;	
}

function GatherMeshes()
{
	GatherPawnMesh();
	GatherWeaponMesh();
	//return;	
}

function GatherPawnMesh()
{
	local HaloPawn Pawn;

	Pawn = HaloPawn(Owner);
	// End:0x55
	if(Pawn != none)
	{
		PawnMesh = Pawn.Mesh;
		return;
	}
	PawnMesh = none;
	//return;	
}

function GatherWeaponMesh()
{
	local HaloPawn Pawn;
	local HaloWeaponAttachment WeaponAttachment;

	Pawn = HaloPawn(Owner);
	// End:0x95
	if(Pawn != none)
	{
		WeaponAttachment = HaloWeaponAttachment(Pawn.CurrentWeaponAttachment);
		// End:0x95
		if(WeaponAttachment != none)
		{
			WeaponMesh = WeaponAttachment.Mesh;
			return;
		}
	}
	WeaponMesh = none;
	//return;	
}

function GatherBaseMaterials()
{
	GatherPawnBaseMaterials();
	GatherWeaponBaseMaterials();
	//return;	
}

function GatherPawnBaseMaterials()
{
	local int I;

	BaseMaterials_Pawn.Length = 0;
	// End:0x9F
	if(PawnMesh != none)
	{
		I = 0;
		J0x26:

		// End:0x9F [Loop If]
		if(I < PawnMesh.Materials.Length)
		{
			BaseMaterials_Pawn.AddItem(MaterialInstance(PawnMesh.Materials[I]));
			I++;
			// [Loop Continue]
			goto J0x26;
		}
	}
	//return;	
}

function GatherWeaponBaseMaterials()
{
	local int I;

	BaseMaterials_Weapon.Length = 0;
	// End:0x9F
	if(WeaponMesh != none)
	{
		I = 0;
		J0x26:

		// End:0x9F [Loop If]
		if(I < WeaponMesh.Materials.Length)
		{
			BaseMaterials_Weapon.AddItem(MaterialInstance(WeaponMesh.Materials[I]));
			I++;
			// [Loop Continue]
			goto J0x26;
		}
	}
	//return;	
}

function SwitchToBaseMaterials()
{
	SwitchPawnToBaseMaterials();
	SwitchWeaponToBaseMaterials();
	//return;	
}

function SwitchPawnToBaseMaterials()
{
	local int I;

	// End:0x7B
	if(PawnMesh != none)
	{
		I = 0;
		J0x1A:

		// End:0x7B [Loop If]
		if(I < BaseMaterials_Pawn.Length)
		{
			PawnMesh.SetMaterial(I, BaseMaterials_Pawn[I]);
			I++;
			// [Loop Continue]
			goto J0x1A;
		}
	}
	//return;	
}

function SwitchWeaponToBaseMaterials()
{
	local int I;

	// End:0x7B
	if(WeaponMesh != none)
	{
		I = 0;
		J0x1A:

		// End:0x7B [Loop If]
		if(I < BaseMaterials_Weapon.Length)
		{
			WeaponMesh.SetMaterial(I, BaseMaterials_Weapon[I]);
			I++;
			// [Loop Continue]
			goto J0x1A;
		}
	}
	//return;	
}

function CreateTransitionMaterials()
{
	CreatePawnTransitionMaterials();
	CreateWeaponTransitionMaterials();
	//return;	
}

function CreatePawnTransitionMaterials()
{
	local int I;
	local MaterialInstance GrandParent, Material;
	local MaterialInstanceConstant TransitionMaterial;

	TransitionMaterials_Pawn.Length = 0;
	I = 0;
	J0x17:

	// End:0x16D [Loop If]
	if(I < BaseMaterials_Pawn.Length)
	{
		Material = BaseMaterials_Pawn[I];
		GrandParent = MaterialInstance(Material.Parent);
		TransitionMaterial = new (none) Class'Engine.MaterialInstanceConstant';
		switch(GrandParent.Parent)
		{
			// End:0xE8
			case ParentMaterial_SpartanSuit:
				HandleSpartanSuitMaterial(Material, TransitionMaterial);
				// End:0x149
				break;
			// End:0x113
			case ParentMaterial_SpartanVisor:
				HandleSpartanVisorMaterial(Material, TransitionMaterial);
				// End:0x149
				break;
			// End:0xFFFF
			default:
				WarnInternal("Unsupported Parent Material in " @ string(Material));
				// End:0x149
				break;
				break;
		}
		TransitionMaterials_Pawn.AddItem(TransitionMaterial);
		I++;
		// [Loop Continue]
		goto J0x17;
	}
	//return;	
}

function CreateWeaponTransitionMaterials()
{
	local int I;
	local MaterialInstance Material;
	local MaterialInstanceConstant TransitionMaterial;

	TransitionMaterials_Weapon.Length = 0;
	I = 0;
	J0x17:

	// End:0x13C [Loop If]
	if(I < BaseMaterials_Weapon.Length)
	{
		Material = BaseMaterials_Weapon[I];
		TransitionMaterial = new (none) Class'Engine.MaterialInstanceConstant';
		switch(Material.Parent)
		{
			// End:0xB7
			case ParentMaterial_UNSCWeapon:
				HandleUNSCWeaponMaterial(Material, TransitionMaterial);
				// End:0x118
				break;
			// End:0xE2
			case ParentMaterial_CovenantWeapon:
				HandleCovenantWeaponMaterial(Material, TransitionMaterial);
				// End:0x118
				break;
			// End:0xFFFF
			default:
				WarnInternal("Unsupported Parent Material in " @ string(Material));
				// End:0x118
				break;
				break;
		}
		TransitionMaterials_Weapon.AddItem(TransitionMaterial);
		I++;
		// [Loop Continue]
		goto J0x17;
	}
	//return;	
}

function HandleSpartanSuitMaterial(MaterialInstance Source, out MaterialInstanceConstant Destination)
{
	local LinearColor PrimaryColor, SecondaryColor;
	local Texture AlphaMap, ColorMap, NormalMap;

	Source.GetVectorParameterValue('CLR01Tint', PrimaryColor);
	Source.GetVectorParameterValue('CLR03Tint', SecondaryColor);
	Source.GetTextureParameterValue('AlphaPack_Texture', AlphaMap);
	Source.GetTextureParameterValue('ColorPack_Texture', ColorMap);
	Source.GetTextureParameterValue('NRM_Texture', NormalMap);
	Destination.SetParent(TransitionMaterial_SpartanSuit);
	Destination.SetVectorParameterValue('CLR01Tint', PrimaryColor);
	Destination.SetVectorParameterValue('CLR03Tint', SecondaryColor);
	Destination.SetTextureParameterValue('AlphaPack_Texture', AlphaMap);
	Destination.SetTextureParameterValue('ColorPack_Texture', ColorMap);
	Destination.SetTextureParameterValue('NRM_Texture', NormalMap);
	//return;	
}

function HandleSpartanVisorMaterial(MaterialInstance Source, out MaterialInstanceConstant Destination)
{
	local LinearColor PrimaryColor, EdgeColor;
	local Texture NormalMap;

	Source.GetVectorParameterValue('VisorColor', PrimaryColor);
	Source.GetVectorParameterValue('VisoredgeColor', EdgeColor);
	Source.GetTextureParameterValue('NRM_Texture', NormalMap);
	Destination.SetParent(TransitionMaterial_SpartanVisor);
	Destination.SetVectorParameterValue('VisorColor', PrimaryColor);
	Destination.SetVectorParameterValue('VisoredgeColor', EdgeColor);
	Destination.SetTextureParameterValue('NRM_Texture', NormalMap);
	//return;	
}

function HandleUNSCWeaponMaterial(MaterialInstance Source, out MaterialInstanceConstant Destination)
{
	local Texture ColorMap, NormalMap;

	Source.GetTextureParameterValue('CLR_Texture', ColorMap);
	Source.GetTextureParameterValue('NRM_Texture', NormalMap);
	Destination.SetParent(TransitionMaterial_UNSCWeapon);
	Destination.SetTextureParameterValue('CLR_Texture', ColorMap);
	Destination.SetTextureParameterValue('NRM_Texture', NormalMap);
	//return;	
}

function HandleCovenantWeaponMaterial(MaterialInstance Source, out MaterialInstanceConstant Destination)
{
	local LinearColor GlowColor;
	local Texture ColorMap, NormalMap;

	Source.GetVectorParameterValue('GlowColor', GlowColor);
	Source.GetTextureParameterValue('CLR_Texture', ColorMap);
	Source.GetTextureParameterValue('NRM_Texture', NormalMap);
	Destination.SetParent(TransitionMaterial_CovenantWeapon);
	Destination.SetVectorParameterValue('GlowColor', GlowColor);
	Destination.SetTextureParameterValue('CLR_Texture', ColorMap);
	Destination.SetTextureParameterValue('NRM_Texture', NormalMap);
	//return;	
}

function SwitchToTransitionMaterials()
{
	TransitionTimer = 0.0000000;
	TransitionProgress = 0.0000000;
	bIsTransitioning = true;
	SwitchPawnToTransitionMaterials();
	SwitchWeaponToTransitionMaterials();
	//return;	
}

function SwitchPawnToTransitionMaterials()
{
	local int I;

	// End:0x7B
	if(PawnMesh != none)
	{
		I = 0;
		J0x1A:

		// End:0x7B [Loop If]
		if(I < TransitionMaterials_Pawn.Length)
		{
			PawnMesh.SetMaterial(I, TransitionMaterials_Pawn[I]);
			I++;
			// [Loop Continue]
			goto J0x1A;
		}
	}
	//return;	
}

function SwitchWeaponToTransitionMaterials()
{
	local int I;

	// End:0x7B
	if(WeaponMesh != none)
	{
		I = 0;
		J0x1A:

		// End:0x7B [Loop If]
		if(I < TransitionMaterials_Weapon.Length)
		{
			WeaponMesh.SetMaterial(I, TransitionMaterials_Weapon[I]);
			I++;
			// [Loop Continue]
			goto J0x1A;
		}
	}
	//return;	
}

function CreateCamoMaterials()
{
	CreatePawnCamoMaterials();
	CreateWeaponCamoMaterials();
	//return;	
}

function CreatePawnCamoMaterials()
{
	local int I;
	local Texture NormalMap;
	local MaterialInstance BaseMaterial;
	local MaterialInstanceConstant CamoMaterial;

	CamoMaterials_Pawn.Length = 0;
	I = 0;
	J0x17:

	// End:0x112 [Loop If]
	if(I < BaseMaterials_Pawn.Length)
	{
		BaseMaterial = BaseMaterials_Pawn[I];
		BaseMaterial.GetTextureParameterValue('NRM_Texture', NormalMap);
		CamoMaterial = new (none) Class'Engine.MaterialInstanceConstant';
		CamoMaterial.SetParent(CamoMaterial_All);
		CamoMaterial.SetTextureParameterValue('NRM_Texture', NormalMap);
		CamoMaterials_Pawn.AddItem(CamoMaterial);
		I++;
		// [Loop Continue]
		goto J0x17;
	}
	//return;	
}

function CreateWeaponCamoMaterials()
{
	local int I;
	local Texture NormalMap;
	local MaterialInstance BaseMaterial;
	local MaterialInstanceConstant CamoMaterial;

	CamoMaterials_Weapon.Length = 0;
	I = 0;
	J0x17:

	// End:0x112 [Loop If]
	if(I < BaseMaterials_Weapon.Length)
	{
		BaseMaterial = BaseMaterials_Weapon[I];
		BaseMaterial.GetTextureParameterValue('NRM_Texture', NormalMap);
		CamoMaterial = new (none) Class'Engine.MaterialInstanceConstant';
		CamoMaterial.SetParent(CamoMaterial_All);
		CamoMaterial.SetTextureParameterValue('NRM_Texture', NormalMap);
		CamoMaterials_Weapon.AddItem(CamoMaterial);
		I++;
		// [Loop Continue]
		goto J0x17;
	}
	//return;	
}

function SwitchToCamoMaterials()
{
	SwitchPawnToCamoMaterials();
	SwitchWeaponToCamoMaterials();
	//return;	
}

function SwitchPawnToCamoMaterials()
{
	local int I;

	// End:0x7B
	if(PawnMesh != none)
	{
		I = 0;
		J0x1A:

		// End:0x7B [Loop If]
		if(I < CamoMaterials_Pawn.Length)
		{
			PawnMesh.SetMaterial(I, CamoMaterials_Pawn[I]);
			I++;
			// [Loop Continue]
			goto J0x1A;
		}
	}
	//return;	
}

function SwitchWeaponToCamoMaterials()
{
	local int I;

	// End:0x7B
	if(WeaponMesh != none)
	{
		I = 0;
		J0x1A:

		// End:0x7B [Loop If]
		if(I < CamoMaterials_Weapon.Length)
		{
			WeaponMesh.SetMaterial(I, CamoMaterials_Weapon[I]);
			I++;
			// [Loop Continue]
			goto J0x1A;
		}
	}
	//return;	
}

function Tick(float DeltaTime)
{
	// End:0x23
	if(bActive)
	{
		TickTransitionToCamo(DeltaTime);		
	}
	else
	{
		TickTransitionFromCamo(DeltaTime);
	}
	super.Tick(DeltaTime);
	//return;	
}

function TickTransitionToCamo(float DeltaTime)
{
	local int I;

	// End:0x18A
	if(bIsTransitioning)
	{
		TransitionTimer += DeltaTime;
		// End:0x88
		if(TransitionTimer >= TransitionDuration)
		{
			SwitchToCamoMaterials();
			bIsTransitioning = false;
			HaloPawn(Owner).PlayAkEvent(AkEvent'Equipment.Play_Equipment_Idle');			
		}
		else
		{
			TransitionProgress = FClamp(TransitionTimer / TransitionDuration, 0.0000000, 1.0000000);
			I = 0;
			J0xBD:

			// End:0x11E [Loop If]
			if(I < TransitionMaterials_Pawn.Length)
			{
				TransitionMaterials_Pawn[I].SetScalarParameterValue('ActiveCamoController', TransitionProgress);
				I++;
				// [Loop Continue]
				goto J0xBD;
			}
			I = 0;
			J0x129:

			// End:0x18A [Loop If]
			if(I < TransitionMaterials_Weapon.Length)
			{
				TransitionMaterials_Weapon[I].SetScalarParameterValue('ActiveCamoController', TransitionProgress);
				I++;
				// [Loop Continue]
				goto J0x129;
			}
		}
	}
	//return;	
}

function TickTransitionFromCamo(float DeltaTime)
{
	local int I;

	// End:0x15A
	if(bIsTransitioning)
	{
		TransitionTimer += DeltaTime;
		// End:0x51
		if(TransitionTimer >= TransitionDuration)
		{
			SwitchToBaseMaterials();
			bIsTransitioning = false;			
		}
		else
		{
			TransitionProgress = 1.0000000 - FClamp(TransitionTimer / TransitionDuration, 0.0000000, 1.0000000);
			I = 0;
			J0x8D:

			// End:0xEE [Loop If]
			if(I < TransitionMaterials_Pawn.Length)
			{
				TransitionMaterials_Pawn[I].SetScalarParameterValue('ActiveCamoController', TransitionProgress);
				I++;
				// [Loop Continue]
				goto J0x8D;
			}
			I = 0;
			J0xF9:

			// End:0x15A [Loop If]
			if(I < TransitionMaterials_Weapon.Length)
			{
				TransitionMaterials_Weapon[I].SetScalarParameterValue('ActiveCamoController', TransitionProgress);
				I++;
				// [Loop Continue]
				goto J0xF9;
			}
		}
	}
	//return;	
}

function ReduceCooldown(float DeltaTime)
{
	CooldownTimer += DeltaTime;
	// End:0x4A
	if(CooldownTimer >= Cooldown)
	{
		bAvailable = true;
		CooldownTimer = Cooldown;
	}
	//return;	
}

function OnWeaponDetach()
{
	// End:0x17
	if(bActive)
	{
		SwitchWeaponToBaseMaterials();
	}
	//return;	
}

function OnWeaponAttach()
{
	// End:0x59
	if(bActive)
	{
		GatherWeaponMesh();
		GatherWeaponBaseMaterials();
		CreateWeaponTransitionMaterials();
		CreateWeaponCamoMaterials();
		// End:0x4F
		if(bIsTransitioning)
		{
			SwitchWeaponToTransitionMaterials();			
		}
		else
		{
			SwitchWeaponToCamoMaterials();
		}
	}
	//return;	
}

defaultproperties
{
	TransitionDuration=1.0000000
	CamoMaterial_All=MaterialInstanceConstant'Shared_Hologram_Materials.ActiveCamo.Master.MI_ActiveCamo_Mat'
	TransitionMaterial_SpartanSuit=MaterialInstanceConstant'Shared_CHAR_Materials.Materials.Master.CHAR_NS_CustomColor_AC_Blend_MIC'
	TransitionMaterial_SpartanVisor=MaterialInstanceConstant'Shared_CHAR_Spartan.Materials.Master.UNSC_SpartanVisorMasterNS_AC_Blend_MIC'
	TransitionMaterial_UNSCWeapon=MaterialInstanceConstant'Shared_Weapons_Lib.Materials.MIC.MI_WeaponsUNSCActiveCamoBlend_Mat'
	TransitionMaterial_CovenantWeapon=MaterialInstanceConstant'Shared_Weapons_Lib.Materials.MIC.MI_WeaponsCovenantActiveCamoBlend_Mat'
	ParentMaterial_SpartanSuit=MaterialInstanceConstant'Shared_CHAR_Materials.Materials.Master.CHAR_NS_CustomColor_MIC'
	ParentMaterial_SpartanVisor=MaterialInstanceConstant'Shared_CHAR_Spartan.Materials.Master.MI_UNSC_SpartanVisorMasterNS_Mat'
	ParentMaterial_UNSCWeapon=MaterialInstanceConstant'Shared_Weapons_Lib.Materials.MIC.MI_WeaponsUNSC_Mat'
	ParentMaterial_CovenantWeapon=MaterialInstanceConstant'Shared_Weapons_Lib.Materials.MIC.MI_WeaponsCovenant_Mat'
	ActivateCamoFX=ParticleSystem'FX_ACTIVECAMO.Effects.FX_ACTIVECAMO_ON'
	DeactivateCamoFX=ParticleSystem'FX_ACTIVECAMO.Effects.FX_ACTIVECAMO_OFF'
	Duration=16.0000000
	Cooldown=30.0000000
}