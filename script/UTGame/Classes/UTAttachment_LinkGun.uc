class UTAttachment_LinkGun extends UTBeamWeaponAttachment
	notplaceable;

struct LinkConnection
{
	var UTWeaponAttachment TargetAttachment;
	var export editinline ParticleSystemComponent Effect;

	structdefaultproperties
	{
		TargetAttachment=none
		Effect=none
	}
};

var Color LinkBeamColors[3];
var ParticleSystem LinkBeamSystems[3];
var Color HighPowerBeamColor;
var ParticleSystem HighPowerSystem;
var MaterialInstanceConstant WeaponMaterialInstance;
var export editinline AudioComponent LinkHitSound;
var bool bHittingWall;
var ParticleSystem WallHitTemplate;
var UTEmitter HitWallEffect;
var ParticleSystem TeamBeamEndpointTemplates[3];
var ParticleSystem HighPowerBeamEndpointTemplate;
var UTEmitter BeamEndpointEffect;
var MaterialInterface BeamDecal;
var float DecalWidth;
var float DecalHeight;
var float DurationOfDecal;
var name DecalDissolveParamName;
var int TicksBetweenDecals;
var int TicksSinceLastDecal;
var ParticleSystem TeamMuzzleFlashTemplates[3];
var ParticleSystem HighPowerMuzzleFlashTemplate;
var export editinline ParticleSystemComponent PoweredUpEffect;
var name PoweredUpEffectSocket;
var array<LinkConnection> Connections;
var ParticleSystem ConnectionEffectTemplate;

static function GetTeamBeamInfo(byte TeamNum, optional out Color BeamColor, optional out ParticleSystem BeamSystem, optional out ParticleSystem BeamEndpointTemplate)
{
	BeamColor = default.LinkBeamColors[((int(TeamNum) < 3) ? int(TeamNum) : 3 - 1)];
	BeamSystem = default.LinkBeamSystems[((int(TeamNum) < 3) ? int(TeamNum) : 3 - 1)];
	BeamEndpointTemplate = default.TeamBeamEndpointTemplates[((int(TeamNum) < 3) ? int(TeamNum) : 3 - 1)];
	//return;	
}

function ParticleSystem GetTeamMuzzleFlashTemplate(byte TeamNum)
{
	// End:0x28
	if(int(TeamNum) >= 3)
	{
		TeamNum = byte(int(3) - int(1));
	}
	return default.TeamMuzzleFlashTemplates[int(TeamNum)];
	//return ReturnValue;	
}

simulated function PostBeginPlay()
{
	local Color DefaultBeamColor;
	local LinearColor BeamColor;

	super(UTWeaponAttachment).PostBeginPlay();
	// End:0xFB
	if(Mesh != none)
	{
		GetTeamBeamInfo(255, DefaultBeamColor);
		WeaponMaterialInstance = Mesh.CreateAndSetMaterialInstanceConstant(0);
		BeamColor = ColorToLinearColor(DefaultBeamColor);
		WeaponMaterialInstance.SetVectorParameterValue('TeamColor', BeamColor);
		// End:0xFB
		if(PoweredUpEffect != none)
		{
			Mesh.AttachComponentToSocket(PoweredUpEffect, PoweredUpEffectSocket);
			SetTimer(0.2500000, true, 'CheckPoweredUp');
		}
	}
	//return;	
}

simulated function SetSkin(Material NewMaterial)
{
	super(UTWeaponAttachment).SetSkin(NewMaterial);
	// End:0x5C
	if((NewMaterial == none) && Mesh != none)
	{
		Mesh.SetMaterial(0, WeaponMaterialInstance);
	}
	//return;	
}

