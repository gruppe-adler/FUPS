private ["_group","_vs"];
_group = _this select 0;
_vs = [];

{ if !(vehicle _x in _vs) then { _vs pushBack vehicle _x } } forEach (units _group);

_vs
