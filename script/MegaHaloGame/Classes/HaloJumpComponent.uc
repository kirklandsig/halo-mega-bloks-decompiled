class HaloJumpComponent extends ActorComponent;

enum HaloJumpState
{
	HaloJumpState_Normal,           // 0
	HaloJumpState_Start,            // 1
	HaloJumpState_Upward,           // 2
	HaloJumpState_Apex,             // 3
	HaloJumpState_MAX               // 4
};

struct HaloJumpParams
{
	var float JumpZ;
	var float StartDuration;
	var float StartGravityScale;
	var float UpwardGravityScale;
	var float apexDuration;
	var float ApexGravityScale;

	structdefaultproperties
	{
		JumpZ=0.0000000
		StartDuration=0.0000000
		StartGravityScale=0.0000000
		UpwardGravityScale=0.0000000
		apexDuration=0.0000000
		ApexGravityScale=0.0000000
	}
};

var HaloJumpParams Params[3];
var float DownGravityScale;
var HaloJumpComponent.HaloJumpState CurState;
var float Timer;
var bool bWaitingForApex;
var float StartLocZ;
var float PrevLocZ;

function float GetJumpZ(HaloPawn.HaloJumpType Type)
{
	local int I;

	I = GetParamsIndex(Type);
	return Params[I].JumpZ;
	//return ReturnValue;	
}

function JumpPressed()
{
	GotoJumpState(1);
	//return;	
}

function JumpReleased()
{
	// End:0x28
	if(int(CurState) == int(1))
	{
		ClearTimer();
		StartState_OnTimer();
	}
	//return;	
}

event PhysicsVolumeChange(PhysicsVolume NewVolume)
{
	// End:0x38
	if(int(CurState) != int(0))
	{
		// End:0x38
		if(GravityVolume(NewVolume) != none)
		{
			GotoJumpState(0);
		}
	}
	//return;	
}

function Tick(float DeltaTime)
{
	// End:0x19F
	if(int(CurState) != int(0))
	{
		// End:0x7E
		if((Timer > 0.0000000) && Timer <= Owner.WorldInfo.TimeSeconds)
		{
			ClearTimer();
			OnTimer();
		}
		// End:0x125
		if(bWaitingForApex && Owner != none)
		{
			// End:0xEA
			if(Owner.Location.Z < PrevLocZ)
			{
				bWaitingForApex = false;				
			}
			else
			{
				PrevLocZ = Owner.Location.Z;
			}
		}
		// End:0x16A
		if(Owner.Velocity.Z <= 0.0000000)
		{
			OnApex();
		}
		// End:0x19F
		if(int(Owner.Physics) != int(2))
		{
			GotoJumpState(0);
		}
	}
	//return;	
}

function SetGravityScaling(optional float Scale)
{
	local HaloPawn P;

	P = HaloPawn(Owner);
	// End:0x54
	if(P != none)
	{
		P.CustomGravityScaling = Scale;
	}
	//return;	
}

function int GetParamsIndex(HaloPawn.HaloJumpType Type)
{
	switch(Type)
	{
		// End:0x1A
		case 1:
			return 0;
		// End:0x21
		case 2:
			return 1;
		// End:0x29
		case 3:
			return 2;
		// End:0xFFFF
		default:
			return 0;
			break;
	}
	//return ReturnValue;	
}

function int GetParamsIndexForOwner()
{
	local HaloPawn P;

	P = HaloPawn(Owner);
	// End:0x54
	if(P != none)
	{
		return GetParamsIndex(P.JumpType);
	}
	return 0;
	//return ReturnValue;	
}

function SetTimer(float Duration)
{
	Timer = Owner.WorldInfo.TimeSeconds + Duration;
	//return;	
}

function ClearTimer()
{
	Timer = 0.0000000;
	//return;	
}

function OnTimer()
{
	switch(CurState)
	{
		// End:0x25
		case 1:
			StartState_OnTimer();
			// End:0x3A
			break;
		// End:0x37
		case 3:
			ApexState_OnTimer();
			// End:0x3A
			break;
		// End:0xFFFF
		default:
			break;
	}
	//return;	
}

function OnApex()
{
	switch(CurState)
	{
		// End:0x25
		case 2:
			UpwardState_OnApex();
			// End:0x28
			break;
		// End:0xFFFF
		default:
			break;
	}
	//return;	
}

function GotoJumpState(HaloJumpComponent.HaloJumpState jumpState)
{
	CurState = jumpState;
	switch(CurState)
	{
		// End:0x38
		case 0:
			NormalState_Begin();
			// End:0x80
			break;
		// End:0x4A
		case 1:
			StartState_Begin();
			// End:0x80
			break;
		// End:0x5C
		case 2:
			UpwardState_Begin();
			// End:0x80
			break;
		// End:0x6E
		case 3:
			ApexState_Begin();
			// End:0x80
			break;
		// End:0xFFFF
		default:
			GotoJumpState(0);
			// End:0x80
			break;
			break;
	}
	//return;	
}

