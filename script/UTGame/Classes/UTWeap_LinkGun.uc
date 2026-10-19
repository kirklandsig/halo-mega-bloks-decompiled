class UTWeap_LinkGun extends UTBeamWeapon
	config(Weapon);

var Actor LinkedTo;
var export editinline PrimitiveComponent LinkedComponent;
var float WeaponLinkDistance;
var array<UTWeap_LinkGun> LinkedList;
var Actor Victim;
var repnotify int LinkStrength;
var float LinkFlexibility;
var float LinkBreakDelay;
var float MomentumTransfer;
var float BeamAmmoUsePerSecond;
var float ReaccquireTimer;
var bool bBeamHit;
var bool bAutoCharge;
var repnotify bool bFullPower;
var float RechargeRate;
var float SavedDamage;
var float SavedAmmoUse;
var float MinimumDamage;
var float PartialAmmo;
var MaterialInstanceConstant WeaponMaterialInstance;
var UTLinkBeamLight BeamLight;
var SoundCue StartAltFireSound;
var SoundCue EndAltFireSound;
var UTEmitter BeamEndpointEffect;
var export editinline ParticleSystemComponent PoweredUpEffect;
var name PoweredUpEffectSocket;
var Vector BeamAttachLocation;
var float LastBeamAttachTime;
var Vector BeamAttachNormal;
var Actor BeamAttachActor;
var Class<UTAttachment_LinkGun> LinkAttachmentClass;
var ParticleSystem TeamMuzzleFlashTemplates[3];
var ParticleSystem HighPowerMuzzleFlashTemplate;

replication
{
	// Pos:0x000
	if(bNetDirty)
		LinkStrength, LinkedTo, 
		bBeamHit, bFullPower;
}

simulated function PostBeginPlay()
{
	local Color DefaultBeamColor, DefaultColor;
	local LinearColor LinColor;

	super(UTWeapon).PostBeginPlay();
	// End:0x31
	if(int(Role) == int(ROLE_Authority))
	{
		SetTimer(0.2500000, true, 'FindLinkedWeapons');
	}
	LinkAttachmentClass = Class<UTAttachment_LinkGun>(AttachmentClass);
	// End:0x179
	if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && Mesh != none)
	{
		LinkAttachmentClass.static.GetTeamBeamInfo(255, DefaultBeamColor);
		WeaponMaterialInstance = Mesh.CreateAndSetMaterialInstanceConstant(0);
		LinColor = ColorToLinearColor(DefaultBeamColor);
		WeaponMaterialInstance.SetVectorParameterValue('TeamColor', LinColor);
		LinColor = ColorToLinearColor(DefaultColor);
		WeaponMaterialInstance.SetVectorParameterValue('Paint_Color', LinColor);
	}
	//return;	
}

simulated function ParticleSystem GetTeamMuzzleFlashTemplate(byte TeamNum)
{
	// End:0x28
	if(int(TeamNum) >= 3)
	{
		TeamNum = byte(int(3) - int(1));
	}
	return default.TeamMuzzleFlashTemplates[int(TeamNum)];
	//return ReturnValue;	
}

simulated function DrawWeaponCrosshair(HUD HUD)
{
	local Vector2D CrosshairSize;
	local float X, Y, PickupScale, ScreenX, ScreenY, TargetDist;

	local UTHUDBase H;

	H = UTHUDBase(HUD);
	// End:0x2D
	if(H == none)
	{
		return;
	}
	TargetDist = GetTargetDistance();
	// End:0x188
	if(H.LastPickupTime > (WorldInfo.TimeSeconds - 0.3000000))
	{
		// End:0x129
		if(H.LastPickupTime > (WorldInfo.TimeSeconds - 0.1500000))
		{
			PickupScale = 1.0000000 + (float(5) * (WorldInfo.TimeSeconds - H.LastPickupTime));			
		}
		else
		{
			PickupScale = 1.0000000 + (float(5) * ((H.LastPickupTime + 0.3000000) - WorldInfo.TimeSeconds));
		}		
	}
	else
	{
		PickupScale = 1.0000000;
	}
	CrosshairSize.Y = ((((H.ConfiguredCrosshairScaling * CrosshairScaling) * CrossHairCoordinates.VL) * PickupScale) * H.Canvas.ClipY) / float(720);
	CrosshairSize.X = CrosshairSize.Y * (CrossHairCoordinates.UL / CrossHairCoordinates.VL);
	X = H.Canvas.ClipX * 0.5000000;
	Y = H.Canvas.ClipY * 0.5000000;
	ScreenX = X - (CrosshairSize.X * 0.5000000);
	ScreenY = Y - (CrosshairSize.Y * 0.5000000);
	// End:0x7B1
	if(CrosshairImage != none)
	{
		H.Canvas.DrawColor = H.BlackColor;
		H.Canvas.SetPos(ScreenX + float(1), ScreenY + float(1), TargetDist);
		H.Canvas.DrawTile(CrosshairImage, CrosshairSize.X, CrosshairSize.Y, CrossHairCoordinates.U, CrossHairCoordinates.V, CrossHairCoordinates.UL, CrossHairCoordinates.VL);
		CrosshairColor = ((LinkStrength > 1) ? H.default.LightGoldColor : default.CrosshairColor);
		CrosshairColor = ((H.bGreenCrosshair) ? H.default.LightGreenColor : CrosshairColor);
		H.Canvas.DrawColor = (((WorldInfo.TimeSeconds - LastHitEnemyTime) < 0.3000000) ? H.RedColor : CrosshairColor);
		H.Canvas.SetPos(ScreenX, ScreenY, TargetDist);
		H.Canvas.DrawTile(CrosshairImage, CrosshairSize.X, CrosshairSize.Y, CrossHairCoordinates.U, CrossHairCoordinates.V, CrossHairCoordinates.UL, CrossHairCoordinates.VL);
	}
	//return;	
}

