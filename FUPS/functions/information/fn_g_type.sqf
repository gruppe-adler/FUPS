#include "..\..\header\header.hpp"

params ["_group"];

_group getVariable ["FUPS_g_type",([_group] call FUPS_fnc_g_type_init)];