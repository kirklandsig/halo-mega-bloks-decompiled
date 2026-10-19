// UE3's script interface reference (core\inc\scriptinterface.h): an object
// and its interface pointer. Layout from the PDB; bodies from the
// disassembly of the out-of-line copies retail keeps.
#pragma once
#include "Core/Inc/HostGuest.h"

class UObject;

class FScriptInterface
{
#ifndef HAGGAR_HOST
public:
    FScriptInterface(UObject *InObject = 0, void *InInterface = 0) : ObjectPointer(InObject), InterfacePointer(InInterface) {}
    UObject *GetObject() const { return ObjectPointer; }
    UObject *&GetObjectRef() { return ObjectPointer; }
    void *GetInterface() const { return ObjectPointer != 0 ? InterfacePointer : 0; }
    void SetObject(UObject *InObject)
    {
        ObjectPointer = InObject;
        if (InObject == 0)
        {
            SetInterface(0);
        }
    }
    void SetInterface(void *InInterface) { InterfacePointer = InInterface; }
    unsigned int operator==(const FScriptInterface &Other) const
    {
        return GetInterface() == Other.GetInterface() && ObjectPointer == Other.GetObject();
    }
    unsigned int operator!=(const FScriptInterface &Other) const
    {
        return GetInterface() != Other.GetInterface() || ObjectPointer != Other.GetObject();
    }

private:
    UObject *ObjectPointer;
    void *InterfacePointer;
#else
public:
    hg::gptr<UObject> ObjectPointer;
    hg::be<unsigned int> InterfacePointer;
#endif
};

template <class InterfaceType> class TScriptInterface : public FScriptInterface
{
#ifndef HAGGAR_HOST
public:
    TScriptInterface() {}
    TScriptInterface(const TScriptInterface &Other) : FScriptInterface(Other.GetObject(), Other.GetInterface()) {}
    InterfaceType *operator->() const { return (InterfaceType *)GetInterface(); }
    InterfaceType &operator*() const { return *(InterfaceType *)GetInterface(); }
    operator unsigned int() const { return GetInterface() != 0; }
    unsigned int operator==(const TScriptInterface &Other) const
    {
        return GetInterface() == Other.GetInterface() && GetObject() == Other.GetObject();
    }
    unsigned int operator==(const InterfaceType *Other) const { return GetInterface() == Other; }
    unsigned int operator!=(const TScriptInterface &Other) const
    {
        return GetInterface() != Other.GetInterface() || GetObject() != Other.GetObject();
    }
    unsigned int operator!=(const InterfaceType *Other) const { return GetInterface() != Other; }
#endif
};
