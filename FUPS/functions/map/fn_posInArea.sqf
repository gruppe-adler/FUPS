/*

	This function returns whether given position is in given area.

	PARAMS:
		0 <ARRAY format AREA> - area to check
		1 <ARRAY format POSITION> - position

	RETURN:
		<BOOL> - true if position is in area to check

	AUTHOR: [W] Exolas

*/

#include "..\..\header\header.hpp"

params [["_area",[],[[]],5],["_pos",[0,0,0],[[]],[2,3]]];
_area params ["_origin","_mindist","_yAxis","_xAxis","_dir"];

_pos inPolygon [
	_origin,
	_origin vectorAdd _xAxis,
	_origin vectorAdd _yAxis,
	_origin vectorAdd _xAxis vectorAdd _yAxis
];
