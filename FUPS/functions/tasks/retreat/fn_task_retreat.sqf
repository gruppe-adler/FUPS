private ["_group","_directions","_nearEnemies"];
_group = _this select 0;
_directions = _this select 2;
_nearEnemies = _this select 3;

switch (_this select 1) do {
	case ("init"): {
		["Retreating"] call FUPS_fnc_log;

		private "_currpos";
		_currpos = getPosATL leader _group;

		private ["_escapeDir","_escapePos"];
		_escapeDir = _directions call FUPS_fnc_escapeDirection;
		_escapePos = [_currpos,300,_escapeDir] call FUPS_fnc_relPos;
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
		private ["_escapeDir","_escapePos"];
		_escapeDir = _directions call FUPS_fnc_escapeDirection;
		_escapePos = [_currpos,300,_escapeDir] call FUPS_fnc_relPos;
		_group setVariable ["FUPS_movePos",_escapePos];

		_group setVariable ["FUPS_taskState","flee"];
	};
};
