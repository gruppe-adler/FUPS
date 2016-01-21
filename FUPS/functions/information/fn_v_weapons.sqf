#include "..\..\header\header.hpp"

params [["_v",objNull,[objNull]]];
if (isNull _group) throw NULLPOINTEREXCEPTION;

_v getVariable ["FUPS_v_weapons",([_v] call FUPS_fnc_v_weapons_init)];
