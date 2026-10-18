class DynamicSMActor extends Actor
	abstract
	native
	notplaceable;

var const editconst export editinline StaticMeshComponent StaticMeshComponent;
var const editconst export editinline DynamicLightEnvironmentComponent LightEnvironment;
var repnotify transient StaticMesh ReplicatedMesh;
var repnotify MaterialInterface ReplicatedMaterial0;
var repnotify MaterialInterface ReplicatedMaterial1;
var repnotify bool bForceStaticDecals;
var bool bPawnCanBaseOn;
var bool bSafeBaseIfAsleep;
var repnotify Vector ReplicatedMeshTranslation;
var repnotify Rotator ReplicatedMeshRotation;
var repnotify Vector ReplicatedMeshScale3D;
var string GwNavObstacleComponentClassPath;

replication
{
	// Pos:0x000
	if(bNetDirty)
		ReplicatedMaterial0, ReplicatedMaterial1, 
		ReplicatedMesh, ReplicatedMeshRotation, 
		ReplicatedMeshScale3D, ReplicatedMeshTranslation, 
		bForceStaticDecals;
}

event PostBeginPlay()
{
	local Class<ActorComponent> GwNavObstacleComponentClass;
	local editinline ActorComponent GwNavObstacleComponent;

	super.PostBeginPlay();
	// End:0x6B
	if(StaticMeshComponent != none)
	{
		ReplicatedMesh = StaticMeshComponent.StaticMesh;
		bForceStaticDecals = StaticMeshComponent.bForceStaticDecals;
	}
	// End:0xE5
	if(GwNavObstacleComponentClassPath != "")
	{
		GwNavObstacleComponentClass = Class<ActorComponent>(DynamicLoadObject(GwNavObstacleComponentClassPath, Class'Core.Class'));
		// End:0xE5
		if(GwNavObstacleComponentClass != none)
		{
			GwNavObstacleComponent = new (self) GwNavObstacleComponentClass;
			AttachComponent(GwNavObstacleComponent);
		}
	}
	//return;	
}

simulated event ReplicatedEvent(name VarName)
{
	// End:0xB0
	if(VarName == 'ReplicatedMesh')
	{
		// End:0xAD
		if(ReplicatedMesh != StaticMeshComponent.StaticMesh)
		{
			LightEnvironment.bCastShadows = false;
			LightEnvironment.SetEnabled(true);
			StaticMeshComponent.SetStaticMesh(ReplicatedMesh);
		}		
	}
	else
	{
		// End:0xF3
		if(VarName == 'ReplicatedMaterial0')
		{
			StaticMeshComponent.SetMaterial(0, ReplicatedMaterial0);			
		}
		else
		{
			// End:0x136
			if(VarName == 'ReplicatedMaterial1')
			{
				StaticMeshComponent.SetMaterial(1, ReplicatedMaterial1);				
			}
			else
			{
				// End:0x178
				if(VarName == 'ReplicatedMeshTranslation')
				{
					StaticMeshComponent.SetTranslation(ReplicatedMeshTranslation);					
				}
				else
				{
					// End:0x1BA
					if(VarName == 'ReplicatedMeshRotation')
					{
						StaticMeshComponent.SetRotation(ReplicatedMeshRotation);						
					}
					else
					{
						// End:0x203
						if(VarName == 'ReplicatedMeshScale3D')
						{
							StaticMeshComponent.SetScale3D(ReplicatedMeshScale3D / 100.0000000);							
						}
						else
						{
							// End:0x246
							if(VarName == 'bForceStaticDecals')
							{
								StaticMeshComponent.SetForceStaticDecals(bForceStaticDecals);								
							}
							else
							{
								super.ReplicatedEvent(VarName);
							}
						}
					}
				}
			}
		}
	}
	//return;	
}

function OnSetMesh(SeqAct_SetMesh Action)
{
	local bool bForce;

	// End:0x292
	if(int(Action.MeshType) == int(0))
	{
		bForce = (Action.bIsAllowedToMove == StaticMeshComponent.bForceStaticDecals) || Action.bAllowDecalsToReattach;
		// End:0x292
		if((Action.NewStaticMesh != none) && (Action.NewStaticMesh != StaticMeshComponent.StaticMesh) || bForce)
		{
			LightEnvironment.bCastShadows = false;
			LightEnvironment.SetEnabled(true);
			bForceStaticDecals = Action.bIsAllowedToMove!;
			StaticMeshComponent.SetForceStaticDecals(bForceStaticDecals);
			StaticMeshComponent.bAllowDecalAutomaticReAttach = Action.bAllowDecalsToReattach;
			StaticMeshComponent.SetStaticMesh(Action.NewStaticMesh, Action.bAllowDecalsToReattach);
			StaticMeshComponent.bAllowDecalAutomaticReAttach = true;
			ReplicatedMesh = Action.NewStaticMesh;
			ForceNetRelevant();
		}
	}
	//return;	
}

