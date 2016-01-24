/*

	Sets the patrol marker for a FUPS group

	PARAMS:
		0 <GROUP> - the group whose marker should be changed
		1 <STRING> - name of the new marker

	RETURN:
		nil

	Author: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]],["_marker","",["",[]]]];
if (_group == grpNull || _marker isEqualTo "" || (_marker isEqualType [] && {!AREA_VALID(_marker)})) exitWith {};

if (_marker isEqualType "") then {
	_marker = [_marker] call FUPS_fnc_markerData;
};

_group setVariable ["FUPS_marker",_marker];