simulated function SetImpactedActor(Actor HitActor, Vector HitLocation, Vector HitNormal, TraceHitInfo HitInfo)
{
	local SoundCue DesiredLinkHitSound;
	local MaterialInstanceTimeVarying MITV_Decal;
	local KActorFromStatic NewKActor;
	local editinline StaticMeshComponent HitStaticMesh;

	// End:0x55D
	if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
	{
		// End:0x1FC
		if(HitActor != none)
		{
			DesiredLinkHitSound = none;
			// End:0xD4
			if(!bHittingWall)
			{
				bHittingWall = UTPawn(HitActor) == none;
				// End:0xD4
				if(bHittingWall)
				{
					HitWallEffect = Spawn(Class'UTGame.UTEmitter', self,, HitLocation);
					HitWallEffect.SetTemplate(WallHitTemplate);
				}
			}
			// End:0x1C7
			if((LinkHitSound == none) || LinkHitSound.SoundCue != DesiredLinkHitSound)
			{
				// End:0x149
				if(LinkHitSound != none)
				{
					LinkHitSound.FadeOut(0.1000000, 0.0000000);
				}
				// End:0x18F
				if(Instigator != none)
				{
					LinkHitSound = Instigator.CreateAudioComponent(DesiredLinkHitSound, false, true);
				}
				// End:0x1C7
				if(LinkHitSound != none)
				{
					LinkHitSound.FadeIn(0.1000000, 1.0000000);
				}
			}
			// End:0x1F9
			if(BeamEndpointEffect != none)
			{
				BeamEndpointEffect.SetRotation(Rotator(HitNormal));
			}			
		}
		else
		{
			// End:0x24B
			if(LinkHitSound != none)
			{
				LinkHitSound.FadeOut(0.1000000, 0.0000000);
				LinkHitSound = none;
				bHittingWall = false;
			}
		}
		// End:0x552
		if(bHittingWall)
		{
			// End:0x330
			if(HitActor.bWorldGeometry)
			{
				HitStaticMesh = StaticMeshComponent(HitInfo.HitComponent);
				// End:0x330
				if((HitStaticMesh != none) && HitStaticMesh.CanBecomeDynamic())
				{
					NewKActor = Class'Engine.KActorFromStatic'.static.MakeDynamic(HitStaticMesh);
					// End:0x330
					if(NewKActor != none)
					{
						HitActor = NewKActor;
					}
				}
			}
			// End:0x383
			if(HitWallEffect != none)
			{
				HitWallEffect.SetRotation(Rotator(HitNormal));
				HitWallEffect.SetLocation(HitLocation);
			}
			// End:0x544
			if(TicksBetweenDecals <= TicksSinceLastDecal)
			{
				// End:0x536
				if(WorldInfo.MyDecalManager != none)
				{
					// End:0x4C0
					if(MaterialInstanceTimeVarying(BeamDecal) != none)
					{
						MITV_Decal = new (self) Class'Engine.MaterialInstanceTimeVarying';
						MITV_Decal.SetParent(BeamDecal);
						WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, HitLocation, Rotator(-HitNormal), DecalWidth, DecalHeight, 10.0000000, false);
						MITV_Decal.SetScalarStartTime(DecalDissolveParamName, DurationOfDecal);						
					}
					else
					{
						WorldInfo.MyDecalManager.SpawnDecal(BeamDecal, HitLocation, Rotator(-HitNormal), DecalWidth, DecalHeight, 10.0000000, true);
					}
				}
				TicksSinceLastDecal = 0;				
			}
			else
			{
				++TicksSinceLastDecal;
			}			
		}
		else
		{
			HitWallEffect = none;
		}
	}
	//return;	
}

simulated function StopMuzzleFlash()
{
	bHittingWall = false;
	super(UTWeaponAttachment).StopMuzzleFlash();
	//return;	
}

simulated function StopThirdPersonFireEffects()
{
	super(UTWeaponAttachment).StopThirdPersonFireEffects();
	// End:0x4D
	if(LinkHitSound != none)
	{
		LinkHitSound.FadeOut(0.1000000, 0.0000000);
		LinkHitSound = none;
	}
	//return;	
}

simulated event Destroyed()
{
	super(Actor).Destroyed();
	// End:0x38
	if(LinkHitSound != none)
	{
		LinkHitSound.Stop();
	}
	KillEndpointEffect();
	//return;	
}

