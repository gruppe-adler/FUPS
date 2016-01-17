#include "..\..\header\header.hpp"

params [["_obj","",[objNull,""]]];

private _data = [];
switch (true) do {
	case (_obj isEqualType objNull && {_obj isKindOf "isKindOf"}): {
		_data = [_obj] call FUPS_fnc_triggerArea;
	};
	case (_obj isEqualType ""): {
		_data = [_obj] call FUPS_fnc_markerArea;
	};
};

_data params ["_pos","_dir","_size","_relpos"];

private _vector	= _pos vectorFromTo _relpos;
_vector	= _vector vectorMultiply 2*(_size select 1);

private _vector_1	= [(_vector select 1),-(_vector select 0),0];
_vector_1	= vectorNormalized _vector_1;
_vector_1	= _vector_1 vectorMultiply 2*(_size select 0);

// set all to the lower right corner of the marker
private _pos = _pos vectorAdd ((_vector vectorMultiply -0.5) vectorAdd (_vector_1 vectorMultiply -0.5));

private _mindist = ((vectorMagnitude (_vector vectorAdd _vector_1)) / 4) min 200;

[_pos,_mindist,_vector,_vector_1,_dir]
