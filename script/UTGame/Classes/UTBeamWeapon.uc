class UTBeamWeapon extends UTWeapon
	abstract
	config(Weapon);

var ParticleSystem BeamTemplate[2];
var export editinline ParticleSystemComponent BeamEmitter[2];
var name BeamSockets[2];
var name EndPointParamName;
var name BeamPreFireAnim[2];
var name BeamFireAnim[2];
var name BeamPostFireAnim[2];
var bool bUsePlayerControllerCameraPoint;
var ForceFeedbackWaveform BeamWeaponFireWaveForm;

simulated function AddBeamEmitter()
{
	// End:0x22B
	if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		// End:0x1FF
		if(BeamEmitter[int(CurrentFireMode)] == none)
		{
			// End:0x1FC
			if(BeamTemplate[int(CurrentFireMode)] != none)
			{
				BeamEmitter[int(CurrentFireMode)] = new (Outer) Class'UTGame.UTParticleSystemComponent';
				BeamEmitter[int(CurrentFireMode)].SetDepthPriorityGroup(2);
				BeamEmitter[int(CurrentFireMode)].SetTemplate(BeamTemplate[int(CurrentFireMode)]);
				BeamEmitter[int(CurrentFireMode)].SetHidden(true);
				BeamEmitter[int(CurrentFireMode)].SetTickGroup(3);
				BeamEmitter[int(CurrentFireMode)].bUpdateComponentInTick = true;
				BeamEmitter[int(CurrentFireMode)].SetIgnoreOwnerHidden(true);
				SkeletalMeshComponent(Mesh).AttachComponentToSocket(BeamEmitter[int(CurrentFireMode)], BeamSockets[int(CurrentFireMode)]);
			}			
		}
		else
		{
			BeamEmitter[int(CurrentFireMode)].ActivateSystem();
		}
	}
	//return;	
}

simulated function KillBeamEmitter()
{
	// End:0x72
	if(BeamEmitter[int(CurrentFireMode)] != none)
	{
		BeamEmitter[int(CurrentFireMode)].SetHidden(true);
		BeamEmitter[int(CurrentFireMode)].DeactivateSystem();
	}
	//return;	
}

simulated function SetBeamEmitterHidden(bool bHide)
{
	// End:0x50
	if(BeamEmitter[int(CurrentFireMode)] != none)
	{
		BeamEmitter[int(CurrentFireMode)].SetHidden(bHide);
	}
	//return;	
}

simulated function UpdateBeamEmitter(Vector FlashLocation, Vector HitNormal, Actor HitActor)
{
	// End:0x8C
	if(BeamEmitter[int(CurrentFireMode)] != none)
	{
		SetBeamEmitterHidden(!UTPawn(Instigator).IsFirstPerson());
		BeamEmitter[int(CurrentFireMode)].SetVectorParameter(EndPointParamName, FlashLocation);
	}
	//return;	
}

simulated function ProcessBeamHit(Vector StartTrace, Vector AimDir, out ImpactInfo TestImpact, float DeltaTime)
{
	//return;	
}

simulated function UpdateBeam(float DeltaTime)
{
	local Rotator CamRot;
	local Vector StartTrace, EndTrace, AimDir;
	local ImpactInfo RealImpact, NearImpact;

	// End:0x8E
	if(bUsePlayerControllerCameraPoint && PlayerController(Instigator.Controller) != none)
	{
		PlayerController(Instigator.Controller).GetPlayerViewPoint(StartTrace, CamRot);		
	}
	else
	{
		StartTrace = Instigator.GetWeaponStartTraceLocation();
	}
	AimDir = Vector(GetAdjustedAim(StartTrace));
	EndTrace = StartTrace + (AimDir * (GetTraceRange()));
	RealImpact = CalcWeaponFire(StartTrace, EndTrace);
	bUsingAimingHelp = false;
	// End:0x1BF
	if((RealImpact.HitActor == none) || !RealImpact.HitActor.bProjTarget)
	{
		NearImpact = InstantAimHelp(StartTrace, EndTrace, RealImpact);
	}
	// End:0x27C
	if(NearImpact.HitActor != none)
	{
		bUsingAimingHelp = true;
		ProcessBeamHit(StartTrace, AimDir, NearImpact, DeltaTime);
		UpdateBeamEmitter(NearImpact.HitLocation, NearImpact.HitNormal, NearImpact.HitActor);		
	}
	else
	{
		ProcessBeamHit(StartTrace, AimDir, RealImpact, DeltaTime);
		UpdateBeamEmitter(RealImpact.HitLocation, RealImpact.HitNormal, RealImpact.HitActor);
	}
	//return;	
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
	super.DisplayDebug(HUD, out_YL, out_YPos);
	// End:0x11E
	if(BeamEmitter[int(CurrentFireMode)] != none)
	{
		HUD.Canvas.SetPos(4.0000000, out_YPos);
		HUD.Canvas.DrawText(("Beam:" @ string(BeamEmitter[int(CurrentFireMode)])) @ string(BeamEmitter[int(CurrentFireMode)].HiddenGame));
		out_YPos += out_YL;
	}
	//return;	
}

