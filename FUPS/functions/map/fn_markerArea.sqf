#include "..\..\header\header.hpp"

params ["_marker"];

private _pos	= getMarkerPos _marker;
private _dir	= markerDir _marker;
private _size	= getmarkerSize _marker;
private _relpos	= [(_pos select 0) + (sin _dir), (_pos select 1) + (cos _dir),0];

[_pos,_dir,_size,_relpos]
