private ["_vec","_dir"];

_vec = (_this select 0) vectorFromTo (_this select 1);
_dir = acos(_vec select 1);
[_dir,(360 - _dir)] select (_vec select 0 < 0)