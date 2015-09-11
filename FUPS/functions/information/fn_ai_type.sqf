/*

    Description: Returns a scalar representing the units type, ai groups can only have one type

    PARAMS:
    0 <GROUP> - group to get the the type of

    RETURNS:
    <SCALAR> - type of the ai group

    Author: [W] Fett_Li
*/

params ["_v"];
_v getVariable ["FUPS_ai_type",([_v] call FUPS_fnc_ai_type_init)];
