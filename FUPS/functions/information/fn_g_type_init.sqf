private ["_group","_types"];
_group = _this select 0;
_types = [_group] call FUPS_fnc_g_type_get;

_group setVariable ["FUPS_g_type",_types];

_types
