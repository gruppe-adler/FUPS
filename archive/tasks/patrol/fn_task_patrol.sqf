#include "..\..\..\header\header.hpp"

params ["_group","_mode"];

switch _mode do {
	case ("init"): {
		["Patroling",false,false,ACTIONS_LOG] call FUPS_fnc_log;

		_group setBehaviour (_group getVariable "FUPS_orgMode");
		_group setSpeedMode (_group getVariable "FUPS_orgSpeed");

		private _route = _group getVariable "FUPS_route";
		if (count _route > 0) then {
			private _index = _group getVariable "FUPS_routeIndex";
			private _wp = _route select _index;
			_index = _wp select 1;
			if (_index == -1) then {
				_group setVariable ["FUPS_route",[]];
			};
			_group setVariable ["FUPS_routeIndex",_index];

			_group move (_wp select 0);
			_group setVariable ["FUPS_movePos",_wp select 0];
		}
		else {
			private _pos = [_group] call FUPS_fnc_generateWP;
			_group setVariable ["FUPS_movePos",_pos];
			_group move _pos;
		};
		_group setVariable ["FUPS_taskState","patrol"];
	};
	case ("patrol"): {

		private _pos = _group getVariable "FUPS_movePos";
		if (leader _group distance _pos < (_group getVariable "FUPS_closeenough")) then {
			if (_group getVariable "FUPS_wait") then {
				_group setVariable ["FUPS_patrolWait",time + 60];
				_group setVariable ["FUPS_taskState","wait"];
			} else {
				_group setVariable ["FUPS_taskState","init"];
			};
		};
	};
	case ("wait"): {
		if (time > _group getVariable "FUPS_patrolWait") then {
			_group setVariable ["FUPS_taskState","init"];
		};
	};
};