simulated function SetSkin(Material NewMaterial)
{
	super(UTWeapon).SetSkin(NewMaterial);
	// End:0x5C
	if((NewMaterial == none) && Mesh != none)
	{
		Mesh.SetMaterial(0, WeaponMaterialInstance);
	}
	//return;	
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
	super(UTWeapon).AttachWeaponTo(MeshCpnt, SocketName);
	// End:0xA6
	if(((PoweredUpEffect != none) && !PoweredUpEffect.bAttached) && SkeletalMeshComponent(Mesh) != none)
	{
		SkeletalMeshComponent(Mesh).AttachComponentToSocket(PoweredUpEffect, PoweredUpEffectSocket);
	}
	//return;	
}

simulated function UpdateBeamEmitter(Vector FlashLocation, Vector HitNormal, Actor HitActor)
{
	local Color BeamColor;
	local ParticleSystem BeamSystem, BeamEndpointTemplate, MuzzleFlashTemplate;
	local byte TeamNum;
	local LinearColor LinColor;

	// End:0x23
	if(LinkedTo != none)
	{
		FlashLocation = GetLinkedToLocation();
	}
	super.UpdateBeamEmitter(FlashLocation, HitNormal, HitActor);
	// End:0x131
	if((LinkedTo != none) && WorldInfo.GRI.GameClass.default.bTeamGame)
	{
		TeamNum = Instigator.GetTeamNum();
		LinkAttachmentClass.static.GetTeamBeamInfo(TeamNum, BeamColor, BeamSystem, BeamEndpointTemplate);
		MuzzleFlashTemplate = GetTeamMuzzleFlashTemplate(TeamNum);		
	}
	else
	{
		// End:0x1F8
		if((LinkStrength > 1) || Instigator.DamageScaling >= 2.0000000)
		{
			BeamColor = LinkAttachmentClass.default.HighPowerBeamColor;
			BeamSystem = LinkAttachmentClass.default.HighPowerSystem;
			BeamEndpointTemplate = LinkAttachmentClass.default.HighPowerBeamEndpointTemplate;
			MuzzleFlashTemplate = HighPowerMuzzleFlashTemplate;			
		}
		else
		{
			LinkAttachmentClass.static.GetTeamBeamInfo(255, BeamColor, BeamSystem, BeamEndpointTemplate);
			MuzzleFlashTemplate = GetTeamMuzzleFlashTemplate(255);
		}
	}
	// End:0x3D7
	if(BeamLight != none)
	{
		// End:0x32D
		if(HitNormal == vect(0.0000000, 0.0000000, 0.0000000))
		{
			BeamLight.BeamLight.Radius = 48.0000000;
			// End:0x309
			if(FastTrace(FlashLocation, FlashLocation - vect(0.0000000, 0.0000000, 32.0000000)))
			{
				BeamLight.SetLocation(FlashLocation - vect(0.0000000, 0.0000000, 32.0000000));				
			}
			else
			{
				BeamLight.SetLocation(FlashLocation);
			}			
		}
		else
		{
			BeamLight.BeamLight.Radius = 32.0000000;
			BeamLight.SetLocation(FlashLocation + (float(16) * HitNormal));
		}
		BeamLight.BeamLight.SetLightProperties(,, BeamColor);
	}
	// End:0x49B
	if(BeamEmitter[int(CurrentFireMode)] != none)
	{
		BeamEmitter[int(CurrentFireMode)].SetColorParameter('Link_Beam_Color', BeamColor);
		// End:0x49B
		if(BeamEmitter[int(CurrentFireMode)].Template != BeamSystem)
		{
			BeamEmitter[int(CurrentFireMode)].SetTemplate(BeamSystem);
		}
	}
	// End:0x52F
	if(MuzzleFlashPSC != none)
	{
		MuzzleFlashPSC.SetColorParameter('Link_Beam_Color', BeamColor);
		// End:0x52F
		if(MuzzleFlashTemplate != MuzzleFlashPSC.Template)
		{
			MuzzleFlashPSC.SetTemplate(MuzzleFlashTemplate);
		}
	}
	// End:0x5F1
	if(UTLinkGunMuzzleFlashLight(MuzzleFlashLight) != none)
	{
		UTLinkGunMuzzleFlashLight(MuzzleFlashLight).SetTeam((((LinkedTo != none) && WorldInfo.GRI.GameClass.default.bTeamGame) ? Instigator.GetTeamNum() : byte(255)));
	}
	// End:0x64E
	if(WeaponMaterialInstance != none)
	{
		LinColor = ColorToLinearColor(BeamColor);
		WeaponMaterialInstance.SetVectorParameterValue('TeamColor', LinColor);
	}
	// End:0x8AA
	if(((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && Instigator != none) && Instigator.IsFirstPerson())
	{
		// End:0x792
		if((BeamEndpointEffect != none) && !BeamEndpointEffect.bDeleteMe)
		{
			BeamEndpointEffect.SetLocation(FlashLocation);
			BeamEndpointEffect.SetRotation(Rotator(HitNormal));
			// End:0x78F
			if(BeamEndpointEffect.ParticleSystemComponent.Template != BeamEndpointTemplate)
			{
				BeamEndpointEffect.SetTemplate(BeamEndpointTemplate, true);
			}			
		}
		else
		{
			BeamEndpointEffect = Spawn(Class'UTGame.UTEmitter', self,, FlashLocation, Rotator(HitNormal));
			BeamEndpointEffect.SetTemplate(BeamEndpointTemplate, true);
			BeamEndpointEffect.LifeSpan = 0.0000000;
		}
		// End:0x8AA
		if(BeamEndpointEffect != none)
		{
			// End:0x87D
			if((HitActor != none) && UTPawn(HitActor) == none)
			{
				BeamEndpointEffect.SetFloatParameter('Touch', 1.0000000);				
			}
			else
			{
				BeamEndpointEffect.SetFloatParameter('Touch', 0.0000000);
			}
		}
	}
	//return;	
}

function Class<Projectile> GetProjectileClass()
{
	return ((LinkStrength > 1) ? Class'UTGame.UTProj_LinkPowerPlasma' : super(Weapon).GetProjectileClass());
	//return ReturnValue;	
}

simulated event Destroyed()
{
	super(UTWeapon).Destroyed();
	UnLink();
	LinkedComponent = none;
	// End:0x47
	if(BeamLight != none)
	{
		BeamLight.Destroy();
	}
	KillEndpointEffect();
	//return;	
}

simulated function SetBeamEmitterHidden(bool bHide)
{
	// End:0x34
	if((BeamEmitter[int(CurrentFireMode)] != none) && bHide)
	{
		KillEndpointEffect();
	}
	super.SetBeamEmitterHidden(bHide);
	//return;	
}

simulated function KillBeamEmitter()
{
	super.KillBeamEmitter();
	KillEndpointEffect();
	//return;	
}

simulated function KillEndpointEffect()
{
	// End:0x72
	if(BeamEndpointEffect != none)
	{
		BeamEndpointEffect.ParticleSystemComponent.DeactivateSystem();
		BeamEndpointEffect.LifeSpan = 2.0000000;
		BeamEndpointEffect = none;
	}
	//return;	
}

function ConsumeAmmo(byte FireModeNum)
{
	// End:0x41
	if(bAutoCharge && int(Role) == int(ROLE_Authority))
	{
		SetTimer(RechargeRate + 1.0000000, false, 'RechargeAmmo');
	}
	super(UTWeapon).ConsumeAmmo(FireModeNum);
	//return;	
}

function ConsumeBeamAmmo(float Amount)
{
	// End:0x41
	if(bAutoCharge && int(Role) == int(ROLE_Authority))
	{
		SetTimer(RechargeRate + 1.0000000, false, 'RechargeAmmo');
	}
	PartialAmmo += Amount;
	// End:0x97
	if(PartialAmmo >= 1.0000000)
	{
		AddAmmo(-int(PartialAmmo));
		PartialAmmo -= float(int(PartialAmmo));
	}
	//return;	
}

function RechargeAmmo()
{
	// End:0x51
	if(AmmoCount < MaxAmmoCount)
	{
		AmmoCount += 1;
		// End:0x51
		if(AmmoCount < MaxAmmoCount)
		{
			SetTimer(RechargeRate, false, 'RechargeAmmo');
		}
	}
	//return;	
}

simulated function ProcessBeamHit(Vector StartTrace, Vector AimDir, out ImpactInfo TestImpact, float DeltaTime)
{
	local float DamageAmount;
	local Vector PushForce, ShotDir, SideDir;
	local UTPawn UTP;

	Victim = TestImpact.HitActor;
	// End:0x5AA
	if(int(Role) == int(ROLE_Authority))
	{
		AttemptLinkTo(Victim, TestImpact.HitInfo.HitComponent);
		SetCurrentFireMode(CurrentFireMode);
		// End:0xC4
		if(LinkedTo == none)
		{
			SetFlashLocation(TestImpact.HitLocation);
		}
		bBeamHit = false;
		CalcLinkStrength();
		DamageAmount = InstantHitDamage[1];
		UTP = UTPawn(Instigator);
		// End:0x14D
		if(UTP != none)
		{
			DamageAmount = DamageAmount / UTP.FireRateMultiplier;
		}
		// End:0x185
		if(LinkStrength > 1)
		{
			DamageAmount *= FClamp(0.7500000 * float(LinkStrength), 1.5000000, 2.0000000);
		}
		SavedDamage += (DamageAmount * DeltaTime);
		DamageAmount = float(int(SavedDamage));
		SavedAmmoUse += (BeamAmmoUsePerSecond * DeltaTime);
		// End:0x5A7
		if(DamageAmount >= MinimumDamage)
		{
			SavedDamage -= DamageAmount;
			// End:0x324
			if(LinkedTo != none)
			{
				// End:0x321
				if(!LinkedTo.IsA('UTPawn'))
				{
					// End:0x30E
					if(LinkedTo.IsA('UTVehicle') || LinkedTo.IsA('UTGameObjective'))
					{
						// End:0x30B
						if(LinkedTo.HealDamage(int(DamageAmount * Instigator.GetDamageScaling()), Instigator.Controller, InstantHitDamageTypes[1]))
						{
							ConsumeBeamAmmo(SavedAmmoUse);
						}						
					}
					else
					{
						ConsumeBeamAmmo(SavedAmmoUse);
					}
				}				
			}
			else
			{
				ConsumeBeamAmmo(SavedAmmoUse);
				// End:0x598
				if((Victim != none) && !WorldInfo.Game.GameReplicationInfo.OnSameTeam(Victim, Instigator))
				{
					bBeamHit = !Victim.bWorldGeometry;
					// End:0x598
					if(DamageAmount > float(0))
					{
						ShotDir = Normal(TestImpact.HitLocation - Location);
						SideDir = Normal(ShotDir Cross vect(0.0000000, 0.0000000, 1.0000000));
						PushForce = vect(0.0000000, 0.0000000, 1.0000000) + Normal(SideDir * (SideDir Dot (TestImpact.HitLocation - Victim.Location)));
						PushForce *= ((int(Victim.Physics) == int(1)) ? 0.1000000 * MomentumTransfer : DeltaTime * MomentumTransfer);
						Victim.TakeDamage(int(DamageAmount), Instigator.Controller, TestImpact.HitLocation, PushForce, InstantHitDamageTypes[1], TestImpact.HitInfo, self);
					}
				}
			}
			SavedAmmoUse = 0.0000000;
		}		
	}
	else
	{
		// End:0x5E2
		if(LinkedTo == none)
		{
			SetFlashLocation(TestImpact.HitLocation);			
		}
		else
		{
			// End:0x67C
			if((TestImpact.HitActor == LinkedTo) && TestImpact.HitInfo.HitComponent != none)
			{
				LinkedComponent = TestImpact.HitInfo.HitComponent;
			}
		}
		// End:0x8A6
		if((Victim != none) && int(Victim.Role) == int(ROLE_Authority))
		{
			bBeamHit = !Victim.bWorldGeometry;
			// End:0x8A6
			if(DamageAmount > float(0))
			{
				ShotDir = Normal(TestImpact.HitLocation - Location);
				SideDir = Normal(ShotDir Cross vect(0.0000000, 0.0000000, 1.0000000));
				PushForce = vect(0.0000000, 0.0000000, 1.0000000) + Normal(SideDir * (SideDir Dot (TestImpact.HitLocation - Victim.Location)));
				PushForce *= ((int(Victim.Physics) == int(1)) ? 0.1000000 * MomentumTransfer : DeltaTime * MomentumTransfer);
				Victim.TakeDamage(int(DamageAmount), Instigator.Controller, TestImpact.HitLocation, PushForce, InstantHitDamageTypes[1], TestImpact.HitInfo, self);
			}
		}
	}
	//return;	
}

simulated function Vector GetLinkedToLocation()
{
	local Vector BestLoc, Loc, ToTarget;
	local bool bHitVehicleAimingAt;
	local Vector HitLocation, HitNormal;

	// End:0x20
	if(LinkedTo == none)
	{
		return vect(0.0000000, 0.0000000, 0.0000000);		
	}
	else
	{
		// End:0x1AB
		if(UTVehicle(LinkedTo) != none)
		{
			// End:0x99
			if(Mesh.bAttached)
			{
				UDKSkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation('MuzzleFlashSocket', Loc);				
			}
			else
			{
				Loc = Instigator.GetPawnViewLocation();
			}
			ToTarget = UTVehicle(LinkedTo).GetTargetLocation();
			// End:0x168
			if(!bHitVehicleAimingAt)
			{
				bHitVehicleAimingAt = TraceComponent(HitLocation, HitNormal, UTVehicle(LinkedTo).Mesh, ToTarget, Loc);
			}
			// End:0x18B
			if(bHitVehicleAimingAt)
			{
				BestLoc = HitLocation;				
			}
			else
			{
				BestLoc = Loc;
			}
			return BestLoc;			
		}
		else
		{
			// End:0x21D
			if(Pawn(LinkedTo) != none)
			{
				return LinkedTo.Location + (Pawn(LinkedTo).BaseEyeHeight * vect(0.0000000, 0.0000000, 0.5000000));				
			}
			else
			{
				// End:0x24F
				if(LinkedComponent != none)
				{
					return LinkedComponent.GetPosition();					
				}
				else
				{
					return LinkedTo.Location;
				}
			}
		}
	}
	//return ReturnValue;	
}

function AttemptLinkTo(Actor Who, PrimitiveComponent HitComponent)
{
	local UTVehicle UTV;
	local Vector StartTrace, EndTrace, V, HitLocation, HitNormal;

	local Actor HitActor;

	// End:0x8F
	if(Who != none)
	{
		UTV = UTVehicle(Who.Owner);
		// End:0x8F
		if((UTV != none) && UTV.AllowLinkThroughOwnedActor(Who))
		{
			Who = UTV;
		}
	}
	UTV = UTVehicle(Who);
	// End:0x2CE
	if((UTV != none) && UTV.bValidLinkTarget)
	{
		// End:0x2C3
		if(WorldInfo.Game.GameReplicationInfo.OnSameTeam(UTV, Instigator) || !UTV.bTeamLocked && UTV.CanEnterVehicle(Instigator))
		{
			// End:0x259
			if(!WorldInfo.Game.GameReplicationInfo.OnSameTeam(UTV, Instigator) && int(Instigator.GetTeamNum()) != int(255))
			{
				UTV.SetTeamNum(Instigator.GetTeamNum());
			}
			LinkedComponent = HitComponent;
			// End:0x2C0
			if(LinkedTo != UTV)
			{
				UnLink();
				LinkedTo = UTV;
				UTV.IncrementLinkedToCount();
			}			
		}
		else
		{
			UnLink();
		}
	}
	// End:0x4A6
	if(LinkedTo != none)
	{
		// End:0x355
		if(LinkedTo.bDeleteMe || (Pawn(LinkedTo) != none) && Pawn(LinkedTo).Health <= 0)
		{
			UnLink();
			return;
		}
		// End:0x4A6
		if(LinkedTo != Who)
		{
			StartTrace = Instigator.GetWeaponStartTraceLocation();
			EndTrace = GetLinkedToLocation();
			V = Normal(EndTrace - StartTrace);
			// End:0x43E
			if(((V Dot Vector(Instigator.GetViewRotation())) < LinkFlexibility) || VSize(EndTrace - StartTrace) > (1.5000000 * WeaponRange))
			{
				UnLink();
				return;
			}
			HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);
			// End:0x4A6
			if((HitActor != none) && HitActor != LinkedTo)
			{
				UnLink(true);
			}
		}
	}
	// End:0x4C9
	if(LinkedTo != none)
	{
		SetFlashLocation(GetLinkedToLocation());
	}
	//return;	
}

