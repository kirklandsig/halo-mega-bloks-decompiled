class HaloWeaponAttachment_TargetDesignator extends HaloBeamWeaponAttachment;

var Color LinkBeamColor;
var ParticleSystem LinkBeamSystem;
var MaterialInstanceConstant WeaponMaterialInstance;
var export editinline AudioComponent LinkHitSound;
var HaloTargetTracer TargetTracer;

static function GetTeamBeamInfo(byte TeamNum, optional out Color BeamColor, optional out ParticleSystem BeamSystem, optional out ParticleSystem BeamEndpointTemplate)
{
	BeamColor = default.LinkBeamColor;
	BeamSystem = default.LinkBeamSystem;
	//return;	
}

simulated function NotifyOfSuccessfulDeploy()
{
	TargetTracer.SetToSelfDestruct(true);
	//return;	
}

simulated function PostBeginPlay()
{
	TargetTracer = Spawn(Class'MegaHaloGame.HaloTargetTracer', self);
	super(UTWeaponAttachment).PostBeginPlay();
	//return;	
}

simulated function Destroyed()
{
	TargetTracer.SetToSelfDestruct(false);
	super(Actor).Destroyed();
	//return;	
}

simulated function UpdateBeam(byte FireModeNum)
{
	local Color BeamColor;
	local byte RealFireModeNum, TeamNum;
	local Vector EndPoint;
	local ParticleSystem BeamSystem, BeamEndpointTemplate;
	local LinearColor LinBeamColor;
	local bool isValidLocation;
	local Vector realWeaponAimPoint;
	local HaloPawn OwnerPawn;
	local HaloWeapon_TargetDesignator ownerTD;
	local bool forceHologramOrientation;
	local Rotator hologramOrientation;

	OwnerPawn = HaloPawn(Owner);
	ownerTD = HaloWeapon_TargetDesignator(Pawn(Owner).Weapon);
	RealFireModeNum = ((int(FireModeNum) >= int(2)) ? byte(1) : FireModeNum);
	EndPoint = PawnOwner.FlashLocation;
	// End:0x102
	if(BeamEmitter[int(RealFireModeNum)] != none)
	{
		BeamEmitter[int(RealFireModeNum)].SetVectorParameter(EndPointParamName, EndPoint);
	}
	HideEmitter(int(RealFireModeNum), false);
	HideEmitter(int(Abs(float(int(RealFireModeNum) - int(1)))), true);
	// End:0x1F6
	if((int(FireModeNum) == int(2)) && WorldInfo.GRI.GameClass.default.bTeamGame)
	{
		TeamNum = Instigator.GetTeamNum();
		GetTeamBeamInfo(TeamNum, BeamColor, BeamSystem, BeamEndpointTemplate);		
	}
	else
	{
		GetTeamBeamInfo(255, BeamColor, BeamSystem, BeamEndpointTemplate);
	}
	// End:0x353
	if(BeamEmitter[0] != none)
	{
		// End:0x328
		if(ownerTD != none)
		{
			// End:0x294
			if(ownerTD.CurrentAimPointOKToDeploy)
			{
				BeamColor = LinearColorToColor(ownerTD.GoodPlacementColor);				
			}
			else
			{
				BeamColor = LinearColorToColor(ownerTD.BadPlacementColor);
			}
			BeamEmitter[0].SetColorParameter('Color', BeamColor);
			HideEmitter(0, ownerTD.IsCurrentItemUnlocked()!);			
		}
		else
		{
			BeamEmitter[0].ClearParameter('Color');
		}
	}
	// End:0x393
	if(MuzzleFlashPSC != none)
	{
		MuzzleFlashPSC.SetColorParameter('Link_Beam_Color', BeamColor);
	}
	// End:0x45A
	if(UTLinkGunMuzzleFlashLight(MuzzleFlashLight) != none)
	{
		UTLinkGunMuzzleFlashLight(MuzzleFlashLight).SetTeam((((int(FireModeNum) == int(2)) && WorldInfo.GRI.GameClass.default.bTeamGame) ? Instigator.GetTeamNum() : byte(255)));
	}
	// End:0x4B7
	if(WeaponMaterialInstance != none)
	{
		LinBeamColor = ColorToLinearColor(BeamColor);
		WeaponMaterialInstance.SetVectorParameterValue('TeamColor', LinBeamColor);
	}
	// End:0x80D
	if(((TargetTracer != none) && OwnerPawn != none) && OwnerPawn.Weapon != none)
	{
		realWeaponAimPoint = EndPoint;
		isValidLocation = OwnerPawn.bIsOKToDeployTDItem;
		TargetTracer.SetPreviewMeshPath(OwnerPawn.DeployTDPreviewMeshPath);
		TargetTracer.TurnOn();
		// End:0x80D
		if(ownerTD != none)
		{
			forceHologramOrientation = ((ownerTD.CurrentItemRequiresPegs() && ownerTD.CurrentlyAimingOnPegs) || ownerTD.CurrentItemShouldAlignToWorld()) || ownerTD.CurrentItemShouldAlignWithFloor();
			// End:0x673
			if(forceHologramOrientation)
			{
				hologramOrientation = ownerTD.CurrentAimGridOrientation;				
			}
			else
			{
				hologramOrientation = Rotator(ownerTD.CurrentAimDir);
				hologramOrientation.Pitch = 0;
				hologramOrientation.Roll = 0;
			}
			TargetTracer.SetVisibility(ownerTD.IsCurrentItemUnlocked() && ownerTD.CurrentlyAimingOnPegs);
			TargetTracer.ProcessAimChange(OwnerPawn.Location, realWeaponAimPoint, hologramOrientation, isValidLocation, forceHologramOrientation || ownerTD.CurrentItemRequiresPegs(), ((isValidLocation) ? ownerTD.GoodPlacementColor : ownerTD.BadPlacementColor));
		}
	}
	//return;	
}

