#include "..\..\..\header\header.hpp"

params ["_group","_mode","_params"];
_params params ["_directions","_nearEnemies"];

switch _mode do {
	case ("init"): {
		["Retreating",false,false,ACTIONS_LOG] call FUPS_fnc_log;

		private _currpos = getPosATL leader _group;

		private _escapeDir = _directions call FUPS_fnc_escapeDirection;
		private _escapePos = [_currpos,300,_escapeDir] call FUPS_fnc_relPos;
		_group setVariable ["FUPS_movePos",_escapePos];

		_group setVariable ["FUPS_taskState","flee"];
	};
	case ("flee"): {
		if (leader _group distance _pos < _group getVariable "FUPS_closeenough") then {
			if (count _nearEnemies == 0) then {
				_group setVariable ["FUPS_break",{true}];
			} else {
				_group setVariable ["FUPS_taskState","loop"];
			};
		};
	};
	case ("loop") : {
		private _escapeDir = _directions call FUPS_fnc_escapeDirection;
		private _escapePos = [_currpos,300,_escapeDir] call FUPS_fnc_relPos;
		_group setVariable ["FUPS_movePos",_escapePos];

		_group setVariable ["FUPS_taskState","flee"];
	};
};