function OnSetMaterial(SeqAct_SetMaterial Action)
{
	StaticMeshComponent.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
	// End:0xB4
	if(Action.MaterialIndex == 0)
	{
		ReplicatedMaterial0 = Action.NewMaterial;
		ForceNetRelevant();		
	}
	else
	{
		// End:0x10A
		if(Action.MaterialIndex == 1)
		{
			ReplicatedMaterial1 = Action.NewMaterial;
			ForceNetRelevant();
		}
	}
	//return;	
}

function SetStaticMesh(StaticMesh NewMesh, optional Vector NewTranslation, optional Rotator NewRotation, optional Vector NewScale3D)
{
	StaticMeshComponent.SetStaticMesh(NewMesh);
	StaticMeshComponent.SetTranslation(NewTranslation);
	StaticMeshComponent.SetRotation(NewRotation);
	// End:0xCF
	if(IsZero(NewScale3D)!)
	{
		StaticMeshComponent.SetScale3D(NewScale3D);
		ReplicatedMeshScale3D = NewScale3D * 100.0000000;
	}
	ReplicatedMesh = NewMesh;
	ReplicatedMeshTranslation = NewTranslation;
	ReplicatedMeshRotation = NewRotation;
	ForceNetRelevant();
	//return;	
}

simulated function bool CanBasePawn(Pawn P)
{
	// End:0x56
	if(bPawnCanBaseOn || (bSafeBaseIfAsleep && StaticMeshComponent != none) && StaticMeshComponent.RigidBodyIsAwake()!)
	{
		return true;
	}
	return false;
	//return ReturnValue;	
}

event Attach(Actor Other)
{
	local Pawn P;

	super.Attach(Other);
	// End:0x50
	if(bSafeBaseIfAsleep)
	{
		P = Pawn(Other);
		// End:0x50
		if(P != none)
		{
			SetPhysics(0);
		}
	}
	//return;	
}

event Detach(Actor Other)
{
	local int Idx;
	local Pawn P, Test;
	local bool bResetPhysics;

	super.Detach(Other);
	P = Pawn(Other);
	// End:0xEA
	if(P != none)
	{
		bResetPhysics = true;
		Idx = 0;
		J0x55:

		// End:0xD8 [Loop If]
		if(Idx < Attached.Length)
		{
			Test = Pawn(Attached[Idx]);
			// End:0xCA
			if((Test != none) && Test != P)
			{
				bResetPhysics = false;
				// [Explicit Break]
				goto J0xD8;
			}
			Idx++;
			// [Loop Continue]
			goto J0x55;
		}
		J0xD8:

		// End:0xEA
		if(bResetPhysics)
		{
			SetPhysics(10);
		}
	}
	//return;	
}

final simulated function SetLightEnvironmentToNotBeDynamic()
{
	// End:0x30
	if(LightEnvironment != none)
	{
		LightEnvironment.bDynamic = false;
	}
	//return;	
}

defaultproperties
{
	// Reference: StaticMeshComponent'Engine.Default__DynamicSMActor.StaticMeshComponent0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'StaticMeshComponent0'
	begin object name="StaticMeshComponent0" class=Engine.StaticMeshComponent
		ReplacementPrimitive=none
		LightEnvironment=DynamicLightEnvironmentComponent'Engine.Default__DynamicSMActor.MyLightEnvironment'
		BlockRigidBody=false
	end object
	StaticMeshComponent=StaticMeshComponent0
	// Reference: DynamicLightEnvironmentComponent'Engine.Default__DynamicSMActor.MyLightEnvironment'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'MyLightEnvironment'
	begin object name="MyLightEnvironment" class=Engine.DynamicLightEnvironmentComponent
	end object
	LightEnvironment=MyLightEnvironment
	bPawnCanBaseOn=true
	GwNavObstacleComponentClassPath="GwNavEngine.GwNavObstacleComponent"
	Components[0]=MyLightEnvironment
	Components[1]=StaticMeshComponent0
	RemoteRole=ENetRole.ROLE_SimulatedProxy
	bShadowParented=true
	bGameRelevant=true
	bEdShouldSnap=true
	bPathColliding=true
	CollisionComponent=StaticMeshComponent0
}