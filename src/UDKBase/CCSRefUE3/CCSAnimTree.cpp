// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsanimtree.cpp: the slot node script drives.
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x8331EBF0
void UCCSATAnimNodeSlot::ActivateChild(int ChildIndex, float BlendTime)
{
    SetActiveChild(ChildIndex, BlendTime);
}
