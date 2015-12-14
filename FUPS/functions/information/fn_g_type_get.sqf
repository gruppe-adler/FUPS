params ["_group"];
private _units = units _group;
private _types = [];
{
	private _type = [vehicle _x] call FUPS_fnc_v_type;
	if (_type > -1 && !(_type in _types)) then { _types pushBack _type };
} forEach _units;

_types
