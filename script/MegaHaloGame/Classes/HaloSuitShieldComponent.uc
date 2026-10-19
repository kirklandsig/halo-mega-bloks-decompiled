class HaloSuitShieldComponent extends ActorComponent;

var float Shield;
var float ShieldMax;
var float HealRate;
var float HealDelay;
var float HealDelayTimer;
var bool bShouldForceShieldShellOn;
var MaterialInstance ShieldShellMaterialBasis;
var MaterialInstanceConstant ShieldShellMaterialInstance;
var ParticleSystem ShieldExpirationBurstFXTemplate;
var export editinline ParticleSystemComponent ShieldExpirationBurstFX;
var ParticleSystem ShieldRestorationBurstFXTemplate;
var name BurstFXBoneName;
var ParticleSystem ShieldExpirationFXTemplate;
var export editinline ParticleSystemComponent ShieldExpirationFX;
var float SecsToFadeShell;
var float SysTimeOfLastDamage;
var AkEvent ShieldDepletedStartEvent;
var AkEvent ShieldDepletedStopEvent;
var AkEvent ShieldChargeEvent;

event OnOwnerDestroyed()
{
	OnDeath();
	//return;	
}

function int TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	// End:0x1B
	if(Damage <= 0)
	{
		return Damage;
	}
	AdjustDamage(Damage, DamageType);
	// End:0x54
	if(Shield > 0.0000000)
	{
		StartShowingShieldShell();
	}
	DelayHealing();
	SysTimeOfLastDamage = Owner.WorldInfo.TimeSeconds;
	return Damage;
	//return ReturnValue;	
}

function AdjustDamage(out int InDamage, Class<DamageType> DamageType)
{
	local Class<HaloDamageType> DamageClass;
	local float ShieldDamageScaler, ShieldDamage;

	// End:0x15
	if(Shield <= 0.0000000)
	{
		return;
	}
	DamageClass = Class<HaloDamageType>(DamageType);
	// End:0x95
	if((DamageClass != none) && DamageClass.default.ShieldScaler != 0.0000000)
	{
		ShieldDamageScaler = DamageClass.default.ShieldScaler;		
	}
	else
	{
		ShieldDamageScaler = 1.0000000;
	}
	ShieldDamage = float(InDamage) * ShieldDamageScaler;
	// End:0xFD
	if(Shield >= ShieldDamage)
	{
		Shield -= ShieldDamage;
		InDamage = 0;		
	}
	else
	{
		InDamage -= int(Shield / DamageClass.default.ShieldScaler);
		Shield = 0.0000000;
	}
	// End:0x169
	if(Shield <= 0.0000000)
	{
		PlayShieldExpirationFX();
		StartLowHealthSound();
	}
	//return;	
}

function OnDeath()
{
	TurnOffAllShieldFX();
	StopLowHealthSound();
	//return;	
}

function DelayHealing()
{
	HealDelayTimer = HealDelay;
	//return;	
}

function TickHealing(float DeltaTime)
{
	local HaloPawn Pawn;

	Pawn = HaloPawn(Owner);
	// End:0x6D
	if((Pawn == none) || int(Pawn.WorldInfo.NetMode) == int(NM_Client))
	{
		return;
	}
	// End:0x1DB
	if(float(Pawn.Health) > 0.0000000)
	{
		// End:0xF9
		if(HealDelayTimer > 0.0000000)
		{
			HealDelayTimer -= DeltaTime;
			// End:0xF9
			if(HealDelayTimer <= 0.0000000)
			{
				TurnOffShieldExpirationFX();
				PlayShieldRestorationBurstFX();
				StopLowHealthSound();
				PlayShieldRechargeSound();
			}
		}
		// End:0x1DB
		if(HealDelayTimer <= 0.0000000)
		{
			// End:0x1DB
			if(Shield < ShieldMax)
			{
				Pawn.Health = Pawn.HealthMax;
				Shield = FMin(Shield + (HealRate * DeltaTime), ShieldMax);
				StartShowingShieldShell();
				SysTimeOfLastDamage = Owner.WorldInfo.TimeSeconds;
			}
		}
	}
	//return;	
}

function InitVisualElements()
{
	local UTPawn upOwner;

	upOwner = UTPawn(Owner);
	// DebugMode: 0
	assert(upOwner != none);
	upOwner.SetOverlaySkeletalMesh(upOwner.Mesh.SkeletalMesh);
	ShieldShellMaterialInstance = new (none) Class'Engine.MaterialInstanceConstant';
	ShieldShellMaterialInstance.SetParent(ShieldShellMaterialBasis);
	//return;	
}

function StartShowingShieldShell()
{
	local UTPawn upOwner;

	upOwner = UTPawn(Owner);
	// End:0x35
	if(ShieldShellMaterialInstance == none)
	{
		InitVisualElements();
	}
	// End:0x8A
	if(upOwner.GetOverlayMaterial() != ShieldShellMaterialInstance)
	{
		upOwner.SetOverlayMaterial(ShieldShellMaterialInstance);
	}
	ShieldShellMaterialInstance.SetScalarParameterValue('Intensity', 1.0000000);
	//return;	
}

function ParticleSystemComponent SpawnEmitterWithActorParameter(ParticleSystem fxTemplate)
{
	local editinline ParticleSystemComponent FX;

	FX = Owner.WorldInfo.MyEmitterPool.SpawnEmitter(fxTemplate, Owner.Location, Owner.Rotation, Owner);
	FX.SetActorParameter('BoneSocketActor', Owner);
	return FX;
	//return ReturnValue;	
}

