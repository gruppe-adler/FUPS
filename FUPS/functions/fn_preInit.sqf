/*

    Description: Sets basic variables and tasks

    PARAMS:
    -

    RETURN:
    -

    Author: [W] Fett_Li

*/

// Generall variables
FUPS_log = true;
FUPS_simulation_dist = 3500;

FUPS_templates  = [];
FUPS_reinforcements_east = [];
FUPS_reinforcements_west = [];
FUPS_reinforcements_guer = [];

FUPS_oefIndex = -1;
FUPS_oefGroups = [];
FUPS_oefGroups_toAdd = [];
FUPS_oefGroups_toDelete = [];
FUPS_oefClockPulse = 0;

// initialize global arrays
FUPS_enemies_west = [];
FUPS_enemies_east = [];
FUPS_enemies_guer = [];
FUPS_enemies = [FUPS_enemies_west,FUPS_enemies_east,FUPS_enemies_guer];

FUPS_groups_west = [];
FUPS_groups_east = [];
FUPS_groups_guer = [];
FUPS_groups = [FUPS_groups_west,FUPS_groups_east,FUPS_groups_guer];

FUPS_share_west = [];
FUPS_share_east = [];
FUPS_share_guer = [];
FUPS_share = [FUPS_share_west,FUPS_share_east,FUPS_share_guer];

FUPS_shareNow_west = [];
FUPS_shareNow_east = [];
FUPS_shareNow_guer = [];
FUPS_shareNow = [FUPS_shareNow_west,FUPS_shareNow_east,FUPS_shareNow_guer];

FUPS_players = [];

FUPS_oefHandler = ["FUPS_oef","onEachFrame",FUPS_fnc_mainHandler,0] call BIS_fnc_addStackedEventhandler;

// register patrol task
["FUPS_fnc_task_patrol",{0},{
    _gothit OR _maxknowledge > 0.5
}] call FUPS_fnc_registerTask;

// register attack task
["FUPS_fnc_task_attack",{ // priority
    private "_prior";
    _prior = 1;
    if (_weakened) then {_prior = _prior - 0.3};
    if (_surrounded AND !_weakened) then {_prior = _prior + 0.3};
    _prior
},{ // break condition
    _surrounded OR _headsdown OR _weakened OR _theyGotUs
},{
    [_target]
}] call FUPS_fnc_registerTask;

// register hold task
["FUPS_fnc_task_hold",{ // priority
    private "_prior";
    _prior = 0;
    if ((_surrounded AND _weakened) OR (_headsdown AND !_weakened)) then {_prior = _prior + 2};
    if (!_surrounded AND _weakened) then {_prior = _prior - 0.5};
    _prior
},{ // break condition
    _weakened
},{
    []
}] call FUPS_fnc_registerTask;

// register retreat task
["FUPS_fnc_task_retreat",{ // priority
    private "_prior";
    _prior = 2;
    if (_headsdown) then {_prior = _prior + 0.5};
    _prior = if (_surrounded) then {_prior - 3} else {_prior + 0.3};
    _prior
},{ // break condition
    _surrounded OR _headsdown OR _theyGotUs
},{
    [_directions,_nearEnemies]
}] call FUPS_fnc_registerTask;

["FUPS_fnc_task_reinforcement",{ // priority
    private "_prior";
    _prior = 0;
    if (_surrounded) then {_prior = _prior - 1};
    _prior = if (_gothit) then {_prior - 0.1} else {_prior + 0.5};
    _prior = if (_weakened) then {_prior - 0.3} else {_prior + 0.5};
    _prior
},{false},{
    [_target]
}] call FUPS_fnc_registerTask;

if (isServer) then {
    "FUPS_enableSimulation" addPublicVariableEventhandler {
        [(_this select 1),true] call FUPS_fnc_simulation;
    };
    "FUPS_disableSimulation" addPublicVariableEventhandler {
        [(_this select 1),false] call FUPS_fnc_simulation;
    };
};
