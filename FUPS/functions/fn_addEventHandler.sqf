
/*

	This function adds an eventhandler to the given group.

	PARAMS:
		0 <GROUP> - the group to add the eventhandler to
		1 <STRING> - eventhandler type
		2 <CODE/STRING> - code upon event, _this select 0 will be the group
		3 <BOOL> - true when event should only trigger once
		4 <ARRAY> - parameters for the task (differ for different eventhandlers)
		5 <ANY> - parameters that will be available in the code (_this select 1)

	List of currently supported eventhandlers:
		- "onTask" - fires, when a specific task is chosen
			parameters: 0 <STRING> - the task on which the eventhandler should fire

	RETURN:
		nil

	AUTHOR: [W] Fett_Li

 */

params [["_grp",grpNull,[grpNull]],["_eh","",[""]],["_onAct",{},[{},""]],["_isDisposable",false,[false]],["_taskParams",[],[[]]],"_params"];

if (typeName _onAct == typeName "") then { _onAct = compile _onAct };

_eh = toLower _eh;
switch _eh do {
	case "ontask": {
		_taskParams params ["_task"];
		if (isNil "_task" || {!missionNamespace getVariable [_task + "_isTask",false]}) exitWith {
			["Error: task is not initialized"] call FUPS_fnc_log;
		};

		if (isNil {_grp getVariable "FUPS_onTaskEhs"}) then {
			_grp setVariable ["FUPS_onTaskEhs",[]];
		};

		private "_ehs";
		_ehs = _group getVariable "FUPS_onTaskEhs";
		_ehs pushBack [_task,_onAct,_isDisposable,_params];
	};
};
