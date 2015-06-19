private ["_group","_target"];
_group = _this select 0;

switch (_this select 1) do {
    case ("init"): {
        ["Holding"] call FUPS_fnc_log;

        private "_wp";
        [_group] call FUPS_fnc_clearWP;
        _wp = _group addWaypoint [_currpos,0];
        _wp setWaypointType "LOITER";
        _wp setWaypointLoiterRadius 200;

        _group setVariable ["FUPS_taskState",""];
    };
};
