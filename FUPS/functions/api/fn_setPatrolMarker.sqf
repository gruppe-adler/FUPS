/*

    Sets the patrol marker for a FUPS group

    PARAMS:
    0 <GROUP> - the group whose marker should be changed
    1 <STRING> - name of the new marker

    RETURN:
    -

    Author: [W] Fett_Li

*/

params [["_group",grpNull,[grpNull]],["_marker","",["",[]],5]];
if (_group == grpNull || _marker == "" || (_marker isEqualType [] && !(_marker isEqualTypeParams [[],0,[],[],0]))) exitWith {};

if (_marker isEqualType "") then {
	_marker = [_marker] call FUPS_fnc_markerData;
};

_group setVariable ["FUPS_marker",_marker];
