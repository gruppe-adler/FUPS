/*

	This function returns whether given position is in given area.

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

// ToDo: test this function and utilize whether it's more efficient

private _a = _xAxis vectorMultiply 0.5;
private _b = _yAxis vectorMultiply 0.5;
_pos inArea [
	_origin vectorAdd _a vectorAdd _b,
	vectorMagnitude _a,
	vectorMagnitude _b,
	acos ([0,1,0] vectorDir _xAxis),
	true
];
