/*



*/

#include "macros.hpp"

params ["_targets","_areas","_units"];

private _assignedTargets = (_units apply { _x getVariable "FUPS_ai_target"; }) - [objNull];
private _targets = _targets - _assignedTargets;

private _unitsWithNearest = [];
private _unitsUnderThreat = [];
{ // forEach
	private _nearestTarget = (_x getVariable "FUPS_ai_targets") select 0;
	private _nearestEnemy = (_x getVariable "FUPS_ai_enemies") select 0;
	private _distDiff = (_nearestEnemy select 1) - (_nearestTarget select 1);

	if (_distDiff >= -150) then {
		if (!isNull (_nearestTarget select 0)) then {
			_unitsWithNearest pushBack [_x, _x distance2D _nearestTarget];
		};
	};

	if (_nearestEnemy select 1 <= 300) then {
		_unitsUnderThreat pushBack _x;
	};
} forEach _units;

_unitsWithNearest sort ASCENDING;

{ // forEach
	private _targetToAssign = objNull;
	{
		_x params ["_target", "_dist"];
		if !(_target in _assignedTargets) exitWith {
			_targetToAssign = _target;
		};
	} forEach (_x getVariable "FUPS_ai_targets");

	if (!isNull _targetToAssign) then {

	};
} forEach (_unitsWithNearest apply { _x select 0 });
