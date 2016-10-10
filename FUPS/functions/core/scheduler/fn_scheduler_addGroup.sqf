/*

	Adds a group to the scheduler.
	Scheduler will take care that only one group per frame is calculated.
	Added groups must be initialized for low level ai calulation.

	PARAMS:
		0 <GROUP>
			- group to be scheduled

	RETURNS:
		NONE

	AUTHOR: [W] Fett_Li

*/

#include "macros.hpp"

params [["_group",grpNull,[grpNull]]];

if (FUPS_scheduler_oefID == -1) then {
	FUPS_scheduler_oefID = [FUPS_fnc_scheduler_main,0,[]] call CBA_fnc_addPerFrameHandler;
};

_group setVariable ["FUPS_clockPulse", 1];
_group setVariable ["FUPS_tickTime", time];
_group setVariable ["FUPS_tickDiff", 0];

{
	[_group] call _x;
} forEach FUPS_scheduler_initScripts;

[{
	FUPS_scheduler_groupQueue pushbackUnique _this;
},_group,true] call FUPS_fnc_scheduler_addOverheadFunction;
