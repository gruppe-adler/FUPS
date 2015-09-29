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

params ["_group","_marker",["_setOrg",false]];

_data = if (typename _marker == typename []) then { _marker } else { [_marker] call FUPS_fnc_markerData };

_group setVariable ["FUPS_marker",_data];
if (_setOrg) then {_group setVariable ["FUPS_orgMarker",_data]};
