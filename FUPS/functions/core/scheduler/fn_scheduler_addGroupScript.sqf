/*

	Adds a script to be calculated for each group.
	Arguments passed to the script will be: [_group]

	PARAMS:
		0 <CODE/STRING>
			- Script to be executed. If string, it will then be compiled.
		1 <SCALAR>
			- Integer number symbolizing the cycle size. For example: value of 2 would lead to the script being calculated every 2 loops.

	RETURNS:
		True iff adding was successful. False otherwise.

	AUTHOR: [W] Fett_Li

*/

params [["_script",{},[{},""]],["_cycle",1,[0]]];

if (_cycle < 1) exitWith {false};

if (_script isEqualType "") then {
	_script = compile _script;
};

if (_script isEqualTo {}) exitWith {false};

if (count FUPS_scheduler_groupScripts < _cycle) then {
	FUPS_scheduler_groupScripts resize _cycle;
};

private _cycleScripts = FUPS_scheduler_groupScripts select (_cycle - 1);
if (isNil "_cycleScripts") then {
	FUPS_scheduler_groupScripts set [_cycle - 1,[]];
	_cycleScripts = FUPS_scheduler_groupScripts select (_cycle - 1);
};

_cycleScripts pushBack _script;

true
