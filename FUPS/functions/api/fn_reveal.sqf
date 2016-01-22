/*

	Reveals all given units or groups to the side in FUPS.

	PARAMS:
		0 <ARRAY/OBJECT/GROUP> - an array containing objects or groups to be revealed
		1 <SIDE> - side to reveal to

	RETURN:
		nil

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

#define DOREVEAL(X) \
	private _target = if (X isEqualType objNull) then {group X} else {X}; \
	if !(_target in _share) then { \
		_target setVariable ["FUPS_revealedAt",time]; \
		_share pushBack _target; \
	};


params [["_toReveal",[],[[],objNull,grpNull]],["_side",sideUnknown,[sideUnknown]]];
if (_side == sideUnknown) exitWith {};

private _share = FUPS_share select (FUPS_sideOrder find _side);

if !(_toReveal isEqualType []) exitWith {DOREVEAL(_toReveal)};

{ DOREVEAL(_x) } forEach _toReveal;

