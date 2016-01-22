/*

	Returns the groups center position. Will be calculated only one time per FUPS_oefClockPulse for performance reasons.

	PARAMS:
		0 <GROUP> - group to get the center position from

	RETURN:
		<ARRAY format POSITION> - center position

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]]];
if (isNull _group) throw NULLPOINTEREXCEPTION;

private _centerData = _group getVariable ["FUPS_g_centerPos",([_group] call FUPS_fnc_g_centerPos_init)];

_centerData params ["_pos","_clockPulse"];
if (_clockPulse != FUPS_oefClockPulse || !(vehicle leader _group isKindOf "Man")) then {
	_centerData = [_group] call FUPS_fnc_g_centerPos_init;
};

_centerData select 0
