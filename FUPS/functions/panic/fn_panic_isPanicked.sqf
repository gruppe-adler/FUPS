
#include "macros.hpp"

params ["_group"];
private _units = units _group;
private _tickDiff = _group getVariable "FUPS_tickDiff";
private _panic = (_group getVariable "FUPS_panic_value" - (_tickDiff * PANIC_DECREASE_RATE)) max MIN_PANIC;

private _killed = _group getVariable "FUPS_panic_killed";
_group setVariable ["FUPS_panic_killed", 0];

private _groupDamage = (REDUCE(_units apply { damage _x }, 0, +) + _killed) / (count _units + _killed);
private _groupSuppression = (REDUCE(_units apply { getSuppression _x }, 0, +) + _killed) / (count _units + _killed);

_panic = _panic + PANIC_FNC(_groupDamage,_groupSuppression);

_panic = _panic max MAX_PANIC;
_group setVariable ["FUPS_panic_value", _panic];
_panic > PANIC_THRESHOLD
