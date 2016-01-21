/*

	This function will create a marker based on the given area data

	PARAMS:
		0 <ARRAY format AREA> - area to create the marker from
		@optional 1 <BOOL> default true - true, if marker should be invisible

	RETURN:
		nil

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_area",AREA_VAL,[AREA_VAL]],["_invisible",true,[false]]];
if !AREA_VALID(_area) throw ILLEGALARGUMENTSEXCEPTION;
AREA_PARAMS(_area); // _origin, _mindist, _xAxis, _yAxis, _dir

_origin = _origin vectorAdd (_xAxis vectorMultiply 0.5) vectorAdd (_yAxis vectorMultiply 0.5);

private _name = str random 999999;
while {markerType _name != ""} do { _name = str random 1000; };

private _marker = createMarker [_name,_origin];
if (_invisible) then {_marker setMarkerAlpha 0};
_marker setMarkerShape "RECTANGLE";
_marker setMarkerDir _dir;
_marker setMarkerSize [vectorMagnitude _xAxis / 2,vectorMagnitude _yAxis / 2];
