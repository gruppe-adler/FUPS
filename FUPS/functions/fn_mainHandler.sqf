
/*

	Will be executed on each frame. Calculates all FUPS groups frame by frame.
	After having calculated all groups it will do some overhead work.

	DON'T CALL THIS FUNCTION BY HAND AS IT WILL CLASH WITH NORMAL FUPS CALCULATION!

	PARAMS:
		-

	RETURN:
		-

	Author: [W] Fett_Li

*/

// clock pulse tracking
FUPS_oefIndex = FUPS_oefIndex + 1;
// Will be executed after all groups have been calculated
if (FUPS_oefIndex == count FUPS_oefGroups) exitWith
	FUPS_fnc_mainHandlerOverhead;

private ["_group","_side","_sideIndex","_leader","_members","_clockPulse"];
_group = FUPS_oefGroups select FUPS_oefIndex;
_side = side _group;
_sideIndex = FUPS_sideOrder find _side;
_leader = leader _group;
_members = units _group;
_membersCount = count _members;
_clockPulse = _group getVariable "FUPS_clockPulse";
_clockPulse = _clockPulse + 1;
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
private ["_currpos","_centerpos"];
_currpos = getPosATL _leader;
_currpos set [2,0];
_centerpos = [_group] call FUPS_fnc_g_centerPos;

// get the group damage
private ["_combatStrength","_groupdamage"];
_combatStrength = 1;
_groupdamage = 0;
{
	_groupdamage = _groupdamage + damage _x;
} forEach _members;
_groupdamage = _groupdamage + ((_group getVariable ["FUPS_members",count _members]) - (count _members));

if (_groupdamage == _membersCount) exitWith {
	FUPS_oefGroups_toDelete pushBack FUPS_oefIndex;
};

_combatStrength = 1 - (_groupdamage / _membersCount);
_gothit = _groupdamage > (_group getVariable "FUPS_lastDamage");

// get the situation
private ["_knowsAny","_targets","_directions","_enemies","_nearEnemies","_fears","_theyGotUs","_shareNow","_panic"];
_knowsAny = false;
_targets = [];
_directions = [];
_enemies = [];
_nearEnemies = [];
_fears = [];
_theyGotUs = false;
_shareNow = FUPS_shareNow select _sideIndex;

// Get the current panic level
[_group] call FUPS_fnc_lowerPanic;
_panic = _group getVariable ["FUPS_panic",0];

// Reveal all shared enemies
if (_group getVariable "FUPS_doSupport") then {
	{
		if (_leader distance leader _x < FUPS_shareDist) then {
			{_group reveal [_x,3]} forEach (units _x);
		};
	} forEach _shareNow;
};

