private ["_directions","_lastindex","_element","_escapeDirection","_lowerBound"];

if (_this isEqualTo []) exitWith { random 360 };

_directions = _this;
_directions sort true;

_sum = 0;
{
    _sum = _sum + _x;
} forEach _directions;
_sum = _sum / count _directions;

(_sum + 180) % 360
