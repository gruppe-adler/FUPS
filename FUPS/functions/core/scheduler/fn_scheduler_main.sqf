/*

	Main scheduling function. Will be executed on each frame.
	Takes care of low level ai calcuation and calling overhead functions.
	Low level ai calculation will be done only once per frame.
	Internal use only.

	PARAMS:
		NONE

	RETURN VALUE:
		NONE

	AUTHOR: [W] Fett_Li

*/

#include "macros.hpp"

private _group = grpNull;

// Skip null groups
while {isNull _group} do {
	_group = FUPS_scheduler_groupQueue deleteAt 0;
};

// Since _group isNil FUPS_scheduler_groupQueue must be empty
if (isNil "_group") exitWith {
	// Array assigning is no problem because if pointer usage
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

[_group] call FUPS_fnc_ai_calculateGroup; // ToDo
