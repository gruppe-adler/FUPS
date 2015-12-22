#include "..\..\header\header.hpp"

params ["_group","_pos"];

private _data		= _group getVariable "FUPS_marker";
private _markerPos	= _data select 0;
private _yVector	= _data select 2;
private _xVector	= _data select 3;
private _markerDir	= _data select 4;

if ([_pos,_data] call FUPS_fnc_posInMarker) exitWith { _pos };

private _posDir		= acos (([0,1,0]) vectorCos (_pos vectorDiff _markerPos));
private _rotX		= [_markerPos,vectorMagnitude _xVector,90] call FUPS_fnc_relPos;
private _rotY		= [_markerPos,vectorMagnitude _yVector,0] call FUPS_fnc_relPos;
_pos				= [_markerPos,vectorMagnitude (_pos vectorDiff _markerPos),(_posDir - _markerDir)] call FUPS_fnc_relPos;

_pos set [0,((_rotX select 0) min (_pos select 0)) max (_markerPos select 0)];
_pos set [1,((_rotY select 1) min (_pos select 1)) max (_markerPos select 1)];

_posDir		= acos (([0,1,0]) vectorCos (_pos vectorDiff _markerPos));
[_markerPos,vectorMagnitude (_markerPos vectorDiff _pos),(_markerDir+_posDir)] call FUPS_fnc_relPos
