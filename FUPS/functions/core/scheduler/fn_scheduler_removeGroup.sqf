/*

	Removes a group from the scheduler.

	PARAMS:
		0 <GROUP>
			- group to be removed

	RETURN VALUE:
		NONE

	AUTHOR: [W] Fett_Li

*/

#include "macros.hpp"

params [["_group",grpNull,[grpNull]]];

[{
	params [["_group",grpNull,[grpNull]]];
	FUPS_scheduler_groupQueue deleteAt (FUPS_scheduler_groupQueue find _group);

},[_group],true] call FUPS_fnc_scheduler_addOverheadFunction;

nil
