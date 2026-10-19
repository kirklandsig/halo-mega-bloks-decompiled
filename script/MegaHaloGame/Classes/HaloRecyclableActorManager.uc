class HaloRecyclableActorManager extends Actor
	config(Recyclables)
	notplaceable;

struct Recyclable
{
	var bool bAvailable;
	var Actor Actor;

	structdefaultproperties
	{
		bAvailable=true
		Actor=none
	}
};

struct RecyclablePool
{
	var int MaxSize;
	var Class<Actor> Type;
	var array<Recyclable> Recyclables;

	structdefaultproperties
	{
		MaxSize=0
		Type=none
		Recyclables=none
	}
};

struct ActorComponentInstance
{
	var int RefCount;
	var export editinline ActorComponent ActorComponent;

	structdefaultproperties
	{
		RefCount=0
		ActorComponent=none
	}
};

var config array<config RecyclablePool> Pools;
var bool bFillingPools;
var array<ActorComponentInstance> InstancedComponents;

function Actor RequestActor(Class<Actor> ActorType, Object Requester)
{
	local int I;

	I = Pools.Find('Type', ActorType);
	// End:0x53
	if(I != -1)
	{
		return RequestActorFromPool(I);		
	}
	else
	{
		WarnInternal((string(self) $ ": No pool exists for ") $ string(ActorType));
	}
	return none;
	//return ReturnValue;	
}

function bool ReleaseActor(Actor DeadActor)
{
	local int I;

	I = Pools.Find('Type', DeadActor.Class);
	// End:0x71
	if(I != -1)
	{
		return ReclaimActor(I, DeadActor);		
	}
	else
	{
		WarnInternal((string(self) $ ": No pool exists for ") $ string(DeadActor.Class));
	}
	return false;
	//return ReturnValue;	
}

function bool RemoveActor(Actor DestroyedActor)
{
	local int I;

	WarnInternal(((((string(self) $ ": ") $ string(DestroyedActor)) $ " is being removed from the ") $ string(DestroyedActor.Class)) $ " pool");
	I = Pools.Find('Type', DestroyedActor.Class);
	// End:0xD3
	if(I != -1)
	{
		return RemoveActorFromPool(I, DestroyedActor);		
	}
	else
	{
		WarnInternal((string(self) $ ": No pool exists for ") $ string(DestroyedActor.Class));
	}
	return false;
	//return ReturnValue;	
}

function ActorComponent RequestComponent(Class<ActorComponent> Type, Actor CompOwner)
{
	local ActorComponentInstance NewInstance;
	local editinline ActorComponent NewComponent;

	NewComponent = new (self) Type;
	NewInstance.RefCount = 1;
	NewInstance.ActorComponent = NewComponent;
	InstancedComponents.AddItem(NewInstance);
	// End:0xAC
	if(Owner != none)
	{
		CompOwner.AttachComponent(NewComponent);		
	}
	else
	{
		AttachComponent(NewComponent);
	}
	return NewComponent;
	//return ReturnValue;	
}

function bool AddComponentRef(ActorComponent InstancedComponent, Actor RefOwner)
{
	local int I;

	// End:0x158
	if(RefOwner != none)
	{
		// End:0xF8
		if(InstancedComponent != none)
		{
			I = InstancedComponents.Find('ActorComponent', InstancedComponent);
			// End:0x87
			if(I != -1)
			{
				InstancedComponents[I].RefCount++;
				return true;				
			}
			else
			{
				WarnInternal(((((string(self) $ ": ") $ string(RefOwner)) $ " tried to add a ref of non-instanced component ") $ string(InstancedComponent)) $ ", no ref was added");
			}			
		}
		else
		{
			WarnInternal(((string(self) $ ": ") $ string(RefOwner)) $ " tried to add a ref of unknown component (NONE), no ref was added");
		}		
	}
	else
	{
		WarnInternal(string(self) $ ": Unknown Actor (NONE) tried to add a component ref, no ref was added");
	}
	return false;
	//return ReturnValue;	
}

function bool IsComponentInstanced(ActorComponent InstancedComponent)
{
	local int I;

	// End:0x4D
	if(InstancedComponent != none)
	{
		I = InstancedComponents.Find('ActorComponent', InstancedComponent);
		// End:0x4D
		if(I != -1)
		{
			return true;
		}
	}
	return false;
	//return ReturnValue;	
}

