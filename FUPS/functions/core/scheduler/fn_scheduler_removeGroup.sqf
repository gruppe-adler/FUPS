/*

	Removes a group from the scheduler.

	PARAMS:
		0 <GROUP>
			- group to be removed

	RETURNS:
		NONE

	AUTHOR: [W] Fett_Li

*/

#include "macros.hpp"

params [["_group",grpNull,[grpNull]]];

[{
	FUPS_scheduler_groupQueue deleteAt (FUPS_scheduler_groupQueue find _this);

},_group,true] call FUPS_fnc_scheduler_addOverheadFunction;

nil
