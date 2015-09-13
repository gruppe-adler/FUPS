/*

    Description: This file will order any group to exectue given order

    PARAMS:

    RETURN:

    Author: [W] Fett_Li

*/

params ["_grp","_task",["_force",false],["_params",[]]];

if (isNil "_grp" || isNil "_task" || {!isNil _task || !(missionNamespace getVariable [_task + "_isTask",false])}) exitWith {
	["Error: wrong params given"] call FUPS_fnc_log;
};

if (_force) then {
	private "_orders";
	_orders = [_task,_force] append (_grp getVariable "FUPS_orders");
	_grp setVariable ["FUPS_orders",_orders];

	_grp setVariable ["FUPS_break",{true}];
} else {
	(_grp getVariable "FUPS_orders") pushBack [_task,_force];
};
