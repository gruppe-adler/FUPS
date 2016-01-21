/*

    Description: Generates a new waypoint for the given group

    PARAMS:
    	0 <GROUP> - the group to generate for
    	@optinal 1 <ARRAY format AREA> default "FUPS_marker" - area to generate the waypoint in

    RETURN:
    	<ARRAY format POSITION> - the new waypoint

    Author: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]],["_area",AREA_VAL,[AREA_VAL]]];
if (_area isEqualTo AREA_VAL) then { _area = _group getVariable "FUPS_marker" };
if !AREA_VALID(_area) throw ILLEGALARGUMENTSEXCEPTION;

private _type = [_group] call FUPS_fnc_ai_type;
private _allowWater = [0,0,2,1] select _type;
private _pos = [_group,0,_allowWater,_area] call FUPS_fnc_randomMarkerPos;

if (_type == 1) then {
	private _roads = _pos nearRoads 250;
	if !(_roads isEqualTo []) then {_pos = getPosATL (_roads select 0)};
};

_pos
