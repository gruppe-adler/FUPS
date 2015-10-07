params ["_group","_mode","_params"];
_params params ["_target"];

switch _mode do {
	case "init": {
		_group setBehaviour "AWARE";
		_group setSpeedMode "NORMAL";

		private ["_params","_areainfo","_combinedGroups","_targets"];
		_params = _group getVariable "FUPS_reinfInfo";
		_areainfo = _params select 0;
		_combinedGroups = _reinfParams select 2;
		_targets = _reinfParams select 3;

		{
			private "_sol";
			_sol = _x;
			{
				_sol reveal [_x,3];
			} forEach _targets;
		} forEach (units _group);

		private ["_center","_movePos","_dir","_relDist"];
		_center = (_areainfo select 0) vectorAdd ((_areainfo select 2) vectorMultiply 0.5) vectorAdd ((_areainfo select 3) vectorMultiply 0.5);
		_movePos = getPosATL leader _group;
		_dir = [_center,_movePos] call FUPS_fnc_getDir;
		_relDist = [_areainfo,_dir] call FUPS_fnc_recMarkerRad;
		if (count _combinedGroups == 0 AND _center distance _movePos > _relDist + 350) then {
			_movePos = [_center,_dir,_relDist + 300] call FUPS_fnc_relPos;
		};

		_group move _movePos;
		_group setVariable ["FUPS_movePos",_movePos];
		_group setVariable ["FUPS_taskState","move"];
	};
	case "move": {
		if (leader _group distance (_group getVariable "FUPS_movePos") < (_group getVariable "FUPS_closeenough")) then {
			_group setVariable ["FUPS_reinfReady",true];

			private "_combinedGroups";
			_combinedGroups = (_group getVariable "FUPS_reinfInfo") select 2;

			if ({!(_x getVariable ["FUPS_reinfReady",false])} count _combinedGroups == 0) then {
				_group setVariable ["FUPS_taskState","newwp"];
				_group setVariable ["FUPS_reinfInArea",time];
			};
		};
	};
	case "newwp": {
		private ["_areainfo","_wp"];
		_areainfo = (_group getVariable "FUPS_reinfInfo") select 2;
		_wp = [_group] call FUPS_fnc_generateWP;

		_group move _wp;
		_group setVariable ["FUPS_movePos",_wp];
		_group setVariable ["FUPS_taskState","patrol"];
	};
	case "patrol": {
		switch (true) do {
			case (!isNull _target): {
				_group setVariable ["FUPS_taskState","attack"];
			};
			case (time - (_group getVariable "FUPS_reinfInArea") > 900): {
				_group setVariable ["FUPS_break",{true}];
			};
			case (leader _group distance (_group getVariable "FUPS_movePos") < (_group getVariable "FUPS_closeenough")): {
				_group setVariable ["FUPS_taskState","newwp"];
			};
		};
	};
	case "attack": {
		// --- ToDo: force do and check function parameters
		[_group,"FUPS_fnc_attack",_target] call FUPS_fnc_do;
	};
};
