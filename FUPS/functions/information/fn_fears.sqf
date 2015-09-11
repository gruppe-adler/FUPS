/*

    Description: Checks whether the ai fears the group. A group fears antoher when the group has weapons against the ai

    PARAMS:
    0 <GROUP> - ai group
    1 <GROUP> - enemy group

    RETURN:
    <BOOLEAN> - does ai fear the group?

    Author: [W] Fett_Li

*/

params ["_ai"];
private ["_ai_type","_g_weapons"];
_ai_type = [_ai] call FUPS_fnc_ai_type;
_group = _this select 1;
_g_weapons = [_group] call FUPS_fnc_g_weapons;

_g_weapons select _ai_type
