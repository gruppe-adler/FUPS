private ["_group","_building","_posArray","_index"];

_group = _this select 0;
_building = _this select 1;

private ["_index","_posArray"];
_index = 0;
_posArray = [];
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
