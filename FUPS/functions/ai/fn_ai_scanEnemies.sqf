
#include "macros.hpp"

params ["_group"];

private _knowsAny = false;
private _targets = [];
private _enemies = [];
private _nearEnemies = [];
private _fears = [];
private _shareNow = FUPS_shareNow select _sideIndex;

// Reveal all shared enemies
if (_group getVariable "FUPS_doSupport") then {
	{
		if (_leader distance leader _x < FUPS_shareDist) then {
			_group reveal [leader _x,3];
		};
	} forEach _shareNow;
};

private _askedForSupport = _group getVariable "FUPS_askedForSupport";
{ // foreach
	if !(isNull _x || units _x isEqualTo []) then {

		private _dist = _leader distance leader _x;

		// How much does this group know the other?
		private _maxKnowledge = REDUCE(units _x apply {_group knowsAbout _x}, 0, max);

		// Do the actual "this group was spotted"-stuff
		if (_maxKnowledge >= FUPS_knowsAboutThreshold) then {
			_x setVariable ["FUPS_revealedAt",time];

			if (_dist < NEAR_ENEMY_DIST) then {
				_nearEnemies pushBack [_x, _dist];
			};
			_enemies pushBack [_x, _dist];

			if ([_group,_x] call FUPS_fnc_isEffective) then {
				_targets pushBack [_x, _dist]; // TODO: consider distance to possible target
			} else {if ([_group,_x] call FUPS_fnc_fears) then {
				_fears pushBack _x;
			}};
		};
	} else {
		[["Error: group %1 is null or empty - looping enemies",_x],true,false,ERROR_LOG] call FUPS_fnc_logging_log;
	};
} forEach (FUPS_enemies select _sideIndex);

_targets sort ASCENDING;
_enemies sort ASCENDING;

_group setVariable ["FUPS_ai_targets", _targets];
_group setVariable ["FUPS_ai_enemies", _enemies];
_group setVariable ["FUPS_ai_nearEnemies", _nearEnemies];
_group setVariable ["FUPS_ai_fears", _fears];
