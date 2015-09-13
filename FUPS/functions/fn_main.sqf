/*

	Description: This function will initialize a group with FUPS

	PARAMS:
	0 <OBJECT> - leader of the group
	1 <STRING> - the marker to patrol in
	. <?> - various other arguments

	RETURN:
	-

	Author: [W] Fett_Li

*/

params ["_leader","_marker"];

private "_group";
_group = group _leader;
_leader = leader _group;

if (!local _leader) exitWith {};

// Start AI calculation if not allready done
if (isNil "FUPS_oefHandler") then {
	FUPS_oefHandler = ["FUPS_oef","onEachFrame",FUPS_fnc_mainHandler,0] call BIS_fnc_addStackedEventhandler;
};

_group setVariable ["FUPS_marker",([_marker] call FUPS_fnc_markerData)];

private "_settings";
_settings = [_group,+_this] call FUPS_fnc_getParams;

private "_behaviour";
_behaviour = _settings select 0;
_group setBehaviour _behaviour;
_group setVariable ["FUPS_orgMode",_behaviour];

private "_speed";
_speed = _settings select 1;
_group setSpeedMode _speed;
_group setVariable ["FUPS_orgSpeed",_speed];

private "_nofollow";
_nofollow = _settings select 2;
_group setVariable ["FUPS_nofollow",_nofollow];

private "_noshare";
_noshare = _settings select 3;
_group setVariable ["FUPS_doShare",!_noshare];

private "_nosupport";
_nosupport = _settings select 4;
_group setVariable ["FUPS_doSupport",!_nosupport];

private "_nowait";
_nowait = _settings select 5;
_group setVariable ["FUPS_wait",!_nowait];

private "_route";
_route = _settings select 6;
_group setVariable ["FUPS_route",_route];
_group setVariable ["FUPS_routeIndex",0];

private "_vehicle";
_vehicle = _settings select 7;
_group setVariable ["FUPS_vehicle",_vehicle];

private "_randomSpawn";
_randomSpawn = _settings select 8;
if (_randomSpawn) then {
	[_group,_vehicles] call FUPS_fnc_randomSpawn;
};

private "_simulation";
_simulation = _settings select 9
_group setVariable ["FUPS_simulation",{true}];
if ((typename _simulation == typename objNull AND {!isNull _simulation})) then {
	private "_fnc";
	_fnc = {
		triggerActivated ((_this select 0) getVariable "FUPS_simulation_trigger");
	};
	_group setVariable ["FUPS_simulation",_fnc];
};
if (typename _simulation == typename 0) then {
	private "_fnc";
	_fnc = {
		private ["_leader","_dist"];
		_leader = leader (_this select 0);
		_dist = _group getVariable "FUPS_simulation_dist";
		{_leader distance _x < _dist} count FUPS_players > 0;
	};

	if (_simulation > 0) then {
		_group setVariable ["FUPS_simulation_dist",_simulation];
	}
	else {
		_group setVariable ["FUPS_simulation_dist",FUPS_simulation_dist];
	};

	_group setVariable ["FUPS_simulation",_fnc];
};

private "_reinforcement";
_reinforcement = _settings select 10;
if (count _reinforcement > 0) then {
	// Remove duplicates
	_reinforcement = _reinforcement arrayIntersect _reinforcement;

	private ["_sideIndex","_reinfArray"];
	_sideIndex = [west,east,independent] find (side _group);
	_reinfArray = FUPS_reinforcements select _side;

	{
		// If this array isn't initialized
		if (isNil {_reinfArray param [_x]}) then {
			_reinfArray set [_x,[]];
		};

		(_reinfArray select _x) pushBack _group;
	} forEach _reinforcement;
};

private ["_closeenough","_typeName","_allowWater"];
_closeenough = 7;
_typeName = "_man";
_allowWater = false;
switch ([_group] call FUPS_fnc_ai_type) do {
	case 1: {
		_closeenough = 20;
		_typeName = "_vehicle";
	};
	case 2: {
		_closeenough = 50;
		_typeName = "_air";
		_allowWater = true;
	};
	case 3: {
		_closeenough = 20;
		_typeName = "_ship";
		_allowWater = true;
	};
};
_group setVariable ["FUPS_closeenough",_closeenough];
_group setVariable ["FUPS_typeName",_typeName];
_group setVariable ["FUPS_allowWater",_allowWater];

// Initializing generic varaibles
_group setVariable ["FUPS_break",{true}];
_group setVariable ["FUPS_task",""];
_group setVariable ["FUPS_orders",[]];
_group setVariable ["FUPS_clockPulse",-1];
_group setVariable ["FUPS_lastDamage",0];
_group setVariable ["FUPS_target",objNull];
_group setVariable ["FUPS_askedForSupport",[]];

[["Adding %1",_group]] call FUPS_fnc_log;
FUPS_oefGroups_toAdd pushBack _group;
