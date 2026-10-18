class UIDataStorePublisher extends UIDataStoreSubscriber
	abstract
	native;

// Export UUIDataStorePublisher::execSaveSubscriberValue(FFrame&, void* const)
native function bool SaveSubscriberValue(out array<UIDataStore> out_BoundDataStores, optional int BindingIndex = -1);
