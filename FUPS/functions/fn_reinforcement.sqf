/*

	Description: orders a unit to be sent as reinforcement

	PARAMS:
	0 <OBJECT/OBJECT ARRAY/ARRAY FORMAT POSITION/ARRAY FORMAT POSITION ARRAY/STRING> - data to describe the area to be sent in
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

if (isNil "_targets" || isNil "_rIDs" || isNil "_side") exitWith {
	["Exiting, wrong params given",true,true] call FUPS_fnc_log;
};

[["Sending reinforcements to: %1",_targets]] call FUPS_fnc_log;

// create the reinforcements array
private ["_reinfGroups","_reinfArray"];
_reinfGroups = [];
_reinfArray = FUPS_reinforcements select (FUPS_sideOrder find _side);
{
	_reinfGroups append (_reinfArray param [_x,[]]);
} forEach _rIDs;

// Create the marker to seize
private "_areaInfo";
_areaInfo = [];
if (typeName _targets == typeName "") then {
	_areaInfo = _targets call FUPS_fnc_markerData;
	_targets = [];
} else {
	_areaInfo = [_targets,50] call FUPS_fnc_coverMarker;
};

// Do the groups act combined?
_combined = if (_combined) then {_reinfGroups} else {[]};

// Order the reinforcements to begin
{
	private "_grp";
	_grp = _x;

	// Handle disabled simulation
	if (!isNil {_grp getVariable "FUPS_simulation"}) then {
		if (!simulationEnabled (leader _grp)) then {
			[_grp,true,true] call FUPS_fnc_simulation;
		};
		_grp setVariable ["FUPS_simulation",{true}];
	};

	_grp setVariable ["FUPS_reinforcementReady",false];
	{ _grp reveal _x } forEach _targets;
	_grp setVariable ["FUPS_reinfInfo",[_areaInfo,_stayInArea,_combined,_targets]];
	[_grp,"FUPS_fnc_task_reinf",_skipVars] call FUPS_fnc_do;
} forEach _reinfGroups;
