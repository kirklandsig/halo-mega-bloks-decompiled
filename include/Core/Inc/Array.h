// UE3's dynamic array (core\inc\array.h): the heap allocator, TArray and
// TArrayNoInit. Layouts from the PDB; bodies written from the disassembly of
// the out-of-line copies retail keeps (TArray<ActorWrapper *>::RemoveSwap and
// the like). check() records __LINE__, so each check sits on its retail line.
// The host build (HAGGAR_HOST) sees an array in guest memory: no bodies.
#pragma once
#include "Core/Inc/HostGuest.h"
#include "Core/Inc/Core.h"

class FArchive;
struct FScriptContainerElement;

int DefaultCalculateSlack(int NumElements, int NumAllocatedElements, unsigned int BytesPerElement);

#ifndef HAGGAR_HOST

class FHeapAllocator
{
public:
    enum
    {
        NeedsElementType = 0,
    };
    class ForAnyElementType
    {
    public:
        ForAnyElementType() : Data(0) {}
        ForAnyElementType(ENoInit) {}
        ~ForAnyElementType()
        {
            if (Data)
            {
                appFree(Data);
                Data = 0;
            }
        }
        FScriptContainerElement *GetAllocation() const { return Data; }
        void ResizeAllocation(int PreviousNumElements, int NumElements, int NumBytesPerElement)
        {
            (void)PreviousNumElements;
            if (Data || NumElements)
            {
                Data = (FScriptContainerElement *)appRealloc(Data, NumElements * NumBytesPerElement, DEFAULT_ALIGNMENT);
            }
        }
        int CalculateSlack(int NumElements, int NumAllocatedElements, int NumBytesPerElement) const
        {
            return DefaultCalculateSlack(NumElements, NumAllocatedElements, NumBytesPerElement);
        }
        int GetAllocatedSize(int NumAllocatedElements, int NumBytesPerElement) const
        {
            return NumAllocatedElements * NumBytesPerElement;
        }
        FScriptContainerElement *Data;
    };
};

class FDefaultAllocator : public FHeapAllocator
{
};

