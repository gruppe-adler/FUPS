
#include "macros.hpp"

params ["_group"];

// get the situation
private _knowsAny = false;
private _targets = [];
private _directions = [];
private _enemies = [];
private _nearEnemies = [];
private _fears = [];
private _theyGotUs = false;
private _shareNow = FUPS_shareNow select _sideIndex;

// Get the current panic level
private _panic = _group getVariable ["FUPS_panic",0];

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
		private _maxKnowledge = REDUCE((units _x) apply {_group knowsAbout _x}, 0, max);

		// Even the groups enenmy knowledge
		{ // forEach
			_group reveal [_x, _maxKnowledge];
		} forEach (units _x);

		// Do the actual "this group was spotted"-stuff
		if (_maxKnowledge >= FUPS_knowsAboutThreshold) then {
			_knowsAny = true;

			if (_dist < 150) then {
				_nearEnemies pushBack [_x, _dist];
			};

			_x setVariable ["FUPS_revealedAt",time];
			_enemies pushBack [_x, _dist];

			if !([3] isEqualTo ([_x] call FUPS_fnc_g_type)) then {
				_directions pushBack ([_currpos,getPosATL leader _x] call FUPS_fnc_getDir);
			};

			if ([_group,_x] call FUPS_fnc_isEffective) then {
				_targets pushBack [_x, _dist];
			} else {
				if ([_group,_x] call FUPS_fnc_fears) then {
					_fears pushBack _x;

					// is this vehicle aimed at the group?
					{ // forEach
						private _v = vehicle _x;
						_theyGotUs = _theyGotUs || ({_v aimedAtTarget [_x] > 0.9} count _members > 0);
					} forEach (units _x);
				};
			};
		};
	} else {
		[["Error: group %1 is null or empty - looping enemies",_x],true,false,ERROR_LOG] call FUPS_fnc_log;
	};
} forEach (FUPS_enemies select _sideIndex); // TODO: use section

_group setVariable ["FUPS_ai_knowsAny", _knowsAny];
_targets sort ASCENDING;
_group setVariable ["FUPS_ai_targets", _targets];
_group setVariable ["FUPS_ai_nearestTarget", _nearestTarget select 0];
_group setVariable ["FUPS_ai_directions", _directions];
_enemies sort ASCENDING;
_group setVariable ["FUPS_ai_enemies", _enemies];
_group setVariable ["FUPS_ai_nearEnemies", _nearEnemies];
_group setVariable ["FUPS_ai_nearestEnemy", _nearestEnemy select 0];
_group setVariable ["FUPS_ai_fears", _fears];
_group setVariable ["FUPS_ai_theyGotUs", _theyGotUs];
_group setVariable ["FUPS_ai_surrounded", _directions call FUPS_fnc_isSurrounded];
_group setVariable ["FUPS_ai_headsdown", !(_fears isEqualTo [])];
