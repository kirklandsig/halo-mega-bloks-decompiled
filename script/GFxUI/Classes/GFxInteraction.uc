class GFxInteraction extends Interaction
	transient
	native
	config(Engine);

var private native const noexport Pointer VfTable_FCallbackEventDevice;
var bool bFakeMobileTouches;

// Export UGFxInteraction::execGetFocusMovie(FFrame&, void* const)
native function GFxMoviePlayer GetFocusMovie(int ControllerId);

// Export UGFxInteraction::execNotifyGameSessionEnded(FFrame&, void* const)
native function NotifyGameSessionEnded();

// Export UGFxInteraction::execNotifyPlayerAdded(FFrame&, void* const)
native function NotifyPlayerAdded(int PlayerIndex, LocalPlayer AddedPlayer);

// Export UGFxInteraction::execNotifyPlayerRemoved(FFrame&, void* const)
native function NotifyPlayerRemoved(int PlayerIndex, LocalPlayer RemovedPlayer);

// Export UGFxInteraction::execNotifySplitscreenLayoutChanged(FFrame&, void* const)
native function NotifySplitscreenLayoutChanged();

// Export UGFxInteraction::execCloseAllMoviePlayers(FFrame&, void* const)
native function CloseAllMoviePlayers();