function UnLink(optional bool bDelayed)
{
	local UTVehicle V;

	// End:0x73
	if(!bDelayed)
	{
		V = UTVehicle(LinkedTo);
		// End:0x5A
		if(V != none)
		{
			V.DecrementLinkedToCount();
		}
		LinkedTo = none;
		LinkedComponent = none;		
	}
	else
	{
		// End:0x97
		if(ReaccquireTimer <= float(0))
		{
			ReaccquireTimer = LinkBreakDelay;
		}
	}
	//return;	
}

function FindLinkedWeapons()
{
	local UTPawn P;
	local UTWeap_LinkGun Link;

	LinkedList.Length = 0;
	// End:0x1E8
	if((Instigator != none) && (bReadyToFire()) || IsFiring())
	{
		// End:0x1E7
		foreach WorldInfo.AllPawns(Class'UTGame.UTPawn', P, Instigator.Location, WeaponLinkDistance)
		{
			// End:0x1E6
			if(((P != Instigator) && !P.bNoWeaponFiring) && P.DrivenVehicle == none)
			{
				Link = UTWeap_LinkGun(P.Weapon);
				// End:0x1E6
				if(((Link != none) && WorldInfo.GRI.OnSameTeam(Instigator, P)) && FastTrace(P.Location, Instigator.Location))
				{
					LinkedList[LinkedList.Length] = Link;
				}
			}			
		}		
	}
	CalcLinkStrength();
	// End:0x2C3
	if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && PoweredUpEffect != none)
	{
		// End:0x282
		if(LinkStrength > 1)
		{
			// End:0x27F
			if(!PoweredUpEffect.bIsActive)
			{
				PoweredUpEffect.ActivateSystem();
			}			
		}
		else
		{
			// End:0x2C3
			if(PoweredUpEffect.bIsActive)
			{
				PoweredUpEffect.DeactivateSystem();
			}
		}
	}
	//return;	
}

