/*

	Calculates the efficiency of a group against types. Type idnexes match true/false - efficient/not efficient.

	PARAMS:
		0 <GROUP> - group to get the weapons from

	RETURN:
		<<BOOL> ARRAY> - weapons of the group

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]]];
if (isNull _group) throw NULLPOINTEREXCEPTION;

_group getVariable ["FUPS_weapons",([_group] call FUPS_fnc_g_weapons_init)];
