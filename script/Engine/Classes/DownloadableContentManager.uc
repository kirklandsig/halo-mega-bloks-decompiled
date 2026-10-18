class DownloadableContentManager extends Object
	native;

var native const transient array<Pointer> DLCConfigCacheChanges;
var const transient array<string> InstalledDLC;
var native const transient Map_Mirror NonPackageFilePathMap;
var native const transient array< Class > ClassesToReload;
var native const transient array<Object> ObjectsToReload;
var const transient array<string> QueuedFullyLoadPackageInis;
var const transient GameEngine GameEngine;
//var delegate<OnRefreshComplete> __OnRefreshComplete__Delegate;

// Export UDownloadableContentManager::execInstallDLC(FFrame&, void* const)
native function bool InstallDLC(const out OnlineContent DLCBundle);

// Export UDownloadableContentManager::execInstallDLCs(FFrame&, void* const)
native function InstallDLCs(const out array<OnlineContent> DLCBundles);

// Export UDownloadableContentManager::execClearDLC(FFrame&, void* const)
native function ClearDLC();

// Export UDownloadableContentManager::execGetDLCNonPackageFilePath(FFrame&, void* const)
native function bool GetDLCNonPackageFilePath(name NonPackageFileName, out string Path);

// Export UDownloadableContentManager::execAddSectionToObjectList(FFrame&, void* const)
native function AddSectionToObjectList(string Section);

// Export UDownloadableContentManager::execMarkPerObjectConfigPendingKill(FFrame&, void* const)
native function MarkPerObjectConfigPendingKill(string Section);

// Export UDownloadableContentManager::execUpdateObjectLists(FFrame&, void* const)
native function UpdateObjectLists();

// Export UDownloadableContentManager::execInstallPackages(FFrame&, void* const)
protected native function InstallPackages(const out OnlineContent DLCBundle);

// Export UDownloadableContentManager::execInstallNonPackageFiles(FFrame&, void* const)
protected native function InstallNonPackageFiles(const out OnlineContent DLCBundle);

event Init()
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
	// End:0x1AA
	if(OnlineSub != none)
	{
		// End:0xB3
		if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
		{
			OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
		}
		// End:0x12E
		if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
		{
			OnlineSub.SystemInterface.AddStorageDeviceChangeDelegate(OnStorageDeviceChange);
		}
		// End:0x1AA
		if(NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
		{
			OnlineSub.ContentInterface.AddContentChangeDelegate(OnContentChange);
		}
	}
	//return;	
}

function OnLoginChange(byte LocalUserNum)
{
	RefreshDLC();
	//return;	
}

function OnStorageDeviceChange()
{
	RefreshDLC();
	//return;	
}

function OnContentChange()
{
	RefreshDLC();
	//return;	
}

function RefreshDLC()
{
	local DownloadableContentEnumerator DLCEnum;

	ClearDLC();
	DLCEnum = Class'Engine.GameEngine'.static.GetDLCEnumerator();
	// End:0x91
	if(DLCEnum != none)
	{
		DLCEnum.AddFindDLCDelegate(RefreshDLCEnumComplete);
		DLCEnum.FindDLC();
	}
	//return;	
}

function RefreshDLCEnumComplete()
{
	local DownloadableContentEnumerator DLCEnum;

	DLCEnum = Class'Engine.GameEngine'.static.GetDLCEnumerator();
	// End:0x87
	if(DLCEnum != none)
	{
		DLCEnum.ClearFindDLCDelegate(RefreshDLCEnumComplete);
		DLCEnum.InstallAllDLC();
	}
	OnRefreshComplete();
	//return;	
}

// Export UDownloadableContentManager::execAddPackagesToFullyLoad(FFrame&, void* const)
native function AddPackagesToFullyLoad(string Filename);

delegate OnRefreshComplete()
{
	//return;	
}
