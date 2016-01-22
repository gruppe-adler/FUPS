/*

    Returns a scalar representing the units type, ai groups can only have one type.

    PARAMS:
    	0 <GROUP> - group to get the the type of

    RETURN:
    	<SCALAR> - type of the ai group

    AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]]];
if (isNull _group) throw NULLPOINTEREXCEPTION;

_group getVariable ["FUPS_ai_type",([_group] call FUPS_fnc_ai_type_init)];
