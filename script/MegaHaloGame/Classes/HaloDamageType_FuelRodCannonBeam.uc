class HaloDamageType_FuelRodCannonBeam extends HaloDamageType;

defaultproperties
{
	ShieldScaler=2.0000000
	bKnockdown=true
	KnockdownDamageThreshold=20
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType_FuelRodCannonBeam.ForceFeedbackWaveform0'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType.ForceFeedbackWaveform0'
	begin object name="ForceFeedbackWaveform0"
	end object
	DamagedFFWaveform=ForceFeedbackWaveform0
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType_FuelRodCannonBeam.ForceFeedbackWaveform1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType.ForceFeedbackWaveform1'
	begin object name="ForceFeedbackWaveform1"
	end object
	KilledFFWaveform=ForceFeedbackWaveform1
}