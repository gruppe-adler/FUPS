/*

	This function calculates the relative position in given distance and direction.

	PARAMS:
		0 <ARRAY format POSITION> - base position
		1 <SCALAR> - distance relative position should have
		2 <SCALAR> - direction of relative position

	RETURN:
		<ARRAY format POSITION> - relative position

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_pos",[0,0,0],[[]],[2,3]],["_dist",0,[0]],["_dir",0,[0]]];

[(_pos select 0) + _dist*sin _dir, (_pos select 1) + _dist*cos _dir,0]