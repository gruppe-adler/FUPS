params [["_grp",grpNull,[grpNull]],["_eh","",[""]],["_onAct",{},[{}]],["_isDisposable",false,[false]],["_params",[],[[]]]];

if (isNil "_grp" || isNil "_eh" || isNil "_onAct" || isNil "_params") exitWith {
	["Error: wrong params"] call FUPS_fnc_log;
};

switch _eh do {
	case "onTask": {
		_params params ["_task"];
		if (isNil "_task" || {!missionNamespace getVariable [_task + "_isTask",false]}) exitWith {
			["Error: task is not initialized"] call FUPS_fnc_log;
		};

		if (isNil {_grp getVariable "FUPS_onTaskEhs"}) then {
			_grp setVariable ["FUPS_onTaskEhs",[]];
		};

		private "_ehs";
		_ehs = _group getVariable "FUPS_onTaskEhs";
		_ehs pushBack [_task,_onAct,_isDisposable];
	};
};
