/*

	This function will create a marker covering all targets.
	Marker will have a minimum size.

	PARAMS:
		0 <<OBJECT/STRING/ARRAY format POSITION> ARRAY> - targets
		@optional 1 <SCALAR> default 50 - minimum size

	RETURN:
		ARRAY format AREA

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_targets",[],[[]]],["_minSize",50,[0]]];

private _positions = [];
{
	switch (typeName _x) do {
		case (typeName []): {
			_positions pushBack _x;
		};
		case (typeName objNull): {
			_positions pushBack getPosATL _x;
		};
		case (typeName ""): {
			_positions pushBack markerPos _x;
		};
	};
} forEach _targets;
private _targetsCount = count _targets;

private _xCord = 0;
private _yCord = 0;
{
	_xCord = _xCord + (_x select 0);
	_yCord = _yCord + (_x select 1);
} forEach _positions;
_xCord = _xCord / _targetsCount;
_yCord = _yCord / _targetsCount;

private _centerpos = [_xCord,_yCord,0];
private _sizeA = _minSize;
private _sizeB = _minSize;
{
	private _xDist = _xCord - (_positions select _forEachIndex select 0);
	private _yDist = _yCord - (_positions select _forEachIndex select 1);

	_sizeA = _sizeA max _xDist;
	_sizeB = _sizeB max _yDist;
} forEach _targets;

// create imaginery marker
private _yAxis	= [1,0,0] vectorMultiply (2*_sizeA);
private _xAxis	= [0,1,0] vectorMultiply (2*_sizeB);
private _origin		= (_centerpos vectorAdd (_yAxis vectorMultiply -0.5)) vectorAdd (_xAxis vectorMultiply -0.5);
_mindist		= (vectorMagnitude (_yAxis vectorAdd _xAxis)) / 4;

private _area = AREA_NEW();
AREA_SET_ORIGIN(_area,_origin);
AREA_SET_MINDIST(_area,_mindist);
AREA_SET_XAXIS(_area,_xAxis);
AREA_SET_YAXIS(_area,_yAxis);

_area
