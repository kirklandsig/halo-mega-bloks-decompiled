// @object Unity_UDKWeaponEtAl.cpp.obj
// n-Space's additions to UDK's udkplayercontroller.cpp: a navigation-mesh
// path for script, and the AI director's alert check.
#include "UDKBase/Inc/UDKBaseClasses.h"

// @retail 0x8339DF28
unsigned int AUDKPlayerController::FindPath(const FVector Destination, TArray<FVector> &PathPoints)
{
    unsigned int bFound = 0;
    if (Pawn)
    {
        for (int i = 0; i < Pawn->Components.Num(); i++)
        {
            // Cast<UGwNavBotHandle>, inlined here
            UActorComponent *Component = Pawn->Components(i);
            if (Component && Component->IsA(UGwNavBotHandle::StaticClass()))
            {
                UGwNavBotHandle *Handle = (UGwNavBotHandle *)Component;
                Kaim::Bot *Bot = Handle->BotPointer->m_kaimbot;
                if (Bot)
                {
                    Kaim::Ptr<Kaim::AStarQuery<Kaim::DefaultTraverseLogic> > Query = *new Kaim::AStarQuery<Kaim::DefaultTraverseLogic>;
                    Query->BindToDatabase(Bot->m_database);
                    if (Query != 0 && Query->m_inQueueStatus != Kaim::QueryPushedAsCommand)
                    {
                        Kaim::Vec3f Start = UnrealToGwNavVector(Pawn->Location);
                        Kaim::Vec3f Dest = UnrealToGwNavVector(Destination);
                        Query->Initialize(Start, Dest);
                        Query->PerformQueryBlocking(0);
                        if (Query->m_result == Kaim::ASTAR_DONE_PATH_FOUND)
                        {
                            Kaim::Path *Path = Query->m_path;
                            for (unsigned int j = 0; j < Path->m_nodesCount; j++)
                            {
                                PathPoints.AddItem(GwNavToUnrealVector(Path->m_nodePositions[j]));
                            }
                            bFound = 1;
                        }
                    }
                }
                break;
            }
        }
    }
    return bFound;
}

// @retail 0x83384390
unsigned int AUDKPlayerController::IsAlertedEnemyInRange(float Range)
{
    if (Pawn == 0)
    {
        return 0;
    }
    return CCSNorman::getInstance()->IsAlertedEnemyInRange(Pawn, Range);
}
