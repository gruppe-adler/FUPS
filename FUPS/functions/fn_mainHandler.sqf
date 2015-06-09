// clock pulse tracking
FUPS_oefIndex = FUPS_oefIndex + 1;
// Will be executed after all groups have been calculated
if (FUPS_oefIndex == count FUPS_oefGroups) exitWith {
    FUPS_oefIndex = -1;
    FUPS_oefClockPulse = FUPS_oefClockPulse + 1;
    // new clock cycle period

    // delete groups
    if (count FUPS_oefGroups_toDelete > 0) then {
        FUPS_oefGroups_toDelete sort false;
        {
            FUPS_oefGroups deleteAt _x;
        } foreach FUPS_oefGroups_toDelete;
        FUPS_oefGroups_toDelete = [];
    };

    // re-calculate all groups
    {
        _x resize 0;
        _x = +(FUPS_share select _forEachIndex);
    } forEach FUPS_shareNow;

    {
        {
            // clear array without resetting the pointer
            _x resize 0;
        } forEach _x;
    } forEach [FUPS_enemies,FUPS_groups,FUPS_share];

    {
        private "_side";
        _side = side _x;
        // refill the enemie arrays
        if (_side getFriend west < 0.6) then {FUPS_enemies_west pushBack _x};
        if (_side getFriend east < 0.6) then {FUPS_enemies_east pushBack _x};
        if (_side getFriend independent < 0.6) then {FUPS_enemies_guer pushBack _x};

        if (_side != civilian) then {
            (FUPS_groups select ([west,east,independent] find _side)) pushBack _x;
        };
    } forEach allGroups;

    if (count FUPS_oefGroups_toAdd > 0) then {
        FUPS_oefGroups append FUPS_oefGroups_toAdd;
        FUPS_oefGroups_toAdd = [];
    };

    FUPS_players = [];
    if (isMultiplayer) then {
        private "_players";
        _players = playableUnits;
        {
            if (!isNull (getConnectedUAV _x)) then {
                _players pushBack (getConnectedUAV _x);
            };
        } forEach _players;
        FUPS_players = _players;
    }
    else {
        FUPS_players = [player];
    };
};

//if (count FUPS_oefGroups == 0) exitWith {};

private ["_group","_side","_sideIndex","_leader","_members","_clockPulse"];
_group = FUPS_oefGroups select FUPS_oefIndex;
_side = side _group;
_sideIndex = [west,east,independent] find _side;
_leader = leader _group;
_members = units _group;
_clockPulse = _group getVariable ["FUPS_clockPulse",-1];
_clockPulse = _clockPulse + 1;
_group setVariable ["FUPS_clockPulse",_clockPulse];

// handle simulation
_simulation = _group getVariable ["FUPS_simulation",{true}];
if !([_group] call _simulation) exitWith {
    if (simulationEnabled _leader) then {[_group,false,true] call FUPS_fnc_simulation};
};
if !(simulationEnabled _leader) then {
    [_group,true,true] call FUPS_fnc_simulation;
};

// get moved distance
private "_currpos";
_currpos = getPosATL _leader;
_currpos set [2,0];

// get the group damage
private ["_combatStrength","_groupdamage"];
_combatStrength     = 1;
_groupdamage        = 0;
{
    _groupdamage = _groupdamage + damage _x;
} forEach _members;
_groupdamage = _groupdamage + ((_group getVariable ["FUPS_members",count _members]) - (count _members));

if (_groupdamage == _group getVariable ["FUPS_members",count _members]) exitWith {
    FUPS_oefGroups_toDelete pushBack FUPS_oefIndex;
};

_combatStrength = 1 - (_groupdamage / (_group getVariable ["FUPS_members",count _members]));
_gothit = _groupdamage > (_group getVariable ["FUPS_lastDamage",0]);

// get the situation
private ["_maxknowledge","_targets","_directions","_enemies","_nearEnemies","_fears","_theyGotUs","_share"];
_maxknowledge = 0.5;
_targets = [];
_directions = [];
_enemies = [];
_nearEnemies = [];
_fears = [];
_theyGotUs = false;
_share = FUPS_shareNow select _sideIndex;

if (_group getVariable ["FUPS_doShare",true]) then {
    {
        if (_leader distance leader _x < 600) then {
            {_group reveal [3,_x]} forEach (units _x);
        };
    } forEach _share;
};

_share = FUPS_share select _sideIndex;
{ // foreach
    private "_knowsgroup";
    _knowsgroup = false;
    { // foreach
        private ["_v","_knows"];
        _v = vehicle _x;
        _knows = _group knowsAbout _v;
        if (_knows > 0.5) then {_knowsgroup = true};
        if (_knows > _maxknowledge) then {_maxknowledge = _knows};
    } forEach (units _x);

    if (_leader distance leader _x < 150) then {_nearEnemies pushBack _x};

    if (_knowsgroup) then {
        _x setVariable ["FUPS_lastSpotted",time];

        _enemies pushBack _x;
        _share pushBack _x;

        if !([3] isEqualTo ([_x] call FUPS_fnc_g_type)) then {
            _directions pushBack ([_currpos,getPosATL leader _x] call FUPS_fnc_getDir)
        };

        if ([_group,_x] call FUPS_fnc_isEffective) then {
            _targets pushBack _x;
        }
        else {
            if ([_group,_x] call FUPS_fnc_fears) then {
                _fears pushBack _x;

                // is this vehicle aimed at the group?
                { // foreach
                    private "_v";
                    _v = vehicle _x;
                    if ({_v aimedAtTarget [_x] > 0.9} count _members > 0) then {_theyGotUs = true};
                } forEach (units _x);
            };
        };
    };
} forEach (FUPS_enemies select _sideIndex);

