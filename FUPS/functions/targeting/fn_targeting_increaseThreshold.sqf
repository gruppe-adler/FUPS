#include "..\..\header\header.hpp"

params ["_viewer","_target","_newVal"];

private _value = [_viewer,_target] call FUPS_fnc_targeting_getMapValue;
_value set [0,(_value select 0) + _newVal];
