#include "..\..\header\header.hpp"

params ["_viewer","_target"];

(_viewer getVariable "FUPS_revealMap") params ["_indexes","_values"];
private _index = _indexes find _target;
if (_index == -1) then {
	_index = _indexes find grpNull;
	if (_index == -1) then {
		_index = count _indexes;
	};

	_indexes set [_index,_target];
	_values set [_index,[0,0]];
};

_values select _index;
