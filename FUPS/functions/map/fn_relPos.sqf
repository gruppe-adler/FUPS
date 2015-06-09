private ["_pos","_dist","_dir"];

_pos  = _this select 0;
_dist = _this select 1;
_dir  = _this select 2;

[(_pos select 0) + _dist*sin _dir, (_pos select 1) + _dist*cos _dir,0]