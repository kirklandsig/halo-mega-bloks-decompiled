class HaloDroppedGrenade extends KActorSpawnable;

var bool bIsPlasmaGrenade;
var AkEvent PickupGrenadeEvent;

function Init(bool isPlasma)
{
	bIsPlasmaGrenade = isPlasma;
	// End:0x3B
	if(isPlasma)
	{
		SetStaticMesh(StaticMesh'Plasma_Grenade.Plasma_Grenade');		
	}
	else
	{
		SetStaticMesh(StaticMesh'grenade.grenade');
	}
	AddToGlobalList();
	//return;	
}

simulated function Destroyed()
{
	RemoveFromGlobalList();
	super(KActor).Destroyed();
	//return;	
}

function AddToGlobalList()
{
	local HaloGameDefault Game;
	local HaloDroppedGrenade ToDelete;

	// End:0x11
	if(WorldInfo == none)
	{
		return;
	}
	Game = HaloGameDefault(WorldInfo.Game);
	// End:0x53
	if(Game == none)
	{
		return;
	}
	Game.DroppedGrenadesList.AddItem(self);
	J0x76:

	// End:0x11F [Loop If]
	if(Game.DroppedGrenadesList.Length > Game.MaxDroppedGrenades)
	{
		ToDelete = Game.DroppedGrenadesList[0];
		Game.DroppedGrenadesList.Remove(0, 1);
		ToDelete.Destroy();
		// [Loop Continue]
		goto J0x76;
	}
	//return;	
}

function RemoveFromGlobalList()
{
	local HaloGameDefault Game;

	// End:0x11
	if(WorldInfo == none)
	{
		return;
	}
	Game = HaloGameDefault(WorldInfo.Game);
	// End:0x53
	if(Game == none)
	{
		return;
	}
	Game.DroppedGrenadesList.RemoveItem(self);
	//return;	
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	local HaloPawn Pawn;
	local HaloPlayerInventoryManager invMgr;

	Pawn = HaloPawn(Other);
	// End:0x5C
	if((Pawn == none) || HaloPlayerPawnController(Pawn.Controller) == none)
	{
		return;
	}
	invMgr = HaloPlayerInventoryManager(Pawn.InvManager);
	// End:0x9E
	if(invMgr == none)
	{
		return;
	}
	// End:0x115
	if(bIsPlasmaGrenade)
	{
		// End:0xF0
		if(int(invMgr.PlasmaGrenadeCount) >= invMgr.PlasmaGrenadeCountMax)
		{
			return;
		}
		invMgr.PlasmaGrenadeCount += 1;		
	}
	else
	{
		// End:0x15A
		if(int(invMgr.FragGrenadeCount) >= invMgr.FragGrenadeCountMax)
		{
			return;
		}
		invMgr.FragGrenadeCount += 1;
	}
	// End:0x21F
	if((HaloPlayerPawnController(Pawn.Controller) != none) && HaloPlayerPawnController(Pawn.Controller).IsLocalPlayerController())
	{
		Pawn.SetSwitch('Local_Player', 'Yes');		
	}
	else
	{
		Pawn.SetSwitch('Local_Player', 'No');
	}
	Pawn.SetSwitch('Weapon_Type', ((bIsPlasmaGrenade) ? 'COV_Grenade' : 'UNSC_Grenade'));
	Pawn.PlayAkEvent(PickupGrenadeEvent);
	Destroy();
	//return;	
}

auto state Spinning
{
	event BeginState(name PreviousStateName)
	{
		GetALocalPlayerController().myHUD.RemovePostRenderedActor(self);
		SetTickIsDisabled(false);
		//return;		
	}

	event Tick(float DeltaTime)
	{
		// End:0x22
		if(PlayerCanSeeMe() == false)
		{
			// End:0x22
			if(PlayerCanSeeMe(true) == false)
			{
				GotoState('Dormant');
			}
		}
		//return;		
	}
	stop;	
}

state Dormant
{
	event BeginState(name PreviousStateName)
	{
		GetALocalPlayerController().myHUD.AddPostRenderedActor(self);
		SetTickIsDisabled(true);
		//return;		
	}

	simulated event PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
	{
		GotoState('Spinning');
		//return;		
	}
	stop;	
}

defaultproperties
{
	PickupGrenadeEvent=AkEvent'Weapons.Play_Weapon_Pickup'
	// Reference: StaticMeshComponent'MegaHaloGame.Default__HaloDroppedGrenade.StaticMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'StaticMeshComponent0'
	// Archetype: StaticMeshComponent'Engine.Default__KActorSpawnable.StaticMeshComponent0'
	begin object name="StaticMeshComponent0"
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloDroppedGrenade.MyLightEnvironment'
		RBChannel=ERBCollisionChannel.RBCC_Untitled1
	end object
	StaticMeshComponent=StaticMeshComponent0
	// Reference: DynamicLightEnvironmentComponent'MegaHaloGame.Default__HaloDroppedGrenade.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	// Archetype: DynamicLightEnvironmentComponent'Engine.Default__KActorSpawnable.MyLightEnvironment'
	begin object name="MyLightEnvironment"
	end object
	LightEnvironment=MyLightEnvironment
	GwNavObstacleComponentClassPath=""
	Components[0]=MyLightEnvironment
	Components[1]=StaticMeshComponent0
	CollisionType=ECollisionType.COLLIDE_TouchAll
	bBlockActors=false
	bProjTarget=false
	bBlocksTeleport=false
	CollisionComponent=StaticMeshComponent0
}