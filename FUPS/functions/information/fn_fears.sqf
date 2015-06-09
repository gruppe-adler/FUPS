private ["_ai","_ai_type"];
_ai = _this select 0;
_ai_type = [_ai] call FUPS_fnc_ai_type;
_group = _this select 1;
_g_weapons = [_group] call FUPS_fnc_g_weapons;

_g_weapons select _ai_type
