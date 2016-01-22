/*

	Clears all waypoints of a group, except the first one.

	PARAMS:
		0 <GROUP> - group to delete at

	RETURN:
		nil

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]]];

private _count = count (waypoints _group);
if (_count < 2) exitWith {};
for "_i" from 1 to (_count - 1) do {
	deleteWaypoint [_group,0];
};