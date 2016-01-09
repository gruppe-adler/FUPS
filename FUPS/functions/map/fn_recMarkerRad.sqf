#include "..\..\header\header.hpp"

params ["_data","_angle"];

private _yVec = (_data select 2) vectorMultiply 0.5;
private _xVec = (_data select 3) vectorMultiply 0.5;
private _dir = _data select 4;

_yVec = _yVec vectorMultiply (cos (_angle - _dir));
_xVec = _xVec vectorMultiply (sin (_angle - _dir));

vectorMagnitude (_yVec vectorAdd _xVec)