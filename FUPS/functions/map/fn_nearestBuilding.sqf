/*

	This function return all near buildings within given searchdistance of searchpos.

	PARAMS:
		0 <OBJECT/ARRAY format POSITION> - search position
		1 <SCALAR> - search distance

	RETURN:
		<OBJECT> - nearest building

	ATUHOR: [W] Fett_Li

*/

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
