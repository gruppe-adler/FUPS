#include "..\..\header\header.hpp"

params ["_vehicle","_weapon","_muzzle","_mode","_ammo"];

private _distance = (getNumber (configFile >> "CfgAmmo" >> _ammo >> "audibleFire") * 100) min FUPS_hearing_maxRange;

// commander if this eh is attached to a land vehicle, etc.
private _group = group _vehicle;
private _firedLast = _group getVariable ["FUPS_firedLast",[-1,0]];
_firedLast params ["_lastTime","_lastDistance"];

if (_distance > _lastDistance || _lastTime + FUPS_cycleTime + 0.01 < time) then {
	_group setVariable ["FUPS_firedLast",[time,_distance]];
};
