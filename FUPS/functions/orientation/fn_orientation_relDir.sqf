#include "macros.hpp"

params ["_group", "_target", "_orientation"];

private _v = vectorNormalized _orientation;
private _orientationDir = acos(_v select 1);
_orientationDir = [_orientationDir, 360 - _orientationDir] select (_v select 0 < 0); // get compass dir

private _groupDir = [getPosATL _target, getPosATL _group] call FUPS_fnc_getDir;

_orientationDir - _groupDir
