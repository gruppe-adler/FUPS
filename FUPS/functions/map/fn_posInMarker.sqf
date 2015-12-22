#include "..\..\header\header.hpp"

params ["_data","_pos"];

// --- ToDo: set proper backup data for _data

private _center	= (_data select 0) vectorAdd ((_data select 2) vectorMultiply 0.5) vectorAdd ((_data select 3) vectorMultiply 0.5);
private _angle = [_center,_pos] call FUPS_fnc_getDir;

_rad = [_data,_angle] call FUPS_fnc_recMarkerRad;

_pos distance _center <= _rad