simulated state WeaponBeamFiring
{
	ignores ShakeView;

	simulated function RefireCheckTimer()
	{
		local UTPlayerController PC;

		// End:0x14B
		if(ShouldRefire())
		{
			PC = UTPlayerController(Instigator.Controller);
			// End:0x149
			if((((PC != none) && LocalPlayer(PC.Player) != none) && int(CurrentFireMode) < FireCameraAnim.Length) && FireCameraAnim[int(CurrentFireMode)] != none)
			{
				PC.PlayCameraAnim(FireCameraAnim[int(CurrentFireMode)], ((int(GetZoomedState()) > int(1)) ? PC.GetFOVAngle() / PC.DefaultFOV : 1.0000000));
			}
			return;
		}
		GotoState('Active');
		// End:0x172
		if(!HasAnyAmmo())
		{
			WeaponEmpty();
		}
		//return;		
	}

	simulated function EndFire(byte FireModeNum)
	{
		global.EndFire(FireModeNum);
		// End:0x33
		if(bWeaponPutDown)
		{
			GotoState('WeaponPuttingDown');
			return;			
		}
		else
		{
			GotoState('Active');
		}
		//return;		
	}

	simulated function Tick(float DeltaTime)
	{
		UpdateBeam(DeltaTime);
		//return;		
	}

	simulated function PlayFireEffects(byte FireModeNum, optional Vector HitLocation)
	{
		local UTPlayerController PC;

		CauseMuzzleFlash();
		PC = UTPlayerController(Instigator.Controller);
		// End:0xA3
		if((PC != none) && LocalPlayer(PC.Player) != none)
		{
			PC.ClientPlayForceFeedbackWaveform(BeamWeaponFireWaveForm);
		}
		ShakeView();
		//return;		
	}

	event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
	{
		// End:0x94
		if(((SeqNode == none) || SeqNode.AnimSeqName != BeamFireAnim[int(CurrentFireMode)]) && BeamFireAnim[int(CurrentFireMode)] != 'None')
		{
			PlayWeaponAnimation(BeamFireAnim[int(CurrentFireMode)], 1.0000000, true);
		}
		//return;		
	}

	simulated function BeginState(name PreviousStateName)
	{
		local UTPawn POwner;

		RefireCheckTimer();
		TimeWeaponFiring(CurrentFireMode);
		// End:0x69
		if(BeamPreFireAnim[int(CurrentFireMode)] != 'None')
		{
			PlayWeaponAnimation(BeamPreFireAnim[int(CurrentFireMode)], 1.0000000);			
		}
		else
		{
			// End:0xB2
			if(BeamFireAnim[int(CurrentFireMode)] != 'None')
			{
				PlayWeaponAnimation(BeamFireAnim[int(CurrentFireMode)], 1.0000000);
			}
		}
		POwner = UTPawn(Instigator);
		// End:0x11B
		if(POwner != none)
		{
			AddBeamEmitter();
			POwner.SetWeaponAmbientSound(WeaponFireSnd[int(CurrentFireMode)]);
		}
		//return;		
	}

	simulated function EndState(name NextStateName)
	{
		local UTPawn POwner;
		local UTPlayerController PC;

		POwner = UTPawn(Instigator);
		// End:0x4B
		if(POwner != none)
		{
			POwner.SetWeaponAmbientSound(none);
		}
		ClearTimer('RefireCheckTimer');
		ClearFlashLocation();
		// End:0xB2
		if(BeamPostFireAnim[int(CurrentFireMode)] != 'None')
		{
			PlayWeaponAnimation(BeamPostFireAnim[int(CurrentFireMode)], 1.0000000);
		}
		PC = UTPlayerController(Instigator.Controller);
		// End:0x149
		if((PC != none) && LocalPlayer(PC.Player) != none)
		{
			PC.ClientStopForceFeedbackWaveform(BeamWeaponFireWaveForm);
		}
		super(Object).EndState(NextStateName);
		KillBeamEmitter();
		//return;		
	}

	simulated function bool IsFiring()
	{
		return true;
		//return ReturnValue;		
	}

	simulated function bool TryPutDown()
	{
		bWeaponPutDown = true;
		return false;
		//return ReturnValue;		
	}
	stop;	
}

defaultproperties
{
	// Reference: ForceFeedbackWaveform'UTGame.Default__UTBeamWeapon.ForceFeedbackWaveformShooting1'
	// Archetype: ForceFeedbackWaveform'UTGame.Default__UTWeapon.ForceFeedbackWaveformShooting1'
	begin object name="ForceFeedbackWaveformShooting1"
	end object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	// Reference: UDKSkeletalMeshComponent'UTGame.Default__UTBeamWeapon.FirstPersonMesh'
	// Archetype: UDKSkeletalMeshComponent'UTGame.Default__UTWeapon.FirstPersonMesh'
	begin object name="FirstPersonMesh"
		ReplacementPrimitive=none
	end object
	Mesh=FirstPersonMesh
	// Reference: SkeletalMeshComponent'UTGame.Default__UTBeamWeapon.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	// Archetype: SkeletalMeshComponent'UTGame.Default__UTWeapon.PickupMesh'
	begin object name="PickupMesh"
		ReplacementPrimitive=none
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
}