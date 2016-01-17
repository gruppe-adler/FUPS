#include "..\..\header\header.hpp"

params ["_data",["_invisible",true]];

_data params ["_markerPos","_mindist","_markerVector","_markerVector_1","_markerDir"];

_markerPos = _markerPos vectorAdd (_markerVector vectorMultiply 0.5) vectorAdd (_markerVector_1 vectorMultiply 0.5);

private _name = str random 999999;
while {markerType _name != ""} do { _name = str random 1000; };

private _marker = createMarker [_name,_markerPos];
if (_invisible) then {_marker setMarkerAlpha 0};
_marker setMarkerShape "RECTANGLE";
_marker setMarkerDir _markerDir;
_marker setMarkerSize [vectorMagnitude _markerVector / 2,vectorMagnitude _markerVector_1 / 2];
