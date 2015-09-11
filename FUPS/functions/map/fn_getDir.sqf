params ["_from","_to"];
private ["_vec","_dir"];
_vec = _from vectorFromTo _to;
_dir = acos(_vec select 1);
[_dir,(360 - _dir)] select (_vec select 0 < 0)