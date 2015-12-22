#include "..\..\header\header.hpp"

params ["_searchPos","_searchDistance"];

private _building = objNull;
private _buildings = _searchPos nearObjects ["Building",_searchDistance];
if !(_buildings isEqualTo []) then {
	_building = objNull;
	private _minDist = 0;
	{
		private _dist = _x distance _searchPos;
		if (_dist < _minDist) then {
			_building = _x;
			_minDist = _dist;
		};
	} forEach _buildings;
};

_building