// re-evaluate current target
private ["_target_val","_target_dist"];
_target = _group getVariable "FUPS_target";
_target_val = 0;
_target_dist = 10000;
if !(isNull _target) then {
    _target_val = count (_target getVariable ["FUPS_supportFor",[]]);
    _target_dist = _leader distance leader _target;
};

private ["_nearestTarget","_nearestTarget_dist","_nearestTarget_val","_mostDangerousTarget","_mostDangerousTarget_val","_mostDangerousTarget_dist"];
_nearestTarget = grpNull;
_nearestTarget_dist = 10000;
_nearestTarget_val = 10000;
_mostDangerousTarget = grpNull;
_mostDangerousTarget_val = 0;
_mostDangerousTarget_dist = 10000;
{ // foreach
    private ["_dist","_val"];
    _dist = _leader distance leader _x;
    _val = count (_x getVariable ["FUPS_supportFor",[]]);

    // nearest Target
    if (_dist < _nearestTarget_dist) then {
        _nearestTarget = _x;
        _nearestTarget_dist = _dist;
        _nearestTarget_val = _val;
    };

    // most dangerous Target
    if (_val > _mostDangerousTarget_val) then {
        _mostDangerousTarget = _x;
        _mostDangerousTarget_val = _val;
        _mostDangerousTarget_dist = _dist;
    }
    else {
        if (_val == _mostDangerousTarget_val && _dist < _mostDangerousTarget_dist) then {
            _mostDangerousTarget = _x;
            _mostDangerousTarget_val = _val;
            _mostDangerousTarget_dist = _dist;
        };
    };
} forEach _targets;

// get the target
private "_target";
_target = _nearestTarget;
if (_mostDangerousTarget_dist - _nearestTarget_dist < 150) then {_target = _mostDangerousTarget};
_group setVariable ["FUPS_target",_target];

// get situation variables
private ["_surrounded","_headsdown","_unknowIncident","_weakened"];
_surrounded     = _directions call FUPS_fnc_isSurrounded;
_headsdown      = !(_fears isEqualTo []);
_unknowIncident = (_maxknowledge == 0) && _gothit;
_weakened       = _combatStrength < 0.4;

if ((surfaceIsWater _currpos) && !(_group getVariable ["FUPS_allowWater",false])) then {
    _group setVariable ["FUPS_task","FUPS_fnc_getOutOfWater"];
    _group setVariable ["FUPS_break",{false}];
};

// --- ToDo: external orders
if (call (_group getVariable ["FUPS_break",{true}]) || (_group getVariable ["FUPS_task",""] == "")) then {
    ["Breaking the task"] call FUPS_fnc_log;

    // get current task
    private "_tasks";
    _tasks = [];
    if (_gothit && _targets isEqualTo [] || !(_enemies isEqualTo []) || _unknowIncident) then {
        _tasks pushBack "FUPS_fnc_task_hold";
    };
    if (!isNull _target) then {
        _tasks pushBack "FUPS_fnc_task_attack";
    };
    if (!(_fears isEqualTo []) || _weakened || (_groupdamage > (2*_lastdamage)) || ((_groupdamage - _lastdamage) > 1.5)) then {
        _tasks pushBack "FUPS_fnc_task_retreat";
    };

    private ["_highestPriority","_task"];
    _highestPriority = 0;
    _task = "FUPS_fnc_task_patrol";

    {
        private ["_taskName","_prior"];
        _taskName = _x;
        _prior = call (missionnamespace getVariable [(_taskName + "_prior"),{-10}]);
        if (_prior > _highestPriority) then {
            _task = _taskName;
            _highestPriority = _prior;
        };
    } forEach _tasks;

    // [["Selected task is: %1",_task]] call FUPS_fnc_log;

    _group setVariable ["FUPS_break",missionnamespace getVariable [(_task + "_break"),{true}]];

    // get the "right" task for the groups type, if it is defined
    private "_typeName";
    _typeName = _group getVariable ["FUPS_typeName","_man"];
    if !(isNil {missionnamespace getVariable (_task + _typeName)}) then {
        _task = _task + _typeName;
    };
    _group setVariable ["FUPS_task",_task];
    _group setVariable ["FUPS_taskState","init"];
};

0 call (missionnamespace getVariable (_group getVariable "FUPS_task"));

_group setVariable ["FUPS_gothit",_gothit];
_group setVariable ["FUPS_lastPos",_currpos];
_group setVariable ["FUPS_lastDamage",_groupdamage];
