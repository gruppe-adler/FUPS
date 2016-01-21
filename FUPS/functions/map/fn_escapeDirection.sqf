/*

	This function calculates an escape direction based on enemy directions.
	The returned direction will be the median direction of two most appart enemies.

	PARAMS:
		_this <<SCALAR> ARRAY> - all directions of known enemies

	RETURN:
		<SCALAR> - best direction to escape

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

if (_this isEqualTo []) exitWith { random 360 };

private _directions = _this;
_directions sort true;

private _sum = 0;
{
    _sum = _sum + _x;
} forEach _directions;
_sum = _sum / count _directions;

(_sum + 180) % 360