template <class T, class Allocator = FDefaultAllocator> class TArray
{
public:
    typedef T ElementType;
    enum
    {
        AllocatorNeedsElementType = Allocator::NeedsElementType,
    };

    TArray() : ArrayNum(0), ArrayMax(0) {}
    TArray(ENoInit) : AllocatorInstance(E_NoInit) {}
    explicit TArray(int InNum) : ArrayNum(InNum), ArrayMax(InNum)
    {
        AllocatorInstance.ResizeAllocation(0, ArrayMax, sizeof(T));
    }
    TArray(const TArray &Other) : ArrayNum(0), ArrayMax(0) { Copy(Other); }
    ~TArray()
    {
        DestructItems(0, ArrayNum);
        ArrayNum = ArrayMax = 0;
    }

    T *GetTypedData() { return (T *)AllocatorInstance.GetAllocation(); }
    const T *GetTypedData() const { return (T *)AllocatorInstance.GetAllocation(); }
    void *GetData() { return AllocatorInstance.GetAllocation(); }
    const void *GetData() const { return AllocatorInstance.GetAllocation(); }
    unsigned long GetTypeSize() const { return sizeof(T); }
    unsigned long GetAllocatedSize() const { return AllocatorInstance.GetAllocatedSize(ArrayMax, sizeof(T)); }
    int GetSlack() const { return ArrayMax - ArrayNum; }
    unsigned int IsValidIndex(int i) const { return i >= 0 && i < ArrayNum; }
    int Num() const { return ArrayNum; }
    T &operator()(int i) { return GetTypedData()[i]; }
    const T &operator()(int i) const { return GetTypedData()[i]; }
    T Pop()
    {
        T Result = GetTypedData()[ArrayNum - 1];
        Remove(ArrayNum - 1);
        return Result;
    }
    void Push(const T &Item) { AddItem(Item); }
    T &Top() { return Last(); }
    const T &Top() const { return Last(); }
    T &Last(int c = 0) { return GetTypedData()[ArrayNum - c - 1]; }
    const T &Last(int c = 0) const { return GetTypedData()[ArrayNum - c - 1]; }
    unsigned int FindItem(const T &Item, int &Index) const
    {
        const T *const Start = GetTypedData();
        for (const T *Data = Start, *DataEnd = Data + ArrayNum; Data < DataEnd; Data++)
        {
            if (*Data == Item)
            {
                Index = (int)(Data - Start);
                return 1;
            }
        }
        return 0;
    }
    int FindItemIndex(const T &Item) const
    {
        const T *const Start = GetTypedData();
        for (const T *Data = Start, *DataEnd = Data + ArrayNum; Data < DataEnd; Data++)
        {
            if (*Data == Item)
            {
                return (int)(Data - Start);
            }
        }
        return INDEX_NONE;
    }
    unsigned int ContainsItem(const T &Item) const { return FindItemIndex(Item) != INDEX_NONE; }

    int Add(int Count = 1)
    {
#line 858
        check(Count >= 0);
        const int OldNum = ArrayNum;
        if ((ArrayNum += Count) > ArrayMax)
        {
            ArrayMax = AllocatorInstance.CalculateSlack(ArrayNum, ArrayMax, sizeof(T));
            AllocatorInstance.ResizeAllocation(OldNum, ArrayMax, sizeof(T));
        }
        return OldNum;
    }
    void Remove(int Index, int Count = 1)
    {
#line 910
        check(Index >= 0);
        check(Index <= ArrayNum);
        check(Index + Count <= ArrayNum);
        DestructItems(Index, Count);
        const int NumToMove = ArrayNum - Index - Count;
        if (NumToMove)
        {
            appMemmove((unsigned char *)AllocatorInstance.GetAllocation() + Index * sizeof(T),
                       (unsigned char *)AllocatorInstance.GetAllocation() + (Index + Count) * sizeof(T),
                       NumToMove * sizeof(T));
        }
        ArrayNum -= Count;
        const int NewArrayMax = AllocatorInstance.CalculateSlack(ArrayNum, ArrayMax, sizeof(T));
        if (NewArrayMax != ArrayMax)
        {
            ArrayMax = NewArrayMax;
            AllocatorInstance.ResizeAllocation(ArrayNum, ArrayMax, sizeof(T));
        }
    }
    void RemoveSwap(int Index, int Count = 1)
    {
#line 941
        check(Index >= 0);
        check(Index <= ArrayNum);
        check(Index + Count <= ArrayNum);
        DestructItems(Index, Count);
        const int NumElementsInHole = Count;
        const int NumElementsAfterHole = ArrayNum - (Index + Count);
        const int NumElementsToMoveIntoHole = Min(NumElementsInHole, NumElementsAfterHole);
        if (NumElementsToMoveIntoHole)
        {
            appMemcpy((unsigned char *)AllocatorInstance.GetAllocation() + Index * sizeof(T),
                      (unsigned char *)AllocatorInstance.GetAllocation() + (ArrayNum - NumElementsToMoveIntoHole) * sizeof(T),
                      NumElementsToMoveIntoHole * sizeof(T));
        }
        ArrayNum -= Count;
        const int NewArrayMax = AllocatorInstance.CalculateSlack(ArrayNum, ArrayMax, sizeof(T));
        if (NewArrayMax != ArrayMax)
        {
            ArrayMax = NewArrayMax;
            AllocatorInstance.ResizeAllocation(ArrayNum, ArrayMax, sizeof(T));
        }
    }
    void Empty(int Slack = 0)
    {
        DestructItems(0, ArrayNum);
        ArrayNum = 0;
        if (ArrayMax != Slack)
        {
            ArrayMax = Slack;
            AllocatorInstance.ResizeAllocation(0, ArrayMax, sizeof(T));
        }
    }
    TArray &operator=(const TArray &Other)
    {
        Copy(Other);
        return *this;
    }
    int AddItem(const T &Item)
    {
        const int Index = Add(1);
        new (GetTypedData() + Index) T(Item);
        return Index;
    }
    int AddZeroed(int Count = 1)
    {
        const int Index = Add(Count);
        appMemzero(GetTypedData() + Index, Count * sizeof(T));
        return Index;
    }
    int AddUniqueItem(const T &Item)
    {
        for (int Index = 0; Index < ArrayNum; Index++)
        {
            if ((*this)(Index) == Item)
            {
                return Index;
            }
        }
        return AddItem(Item);
    }
    void Reserve(int Number)
    {
        if (Number > ArrayMax)
        {
            ArrayMax = Number;
            AllocatorInstance.ResizeAllocation(ArrayNum, ArrayMax, sizeof(T));
        }
    }
    void Reset(int NewSize = 0)
    {
        if (NewSize <= ArrayMax)
        {
            DestructItems(0, ArrayNum);
            ArrayNum = 0;
        }
        else
        {
            Empty(NewSize);
        }
    }
    template <class OtherAllocator> void Copy(const TArray<T, OtherAllocator> &Source)
    {
        if ((void *)this != (void *)&Source)
        {
            if (Source.ArrayNum > 0)
            {
                Empty(Source.ArrayNum);
                appMemcpy(GetData(), Source.GetData(), Source.ArrayNum * sizeof(T));
                ArrayNum = Source.ArrayNum;
            }
            else
            {
                Empty();
            }
        }
    }

    // declared for their decorated names; written when a caller needs them
    void Shrink();
    unsigned int operator==(const TArray &) const;
    unsigned int operator!=(const TArray &) const;
    void BulkSerialize(FArchive &, int);
    void CountBytes(FArchive &);
    void Insert(int, int);
    void InsertZeroed(int, int);
    int InsertItem(const T &, int);
    void SetNum(int);
    void Append(const TArray &);
    TArray &operator+=(const TArray &);
    void Init(const T &, int);
    void Init(int);
    int RemoveSingleItem(const T &);
    int RemoveItem(const T &);
    int RemoveSingleItemSwap(const T &);
    int RemoveItemSwap(const T &);
    void Swap(int, int);
    void SwapItems(int, int);

protected:
    // forced inline: retail inlines it into ~TArray even where that makes
    // ~TArray too big to inline (TArray<FString>)
    __forceinline void DestructItems(int Index, int Count)
    {
        T *Element = GetTypedData() + Index;
        for (int i = Count; i > 0; i--)
        {
            Element->~T();
            Element++;
        }
    }

    typename Allocator::ForAnyElementType AllocatorInstance;
    int ArrayNum;
    int ArrayMax;

    template <class, class> friend class TArray;
};

template <class T> class TArrayNoInit : public TArray<T, FDefaultAllocator>
{
public:
    TArrayNoInit() : TArray<T, FDefaultAllocator>(E_NoInit) {}
    TArrayNoInit &operator=(const TArrayNoInit &Other)
    {
        this->Copy(Other);
        return *this;
    }
    TArrayNoInit &operator=(const TArray<T, FDefaultAllocator> &Other)
    {
        this->Copy(Other);
        return *this;
    }
};

#else

class FHeapAllocator
{
public:
    class ForAnyElementType
    {
    public:
        hg::gptr<FScriptContainerElement> Data;
    };
};
class FDefaultAllocator : public FHeapAllocator
{
};

template <class T, class Allocator = FDefaultAllocator> class TArray
{
public:
    int Num() const { return ArrayNum; }
    typename Allocator::ForAnyElementType AllocatorInstance;
    hg::be<int> ArrayNum;
    hg::be<int> ArrayMax;
};
template <class T> class TArrayNoInit : public TArray<T, FDefaultAllocator>
{
};

#endif
