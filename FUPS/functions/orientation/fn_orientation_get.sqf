#include "macros.hpp"

params [["_group", grpNull, [grpNull]]];

private _array = _group getVariable ["FUPS_orientation_queue", []];
private _length = count _array;
if (_length < 2) exitWith { [0,1,0] };

private _basePos = _array select 0;
private _diffs = _array apply { _x vectorDiff _basePos };
_diffs deleteAt 0; // this is _basePos vectorDiff _basePos and therefore unnecessary

private _ret = [0,0,0];
{
	_ret = _ret vectorAdd _x;
} forEach _diffs;

_ret apply { _x / (_length - 1) }
