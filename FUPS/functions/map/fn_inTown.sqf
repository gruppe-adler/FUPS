/*

	This function checks whether given position is in a town.
	Position will be counted as in town when there are at least two buildings within a 25 metres radius.

	PARAMS:
		0 <ARRAY format POSITION/OBJECT> - position to check

	RETURN:
		<BOOL> - true when in town

*/

#include "..\..\header\header.hpp"

params [["_obj",objNull,[objNull,[]],[2,3]]];

count (_obj nearObjects ["Building",25]) > 1
