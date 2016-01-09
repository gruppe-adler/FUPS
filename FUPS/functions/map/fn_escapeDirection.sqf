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
