#include "macros.hpp"

params ["_group", ["_moveSpeed", ""], ["_moveBehaviour", ""], ["_onAct", {}], ["_args", []]];

if (_moveSpeed == "") then {
    _moveSpeed = _group getVariable "FUPS_orgSpeed";
};

if (_moveBehaviour == "") then {
    _moveBehaviour = _group getVariable "FUPS_orgMode";
};

(_group getVariable "FUPS_ai_moveQueue") pushBack [_group, _moveSpeed, _moveBehaviour, _onAct, _args];
