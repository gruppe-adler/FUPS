
#include "macros.hpp"

params ["_group"];

// handle simulation
// --- ToDo: better caching
if !([_group] call (_group getVariable "FUPS_simulation")) exitWith {
	if (simulationEnabled _leader) then {
		[_group,false,true] call FUPS_fnc_simulation
	};

	false
};

if !(simulationEnabled _leader) then {
	[_group,true,true] call FUPS_fnc_simulation;
};

true
