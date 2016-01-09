#include "..\..\..\header\header.hpp"

params ["_group","_mode","_params"];
_params params ["_target"];

switch _mode do {
    case ("init"): {
        ["Attacking",false,false,ACTIONS_LOG] call FUPS_fnc_log;
        [_group] call FUPS_fnc_clearWP;
        {_x doWatch leader _target} forEach (units _group);

        _wp = _group addWaypoint [getPosATL leader _target,0];
        _wp setWaypointType "SAD";
        _wp waypointAttachVehicle (vehicle leader _target);

        _group setVariable ["FUPS_taskState","fight"];
    };
    case ("fight"): {
        if ({alive _x} count units _target == 0 || time - FUPS_timeOnTarget > (_target getVariable ["FUPS_revealedAt",0])) then {
            _group setVariable ["FUPS_task",""];
        };
    };
};
