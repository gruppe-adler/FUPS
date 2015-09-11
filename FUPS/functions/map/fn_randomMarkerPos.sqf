params ["_group","_freeRadius","_water"];
// for _water: 0 - no water, 1 - force water, 2 - don't care
private "_waterCondition";
_waterCondition = [{!surfaceIsWater _pos},{surfaceIsWater _pos},{true}] select _water;

private ["_markerdata","_markerpos","_markervector","_markervector_1"];
_markerdata = _group getVariable "FUPS_marker";
_markerpos = _markerdata select 0;
_markervector = _markerdata select 2;
_markervector_1 = _markerdata select 3;

private ["_tries","_randompos"];
_tries = 0;
_randompos = [];
while {_tries < 25} do {
	private "_pos";
	_pos = _markerpos vectorAdd (_markervector vectorMultiply random 1) vectorAdd (_markervector_1 vectorMultiply random 1),
	_pos = _pos findEmptyPosition [_freeRadius,30];
	if (!(_pos isEqualTo []) AND _waterCondition) then {
		_randompos = _pos;
		_tries = 25;
	};
};

_randompos
