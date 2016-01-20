#include "..\..\header\header.hpp"

params ["_data","_pos"];

private _relPos = _pos vectorDiff AREA_ORIGIN(_data);
private _relPosMagnitude = vectorMagnitude _relPos;
private _xMagnitude = vectorMagnitude(AREA_XAXIS(_data));
private _yMagnitude = vectorMagnitude(AREA_YAXIS(_data));
private _cosY = AREA_YAXIS(_data) vectorCos _relPos;
private _cosX = AREA_XAXIS(_data) vectorCos _relPos;

_projectionMagnitudeY = (_cosY * _relPosMagnitude);
_projectionMagnitudeX = (_cosX * _relPosMagnitude);

0 <= _projectionMagnitudeY && _projectionMagnitudeY <= _yMagnitude && 0 <= _projectionMagnitudeX && _projectionMagnitudeX <= _xMagnitude
