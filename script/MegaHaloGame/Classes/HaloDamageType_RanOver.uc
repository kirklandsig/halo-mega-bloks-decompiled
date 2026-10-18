class HaloDamageType_RanOver extends HaloDamageType;

defaultproperties
{
	bNeverGibs=true
	bUseTearOffMomentum=true
	bVehicleHit=true
	GibPerterbation=0.5000000
	bExtraMomentumZ=false
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType_RanOver.ForceFeedbackWaveform0'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType.ForceFeedbackWaveform0'
	begin object name="ForceFeedbackWaveform0"
	end object
	DamagedFFWaveform=ForceFeedbackWaveform0
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType_RanOver.ForceFeedbackWaveform1'
	// Archetype: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType.ForceFeedbackWaveform1'
	begin object name="ForceFeedbackWaveform1"
	end object
	KilledFFWaveform=ForceFeedbackWaveform1
}