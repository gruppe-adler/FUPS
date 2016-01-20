#include "..\..\header\header.hpp"

params ["_group","_pos"];

private _data = _group getVariable "FUPS_marker";
private _markerOrigin = AREA_ORIGIN(_data);
private _xVector	= AREA_XAXIS(_data);
private _yVector	= AREA_YAXIS(_data);
private _markerDir	= AREA_DIR(_data);

if ([_pos,_data] call FUPS_fnc_posInMarker) exitWith { _pos };

private _posDir		= acos (([0,1,0]) vectorCos (_pos vectorDiff _markerOrigin));
private _rotX		= [_markerOrigin,vectorMagnitude _xVector,90] call FUPS_fnc_relPos;
private _rotY		= [_markerOrigin,vectorMagnitude _yVector,0] call FUPS_fnc_relPos;
_pos				= [_markerOrigin,vectorMagnitude (_pos vectorDiff _markerOrigin),(_posDir - _markerDir)] call FUPS_fnc_relPos;

_pos set [0,((_rotX select 0) min (_pos select 0)) max (_markerOrigin select 0)];
_pos set [1,((_rotY select 1) min (_pos select 1)) max (_markerOrigin select 1)];

_posDir		= acos (([0,1,0]) vectorCos (_pos vectorDiff _markerOrigin));
[_markerOrigin,vectorMagnitude (_markerOrigin vectorDiff _pos),(_markerDir+_posDir)] call FUPS_fnc_relPos
