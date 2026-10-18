class HaloNeedleTargetComponent extends ActorComponent;

var array<HaloProjectile_NeedlerNeedle> Needles;
var int ComboTriggerSize;
var float ComboDamagePerNeedle;
var Class<DamageType> ComboDamageType;
var float ComboDelay;
var ParticleSystem ComboExplosionFxTemplate;
var float ComboTime;

simulated function AddNeedle(HaloProjectile_NeedlerNeedle needle)
{
	Needles.AddItem(needle);
	// End:0xDF
	if(Owner != none)
	{
		// End:0xB4
		if(Needles.Length == ComboTriggerSize)
		{
			ComboTime = Owner.WorldInfo.TimeSeconds + ComboDelay;
			// End:0xB0
			foreach Needles(needle)
			{
				PrepNeedleForComboExplosion(needle);				
			}						
		}
		else
		{
			// End:0xDF
			if(Needles.Length > ComboTriggerSize)
			{
				PrepNeedleForComboExplosion(needle);
			}
		}
	}
	//return;	
}

simulated function RemoveNeedle(HaloProjectile_NeedlerNeedle needle)
{
	Needles.RemoveItem(needle);
	//return;	
}

function Tick(float DeltaTime)
{
	// End:0x11
	if(Owner == none)
	{
		return;
	}
	// End:0x80
	if((ComboTime > 0.0000000) && ComboTime <= Owner.WorldInfo.TimeSeconds)
	{
		DoComboExplosion();
		ComboTime = 0.0000000;
	}
	//return;	
}

simulated function UpdateStickyAttachments()
{
	local HaloProjectile_NeedlerNeedle needle;

	// End:0x37
	foreach Needles(needle)
	{
		needle.UpdateStickyAttachment();		
	}	
	//return;	
}

simulated function OnDeath()
{
	local HaloProjectile_NeedlerNeedle needle;
	local array<HaloProjectile_NeedlerNeedle> Temp;

	Temp = Needles;
	Needles.Length = 0;
	// End:0x56
	foreach Temp(needle)
	{
		needle.ExplodeNow();		
	}	
	//return;	
}

simulated function OnOwnerDestroyed()
{
	OnDeath();
	//return;	
}

simulated function PrepNeedleForComboExplosion(HaloProjectile_NeedlerNeedle needle)
{
	needle.ClearExplodeNowTimer();
	//return;	
}

simulated function DoComboExplosion()
{
	local HaloProjectile_NeedlerNeedle needle;
	local array<HaloProjectile_NeedlerNeedle> Temp;

	// End:0x1E3
	if(Owner != none)
	{
		Owner.WorldInfo.MyEmitterPool.SpawnEmitter(ComboExplosionFxTemplate, Owner.Location, Owner.Rotation, Owner);
		Owner.SetSwitch('Explosion_Type', 'Explosion_Plasma');
		Owner.SetSwitch('Explosion_Size', 'Explosion_Small');
		Owner.PlayAkEvent(AkEvent'Foley.Play_Explosion');
		// End:0x1E3
		if(Needles.Length > 0)
		{
			Owner.TakeDamage(int(float(Needles.Length) * ComboDamagePerNeedle), Needles[0].InstigatorController, Needles[0].Location, vect(0.0000000, 0.0000000, 0.0000000), ComboDamageType,, Needles[0]);
		}
	}
	Temp = Needles;
	Needles.Length = 0;
	// End:0x239
	foreach Temp(needle)
	{
		needle.ReturnToNspacePool();		
	}	
	//return;	
}

defaultproperties
{
	ComboTriggerSize=7
	ComboDamagePerNeedle=10.0000000
	ComboDamageType=Class'MegaHaloGame.HaloDamageType_NeedlerNeedleCombo'
	ComboDelay=0.7500000
	ComboExplosionFxTemplate=ParticleSystem'WP_COV_NEEDLER.Effects.WP_COV_NEEDLESGROUP_Hit'
}