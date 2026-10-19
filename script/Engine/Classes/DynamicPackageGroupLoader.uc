class DynamicPackageGroupLoader extends Actor
	native
	config(DynamicLoader)
	notplaceable;

struct native PkgGroup
{
	var name Name;
	var array<string> PackageNameList;

	structdefaultproperties
	{
		Name="None"
		PackageNameList=none
	}
};

var config array<config PkgGroup> PackageGroups;

event PostBeginPlay()
{
	super.PostBeginPlay();
	DumpDataToLog();
	// End:0x8A
	if(!VerifySanity())
	{
		WarnInternal("DynamicPackageGroupLoader detected problems with data configuration - check DynamicLoader INI file!");
	}
	//return;	
}

// Export UDynamicPackageGroupLoader::execStartLoadingPackageGroup(FFrame&, void* const)
native function bool StartLoadingPackageGroup(string pkgGroupName);

// Export UDynamicPackageGroupLoader::execUnloadPackageGroup(FFrame&, void* const)
native function bool UnloadPackageGroup(string pkgGroupName);

// Export UDynamicPackageGroupLoader::execIsPackageGroupLoaded(FFrame&, void* const)
native function bool IsPackageGroupLoaded(string pkgGroupName);

// Export UDynamicPackageGroupLoader::execVerifySanity(FFrame&, void* const)
native function bool VerifySanity();

simulated function DumpDataToLog()
{
	local int G, P;

	LogInternal(" ====== BEGIN DYNAMIC PACKAGE GROUP LOADER DUMP ====== ");
	G = 0;
	J0x47:

	// End:0x1A4 [Loop If]
	if(G < PackageGroups.Length)
	{
		LogInternal(((("    DYNAMIC PACKAGE GROUP: " $ string(PackageGroups[G].Name)) $ " (") $ string(PackageGroups[G].PackageNameList.Length)) $ ") packages listed");
		P = 0;
		J0xFA:

		// End:0x196 [Loop If]
		if(P < PackageGroups[G].PackageNameList.Length)
		{
			LogInternal((("        > PKG " $ string(P)) $ ":  ") $ PackageGroups[G].PackageNameList[P]);
			++P;
			// [Loop Continue]
			goto J0xFA;
		}
		++G;
		// [Loop Continue]
		goto J0x47;
	}
	LogInternal(" ====== END DYNAMIC PACKAGE GROUP LOADER DUMP ====== ");
	//return;	
}

defaultproperties
{
	PackageGroups[0]=(Name="Warthog",PackageNameList=("Warthog","MainHUD","BadPackageName"))
	PackageGroups[1]=(Name="Mongoose",PackageNameList=("Warthog","MainHUD","BadPackageName"))
	CollisionType=ECollisionType.COLLIDE_CustomDefault
}