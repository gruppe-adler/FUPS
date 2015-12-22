#include "..\..\header\header.hpp"

params ["_viewer","_target","_newVal"];

private _value = [_viewer,_target] call FUPS_fnc_targeting_getMapValue;
_value params ["_revealVal","_lastQuery"];
_revealVal = _revealVal - linearConversion [FUPS_targeting_forgetTime,0,_lastQuery - time,0,1,true] max 0;
_revealVal = _revealVal + _newVal;

_value set [0,_revealVal];
_value set [1,time];

_revealVal
