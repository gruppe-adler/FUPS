params ["_group","_mode"];

switch _mode do {
    case ("init"): {
        ["Holding"] call FUPS_fnc_log;

        [_group] call FUPS_fnc_clearWP;
        private _wp = _group addWaypoint [_currpos,0];
        _wp setWaypointType "LOITER";
        _wp setWaypointLoiterRadius 200;

        _group setVariable ["FUPS_taskState",""];
    };
};
