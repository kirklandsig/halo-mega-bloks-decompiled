class HaloDamageType extends UTDamageType;

var float FromAIScaler;
var float ToPlayerScaler;
var float ShieldScaler;
var int HeadshotBonus;
var bool Staggers;
var bool bKnockdown;
var int KnockdownDamageThreshold;

defaultproperties
{
	FromAIScaler=1.0000000
	ToPlayerScaler=1.0000000
	ShieldScaler=1.0000000
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType.ForceFeedbackWaveform0'
	// Archetype: ForceFeedbackWaveform'UTGame.Default__UTDamageType.ForceFeedbackWaveform0'
	begin object name="ForceFeedbackWaveform0"
	end object
	DamagedFFWaveform=ForceFeedbackWaveform0
	// Reference: ForceFeedbackWaveform'MegaHaloGame.Default__HaloDamageType.ForceFeedbackWaveform1'
	// Archetype: ForceFeedbackWaveform'UTGame.Default__UTDamageType.ForceFeedbackWaveform1'
	begin object name="ForceFeedbackWaveform1"
	end object
	KilledFFWaveform=ForceFeedbackWaveform1
}