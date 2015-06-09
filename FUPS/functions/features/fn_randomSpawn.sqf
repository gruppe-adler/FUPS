/*

	Description: Spawns the group randomly in its marker

	PARAMS:
	0 <GROUP> - the group to spawn
	1 <OBJECT ARRAY> - vehicles of the group

	RETURN:
	-

	Author: [W] Fett_Li

*/

private ["_group","_type"];
_group = _this select 0;
_vehicles = _this select 1;

_type = [_group] call FUPS_fnc_g_type;

switch (_type) do {
	case (0): { // infantry
		private ["_pos","_spawnpos"];
		_pos = [_group,3,0] call FUPS_fnc_randomMarkerPos;
		_spawnpos = if (_pos isEqualTo []) then {_currpos} else {_pos};
		{ _x setPosATL _spawnpos } forEach _vehicles;
	};
	case (1): { // land vehicle
		private ["_pos","_spawnpos"];
		_pos = [_group,count _vehicles * 15,0] call FUPS_fnc_randomMarkerPos;
		_spawnpos = if (_pos isEqualTo []) then {_currpos} else {_pos};

		{
			private "_rel";
			_rel = (_vehicles select 0) modelToWorld (getPosATL _x);
			_rel set [2,0];
			_x setPosATL (_spawnpos vectorAdd _rel);
		} forEach _vehicles;
	};
	case (2): { // air
		private ["_pos","_spawnpos"];
		_pos = [_group,0,2] call FUPS_fnc_randomMarkerPos;
		_spawnpos = if (_pos isEqualTo []) then { _currpos} else {_pos};
		_spawnpos set [2,100];

		// send them flying because anything other would be to risky
		{
			private "_rel";
			_rel = (_vehicles select 0) modelToWorld (getPosATL _x);
			_rel set [2,0];
			_x setPosATL (_spawnpos vectorAdd _rel);

			private "_velocity";
			_velocity = (getPosATL _x) vectorFromTo ([getPosATL _x,1,direction _x] call FUPS_fnc_relPos);
			_velocity = _velocity vectorMultiply (getNumber (configfile >> "CfgVehicles" >> typeof _x >> "maxSpeed") / 2 /3.6);
			_x engineOn true;
			_x setVelocity _velocity;
		} forEach _vehicles;
	};
	case (3): { // ship
		private ["_pos","_spawnpos"];
		_pos = [_group,0,1] call FUPS_fnc_randomMarkerPos;
		_spawnpos = if (_pos isEqualTo []) then {_currpos} else {_spawnpos};
		_spawnpos set [2,0];

		{
			private "_rel";
			_rel = (_vehicles select 0) modelToWorld (getPosATL _x);
			_rel set [2,0];
			_x setPosASL (_spawnpos vectorAdd _rel);
		} forEach _vehicles;
	};
};