function GetLinkedWeapons(out array<UTWeap_LinkGun> LinkedWeapons)
{
	local int I;

	LinkedWeapons[LinkedWeapons.Length] = self;
	I = 0;
	J0x21:

	// End:0xA3 [Loop If]
	if(I < LinkedList.Length)
	{
		// End:0x95
		if(LinkedWeapons.Find(LinkedList[I]) == -1)
		{
			LinkedList[I].GetLinkedWeapons(LinkedWeapons);
		}
		I++;
		// [Loop Continue]
		goto J0x21;
	}
	//return;	
}

function CalcLinkStrength()
{
	local array<UTWeap_LinkGun> LinkedWeapons;

	GetLinkedWeapons(LinkedWeapons);
	LinkStrength = LinkedWeapons.Length;
	//return;	
}

simulated function ChangeVisibility(bool bIsVisible)
{
	super(UTWeapon).ChangeVisibility(bIsVisible);
	// End:0x4E
	if(PoweredUpEffect != none)
	{
		PoweredUpEffect.SetHidden(!bIsVisible);
	}
	//return;	
}

simulated event ReplicatedEvent(name VarName)
{
	// End:0xB1
	if(VarName == 'LinkStrength')
	{
		// End:0x6D
		if(LinkStrength > 1)
		{
			// End:0x6A
			if(!PoweredUpEffect.bIsActive)
			{
				PoweredUpEffect.ActivateSystem();
			}			
		}
		else
		{
			// End:0xAE
			if(PoweredUpEffect.bIsActive)
			{
				PoweredUpEffect.DeactivateSystem();
			}
		}		
	}
	else
	{
		// End:0xE2
		if(VarName == 'bFullPower')
		{
			// End:0xDF
			if(bFullPower)
			{
				BoostPower();
			}			
		}
		else
		{
			super(UTWeapon).ReplicatedEvent(VarName);
		}
	}
	//return;	
}

