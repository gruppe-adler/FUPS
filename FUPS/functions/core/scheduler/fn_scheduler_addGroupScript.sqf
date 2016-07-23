/*

	Adds a script to be calculated for each group.
	Arguments passed to the script will be: [_group]

	PARAMS:
		0 <CODE/STRING>
			- Script to be executed. If string, it will then be compiled.
		1 <SCALAR> @optional default: 1
			- Integer number symbolizing the cycle size. For example: value of 2 would lead to the script being calculated every 2 loops.
		2 <SCALAR> @optional default: 0
			- Priority of the script. The script will be executed before each script that has a lower priority.

	RETURNS:
		True iff adding was successful. False otherwise.

	AUTHOR: [W] Fett_Li

*/

#include "macros.hpp"

params [["_script",{},[{},""]],["_cycle",1,[0]],["_prior",0,[0]]];

if (_cycle < 1) exitWith {false};

if (_script isEqualType "") then {
	_script = compile _script;
};

if (_script isEqualTo {}) exitWith {false};

private _priorityScripts = [FUPS_scheduler_groupScripts,_prior,[]] call FUPS_fnc_selectOrEnlarge;
private _cycleScripts = [_priorityScripts,_cycle - 1,[]] call FUPS_fnc_selectOrEnlarge;

_cycleScripts pushBack _script;

true
