/*

	Postinit function to ai package.

	PARAMS:
		NONE

	RETURNS:
		NONE

	AUTHOR: [W] Fett_Li

*/

[FUPS_fnc_ai_overhead] call FUPS_fnc_scheduler_addOverheadFunction;

[FUPS_fnc_ai_initGroup] call FUPS_fnc_scheduler_addInitScript;

[FUPS_fnc_ai_updateStatus, 1, 2] call FUPS_fnc_scheduler_addGroupScript;
[FUPS_fnc_ai_scanEnemies, 1, 2] call FUPS_fnc_scheduler_addGroupScript;
[FUPS_fnc_ai_calculateGroup, 1, 3] call FUPS_fnc_scheduler_addGroupScript;
