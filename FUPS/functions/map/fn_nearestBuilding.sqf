private ["_searchPos","_searchDistance","_pos","_buildings","_building","_minDist","_dist"];

_searchPos = _this select 0;
_searchDistance = _this select 1;

_building = objNull;
_buildings = _searchPos nearObjects ["Building",_searchDistance];
if !(_buildings isEqualTo []) then {
	_building = objNull;
	_minDist = 0;
	{
		_dist = _x distance _searchPos;
		if (_dist < _minDist) then {
			_building = _x;
			_minDist = _dist;
		};
	} forEach _buildings;
};

_building