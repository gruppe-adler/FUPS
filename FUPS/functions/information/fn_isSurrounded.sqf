private ["_directions","_lastindex","_element","_surrounded"];

_directions = _this;
if (_directions isEqualTo []) exitWith { false };

_directions sort true;
_lastindex = count _directions - 1;

_element = _directions select 0;
_surrounded = true;
for "_i" from 1 to _lastindex do {
	if (!(((_element + 120) mod 360) <= (_directions select _i))) then {
		_surrounded = false;
	} else {
		_element = _directions select _i;
	};
};
if (_surrounded) then {
	_surrounded = (((_directions select _lastindex) + 120) mod 360) <= (_directions select 0);
};

_surrounded
