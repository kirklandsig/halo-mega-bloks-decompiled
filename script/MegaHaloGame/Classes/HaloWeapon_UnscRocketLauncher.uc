class HaloWeapon_UnscRocketLauncher extends HaloWeapon
	config(Weapon);

struct HaloWeapon_UnscRocketLauncher_Target
{
	var HaloPawn Actor;
	var float AngleOffset;

	structdefaultproperties
	{
		Actor=none
		AngleOffset=0.0000000
	}
};

var float TargetSearchRange;
var float TargetSearchAngle;
var float TargetLockRange;
var float TargetLockAngle;
var int MaxTargetCount;
var float ChargeUpDuration;
var array<HaloWeapon_UnscRocketLauncher_Target> Targets;
var float ChargeUpTimer;

function HaloPawn GetTargetActorByIndex(int I)
{
	// End:0x50
	if((I >= 0) && I < Targets.Length)
	{
		return Targets[I].Actor;
	}
	return none;
	//return ReturnValue;	
}

function int GetTargetIndex(HaloPawn Actor)
{
	local HaloWeapon_UnscRocketLauncher_Target targ;
	local int I;

	// End:0x55
	foreach Targets(targ, I)
	{
		// End:0x54
		if(targ.Actor == Actor)
		{			
			return I;
		}		
	}	
	return -1;
	//return ReturnValue;	
}

function UpdateTargets(int maxTargets)
{
	UpdateCurrentTargets();
	FindNewTargets();
	Targets.Sort(TargetLessThan);
	// End:0x5E
	if(Targets.Length > maxTargets)
	{
		Targets.Length = maxTargets;
	}
	//return;	
}

function UpdateCurrentTargets()
{
	local Vector ViewLoc;
	local Rotator ViewRot;
	local int I;
	local HaloPawn targActor;
	local Vector toTarg;
	local array<int> toRemove;

	// End:0x11
	if(Instigator == none)
	{
		return;
	}
	// End:0x7E
	if(Instigator.Controller != none)
	{
		Instigator.Controller.GetPlayerViewPoint(ViewLoc, ViewRot);		
	}
	else
	{
		ViewLoc = Instigator.Location;
		ViewRot = Instigator.Rotation;
	}
	I = 0;
	J0xD9:

	// End:0x2AB [Loop If]
	if(I < Targets.Length)
	{
		targActor = Targets[I].Actor;
		// End:0x149
		if(targActor == none)
		{
			toRemove.AddItem(I);			
		}
		else
		{
			// End:0x186
			if(targActor.Health <= 0)
			{
				toRemove.AddItem(I);				
			}
			else
			{
				toTarg = targActor.Location - Instigator.Location;
				// End:0x20B
				if(VSizeSq(toTarg) > (TargetLockRange * TargetLockRange))
				{
					toRemove.AddItem(I);					
				}
				else
				{
					Targets[I].AngleOffset = RDiff(Rotator(toTarg), ViewRot);
					// End:0x29D
					if(Targets[I].AngleOffset >= TargetLockAngle)
					{
						toRemove.AddItem(I);						
					}
				}
			}
		}
		++I;
		// [Loop Continue]
		goto J0xD9;
	}
	I = toRemove.Length - 1;
	J0x2C2:

	// End:0x2FE [Loop If]
	if(I >= 0)
	{
		Targets.Remove(toRemove[I], 1);
		--I;
		// [Loop Continue]
		goto J0x2C2;
	}
	//return;	
}

