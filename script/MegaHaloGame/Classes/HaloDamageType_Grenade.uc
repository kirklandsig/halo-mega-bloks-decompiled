class HaloDamageType_Grenade extends HaloDamageType;

defaultproperties
{
	ToPlayerScaler=0.3400000
	ShieldScaler=0.5000000
	Staggers=true
	bKnockdown=true
	KnockdownDamageThreshold=80
	bAlwaysGibs=true
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType_Grenade.ForceFeedbackWaveform0'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType.ForceFeedbackWaveform0'
	begin object name="ForceFeedbackWaveform0"
	end object
	DamagedFFWaveform=ForceFeedbackWaveform0
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType_Grenade.ForceFeedbackWaveform1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType.ForceFeedbackWaveform1'
	begin object name="ForceFeedbackWaveform1"
	end object
	KilledFFWaveform=ForceFeedbackWaveform1
}