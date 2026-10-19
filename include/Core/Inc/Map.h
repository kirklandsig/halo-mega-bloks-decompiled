// The parts of UE3's TSet and TMap (Set.h, Map.h) that inline into game code:
// TMap::Set, which builds an FPairInitializer and adds it to the pair set.
// Include it after a generated header that declares FName. The set's storage
// is opaque (TSparseArray, the hash) and its Add is called out of line.
#pragma once

class FSetElementId
{
public:
    FSetElementId() : Index(-1) {}
    int Index;
};

template <class T> struct TMapConstInitType
{
    typedef const T &Type;
};
template <class T> struct TMapConstInitType<T *>
{
    typedef T *Type;
};

template <class ElementType, class KeyFuncs, class Allocator> class TSet
{
public:
    template <class InitType> FSetElementId Add(const InitType &InElement, unsigned int *bIsAlreadyInSetPtr = 0);

private:
    unsigned int SetData[0xF];
};

template <class KeyType, class ValueType, int bInAllowDuplicateKeys, class SetAllocator> class TMapBase
{
public:
    class FPair;
    struct KeyFuncs;
    class FPairInitializer
    {
    public:
        FPairInitializer(typename TMapConstInitType<KeyType>::Type InKey, typename TMapConstInitType<ValueType>::Type InValue)
            : Key(InKey), Value(InValue)
        {
        }
        typename TMapConstInitType<KeyType>::Type Key;
        typename TMapConstInitType<ValueType>::Type Value;
    };

    // Retail's Set returns the added value; nothing here reads it.
    void Set(typename TMapConstInitType<KeyType>::Type InKey, typename TMapConstInitType<ValueType>::Type InValue)
    {
        const FSetElementId PairId = Pairs.Add(FPairInitializer(InKey, InValue));
        (void)PairId;
    }

protected:
    TSet<FPair, KeyFuncs, SetAllocator> Pairs;
};

template <class KeyType, class ValueType, int bInAllowDuplicateKeys, class SetAllocator> class TSortableMapBase
    : public TMapBase<KeyType, ValueType, bInAllowDuplicateKeys, SetAllocator>
{
};

template <class KeyType, class ValueType, class SetAllocator> class TMap : public TSortableMapBase<KeyType, ValueType, 0, SetAllocator>
{
};
