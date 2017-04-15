
#include "macros.hpp"

params ["_group"];
private _units = units _group;
private _killed = _group getVariable "FUPS_panic_killed";
private _countUnits = {alive _x} count _units + _killed;
private _tickDiff = _group getVariable "FUPS_tickDiff";

private _rawDamage = REDUCE(_units apply { if (alive _x) then {damage _x} else {0} }, 0, +) + _killed;
private _damageConsidered = _group getVariable "FUPS_panic_damageConsidered";

private _groupDamage =  _rawDamage / _countUnits;
if (_groupDamage > _damageConsidered) then {
    _damageConsidered = _damageConsidered + ((_groupDamage - _damageConsidered) / DAMAGE_DECREASE_FACTOR * _tickDiff);
    _group setVariable ["FUPS_panic_damageConsidered", _damageConsidered];
};
_groupDamage = (_rawDamage - _damageConsidered) / (_countUnits - _damageConsidered);

private _groupSuppression = (REDUCE(_units apply { if (alive _x) then {getSuppression _x} else {0} }, 0, +) + _killed) / _countUnits;

_panic = PANIC_FNC(_groupDamage,_groupSuppression);
_group setVariable ["FUPS_panic_value", _panic];

_group allowFleeing _panic;

private _isFleeing = fleeing leader _group;

if (_isFleeing) then {
    _group setVariable ["FUPS_ai_target", objNull];
    [_group] call FUPS_fnc_ai_clearWp;
};

_isFleeing