function FindNewTargets()
{
	local Vector ViewLoc;
	local Rotator ViewRot;
	local HaloWeapon_UnscRocketLauncher_Target targ;
	local Vector toTarg;

	// End:0x11
	if(Instigator == none)
	{
		return;
	}
	// End:0x7E
	if(Instigator.Controller != none)
	{
		Instigator.Controller.GetPlayerViewPoint(ViewLoc, ViewRot);		
	}
	else
	{
		ViewLoc = Instigator.Location;
		ViewRot = Instigator.Rotation;
	}
	// End:0x280
	foreach Instigator.VisibleCollidingActors(Class'MegaHaloGame.HaloPawn', targ.Actor, TargetSearchRange, Instigator.Location)
	{
		// End:0x175
		if(targ.Actor.Health <= 0)
		{
			continue;			
		}
		// End:0x1A5
		if((GetTargetIndex(targ.Actor)) >= 0)
		{
			continue;			
		}
		toTarg = targ.Actor.Location - Instigator.Location;
		targ.AngleOffset = RDiff(ViewRot, Rotator(toTarg));
		// End:0x269
		if(targ.AngleOffset > TargetSearchAngle)
		{
			continue;			
		}
		Targets.AddItem(targ);		
	}	
	//return;	
}

function int TargetLessThan(HaloWeapon_UnscRocketLauncher_Target A, HaloWeapon_UnscRocketLauncher_Target B)
{
	// End:0x3F
	if(A.AngleOffset < B.AngleOffset)
	{
		return 1;
	}
	// End:0x82
	if(A.AngleOffset > B.AngleOffset)
	{
		return -1;
	}
	return 0;
	//return ReturnValue;	
}

function UpdateTargetReticles()
{
	local HaloWeapon_UnscRocketLauncher_Target targ;
	local Vector LineStart;

	LineStart = GetMuzzleFlashLocation();
	// End:0x77
	foreach Targets(targ)
	{
		DrawDebugLine(LineStart, targ.Actor.Location, 255, 0, 0, false);		
	}	
	//return;	
}

function int CalcProjectileCount()
{
	local float T;

	T = FMin(1.0000000, ChargeUpTimer / ChargeUpDuration);
	return int(Lerp(1.0000000, float(MaxTargetCount), T));
	//return ReturnValue;	
}

function PostRender(Canvas Canvas, GFxHaloMinimapHUD HUD)
{
	local int I;
	local string Str;
	local float StringWidth, StringHeight;
	local Vector ScreenLocation;
	local Actor Target;
	local MaterialInstanceConstant MIC;
	local FontRenderInfo FontRenderInfo;
	local HaloProjectile_UnscRocket Rocket;

	Canvas.Font = Font'UI_FontLibrary.Font_ObjectiveMarker';
	FontRenderInfo = Canvas.CreateFontRenderInfo(true, true);
	I = 0;
	J0x61:

	// End:0x362 [Loop If]
	if(I < Targets.Length)
	{
		Target = GetTargetActorByIndex(I);
		// End:0x354
		if(HUD.IsInfrontOfCamera(Target.Location))
		{
			MIC = new Class'Engine.MaterialInstanceConstant';
			MIC.SetParent(Material'mainhud.ObjectiveMarkers.ObjectiveMarker_Mat');
			MIC.SetTextureParameterValue('Icon', Texture2D'mainhud.ObjectiveMarkers.OMIcon_TakeDown');
			HUD.Project(Target.Location, ScreenLocation);
			Canvas.SetPos(ScreenLocation.X - 18.0000000, ScreenLocation.Y - 16.0000000);
			Canvas.DrawMaterialTile(MIC, 64.0000000, 64.0000000,,,,, true);
			Str = "" $ string(I + 1);
			Canvas.TextSize(Str, StringWidth, StringHeight);
			Canvas.SetDrawColor(255, 255, 255);
			Canvas.SetPos(ScreenLocation.X + 21.0000000, ScreenLocation.Y + ((20.0000000 - StringHeight) * 0.5000000));
			Canvas.DrawText(Str,,,, FontRenderInfo);
		}
		I++;
		// [Loop Continue]
		goto J0x61;
	}
	// End:0x6A6
	foreach HUD.PC.DynamicActors(Class'MegaHaloGame.HaloProjectile_UnscRocket', Rocket)
	{
		Target = Rocket.SeekTarget;
		// End:0x69A
		if(Target != none)
		{
			// End:0x69A
			if(HUD.IsInfrontOfCamera(Target.Location))
			{
				MIC = new Class'Engine.MaterialInstanceConstant';
				MIC.SetParent(Material'mainhud.ObjectiveMarkers.ObjectiveMarker_Mat');
				MIC.SetTextureParameterValue('Icon', Texture2D'mainhud.ObjectiveMarkers.OMIcon_TakeDown');
				HUD.Project(Target.Location, ScreenLocation);
				Canvas.SetPos(ScreenLocation.X - 18.0000000, ScreenLocation.Y - 16.0000000);
				Canvas.DrawMaterialTile(MIC, 64.0000000, 64.0000000,,,,, true);
				Str = "" $ string(I + 1);
				Canvas.TextSize(Str, StringWidth, StringHeight);
				Canvas.SetDrawColor(255, 255, 255);
				Canvas.SetPos(ScreenLocation.X + 21.0000000, ScreenLocation.Y + ((20.0000000 - StringHeight) * 0.5000000));
				Canvas.DrawText(Str,,,, FontRenderInfo);
			}
		}
		I++;		
	}	
	//return;	
}

