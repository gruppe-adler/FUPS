/*

	This function sets the groups types.

	PARAMS:
		0 <GROUP> - group to set to

	RETURN:
		<<SCALAR> ARRAY> - groups type indexes

	ATUHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]]];
if (isNull _group) throw NULLPOINTEREXCEPTION;

private _types = [_group] call FUPS_fnc_g_type_get;

_group setVariable ["FUPS_g_type",_types];

_types
