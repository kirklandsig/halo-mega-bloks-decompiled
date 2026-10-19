import gen_classes

# Expected text written from the retail disassembly of each thunk
# (ACCSController, Unity_HaloRBTKamikazeEtAl.cpp.obj).


def thunk(member, ret, args, parms=None):
    return '\n'.join(gen_classes.event_thunk('ACCSController', member, ret, args, f'UDKBASE_{member[5:]}',
                                             parms, parms is not None))


def test_event_thunk_without_parameters():
    # 0x8331D370: ProcessEvent(FindFunctionChecked(name, 0), NULL, NULL)
    assert thunk('eventCreateDebugVizComponent', 'void', []) == '\n'.join([
        'inline void ACCSController::eventCreateDebugVizComponent()',
        '{',
        '    ProcessEvent(FindFunctionChecked(UDKBASE_CreateDebugVizComponent, 0), 0, 0);',
        '}'])


def test_event_thunk_with_return_value():
    # 0x8331D7A0: ReturnValue cleared, the actor stored, ReturnValue loaded after the call
    assert thunk('eventCanFireAt', 'unsigned int', [('Target', 'AActor *')],
                 'CCSController_eventCanFireAt_Parms') == '\n'.join([
        'inline unsigned int ACCSController::eventCanFireAt(AActor *Target)',
        '{',
        '    CCSController_eventCanFireAt_Parms Parms(EC_EventParm);',
        '    Parms.ReturnValue = 0;',
        '    Parms.Target = Target;',
        '    ProcessEvent(FindFunctionChecked(UDKBASE_CanFireAt, 0), &Parms, 0);',
        '    return Parms.ReturnValue;',
        '}'])


def test_event_thunk_with_struct_and_out_parameter():
    # 0x8331D3D0: the FVector copied in by words, Distance in and back out
    assert thunk('eventFindNavMeshDistance', 'unsigned int', [('targetPos', 'FVector'), ('Distance', 'float &')],
                 'CCSController_eventFindNavMeshDistance_Parms') == '\n'.join([
        'inline unsigned int ACCSController::eventFindNavMeshDistance(FVector targetPos, float &Distance)',
        '{',
        '    CCSController_eventFindNavMeshDistance_Parms Parms(EC_EventParm);',
        '    Parms.ReturnValue = 0;',
        '    Parms.targetPos = targetPos;',
        '    Parms.Distance = Distance;',
        '    ProcessEvent(FindFunctionChecked(UDKBASE_FindNavMeshDistance, 0), &Parms, 0);',
        '    Distance = Parms.Distance;',
        '    return Parms.ReturnValue;',
        '}'])


def test_event_thunk_bool_parameter_sets_first_bitfield():
    # 0x8331D5B0: each UBOOL becomes (x != 0) & 0x80000000
    text = thunk('eventFireWeapon', 'unsigned int', [('charge', 'unsigned int')], 'CCSController_eventFireWeapon_Parms')
    assert '    Parms.charge = charge ? FIRST_BITFIELD : 0;' in text


def test_kind_of_rows():
    row = {'name': 'UCCSBTTree::GetPrivateStaticClassUCCSBTTree', 'symbol': ''}
    assert gen_classes.kind(row) == 'get'
    assert gen_classes.kind({'name': "UCCSBTTree::`scalar deleting destructor'", 'symbol': ''}) == 'sdd'
    assert gen_classes.kind({'name': 'UCCSBTTree::operator new', 'symbol': '??2UCCSBTTree@@SAPAXIPAW4EInternal@@@Z'}) == 'new'
    assert gen_classes.kind({'name': 'ACCSController::eventAimAt', 'symbol': ''}) == 'event'
    assert gen_classes.kind({'name': 'ACCSController::Tick', 'symbol': ''}) is None
