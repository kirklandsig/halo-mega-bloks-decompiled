class CCSNorman extends Object
	native;

// Export UCCSNorman::execGetTotalBrainCount(FFrame&, void* const)
native static final function int GetTotalBrainCount(int Team);

// Export UCCSNorman::execGetBrainCountByPawnType(FFrame&, void* const)
native static final function int GetBrainCountByPawnType(Class<Pawn> Pawn);
