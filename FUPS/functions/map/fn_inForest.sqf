scopeName _fnc_scriptname;
private ["_trees"];

_trees = 0;
{
	if ((str _x) find ': t_' > -1) then {
		_trees = _trees + 1;
		if (_trees > 2) then {
			true breakOut _fnc_scriptname;
		};
	};
} count nearestObjects [param [0,objNull,[objNull]], [], 20];

false
