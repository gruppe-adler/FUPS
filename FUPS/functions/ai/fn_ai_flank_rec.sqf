
params [["_leader",objNull,[objNull]], ["_flankPos",[0,0,0],[[]],[3]], ["_distanceFactor",0,[0]], ["_angle",0,[0]]];

if (_distanceFactor <= 0 || _angle <= 0) exitWith {};

private _movePos = _leader getRelPos [_leader distance2D _flankPos * _distanceFactor,_angle];
// TODO: use _movePos

_args set [2, _distanceFactor - 0.1];
_args set [3, _angle + ([10, -10] select (_angle < 0))];

_args call FUPS_fnc_ai_flank_rec;
