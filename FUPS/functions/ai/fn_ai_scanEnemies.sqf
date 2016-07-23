
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
[_group] call FUPS_fnc_lowerPanic;
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
private _shareNext = FUPS_share select _sideIndex;
{ // foreach
	if !(isNull _x || units _x isEqualTo []) then {
		private _dist = _leader distance leader _x;

		// How much does this group know the other?
		private _maxKnowledge = 0;
		{ // foreach
			private _knows = _group knowsAbout _x;
			_maxKnowledge = _knows max _maxKnowledge;
		} forEach (units _x);

		// Check whether this group has been heared
		if (FUPS_hearing_enabled && _maxKnowledge <= 0) then {
			(_x getVariable ["FUPS_firedLast",[-1,0]]) params ["_firedAt","_soundDistance"];
			if (_firedAt + FUPS_cycleTime + 0.01 > time && _soundDistance <= _dist) then {
				private _reveal = linearConversion [_soundDistance / 2,_soundDistance,_dist,FUPS_hearing_shotRevealMax,FUPS_hearing_shotRevealMin,true];
				_group reveal [leader _x,_reveal];
				_maxKnowledge = _reveal;

				if (FUPS_targeting_enabled) then {
					[_group,_x,0.90] call FUPS_fnc_targeting_increaseThreshold;
				};
			};
		};

		// Check whether this group should be able to see the enemy group
		if (FUPS_targeting_enabled && _maxKnowledge < FUPS_knowsAboutThreshold) then {
			private _lookAt = vehicle selectRandom(units _x);
			private _lookFrom = vehicle selectRandom(units _group);

			private _chance = [_lookAt,_lookFrom] call FUPS_fnc_targeting_getChance;
			if (random 1 < _chance) then {
				_group reveal [_lookAt,FUPS_targeting_revealValue];
				_maxKnowledge = _maxKnowledge max FUPS_targeting_revealValue;
			};
		};

		// Even the groups enenmy knowledge
		{
			_group reveal [_x,_maxKnowledge];
		} forEach (units _x);

		// Do the actual "this group was spotted"-stuff
		if (_maxKnowledge >= FUPS_knowsAboutThreshold) then {
			_knowsAny = true;

			if (_dist < 150) then {_nearEnemies pushBack _x};

			_x setVariable ["FUPS_revealedAt",time];
			_enemies pushBack _x;
			if (_group getVariable "FUPS_doShare") then {
				_shareNext pushBack _x;
			};

			if !([3] isEqualTo ([_x] call FUPS_fnc_g_type)) then {
				_directions pushBack ([_currpos,getPosATL leader _x] call FUPS_fnc_getDir);
			};

			if ([_group,_x] call FUPS_fnc_isEffective) then {
				_targets pushBack _x;
			} else {
				if ([_group,_x] call FUPS_fnc_fears) then {
					_fears pushBack _x;

					// is this vehicle aimed at the group?
					{ // foreach
						private _v = vehicle _x;
						_theyGotUs = _theyGotUs || ({_v aimedAtTarget [_x] > 0.9} count _members > 0);
					} forEach (units _x);

					if (isNil {_x getVariable "FUPS_supportFor"}) then {
						_x setVariable ["FUPS_supportFor",[]];
					};

					if !(_x in _askedForSupport) then {
						(_x getVariable "FUPS_supportFor") pushBack _group;
						_askedForSupport pushBack _x;
					};
				};
			};
		};
		// --- ToDo: implement with new task system
		/* else { if (_maxKnowledge >= 0) then {
			// --- ToDo: reset patrol route
		}};*/
	} else {
		[["Error: group %1 is null or empty - looping enemies",_x],true,false,ERROR_LOG] call FUPS_fnc_log;
	};
} forEach (FUPS_enemies select _sideIndex);

{
	private _supportArray = _x getVariable "FUPS_supportFor";
	_supportArray deleteAt (_supportArray find _group);
	_askedForSupport deleteAt (_askedForSupport find _group);
} forEach (_askedForSupport - _fears);

_group setVariable ["FUPS_ai_knowsAny", _knowsAny];
_group setVariable ["FUPS_ai_targets", _targets];
_group setVariable ["FUPS_ai_directions", _directions];
_group setVariable ["FUPS_ai_enemies", _enemies];
_group setVariable ["FUPS_ai_nearEnemies", _nearEnemies];
_group setVariable ["FUPS_ai_fears", _fears];
_group setVariable ["FUPS_ai_theyGotUs", _theyGotUs];
_group setVariable ["FUPS_ai_surrounded", _directions call FUPS_fnc_isSurrounded];
_group setVariable ["FUPS_ai_headsdown", !(_fears isEqualTo [])];
