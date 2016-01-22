/*

	Calculates the type of a vehicle based on an index.
		0 - Man
		1 - Land Vehicle
		2 - Air
		3 - Ship

	PARAMS:
		0 <OBJECT> - object to get the type from

	RETURN:
		<SCALAR> - type index

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_v",objNull,[objNull]]];
if (isNull _group) throw NULLPOINTEREXCEPTION;

_v getVariable ["FUPS_type",([_v] call FUPS_fnc_v_type_init)];