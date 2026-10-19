// The vector constants UE3's Xenon math headers define in every unity object
// (unmathvectorconstants.h, unmathxe.h, unmath.h), each initialised at
// startup by its own dynamic initializer.
#pragma once
#include <vectorintrinsics.h>

typedef __vector4 VectorRegister;

inline VectorRegister MakeVectorRegister(float X, float Y, float Z, float W)
{
    VectorRegister Vec;
    Vec.x = X;
    Vec.y = Y;
    Vec.z = Z;
    Vec.w = W;
    return Vec;
}

inline VectorRegister MakeVectorRegister(unsigned long X, unsigned long Y, unsigned long Z, unsigned long W)
{
    union
    {
        VectorRegister V;
        unsigned long U[4];
    } Tmp;
    Tmp.U[0] = X;
    Tmp.U[1] = Y;
    Tmp.U[2] = Z;
    Tmp.U[3] = W;
    return Tmp.V;
}

#define DELTA 0.00001f

namespace GlobalVectorConstants
{
static const VectorRegister Float0001 = MakeVectorRegister(0.0f, 0.0f, 0.0f, 1.0f);
static const VectorRegister SmallLengthThreshold = MakeVectorRegister(1.e-8f, 1.e-8f, 1.e-8f, 1.e-8f);
static const VectorRegister FloatOneHundredth = MakeVectorRegister(0.01f, 0.01f, 0.01f, 0.01f);
static const VectorRegister Float111_Minus1 = MakeVectorRegister(1.f, 1.f, 1.f, -1.f);
static const VectorRegister FloatOneHalf = MakeVectorRegister(0.5f, 0.5f, 0.5f, 0.5f);
static const VectorRegister QINV_SIGN_MASK = MakeVectorRegister(-1.f, -1.f, -1.f, 1.f);
static const VectorRegister QMULTI_SIGN_MASK0 = MakeVectorRegister(1.f, -1.f, 1.f, -1.f);
static const VectorRegister QMULTI_SIGN_MASK1 = MakeVectorRegister(1.f, 1.f, -1.f, -1.f);
static const VectorRegister QMULTI_SIGN_MASK2 = MakeVectorRegister(-1.f, 1.f, 1.f, -1.f);
}

static const VectorRegister XBOXALTIVEC_ONE = MakeVectorRegister(1.0f, 1.0f, 1.0f, 1.0f);
static const VectorRegister XBOXALTIVEC_SELECT_MASK = MakeVectorRegister(0x00000000ul, 0x00000000ul, 0x00000000ul, 0xFFFFFFFFul);
static const VectorRegister XBOXALTIVEC_SWIZZLE_MASK_UNPACK = MakeVectorRegister(0x1F1F1F0Cul, 0x1F1F1F0Dul, 0x1F1F1F0Eul, 0x1F1F1F0Ful);
static const VectorRegister XBOXALTIVEC_SWIZZLE_MASK_UNPACK_REVERSE = MakeVectorRegister(0x1F1F1F0Ful, 0x1F1F1F0Eul, 0x1F1F1F0Dul, 0x1F1F1F0Cul);

namespace GlobalVectorConstants
{
static const VectorRegister AnimWeightThreshold = MakeVectorRegister(0.00001f, 0.00001f, 0.00001f, 0.00001f);
static const VectorRegister RotationSignificantThreshold = MakeVectorRegister(1.0f - DELTA * DELTA, 1.0f - DELTA * DELTA, 1.0f - DELTA * DELTA, 1.0f - DELTA * DELTA);
}
