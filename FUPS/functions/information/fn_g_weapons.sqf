#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]]];
if (isNull _group) throw NULLPOINTEREXCEPTION;

_group getVariable ["FUPS_weapons",([_group] call FUPS_fnc_g_weapons_init)];
