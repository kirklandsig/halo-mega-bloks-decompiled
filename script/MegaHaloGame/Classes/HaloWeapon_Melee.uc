class HaloWeapon_Melee extends HaloWeapon
	config(Weapon);

var array<HaloMeleeAttackDesc> ComboAttackDescs;
var HaloLeapAttackDesc LeapAttackDesc;
var name LeapChargeUpPawnAnimName;
var float LeapChargeUpDuration;
var bool bAllowComboQueueing;
var bool bComboWindowEnabled;
var bool bComboQueued;
var bool bComboOnNextTick;
var int NextComboAttackIndex;

function OnMeleeDone()
{
	//return;	
}

simulated function EndFire(byte FireMode)
{
	super(UTWeapon).EndFire(FireMode);
	//return;	
}

function AllowComboQueueing()
{
	//return;	
}

function StartComboWindow()
{
	//return;	
}

function EndComboWindow()
{
	//return;	
}

function PlayChargeUpAnim()
{
	local HaloPawn P;

	P = HaloPawn(Owner);
	// End:0x4A
	if(P != none)
	{
		P.PlayChargeUpAnim();
	}
	//return;	
}

function StopChargeUpAnim()
{
	local HaloPawn P;

	P = HaloPawn(Owner);
	// End:0x4A
	if(P != none)
	{
		P.StopChargeUpAnim();
	}
	//return;	
}

function DoLeapAttack()
{
	local HaloPawn P;

	P = HaloPawn(Owner);
	// End:0x54
	if(P != none)
	{
		P.LeapAttack(LeapAttackDesc);
	}
	//return;	
}

function bool DoComboAttack()
{
	local HaloPawn P;

	P = HaloPawn(Owner);
	// End:0x5F
	if(P != none)
	{
		return P.MeleeAttack(ComboAttackDescs[NextComboAttackIndex]);
	}
	//return ReturnValue;	
}

function AddSwipeKey(int comboIdx, float Time, Vector Loc)
{
	local HaloMeleeSwipeKeyFrame Key;

	Key.Time = Time;
	Key.RelativeLoc = Loc;
	ComboAttackDescs[comboIdx].SwipeKeyFrames.AddItem(Key);
	//return;	
}

state Active
{
	simulated event BeginState(name PrevStateName)
	{
		bAllowComboQueueing = false;
		bComboQueued = false;
		bComboWindowEnabled = false;
		NextComboAttackIndex = 0;
		super.BeginState(PrevStateName);
		//return;		
	}
	stop;	
}

state ChargeUp
{
	simulated event BeginState(name PrevStateName)
	{
		bAllowComboQueueing = false;
		bComboQueued = false;
		bComboWindowEnabled = false;
		NextComboAttackIndex = 0;
		PlayChargeUpAnim();
		SetTimer(LeapChargeUpDuration);
		//return;		
	}

	function Timer()
	{
		GotoState('LeapAttackReady');
		//return;		
	}

	simulated function EndFire(byte FireMode)
	{
		super(HaloWeapon_Melee).EndFire(FireMode);
		StopChargeUpAnim();
		GotoState('ComboAttack');
		//return;		
	}
	stop;	
}

state LeapAttackReady
{
	simulated event EndState(name NextStateName)
	{
		StopChargeUpAnim();
		//return;		
	}

	simulated function EndFire(byte FireMode)
	{
		super(HaloWeapon_Melee).EndFire(FireMode);
		DoLeapAttack();
		GotoState('WaitForLeapAttackDone');
		//return;		
	}
	stop;	
}

state WaitForLeapAttackDone
{
	function OnMeleeDone()
	{
		GotoState('Active');
		//return;		
	}
	stop;	
}

state ComboAttack
{
	simulated event BeginState(name PrevStateName)
	{
		bAllowComboQueueing = false;
		bComboWindowEnabled = false;
		bComboQueued = false;
		bComboOnNextTick = false;
		// End:0x4D
		if(!DoComboAttack())
		{
			GotoState('Active');
		}
		// End:0x7F
		if(ComboAttackDescs.Length > 0)
		{
			NextComboAttackIndex = (NextComboAttackIndex + 1) % ComboAttackDescs.Length;
		}
		//return;		
	}

	simulated function EndFire(byte FireMode)
	{
		super(HaloWeapon_Melee).EndFire(FireMode);
		// End:0x31
		if(bComboWindowEnabled)
		{
			GotoState('ComboAttack',, true);			
		}
		else
		{
			// End:0x5F
			if(bAllowComboQueueing)
			{
				bComboQueued = true;
				bComboOnNextTick = bComboWindowEnabled;
			}
		}
		//return;		
	}

	function OnMeleeDone()
	{
		// End:0x1F
		if(PendingFire(0))
		{
			GotoState('ChargeUp');			
		}
		else
		{
			// End:0x3D
			if(bComboQueued)
			{
				GotoState('ComboAttack',, true);				
			}
			else
			{
				GotoState('Active');
			}
		}
		//return;		
	}

	function AllowComboQueueing()
	{
		bAllowComboQueueing = true;
		//return;		
	}

	function StartComboWindow()
	{
		bComboWindowEnabled = true;
		bComboOnNextTick = bComboQueued;
		//return;		
	}

	function EndComboWindow()
	{
		bComboWindowEnabled = false;
		bAllowComboQueueing = false;
		//return;		
	}

	simulated function Tick(float DeltaTime)
	{
		super(HaloWeapon).Tick(DeltaTime);
		// End:0x2E
		if(bComboOnNextTick)
		{
			GotoState('ComboAttack',, true);
		}
		//return;		
	}
	stop;	
}

defaultproperties
{
	LeapChargeUpDuration=1.0000000
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon_Melee.ForceFeedbackWaveformShooting1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloWeapon.ForceFeedbackWaveformShooting1'
	begin object name="ForceFeedbackWaveformShooting1"
	end object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1
	FiringStatesArray[0]="ChargeUp"
	FiringStatesArray[1]="WeaponFiring"
	WeaponFireTypes[0]=0
	WeaponFireTypes[1]=0
	// Reference: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_Melee.FirstPersonMesh'
	// Archetype: UDKSkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon.FirstPersonMesh'
	begin object name="FirstPersonMesh"
		ReplacementPrimitive=none
	end object
	Mesh=FirstPersonMesh
	// Reference: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon_Melee.PickupMesh'
	// TemplateOwnerClass: none
	// TemplateOwnerName: 'PickupMesh'
	// Archetype: SkeletalMeshComponent'MegaHaloGame.Default__HaloWeapon.PickupMesh'
	begin object name="PickupMesh"
		ReplacementPrimitive=none
	end object
	DroppedPickupMesh=PickupMesh
	PickupFactoryMesh=PickupMesh
}