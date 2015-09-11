params ["_searchPos","_searchDistance"];
private ["_pos","_buildings","_building","_minDist","_dist"];

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