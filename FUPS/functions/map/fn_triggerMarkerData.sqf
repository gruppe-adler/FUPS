#include "..\..\header\header.hpp"

params ["_trigger"];

private _pos	= getPos _trigger;
private _size	= triggerArea _trigger;
private _dir	= _size select 2;
_size resize 2;
private _relpos	= [(_pos select 0) + (sin _dir), (_pos select 1) + (cos _dir),0];

[_pos,_dir,_size,_relpos]
