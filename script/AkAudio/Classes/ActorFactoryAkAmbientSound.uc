class ActorFactoryAkAmbientSound extends ActorFactory
	native
	config(Editor)
	editinlinenew
	collapsecategories;

var AkEvent AmbientEvent;

defaultproperties
{
	MenuName="Add AkAmbientSound"
	NewActorClass=Class'AkAudio.AkAmbientSound'
}