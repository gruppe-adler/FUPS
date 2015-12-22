#include "..\..\header\header.hpp"

params ["_o"];

private _count = count (waypoints _o);
if (_count < 2) exitWith {};
for "_i" from 1 to (_count - 1) do {
	deleteWaypoint [_o,0];
};