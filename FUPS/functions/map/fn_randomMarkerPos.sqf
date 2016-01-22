/*

	This function returns a random position inside an area.

	PARAMS:
		0 <GROUP> - group to generate the position for
		1 <SCALAR> - radius around the random position that has to be free
		2 <SCALAR> - water condition:
			0 - no water allowed
			1 - water forced
			2 - water doesn't matter
		3 <ARRAY format AREA> - area to generate the waypoint in

	RETURN:
		<ARRAY format POSITION> - random position

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]],["_freeRadius",0,[0]],["_water",0,[0]],["_area",AREA_VAL,[AREA_VAL]]];
if !AREA_VALID(_area) throw ILLEGALARGUMENTSEXCEPTION;
AREA_PARAMS(_area); // _origin, _mindist, _xAxis, _yAxis, _dir

// for _water: 0 - no water, 1 - force water, 2 - don't care
private _waterCondition = [{!surfaceIsWater _pos},{surfaceIsWater _pos},{true}] select _water;

private _tries = 0;
private _randompos = [];
while {_tries < 25} do {
	private _pos = _origin vectorAdd (_xAxis vectorMultiply random 1) vectorAdd (_yAxis vectorMultiply random 1),
	if !(surfaceIsWater _pos) then {
		_pos = _pos findEmptyPosition [_freeRadius,30];
	};

	if (!(_pos isEqualTo []) && _waterCondition && {leader _group distance _pos > _mindist}) then {
		_randompos = _pos;
		_tries = 25;
	};
	_tries = _tries + 1;
};

if (_randompos isEqualTo []) then {
	["Error: Could not find random marker pos. Please check position.",false,true,true] call FUPS_fnc_log;
	_randompos = getPosATL leader _group;
};

_randompos
