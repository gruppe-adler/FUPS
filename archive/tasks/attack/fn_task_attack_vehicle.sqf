#include "..\..\..\header\header.hpp"

params ["_group","_mode","_params"];
_params params ["_target"];

switch _mode do {
	case ("init"): {
		["Attacking",false,false,ACTIONS_LOG] call FUPS_fnc_log;

		_group setBehaviour "COMBAT";
		_group setSpeedMode "FULL";

		private _targetPos = (leader _group targetKnowledge leader _target) select 6;

		{_x doWatch _targetPos} forEach (units _group);

		if (_currpos distance leader _target > 500) then { // enemy far enough away to flank
			private _dir = [_currpos,_targetPos] call FUPS_fnc_getDir;
			_dir = if (random 1 < 0.5) then {_dir + 90} else {_dir - 90};
			private _pos = [_targetPos,500,_dir] call FUPS_fnc_relPos;
			_pos = (selectbestPlaces [_pos,50,"meadow + trees - forest + hills - houses",5,1]) select 0 select 0;

			_group move _pos;

			_group setVariable ["FUPS_movePos",_pos];
		} else {
			// do not flank, so set this to nil
			_group setVariable ["FUPS_movePos",nil];
		};
		_group setVariable ["FUPS_taskState","flank"];
	};
	case ("flank"): {
		if (_currpos distance (_group getVariable ["FUPS_movePos",_currpos]) < (_group getVariable "FUPS_closeenough")) then {
			private _targetPos = (leader _group targetKnowledge leader _target) select 6;

			private _pos = (selectbestPlaces [_currpos,50,"meadow + trees - forest + hills - houses",5,1]) select 0 select 0;

			_group move _pos;

			{_x doWatch _targetPos} forEach (units _group);

			_group setVariable ["FUPS_taskState","fight"];
		};
	};
	case ("fight"): {
		if ({alive _x} count units _target == 0 || time - FUPS_timeOnTarget > (_target getVariable ["FUPS_revealedAt",0])) then {
			_group setVariable ["FUPS_task",""];
		};
	};
};
