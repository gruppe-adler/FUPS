/*

   -1 - target is no man
	0 - swimming
	1 - prone
	2 - crouch
	3 - stand

 */

#include "..\..\header\header.hpp"

params ["_unit"];

if !(_unit isKindOf "Man") exitWith {-1};
if (surfaceIsWater getPosATL _unit) exitWith {0};

private _eyeHeight = (ASLtoATL eyePos _unit) select 2;

if (_eyeHeight < 1) exitWith {1};
if (_eyeHeight < 1.5) exitWith {2};
3
