// @object Unity_HaloRBTKamikazeEtAl.cpp.obj
// ccstargetrenderingcomponent.cpp: the debug scene view's component for a
// brain's current target; it makes a CCSTargetRenderingProxy.
#pragma once
#include "CCSTargetRenderingProxy.cpp"
#include "../Src/HaloRBTKamikaze.cpp"

#ifndef HAGGAR_HOST  // constructors stay recompiled in the port
// @retail 0x83325270
CCSTargetRenderingComponent::CCSTargetRenderingComponent(CCSBlackboard *pBB) : m_pBB(pBB)
{
}
#endif

// @retail 0x83340990
IGripSRProxy *CCSTargetRenderingComponent::CreateRenderingProxy()
{
    CCSTargetRenderingProxy *pProxy = new CCSTargetRenderingProxy();
    pProxy->SetTarget(m_pBB->GetCurrentTarget());
    return pProxy;
}

// @retail 0x83340A88
bool CCSTargetRenderingComponent::IsProxyVisible()
{
    GripBrainDebugOptions *pOptions = GripEngineServices::GetAIManagerSystem<GripBrainDebugOptions>();
    return pOptions != 0 && pOptions->IsOptionEnabled(GripBrainDebugOptions::BT_BB);
}
