/*

	Get's all vehicles of a group without duplicates.

	PARAMS:
		0 <GROUP> - group

	RETURN:
		<<OBJECT> ARRAY> - all group vehicles (no crews)

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]]];

private _vs = [];

{ if !(vehicle _x in _vs) then { _vs pushBack vehicle _x } } forEach (units _group);

_vs
