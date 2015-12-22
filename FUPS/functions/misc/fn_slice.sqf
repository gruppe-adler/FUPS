#include "..\..\header\header.hpp"

params ["_array",["_from",0],["_to",count _array]];

private _count = count _array - _from;
_to = _to - _from;

_array = +_array;
reverse _array;
_array resize _count;
reverse _array;

_array resize _to;

_array