private ["_askedForSupport","_shareNext"];
_askedForSupport = _group getVariable "FUPS_askedForSupport";
_shareNext = FUPS_share select _sideIndex;
{ // foreach
	private "_dist";
	_dist = _leader distance leader _x;

	// Check whether this group has been heared
	(_x getVariable ["FUPS_firedLast",[-1,0]]) params ["_firedAt","_soundDuration"];
	if (_firedAt + FUPS_cycleTime + 0.01 > time && _soundDuration * FUPS_speedOfSound <= _dist) then {
		// --- ToDo: reveal
	};

	private "_knowsGroup";
	_knowsGroup = { // foreach
		//_knowsGroup = (_leader targetKnowledge _x) select 1;
		if (_group knowsAbout _x > FUPS_knowsAboutThreshold) exitWith {true};
		false
	} forEach (units _x);

	if (_knowsGroup) then {
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
					private "_v";
					_v = vehicle _x;
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
} forEach (FUPS_enemies select _sideIndex);

{
	private "_supportArray";
	_supportArray = _x getVariable "FUPS_supportFor";
	_supportArray deleteAt (_supportArray find _group);
	_askedForSupport deleteAt (_askedForSupport find _group);
} forEach (_askedForSupport - _fears);

// re-evaluate current target
private ["_target_val","_target_dist"];
_target = _group getVariable "FUPS_target";
_target_val = 0;
_target_dist = 10000;
if !(isNull _target) then {
	_target_val = count (_target getVariable ["FUPS_supportFor",[]]);
	_target_dist = _leader distance leader _target;
};

private ["_nearestTarget","_nearestTarget_dist","_nearestTarget_val","_mostDangerousTarget","_mostDangerousTarget_val","_mostDangerousTarget_dist"];
_nearestTarget = grpNull;
_nearestTarget_dist = 10000;
_nearestTarget_val = 10000;
_mostDangerousTarget = grpNull;
_mostDangerousTarget_val = 0;
_mostDangerousTarget_dist = 10000;
{ // foreach
	private ["_dist","_val"];
	_dist = _leader distance leader _x;
	_val = count (_x getVariable ["FUPS_supportFor",[]]);

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
private "_target";
_target = _nearestTarget;
if (_mostDangerousTarget_dist - _nearestTarget_dist < 150) then {
	_target = _mostDangerousTarget;
};
_group setVariable ["FUPS_target",_target];

// get situation variables
private ["_surrounded","_headsdown","_unknowIncident","_weakened"];
_surrounded     = _directions call FUPS_fnc_isSurrounded;
_headsdown      = !(_fears isEqualTo []);
_unknowIncident = !_knowsAny && _gothit;
_weakened       = _combatStrength < FUPS_damageToRetreat;

private "_task";
_task = _group getVariable "FUPS_task";
switch (true) do {
	case ((surfaceIsWater _currpos) && !(_group getVariable "FUPS_allowWater")): {
		// Group is in water

		_group setVariable ["FUPS_task","FUPS_fnc_getOutOfWater"];
		_group setVariable ["FUPS_taskState","init"];
	};
	case (call (_group getVariable "FUPS_break") || (_group getVariable "FUPS_task" == "")): {
		// New task

		[["Breaking the task with:
			_gothit := %1
			_weakened := %2
			_surrounded := %3
			_headsdown := %4
			_unknowIncident := %5
			_theyGotUs := %6
			_knowsAny := %7",_gothit,_weakened,_surrounded,_headsdown,_unknowIncident,_theyGotUs,_knowsAny]] call FUPS_fnc_log;

		// get current task
		private "_tasks";
		_tasks = [];
		if (_gothit && _targets isEqualTo [] || !(_enemies isEqualTo []) || _unknowIncident) then {
			_tasks pushBack "FUPS_fnc_task_hold";
		};
		if (!isNull _target) then {
			_tasks pushBack "FUPS_fnc_task_attack";
		};
		if (!(_fears isEqualTo []) || _weakened || (_groupdamage > (2 * _lastdamage)) || ((_groupdamage - _lastdamage) > 1.5)) then {
			_tasks pushBack "FUPS_fnc_task_retreat";
		};
		[_tasks,false] call FUPS_fnc_log;

		private "_highestPriority";
		_highestPriority = 0;
		_task = "FUPS_fnc_task_patrol";

		{
			private ["_taskName","_prior"];
			_taskName = _x;
			_prior = call (missionnamespace getVariable [(_taskName + "_prior"),{-10}]);
			[["%1 has the priority %2, %3",_taskName,_prior,_prior > _highestPriority]] call FUPS_fnc_log;
			if (_prior > _highestPriority) then {
				_task = _taskName;
				[["Task is now %1",_task]] call FUPS_fnc_log;
				_highestPriority = _prior;
			};
		} forEach _tasks;

		// Exectuing given orders
		private "_orders";
		_orders = _group getVariable "FUPS_orders";
		if (count _orders > 0) then {
			(_orders select 0) params ["_order","_force"];
			if (_force || _task == "FUPS_fnc_task_patrol") then {
				_task = _order;
				_orders deleteAt 0;
			};
		};

		_group setVariable ["FUPS_break",missionnamespace getVariable [(_task + "_break"),{true}]];

		_group setVariable ["FUPS_task",_task];
		_group setVariable ["FUPS_taskState","init"];

		private ["_onTaskEhs","_disposedEhs"];
		_onTaskEhs = _group getvariable "FUPS_onTaskEhs";
		_disposedEhs = [];
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
	};
};

private "_params";
_params = [_group,_group getVariable "FUPS_taskState"];
_params pushBack (0 call (missionnamespace getVariable (_task + "_params")));

// get the "right" task for the groups type, if it is defined
private "_typeName";
_typeName = _group getVariable "FUPS_typeName";
if !(isNil {missionnamespace getVariable (_task + _typeName)}) then {
	_task = _task + _typeName;
};

private "_skipActionChance";
_skipActionChance = 0;
if (_panic >= FUPS_panic_isPanickedThreshold) then {
	_skipActionChance = FUPS_panic_skipAction_panicked;
} else { if (_panic >= FUPS_panic_isNervousThreshold) then {
	_skipActionChance = FUPS_panic_skipAction_nervous;
}};

if (random 1 < 1 - _skipActionChance) then {
	_params call (missionnamespace getVariable _task);
};

_group setVariable ["FUPS_gothit",_gothit];
_group setVariable ["FUPS_lastPos",_currpos];
_group setVariable ["FUPS_lastDamage",_groupdamage];
