#include "..\..\header\header.hpp"

params ["_obj"];

private _data = [];
switch (true) do {
	case (_obj isEqualType objNull && {_obj isKindOf "isKindOf"}): {
		_data = [_obj] call FUPS_fnc_triggerArea;
	};
	case (_obj isEqualType "") {
		_data = [_obj] call FUPS_fnc_markerArea;
	};
};

_data params ["_pos","_dir","_size","_relpos"];

private _markervector	= _pos vectorFromTo _relpos;
_markervector	= _markervector vectorMultiply 2*(_size select 1);

private _markervector_1	= [(_markervector select 1),-(_markervector select 0),0];
_markervector_1	= vectorNormalized _markervector_1;
_markervector_1	= _markervector_1 vectorMultiply 2*(_size select 0);

// set all to the lower right corner of the marker
private _pos = _pos vectorAdd ((_markervector vectorMultiply -0.5) vectorAdd (_markervector_1 vectorMultiply -0.5));

private _mindist = (vectorMagnitude (_markervector vectorAdd _markervector_1)) / 4;

[_pos,_mindist,_markervector,_markervector_1,_dir]
