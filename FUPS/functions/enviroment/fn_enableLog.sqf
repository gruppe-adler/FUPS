#include "..\..\header\header.hpp"

params [["_levels",[],[[]]],["_enable",true,[true]]];

{
	if (_x isEqualType 0 && _x >= 0) then {
		FUPS_logLevels set [_x,_enable];
	};
} forEach _levels;
