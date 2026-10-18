class HaloWeapon_EnergySword extends HaloWeapon_Melee
	config(Weapon);

simulated event PostBeginPlay()
{
	super(HaloWeapon).PostBeginPlay();
	AddSwipeKey(0, 0.1721000, vect(-153.6699982, 38.2099991, -23.6000004));
	AddSwipeKey(0, 0.2058000, vect(-106.7200012, 116.2600021, -16.3400002));
	AddSwipeKey(0, 0.2394000, vect(9.3100004, 159.1799927, -15.1199999));
	AddSwipeKey(0, 0.2730000, vect(114.2099991, 126.7300034, -6.0500002));
	AddSwipeKey(0, 0.3056000, vect(172.5000000, 40.3100014, 34.4300003));
	AddSwipeKey(0, 0.3393000, vect(150.7299957, -64.6299973, 87.3499985));
	AddSwipeKey(0, 0.3732000, vect(64.5400009, -136.7500000, 102.4400024));
	AddSwipeKey(0, 0.4057000, vect(-12.5500002, -149.5399933, 86.7699966));
	AddSwipeKey(0, 0.4125000, vect(-20.2700005, -148.7400055, 82.4899979));
	AddSwipeKey(1, 0.1160000, vect(-75.6800003, -107.7699966, -19.0400009));
	AddSwipeKey(1, 0.1498000, vect(-37.8199997, -115.0800018, -17.2199993));
	AddSwipeKey(1, 0.1836000, vect(24.7099991, -112.9000015, -10.0799999));
	AddSwipeKey(1, 0.2164000, vect(103.0899963, -72.0599976, -2.4300001));
	AddSwipeKey(1, 0.2502000, vect(152.6900024, 43.4599991, 29.9799995));
	AddSwipeKey(1, 0.2830000, vect(82.0100021, 163.1399994, 96.2900009));
	AddSwipeKey(1, 0.3169000, vect(-65.8199997, 163.2899933, 156.8399963));
	AddSwipeKey(1, 0.3486000, vect(-144.6799927, 92.3899994, 164.7599945));
	AddSwipeKey(2, 0.3947000, vect(-33.5499992, -115.3799973, 118.7300034));
	AddSwipeKey(2, 0.4113000, vect(85.3499985, -124.6900024, 108.0000000));
	AddSwipeKey(2, 0.4285000, vect(182.1900024, -18.1700001, 86.4700012));
	AddSwipeKey(2, 0.4449000, vect(155.3200073, 125.6800003, 73.5299988));
	AddSwipeKey(2, 0.4617000, vect(19.0699997, 202.6100006, 74.7600021));
	AddSwipeKey(2, 0.4783000, vect(-103.4899979, 169.3999939, 83.0699997));
	AddSwipeKey(2, 0.4950000, vect(-173.6000061, 76.9499969, 89.6100006));
	AddSwipeKey(2, 0.5015000, vect(-182.6699982, 37.4399986, 90.7600021));
	//return;	
}

defaultproperties
{
	ComboAttackDescs[0]=(Damage=67,DamageType=Class'MegaHaloGame.HaloDamageType_Melee',SwipeKeyFrames=none,SwipeExtent=(X=40.0000000,Y=40.0000000,Z=40.0000000),TargetRange=180.0000000,TargetAngle=90.0000000,DamageAngle=45.0000000,DamageRange=150.0000000,AnimName="Sword_Combo_1",BlendInTime=0.1000000,BlendOutTime=0.2000000,bIsFullBodyAnim=true,bLockMovementInput=true,bUseRootMotion=true,HitFxTemplate=ParticleSystem'wp_cov_energysword.Effects.W_COV_ENERGYSWORD_HIT',RibbonTemplate=ParticleSystem'wp_cov_energysword.Effects.W_COV_ENERGYSWORD_SWIPE')
	ComboAttackDescs[1]=(Damage=67,DamageType=Class'MegaHaloGame.HaloDamageType_Melee',SwipeKeyFrames=none,SwipeExtent=(X=40.0000000,Y=40.0000000,Z=40.0000000),TargetRange=180.0000000,TargetAngle=90.0000000,DamageAngle=45.0000000,DamageRange=150.0000000,AnimName="Sword_Combo_2",BlendInTime=0.0000000,BlendOutTime=0.2000000,bIsFullBodyAnim=true,bLockMovementInput=true,bUseRootMotion=true,HitFxTemplate=ParticleSystem'wp_cov_energysword.Effects.W_COV_ENERGYSWORD_HIT',RibbonTemplate=ParticleSystem'wp_cov_energysword.Effects.W_COV_ENERGYSWORD_SWIPE')
	ComboAttackDescs[2]=(Damage=67,DamageType=Class'MegaHaloGame.HaloDamageType_Melee',SwipeKeyFrames=none,SwipeExtent=(X=40.0000000,Y=40.0000000,Z=40.0000000),TargetRange=180.0000000,TargetAngle=90.0000000,DamageAngle=45.0000000,DamageRange=150.0000000,AnimName="Sword_Combo_3",BlendInTime=0.0000000,BlendOutTime=0.2000000,bIsFullBodyAnim=true,bLockMovementInput=true,bUseRootMotion=true,HitFxTemplate=ParticleSystem'wp_cov_energysword.Effects.W_COV_ENERGYSWORD_HIT',RibbonTemplate=ParticleSystem'wp_cov_energysword.Effects.W_COV_ENERGYSWORD_SWIPE')
	LeapAttackDesc=(Damage=500,DamageType=Class'MegaHaloGame.HaloDamageType_Ram',TargetRange=1000.0000000,TargetAngle=45.0000000,LoopDuration=0.3333330,AnimNameLoop="Charge_Air")
	LeapChargeUpPawnAnimName="Sword_ChargeUp"
	HUDIcon="energySword"
	bIsEnergyPowered=true
	HeatPerShot=0.1000000
	CooldownRate=0.3000000
	CooldownPawnAnimName="Overheat_Pistol"
	akWeaponType="COV_EnergySword"
	SpreadMin=0.0200000
	SpreadMax=0.1400000
	SpreadIncWithEachShot=0.0300000
	SpreadDecRate=-0.1000000
	ThrowGrenadePawnAnimName="ThrowGrenade_Pistol"
	ReadyPawnAnimName="Ready_Pistol"
	FirePawnAnimName="Fire_Pistol"
	FireChargedPawnAnimName="Fire_Pistol_Charged"
	RelaxPawnAnimName="Relax_Pistol"
	bShouldDrawCrosshairDropShadow=false
	MaxAmmoCount=100
	ShotCost[0]=2
	ShotCost[1]=20
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_EnergySword.ForceFeedbackWaveformShooting1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_Melee.ForceFeedbackWaveformShooting1'
	begin object name="ForceFeedbackWaveformShooting1"
	end object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	CrossHairCoordinates=(U=256.0000000,V=0.0000000)
	CrosshairImage=Texture2D'mainhud.Crosshairs'
	WeaponName="Weapon_EnergySword"
	HUDFrameName="energySword"
	InventoryGroup=1
	AmmoCount=100
	Spread[0]=0.0200000
	Spread[1]=0.0000000
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_EnergySword.FirstPersonMesh'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_Melee.FirstPersonMesh'
	begin object name="FirstPersonMesh"
		ReplacementPrimitive=none
	end object
	Mesh=FirstPersonMesh
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_EnergySword.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_Melee.PickupMesh'
	begin object name="PickupMesh"
		ReplacementPrimitive=none
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
}