function DeactivateEmitterWithActorParameter(ParticleSystemComponent FX)
{
	FX.SetActorParameter('BoneSocketActor', none);
	FX.DeactivateSystem();
	//return;	
}

function PlayShieldExpirationFX()
{
	// End:0x90
	if(Owner != none)
	{
		// End:0x47
		if(ShieldExpirationBurstFX != none)
		{
			ShieldExpirationBurstFX.SetActorParameter('BoneSocketActor', none);
		}
		ShieldExpirationBurstFX = SpawnEmitterWithActorParameter(ShieldExpirationBurstFXTemplate);
		// End:0x90
		if(ShieldExpirationFX == none)
		{
			ShieldExpirationFX = SpawnEmitterWithActorParameter(ShieldExpirationFXTemplate);
		}
	}
	//return;	
}

function TurnOffShieldExpirationFX()
{
	// End:0x2D
	if(ShieldExpirationFX != none)
	{
		DeactivateEmitterWithActorParameter(ShieldExpirationFX);
		ShieldExpirationFX = none;
	}
	// End:0x5A
	if(ShieldExpirationBurstFX != none)
	{
		DeactivateEmitterWithActorParameter(ShieldExpirationBurstFX);
		ShieldExpirationBurstFX = none;
	}
	//return;	
}

function PlayShieldRestorationBurstFX()
{
	local editinline ParticleSystemComponent NewSystem;

	// End:0xE4
	if(Owner != none)
	{
		NewSystem = Owner.WorldInfo.MyEmitterPool.SpawnEmitter(ShieldRestorationBurstFXTemplate, Owner.Location, Owner.Rotation, Owner);
		NewSystem.SetActorParameter('BoneSocketActor', Owner);
	}
	//return;	
}

function TurnOffAllShieldFX()
{
	// End:0x38
	if(Owner != none)
	{
		UTPawn(Owner).SetOverlayMaterial(none);
	}
	TurnOffShieldExpirationFX();
	//return;	
}

function TickVisuals(float DeltaTime)
{
	local float pctOpacity;
	local UTPawn upOwner;

	upOwner = UTPawn(Owner);
	// End:0xC3
	if((!bShouldForceShieldShellOn && (SysTimeOfLastDamage + SecsToFadeShell) < Owner.WorldInfo.TimeSeconds) && upOwner.GetOverlayMaterial() != none)
	{
		upOwner.SetOverlayMaterial(none);		
	}
	else
	{
		// End:0x14F
		if(bShouldForceShieldShellOn && upOwner.GetOverlayMaterial() == none)
		{
			upOwner.SetOverlayMaterial(ShieldShellMaterialInstance);
			ShieldShellMaterialInstance.SetScalarParameterValue('Intensity', 1.0000000);			
		}
		else
		{
			// End:0x25E
			if((!bShouldForceShieldShellOn && (SysTimeOfLastDamage + SecsToFadeShell) > Owner.WorldInfo.TimeSeconds) && upOwner.GetOverlayMaterial() != none)
			{
				pctOpacity = 1.0000000 - ((Owner.WorldInfo.TimeSeconds - SysTimeOfLastDamage) / SecsToFadeShell);
				ShieldShellMaterialInstance.SetScalarParameterValue('Intensity', pctOpacity);
			}
		}
	}
	//return;	
}

function StartLowHealthSound()
{
	// End:0x4E
	if((ShieldDepletedStartEvent != none) && Owner != none)
	{
		Owner.PlayAkEvent(ShieldDepletedStartEvent);
	}
	//return;	
}

function StopLowHealthSound()
{
	// End:0x4E
	if((ShieldDepletedStopEvent != none) && Owner != none)
	{
		Owner.PlayAkEvent(ShieldDepletedStopEvent);
	}
	//return;	
}

function PlayShieldRechargeSound()
{
	// End:0x4E
	if((ShieldChargeEvent != none) && Owner != none)
	{
		Owner.PlayAkEvent(ShieldChargeEvent);
	}
	//return;	
}

function Tick(float DeltaTime)
{
	TickHealing(DeltaTime);
	TickVisuals(DeltaTime);
	//return;	
}

defaultproperties
{
	Shield=100.0000000
	ShieldMax=100.0000000
	HealRate=50.0000000
	HealDelay=6.0000000
	ShieldShellMaterialBasis=MaterialInstanceConstant'ShieldEffect.ShieldMasterChief'
	ShieldExpirationBurstFXTemplate=ParticleSystem'FX_UNSC_SHIELDS.Effects.UNSC_SHIELD_BURST'
	ShieldRestorationBurstFXTemplate=ParticleSystem'FX_UNSC_SHIELDS.Effects.UNSC_SHIELD_RENEW'
	BurstFXBoneName="Name"
	ShieldExpirationFXTemplate=ParticleSystem'FX_UNSC_SHIELDS.Effects.UNSC_SHIELD_FAILING'
	SecsToFadeShell=1.0000000
	ShieldDepletedStartEvent=AkEvent'UIHUD.Play_UI_HUD_Shield_Depleted_Loop'
	ShieldDepletedStopEvent=AkEvent'UIHUD.Stop_UI_HUD_Shield_Depleted_Loop'
	ShieldChargeEvent=AkEvent'UIHUD.Play_UI_HUD_Shield_Charge'
}