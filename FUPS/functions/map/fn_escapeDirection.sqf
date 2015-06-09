private ["_directions","_lastindex","_element","_escapeDirection","_lowerBound"];

if (_this isEqualTo []) exitWith { random 360 };

_directions = _this;
_directions sort true;
_lastindex = count _directions - 1;

_element			= _directions select 0;
_escapeDirection	= 0;
_lastdifference 	= 0;
for "_i" from 1 to _lastindex do {
	_difference = (_directions select _i) - _element;
	if (_difference > _lastdifference) then {
		_escapeDirection = _element + (_difference / 2);
		_lastdifference = _difference;
	};

	_element = _directions select _i;
};

_difference = ((_directions select 0) + 360) - _element;
if (_difference > _escapeDirection) then {
	_escapeDirection = _element + (_difference / 2);
};

// for we wouldn't be here if we'd be surrounnded, we can just continue
_escapeDirection