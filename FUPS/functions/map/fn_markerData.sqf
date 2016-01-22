/*

	This function returns the area data of given marker/trigger.

	PARAMS:
		0 <OBJECT/STRING> - trigger or marker

	RETURN:
		<ARRAY format AREA> - area of the trigger/marker

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_obj","",[objNull,""]]];

// Init variables
private _pos	= [0,0,0];
private _dir	= 0;
private _size	= [0,0];
private _relpos	= [0,0,0];

// Get basic data from trigger or from marker
switch (true) do {
	case (_obj isEqualType objNull && {_obj isKindOf "isKindOf"}): {
		_pos	= getPos _trigger;
		_size	= triggerArea _trigger;
		_dir	= _size select 2;
		_size resize 2;
		_relpos	= [(_pos select 0) + (sin _dir), (_pos select 1) + (cos _dir),0];
	};
	case (_obj isEqualType ""): {
		_pos	= getMarkerPos _obj;
		_dir	= markerDir _obj;
		_size	= getmarkerSize _obj;
		_relpos	= [(_pos select 0) + (sin _dir), (_pos select 1) + (cos _dir),0];
	};
};

private _vectorY	= _pos vectorFromTo _relpos;
_vectorY	= _vectorY vectorMultiply 2*(_size select 1);

private _vectorX	= [(_vectorY select 1),-(_vectorY select 0),0];
_vectorX	= vectorNormalized _vectorX;
_vectorX	= _vectorX vectorMultiply 2*(_size select 0);

// set all to the lower right corner of the marker
private _pos = _pos vectorAdd ((_vectorY vectorMultiply -0.5) vectorAdd (_vectorX vectorMultiply -0.5));

private _mindist = ((vectorMagnitude (_vectorY vectorAdd _vectorX)) / 4) min 200;

// Create struct from data
private _area = AREA_NEW();
AREA_SET_ORIGIN(_area,_pos);
AREA_SET_MINDIST(_area,_mindist);
AREA_SET_XAXIS(_area,_vectorX);
AREA_SET_YAXIS(_area,_vectorY);
AREA_SET_DIR(_area,_dir);

_area
