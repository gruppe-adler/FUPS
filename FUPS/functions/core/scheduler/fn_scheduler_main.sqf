/*

	Main scheduling function. Will be executed on each frame.
	Takes care of low level ai calcuation and calling overhead functions.
	Low level ai calculation will be done only once per frame.
	Internal use only.

	PARAMS:
		NONE

	RETURNS:
		NONE

	AUTHOR: [W] Fett_Li

*/

#include "macros.hpp"

scopeName "main";

private _group = grpNull;

// Skip null groups
while {isNull _group || {units _group isEqualTo []}} do {
	_group = FUPS_scheduler_groupQueue deleteAt 0;
};

// If _group isNil FUPS_scheduler_groupQueue must be empty
if (isNil "_group") exitWith {
	// Array assigning is no problem because of pointer usage
	FUPS_scheduler_groupQueue = FUPS_scheduler_enqueued;
	FUPS_scheduler_groupEnqueued = [];

	// Execute every overhead function inbetween group calculation
	{
		_x params ["_func","_args"];

		_args call _func;
	} forEach FUPS_scheduler_oefTopped;

	// Execute every overhead function that should be executed only once
	{
		_x params ["_func","_args"];

		_args call _func;
	} forEach FUPS_scheduler_oefToppedOnce;
	FUPS_scheduler_oefToppedOnce = [];
};

FUPS_scheduler_groupEnqueued pushBack _group;

// Check clockpulse of the group
private _clockPulse = _group getVariable ["FUPS_clockPulse", 1];
_group setVariable ["FUPS_clockPulse", _clockPulse + 1];

// Loop scripts backwards in order to exec higher priority first
for "_priority" from (count FUPS_scheduler_groupScripts - 1) to 0 do {

	private _priorityScripts = FUPS_scheduler_groupScripts select _priority;
	if (!isNil "_priorityScripts") then {
		// Execute scripts only that should be executed in this loop
		{ // forEach
			if (_clockPulse mod (_forEachIndex + 1) == 0) then {
				{
					private _carryOn = [_group] call _x;
					if (!_carryOn) then {
						breakOut "main";
					};
				} forEach _x;
			};
		} forEach _priorityScripts;
	};
};
