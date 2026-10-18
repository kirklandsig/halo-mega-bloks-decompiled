// HaloRBTKamikaze and the little it needs, from the PDB (tools/pdbtype.py).
// The bases are opaque: only their size and their vtable pointer matter here.
#pragma once

class FName
{
public:
    int Index;
    int Number;
};

class UAnimNodeSlot;
class APawn;
class AActor;
class GripBlackboard;

#define GRIP_RESERVED_SLOT(n) virtual void ReservedSlot##n();

class GripVHeapObject
{
public:
    virtual ~GripVHeapObject();
};

class IGripBTInterface  // gripbtinterface.h
{
public:
    GRIP_RESERVED_SLOT(0) GRIP_RESERVED_SLOT(1) GRIP_RESERVED_SLOT(2) GRIP_RESERVED_SLOT(3)
    GRIP_RESERVED_SLOT(4) GRIP_RESERVED_SLOT(5) GRIP_RESERVED_SLOT(6) GRIP_RESERVED_SLOT(7)
    virtual GripBlackboard *GetBlackboardInternal();  // vtable 0x20

    template <class T> T *GetBlackboard() { return static_cast<T *>(GetBlackboardInternal()); }
};

class IGripRBTTreeListener
{
public:
    virtual void OnTreeEvent();
};

class GripBrain : public GripVHeapObject, public IGripBTInterface, public IGripRBTTreeListener  // size 0x9C
{
    char GripBrainData[0x90];
};

class ICCSMeatPuppet
{
public:
    virtual ~ICCSMeatPuppet();
    GRIP_RESERVED_SLOT(1) GRIP_RESERVED_SLOT(2) GRIP_RESERVED_SLOT(3) GRIP_RESERVED_SLOT(4)
    GRIP_RESERVED_SLOT(5) GRIP_RESERVED_SLOT(6) GRIP_RESERVED_SLOT(7) GRIP_RESERVED_SLOT(8)
    GRIP_RESERVED_SLOT(9) GRIP_RESERVED_SLOT(10) GRIP_RESERVED_SLOT(11) GRIP_RESERVED_SLOT(12)
    GRIP_RESERVED_SLOT(13) GRIP_RESERVED_SLOT(14) GRIP_RESERVED_SLOT(15) GRIP_RESERVED_SLOT(16)
    GRIP_RESERVED_SLOT(17) GRIP_RESERVED_SLOT(18) GRIP_RESERVED_SLOT(19) GRIP_RESERVED_SLOT(20)
    GRIP_RESERVED_SLOT(21) GRIP_RESERVED_SLOT(22) GRIP_RESERVED_SLOT(23) GRIP_RESERVED_SLOT(24)
    GRIP_RESERVED_SLOT(25) GRIP_RESERVED_SLOT(26) GRIP_RESERVED_SLOT(27) GRIP_RESERVED_SLOT(28)
    GRIP_RESERVED_SLOT(29) GRIP_RESERVED_SLOT(30) GRIP_RESERVED_SLOT(31) GRIP_RESERVED_SLOT(32)
    GRIP_RESERVED_SLOT(33) GRIP_RESERVED_SLOT(34) GRIP_RESERVED_SLOT(35) GRIP_RESERVED_SLOT(36)
    GRIP_RESERVED_SLOT(37) GRIP_RESERVED_SLOT(38) GRIP_RESERVED_SLOT(39) GRIP_RESERVED_SLOT(40)
    virtual UAnimNodeSlot *GetFullBodyAnimSlot();  // vtable 0xA4
};

class CCSBrain : public GripBrain  // size 0xFC
{
public:
    ICCSMeatPuppet *m_meatPuppet;  // 0x9C
};

struct CCSGameCharacter  // size 0x14
{
    APawn *m_pawn;
    AActor *m_actor;
    void *m_targetableComponent;
    bool m_targetableComponentCheck;
    int m_cachedTeamNum;
};

struct CCSCharacter  // ccscharacter.h
{
    CCSGameCharacter m_gameCharacter;
    static const CCSCharacter NONE;

    bool operator==(const CCSCharacter &Other) const
    {
        return m_gameCharacter.m_pawn == Other.m_gameCharacter.m_pawn
            && m_gameCharacter.m_actor == Other.m_gameCharacter.m_actor;
    }
};

struct CCSTarget  // size 0x64
{
    CCSCharacter character;
};

template <class T> class GripBBProperty  // size 0x20
{
    char GripBBMemberData[0x1C];

public:
    T m_value;
};

class GripBlackboard  // size 0x8C
{
    char GripBlackboardData[0x8C];
};

class CCSBlackboard : public GripBlackboard  // size 0x67C
{
public:
    CCSTarget *GetCurrentTarget();

    GripBBProperty<CCSTarget *> m_pHighestThreatTarget;  // 0x8C
    GripBBProperty<CCSTarget *> m_closestEnemy;  // 0xAC
    GripBBProperty<CCSTarget *> m_closestVisibleEnemy;  // 0xCC
    GripBBProperty<CCSTarget *> m_currentTarget;  // 0xEC
};

class GripRBTNode  // size 0x64, GripVHeapObject's vtable pointer at 0x0
{
public:
    enum EBTExecutionResult
    {
        ER_SUCCESS = 0,
        ER_FAILURE = 1,
        ER_INPROGRESS = 2,
        ER_INTERRUPTING = 3,
        ER_SUCCESSFULLY_INTERRUPTED = 4,
        ER_READY = 5,
        ER_NOT_READY = 6,
        ER_MAX = 7,
    };
    virtual ~GripRBTNode();

private:
    char GripRBTNodeData[0x60];
};

class GripRBTBehavior : public GripRBTNode  // size 0x64
{
};

class CCSRBTMoveTo : public GripRBTBehavior  // size 0xA4
{
public:
    CCSRBTMoveTo();
    virtual bool TestPreCondition(IGripBTInterface *pInterface);

protected:
    virtual EBTExecutionResult ExecutePreInternal(IGripBTInterface *pInterface, bool bFirstTime);

private:
    char CCSRBTMoveToData[0x40];
};

class HaloRBTKamikaze : public CCSRBTMoveTo  // size 0xD0
{
public:
    enum KamikazeState
    {
        Initialize = 0,
        Arming = 1,
        Chasing = 2,
        Detonating = 3,
    };

    HaloRBTKamikaze();
    virtual bool TestPreCondition(IGripBTInterface *pInterface);

    void SetDetonationDistance(float Distance) { m_detonationDistance = Distance; }
    void SetArmKamikazeAnimName(FName Name) { m_ArmKamikazeAnimName = Name; }
    void SetDetonateKamikazeAnimName(FName Name) { m_DetonateKamikazeAnimName = Name; }
    void SetBlendTimes(float BlendIn, float BlendOut) { m_BlendInTime = BlendIn; m_BlendOutTime = BlendOut; }

protected:
    virtual EBTExecutionResult ExecutePreInternal(IGripBTInterface *pInterface, bool bFirstTime);

private:
    int m_actionHandle;                     // 0xA4
    float m_detonationDistance;             // 0xA8
    KamikazeState m_kamikazeState;          // 0xAC
    UAnimNodeSlot *m_FullBodyAnimSlot;      // 0xB0
    FName m_ArmKamikazeAnimName;            // 0xB4
    FName m_DetonateKamikazeAnimName;       // 0xBC
    float m_BlendInTime;                    // 0xC4
    float m_BlendOutTime;                   // 0xC8
    CCSTarget *kamikazeTarget;              // 0xCC
};