simulated state AquireTargets
{
	simulated event BeginState(name PrevStateName)
	{
		ChargeUpTimer = 0.0000000;
		//return;		
	}

	simulated function Tick(float DeltaTime)
	{
		ChargeUpTimer += DeltaTime;
		AmmoCount = CalcProjectileCount();
		MaxAmmoCount = AmmoCount;
		UpdateTargets(AmmoCount);
		//return;		
	}

	simulated function EndFire(byte FireMode)
	{
		FireAmmunition();
		AmmoCount = 0;
		MaxAmmoCount = 1;
		Targets.Length = 0;
		super(UTWeapon).EndFire(FireMode);
		GotoState('Active');
		//return;		
	}

	function Projectile SpawnProjectile(Class<Projectile> ProjectileClass, Vector ProjectileStart, Vector BaseProjectileDir)
	{
		local int I, J;
		local float T, theta, maxTheta;
		local Rotator baseProjRot;
		local Vector projDir;
		local Projectile Proj;
		local HaloProjectile_UnscRocket Rocket;

		// End:0x4A
		if(MaxAmmoCount > 1)
		{
			baseProjRot = Rotator(BaseProjectileDir);
			maxTheta = (5.0000000 * 0.0174533) * float(MaxAmmoCount - 1);
		}
		I = 0;
		J0x55:

		// End:0x255 [Loop If]
		if(I < MaxAmmoCount)
		{
			// End:0x166
			if(MaxAmmoCount > 1)
			{
				T = float(I);
				T /= float(MaxAmmoCount - 1);
				theta = Lerp(-maxTheta, maxTheta, T);
				projDir.X = Cos(theta);
				projDir.Y = Sin(theta);
				projDir.Z = 0.0000000;
				projDir = projDir >> baseProjRot;				
			}
			else
			{
				projDir = BaseProjectileDir;
			}
			Proj = super(HaloWeapon).SpawnProjectile(ProjectileClass, ProjectileStart, projDir);
			// End:0x247
			if(Targets.Length > 0)
			{
				J = I % Targets.Length;
				Rocket = HaloProjectile_UnscRocket(Proj);
				// End:0x247
				if(Rocket != none)
				{
					Rocket.SetTarget(Targets[J].Actor);
				}
			}
			++I;
			// [Loop Continue]
			goto J0x55;
		}
		return none;
		//return ReturnValue;		
	}
	stop;	
}

