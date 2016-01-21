#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]]];
if (isNull _group) throw NULLPOINTEREXCEPTION;

_group getVariable ["FUPS_g_type",([_group] call FUPS_fnc_g_type_init)];