
#include "macros.hpp"

params ["_groups"];

// Check whether groups have been heared
{
	(_x getVariable ["FUPS_firedLast",[-1,0]]) params ["_firedAt","_soundDistance"];
	if (_firedAt + FUPS_cycleTime + 0.01 > time && _soundDistance <= _dist) then {
		private _reveal = linearConversion [_soundDistance / 2, _soundDistance ,_dist, FUPS_hearing_shotRevealMax, FUPS_hearing_shotRevealMin, true];
		_group reveal [leader _x, _reveal];

		if (FUPS_targeting_enabled) then {
			[_group, _x, 0.90] call FUPS_fnc_targeting_increaseThreshold;
		};
	};
} forEach (FUPS_enemies select _sideIndex);