defaultproperties
{
	TargetSearchRange=8000.0000000
	TargetSearchAngle=45.0000000
	TargetLockRange=9000.0000000
	TargetLockAngle=75.0000000
	MaxTargetCount=3
	ChargeUpDuration=1.5000000
	HUDIcon="assaultRifle"
	ExtraAmmoCount=5
	MaxExtraAmmoCount=5
	bInfiniteExtraAmmo=true
	akWeaponType="UNSC_Mortar"
	SpreadMin=0.0208000
	SpreadMax=0.1744000
	SpreadIncWithEachShot=0.0200000
	MeleeRange=250.0000000
	ReadyPawnAnimName="Ready_Rifle"
	FirePawnAnimName="Fire_Rifle"
	FireChargedPawnAnimName="Fire_Rifle"
	RelaxPawnAnimName="Relax_Rifle"
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher.FireWaveform1'
	begin object name="FireWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=60,RightAmplitude=60,LeftFunction=EWaveformFunction.WF_LinearDecreasing,RightFunction=EWaveformFunction.WF_LinearDecreasing,Duration=0.2000000)
	end object
	FireWaveform=FireWaveform1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher.ReloadWaveform1'
	begin object name="ReloadWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=30,RightAmplitude=30,LeftFunction=EWaveformFunction.WF_LinearDecreasing,RightFunction=EWaveformFunction.WF_LinearDecreasing,Duration=0.2500000)
	end object
	RemoveClipWaveform=ReloadWaveform1
	InsertClipWaveform=ReloadWaveform1
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher.MeleeWaveform1'
	begin object name="MeleeWaveform1" class=Engine.ForceFeedbackWaveform
		Samples[0]=(LeftAmplitude=60,RightAmplitude=60,LeftFunction=EWaveformFunction.WF_LinearDecreasing,RightFunction=EWaveformFunction.WF_LinearDecreasing,Duration=0.2000000)
	end object
	MeleeWaveform=MeleeWaveform1
	RemoveClipFeedbackDelay=0.5000000
	InsertClipFeedbackDelay=1.0000000
	MeleeFeedbackDelay=0.1000000
	// Reference: CameraShake'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher.FireCameraShake1'
	begin object name="FireCameraShake1" class=Engine.CameraShake
		OscillationDuration=0.1000000
		RotOscillation=(Pitch=(Amplitude=10.0000000,Frequency=1.0000000,InitialOffset=EInitialOscillatorOffset.EOO_OffsetZero),Yaw=(Amplitude=10.0000000,Frequency=1.0000000,InitialOffset=EInitialOscillatorOffset.EOO_OffsetZero))
	end object
	FireCameraShake=FireCameraShake1
	// Reference: CameraShake'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher.MeleeCameraShake1'
	begin object name="MeleeCameraShake1" class=Engine.CameraShake
		OscillationDuration=0.4000000
		RotOscillation=(Pitch=(Amplitude=100.0000000,Frequency=1.0000000),Yaw=(Amplitude=1000.0000000,Frequency=2.0000000))
	end object
	MeleeCameraShake=MeleeCameraShake1
	bShouldDrawCrosshairDropShadow=false
	LockerAmmoCount=6
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher.ForceFeedbackWaveformShooting1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon.ForceFeedbackWaveformShooting1'
	begin object name="ForceFeedbackWaveformShooting1"
	end object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	CrossHairCoordinates=(U=256.0000000,V=0.0000000)
	CrosshairImage=Texture2D'mainhud.Crosshairs'
	WeaponName="Weapon_UnscRocketLauncher"
	HUDFrameName="assaultRifle"
	InventoryGroup=1
	AttachmentClass=Class'MegaHaloGame.HaloWeaponAttachment_UnscRocketLauncher'
	AmmoCount=1
	FiringStatesArray[0]="AquireTargets"
	FiringStatesArray[1]="WeaponFiring"
	WeaponFireTypes[0]=0
	WeaponFireTypes[1]=0
	WeaponProjectiles[0]=Class'MegaHaloGame.HaloProjectile_UnscRocket'
	WeaponProjectiles[1]=none
	FireInterval[0]=0.1500000
	FireInterval[1]=1.0000000
	Spread[0]=0.0208000
	Spread[1]=0.0000000
	InstantHitDamage[0]=16.6669998
	InstantHitDamage[1]=0.0000000
	InstantHitDamageTypes[0]=Class'MegaHaloGame.HaloDamageType_UnscRocket'
	InstantHitDamageTypes[1]=Class'Engine.DamageType'
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher.FirstPersonMesh'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon.FirstPersonMesh'
	begin object name="FirstPersonMesh"
		ReplacementPrimitive=none
	end object
	Mesh=FirstPersonMesh
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_UnscRocketLauncher.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon.PickupMesh'
	begin object name="PickupMesh"
		ReplacementPrimitive=none
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
}