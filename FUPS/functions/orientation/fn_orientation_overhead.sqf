#include "macros.hpp"

{
	private _posArray = _x getVariable ["FUPS_orientation_queue", []];
	private _length = count _posArray;
	if (_length == 0) then {
		_x setVariable ["FUPS_orientation_queue", _posArray];
	};

	private _pos = getPosATL leader _x;
	_pos set [2, 0];
	if (_length == 0 || {(_posArray select (_length - 1)) distance2D _pos >= POS_DIFF}) then {
		_posArray pushBack _pos;

		if (_length + 1 > ARR_LENGTH) then {
			_posArray deleteAt 0;
		};
	};
} forEach allGroups;
