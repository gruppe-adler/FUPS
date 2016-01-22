/*

	This function calculates all types of a group.

	PARAMS:
		0 <GROUP> - group to calculate from

	RETURN:
		<<SCALAR> ARRAY> - group type indexes

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]]];
if (isNull _group) throw NULLPOINTEREXCEPTION;

private _units = units _group;
private _types = [];
{
	private _type = [vehicle _x] call FUPS_fnc_v_type;
	if (_type > -1 && !(_type in _types)) then { _types pushBack _type };
} forEach _units;

_types
