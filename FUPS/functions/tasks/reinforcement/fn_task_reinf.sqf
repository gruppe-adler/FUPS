#include "..\..\..\header\header.hpp"

params ["_group","_mode","_params"];
_params params ["_target"];

switch _mode do {
	case "init": {
        ["Reinforcing",false,false,ACTIONS_LOG] call FUPS_fnc_log;

		_group setBehaviour "AWARE";
		_group setSpeedMode "NORMAL";

		_params = _group getVariable "FUPS_reinfInfo";
		_params params ["_areainfo","_stayInArea","_combinedGroups","_targets"];
		AREA_PARAMS(_areainfo); // _origin, _mindist, _xAxis, _yAxis, _dir

		if (_stayInArea) then {
			[_group,_areainfo] call FUPS_fnc_setPatrolMarker;
		};

		{
			_group reveal [_x,3];
		} forEach _targets;

		private _center = _center vectorAdd (_xAxis vectorMultiply 0.5) vectorAdd (_yAxis vectorMultiply 0.5);
		private _movePos = getPosATL leader _group;
		private _dir = [_center,_movePos] call FUPS_fnc_getDir;
		private _relDist = [_areainfo,_dir] call FUPS_fnc_recMarkerRad;
		if (_center distance _movePos > _relDist + 350) then {
			_movePos = [_center,_dir,_relDist + 300] call FUPS_fnc_relPos;
		};

		_group move _movePos;
		_group setVariable ["FUPS_movePos",_movePos];
		_group setVariable ["FUPS_taskState","move"];
	};
	case "move": {
		if (leader _group distance (_group getVariable "FUPS_movePos") < (_group getVariable "FUPS_closeenough")) then {
			// _group setVariable ["FUPS_reinfReady",true];

			//if ({!(_x getVariable ["FUPS_reinfReady",false])} count _combinedGroups == 0) then {
			_group setVariable ["FUPS_taskState","newwp"];
			_group setVariable ["FUPS_reinfInArea",time];
		};
	};
	case "newwp": {
        ["Newwp",false,false,ACTIONS_LOG] call FUPS_fnc_log;
		private _areainfo = (_group getVariable "FUPS_reinfInfo") select 0;
		private _wp = [_group,_areaInfo] call FUPS_fnc_generateWP;

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
		[_group,"FUPS_fnc_task_attack",true] call FUPS_fnc_do;
	};
};
