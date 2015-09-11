/*

    Description: Initializes the type for an ai group

    PARAMS:
    0 <GROUP> - group to get the type of

    RETURN:
    <SCALAR> - type of the group

    Author: [W] Fett_Li

*/

params ["_group"];
private ["_units","_types"];
_units = units _group;
_types = [_group] call FUPS_fnc_g_type_get;

private "_type";
_type = -1;
if (count _types == 1) then { _type = _types select 0 };
_group setVariable ["FUPS_type",_type];

_type
