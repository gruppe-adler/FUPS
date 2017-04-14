
params ["_group", "_target"];

_group setVariable ["FUPS_tasks_attacked", objNull];

if (_target getVariable ["FUPS_tasks_attacker"] == _group) then {
    _target setVariable ["FUPS_task_attacker", objNull];
};
