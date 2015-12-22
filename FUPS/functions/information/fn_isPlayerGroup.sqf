#include "..\..\header\header.hpp"

params ["_group"];

_group getVariable ["FUPS_grpIsPlayer",([_group] call FUPS_fnc_isPlayerGroup_init)];