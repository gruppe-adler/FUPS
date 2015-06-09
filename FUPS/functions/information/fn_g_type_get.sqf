private ["_group","_units","_types"];
_group = _this select 0;
_units = units _group;

_types = [];
{
	private "_type";
	_type = [vehicle _x] call FUPS_fnc_v_type;
	if (_type > -1 && !(_type in _types)) then { _types pushBack _type };
} forEach _units;

_types
