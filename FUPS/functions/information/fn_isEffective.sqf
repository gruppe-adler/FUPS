private ["_ai","_ai_weapons","_group","_g_type"];
_ai = _this select 0;
_ai_weapons = [_ai] call FUPS_fnc_g_weapons;
_group = _this select 1;
_g_type = [_group] call FUPS_fnc_g_type;

private "_effective";
_effective = true;
{
	if !(_ai_weapons select _x) then { _effective = false }
} forEach _g_type;
_effective
