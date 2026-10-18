class HaloDamageType_ChargedPistolBullet extends HaloDamageType;

defaultproperties
{
	ShieldScaler=1.5000000
	Staggers=true
	bKnockdown=true
	KnockdownDamageThreshold=80
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType_ChargedPistolBullet.ForceFeedbackWaveform0'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType.ForceFeedbackWaveform0'
	begin object name="ForceFeedbackWaveform0"
	end object
	DamagedFFWaveform=ForceFeedbackWaveform0
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType_ChargedPistolBullet.ForceFeedbackWaveform1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType.ForceFeedbackWaveform1'
	begin object name="ForceFeedbackWaveform1"
	end object
	KilledFFWaveform=ForceFeedbackWaveform1
}