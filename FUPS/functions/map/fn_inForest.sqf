#include "..\..\header\header.hpp"

scopeName _fnc_scriptname;
params [["_pos",objNull,[objNull,[]]]];
if (_pos isEqualType [] && {count _pos > 3 || count _pos < 2}) exitWith {
	["Error: Bad formatted position",false,false,ERROR_LOG] call FUPS_fnc_log;
	false;
};

private _trees = 0;
{
	if ((str _x) find ': t_' > -1) then {
		_trees = _trees + 1;
		if (_trees > 2) then {
			true breakOut _fnc_scriptname;
		};
	};
} forEach nearestObjects [_pos,[],20];

false