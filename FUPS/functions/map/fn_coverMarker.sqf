private ["_targets","_positions","_minSize","_targetsCount","_centerpos","_center1","_center2","_sizeA","_sizeB"];

_targets = _this select 0;
_positions = [];
{
	_positions set [_forEachIndex,(getPosATL _x)];
} forEach _targets;
_targetsCount = count _targets;

_xCord = 0;
_yCord = 0;
{
	_xCord = _xCord + (_x select 0);
	_yCord = _yCord + (_x select 1);
} forEach _positions;
_xCord = _xCord / _targetsCount;
_yCord = _yCord / _targetsCount;

_centerpos = [_xCord,_yCord,0];
_minSize = [_this,1,0,[0]] call BIS_fnc_param;
_sizeA = _minSize;
_sizeB = _minSize;
{
	private ["_xDist","_yDist"];
	_xDist = _xCord - (_positions select _forEachIndex select 0);
	_yDist = _yCord - (_positions select _forEachIndex select 1);

	if (_sizeA < _xDist) then {
		_sizeA = _xDist;
	};

	if (_sizeB < _yDist) then {
		_sizeB = _yDist;
	};
} forEach _targets;

// create imaginery marker
_markervector	= [1,0,0] vectorMultiply (2*_sizeA);
_markervector_1	= [0,1,0] vectorMultiply (2*_sizeB);
_markerPos		= (_centerpos vectorAdd (_markervector vectorMultiply -0.5)) vectorAdd (_markervector_1 vectorMultiply -0.5);
_mindist		= (vectorMagnitude (_markervector vectorAdd _markervector_1)) / 4;

[_markerPos,_mindist,_markervector,_markervector_1,0]
