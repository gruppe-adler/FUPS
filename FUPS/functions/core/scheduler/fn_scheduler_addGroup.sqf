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

[{
	FUPS_scheduler_groupQueue pushbackUnique _this;

},_group,true] call FUPS_fnc_scheduler_addOverheadFunction;