simulated function UpdateBeam(byte FireModeNum)
{
	local Color BeamColor;
	local byte RealFireModeNum, TeamNum;
	local Vector EndPoint, CameraDir, BeamDir, CameraLocation, BeamStart;

	local Rotator CameraRotation;
	local PlayerController PC;
	local ParticleSystem BeamSystem, BeamEndpointTemplate, MuzzleFlashTemplate;
	local LinearColor LinBeamColor;

	RealFireModeNum = ((int(FireModeNum) >= int(2)) ? byte(1) : FireModeNum);
	// End:0x33B
	if(BeamEmitter[int(RealFireModeNum)] != none)
	{
		EndPoint = PawnOwner.FlashLocation;
		// End:0x1B5
		foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
		{
			PC.GetPlayerViewPoint(CameraLocation, CameraRotation);
			CameraDir = Vector(CameraRotation);
			BeamStart = BeamEmitter[int(RealFireModeNum)].GetPosition();
			BeamDir = Normal(EndPoint - BeamStart);
			// End:0x1B4
			if(((CameraDir Dot BeamDir) < -0.7500000) && (Normal(EndPoint - CameraLocation) Dot BeamDir) > 0.0000000)
			{
				EndPoint = BeamStart + (BeamDir * (VSize(CameraLocation - BeamStart) - 20.0000000));
				// End:0x1B5
				break;
			}			
		}		
		BeamEmitter[int(RealFireModeNum)].SetVectorParameter(EndPointParamName, EndPoint);
		// End:0x33B
		if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
		{
			// End:0x2B0
			if((BeamEndpointEffect != none) && !BeamEndpointEffect.bDeleteMe)
			{
				BeamEndpointEffect.SetLocation(EndPoint);
				BeamEndpointEffect.SetFloatParameter('Touch', float(((bHittingWall) ? 1 : 0)));				
			}
			else
			{
				BeamEndpointEffect = Spawn(Class'UTGame.UTEmitter', self,, EndPoint);
				BeamEndpointEffect.LifeSpan = 0.0000000;
				BeamEndpointEffect.SetFloatParameter('Touch', float(((bHittingWall) ? 1 : 0)));
			}
		}
	}
	HideEmitter(int(RealFireModeNum), false);
	HideEmitter(int(Abs(float(int(RealFireModeNum) - int(1)))), true);
	// End:0x44C
	if((int(FireModeNum) == int(2)) && WorldInfo.GRI.GameClass.default.bTeamGame)
	{
		TeamNum = Instigator.GetTeamNum();
		GetTeamBeamInfo(TeamNum, BeamColor, BeamSystem, BeamEndpointTemplate);
		MuzzleFlashTemplate = GetTeamMuzzleFlashTemplate(TeamNum);		
	}
	else
	{
		// End:0x4C5
		if((int(FireModeNum) == int(3)) || int(FireModeNum) == int(4))
		{
			BeamColor = HighPowerBeamColor;
			BeamSystem = HighPowerSystem;
			BeamEndpointTemplate = HighPowerBeamEndpointTemplate;
			MuzzleFlashTemplate = HighPowerMuzzleFlashTemplate;			
		}
		else
		{
			GetTeamBeamInfo(255, BeamColor, BeamSystem, BeamEndpointTemplate);
			MuzzleFlashTemplate = GetTeamMuzzleFlashTemplate(255);
		}
	}
	// End:0x681
	if(int(FireModeNum) > int(0))
	{
		// End:0x5B2
		if(BeamEmitter[1] != none)
		{
			// End:0x57F
			if(BeamEmitter[1].Template != BeamSystem)
			{
				BeamEmitter[1].SetTemplate(BeamSystem);
			}
			BeamEmitter[1].SetColorParameter('Link_Beam_Color', BeamColor);
		}
		// End:0x62D
		if((BeamEndpointEffect != none) && BeamEndpointEffect.ParticleSystemComponent.Template != BeamEndpointTemplate)
		{
			BeamEndpointEffect.SetTemplate(BeamEndpointTemplate, true);
		}
		// End:0x681
		if(MuzzleFlashTemplate != MuzzleFlashPSC.Template)
		{
			MuzzleFlashPSC.SetTemplate(MuzzleFlashTemplate);
		}
	}
	// End:0x6C1
	if(MuzzleFlashPSC != none)
	{
		MuzzleFlashPSC.SetColorParameter('Link_Beam_Color', BeamColor);
	}
	// End:0x788
	if(UTLinkGunMuzzleFlashLight(MuzzleFlashLight) != none)
	{
		UTLinkGunMuzzleFlashLight(MuzzleFlashLight).SetTeam((((int(FireModeNum) == int(2)) && WorldInfo.GRI.GameClass.default.bTeamGame) ? Instigator.GetTeamNum() : byte(255)));
	}
	// End:0x7E5
	if(WeaponMaterialInstance != none)
	{
		LinBeamColor = ColorToLinearColor(BeamColor);
		WeaponMaterialInstance.SetVectorParameterValue('TeamColor', LinBeamColor);
	}
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

simulated function HideEmitter(int Index, bool bHide)
{
	local Color EffectColor;
	local LinearColor LinEffectColor;

	super.HideEmitter(Index, bHide);
	// End:0xF1
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
		KillEndpointEffect();
	}
	//return;	
}

