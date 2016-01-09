/*

    Description: Sets the patrol marker for a FUPS group

    PARAMS:
    0 <GROUP> - the group whose marker should be changed
    1 <STRING> - name of the new marker
    2 <BOOLEAN> - true to overwrite the original marker, too

    RETURN:
    -

    Author: [W] Fett_Li

*/

#include "..\header\header.hpp"

params [["_group",grpNull,[grpNull]],["_marker","",["",[]]]];

if (isNull _group || _marker == "") then {
	throw ILLEGALARGUMENTSECEPTION;
};

if (_marker isEqualType "") then {
	_marker = [_marker] call FUPS_fnc_markerData;
};

_group setVariable ["FUPS_marker",_marker];
