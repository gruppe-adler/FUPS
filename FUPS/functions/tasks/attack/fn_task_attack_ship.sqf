private ["_group","_target"];
_group = _this select 0;
_target = _this select 2;

switch (_this select 1) do {
    case ("init"): {
        ["Attacking"] call FUPS_fnc_log;
        [_group] call FUPS_fnc_clearWP;
        {_x doWatch leader _target} forEach (units _group);

        _wp = _group addWaypoint [getPosATL leader _target,0];
        _wp setWaypointType "DESTROY";
        _wp waypointAttachVehicle (vehicle leader _target);

        _group setVariable ["FUPS_timeOnTarget",time + 600];
        _group setVariable ["FUPS_taskState","fight"];
    };
    case ("fight"): {
        if (_group knowsAbout leader _target > 0.2) then {
            _group setVariable ["FUPS_timeOnTarget",time + 600];
        };

        if ({alive _x} count units _target == 0 OR time > (_group getVariable "FUPS_timeOnTarget")) then {
            _group setVariable ["FUPS_task",""];
        };
    };
};
