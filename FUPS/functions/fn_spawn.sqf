/*

	Description: Spawns the given template or clones the given group

	PARAMS:
	0 <ARRAY FORMAT POSITION> - position to spawn
	1 <STRING> - marker to patrol in
	2 <SCALAR ARRAY> - array filled with indexes of units to spawn, multiple occurrents of the same index possible
	3 <ARRAY> - additional parameters for FUPS initialization
	4 <BOOLEAN> - false to suppress FUPS initialization
	5 <SCALAR> - duration to sleep between EACH spawn

	RETURN:
	<GROUP ARRAY> - array of spawned groups

	Author: [W] Fett_Li

*/

private ["_spawnPos","_marker","_templates","_params","_initFups","_spawnPosCount","_spawned","_leaders"];

_spawnPos		= [_this,0,[],[[]]]			call BIS_fnc_param;
_marker			= [_this,1,"",[""]]			call BIS_fnc_param;
_templates		= [_this,2,[],[[],objNull]]	call BIS_fnc_param;
_params			= [_this,3,[],[[]]]			call BIS_fnc_param;
_initFUPS		= [_this,4,true,[true]]		call BIS_fnc_param;
_sleepTime		= [_this,5,2,[0]]			call BIS_fnc_param;

if (_spawnPos isEqualTo [] || (_marker == "" && _initFUPS) || _templates isEqualTo []) exitWith { ["Error: wrong params"] call FUPS_fnc_log; [] };

private "_count";
_count = count FUPS_templates;
switch (typeName _templates) do {
	case ("ARRAY"): {
		{
			_data = [];
			if (_count > _x && { !isNil { FUPS_templates select _x } }) then {
				_data = FUPS_templates select _x;
			};
			_templates set [_forEachIndex,_data];
		} forEach _templates;
	};
	case ("OBJECT"): {
		_templates = [[group _templates,-1] call FUPS_fnc_saveTemplate];
	};
};

_spawnPosCount	= -1; // will get incremented right away, so start with -1
_spawned		= []; // saves spawned leaders
{
	// create new group
	_grp = createGroup (_x select 0);

	[["Spawning group: %1",_grp]] call FUPS_fnc_log;

	_grp setBehaviour "SAFE";
	_grp setSpeedMode "LIMITED";
	{
		if ((_x select 0) isKindOf "Man") then {
			_unit = _grp createUnit [(_x select 0),_spawnPos,[],0,"NONE"];
			_unit setSkill (_x select 1);
		} else {
			_spawnPosCount = _spawnPosCount + 1;
			_multiplier = ceil (_spawnPosCount / 11);
			_pos = [_spawnPos,(_multiplier * 20),(_spawnPosCount * 30)] call FUPS_fnc_relPos;

			_special = ["NONE","FLY"] select ((_x select 0) isKindOf "Air");
			_veh = createVehicle [(_x select 0),_pos,[],0,_special];
			createVehicleCrew _veh;
			(commander _veh) setSkill (_x select 1);
			(crew _veh) joinSilent _grp;
		};
	} forEach (_x select 1);

	// init the new group
	_spawned pushBack _grp;

	if (_initFUPS) then {
		_initParams = [(leader _grp),_marker] + _params;
		(+_initParams) spawn FUPS_fnc_main;
	};

	sleep _sleepTime;
} forEach _templates;

_spawned
