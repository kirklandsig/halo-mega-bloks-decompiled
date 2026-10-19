// Grip's containers (grip_array.h, gripsf_allocator.h, gripbbarray.h,
// gripbbproperty.h): the dynamic array, its allocation and construction
// policies, and the blackboard members that wrap a value or an array.
// Layouts from the PDB; bodies from the disassembly of the out-of-line
// copies retail keeps. A generated header includes this file once
// GripVHeapObject and GripBBMember are complete.
#pragma once

#ifndef HAGGAR_HOST

namespace Grip
{
// Heap allocation with a statistics id (the stat isn't used by Grip_Array)
template <int SID> class AllocatorBaseGH
{
public:
    enum
    {
        StatId = SID,
    };
    static void *Alloc(const void *, unsigned int Size, const char *, unsigned int);
    static void *Realloc(void *Ptr, unsigned int Size, const char *, unsigned int);
    static void Free(void *Ptr);
};

// Construction of plain data: copies
template <class T> class ConstructorPOD
{
public:
    static void Construct(void *Ptr, const T &Source) { *(T *)Ptr = Source; }
    static void Construct(void *) {}
    static void ConstructArray(void *, unsigned int, const T *);
    static void ConstructArray(void *, unsigned int, const T &);
    static void ConstructArray(void *, unsigned int);
    static void Destruct(T *) {}
    static void DestructArray(T *, unsigned int) {}
    static void CopyArrayForward(T *, const T *, unsigned int);
    static void CopyArrayBackward(T *, const T *, unsigned int);
    static bool IsMovable() { return true; }
};

// Construction of movable objects: copy-constructed in place, destroyed
template <class T> class ConstructorMov
{
public:
    static void Construct(void *Ptr, const T &Source) { ::new (Ptr) T(Source); }
    static void Construct(void *Ptr) { ::new (Ptr) T; }
    static void ConstructArray(void *, unsigned int, const T *);
    static void ConstructArray(void *, unsigned int, const T &);
    static void ConstructArray(void *, unsigned int);
    static void Destruct(T *Ptr)
    {
        (void)Ptr;  // unreferenced when T has a trivial destructor
        Ptr->~T();
    }
    static void DestructArray(T *, unsigned int);
    static void CopyArrayForward(T *, const T *, unsigned int);
    static void CopyArrayBackward(T *, const T *, unsigned int);
    static bool IsMovable() { return true; }
};

template <class T, int SID> struct AllocatorGH : public AllocatorBaseGH<SID>, public ConstructorMov<T>
{
};
template <class T, int SID> struct AllocatorGH_POD : public AllocatorBaseGH<SID>, public ConstructorPOD<T>
{
};
}

template <class T, class Allocator> class Grip_Array : public GripVHeapObject
{
public:
    Grip_Array(const int InitialSize = 0) : m_ContainingNum(0), m_ContainingMax(0), m_ContainerContent(0)
    {
        if (InitialSize > 0)
        {
            ResizeTo(InitialSize);
        }
    }
    Grip_Array(const Grip_Array &Other) : m_ContainingNum(0), m_ContainingMax(0), m_ContainerContent(0)
    {
        if (this != &Other)
        {
            CloneContainer(Other.m_ContainerContent, Other.m_ContainingNum, Other.m_ContainingMax);
        }
    }
    virtual ~Grip_Array() { DeleteContainerContent(); }
    Grip_Array &operator=(const Grip_Array &Other)
    {
        if (this != &Other)
        {
            CloneContainer(Other.m_ContainerContent, Other.m_ContainingNum, Other.m_ContainingMax);
        }
        return *this;
    }
    void Clone(const Grip_Array &Other)
    {
        if (this != &Other)
        {
            CloneContainer(Other.m_ContainerContent, Other.m_ContainingNum, Other.m_ContainingMax);
        }
    }
    void Empty() { DeleteContainerContent(); }
    void Reset()
    {
        DestructItems(0, m_ContainingNum);
        m_ContainingNum = 0;
    }
    void Reserve(int Size)
    {
        if (Size > m_ContainingMax)
        {
            ResizeTo(Size);
        }
    }
    int FindObject(const T &Item) const
    {
        for (int i = 0; i < m_ContainingNum; i++)
        {
            if (m_ContainerContent[i] == Item)
            {
                return i;
            }
        }
        return -1;
    }
    bool ContainsItem(const T &Item) const { return FindObject(Item) != -1; }
    int Num() const { return m_ContainingNum; }
    const T &operator[](int Index) const { return m_ContainerContent[Index]; }
    T &operator[](int Index) { return m_ContainerContent[Index]; }
    void AddItem(const T &Item)
    {
        if (m_ContainingNum + 1 > m_ContainingMax)
        {
            ResizeTo(m_ContainingMax + increment);
        }
        Allocator::Construct(&m_ContainerContent[m_ContainingNum], Item);
        m_ContainingNum++;
    }
    void AddUniqueItem(const T &Item)
    {
        if (FindObject(Item) == -1)
        {
            AddItem(Item);
        }
    }
    void InsertItemAt(const T &, int);
    void RemoveItemSwap(int Index)
    {
        DestructItems(Index, 1);
        m_ContainingNum--;
        if (Index != m_ContainingNum)
        {
            memmove(&m_ContainerContent[Index], &m_ContainerContent[m_ContainingNum], sizeof(T));
        }
    }
    void RemoveItem(int Index)
    {
        DestructItems(Index, 1);
        m_ContainingNum--;
        if (Index != m_ContainingNum)
        {
            memmove(&m_ContainerContent[Index], &m_ContainerContent[Index + 1], (m_ContainingNum - Index) * sizeof(T));
        }
    }
    void RemoveItemItem(const T &Item)
    {
        int Index = FindObject(Item);
        if (Index != -1)
        {
            RemoveItem(Index);
        }
    }
    T *GetData() { return m_ContainerContent; }

protected:
    void CloneContainer(T *pContent, int NumItems, int MaxItems)
    {
        if (m_ContainerContent)
        {
            Grip::Memory::pGlobalHeap->Free(m_ContainerContent);
        }
        m_ContainingMax = MaxItems;
        m_ContainingNum = NumItems;
        m_ContainerContent = 0;
        if (MaxItems)
        {
            m_ContainerContent = (T *)Grip::Memory::pGlobalHeap->Alloc(MaxItems * sizeof(T), 0);
        }
        else
        {
            m_ContainerContent = 0;
        }
        for (int i = 0; i < m_ContainingNum; i++)
        {
            Allocator::Construct(&m_ContainerContent[i], pContent[i]);
        }
    }
    void DestructItems(int Index, int Count)
    {
        for (int i = Index; i < Index + Count; i++)
        {
            Allocator::Destruct(&m_ContainerContent[i]);
        }
    }
    void ResizeTo(int NewMax)
    {
        T *pNewContent = (T *)Grip::Memory::pGlobalHeap->Alloc(NewMax * sizeof(T), 0);
        if (m_ContainerContent)
        {
            memcpy(pNewContent, m_ContainerContent, m_ContainingMax * sizeof(T));
        }
        Grip::Memory::pGlobalHeap->Free(m_ContainerContent);
        m_ContainerContent = pNewContent;
        m_ContainingMax = NewMax;
    }
    void DeleteContainerContent()
    {
        DestructItems(0, m_ContainingNum);
        if (m_ContainerContent)
        {
            Grip::Memory::pGlobalHeap->Free(m_ContainerContent);
        }
        m_ContainerContent = 0;
        m_ContainingMax = 0;
        m_ContainingNum = 0;
    }

public:
    static const int increment = 64;
    int m_ContainingNum;
    int m_ContainingMax;
    T *m_ContainerContent;
};

