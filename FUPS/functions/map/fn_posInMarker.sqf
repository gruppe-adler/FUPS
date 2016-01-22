/*

	This function returns whtether given position is in given area.

	PARAMS:
		0 <ARRAY format AREA> - area to check
		1 <ARRAY format POSITION> - position

	RETURN:
		<BOOL> - true if position is in area to check

	AUTHOR: [W] Exolas

*/

#include "..\..\header\header.hpp"

params [["_area",AREA_VAL,[AREA_VAL]],["_pos",[0,0,0],[[]],[2,3]]];
if !AREA_VALID(_area) throw ILLEGALARGUMENTSEXCEPTION;
AREA_PARAMS(_area); // _origin, _mindist, _xAxis, _yAxis, _dir

private _relPos = _pos vectorDiff _origin;
private _relPosMagnitude = vectorMagnitude _relPos;
private _xMagnitude = vectorMagnitude _xAxis;
private _yMagnitude = vectorMagnitude _yAxis;
private _cosY = _yAxis vectorCos _relPos;
private _cosX = _xAxis vectorCos _relPos;

_projectionMagnitudeY = (_cosY * _relPosMagnitude);
_projectionMagnitudeX = (_cosX * _relPosMagnitude);

0 <= _projectionMagnitudeY && _projectionMagnitudeY <= _yMagnitude && 0 <= _projectionMagnitudeX && _projectionMagnitudeX <= _xMagnitude
