
#include "macros.hpp"

params ["_group"];

// Check whether group should be able to see an enemy group
{ // forEach
	private _lookAt = vehicle selectRandom units _x;
	private _lookFrom = vehicle selectRandom units _group;

	private _chance = [_lookAt, _lookFrom] call FUPS_fnc_targeting_getChance;
	if (random 1 < _chance) then {
		_group reveal [_lookAt, FUPS_targeting_revealValue];
	};
} forEach (FUPS_enemies select _sideIndex);
