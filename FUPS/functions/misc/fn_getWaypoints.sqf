/*

	Parses all waypoints of a group. Only move and cycle waypoints will be counted. Every non-move/cycle waypoint will be treated as move waypoint.

	PARAMS:
		0 <GROUP> - group to get waypoints from

	RETURN:
		<ARRAY> - array with elements formated as: [POSITION,NEXT WP INDEX]

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]]];

_group = _this select 0;
private _wps = waypoints _group;

{
	scopeName "forEach";

	// If we encountered a cycle waypoint, stop here
	if (waypointType _x == "CYCLE") exitWith {
		_wps set [_forEachIndex,[waypointPosition _x,-1]];
		breakOut "forEach";
	};

	// Transform each waypoint into a position and the next waypoint to take
	_wps set [_forEachIndex,[waypointPosition _x,_forEachIndex + 1]];
} forEach _wps;

private _lastIndex = count _wps - 1;
private _lastWp = _wps select _lastIndex;

// If last wp was of type cycle and there are any other wps
if ((_wps select _lastIndex) select 1 == -1 && {_lastIndex > 0}) then {
	// Find the nearest waypoint to the cycle position
	private _cyclePos = _lastWp select 0;
	private _nearest = (_wps select 0) select 0;
	private _index = 0;

	for "_i" from 1 to _lastIndex - 1 do {
		private _wp = _wps select _i;
		if (_cyclePos distance (_wp select 0) < _cyclePos distance _nearest) then {
			_nearest = _wp;
			_index = _forEachIndex;
		};
	};

	// Set the index of the nearest waypoint to the cycle waypoint
	_lastWp set [1,_index];

// Last wp was not of type cycle so we have to set a stop sign
} else {
	_lastWp set [1,-1];
};

_wps
