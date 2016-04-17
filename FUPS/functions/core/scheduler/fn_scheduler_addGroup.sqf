/*

	Adds a group to the scheduler.
	Scheduler will take care that only one group per frame is calculated.
	Added groups must be initialized for low level ai calulation.

	PARAMS:
		0 <GROUP>
			- group to be scheduled

	RETURN VALUE:
		NONE

	AUTHOR: [W] Fett_Li

*/

#include "macros.hpp"

params [["_group",grpNull,[grpNull]]];

[{
	params [["_group",grpNull,[grpNull]]];
	FUPS_scheduler_groupQueue pushbackUnique _group;

},[_group],true] call FUPS_fnc_scheduler_addOverheadFunction;

nil
