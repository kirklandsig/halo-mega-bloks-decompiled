class NavMeshObstacle extends Actor
	native
	placeable
	implements(Interface_NavMeshPathObstacle);

struct CheckpointRecord
{
	var bool bEnabled;

	structdefaultproperties
	{
		bEnabled=false
	}
};

var private native const noexport Pointer VfTable_IInterface_NavMeshPathObstacle;
var bool bEnabled;
var bool bPreserveInternalGeo;

event bool GetObstacleBoudingShape(out array<Vector> Shape)
{
	local float Scale;
	local Vector Offset;

	Scale = 200.0000000 * DrawScale;
	Offset.X = Scale * DrawScale3D.X;
	Offset.Y = Scale * DrawScale3D.Y;
	Shape.AddItem(Location + (Offset >> Rotation));
	Offset.X = Scale- * DrawScale3D.X;
	Offset.Y = Scale * DrawScale3D.Y;
	Shape.AddItem(Location + (Offset >> Rotation));
	Offset.X = Scale- * DrawScale3D.X;
	Offset.Y = Scale- * DrawScale3D.Y;
	Shape.AddItem(Location + (Offset >> Rotation));
	Offset.X = Scale * DrawScale3D.X;
	Offset.Y = Scale- * DrawScale3D.Y;
	Shape.AddItem(Location + (Offset >> Rotation));
	return true;
	//return ReturnValue;	
}

// Export UNavMeshObstacle::execRegisterObstacle(FFrame&, void* const)
native function RegisterObstacle();

// Export UNavMeshObstacle::execUnRegisterObstacle(FFrame&, void* const)
native function UnRegisterObstacle();

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	// End:0x21
	if(bEnabled)
	{
		RegisterObstacle();
	}
	//return;	
}

simulated function OnToggle(SeqAct_Toggle Action)
{
	// End:0x46
	if(Action.InputLinks[0].bHasImpulse)
	{
		bEnabled = true;		
	}
	else
	{
		// End:0x8C
		if(Action.InputLinks[1].bHasImpulse)
		{
			bEnabled = false;			
		}
		else
		{
			// End:0xDB
			if(Action.InputLinks[2].bHasImpulse)
			{
				bEnabled = bEnabled!;
			}
		}
	}
	SetEnabled(bEnabled);
	//return;	
}

function SetEnabled(bool bInEnabled)
{
	// End:0x1A
	if(bInEnabled)
	{
		RegisterObstacle();		
	}
	else
	{
		UnRegisterObstacle();
	}
	//return;	
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
	Record.bEnabled = bEnabled;
	//return;	
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
	SetEnabled(Record.bEnabled);
	//return;	
}

defaultproperties
{
	Components[0]=none
	// Reference: DrawBoxComponent'Engine.Default__NavMeshObstacle.DrawBox0'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'DrawBox0'
	begin object name="DrawBox0" class=Engine.DrawBoxComponent
		BoxColor=(R=70,G=64,B=255,A=255)
		ReplacementPrimitive=none
	end object
	Components[1]=DrawBox0
	CollisionType=ECollisionType.COLLIDE_CustomDefault
}