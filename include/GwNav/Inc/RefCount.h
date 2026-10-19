// Gameware Navigation's reference-counted pointer (sf_refcount.h): Ptr
// holds an object and its reference, Pickable hands one over without
// adding a reference. Layouts from the PDB; bodies from the disassembly of
// the out-of-line copies retail keeps. The objects' AddRef and Release
// come from their own reference-count base.
#pragma once
#include "Core/Inc/HostGuest.h"

namespace Kaim
{
enum PickType
{
    PickValue = 0,
};

#ifndef HAGGAR_HOST

template <class C> class Pickable
{
public:
    Pickable() : pV(0) {}
    explicit Pickable(C *p) : pV(p) {}
    Pickable(C *p, PickType) : pV(p) {}
    Pickable &operator=(const Pickable &Other)
    {
        pV = Other.pV;
        return *this;
    }
    C *GetPtr() const { return pV; }
    C *operator->() const { return pV; }
    C &operator*() const { return *pV; }

private:
    C *pV;
};

template <class C> class Ptr
{
public:
    Ptr() : pObject(0) {}
    Ptr(C &Object) : pObject(&Object) {}
    Ptr(Pickable<C> v) : pObject(v.GetPtr()) {}
    Ptr(Ptr &Other, PickType) : pObject(Other.pObject) { Other.pObject = 0; }
    Ptr(C *pObj)
    {
        if (pObj)
        {
            pObj->AddRef();
        }
        pObject = pObj;
    }
    Ptr(const Ptr &Src)
    {
        if (Src.pObject)
        {
            Src.pObject->AddRef();
        }
        pObject = Src.pObject;
    }
    ~Ptr()
    {
        if (pObject)
        {
            pObject->Release();
        }
    }
    bool operator==(C *p) const { return pObject == p; }
    bool operator==(const Ptr &p) const { return pObject == p.pObject; }
    bool operator!=(C *p) const { return pObject != p; }
    bool operator!=(const Ptr &p) const { return pObject != p.pObject; }
    bool operator<(const Ptr &p) const { return pObject < p.pObject; }
    const Ptr &operator=(const Ptr &Src)
    {
        if (Src.pObject)
        {
            Src.pObject->AddRef();
        }
        if (pObject)
        {
            pObject->Release();
        }
        pObject = Src.pObject;
        return *this;
    }
    const Ptr &operator=(C *pObj)
    {
        if (pObj)
        {
            pObj->AddRef();
        }
        if (pObject)
        {
            pObject->Release();
        }
        pObject = pObj;
        return *this;
    }
    // adopts the new object's reference (Ptr<C> p = *new C); forced inline,
    // as retail inlines it where -Ob2 alone doesn't (CCSTarget::FindDestinationReachable)
    __forceinline const Ptr &operator=(C &Obj)
    {
        if (pObject)
        {
            pObject->Release();
        }
        pObject = &Obj;
        return *this;
    }
    Ptr &operator=(Pickable<C> v) { return Pick(v); }
    Ptr &SetPtr(Pickable<C>);
    Ptr &SetPtr(C &);
    Ptr &SetPtr(C *);
    Ptr &SetPtr(const Ptr &);
    void NullWithoutRelease() { pObject = 0; }
    void Clear()
    {
        if (pObject)
        {
            pObject->Release();
        }
        pObject = 0;
    }
    C *&GetRawRef() { return pObject; }
    C *GetPtr() const { return pObject; }
    C &operator*() const { return *pObject; }
    C *operator->() const { return pObject; }
    operator C *() const { return pObject; }
    Ptr &Pick(C *p)
    {
        if (pObject)
        {
            pObject->Release();
        }
        pObject = p;
        return *this;
    }
    Ptr &Pick(Pickable<C> v)
    {
        if (pObject)
        {
            pObject->Release();
        }
        pObject = v.GetPtr();
        return *this;
    }
    Ptr &Pick(Ptr &Other);

    C *pObject;
};

#else

template <class C> class Pickable
{
public:
    hg::gptr<C> pV;
};
template <class C> class Ptr
{
public:
    hg::gptr<C> pObject;
};

#endif
}