function float GetAIRating()
{
	local UTBot B;
	local UTVehicle V;
	local UTGameObjective O;
	local float Dist;

	B = UTBot(Instigator.Controller);
	// End:0x70
	if((B == none) || B.Squad == none)
	{
		return AIRating;
	}
	V = UTSquadAI(B.Squad).GetLinkVehicle(B);
	// End:0x197
	if((((V != none) && VSize(Instigator.Location - V.Location) < (1.5000000 * WeaponRange)) && V.Health < V.HealthMax) && V.LinkHealMult > float(0))
	{
		return 1.2000000;
	}
	V = UTVehicle(B.RouteGoal);
	// End:0x2B4
	if((((V != none) && B.Enemy == none) && VSize(Instigator.Location - B.RouteGoal.Location) < (1.5000000 * WeaponRange)) && V.TeamLink(int(B.GetTeamNum())))
	{
		return 1.2000000;
	}
	O = UTGameObjective(B.Squad.SquadObjective);
	// End:0x3F8
	if(((((O != none) && O.TeamLink(int(B.GetTeamNum()))) && O.NeedsHealing()) && VSize(Instigator.Location - O.Location) < (1.1000000 * (GetTraceRange()))) && B.LineOfSightTo(O))
	{
		return 1.2000000;
	}
	// End:0x4AE
	if(B.Enemy != none)
	{
		Dist = VSize(B.Enemy.Location - Instigator.Location);
		// End:0x4AE
		if(Dist > float(3500))
		{
			return (AIRating * float(3500)) / Dist;
		}
	}
	return AIRating * FMin(Pawn(Owner).GetDamageScaling(), 1.5000000);
	//return ReturnValue;	
}

