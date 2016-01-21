#include "..\..\header\header.hpp"

params [["_searchPos",objNull,[objNull,[]],[2,3]],["_searchDistance",0,[0]]];

private _building = objNull;
private _minDist = _searchDistance;
private _buildings = _searchPos nearObjects ["Building",_searchDistance];
{
	private _dist = _x distance _searchPos;
	if (_dist < _minDist) then {
		_building = _x;
		_minDist = _dist;
	};
} forEach _buildings;

_building
