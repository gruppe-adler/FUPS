/*

	Postinit function to ai package.

	PARAMS:
		NONE

	RETURNS:
		NONE

	AUTHOR: [W] Fett_Li

*/

[FUPS_fnc_ai_overhead] call FUPS_fnc_scheduler_addOverheadFunction;
[FUPS_fnc_ai_calculateGroup] call FUPS_fnc_scheduler_addGroupScript;
