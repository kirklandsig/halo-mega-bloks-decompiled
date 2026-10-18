class HaloDeployableBubbleShield extends Actor
	placeable
	implements(IHaloDeployable);

var archetype HaloDestructibleActor GeneratorArchetype;
var archetype HaloDestructibleActor ShieldArchetype;
var export editinline ParticleSystemComponent SpawnPSComponent;
var bool bAreChildrenHidden;
var float SpawnShieldTimer;
var HaloDestructibleActor Generator;
var HaloDestructibleActor Shield;
var MaterialInstanceConstant DamageMaterial;
var LinearColor InitialColor;
var int LastShieldHealth;
var HaloWeapon_TargetDesignator.ETargetDesignatorCategory DeployableCategory;
var name DeployableName;
var Actor DeployableBase;

simulated event Destroyed()
{
	// End:0x33
	if(Generator != none)
	{
		Generator.LifeSpan = 0.0010000;
	}
	// End:0x66
	if(Shield != none)
	{
		Shield.LifeSpan = 0.0010000;
	}
	PlayAkEvent(AkEvent'Equipment.Play_Equipment_Destroyed');
	SetSwitch('Explosion_Type', 'Explosion_Concussive');
	SetSwitch('Explosion_Size', 'Explosion_Med');
	PlayAkEvent(AkEvent'Foley.Play_Explosion');
	super.Destroyed();
	//return;	
}

event Tick(float DeltaTime)
{
	// End:0x9E
	if(bHidden != bAreChildrenHidden)
	{
		// End:0x51
		if(Generator != none)
		{
			Generator.SetHidden(bHidden);
		}
		// End:0x89
		if(Shield != none)
		{
			Shield.SetHidden(bHidden);
		}
		bAreChildrenHidden = bHidden;
	}
	super.Tick(DeltaTime);
	//return;	
}

function bool ShouldDie()
{
	return (((Generator == none) || Generator.Health <= 0) || Shield == none) || Shield.Health <= 0;
	//return ReturnValue;	
}

function UpdateShieldColor()
{
	local float curHealth;
	local LinearColor newColor;

	// End:0x249
	if((Shield != none) && DamageMaterial != none)
	{
		// End:0x249
		if(Shield.Health != LastShieldHealth)
		{
			LastShieldHealth = Shield.Health;
			curHealth = 1.0000000 - (float(LastShieldHealth) / float(Shield.HealthMax));
			newColor.R = InitialColor.R + ((1.0000000 - InitialColor.R) * curHealth);
			newColor.G = InitialColor.G - (InitialColor.G * curHealth);
			newColor.B = InitialColor.B - (InitialColor.B * curHealth);
			newColor.A = InitialColor.A;
			DamageMaterial.SetVectorParameterValue('Damage Color', newColor);
		}
	}
	//return;	
}

function HaloWeapon_TargetDesignator.ETargetDesignatorCategory GetDeployableCategory()
{
	return DeployableCategory;
	//return ReturnValue;	
}

function SetDeployableCategory(HaloWeapon_TargetDesignator.ETargetDesignatorCategory newCategory)
{
	DeployableCategory = newCategory;
	//return;	
}

function name GetDeployableName()
{
	return DeployableName;
	//return ReturnValue;	
}

function SetDeployableName(name NewName)
{
	DeployableName = NewName;
	//return;	
}

function Actor GetDeployableBase()
{
	return DeployableBase;
	//return ReturnValue;	
}

function SetDeployableBase(Actor NewBase)
{
	DeployableBase = NewBase;
	//return;	
}

function Actor GetDeployable()
{
	return self;
	//return ReturnValue;	
}

function array< Class<HaloVCustomizationComponent> > GetCustomizations()
{
	local array< Class<HaloVCustomizationComponent> > returnArr;

	returnArr.Length = 0;
	return returnArr;
	//return ReturnValue;	
}

function SetCustomizations(array< Class<HaloVCustomizationComponent> > Customizations)
{
	//return;	
}

auto state Spawning
{
	event BeginState(name PreviousStateName)
	{
		SpawnPSComponent.ActivateSystem();
		Generator = Spawn(GeneratorArchetype.Class, self,, Location, Rotation, GeneratorArchetype, true);
		SetSwitch('Equipment_Type', 'BubbleShield');
		PlayAkEvent(AkEvent'Equipment.Play_Equipment_Activate');
		//return;		
	}

	event Tick(float DeltaTime)
	{
		SpawnShieldTimer -= DeltaTime;
		// End:0x35
		if(SpawnShieldTimer <= 0.0000000)
		{
			GotoState('Active');
		}
		global.Tick(DeltaTime);
		//return;		
	}
	stop;	
}

state Active
{
	event BeginState(name PreviousStateName)
	{
		Shield = Spawn(ShieldArchetype.Class, self,, Location, Rotation, ShieldArchetype, true);
		// End:0x15A
		if(Shield != none)
		{
			Shield.AkObjectType = 'BubbleShield';
			Shield.bPassShotsFromWithin = true;
			DamageMaterial = Shield.SkeletalMeshComponent.CreateAndSetMaterialInstanceConstant(0);
			DamageMaterial.GetVectorParameterValue('Damage Color', InitialColor);
			LastShieldHealth = Shield.Health;
			PlayAkEvent(AkEvent'Equipment.Play_Equipment_Idle');
		}
		//return;		
	}

	event Tick(float DeltaTime)
	{
		// End:0x2C
		if(ShouldDie())
		{
			PlayAkEvent(AkEvent'Equipment.Play_Equipment_Deactivate');
			Destroy();			
		}
		else
		{
			UpdateShieldColor();
		}
		global.Tick(DeltaTime);
		//return;		
	}
	stop;	
}

defaultproperties
{
	GeneratorArchetype=HaloDestructibleActor'UNSC_BubbleShield_01.Generator_Archetype'
	ShieldArchetype=HaloDestructibleActor'UNSC_BubbleShield_01.Shield_Archetype'
	// Reference: ParticleSystemComponent'MegaHaloGame.Default__HaloDeployableBubbleShield.ParticleSystemComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'ParticleSystemComponent0'
	begin object name="ParticleSystemComponent0" class=Engine.ParticleSystemComponent
		Template=ParticleSystem'FX_BubbleShield.Effects.FX_BubbleShield_START'
		bAutoActivate=false
		ReplacementPrimitive=none
		bCastDynamicShadow=false
		bCastStaticShadow=false
		bAcceptsDynamicDominantLightShadows=false
	end object
	SpawnPSComponent=ParticleSystemComponent0
	SpawnShieldTimer=0.5000000
	InitialColor=(R=1.0000000,G=0.0000000,B=0.0000000,A=0.0000000)
	Components[0]=ParticleSystemComponent0
	// Reference: UDKTargetableComponent'MegaHaloGame.Default__HaloDeployableBubbleShield.targetableComponent'
	begin object name="targetableComponent" class=UDKBase.UDKTargetableComponent
		InnerThreatRadius=3000.0000000
		OutterThreatRadius=100000.0000000
		fAITargetHeight=50.0000000
		AITargetType=HaloTargetType.TARGET_PASSIVE_SECONDARY
		bAITargetable=true
	end object
	Components[1]=targetableComponent
	CollisionType=ECollisionType.COLLIDE_CustomDefault
}