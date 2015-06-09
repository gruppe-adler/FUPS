private ["_group","_wps"];
_group = _this select 0;
_wps	= [];

if (count waypoints _group <= 1) exitWith { _wps };

for "_i" from 1 to (count waypoints _group - 1) do {
	private "_array";
	_array = [[0,0,0],_i + 1];
	_array set [0,waypointPosition [_group,_i]];
	if (waypointType [_group,_i] == "CYCLE") exitWith {
		_array set [1,0];
		_wps pushBack _array;
	};

	_wps pushBack _array;
};

private ["_minDist","_index","_cyclePos"];
_minDist	= 100000;
_index		= 0;
_cyclePos	= _wps select ((count _wps) - 1) select 0;
for "_i" from 0 to ((count _wps) - 2) do {
	private "_dist";
	_dist = (_wps select _i select 0) distance _cyclePos;
	if (_dist < _minDist) then {
		_index = _i;
	};
};
(_wps select ((count _wps) - 1)) set [1,_index];

if (count _wps == 1) exitWith { [] };

_wps
