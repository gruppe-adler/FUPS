/*

	Returns the weapons of the object.

	PARAMS:
		0 <OBJECT> - object to get the weapons from

	RETURN:
		<<BOOL> ARRAY> - array of booleans, matching type indexes with true or false

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_v",objNull,[objNull]]];
if (isNull _group) throw NULLPOINTEREXCEPTION;

_v getVariable ["FUPS_v_weapons",([_v] call FUPS_fnc_v_weapons_init)];
