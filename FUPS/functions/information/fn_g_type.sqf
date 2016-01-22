/*

	This function gets the types of a group inside an array.

	PARAMS:
		0 <GROUP> - group to get the types from

	RETURN:
		<<SCALAR> ARRAY> - all type indexes

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]]];
if (isNull _group) throw NULLPOINTEREXCEPTION;

_group getVariable ["FUPS_g_type",([_group] call FUPS_fnc_g_type_init)];