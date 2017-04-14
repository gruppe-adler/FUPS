
params ["_group", "_target"];

if (_group getVariable "FUPS_tasks_attacked" == _target) exitWith {};
_group setVariable ["FUPS_tasks_attacked", _target];

[_group] call FUPS_fnc_ai_clearWp;

private _pos = getPosATL leader _group;
_pos set [2, 0];
private _targetPos = getPosATL leader _target;
_targetPos set [2, 0];

// Get near the enemies first
if (_pos distance2D _targetPos > MIN_ENGAGE_DIST + (_group getVariable "FUPS_closeEnough")) exitWith {
    private _p = (vectorNormalized (_targetPos vectorDiff _pos)) vectorMultiply MIN_ENGAGE_DIST;
    [_p, ATTACK_PREPARE_SPEED, ATTACK_PREPARE_BEH, FUPS_fnc_tasks_attack, [_group, _target]] call FUPS_fnc_ai_addWp;
};

if (!isNull (_target getVariable ["FUPS_tasks_attacker", objNull])) then {
    private _orientation = vectorNormalized ([_target] call FUPS_fnc_orientation_get);
    private _dir = [_group, _target, _orientation] call FUPS_fnc_orientation_relDir;
    if (abs _dir <= 45) then { // -45 <= _dir <= 45
        private _p = _orientation vectorCrossProduct [0, 0, _dir / abs _dir]; // [0,0,1] or [0,0,-1]
        _p = _p vectorMultiply FLANK_DIST;
        [_targetPos vectorAdd _p, ATTACK_SPEED, ATTACK_BEH] call FUPS_fnc_ai_addWp;
    };
} else {
    _target setVariable ["FUPS_tasks_attacker", _group];
};
[_targetPos, ATTACK_SPEED, ATTACK_BEH, FUPS_fnc_tasks_attackDone, [_group, _target]] call FUPS_fnc_ai_addWp;
