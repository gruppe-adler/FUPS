#include "..\..\header\header.hpp"

params ["_group"];
if (isNull _group) exitWith {};

private _types = [_group] call FUPS_fnc_g_type_get;

_group setVariable ["FUPS_g_type",_types];

_types