event NormalState_Begin()
{
	local HaloPawn P;

	P = HaloPawn(Owner);
	// End:0x86
	if(P != none)
	{
		P.CustomGravityScaling = ((DownGravityScale > 0.0000000) ? DownGravityScale : P.default.CustomGravityScaling);
	}
	//return;	
}

event StartState_Begin()
{
	local int I;

	// End:0x7A
	if(!bWaitingForApex && Owner != none)
	{
		StartLocZ = Owner.Location.Z;
		PrevLocZ = StartLocZ;
		bWaitingForApex = true;
	}
	I = GetParamsIndexForOwner();
	// End:0x121
	if(Params[I].StartDuration > 0.0000000)
	{
		SetGravityScaling(Params[I].StartGravityScale);
		SetTimer(Params[I].StartDuration);		
	}
	else
	{
		StartState_OnTimer();
	}
	//return;	
}

function StartState_OnTimer()
{
	GotoJumpState(2);
	//return;	
}

event UpwardState_Begin()
{
	local int I;

	// End:0x1C
	if(!bWaitingForApex)
	{
		UpwardState_OnApex();		
	}
	else
	{
		I = GetParamsIndexForOwner();
		SetGravityScaling(Params[I].UpwardGravityScale);
	}
	//return;	
}

function UpwardState_OnApex()
{
	GotoJumpState(3);
	//return;	
}

event ApexState_Begin()
{
	local int I;

	I = GetParamsIndexForOwner();
	// End:0xA7
	if(Params[I].apexDuration > 0.0000000)
	{
		SetGravityScaling(Params[I].ApexGravityScale);
		SetTimer(Params[I].apexDuration);		
	}
	else
	{
		ApexState_OnTimer();
	}
	//return;	
}

function ApexState_OnTimer()
{
	GotoJumpState(0);
	//return;	
}

function LogJumpStats(HaloPawn P, int I)
{
	local float gravBase, gravStart, gravUp, gravDown, MaxTime, DeltaTime,
		MinHeight, MaxHeight;

	P.SetPhysics(2);
	gravDown = -2.0000000 * P.GetGravityZ();
	gravBase = gravDown / P.CustomGravityScaling;
	gravStart = Params[I].StartGravityScale * gravBase;
	gravUp = Params[I].UpwardGravityScale * gravBase;
	MinHeight = (Params[I].JumpZ * Params[I].JumpZ) / (2.0000000 * gravUp);
	DeltaTime = (Params[I].JumpZ - (gravStart * Params[I].StartDuration)) / gravUp;
	MaxHeight = (Params[I].StartDuration * (Params[I].JumpZ - ((0.5000000 * Params[I].StartDuration) * gravStart))) + (((0.5000000 * DeltaTime) * DeltaTime) * gravUp);
	MaxTime = Params[I].StartDuration + DeltaTime;
	LogInternal(("=== Jump " $ string(I)) $ " stats ===");
	LogInternal("JumpZ = " $ string(Params[I].JumpZ));
	LogInternal("JumpStartGravityScale = " $ string(Params[I].StartGravityScale));
	LogInternal("JumpUpGravityScale = " $ string(Params[I].UpwardGravityScale));
	LogInternal("==================");
	LogInternal("gravStart = " $ string(gravStart));
	LogInternal("gravUp = " $ string(gravUp));
	LogInternal("gravDown = " $ string(gravDown));
	LogInternal("==================");
	LogInternal("min height = " $ string(MinHeight));
	LogInternal("max height = " $ string(MaxHeight));
	LogInternal("max height time = " $ string(MaxTime));
	LogInternal("==================");
	//return;	
}

exec function LogFallTimes(HaloPawn P)
{
	local float grav, H;
	local int I;
	local float T;

	I = 0;
	J0x0B:

	// End:0xC3 [Loop If]
	if(I <= 2)
	{
		H = GetMaxJumpHeight(P, I, grav);
		T = Sqrt((2.0000000 * H) / grav);
		LogInternal(((("Fall time for jump " $ string(I)) $ " is ") $ string(T)) $ " secs.");
		++I;
		// [Loop Continue]
		goto J0x0B;
	}
	//return;	
}

function LogJumpParams()
{
	local int I;

	LogInternal("");
	I = 0;
	J0x10:

	// End:0x1FA [Loop If]
	if(I < 3)
	{
		LogInternal(("Params(" $ string(I)) $ ") = {(");
		LogInternal(("    JumpZ=" $ string(Params[I].JumpZ)) $ ",");
		LogInternal(("    StartDuration=" $ string(Params[I].StartDuration)) $ ",");
		LogInternal(("    StartGravityScale=" $ string(Params[I].StartGravityScale)) $ ",");
		LogInternal(("    UpwardGravityScale=" $ string(Params[I].UpwardGravityScale)) $ ",");
		LogInternal(("    ApexDuration=" $ string(Params[I].apexDuration)) $ ",");
		LogInternal("    ApexGravityScale=" $ string(Params[I].ApexGravityScale));
		LogInternal(")}");
		++I;
		// [Loop Continue]
		goto J0x10;
	}
	LogInternal("");
	LogInternal("DownGravityScale=" $ string(DownGravityScale));
	LogInternal("");
	//return;	
}

