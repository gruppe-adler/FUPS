#include "..\..\header\header.hpp"

scopeName _fnc_scriptname;
params [["_pos",objNull,[objNull,[]],[2,3]]];

private _trees = 0;
private _nearObjects = nearestObjects [_pos,[],20];
{
	if ((str _x) find ': t_' > -1) then {
		_trees = _trees + 1;
		if (_trees > 2) then {
			true breakOut _fnc_scriptname;
		};
	};
} forEach _nearObjects;

false