simulated function CheckPoweredUp()
{
	local UTPawn UTP;
	local bool bPoweredUp, bInstigatorFirstPerson;
	local array<byte> ConnectionStillValid;
	local int Index;
	local editinline ParticleSystemComponent NewEffect;

	// End:0x884
	if((Instigator != none) && WorldInfo.GRI != none)
	{
		ConnectionStillValid.Length = Connections.Length;
		bInstigatorFirstPerson = (Instigator.IsFirstPerson() && Instigator.Weapon != none) && SkeletalMeshComponent(Instigator.Weapon.Mesh) != none;
		// End:0x7A4
		foreach WorldInfo.AllPawns(Class'UTGame.UTPawn', UTP, Instigator.Location, Class<UTWeap_LinkGun>(WeaponClass).default.WeaponLinkDistance)
		{
			// End:0x7A3
			if((((((UTP != Instigator) && !UTP.bNoWeaponFiring) && UTP.DrivenVehicle == none) && UTAttachment_LinkGun(UTP.CurrentWeaponAttachment) != none) && WorldInfo.GRI.OnSameTeam(Instigator, UTP)) && FastTrace(UTP.Location, Instigator.Location))
			{
				bPoweredUp = true;
				// End:0x7A3
				if(!UTP.IsFirstPerson())
				{
					Index = Connections.Find('TargetAttachment', UTP.CurrentWeaponAttachment);
					// End:0x314
					if(Index != -1)
					{
						ConnectionStillValid[Index] = 1;
						// End:0x7A3
						continue;
					}
					// End:0x7A3
					if(bInstigatorFirstPerson || UTAttachment_LinkGun(UTP.CurrentWeaponAttachment).Connections.Find('TargetAttachment', self) == -1)
					{
						Index = Connections.Find('TargetAttachment', none);
						// End:0x481
						if(Index != -1)
						{
							Connections[Index].TargetAttachment = UTP.CurrentWeaponAttachment;
							Connections[Index].Effect.SetVectorParameter(EndPointParamName, UTP.CurrentWeaponAttachment.Mesh.GetPosition());							
						}
						else
						{
							Index = Connections.Length;
							Connections.Length = Connections.Length + 1;
							Connections[Index].TargetAttachment = UTP.CurrentWeaponAttachment;
							NewEffect = new (self) Class'Engine.ParticleSystemComponent';
							NewEffect.bAutoActivate = false;
							NewEffect.SetTemplate(ConnectionEffectTemplate);
							NewEffect.SetVectorParameter(EndPointParamName, UTP.CurrentWeaponAttachment.Mesh.GetPosition());
							Connections[Index].Effect = NewEffect;
						}
						// End:0x6C3
						if(bInstigatorFirstPerson)
						{
							Connections[Index].Effect.SetDepthPriorityGroup(2);
							SkeletalMeshComponent(Instigator.Weapon.Mesh).AttachComponentToSocket(Connections[Index].Effect, PoweredUpEffectSocket);							
						}
						else
						{
							Connections[Index].Effect.SetDepthPriorityGroup(1);
							Mesh.AttachComponentToSocket(Connections[Index].Effect, PoweredUpEffectSocket);
						}
						Connections[Index].Effect.SetActive(true);
						ConnectionStillValid[Index] = 1;
					}
				}
			}			
		}		
		PoweredUpEffect.SetActive(bPoweredUp);
		Index = 0;
		J0x7DA:

		// End:0x884 [Loop If]
		if(Index < Connections.Length)
		{
			// End:0x876
			if(int(ConnectionStillValid[Index]) == int(0))
			{
				Connections[Index].TargetAttachment = none;
				Connections[Index].Effect.SetActive(false);
			}
			Index++;
			// [Loop Continue]
			goto J0x7DA;
		}
	}
	//return;	
}

simulated function ChangeVisibility(bool bIsVisible)
{
	super(UTWeaponAttachment).ChangeVisibility(bIsVisible);
	// End:0x4E
	if(PoweredUpEffect != none)
	{
		PoweredUpEffect.SetHidden(!bIsVisible);
	}
	//return;	
}

