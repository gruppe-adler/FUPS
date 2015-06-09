private ["_group","_marker"];
_group = [_this,0,grpNull,[grpNull]] call BIS_fnc_param;
_marker = [_this,1,"",[[],""],5] call BIS_fnc_param;
_setOrg = [_this,2,false,[true]] call BIS_fnc_param;

_data = if (typename _marker == typename []) then { _marker } else { [_marker] call FUPS_fnc_markerData };

_group setVariable ["FUPS_marker",_data];
if (_setOrg) then {_group setVariable ["FUPS_orgMarker",_data]};
