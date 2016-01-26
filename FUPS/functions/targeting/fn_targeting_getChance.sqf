#include "..\..\header\header.hpp"

params [["_lookAt",objNull,[objNull]],["_lookFrom",objNull,[objNull]]];

if (isNull _lookAt || isNull _lookFrom) exitWith {0};

private _dist = _lookAt distance _lookFrom;

// Exit conditions
// Out of sight distance
if (_dist > FUPS_targeting_maxRange) exitWith {0};
// No line of sight
if !(lineIntersectsSurfaces [eyePos _lookFrom,eyePos _lookAt] isEqualTo []) exitWith {0};
// --- ToDo: maybe add "VIEW" and "GEOM" LODs
// Is diving
if (getPosASL _lookAt select 2 < 0) exitWith {0};

private _reveal = linearConversion [FUPS_targeting_hide_increaseThreshold,FUPS_targeting_maxRange,_dist,FUPS_targeting_base,FUPS_targeting_base * 1.66,true];

// Multiply revealchance in relation to moving angle and speed
private _speed = vectorMagnitude velocity _lookAt;
if (_speed > 1.4) then { // Speed has to be more than walking
	_reveal = FUPS_targeting_time_moving * linearConversion [1,4,_speed,1,1/3,true];
};

private _stance = [_lookAt] call FUPS_fnc_getUnitStace;
if (_stance >= 0) then {
	_reveal = _reveal * ([FUPS_targeting_hide_swimming,FUPS_targeting_hide_prone,FUPS_targeting_hide_kneeling,FUPS_targeting_hide_standing] select _stance);
};

if ([_lookAt] call FUPS_fnc_inForest) then {
	_reveal = _reveal * FUPS_targeting_hide_forest;
};

if ([_lookAt] call FUPS_fnc_inTown) then {
	_reveal = _reveal * FUPS_targeting_hide_town;
};

// Apply the revealtime
_reveal = _reveal min FUPS_targeting_maxTime;
_reveal = FUPS_cycleTime / _reveal;

(([group _lookFrom,group _lookAt,(_reveal max 0)] call FUPS_fnc_targeting_getThreshold) - 1) max 0 min 1.33
