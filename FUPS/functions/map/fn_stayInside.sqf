/*

	This function limits a given position on a straight line from the area center position to the area. The position will be "shoved" along this line until it is in the area.

	PARAMS:
		0 <GROUP> - group the area belongs to
		1 <ARRAY format POSITION> - position to limit into area

	RETURN:
		<ARRAY format POSITION> - limited position, if params position was in area it will remain the same

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_group",grpNull,[grpNull]],["_pos",[0,0,0],[[]],[2,3]]];

private _area = _group getVariable "FUPS_marker";
if !AREA_VALID(_area) throw ILLEGALARGUMENTSEXCEPTION;
AREA_PARAMS(_area); // _origin, _mindist, _xAxis, _yAxis, _dir

if ([_pos,_area] call FUPS_fnc_posInMarker) exitWith { _pos };

private _posDir		= acos (([0,1,0]) vectorCos (_pos vectorDiff _origin));
private _rotX		= [_origin,vectorMagnitude _xVector,90] call FUPS_fnc_relPos;
private _rotY		= [_origin,vectorMagnitude _yVector,0] call FUPS_fnc_relPos;
_pos				= [_origin,vectorMagnitude (_pos vectorDiff _origin),(_posDir - _dir)] call FUPS_fnc_relPos;

_pos set [0,((_rotX select 0) min (_pos select 0)) max (_origin select 0)];
_pos set [1,((_rotY select 1) min (_pos select 1)) max (_origin select 1)];

_posDir		= acos (([0,1,0]) vectorCos (_pos vectorDiff _origin));
[_origin,vectorMagnitude (_origin vectorDiff _pos),(_dir+_posDir)] call FUPS_fnc_relPos
