/*

	Spawns the given template or clones the given group

	PARAMS:
		0 <ARRAY FORMAT POSITION> - position to spawn
		1 <STRING> - marker to patrol in
		2 <<SCALAR/ARRAY> ARRAY/OBJECT> - array filled with indexes of units to spawn, multiple occurrents of the same index possible
		@optional 3 <ARRAY> - additional parameters for FUPS initialization
		@optional 4 <BOOLEAN> - false to suppress FUPS initialization
		@optional 5 <SCALAR> - duration to sleep between each unit spawn

	RETURN:
		<GROUP ARRAY> - array of spawned groups

	AUTHOR: [W] Fett_Li

*/

#include "..\header\header.hpp"

params [["_spawnPos",[],[[]]],["_marker","",[""]],["_templates",[],[[]]],["_params",[]],["_initFups",true],["_sleepTime",1]];

if (_spawnPos isEqualTo [] || !([0,0,0] isEqualTypeParams _spawnPos) || _marker == "" || _templates isEqualTo []) then {
	throw ILLEGALARGUMENTSEXECPTION;
};

private _count = count FUPS_templates;
private _toSpawn = [];
switch (typeName _templates) do {
	case ("ARRAY"): {
		{
			switch (typeName _x) do {
				case ("SCALAR"): {
					if (_count > _x && { !isNil { FUPS_templates select _x } }) then {
						_toSpawn pushBack (FUPS_templates select _x);
					} else {
						[["Fatal Error: Template %1 not found",_x],true,true,true] call FUPS_fnc_log;
					};
				};
				case ("ARRAY"): {
					_toSpawn pushBack _x;
				};
			};
		} forEach _templates;
	};
	case ("OBJECT"): {
		_templates = [[group _templates,-1] call FUPS_fnc_saveTemplate];
	};
};

private _spawnPosCount = -1; // will get incremented right away, so start with -1
private _spawned = []; // saves spawned leaders
{
	_x params ["_side","_units"];

	// create new group
	_grp = createGroup _side;

	[["Spawning group: %1",_grp],true,false,ENVIROMENT_LOG] call FUPS_fnc_log;

	_grp setBehaviour "SAFE";
	_grp setSpeedMode "LIMITED";

	{
		_x params ["_type","_skill"];

		if (_type isKindOf "Man") then {
			_unit = _grp createUnit [_type,_spawnPos,[],4,"NONE"];
			_unit setSkill _skill;
		} else {
			_spawnPosCount = _spawnPosCount + 1;
			_multiplier = ceil (_spawnPosCount / 11);
			_pos = [_spawnPos,(_multiplier * 20),(_spawnPosCount * 30)] call FUPS_fnc_relPos;

			_special = ["NONE","FLY"] select (_type isKindOf "Air");
			_veh = createVehicle [_type,_pos,[],0,_special];
			createVehicleCrew _veh;
			(commander _veh) setSkill _skill;
			(crew _veh) joinSilent _grp;
		};
		if (_sleepTime > 0) then {sleep _sleepTime};
	} forEach _units;

	// init the new group
	_spawned pushBack _grp;

	if (_initFUPS) then {
		_initParams = [(leader _grp),_marker];
		_initParams append _params;
		_initParams call FUPS_fnc_main;
	};
} forEach _toSpawn;

_spawned
