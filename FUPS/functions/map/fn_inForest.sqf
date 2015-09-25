scopeName _fnc_scriptname;
params [["_pos",objNull,[objNull,[]]]];
private ["_trees"];

_trees = 0;
{
	if ((str _x) find ': t_' > -1) then {
		_trees = _trees + 1;
		if (_trees > 2) then {
			true breakOut _fnc_scriptname;
		};
	};
} count nearestObjects [_pos,[],20];

false
