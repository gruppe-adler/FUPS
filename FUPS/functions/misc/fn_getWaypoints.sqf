scopeName _fnc_scriptName;
params ["_group"];
_group = _this select 0;
private _wps = waypoints _group;

{
	private _nextIndex = if (waypointType _x == "CYCLE") then {
		_wps set [_forEachIndex,[waypointPosition _x,-1]];
		breakTo _fnc_scriptName;
	}
	else {
		_wps set [_forEachIndex,[waypointPosition _x,_forEachIndex + 1]];
	};
} forEach _wps;

private _lastWp = _wps select (count _wps - 1);
if (_lastWp select 1 == -1) then {
	private _pos = _lastWp select 0;
	private _nearest = [0,0,0];
	private _index = -1;
	{
		if (_pos distance (_x select 0) < _pos distance _nearest) then {
			_nearest = _x select 0;
			_index = _forEachIndex;
		}
	} forEach (_wps - [_lastWp]);

	_lastWp set [1,_index];
} else {
	_lastWp set [1,-1];
};

_wps
