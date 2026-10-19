class Mutator extends Info
	abstract
	native
	notplaceable;

var Mutator NextMutator;
var array<string> GroupNames;
var bool bUserAdded;

event PreBeginPlay()
{
	// End:0x12
	if(!MutatorIsAllowed())
	{
		Destroy();
	}
	//return;	
}

function bool MutatorIsAllowed()
{
	return !WorldInfo.IsDemoBuild();
	//return ReturnValue;	
}

event Destroyed()
{
	WorldInfo.Game.RemoveMutator(self);
	super(Actor).Destroyed();
	//return;	
}

function Mutate(string MutateString, PlayerController Sender)
{
	// End:0x40
	if(NextMutator != none)
	{
		NextMutator.Mutate(MutateString, Sender);
	}
	//return;	
}

function ModifyLogin(out string Portal, out string Options)
{
	// End:0x40
	if(NextMutator != none)
	{
		NextMutator.ModifyLogin(Portal, Options);
	}
	//return;	
}

function ModifyPlayer(Pawn Other)
{
	// End:0x37
	if(NextMutator != none)
	{
		NextMutator.ModifyPlayer(Other);
	}
	//return;	
}

function AddMutator(Mutator M)
{
	// End:0x25
	if(NextMutator == none)
	{
		NextMutator = M;		
	}
	else
	{
		NextMutator.AddMutator(M);
	}
	//return;	
}

function bool AlwaysKeep(Actor Other)
{
	// End:0x38
	if(NextMutator != none)
	{
		return NextMutator.AlwaysKeep(Other);
	}
	return false;
	//return ReturnValue;	
}

function bool IsRelevant(Actor Other)
{
	local bool bResult;

	bResult = CheckReplacement(Other);
	// End:0x6F
	if(bResult && NextMutator != none)
	{
		bResult = NextMutator.IsRelevant(Other);
	}
	return bResult;
	//return ReturnValue;	
}

function bool CheckRelevance(Actor Other)
{
	local bool bResult;

	// End:0x18
	if(AlwaysKeep(Other))
	{
		return true;
	}
	bResult = IsRelevant(Other);
	return bResult;
	//return ReturnValue;	
}

function bool CheckReplacement(Actor Other)
{
	return true;
	//return ReturnValue;	
}

function NotifyLogout(Controller Exiting)
{
	// End:0x37
	if(NextMutator != none)
	{
		NextMutator.NotifyLogout(Exiting);
	}
	//return;	
}

function NotifyLogin(Controller NewPlayer)
{
	// End:0x37
	if(NextMutator != none)
	{
		NextMutator.NotifyLogin(NewPlayer);
	}
	//return;	
}

function DriverEnteredVehicle(Vehicle V, Pawn P)
{
	// End:0x40
	if(NextMutator != none)
	{
		NextMutator.DriverEnteredVehicle(V, P);
	}
	//return;	
}

function bool CanLeaveVehicle(Vehicle V, Pawn P)
{
	// End:0x41
	if(NextMutator != none)
	{
		return NextMutator.CanLeaveVehicle(V, P);
	}
	return true;
	//return ReturnValue;	
}

function DriverLeftVehicle(Vehicle V, Pawn P)
{
	// End:0x40
	if(NextMutator != none)
	{
		NextMutator.DriverLeftVehicle(V, P);
	}
	//return;	
}

function InitMutator(string Options, out string ErrorMessage)
{
	// End:0x40
	if(NextMutator != none)
	{
		NextMutator.InitMutator(Options, ErrorMessage);
	}
	//return;	
}

function GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
	// End:0x23
	if(bToEntry)
	{
		ActorList[ActorList.Length] = self;
	}
	// End:0x64
	if(NextMutator != none)
	{
		NextMutator.GetSeamlessTravelActorList(bToEntry, ActorList);
	}
	//return;	
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string IncomingName, optional bool IsNewPlayer)
{
	// End:0x5A
	if(NextMutator != none)
	{
		return NextMutator.FindPlayerStart(Player, InTeam, IncomingName, IsNewPlayer);		
	}
	else
	{
		return none;
	}
	//return ReturnValue;	
}

function bool HandleRestartGame()
{
	return (NextMutator != none) && NextMutator.HandleRestartGame();
	//return ReturnValue;	
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
	return (NextMutator == none) || NextMutator.CheckEndGame(Winner, Reason);
	//return ReturnValue;	
}

function bool OverridePickupQuery(Pawn Other, Class<Inventory> ItemClass, Actor Pickup, out byte bAllowPickup)
{
	return (NextMutator != none) && NextMutator.OverridePickupQuery(Other, ItemClass, Pickup, bAllowPickup);
	//return ReturnValue;	
}

function bool PreventDeath(Pawn Killed, Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
	return (NextMutator != none) && NextMutator.PreventDeath(Killed, Killer, DamageType, HitLocation);
	//return ReturnValue;	
}

function ScoreObjective(PlayerReplicationInfo Scorer, int Score)
{
	// End:0x40
	if(NextMutator != none)
	{
		NextMutator.ScoreObjective(Scorer, Score);
	}
	//return;	
}

function ScoreKill(Controller Killer, Controller Killed)
{
	// End:0x40
	if(NextMutator != none)
	{
		NextMutator.ScoreKill(Killer, Killed);
	}
	//return;	
}

function NetDamage(int OriginalDamage, out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, Class<DamageType> DamageType, Actor DamageCauser)
{
	// End:0x76
	if(NextMutator != none)
	{
		NextMutator.NetDamage(OriginalDamage, Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
	}
	//return;	
}
