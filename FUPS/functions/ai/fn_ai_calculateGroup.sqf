/*

	Calculates the low level ai for a group.
	Group must be initialized with FUPS.

	PARAMS:
		0 <GROUP> - group to be calculated

	RETURNS:
		NONE

	AUTHOR: [W] Fett_Li

*/

#include "macros.hpp"

params ["_group"];
private _leader = leader _group;
private _curPos = getPosATL _leader;

// re-evaluate current target
private _target = _group getVariable "FUPS_ai_target";

if (isNull _target || {surfaceIsWater _curPos && !(_group getVariable "FUPS_allowWater")}) then {
	// patrol or get out of water
} else {
	// fight
};

private _moveQueue = _group getVariable "FUPS_ai_moveQueue";
private _wp = _moveQueue select 0;
if (_curPos distance2D (_wp select 0) <= (_group getVariable "FUPS_closeenough")) then {
	(_wp select 4) call (_wp select 3);
	_moveQueue deleteAt 0;
	_wp = _moveQueue select 0;

	_wp params ["_movePos", "_moveSpeed", "_moveBehaviour"];
	_group move _movePos;
	_group setSpeedMode _moveSpeed;
	_group setBehaviour _moveBehaviour;
};

_group setVariable ["FUPS_lastPos",_curPos];
