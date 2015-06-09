private ["_group","_units","_types"];
_group = _this select 0;
_units = units _group;
_types = [_group] call FUPS_fnc_g_type_get;

private "_type";
_type = -1;
if (count _types == 1) then { _type = _types select 0 };
_group setVariable ["FUPS_type",_type];

_type