function SetupJumpStart(HaloPawn P, int I, float JumpImpulse, float gravStartScale, float gravUpScale, float buttonTime)
{
	Params[I].JumpZ = JumpImpulse;
	Params[I].StartGravityScale = gravStartScale;
	Params[I].UpwardGravityScale = gravUpScale;
	Params[I].StartDuration = buttonTime;
	LogJumpStats(P, I);
	//return;	
}

function SetupJumpStartByMetrics(HaloPawn P, int I, optional float MinHeight = 366.0000000, optional float MaxHeight = 480.0000000, optional float MaxTime = 0.5000000, optional float holdTime = 0.2000000)
{
	local float DeltaTime, A, B, C, Q, gravBase,
		gravStart, gravUp;

	// End:0xCA
	if(holdTime <= 0.0000000)
	{
		Params[I].JumpZ = (2.0000000 * MaxHeight) / MaxTime;
		gravUp = Params[I].JumpZ / MaxTime;
		gravStart = gravUp;		
	}
	else
	{
		DeltaTime = MaxTime - holdTime;
		A = (MaxTime * DeltaTime) / (4.0000000 * MinHeight);
		B = 0.5000000 * holdTime;
		C = -MaxHeight;
		Q = (B * B) - ((4.0000000 * A) * C);
		// End:0x1CD
		if(Q < 0.0000000)
		{
			LogInternal("Imaginary number generated in SetupJumpByMetrics!");
			return;
		}
		Params[I].JumpZ = (Sqrt(Q) - B) / (2.0000000 * A);
		gravUp = (Params[I].JumpZ * Params[I].JumpZ) / (2.0000000 * MinHeight);
		gravStart = (Params[I].JumpZ - (gravUp * DeltaTime)) / holdTime;
	}
	P.CustomGravityScaling = 1.0000000;
	gravBase = -0.5000000 / P.GetGravityZ();
	Params[I].StartGravityScale = gravStart * gravBase;
	Params[I].UpwardGravityScale = gravUp * gravBase;
	Params[I].StartDuration = holdTime;
	//return;	
}

function float GetMaxJumpHeight(HaloPawn P, int I, optional out float gravDown)
{
	local float gravBase, gravStart, gravUp, DeltaTime, MaxHeight;

	P.SetPhysics(2);
	gravDown = -2.0000000 * P.GetGravityZ();
	gravBase = gravDown / P.CustomGravityScaling;
	gravStart = Params[I].StartGravityScale * gravBase;
	gravUp = Params[I].UpwardGravityScale * gravBase;
	DeltaTime = (Params[I].JumpZ - (gravStart * Params[I].StartDuration)) / gravUp;
	MaxHeight = (Params[I].StartDuration * (Params[I].JumpZ - ((0.5000000 * Params[I].StartDuration) * gravStart))) + (((0.5000000 * DeltaTime) * DeltaTime) * gravUp);
	// End:0x24B
	if(I == 1)
	{
		MaxHeight += (GetMaxJumpHeight(P, 0));
	}
	return MaxHeight;
	//return ReturnValue;	
}

function SetupJumpApex(HaloPawn P, int I, float apexDuration, float apexGravScale)
{
	Params[I].apexDuration = apexDuration;
	Params[I].ApexGravityScale = apexGravScale;
	//return;	
}

function SetupJumpFallByMetrics(HaloPawn P, int I, float fallTime)
{
	local float MaxHeight, gravApex, gravDown, DeltaTime;

	MaxHeight = GetMaxJumpHeight(P, I);
	P.CustomGravityScaling = Params[I].ApexGravityScale;
	gravApex = -2.0000000 * P.GetGravityZ();
	DeltaTime = fallTime - Params[I].apexDuration;
	gravDown = ((2.0000000 * MaxHeight) - ((gravApex * Params[I].apexDuration) * Params[I].apexDuration)) / (DeltaTime * DeltaTime);
	P.CustomGravityScaling = 1.0000000;
	DownGravityScale = gravDown / (-2.0000000 * P.GetGravityZ());
	P.CustomGravityScaling = DownGravityScale;
	//return;	
}

defaultproperties
{
	Params[0]=(JumpZ=1700.0000000,StartDuration=0.0000000,StartGravityScale=5.4000001,UpwardGravityScale=5.4000001,apexDuration=0.0000000,ApexGravityScale=0.0100000)
	Params[1]=(JumpZ=850.0000000,StartDuration=0.0000000,StartGravityScale=2.2000000,UpwardGravityScale=2.2000000,apexDuration=0.0000000,ApexGravityScale=0.0100000)
	Params[2]=(JumpZ=2000.0000000,StartDuration=0.0000000,StartGravityScale=6.4000001,UpwardGravityScale=6.4000001,apexDuration=0.0000000,ApexGravityScale=0.0100000)
}