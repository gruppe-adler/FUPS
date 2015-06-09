scopeName "FUPS_fnc_inForest";
private ["_inForest","_trees"];

_inForest	= false;
_trees		= 0;
{
	if ((str _x) find ': t_' > -1) then {
			_trees = _trees + 1;
			if (_trees > 2) then {
				_inForest = true;
				breakTo "FUPS_fnc_inForest";
			};
	};
} count nearestObjects [(_this select 0), [], 20];

_inForest