function bool ReleaseComponent(ActorComponent InstancedComponent, Actor RefOwner)
{
	local int I;

	// End:0x21E
	if(RefOwner != none)
	{
		// End:0x1B8
		if(InstancedComponent != none)
		{
			I = InstancedComponents.Find('ActorComponent', InstancedComponent);
			// End:0x141
			if(I != -1)
			{
				InstancedComponents[I].RefCount--;
				// End:0xFD
				if(InstancedComponents[I].RefCount == 0)
				{
					InstancedComponents.Remove(I, 1);
					// End:0xFA
					if(InstancedComponent.Owner == self)
					{
						DetachComponent(InstancedComponent);
					}					
				}
				else
				{
					// End:0x13C
					if(InstancedComponent.Owner == RefOwner)
					{
						AttachComponent(InstancedComponent);
					}
				}
				return true;				
			}
			else
			{
				WarnInternal(((((string(self) $ ": ") $ string(RefOwner)) $ " tried to release a ref of non-instanced component ") $ string(InstancedComponent)) $ ", no ref was removed");
			}			
		}
		else
		{
			WarnInternal(((string(self) $ ": ") $ string(RefOwner)) $ " tried to release a ref of unknown component (NONE), no ref was removed");
		}		
	}
	else
	{
		WarnInternal(string(self) $ ": Unknown Actor (NONE) tried to release a component ref, no ref was removed");
	}
	return false;
	//return ReturnValue;	
}

private final function FillPools()
{
	local int I;
	local bool bStillFilling;

	bStillFilling = false;
	I = 0;
	J0x17:

	// End:0x62 [Loop If]
	if(I < Pools.Length)
	{
		// End:0x54
		if(FillPool(I) == false)
		{
			bStillFilling = true;
		}
		I++;
		// [Loop Continue]
		goto J0x17;
	}
	bFillingPools = bStillFilling;
	//return;	
}

private final function bool FillPool(int Idx)
{
	local bool bIsFull;
	local Recyclable NewRecyclable;

	bIsFull = false;
	// End:0x197
	if(Pools[Idx].Recyclables.Length < Pools[Idx].MaxSize)
	{
		NewRecyclable.Actor = SpawnActor(Pools[Idx].Type);
		// End:0x194
		if(NewRecyclable.Actor != none)
		{
			NewRecyclable.Actor.GotoState('Inactive');
			Pools[Idx].Recyclables.AddItem(NewRecyclable);
			// End:0x194
			if(Pools[Idx].Recyclables.Length == Pools[Idx].MaxSize)
			{
				bIsFull = true;
			}
		}		
	}
	else
	{
		bIsFull = true;
	}
	return bIsFull;
	//return ReturnValue;	
}

private final function Actor SpawnActor(Class<Actor> ActorType)
{
	return Spawn(ActorType, self,,,,, true);
	//return ReturnValue;	
}

private final function Actor RequestActorFromPool(int Idx)
{
	local int I;

	I = Pools[Idx].Recyclables.Find('bAvailable', true);
	// End:0xDB
	if(I != -1)
	{
		Pools[Idx].Recyclables[I].bAvailable = false;
		return Pools[Idx].Recyclables[I].Actor;
	}
	return OverfillPool(Idx);
	//return ReturnValue;	
}

private final function Actor OverfillPool(int Idx)
{
	local Recyclable NewRecyclable;

	WarnInternal((((string(self) $ ": No Available Actors of type ") $ string(Pools[Idx].Type)) $ ". Allocating New Actor; Current Pool Size: ") $ ((string(Pools[Idx].Recyclables.Length) $ " Max Pool Size: ") $ string(Pools[Idx].MaxSize)));
	NewRecyclable.Actor = SpawnActor(Pools[Idx].Type);
	// End:0x18E
	if(NewRecyclable.Actor != none)
	{
		Pools[Idx].Recyclables.AddItem(NewRecyclable);		
	}
	else
	{
		WarnInternal((string(self) $ ": Failed To Allocate New Actor Of Type ") $ string(Pools[Idx].Type));
	}
	return NewRecyclable.Actor;
	//return ReturnValue;	
}

private final function bool ReclaimActor(int Idx, Actor DeadActor)
{
	local int I;

	I = Pools[Idx].Recyclables.Find('Actor', DeadActor);
	// End:0x101
	if(I != -1)
	{
		Pools[Idx].Recyclables[I].Actor.GotoState('Inactive');
		Pools[Idx].Recyclables[I].bAvailable = true;
		return true;		
	}
	else
	{
		WarnInternal(((string(self) $ ": ") $ string(DeadActor)) $ " is not a pooled Actor");
	}
	return false;
	//return ReturnValue;	
}

