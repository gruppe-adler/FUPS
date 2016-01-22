/*

    Initializes the type for an ai group.

    PARAMS:
   		0 <GROUP> - group to get the type of

    RETURN:
    	<SCALAR> - type of the group

    AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]]];
if (isNull _group) throw NULLPOINTEREXCEPTION;

private _units = units _group;
private _types = [_group] call FUPS_fnc_g_type_get;

private _type = -1;
if (count _types == 1) then { _type = _types select 0 };
_group setVariable ["FUPS_type",_type];

_type
