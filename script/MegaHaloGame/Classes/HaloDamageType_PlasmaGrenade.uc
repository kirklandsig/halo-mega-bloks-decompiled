class HaloDamageType_PlasmaGrenade extends HaloDamageType;

defaultproperties
{
	ToPlayerScaler=0.3400000
	bKnockdown=true
	KnockdownDamageThreshold=80
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType_PlasmaGrenade.ForceFeedbackWaveform0'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType.ForceFeedbackWaveform0'
	begin object name="ForceFeedbackWaveform0"
	end object
	DamagedFFWaveform=ForceFeedbackWaveform0
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType_PlasmaGrenade.ForceFeedbackWaveform1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType.ForceFeedbackWaveform1'
	begin object name="ForceFeedbackWaveform1"
	end object
	KilledFFWaveform=ForceFeedbackWaveform1
}