function bool FocusOnLeader(bool bLeaderFiring)
{
	local UTBot B;
	local UTVehicle LinkVehicle;
	local Actor Other;
	local Vector HitLocation, HitNormal, StartTrace;
	local Controller SquadLeader;

	B = UTBot(Instigator.Controller);
	// End:0x68
	if((B == none) || B.Squad == none)
	{
		return false;
	}
	SquadLeader = UTSquadAI(B.Squad).SquadLeader;
	// End:0xBF
	if(SquadLeader == none)
	{
		return false;
	}
	// End:0x10B
	if(PlayerController(SquadLeader) != none)
	{
		LinkVehicle = UTVehicle(SquadLeader.Pawn);		
	}
	else
	{
		LinkVehicle = UTSquadAI(B.Squad).GetLinkVehicle(B);
	}
	// End:0x1AC
	if(LinkVehicle == none)
	{
		LinkVehicle = UTVehicle(SquadLeader.Pawn);
		// End:0x1AC
		if(LinkVehicle == none)
		{
			return false;
		}
	}
	// End:0x263
	if((((B.Enemy != none) && !LinkVehicle.bKeyVehicle) || LinkVehicle.Health >= LinkVehicle.HealthMax) || LinkVehicle.LinkHealMult <= float(0))
	{
		return false;
	}
	StartTrace = Instigator.GetPawnViewLocation();
	// End:0x354
	if(VSize(LinkVehicle.Location - StartTrace) < (GetTraceRange()))
	{
		Other = Trace(HitLocation, HitNormal, LinkVehicle.GetTargetLocation(), StartTrace, true);
		// End:0x354
		if(Other == LinkVehicle)
		{
			B.Focus = Other;
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function byte BestMode()
{
	local float enemyDist;
	local UTBot B;
	local UTVehicle V;
	local UTGameObjective ObjTarget;

	// End:0x27
	if(WorldInfo.IsConsoleBuild(3))
	{
		return 0;
	}
	B = UTBot(Instigator.Controller);
	// End:0x6A
	if(B == none)
	{
		return 0;
	}
	ObjTarget = UTGameObjective(B.Focus);
	// End:0xF2
	if((ObjTarget != none) && ObjTarget.TeamLink(int(B.GetTeamNum())))
	{
		return 1;
	}
	// End:0x173
	if(FocusOnLeader(B.Focus == UTSquadAI(B.Squad).SquadLeader.Pawn))
	{
		return 1;
	}
	V = UTVehicle(B.Focus);
	// End:0x201
	if((V != none) && WorldInfo.GRI.OnSameTeam(B, V))
	{
		return 1;
	}
	// End:0x228
	if(B.Enemy == none)
	{
		return 0;
	}
	enemyDist = VSize(B.Enemy.Location - Instigator.Location);
	// End:0x2A1
	if(enemyDist > WeaponRange)
	{
		return 0;
	}
	return 1;
	//return ReturnValue;	
}

function bool CanHeal(Actor Other)
{
	// End:0x17
	if(!HasAmmo(1))
	{
		return false;		
	}
	else
	{
		// End:0x7C
		if(UTGameObjective(Other) != none)
		{
			return UTGameObjective(Other).TeamLink(int(Instigator.GetTeamNum()));			
		}
		else
		{
			return (UTVehicle(Other) != none) && UTVehicle(Other).LinkHealMult > 0.0000000;
		}
	}
	//return ReturnValue;	
}

function float GetOptimalRangeFor(Actor Target)
{
	return ((WorldInfo.GRI.OnSameTeam(Target, Instigator)) ? WeaponRange : super(UTWeapon).GetOptimalRangeFor(Target));
	//return ReturnValue;	
}

function float SuggestAttackStyle()
{
	return 0.8000000;
	//return ReturnValue;	
}

function float SuggestDefenseStyle()
{
	return -0.4000000;
	//return ReturnValue;	
}

function bool DenyPickupQuery(Class<Inventory> ItemClass, Actor Pickup)
{
	// End:0x21
	if(ItemClass == Class)
	{
		BoostPower();
	}
	return super(UTWeapon).DenyPickupQuery(ItemClass, Pickup);
	//return ReturnValue;	
}

simulated function BoostPower()
{
	AIRating = 0.7100000;
	CurrentRating = 0.7100000;
	FireInterval[0] = 0.1600000;
	WeaponRange = 900.0000000;
	bFullPower = true;
	// End:0x9F
	if(WeaponMaterialInstance != none)
	{
		WeaponMaterialInstance.SetVectorParameterValue('Paint_Color', Class'UTGame.UTHUD'.default.WhiteLinearColor);
	}
	//return;	
}

simulated state WeaponBeamFiring
{
	simulated function EndFire(byte FireModeNum)
	{
		UnLink();
		super.EndFire(FireModeNum);
		//return;		
	}

	simulated function SetCurrentFireMode(byte FiringModeNum)
	{
		local byte InstigatorFireMode;

		CurrentFireMode = FiringModeNum;
		// End:0x130
		if(Instigator != none)
		{
			// End:0xF4
			if(int(CurrentFireMode) == int(1))
			{
				// End:0x54
				if(LinkedTo != none)
				{
					InstigatorFireMode = 2;					
				}
				else
				{
					CalcLinkStrength();
					// End:0xC2
					if((LinkStrength > 1) || Instigator.DamageScaling >= 2.0000000)
					{
						// End:0xB3
						if(bBeamHit)
						{
							InstigatorFireMode = 4;							
						}
						else
						{
							InstigatorFireMode = 3;
						}						
					}
					else
					{
						// End:0xDE
						if(bBeamHit)
						{
							InstigatorFireMode = 5;							
						}
						else
						{
							InstigatorFireMode = CurrentFireMode;
						}
					}
				}				
			}
			else
			{
				InstigatorFireMode = CurrentFireMode;
			}
			Instigator.SetFiringMode(self, InstigatorFireMode);
		}
		//return;		
	}

	function SetFlashLocation(Vector HitLocation)
	{
		global.SetFlashLocation(HitLocation);
		SetCurrentFireMode(CurrentFireMode);
		//return;		
	}

	simulated function Tick(float DeltaTime)
	{
		// End:0x50
		if(ReaccquireTimer > float(0))
		{
			ReaccquireTimer -= DeltaTime;
			// End:0x50
			if(ReaccquireTimer <= float(0))
			{
				ReaccquireTimer = 0.0000000;
				UnLink();
			}
		}
		UpdateBeam(DeltaTime);
		//return;		
	}

	simulated function BeginState(name PreviousStateName)
	{
		super.BeginState(PreviousStateName);
		// End:0xBD
		if(((PlayerController(Instigator.Controller) != none) && Instigator.IsLocallyControlled()) && (BeamLight == none) || BeamLight.bDeleteMe)
		{
			BeamLight = Spawn(Class'UTGame.UTLinkBeamLight');
		}
		WeaponPlaySound(StartAltFireSound);
		//return;		
	}

	simulated function EndState(name NextStateName)
	{
		local Color EffectColor;
		local LinearColor LinEffectColor;

		WeaponPlaySound(EndAltFireSound);
		super.EndState(NextStateName);
		// End:0x4E
		if(BeamLight != none)
		{
			BeamLight.Destroy();
		}
		ReaccquireTimer = 0.0000000;
		UnLink();
		Victim = none;
		LinkAttachmentClass.static.GetTeamBeamInfo(255, EffectColor);
		// End:0xFC
		if(WeaponMaterialInstance != none)
		{
			LinEffectColor = ColorToLinearColor(EffectColor);
			WeaponMaterialInstance.SetVectorParameterValue('TeamColor', LinEffectColor);
		}
		// End:0x134
		if(MuzzleFlashPSC != none)
		{
			MuzzleFlashPSC.ClearParameter('Link_Beam_Color');
		}
		//return;		
	}

	simulated function bool CanViewAccelerationWhenFiring()
	{
		return true;
		//return ReturnValue;		
	}
	stop;	
}

simulated state WeaponPuttingDown
{
	simulated function WeaponIsDown()
	{
		UnLink();
		LinkedList.Length = 0;
		super.WeaponIsDown();
		//return;		
	}
	stop;	
}

simulated state WeaponEquipping
{
	simulated event BeginState(name PreviousStateName)
	{
		local LinearColor TeamColor;

		super.BeginState(PreviousStateName);
		// End:0x1CE
		if(((((!bFullPower && WorldInfo.GRI != none) && WorldInfo.GRI.GameClass.default.bTeamGame) && Instigator != none) && Instigator.PlayerReplicationInfo != none) && Instigator.PlayerReplicationInfo.Team != none)
		{
			// End:0x17B
			if(Instigator.PlayerReplicationInfo.Team.TeamIndex == 0)
			{
				TeamColor.R = 0.2000000;				
			}
			else
			{
				TeamColor.B = 0.4000000;
			}
			WeaponMaterialInstance.SetVectorParameterValue('Paint_Color', TeamColor);
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	WeaponLinkDistance=160.0000000
	LinkStrength=1
	LinkFlexibility=0.6400000
	LinkBreakDelay=0.5000000
	MomentumTransfer=50000.0000000
	BeamAmmoUsePerSecond=8.5000000
	bAutoCharge=true
	RechargeRate=1.0000000
	MinimumDamage=5.0000000
	// Reference: ParticleSystemComponent'UTGame.Default__UTWeap_LinkGun.PoweredUpComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PoweredUpComponent'
	begin object name="PoweredUpComponent" class=Engine.ParticleSystemComponent
		Template=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_PoweredUp'
		bAutoActivate=false
		ReplacementPrimitive=none
		DepthPriorityGroup=SDPG_Foreground
	end object
	PoweredUpEffect=PoweredUpComponent
	PoweredUpEffectSocket="PowerEffectSocket"
	TeamMuzzleFlashTemplates[0]=ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_MF_Beam_Red'
	TeamMuzzleFlashTemplates[1]=ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_MF_Beam_Blue'
	TeamMuzzleFlashTemplates[2]=ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_MF_Beam'
	HighPowerMuzzleFlashTemplate=ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_MF_Beam_Gold'
	BeamTemplate[1]=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Altbeam'
	BeamSockets[1]="MuzzleFlashSocket02"
	EndPointParamName="LinkBeamEnd"
	BeamPreFireAnim[1]="WeaponAltFireStart"
	BeamFireAnim[1]="WeaponAltFire"
	BeamPostFireAnim[1]="WeaponAltFireEnd"
	// Reference: ForceFeedbackWaveform'UTGame.Default__UTWeap_LinkGun.BeamForceFeedbackWaveform1'
	begin object name="BeamForceFeedbackWaveform1" class=Engine.ForceFeedbackWaveform
		bIsLooping=true
		Samples[0]=(LeftAmplitude=20,RightAmplitude=10,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.1000000)
	end object
	BeamWeaponFireWaveForm=BeamForceFeedbackWaveform1
	bShowAltMuzzlePSCWhenWeaponHidden=true
	bMuzzleFlashPSCLoops=true
	bFastRepeater=true
	bTargetFrictionEnabled=true
	bTargetAdhesionEnabled=true
	LockerAmmoCount=100
	MaxAmmoCount=100
	// Reference: ForceFeedbackWaveform'UTGame.Default__UTWeap_LinkGun.ForceFeedbackWaveformShooting1'
	// Archetype: ForceFeedbackWaveform'UTGame.Default__UTBeamWeapon.ForceFeedbackWaveformShooting1'
	begin object name="ForceFeedbackWaveformShooting1"
	end object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	IconX=412
	IconY=82
	iconWidth=40
	iconHeight=36
	IconCoordinates=(U=453.0000000,V=467.0000000,UL=147.0000000,VL=41.0000000)
	CrossHairCoordinates=(U=384.0000000,V=0.0000000)
	InventoryGroup=1
	AttachmentClass=Class'UTGame.UTAttachment_LinkGun'
	GroupWeight=0.5000000
	WeaponColor=(R=255,G=255,B=255,A=0)
	MuzzleFlashPSCTemplate=ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_MF_Primary'
	MuzzleFlashAltPSCTemplate=ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_MF_Beam'
	MuzzleFlashColor=(R=255,G=120,B=255,A=120)
	MuzzleFlashLightClass=Class'UTGame.UTLinkGunMuzzleFlashLight'
	PlayerViewOffset=(X=-18.0000000,Y=-18.0000000,Z=16.0000000)
	LockerRotation=(Pitch=-16384,Yaw=0,Roll=0)
	CurrentRating=0.3000000
	UseHintString="The Link Gun is a brutal close-to-mid range weapon. Both the primary fire bolts and secondary beam are great for chewing up enemies at close range."
	AmmoCount=100
	FiringStatesArray[0]="WeaponFiring"
	FiringStatesArray[1]="WeaponBeamFiring"
	WeaponFireTypes[0]=0
	WeaponFireTypes[1]=0
	WeaponProjectiles[0]=Class'UTGame.UTProj_LinkPlasma'
	WeaponProjectiles[1]=none
	FireInterval[0]=0.2400000
	FireInterval[1]=0.3500000
	InstantHitDamage[0]=0.0000000
	InstantHitDamage[1]=100.0000000
	InstantHitDamageTypes[0]=Class'Engine.DamageType'
	InstantHitDamageTypes[1]=Class'UTGame.UTDmgType_LinkBeam'
	FireOffset=(X=-10.0000000,Y=10.0000000,Z=12.0000000)
	WeaponRange=500.0000000
	// Reference: UDKSkeletalMeshComponent'UTGame.Default__UTWeap_LinkGun.FirstPersonMesh'
	// Archetype: UDKSkeletalMeshComponent'UTGame.Default__UTBeamWeapon.FirstPersonMesh'
	begin object name="FirstPersonMesh"
		FOV=60.0000000
		SkeletalMesh=SkeletalMesh'WP_LinkGun.Mesh.SK_WP_Linkgun_1P'
		Animations=AnimNodeSequence'UTGame.Default__UTWeap_LinkGun.MeshSequenceA'
		AnimSets[0]=AnimSet'WP_LinkGun.Anims.K_WP_LinkGun_1P_Base'
		ReplacementPrimitive=none
		Scale=0.9000000
	end object
	Mesh=FirstPersonMesh
	Priority=2.0000000
	AIRating=0.3000000
	ItemName="Link Gun"
	MaxDesireability=0.7000000
	PickupMessage="Link Gun"
	// Reference: SkeletalMeshComponent'UTGame.Default__UTWeap_LinkGun.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	// Archetype: SkeletalMeshComponent'UTGame.Default__UTBeamWeapon.PickupMesh'
	begin object name="PickupMesh"
		SkeletalMesh=SkeletalMesh'WP_LinkGun.Mesh.SK_WP_LinkGun_3P'
		ReplacementPrimitive=none
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
}