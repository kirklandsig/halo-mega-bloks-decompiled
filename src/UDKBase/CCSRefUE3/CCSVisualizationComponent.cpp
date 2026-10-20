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

// The proxy draws the brain's debug rendering proxies.
#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x8336D3C0
FCCSVisualizationSceneProxy::FCCSVisualizationSceneProxy(const UCCSVisualizationComponent *pComponent)
    : GripUnrealSceneProxy(pComponent)
{
    m_ctrl = Cast<ACCSController>(pComponent->Owner);
    if (m_ctrl != 0)
    {
        m_ctrl->Brain->CreateDebugRenderingProxies(m_proxies);
    }
}

// @retail 0x8336D440
FCCSVisualizationSceneProxy::~FCCSVisualizationSceneProxy()
{
}
#endif

// @retail 0x83322078
void FCCSVisualizationSceneProxy::CreateDynamic()
{
    if (m_ctrl != 0)
    {
        m_ctrl->Brain->CreateDebugRenderingProxies(m_proxies);
    }
}

// @retail 0x8336D4E0
unsigned long FCCSVisualizationSceneProxy::GetMemoryFootprint() const
{
    return sizeof(*this) + GetAllocatedSize();
}

// @retail 0x8336D4D0
unsigned long FCCSVisualizationSceneProxy::GetAllocatedSize() const
{
    return FPrimitiveSceneProxy::GetAllocatedSize();
}
