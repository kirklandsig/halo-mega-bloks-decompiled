class UIDataStore extends UIDataProvider
	abstract
	transient
	native
	config(Engine);

var name Tag;
var array< delegate<OnDataStoreValueUpdated> > RefreshSubscriberNotifies;
//var delegate<OnDataStoreValueUpdated> __OnDataStoreValueUpdated__Delegate;

delegate OnDataStoreValueUpdated(UIDataStore SourceDataStore, bool bValuesInvalidated, name PropertyTag, UIDataProvider SourceProvider, int ArrayIndex)
{
	//return;	
}

event Registered(LocalPlayer PlayerOwner)
{
	//return;	
}

event Unregistered(LocalPlayer PlayerOwner)
{
	//return;	
}

event SubscriberAttached(UIDataStoreSubscriber Subscriber)
{
	local int SubscriberNotifyIndex;

	// End:0xC0
	if(NotEqual_InterfaceInterface(Subscriber, none))
	{
		SubscriberNotifyIndex = RefreshSubscriberNotifies.Find(Subscriber.NotifyDataStoreValueUpdated);
		// End:0xC0
		if(SubscriberNotifyIndex == -1)
		{
			SubscriberNotifyIndex = RefreshSubscriberNotifies.Length;
			RefreshSubscriberNotifies[SubscriberNotifyIndex] = Subscriber.NotifyDataStoreValueUpdated;
		}
	}
	//return;	
}

event SubscriberDetached(UIDataStoreSubscriber Subscriber)
{
	local int SubscriberNotifyIndex;

	// End:0x86
	if(NotEqual_InterfaceInterface(Subscriber, none))
	{
		SubscriberNotifyIndex = RefreshSubscriberNotifies.Find(Subscriber.NotifyDataStoreValueUpdated);
		// End:0x86
		if(SubscriberNotifyIndex != -1)
		{
			RefreshSubscriberNotifies.Remove(SubscriberNotifyIndex, 1);
		}
	}
	//return;	
}

function bool NotifyGameSessionEnded()
{
	//return ReturnValue;	
}

final event RefreshSubscribers(optional name PropertyTag, optional bool bInvalidateValues = true, optional UIDataProvider SourceProvider, optional int ArrayIndex = -1)
{
	local int Idx;
	local delegate<OnDataStoreValueUpdated> Subscriber;
	local array< delegate<OnDataStoreValueUpdated> > SubscriberArrayCopy;

	SubscriberArrayCopy.Length = RefreshSubscriberNotifies.Length;
	Idx = 0;
	J0x30:

	// End:0x7D [Loop If]
	if(Idx < SubscriberArrayCopy.Length)
	{
		SubscriberArrayCopy[Idx] = RefreshSubscriberNotifies[Idx];
		Idx++;
		// [Loop Continue]
		goto J0x30;
	}
	Idx = 0;
	J0x88:

	// End:0x104 [Loop If]
	if(Idx < SubscriberArrayCopy.Length)
	{
		Subscriber = SubscriberArrayCopy[Idx];
		OnDataStoreValueUpdated(self, bInvalidateValues, PropertyTag, SourceProvider, ArrayIndex);
		Idx++;
		// [Loop Continue]
		goto J0x88;
	}
	//return;	
}

final function DataStoreClient GetDataStoreClient()
{
	return Class'Engine.UIInteraction'.static.GetDataStoreClient();
	//return ReturnValue;	
}
