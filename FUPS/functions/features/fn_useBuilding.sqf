/*

	Let's the group use the building

	PARAMS:
		0 <GROUP> - group
		1 <OBJECT> - building

	RETURN:
		<BOOLEAN> - success or not

	AUTHOR: [W] Fett_Li

*/

// -- ToDo

#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]],["_building",objNull,[objNull]]];

private _index = 0;
private _posArray = [];
while {!(_build buildingPos _index isEqualTo [0,0,0])} do {
	_posArray pushBack (_build buildingPos _index);
	_index = _index + 1;
};

if !((count _posArray) >= count units _group) exitWith {false};

{
	_index = floor random (count _posArray);
	_x doMove (_posArray select _index);
	_x setVariable ["FUPS_buildingIndex",_index];
	[_x,(_posArray select _index)] spawn {
		_unit = _this select 0;
		waitUntil {unitReady _unit};
		if (_unit distance (_this select 1) < 1) then {doStop _unit};
	};
	_posArray deleteAt _index;
} forEach (units _group);

true
