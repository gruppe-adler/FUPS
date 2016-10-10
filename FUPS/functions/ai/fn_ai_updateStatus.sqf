
#include "macros.hpp"

params ["_group"];

private _leader = leader _group;
private _members = units _group;
private _membersCount = count _members;

[_group] call FUPS_fnc_lowerPanic;

// get the group damage
private _combatStrength = 1;
private _groupdamage = 0;
{
	_groupdamage = _groupdamage + damage _x;
} forEach _members;
_groupdamage = _groupdamage + ((_group getVariable "FUPS_members") - _membersCount);

_group setVariable ["FUPS_ai_combatStrength", 1 - (_groupdamage / _membersCount)];
_group setVariable ["FUPS_ai_gotHit", _groupdamage > (_group getVariable "FUPS_lastDamage")];
_group setVariable ["FUPS_ai_lastDamage", _groupdamage];
_group getVariable ["FUPS_ai_weakened", _combatStrength < FUPS_damageToRetreat];

// TODO: use getSuppression

true
