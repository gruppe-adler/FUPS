#include "..\..\header\header.hpp"

params ["_unit","_raise"];

private _group = if (_unit isEqualType grpNull) then {_unit} else {group _unit};

private _level = _group getVariable ["FUPS_panic",0];
_group setVariable ["FUPS_panic",_level + _raise];
