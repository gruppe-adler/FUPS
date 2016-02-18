/*

	Will be executed on each frame. Calculates all FUPS groups frame by frame.
	After having calculated all groups it will do some overhead work.

	DON'T CALL THIS FUNCTION BY HAND AS IT WILL CLASH WITH NORMAL FUPS CALCULATION!

	PARAMS:
		-

	RETURN:
		-

	AUTHOR: [W] Fett_Li

*/

#include "..\header\header.hpp"

// clock pulse tracking
FUPS_oefIndex = FUPS_oefIndex + 1;
// Will be executed after all groups have been calculated
if (FUPS_oefIndex == count FUPS_oefGroups) exitWith
	FUPS_fnc_mainHandlerOverhead;

private _group = FUPS_oefGroups select FUPS_oefIndex;
if (isNull _group || units _group isEqualTo []) exitWith {
	FUPS_oefGroups_toDelete pushBack FUPS_oefIndex;
};

private _side = side _group;
private _sideIndex = FUPS_sideOrder find _side;
private _leader = leader _group;
private _members = units _group;
private _membersCount = count _members;
private _clockPulse = _group getVariable "FUPS_clockPulse";
private _clockPulse = _clockPulse + 1;
_group setVariable ["FUPS_clockPulse",_clockPulse];

// handle simulation
// --- ToDo: better caching
if !([_group] call (_group getVariable "FUPS_simulation")) exitWith {
	if (simulationEnabled _leader) then {[_group,false,true] call FUPS_fnc_simulation};
};
if !(simulationEnabled _leader) then {
	[_group,true,true] call FUPS_fnc_simulation;
};

// get moved distance
private _currpos = getPosATL _leader;
_currpos set [2,0];

// get the group damage
private _combatStrength = 1;
private _groupdamage = 0;
{
	_groupdamage = _groupdamage + damage _x;
} forEach _members;
_groupdamage = _groupdamage + ((_group getVariable "FUPS_members") - _membersCount);

if (_groupdamage == _membersCount) exitWith {
	FUPS_oefGroups_toDelete pushBack FUPS_oefIndex;
};

_combatStrength = 1 - (_groupdamage / _membersCount);
_gothit = _groupdamage > (_group getVariable "FUPS_lastDamage");

// get the situation
private _knowsAny = false;
private _targets = [];
private _directions = [];
private _enemies = [];
private _nearEnemies = [];
private _fears = [];
private _theyGotUs = false;
private _shareNow = FUPS_shareNow select _sideIndex;

// Get the current panic level
[_group] call FUPS_fnc_lowerPanic;
private _panic = _group getVariable ["FUPS_panic",0];

// Reveal all shared enemies
if (_group getVariable "FUPS_doSupport") then {
	{
		if (_leader distance leader _x < FUPS_shareDist) then {
			_group reveal [leader _x,3];
		};
	} forEach _shareNow;
};

private _askedForSupport = _group getVariable "FUPS_askedForSupport";
private _shareNext = FUPS_share select _sideIndex;
{ // foreach
	if !(isNull _x || units _x isEqualTo []) then {
		private _dist = _leader distance leader _x;

		// How much does this group know the other?
		private _maxKnowledge = 0;
		{ // foreach
			private _knows = _group knowsAbout _x;
			_maxKnowledge = _knows max _maxKnowledge;
		} forEach (units _x);

		// Check whether this group has been heared
		if (FUPS_hearing_enabled && _maxKnowledge <= 0) then {
			(_x getVariable ["FUPS_firedLast",[-1,0]]) params ["_firedAt","_soundDistance"];
			if (_firedAt + FUPS_cycleTime + 0.01 > time && _soundDistance <= _dist) then {
				private _reveal = linearConversion [_soundDistance / 2,_soundDistance,_dist,FUPS_hearing_shotRevealMax,FUPS_hearing_shotRevealMin,true];
				_group reveal [leader _x,_reveal];
				_maxKnowledge = _reveal;

				if (FUPS_targeting_enabled) then {
					[_group,_x,0.90] call FUPS_fnc_targeting_increaseThreshold;
				};
			};
		};

		// Check whether this group should be able to see the enemy group
		if (FUPS_targeting_enabled && _maxKnowledge < FUPS_knowsAboutThreshold) then {
			private _lookAt = vehicle selectRandom(units _x);
			private _lookFrom = vehicle selectRandom(units _group);

			private _chance = [_lookAt,_lookFrom] call FUPS_fnc_targeting_getChance;
			if (random 1 < _chance) then {
				_group reveal [_lookAt,FUPS_targeting_revealValue];
				_maxKnowledge = _maxKnowledge max FUPS_targeting_revealValue;
			};
		};

		// Even the groups enenmy knowledge
		{
			_group reveal [_x,_maxKnowledge];
		} forEach (units _x);

		// Do the actual "this group was spotted"-stuff
		if (_maxKnowledge >= FUPS_knowsAboutThreshold) then {
			_knowsAny = true;

			if (_dist < 150) then {_nearEnemies pushBack _x};

			_x setVariable ["FUPS_revealedAt",time];
			_enemies pushBack _x;
			if (_group getVariable "FUPS_doShare") then {
				_shareNext pushBack _x;
			};

			if !([3] isEqualTo ([_x] call FUPS_fnc_g_type)) then {
				_directions pushBack ([_currpos,getPosATL leader _x] call FUPS_fnc_getDir);
			};

			if ([_group,_x] call FUPS_fnc_isEffective) then {
				_targets pushBack _x;
			} else {
				if ([_group,_x] call FUPS_fnc_fears) then {
					_fears pushBack _x;

					// is this vehicle aimed at the group?
					{ // foreach
						private _v = vehicle _x;
						_theyGotUs = _theyGotUs || ({_v aimedAtTarget [_x] > 0.9} count _members > 0);
					} forEach (units _x);

					if (isNil {_x getVariable "FUPS_supportFor"}) then {
						_x setVariable ["FUPS_supportFor",[]];
					};

					if !(_x in _askedForSupport) then {
						(_x getVariable "FUPS_supportFor") pushBack _group;
						_askedForSupport pushBack _x;
					};
				};
			};
		};
		// --- ToDo: implement with new task system
		/* else { if (_maxKnowledge >= 0) then {
			// --- ToDo: reset patrol route
		}};*/
	} else {
		[["Error: group %1 is null or empty - looping enemies",_x],true,false,ERROR_LOG] call FUPS_fnc_log;
	};
} forEach (FUPS_enemies select _sideIndex);

{
	private _supportArray = _x getVariable "FUPS_supportFor";
	_supportArray deleteAt (_supportArray find _group);
	_askedForSupport deleteAt (_askedForSupport find _group);
} forEach (_askedForSupport - _fears);

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

// get situation variables
private _surrounded     = _directions call FUPS_fnc_isSurrounded;
private _headsdown      = !(_fears isEqualTo []);
private _unknowIncident = !_knowsAny && _gothit;
private _weakened       = _combatStrength < FUPS_damageToRetreat;

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

_group setVariable ["FUPS_gothit",_gothit];
_group setVariable ["FUPS_lastPos",_currpos];
_group setVariable ["FUPS_lastDamage",_groupdamage];
