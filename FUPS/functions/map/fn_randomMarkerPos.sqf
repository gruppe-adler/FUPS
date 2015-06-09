private ["_group","_freeRadius","_water","_waterCondition"];
_group = _this select 0;
_freeRadius = _this select 1;
_water = _this select 2; // 0 - no water, 1 - force water, 2 - don't care
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
	if (!(_pos isEqualTo []) && _waterCondition) then {
		_randompos = _pos;
		_tries = 25;
	};
};

_randompos
