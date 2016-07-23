#include "..\..\header\header.hpp"

params ["_ai","_group"];

private _ai_weapons = [_ai] call FUPS_fnc_g_weapons;
private _g_type = [_group] call FUPS_fnc_g_type;

private _effective = true;
{
	if !(_ai_weapons select _x) then { _effective = false }
} forEach _g_type;
_effective
