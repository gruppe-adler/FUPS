private ["_group","_target"];
_group = _this select 0;
_target = _this select 2;

switch (_this select 1) do {
	case ("init"): {
		["Attacking"] call FUPS_fnc_log;
		[_group] call FUPS_fnc_clearWP;

		_group setBehaviour "COMBAT";
		// no one would do plane and helicopter in one group, and should they do, it's their fuckin' fault
		if (vehicle leader _group isKindOf "Helicopter") then {
			_group setSpeedMode "FULL";

			if (_fears isEqualTo []) then { // no one near to harm the helicopter
				private ["_wp","_pos"];
				_pos = getPosATL leader _target;
				if (_nofollow) then {_pos = [_group,_pos] call FUPS_fnc_stayInside};

				_wp = _group addWaypoint [_pos,0];
				_wp setWaypointType "LOITER";
				_wp setWaypointLoiterRadius 150;
			} else {
				private "_pos";
				_pos = getPosATL leader _target;
				if (_nofollow) then {_pos = [_group,_pos] call FUPS_fnc_stayInside};

				_wp = _group addWaypoint [getPosATL leader _target,0];
				_wp setWaypointType "DESTROY";
				_wp waypointAttachVehicle (vehicle leader _target);
			};
		} else {
			if (([_target] call FUPS_fnc_g_type) isEqualTo [1]) then { // target is Man only -> can't attack
				{ // forEach
					if !(([_x] call FUPS_fnc_g_type) isEqualTo [1]) exitWith {_target = _x};
				} forEach _targets;
			};

			_wp = _group addWaypoint [getPosATL leader _target,0];
			_wp setWaypointType "DESTROY";
			_wp waypointAttachVehicle (vehicle leader _target);
		};

		{_x doWatch leader _target} forEach (units _group);

		_group setVariable ["FUPS_timeOnTarget",time + 600];
		_group setVariable ["FUPS_taskState","fight"];
	};
	case ("fight"): {
		if (_group knowsAbout leader _target > 0.2) then {_group setVariable ["FUPS_timeOnTarget",time + 600]};

		if ({alive _x} count units _target == 0 OR time > (_group getVariable "FUPS_timeOnTarget")) then {
			_group setVariable ["FUPS_task",""];
		};
	};
};
