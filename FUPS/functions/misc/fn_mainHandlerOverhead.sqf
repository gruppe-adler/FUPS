/*

	This function will be called after all group calculations and does some overhead calculations.

	PARAMS:
		-

	RETURN:
		nil

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

FUPS_oefIndex = -1;
FUPS_oefClockPulse = FUPS_oefClockPulse + 1;
FUPS_cycleTime = (count FUPS_oefGroups + 1) / diag_fps;
// [["FUPS needs %1s to cycle through all groups",FUPS_cycleTime],true,false,ENVIROMENT_LOG] call FUPS_fnc_log;

// delete groups
if (count FUPS_oefGroups_toDelete > 0) then {
	// Remove duplicates
	FUPS_oefGroups_toDelete = FUPS_oefGroups_toDelete arrayIntersect FUPS_oefGroups_toDelete;

	// Sort descending
	FUPS_oefGroups_toDelete sort false;
	{
		FUPS_oefGroups deleteAt _x;
	} foreach FUPS_oefGroups_toDelete;
	FUPS_oefGroups_toDelete = [];
};

// re-calculate all groups
{
	_x resize 0;
	_x append (FUPS_share select _forEachIndex);
} forEach FUPS_shareNow;

{
	{
		// clear array without resetting the pointer
		_x resize 0;
	} forEach _x;
} forEach [FUPS_enemies,FUPS_share];

{
	private _side = side _x;
	// refill the enemie arrays
	if (west getFriend _side < 0.6 && count units _x > 0) then {FUPS_enemies_west pushBack _x};
	if (east getFriend _side < 0.6 && count units _x > 0) then {FUPS_enemies_east pushBack _x};
	if (independent getFriend _side < 0.6 && count units _x > 0) then {FUPS_enemies_guer pushBack _x};
} forEach allGroups;

if (count FUPS_oefGroups_toAdd > 0) then {
	FUPS_oefGroups append FUPS_oefGroups_toAdd;
	FUPS_oefGroups_toAdd = [];
};

FUPS_players = [];
if (isMultiplayer) then {
	private _players = allPlayers;
	{
		if (!isNull (getConnectedUAV _x)) then {
			_players pushBack (getConnectedUAV _x);
		};
	} forEach _players;
	FUPS_players = _players;
} else {
	FUPS_players = [player];
};
