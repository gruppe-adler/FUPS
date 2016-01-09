#include "..\..\..\header\header.hpp"

params ["_group","_mode","_params"];
_params params ["_target"];

switch _mode do {
	case ("init"): {
		["Attacking",false,false,ACTIONS_LOG] call FUPS_fnc_log;
		[_group] call FUPS_fnc_clearWP;

		_group setBehaviour "COMBAT";
		// no one would do plane and helicopter in one group, and should they do, it's their fuckin' fault
		if (vehicle leader _group isKindOf "Helicopter") then {
			_group setSpeedMode "FULL";

			if (_fears isEqualTo []) then { // no one near to harm the helicopter
				private _pos = getPosATL leader _target;
				if (_nofollow) then {_pos = [_group,_pos] call FUPS_fnc_stayInside};

				private _wp = _group addWaypoint [_pos,0];
				_wp setWaypointType "LOITER";
				_wp setWaypointLoiterRadius 150;
			} else {
				private _pos = getPosATL leader _target;
				if (_nofollow) then {_pos = [_group,_pos] call FUPS_fnc_stayInside};

				_wp = _group addWaypoint [getPosATL leader _target,0];
				_wp setWaypointType "SAD";
				_wp waypointAttachVehicle (vehicle leader _target);
			};
		} else {
			if (([_target] call FUPS_fnc_g_type) isEqualTo [1]) then { // target is Man only -> can't attack
				{ // forEach
					if !(([_x] call FUPS_fnc_g_type) isEqualTo [1]) exitWith {_target = _x};
				} forEach _targets;
			};

			private _wp = _group addWaypoint [getPosATL leader _target,0];
			_wp setWaypointType "SAD";
			_wp waypointAttachVehicle (vehicle leader _target);
		};

		{_x doWatch leader _target} forEach (units _group);

		_group setVariable ["FUPS_taskState","fight"];
	};
	case ("fight"): {
		if ({alive _x} count units _target == 0 || time - FUPS_timeOnTarget > (_target getVariable ["FUPS_revealedAt",0])) then {
			_group setVariable ["FUPS_task",""];
		};
	};
};
