
/*

    Sets basic variables & tasks, called during preInit

    PARAMS:
        -

    RETURN:
        -

    Author: [W] Fett_Li

*/

// Variable to check if FUPS is loaded
FUPS_present = true;

// Save the side order for all arrays
FUPS_sideOrder = [west,east,independent];

FUPS_templates  = [];

FUPS_reinforcements_east = [];
FUPS_reinforcements_west = [];
FUPS_reinforcements_guer = [];
FUPS_reinforcements = [FUPS_reinforcements_west,FUPS_reinforcements_east,FUPS_reinforcements_guer];

// OnEachFrame handler variables
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

// register patrol task
["FUPS_fnc_task_patrol",{0},{
    _gothit || _knowsany
}] call FUPS_fnc_registerTask;

// register attack task
["FUPS_fnc_task_attack",{ // priority
    private "_prior";
    _prior = 1;
    if (_weakened) then {_prior = _prior - 0.3};
    if (_surrounded && !_weakened) then {_prior = _prior + 0.3};
    _prior
},{ // break condition
    _surrounded || _headsdown || _weakened || _theyGotUs
},{
    [leader _target]
}] call FUPS_fnc_registerTask;

// register hold task
["FUPS_fnc_task_hold",{ // priority
    private "_prior";
    _prior = 0;
    if ((_surrounded && _weakened) || (_headsdown && !_weakened)) then {_prior = _prior + 2};
    if (!_surrounded && _weakened) then {_prior = _prior - 0.5};
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
    _surrounded || _headsdown || _theyGotUs
},{
    [_directions,_nearEnemies]
}] call FUPS_fnc_registerTask;

["FUPS_fnc_task_reinf",{ // priority
    private "_prior";
    _prior = 0;
    if (_surrounded) then {_prior = _prior - 1};
    _prior = if (_gothit) then {_prior - 0.1} else {_prior + 0.5};
    _prior = if (_weakened) then {_prior - 0.3} else {_prior + 0.5};
    _prior
},{false},{
    [_target]
}] call FUPS_fnc_registerTask;
