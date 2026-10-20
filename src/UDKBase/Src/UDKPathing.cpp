// @object Unity_UDKWeaponEtAl.cpp.obj
// n-Space's addition to UDK's udkpathing.cpp: a jump pad's own gravity scale.
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x833815B8
float AUDKJumpPad::GetGravityZ()
{
    return Super::GetGravityZ() * CustomGravityScaling;
}
