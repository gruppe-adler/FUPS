/*

	This function sets the center position to a group.

	PARAMS:
		0 <GROUP> - group to set the position to

	RETURN:
		<ARRAY> - containes center position and clockpulse when the pos was calculated

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]]];
if (isNull _group) throw NULLPOINTEREXCEPTION;

private _centerPos = [_group] call FUPS_fnc_g_centerPos_get;

_group setVariable ["FUPS_g_centerPos",[_centerPos,FUPS_oefClockPulse]];

[_centerPos,FUPS_oefClockPulse]
