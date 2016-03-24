/*

	Spawns the group randomly in its marker

	PARAMS:
		0 <GROUP> - the group to spawn
		1 <<OBJECT> ARRAY> - vehicles of the group

	RETURN:
		nil

	AUTHOR: [W] Fett_Li

*/

throw "Not implemented";

#include "..\..\header\header.hpp"

params ["_group","_vehicles"];

private _type = [_group] call FUPS_fnc_ai_type;
private _area = _group getVariable "FUPS_marker";

switch (_type) do {
	case (0): { // infantry
		private _pos = [_group,3,0] call FUPS_fnc_randomMarkerPos;
		{ _x setPosATL _spawnpos } forEach _vehicles;
	};
	case (1): { // land vehicle
		private _pos = [_group,count _vehicles * 15,0] call FUPS_fnc_randomMarkerPos;
		{
			private _rel = (_vehicles select 0) worldToModel (getPosATL _x);
			_rel set [2,0];
			_x setPosATL (_spawnpos vectorAdd _rel);
		} forEach _vehicles;
	};
	case (2): { // air
		private _pos = [_group,0,2] call FUPS_fnc_randomMarkerPos;
		private _height = (getPosATL vehicle leader _group) select 2;
		private _pos set [2,_height];

		// send them flying because anything other would be to risky
		{
			private _rel = (_vehicles select 0) worldToModel (getPosATL _x);
			_rel set [2,0];
			_x setPosATL (_spawnpos vectorAdd _rel);
		} forEach _vehicles;
	};
	case (3): { // ship
		private _pos = [_group,0,1] call FUPS_fnc_randomMarkerPos;
		_pos set [2,0];

		{
			private _rel = (_vehicles select 0) worldToModel (getPosATL _x);
			_rel set [2,0];
			_x setPosASL (_spawnpos vectorAdd _rel);
		} forEach _vehicles;
	};
};