simulated function HideEmitter(int Index, bool bHide)
{
	local Color EffectColor;
	local LinearColor LinEffectColor;

	super(UTBeamWeaponAttachment).HideEmitter(Index, bHide);
	// End:0xE7
	if((Index == 1) && bHide)
	{
		GetTeamBeamInfo(255, EffectColor);
		// End:0xAF
		if(WeaponMaterialInstance != none)
		{
			LinEffectColor = ColorToLinearColor(EffectColor);
			WeaponMaterialInstance.SetVectorParameterValue('TeamColor', LinEffectColor);
		}
		// End:0xE7
		if(MuzzleFlashPSC != none)
		{
			MuzzleFlashPSC.ClearParameter('Link_Beam_Color');
		}
	}
	//return;	
}

defaultproperties
{
	LinkBeamColor=(R=64,G=128,B=255,A=255)
	LinkBeamSystem=ParticleSystem'FX_TargetDesignate.Effects.P_FX_TargetDesignate'
	BeamTemplate=ParticleSystem'FX_TargetDesignate.Effects.P_FX_TargetDesignate'
	BeamSockets="Muzzle_Socket"
	EndPointParamName="LinkBeamEnd"
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeaponAttachment_TargetDesignator.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloBeamWeaponAttachment.SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0"
		SkeletalMesh=SkeletalMesh'Weap_TargetDesignator.target_designator'
		// Reference: UTAnimNodeSequence'MegaHaloGame.Default__HaloWeaponAttachment_TargetDesignator.SkeletalMeshComponent0.MeshSequenceA'
		// Archetype: UTAnimNodeSequence'MegaHaloGame.Default__HaloBeamWeaponAttachment.SkeletalMeshComponent0.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		Materials[0]=MaterialInstanceConstant'Weap_TargetDesignator.Materials.MIC.MI_WeaponsUNSCDesignator_Mat'
		Materials[1]=Material'Weap_TargetDesignator.TD_metal_MAT'
		Materials[2]=Material'Weap_TargetDesignator.Materials.TD_screen_MAT'
		ReplacementPrimitive=none
		MaxDrawDistance=5000.0000000
		CachedMaxDrawDistance=5000.0000000
	end object
	Mesh=SkeletalMeshComponent0
	MuzzleFlashSocket="Muzzle_Socket"
	MuzzleFlashColor=(R=255,G=120,B=255,A=120)
	bMuzzleFlashPSCLoops=true
	MuzzleFlashDuration=0.3300000
	WeaponClass=Class'MegaHaloGame.HaloWeapon_TargetDesignator'
	WeapAnimType=EWeapAnimType.EWAT_DualPistols
}