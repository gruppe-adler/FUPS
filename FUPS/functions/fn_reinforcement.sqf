/*

	Description: orders a unit to be sent as reinforcement

	PARAMS:
	0 <OBJECT/OBJECT ARRAY/ARRAY ForMAT POSITION/ARRAY ForMAT POSITION ARRAY/STRING> - data to describe the area to be sent in
	1 <SCALAR ARRAY> - IDs of the reinforcement groups to be sent
	2 <SIDE> - the side of the reinforcement groups to be sent
	3 <BOOLEAN> - true if the units should be send regardless of their current actions
	4 <BOOLEAN> - true to let the units stay in the seized area
	5 <BOOLEAN> - true to let the units work combined (wip)

	RETURN:
	-

	Author: [W] Fett_Li

*/

params ["_targets","_rIDs","_side",["_skipVars",false],["_stayInArea",false],["_combined",true]];

if (!(typeName _targets in [typeName [],typeName objNull,typeName ""]) or typeName (_rIDs != typeName []) or !(typeName _side in [typeName sideUnknown,typeName ""])) exitWith {
	["Exiting, wrong params given",true] call FUPS_fnc_log;
};

[["Sending reinforcements to: %1",_targets]] call FUPS_fnc_log;

// create the reinforcements array
private ["_reinfGroups","_reinfArray"];
_reinfGroups = [];
_reinfArray = missionNamespace getVariable (format ["FUPS_reinforcements_%1",_side]);
{
	if (count _reinfArray > _x AND { !isNil { _reinfArray select _x } }) then {
		{
			if (!(isNull _x) AND (local leader _x) AND {!(count (units _x) == 0) AND !(_x in _reinfGroups)}) then {
				_reinfGroups pushBack _x;
			}
			else {
				[["Error: reinforcements not found for %1",_x],true] call FUPS_fnc_log;
			};
		} forEach (_reinfArray select _x);
	};
} forEach _rIDs;

// set the reinf params
private "_areaInfo";
_areaInfo = [];
if (typeName _targets == typeName "") then {
	_areaInfo = _targets call FUPS_fnc_markerData;
	_targets = [];
} else {
	_areaInfo = [_targets,50] call FUPS_fnc_coverMarker;
};

private "_params";
_params = [_areaInfo,_stayInArea,[],_targets];
if (_combined) then {
	private "_array";
	_array = [];
	{
		_array pushBack _x;
	} forEach _reinfGroups;
	_params set [2,_array];
};

{
	_grp = _x;
	if (local _grp) then {
		if (!isNil {_grp getVariable "FUPS_simulation"}) then {
			if (!simulationEnabled (leader _grp)) then {
				[_grp,true,true] call FUPS_fnc_simulation;
			};
			_grp setVariable ["FUPS_simulation",{true}];
		};

		_grp setVariable ["FUPS_reinforcementReady",false];
		{ _grp reveal _x } forEach _targets;
		[_x,"REINForCEMENT",_skipVars,_params] call FUPS_fnc_do;
	};
} forEach _reinfGroups;
