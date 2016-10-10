
#include "macros.hpp"

params ["_group"];

// Add panic eventhandlers
if (FUPS_panic_enabled) then {

	_group setVariable ["FUPS_panic_killed", 0];
	_group setVariable ["FUPS_panic_value", 0];

	{
		_x addEventHandler ["Killed",{
			params ["_unit"];
			private _group = group _unit;
			_group setVariable ["FUPS_panic_killed", (_group getVariable "FUPS_panic_killed") + 1];
		}];
	} forEach (units _group);
};

