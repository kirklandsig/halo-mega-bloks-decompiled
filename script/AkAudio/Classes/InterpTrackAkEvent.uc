class InterpTrackAkEvent extends InterpTrack
	native
	collapsecategories;

struct native AkEventTrackKey
{
	var float Time;
	var AkEvent Event;

	structdefaultproperties
	{
		Time=0.0000000
		Event=none
	}
};

var array<AkEventTrackKey> AkEvents;

defaultproperties
{
	TrackInstClass=Class'AkAudio.InterpTrackInstAkEvent'
	TrackTitle="AkEvent"
}