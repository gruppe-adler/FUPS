/*

	Calculates the low level ai for a group.
	Group must be initialized with FUPS.

	PARAMS:
		0 <GROUP> - group to be calculated

	RETURNS:
		NONE

	AUTHOR: [W] Fett_Li

*/

#include "macros.hpp"

params ["_group"];

private _side = side _group;
private _sideIndex = FUPS_sideOrder find _side;
private _leader = leader _group;
private _members = units _group;
private _membersCount = count _members;

// get moved distance
private _currpos = getPosATL _leader;
_currpos set [2,0];

// re-evaluate current target
private _target = _group getVariable "FUPS_target";
private _target_val = 0;
private _target_dist = 10000;
if !(isNull _target) then {
	_target_val = count (_target getVariable ["FUPS_supportFor",[]]);
	_target_dist = _leader distance leader _target;
};

private _nearestTarget = grpNull;
private _nearestTarget_dist = 10000;
private _nearestTarget_val = 10000;
private _mostDangerousTarget = grpNull;
private _mostDangerousTarget_val = 0;
private _mostDangerousTarget_dist = 10000;
{ // foreach
	private _dist = _leader distance leader _x;
	private _val = count (_x getVariable ["FUPS_supportFor",[]]);

	// nearest Target
	if (_dist < _nearestTarget_dist) then {
		_nearestTarget = _x;
		_nearestTarget_dist = _dist;
		_nearestTarget_val = _val;
	};

	// most dangerous Target
	if (_val > _mostDangerousTarget_val) then {
		_mostDangerousTarget = _x;
		_mostDangerousTarget_val = _val;
		_mostDangerousTarget_dist = _dist;
	} else {
		if (_val == _mostDangerousTarget_val && _dist < _mostDangerousTarget_dist) then {
			_mostDangerousTarget = _x;
			_mostDangerousTarget_val = _val;
			_mostDangerousTarget_dist = _dist;
		};
	};
} forEach _targets;

// get the target
_target = _nearestTarget;
if (_mostDangerousTarget_dist - _nearestTarget_dist < 150) then {
	_target = _mostDangerousTarget;
};
_group setVariable ["FUPS_target",_target];

private _task			= "";
private _curTask		= _group getVariable "FUPS_task";
private _tasks			= [];
private _patrolling		= _curTask == "FUPS_fnc_task_patrol";
private _orders			= _group getVariable "FUPS_orders";

// The group got into water and isn't allowed to be there
if ((surfaceIsWater _currpos) && !(_group getVariable "FUPS_allowWater")) then {
	// Group is in water
	_task = "FUPS_fnc_getOutOfWater";

// An order was forced
} else { if ({_x select 1} count _orders > 0) then {
	{
		_x params ["_order","_force"];
		if (_force) exitWith {
			_task = _order;
			_orders deleteAt _forEachIndex;
		};
	} forEach _orders;

// An order was queued
} else { if (_patrolling && {!(_orders isEqualTo [])}) then {
	(_orders select 0) params ["_order",""];
	_task = _order;
	_orders deleteAt 0;

// The current task gets canceled
} else { if (call (_group getVariable "FUPS_break")) then {
	// New task
	[["Breaking the task with:
		_gothit := %1
		_weakened := %2
		_surrounded := %3
		_headsdown := %4
		_unknowIncident := %5
		_theyGotUs := %6
		_knowsAny := %7",_gothit,_weakened,_surrounded,_headsdown,_unknowIncident,_theyGotUs,_knowsAny],true,false,STATS_LOG] call FUPS_fnc_log;

	// Get available tasks
	if (_gothit && _targets isEqualTo [] || !(_enemies isEqualTo []) || _unknowIncident) then {
		_tasks pushBack "FUPS_fnc_task_hold";
	};
	if (!isNull _target) then {
		_tasks pushBack "FUPS_fnc_task_attack";
	};
	if (!(_fears isEqualTo []) || _weakened || (_groupdamage > (2 * _lastdamage)) || ((_groupdamage - _lastdamage) > 1.5)) then {
		_tasks pushBack "FUPS_fnc_task_retreat";
	};
	[_tasks,false,false,ACTIONS_LOG] call FUPS_fnc_log;

	private _highestPriority = 0;
	_task = "FUPS_fnc_task_patrol";

	{
		private _taskName = _x;
		private _prior = call (missionnamespace getVariable [(_taskName + "_prior"),{-10}]);
		[["%1 has the priority %2, %3",_taskName,_prior,_prior > _highestPriority],true,false,STATS_LOG] call FUPS_fnc_log;
		if (_prior > _highestPriority) then {
			_task = _taskName;
			[["Task is now %1",_task],true,false,STATS_LOG] call FUPS_fnc_log;
			_highestPriority = _prior;
		};
	} forEach _tasks;
}}}};

// The task was changed
if (_task != "") then {
	_group setVariable ["FUPS_break",missionnamespace getVariable [(_task + "_break"),{true}]];
	_group setVariable ["FUPS_task",_task];
	_group setVariable ["FUPS_taskState","init"];

	private _onTaskEhs = _group getvariable "FUPS_onTaskEhs";
	private _disposedEhs = [];
	{
		_x params ["_ehTask","_onAct","_isDisposable","_params"];
		if (_ehTask == _task) then {
			[_group,_params] call _onAct;
			if (_isDisposable) then {
				_disposedEhs = [_forEachIndex] append _disposedEhs;
			};
		};
	} forEach _onTaskEhs;

	{
		_onTaskEhs deleteAt _x;
	} forEach _disposedEhs;

// Tha task wasn't changed, stick to the old one
} else {
	_task = _curTask;
};

private _params = [_group,_group getVariable "FUPS_taskState"];
_params pushBack call (missionnamespace getVariable (_task + "_params"));

// get the "right" task for the groups type, if it is defined
private _typeName = _group getVariable ["FUPS_typeName",""];
if (!(_typeName isEqualType "") || {_typeName == ""}) then {
	["Error: FUPS_typeName was nil or of wrong type",false,true,ERROR_LOG] call FUPS_fnc_log;
} else {
	if !(isNil {missionnamespace getVariable (_task + _typeName)}) then {
		_task = _task + _typeName;
	};
};

private _skipActionChance = 0;
if (_panic >= FUPS_panic_isPanickedThreshold) then {
	_skipActionChance = FUPS_panic_skipAction_panicked;
} else { if (_panic >= FUPS_panic_isNervousThreshold) then {
	_skipActionChance = FUPS_panic_skipAction_nervous;
}};

if (random 1 < (1 - _skipActionChance)) then {
	_params call (missionnamespace getVariable _task);
};

_group setVariable ["FUPS_lastPos",_currpos];
