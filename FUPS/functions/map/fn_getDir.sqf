/*

	This function gets the direction from one to another position.

	PARAMS:
		0 <ARRAY format POSITION> - from
		1 <ARRAY format POSITION> - to

	RETURN:
		<SCALAR> - direction compass style

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_from",[0,0,0],[[]],[2,3]],["_to",[0,0,0],[[]],[2,3]]];

private _vec = _from vectorFromTo _to;
private _dir = acos(_vec select 1);
[_dir,(360 - _dir)] select (_vec select 0 < 0)