private final function bool RemoveActorFromPool(int Idx, Actor DestroyedActor)
{
	local int I;

	I = Pools[Idx].Recyclables.Find('Actor', DestroyedActor);
	// End:0x90
	if(I != -1)
	{
		Pools[Idx].Recyclables.Remove(I, 1);
		return true;		
	}
	else
	{
		WarnInternal(((string(self) $ ": ") $ string(DestroyedActor)) $ " is not a pooled Actor");
	}
	return false;
	//return ReturnValue;	
}

private final function CleanupUnreferencedComponents()
{
	local int I;

	I = 0;
	J0x0B:

	// End:0xB7 [Loop If]
	if(I < InstancedComponents.Length)
	{
		// End:0xA9
		if((InstancedComponents[I].ActorComponent == none) || InstancedComponents[I].ActorComponent.Owner == none)
		{
			InstancedComponents.Remove(I--, 1);
		}
		I++;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

auto state FillingPools
{
	event Tick(float DeltaTime)
	{
		// End:0x1A
		if(bFillingPools)
		{
			FillPools();			
		}
		else
		{
			Owner.SetTimer(10.0000000, true, 'CleanupUnreferencedComponents', self);
			SetTickIsDisabled(true);
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	Pools[0]=(MaxSize=10,Type=Class'MegaHaloGame.HaloCollectibleBlok_1Peg_Low_Bronze',Recyclables=none)
	Pools[1]=(MaxSize=20,Type=Class'MegaHaloGame.HaloCollectibleBlok_1Peg_Std_Bronze',Recyclables=none)
	Pools[2]=(MaxSize=20,Type=Class'MegaHaloGame.HaloCollectibleBlok_1Peg_Std_Silver',Recyclables=none)
	Pools[3]=(MaxSize=20,Type=Class'MegaHaloGame.HaloCollectibleBlok_1Peg_Std_Gold',Recyclables=none)
	Pools[4]=(MaxSize=10,Type=Class'MegaHaloGame.HaloCollectibleBlok_2Peg_Low_Silver',Recyclables=none)
	Pools[5]=(MaxSize=10,Type=Class'MegaHaloGame.HaloCollectibleBlok_2Peg_Weg_Gold',Recyclables=none)
	Pools[6]=(MaxSize=200,Type=Class'MegaHaloGame.HaloDestructibleBlok',Recyclables=none)
	Pools[7]=(MaxSize=20,Type=Class'MegaHaloGame.HaloBlueprintBlok',Recyclables=none)
	Pools[8]=(MaxSize=75,Type=Class'MegaHaloGame.HaloProjectile_AssaultRifleBullet',Recyclables=none)
	Pools[9]=(MaxSize=50,Type=Class'MegaHaloGame.HaloProjectile_BattleRifleBullet',Recyclables=none)
	Pools[10]=(MaxSize=12,Type=Class'MegaHaloGame.HaloProjectile_CarbineBullet',Recyclables=none)
	Pools[11]=(MaxSize=4,Type=Class'MegaHaloGame.HaloProjectile_FuelRodCannonBall',Recyclables=none)
	Pools[12]=(MaxSize=200,Type=Class'MegaHaloGame.HaloProjectile_NeedlerNeedle',Recyclables=none)
	Pools[13]=(MaxSize=50,Type=Class'MegaHaloGame.HaloProjectile_PistolBullet',Recyclables=none)
	Pools[14]=(MaxSize=4,Type=Class'MegaHaloGame.HaloProjectile_ChargedPistolBullet',Recyclables=none)
	Pools[15]=(MaxSize=200,Type=Class'MegaHaloGame.HaloProjectile_ShotgunPellet',Recyclables=none)
	Pools[16]=(MaxSize=75,Type=Class'MegaHaloGame.HaloProjectile_StormRifleBullet',Recyclables=none)
	Pools[17]=(MaxSize=40,Type=Class'MegaHaloGame.HaloProjectile_UnscPistolBullet',Recyclables=none)
	Pools[18]=(MaxSize=9,Type=Class'MegaHaloGame.HaloProjectile_UnscRocket_Content',Recyclables=none)
	Pools[19]=(MaxSize=4,Type=Class'MegaHaloGame.HaloProjectile_Grenade',Recyclables=none)
	bFillingPools=true
	CollisionType=COLLIDE_CustomDefault
}