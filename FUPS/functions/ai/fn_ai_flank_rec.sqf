params [["_leader",objNull,[objNull]],["_flankPos",[0,0,0],[[]],[3]],["_distanceFactor",0,[0]],["_angle",0,[0]]];
// TODO: allow flanking left or right
if (_distanceFactor <= 0 || _angle <= 0) exitWith {};

private _movePos = _leader getRelPos [_leader distance2D _flankPos * _distanceFactor,_angle];
// TODO: use _movePos

[_leader, _flankPos, _distanceFactor - 0.1, _angle - 10] call FUPS_fnc_ai_flank_rec;