state CurrentlyAttached
{
	simulated event Tick(float DeltaTime)
	{
		local int I;

		super.Tick(DeltaTime);
		I = 0;
		J0x1E:

		// End:0x106 [Loop If]
		if(I < Connections.Length)
		{
			// End:0xF8
			if(Connections[I].TargetAttachment != none)
			{
				Connections[I].Effect.SetVectorParameter(EndPointParamName, Connections[I].TargetAttachment.Mesh.GetPosition());
			}
			I++;
			// [Loop Continue]
			goto J0x1E;
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	LinkBeamColors[0]=(R=64,G=255,B=255,A=64)
	LinkBeamColors[1]=(R=64,G=64,B=255,A=255)
	LinkBeamColors[2]=(R=220,G=128,B=255,A=120)
	LinkBeamSystems[0]=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Altbeam_Red'
	LinkBeamSystems[1]=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Altbeam_Blue'
	LinkBeamSystems[2]=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Altbeam'
	HighPowerBeamColor=(R=192,G=192,B=255,A=32)
	HighPowerSystem=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Altbeam_Gold'
	WallHitTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Beam_Impact_HIT'
	TeamBeamEndpointTemplates[0]=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Beam_Impact_Red'
	TeamBeamEndpointTemplates[1]=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Beam_Impact_Blue'
	TeamBeamEndpointTemplates[2]=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Beam_Impact'
	HighPowerBeamEndpointTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Beam_Impact_Gold'
	BeamDecal=MaterialInstanceTimeVarying'WP_FlakCannon.Decals.MITV_WP_FlakCannon_Impact_Decal01'
	DecalWidth=32.0000000
	DecalHeight=32.0000000
	DurationOfDecal=20.0000000
	DecalDissolveParamName="DissolveAmount"
	TeamMuzzleFlashTemplates[0]=ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_3P_Beam_MF_Red'
	TeamMuzzleFlashTemplates[1]=ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_3P_Beam_MF_Blue'
	TeamMuzzleFlashTemplates[2]=ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_3P_Beam_MF'
	HighPowerMuzzleFlashTemplate=ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_3P_Beam_MF_Gold'
	// Reference: ParticleSystemComponent'UTGame.Default__UTAttachment_LinkGun.PoweredUpComponent'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PoweredUpComponent'
	begin object name="PoweredUpComponent" class=Engine.ParticleSystemComponent
		Template=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_PoweredUp'
		bAutoActivate=false
		ReplacementPrimitive=none
	end object
	PoweredUpEffect=PoweredUpComponent
	PoweredUpEffectSocket="PowerEffectSocket"
	ConnectionEffectTemplate=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Connection_Beam'
	BeamTemplate[1]=ParticleSystem'WP_LinkGun.Effects.P_WP_Linkgun_Altbeam'
	BeamSockets[1]="MussleFlashSocket02"
	EndPointParamName="LinkBeamEnd"
	// Reference: SkeletalMeshComponent'UTGame.Default__UTAttachment_LinkGun.SkeletalMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'SkeletalMeshComponent0'
	// Archetype: SkeletalMeshComponent'UTGame.Default__UTBeamWeaponAttachment.SkeletalMeshComponent0'
	begin object name="SkeletalMeshComponent0"
		SkeletalMesh=SkeletalMesh'WP_LinkGun.Mesh.SK_WP_LinkGun_3P'
		// Reference: UTAnimNodeSequence'UTGame.Default__UTAttachment_LinkGun.SkeletalMeshComponent0.MeshSequenceA'
		// Archetype: UTAnimNodeSequence'UTGame.Default__UTBeamWeaponAttachment.SkeletalMeshComponent0.MeshSequenceA'
		begin object name="MeshSequenceA"
		end object
		Animations=MeshSequenceA
		ReplacementPrimitive=none
		Translation=(X=1.0000000,Y=0.0000000,Z=0.0000000)
		Rotation=(Pitch=-400,Yaw=0,Roll=0)
		Scale=0.9000000
	end object
	Mesh=SkeletalMeshComponent0
	MuzzleFlashSocket="MussleFlashSocket"
	MuzzleFlashPSCTemplate=ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_3P_Primary_MF'
	MuzzleFlashAltPSCTemplate=ParticleSystem'WP_LinkGun.Effects.P_FX_LinkGun_3P_Beam_MF'
	MuzzleFlashColor=(R=255,G=120,B=255,A=120)
	bMuzzleFlashPSCLoops=true
	MuzzleFlashLightClass=Class'UTGame.UTLinkGunMuzzleFlashLight'
	MuzzleFlashDuration=0.3300000
	WeaponClass=Class'UTGame.UTWeap_LinkGun'
}