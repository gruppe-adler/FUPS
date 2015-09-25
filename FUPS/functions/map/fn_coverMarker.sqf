params ["_targets"];
private ["_positions","_targetsCount"];
_positions = [];
{
	switch (typeName _x) do {
		case (typeName []): {
			_positions set [_forEachIndex,_x];
		};
		case (typeName objNull): {
			_positions set [_forEachIndex,(getPosATL _x)];
		};
		case (typeName ""): {
			_positions set [_forEachIndex,(markerPos _x)];
		};
	};
} forEach _targets;
_targetsCount = count _targets;

private ["_xCord","_yCord"];
_xCord = 0;
_yCord = 0;
{
	_xCord = _xCord + (_x select 0);
	_yCord = _yCord + (_x select 1);
} forEach _positions;
_xCord = _xCord / _targetsCount;
_yCord = _yCord / _targetsCount;

private ["_centerpos","_minSize","_sizeA","_sizeB"];
_centerpos = [_xCord,_yCord,0];
_minSize = param [1,0,[0]];
_sizeA = _minSize;
_sizeB = _minSize;
{
	private ["_xDist","_yDist"];
	_xDist = _xCord - (_positions select _forEachIndex select 0);
	_yDist = _yCord - (_positions select _forEachIndex select 1);

	_sizeA = _sizeA max _xDist;
	_sizeB = _sizeB max _yDist;
} forEach _targets;

// create imaginery marker
private ["_markervector","_markervector_1","_mindist"];
_markervector	= [1,0,0] vectorMultiply (2*_sizeA);
_markervector_1	= [0,1,0] vectorMultiply (2*_sizeB);
_markerPos		= (_centerpos vectorAdd (_markervector vectorMultiply -0.5)) vectorAdd (_markervector_1 vectorMultiply -0.5);
_mindist		= (vectorMagnitude (_markervector vectorAdd _markervector_1)) / 4;

[_markerPos,_mindist,_markervector,_markervector_1,0]
