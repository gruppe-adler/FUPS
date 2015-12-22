/*

    Description: Checks whether the ai fears the group. A group fears antoher when the group has weapons against the ai

    PARAMS:
    0 <GROUP> - ai group
    1 <GROUP> - enemy group

    RETURN:
    <BOOLEAN> - does ai fear the group?

    Author: [W] Fett_Li

*/
#include "..\..\header\header.hpp"

params ["_ai","_group"];

private _ai_type = [_ai] call FUPS_fnc_ai_type;
if (_ai_type == -1) exitWith {false};

private _g_weapons = [_group] call FUPS_fnc_g_weapons;

_g_weapons select _ai_type
