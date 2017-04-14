#include "..\..\..\header\header.hpp"

params ["_group","_mode","_params"];
_params params ["_target"];

switch _mode do {
	case ("init"): {
		["Attacking",false,false,ACTIONS_LOG] call FUPS_fnc_log;

		_group setBehaviour "AWARE";
		_group setSpeedMode "FULL";

		private _targetPos = (leader _group targetKnowledge leader _target) select 6;

		// let all units watch into the enemy direction
		{ _x doWatch _targetPos } forEach (units _group);

		// get safepos in the vicinity, if hit
		private _pos = [];
		private _build = [_currpos,20] call FUPS_fnc_nearestBuilding;
		private _inBuilding = false;
		if !(isNull _build) then {
			_inBuilding = [_group,_build] call FUPS_fnc_useBuilding;
		};

		if (_inBuilding) then {
			_pos = getPosATL _build;
		} else {
			_pos = (selectBestPlaces [_currpos,20,"hills + forest + trees - meadow",5,1]) select 0 select 0;
			_group move _pos;
		};

		_group setVariable ["FUPS_movePos",_pos];
		if (leader _group distance leader _target < 100) then {
			// skip flanking, etc. when enemy is too close
			_group setVariable ["FUPS_taskState","flank"];
		} else {
			_group setVariable ["FUPS_taskState","evase"];
		};
	};
	case ("evase"): {
		if (_currpos distance (_group getVariable ["FUPS_movePos",_currpos]) < (_group getVariable "FUPS_closeenough")) then {
			// --- ToDo: only sortie if not to far away? And: what to do, if group is that far away?

			// position calculation
			private _targetPos = (leader _group targetKnowledge leader _target) select 6;

			private _dir = [_currpos,_targetPos] call FUPS_fnc_getDir;
			_dir = if (random 1 < .5) then {_dir + 90} else {_dir - 90};
			private _dist = ((_currpos distance _targetPos) * 2 / 3) min 200;
			private _pos = [_currpos,_dist * 2 / 3,_dir] call FUPS_fnc_relPos;

			_group move _pos;

			_group setVariable ["FUPS_movePos",_pos];
			_group setVariable ["FUPS_taskState","flank"];
		};
	};
	case ("flank"): {
		// evasing finished?
		if (_currpos distance (_group getVariable ["FUPS_movePos",_currpos]) < (_group getVariable "FUPS_closeenough")) then {
			// go to flanking position
			private _targetPos = (leader _group targetKnowledge leader _target) select 6;

			private _dist = if ([_targetPos] call FUPS_fnc_inTown) then {100} else {200};
			private _dir = [_currpos,_targetPos] call FUPS_fnc_getDir;

			_pos = [_targetPos,_dist,_dir] call FUPS_fnc_relPos;
			if (_nofollow) then {_pos = [_group,_pos] call FUPS_fnc_stayInside};

			_group move _pos;

			_group setVariable ["FUPS_movePos",_pos];
			_group setVariable ["FUPS_taskState","attack"];
		};
	};
	case ("attack"): {
		_group setBehaviour "COMBAT";

		// flanking finished?
		if (_currpos distance (_group getVariable ["FUPS_movePos",_currpos]) < (_group getVariable "FUPS_closeenough")) then {
			{ _x doWatch (leader _target) } forEach (units _group);

			private _build = [getPosATL leader _group,20] call FUPS_fnc_nearestBuilding;
			if !(isNull _build) then {[_group,_build] call FUPS_fnc_useBuilding};

			_group setVariable ["FUPS_movePos",nil];
			_group setVariable ["FUPS_taskState","fight"];
		};
	};
	case ("fight"): {
		if ({alive _x} count units _target == 0 || time - FUPS_timeOnTarget > (_target getVariable ["FUPS_revealedAt",0])) then {
			_group setVariable ["FUPS_task",""];
		};
	};
};
