/*

	This function calculates a groups center position.

	PARAMS:
		0 <GROUP> - group to calculate from

	RETURN:
		<ARRAY format POSITION> - center position

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]]];
if (isNull _group) throw NULLPOINTEREXCEPTION;

private _units = units _group;
private _centerPos = [0,0,0];
{
	(getPosATL _x) params ["_xCord","_yCord"];
	_centerPos params ["_xCenter","_yCenter"];
	_centerPos set [0,_xCenter + _xCord];
	_centerPos set [1,_yCenter + _yCord];
} forEach _units;

_centerPos params ["_xCenter","_yCenter"];
_centerPos set [0,_xCenter / count _units];
_centerPos set [1,_yCenter / count _units];

_centerPos
