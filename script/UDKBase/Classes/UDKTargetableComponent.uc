class UDKTargetableComponent extends ActorComponent
	native;

enum HaloTargetType
{
	TARGET_NONE,                    // 0
	TARGET_PASSIVE_OBJECTIVE,       // 1
	TARGET_PASSIVE_SECONDARY,       // 2
	TARGET_AGGRESSIVE_STATIONARY,   // 3
	TARGET_AGGRESSIVE_MOBILE,       // 4
	TARGET_MAX                      // 5
};

var int BaseThreatVal;
var float MaxAIHeat;
var float CurAIHeat;
var float ReduceHeatPerSecond;
var float InnerThreatRadius;
var float OutterThreatRadius;
var float ModifiableThreatPct;
var float fAITargetHeight;
var const UDKTargetableComponent.HaloTargetType AITargetType;
var bool bAITargetable;
var bool bIsVehicle;
var Actor myOwner;

// Export UUDKTargetableComponent::execBeginDeath(FFrame&, void* const)
native final function BeginDeath();

defaultproperties
{
	BaseThreatVal=50
	MaxAIHeat=120.0000000
	ReduceHeatPerSecond=30.0000000
	InnerThreatRadius=5000.0000000
	OutterThreatRadius=8000.0000000
	ModifiableThreatPct=1.0000000
	fAITargetHeight=200.0000000
}