params ["_group"];
private _vs = [];

{ if !(vehicle _x in _vs) then { _vs pushBack vehicle _x } } forEach (units _group);

_vs
