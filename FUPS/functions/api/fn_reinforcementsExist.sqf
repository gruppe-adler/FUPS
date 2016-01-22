/*

	Checks for the reinforcement group if it has any groups.

	PARAMS:
		0 <SCALAR> - reinforcements index
		1 <SIDE> - side of the reinforcements

	RETURN
		<BOOL> - true if the reinforcements group contains any ai groups

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_index",-1,[0]],["_side",sideUnknown,[sideUnknown]]];
if (_index == -1 || _side == sideUnknown) exitWith {};

private _reinfArray = FUPS_reinforcements select (FUPS_sideOrder find _side);

!(_reinfArray param [_index,[]] isEqualTo [])
