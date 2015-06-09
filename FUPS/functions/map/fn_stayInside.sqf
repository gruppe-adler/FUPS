private ["_group","_pos"];
_group = _this select 0;
_pos = _this select 1;

private ["_data","_markerPos","_yVector","_xVector","_markerDir"];
_data		= _group getVariable "FUPS_marker";
_markerPos	= _data select 0;
_yVector	= _data select 2;
_xVector	= _data select 3;
_markerDir	= _data select 4;

if ([_pos,_data] call FUPS_fnc_posInMarker) exitWith { _pos };

_posDir		= acos (([0,1,0]) vectorCos (_pos vectorDiff _markerPos));
_rotX		= [_markerPos,vectorMagnitude _xVector,90] call FUPS_fnc_relPos;
_rotY		= [_markerPos,vectorMagnitude _yVector,0] call FUPS_fnc_relPos;
_pos		= [_markerPos,vectorMagnitude (_pos vectorDiff _markerPos),(_posDir - _markerDir)] call FUPS_fnc_relPos;

_pos set [0,((_rotX select 0) min (_pos select 0)) max (_markerPos select 0)];
_pos set [1,((_rotY select 1) min (_pos select 1)) max (_markerPos select 1)];

_posDir		= acos (([0,1,0]) vectorCos (_pos vectorDiff _markerPos));
[_markerPos,vectorMagnitude (_markerPos vectorDiff _pos),(_markerDir+_posDir)] call FUPS_fnc_relPos
