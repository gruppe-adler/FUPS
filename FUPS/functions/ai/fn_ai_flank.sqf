params ["_args", ["_leader",objNull,[objNull]], ["_flankPos",[],[[]],[3]]];
if (isNil "_args" || {!(_args isEqualType [])}) throw "IllegalArgumentsException";

_flankPos set [2, 0];
_args set [0, _leader];
_args set [1, _flankPos];
_args set [2, 0.6];
_args set [3, 60 * ([1, -1] select (random 1 < 0.5))];

FUPS_fnc_ai_flank_rec;
