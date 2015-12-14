params ["_group","_freeRadius","_water","_area"];
// for _water: 0 - no water, 1 - force water, 2 - don't care
private _waterCondition = [{!surfaceIsWater _pos},{surfaceIsWater _pos},{true}] select _water;

_area params ["_markerPos","_mindist","_markerVector","_markerVector_1","_markerDir"];

private _tries = 0;
private _randompos = [];
while {_tries < 25} do {
	private _pos = _markerPos vectorAdd (_markerVector vectorMultiply random 1) vectorAdd (_markerVector_1 vectorMultiply random 1),
	_pos = _pos findEmptyPosition [_freeRadius,30];
	if (!(_pos isEqualTo []) {&& _waterCondition && leader _group distance _pos > _mindist}) then {
		_randompos = _pos;
		_tries = 25;
	};
};

if (_randompos isEqualTo []) then {
	["Error: Could not find random marker pos. Please check position.",false,true,true] call FUPS_fnc_log;
	_randompos = getPosATL leader _group;
};

_randompos
