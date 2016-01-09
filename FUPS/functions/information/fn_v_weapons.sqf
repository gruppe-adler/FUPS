#include "..\..\header\header.hpp"

params ["_v"];

_v getVariable ["FUPS_v_weapons",([_v] call FUPS_fnc_v_weapons_init)];
