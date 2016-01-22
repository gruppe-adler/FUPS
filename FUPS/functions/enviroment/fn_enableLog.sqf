/*

	Enables/disables logs of given log-levels.

	PARAMS:
		0 <<SCALAR> ARRAY> - all log levels to set
		@optional 1 <BOOL> default true - enable/disable logs for levels

	RETURN:
		nil

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_levels",[],[[]]],["_enable",true,[true]]];

{
	if (_x isEqualType 0 && _x >= 0) then {
		FUPS_logLevels set [_x,_enable];
	};
} forEach _levels;
