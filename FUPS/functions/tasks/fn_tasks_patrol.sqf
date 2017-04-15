
#include "macros.hpp"

params ["_group"];

if (_group getVariable "FUPS_patrolling") exitWith {};
_group setVariable ["FUPS_patrolling", true];

[_group] call FUPS_fnc_ai_clearWp;
private _p = [_group] call FUPS_fnc_generateWp;
[_p, "", "", {_this setVariable ["FUPS_patrolling", false]}, _group] call FUPS_fnc_ai_addWp;
