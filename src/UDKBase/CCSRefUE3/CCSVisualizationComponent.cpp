// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccsvisualizationcomponent.cpp: the component that draws a brain's debug view.
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x833220A8
void UCCSVisualizationComponent::UpdateBounds()
{
    FBox BoundingBox;
    BoundingBox.Max = FVector(1.0e17f, 1.0e17f, 1.0e17f);
    BoundingBox.Min = FVector(-1.0e17f, -1.0e17f, -1.0e17f);
    Bounds = FBoxSphereBounds(BoundingBox);
}

// @retail 0x8336D4F0
FPrimitiveSceneProxy *UCCSVisualizationComponent::CreateSceneProxy()
{
    SceneProxy = new FCCSVisualizationSceneProxy(this);
    return (FPrimitiveSceneProxy *)SceneProxy;
}