template <class T, int SID> class Grip_ArrayPOD : public Grip_Array<T, Grip::AllocatorGH_POD<T, SID> >
{
public:
    Grip_ArrayPOD(const int InitialSize = 0) : Grip_Array<T, Grip::AllocatorGH_POD<T, SID> >(InitialSize) {}
    Grip_ArrayPOD &operator=(const Grip_ArrayPOD &Other)
    {
        if (this != &Other)
        {
            this->CloneContainer(Other.m_ContainerContent, Other.m_ContainingNum, Other.m_ContainingMax);
        }
        return *this;
    }
    void Clone(const Grip_ArrayPOD &Other)
    {
        if (this != &Other)
        {
            this->CloneContainer(Other.m_ContainerContent, Other.m_ContainingNum, Other.m_ContainingMax);
        }
    }
};

// A blackboard member holding an array: changes dirty the blackboard
template <class T, class ArrayType> class GripBBArray : public GripBBMember
{
public:
    GripBBArray() {}
    void AddItem(const T &Item)
    {
        m_array.AddItem(Item);
        DirtyBlackboard();
    }
    void AddUniqueItem(const T &Item)
    {
        m_array.AddUniqueItem(Item);
        DirtyBlackboard();
    }
    void Remove(int Index)
    {
        m_array.RemoveItem(Index);
        DirtyBlackboard();
    }
    void RemoveItem(const T &Item)
    {
        m_array.RemoveItemItem(Item);
        DirtyBlackboard();
    }
    void RemoveItemSwap(int Index)
    {
        m_array.RemoveItemSwap(Index);
        DirtyBlackboard();
    }
    void Empty()
    {
        m_array.Empty();
        DirtyBlackboard();
    }
    void Reset()
    {
        m_array.Reset();
        DirtyBlackboard();
    }
    bool ContainsItem(const T &Item) const { return m_array.ContainsItem(Item); }
    int FindObject(const T &Item) const { return m_array.FindObject(Item); }
    int Num() const { return m_array.Num(); }
    const ArrayType &GetArray() const { return m_array; }
    ArrayType &GetArray() { return m_array; }
    const T &operator[](int Index) const { return m_array[Index]; }
    T &operator[](int Index) { return m_array[Index]; }

    ArrayType m_array;
};

// A blackboard member holding a value: setting it dirties the blackboard
template <class T> class GripBBProperty : public GripBBMember
{
public:
    GripBBProperty() {}
    T &Get() { return m_value; }
    void Set(const T &Value)
    {
        m_value = Value;
        DirtyBlackboard();
    }

    T m_value;
};

#else

namespace Grip
{
template <int SID> class AllocatorBaseGH
{
};
template <class T> class ConstructorPOD
{
};
template <class T> class ConstructorMov
{
};
template <class T, int SID> struct AllocatorGH
{
};
template <class T, int SID> struct AllocatorGH_POD
{
};
}
template <class T, class Allocator> class Grip_Array : public GripVHeapObject
{
public:
    hg::be<int> m_ContainingNum;
    hg::be<int> m_ContainingMax;
    hg::gptr<T> m_ContainerContent;
};
template <class T, int SID> class Grip_ArrayPOD : public Grip_Array<T, Grip::AllocatorGH_POD<T, SID> >
{
};
template <class T, class ArrayType> class GripBBArray : public GripBBMember
{
public:
    ArrayType m_array;
};
template <class T> class GripBBProperty : public GripBBMember
{
public:
    T m_value;
};

#endif
