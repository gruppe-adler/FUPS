
/*

	This function will initialize a group with FUPS.

	PARAMS:
	0 <OBJECT> - leader of the group
	1 <STRING> - the marker to patrol in
	@optional 2...* <?> - various other arguments

	Available arguments:
		"BEHAVIOUR:",X - sets the default behaiour of the group to X, can be "SAFE", "AWARE", "CARELESS", "COMBAT", "STEALTH"

		"SPEED:",X - sets the default speedmode of the group to X, can be "LIMITED", "NORMAL", "FULL"

		"NOSHARE" - disables the group to share information about known enemies with other groups

		"NOSUPPORT" - disables the group to receive information about known enemies from other groups

		"NOWAIT" - disables for the group to wait for a while after a waypoint was reached

		"ROUTE" - this parameter sets the groups route. When given, the group will patrol given waypoints until the end or a cycle is reached. If the end is reached, it will patrol randomly in the given marker area. If a cycle waypoint is reached, it will start again from the nearest waypoint. By this you can set a route for a group to patrol. When an enemy is detected it will attack it normaly, etc. but return to the waypoints after combat is finished.

		"RANDOM" - this will randomize the groups position on FUPS initialization in the given marker area. Does take into account proper space for vehicles, etc.

		"SIMULATION:",X - disables the the simulation of this group in some cases. If X is a trigger simulation is activated if it the trigger is activated. If it is a number simulation is activeated if there are players within X range to the group.

		"REINFORCEMENT:",X - adds the group to the reinforcement groups X. X must be an array containing indexes.

	RETURN:
		nil

	Author: [W] Fett_Li

*/

#include "..\header\header.hpp"

params [["_leader",objNull,[objNull,grpNull]],["_marker","",[""]]];

if (isNull _leader ||_marker == "") throw ILLEGALARGUMENTSEXCEPTION;
if (markerType _marker == "") throw NOSUCHMARKEREXCEPTION(_marker);

private _group = if (_leader isEqualType objNull) then {group _leader} else {_leader};
_leader = leader _group;

if !(local _leader) exitWith {};

// Start AI calculation if not allready done
if (isNil "FUPS_oefHandler") then {
	FUPS_oefHandler = ["FUPS_oef","onEachFrame",FUPS_fnc_mainHandler,0] call BIS_fnc_addStackedEventhandler;
};

_group setVariable ["FUPS_marker",([_marker] call FUPS_fnc_markerData)];

private _settings = [_group,+_this] call FUPS_fnc_getParams;

private _behaviour = _settings select 0;
_group setBehaviour _behaviour;
_group setVariable ["FUPS_orgMode",_behaviour];

private _speed = _settings select 1;
_group setSpeedMode _speed;
_group setVariable ["FUPS_orgSpeed",_speed];

// -- ToDo
/*
private _nofollow = _settings select 2;
_group setVariable ["FUPS_nofollow",_nofollow];
*/

private _noshare = _settings select 3;
_group setVariable ["FUPS_doShare",!_noshare];

private _nosupport = _settings select 4;
_group setVariable ["FUPS_doSupport",!_nosupport];

private _nowait = _settings select 5;
_group setVariable ["FUPS_wait",!_nowait];

private _route = _settings select 6;
_group setVariable ["FUPS_route",_route];
_group setVariable ["FUPS_routeIndex",0];

// --- ToDo
/*
private _vehicle = _settings select 7;
_group setVariable ["FUPS_vehicle",_vehicle];
*/

// --- ToDo
/*private _randomSpawn = _settings select 8;
if (_randomSpawn) then {
	[_group,([_group] call FUPS_fnc_groupVehicles)] call FUPS_fnc_randomSpawn;
};*/

private _simulation = _settings select 9;
_group setVariable ["FUPS_simulation",{true}];
if ((_simulation isEqualType objNull && {!isNull _simulation})) then {
	private _fnc = {
		triggerActivated ((_this select 0) getVariable "FUPS_simulation_trigger");
	};
	_group setVariable ["FUPS_simulation",_fnc];
};
if (_simulation isEqualType 0) then {
	private _fnc = {
		private _leader = leader (_this select 0);
		private _dist = _group getVariable "FUPS_simulation_dist";
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

private _reinforcement = _settings select 10;
if (count _reinforcement > 0) then {
	// Remove duplicates
	_reinforcement = _reinforcement arrayIntersect _reinforcement;

	private _sideIndex = sideIndex(_group);
	private _reinfArray = FUPS_reinforcements select _sideIndex;

	{
		// If this array isn't initialized
		if (isNil {_reinfArray param [_x,nil]}) then {
			_reinfArray set [_x,[]];
		};

		(_reinfArray select _x) pushBack _group;
	} forEach _reinforcement;
};

private _closeenough = 7;
private _typeName = "_man";
private _allowWater = false;
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
_group setVariable ["FUPS_members",count units _group];
_group setVariable ["FUPS_break",{true}];
_group setVariable ["FUPS_task",""];
_group setVariable ["FUPS_orders",[]]; // --- ToDo: make ad
// _group setVariable ["FUPS_moveQueue",[]]; // --- ToDo: use with new task system
_group setVariable ["FUPS_clockPulse",-1];
_group setVariable ["FUPS_lastDamage",0];
_group setVariable ["FUPS_panic",0];
_group setVariable ["FUPS_target",objNull];
_group setVariable ["FUPS_askedForSupport",[]];
_group setVariable ["FUPS_revealMap",[[],[]]]; // --- ToDo: make ad
// Check for existence because eh could have been added before initializing
if (isNil {_group getVariable "FUPS_onTaskEhs"}) then {
	_group setVariable ["FUPS_onTaskEhs",[]];
};

// Add panic eventhandlers
if (FUPS_panic_enabled) then {
	{
		_x addEventHandler ["Killed",{
			params ["_unit"];
			[_unit,FUPS_panic_killed] call FUPS_fnc_raisePanic;
		}];

		_x addEventHandler ["Explosion",{
			params ["_unit"];
			[_unit,FUPS_panic_explosion] call FUPS_fnc_raisePanic;
		}];

		_x addEventHandler ["FiredNear",{
			params ["_unit","_firer"];
			if (_unit == leader _unit && side _firer getFriend side _unit < 0.6) then {
				[_unit,FUPS_panic_firedNear] call FUPS_fnc_raisePanic;
			};
		}];

		_x addEventHandler ["Hit",{
			params ["_unit"];
			[_unit,FUPS_panic_hit] call FUPS_fnc_raisePanic;
		}];
	} forEach (units _group);
};

_group enableDynamicSimulation false;

["Adding",false,false,ENVIROMENT_LOG] call FUPS_fnc_log;
FUPS_oefGroups_toAdd pushBack _group;
