private ["_params","_group","_fsm","_currpos"];
_params = _this;
_group = _params select 1;
_fsm = _params select 2;
_currpos = getPosATL leader _group;

private "_settings";
_settings = _group getVariable "FUPS_settings";
if (isNil "_settings") exitWith {["Error: FUPS not initialized (no settings)",true] call FUPS_fnc_log};
_closeenough = _settings select 12;

_group setBehaviour "AWARE";
_group setBehaviour "NORMAL";

private ["_reinfParams","_areainfo","_stayInArea","_combinedGroups","_enemies"];
_reinfParams = _params select 0;
_areainfo = _reinfParams select 0;
_stayInArea = _reinfParams select 1;
_center = (_areainfo select 0) vectorAdd ((_areainfo select 2) vectorMultiply 0.5) vectorAdd ((_areainfo select 3) vectorMultiply 0.5);
_combinedGroups = _reinfParams select 2;
_enemies = _reinfParams select 3;

[_group,_areainfo] call FUPS_fnc_setPatrolMarker;

private "_waitfnc";
_waitfnc = {
	_exit = false;
	while (_this select 0) do {
		if (_params select 7) exitWith {_exit = true}; // _gothit
	};
	_exit
};

{
	private "_sol";
	_sol = _x;
	{_sol reveal _x} forEach _enemies;
} forEach (units _group);

private ["_pos","_dist","_dir"];
_pos = _currpos;
_dist = vectorMagnitude (_center vectorDiff _currpos);
_dir = [_currpos,_center] call FUPS_fnc_getDir;
if !(([_areainfo,_dir] call FUPS_fnc_recMarkerRad) + 300 < _dist) then { // if not allready to close to area
	_pos = _center vectorFromTo _currpos;
	_pos = _pos vectorMultiply (300 + [_areainfo,_dir] call FUPS_fnc_recMarkerRad);
	_group move _pos;
};

private "_gothit";
_gothit = [{ leader _group distance _pos < _closeenough }] call _waitfnc;
_group setVariable ["FUPS_reinfReady",true];
if (_gothit) exitWith { // got hit while in approach

};

[{ {!(_x getVariable ["FUPS_reinfReady",false])} count _combinedGroups == 0 }] call _waitfnc;

if !(_stayInArea) then {
	_this spawn {
		private ["_params","_aerainfo","_stayInArea"];
		_params = _this select 0;
		_areaInfo = _params select 0;
		_stayInArea = _params select 1;

		private "_group";
		_group = _this select 1;
		waitUntil {[getPosATL leader _group,_areainfo] call FUPS_fnc_posInMarker || _this select 20 == "RETREAT" };
		if (_this select 20 == "RETREAT") exitWith {[_group,(_group getVariable "FUPS_orgMarker")] call FUPS_fnc_setPatrolMarker};

		private "_time";
		_time = time + 600;
		while {time < _time} do {
			if (_this select _maxknowledge > 0) then {_time = time + 600};
			sleep 10;
		};

		// return to old marker
		[_group,(_group getVariable "FUPS_orgMarker")] call FUPS_fnc_setPatrolMarker;
	};
};
