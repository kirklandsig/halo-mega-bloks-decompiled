// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccscoverrenderingcomponent.cpp: the debug scene view's component for a
// brain's cover; it makes a CCSCoverRenderingProxy.
#pragma once
#include "CCSCoverRenderingProxy.cpp"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x8332EF40
CCSCoverRenderingComponent::CCSCoverRenderingComponent(CCSBrain *pBrain) : m_pBrain(pBrain)
{
}
#endif

// @retail 0x83323CF8
CCSCoverRenderingComponent::~CCSCoverRenderingComponent()
{
}

// @retail 0x83356C88
IGripSRProxy *CCSCoverRenderingComponent::CreateRenderingProxy()
{
    CCSCoverRenderingProxy *pProxy = new CCSCoverRenderingProxy();
    pProxy->SetCovers(m_pBrain->GetBlackboard<CCSBlackboard>()->m_covers.GetArray());
    return pProxy;
}

// @retail 0x8333BE28
bool CCSCoverRenderingComponent::IsProxyVisible()
{
    CCSDebugOptions *pOptions = GripEngineServices::GetAIManagerSystem<CCSDebugOptions>();
    return pOptions != 0 && pOptions->IsOptionEnabled(CCSDebugOptions::COVER);
}
