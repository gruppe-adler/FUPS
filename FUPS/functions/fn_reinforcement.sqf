/*

	Orders groups of reinforcement to attack the given things. Only groups that have been added to a reinforcement array can be called as reinforcements.

	PARAMS:
		0 <(<OBJECT> ARRAY)/(<ARRAY FORMAT POSITION> ARRAY)/STRING/OBJECT/TRIGGER> - data to describe the area to be sent in
		1 <SCALAR ARRAY> - IDs of the reinforcement groups to be sent
		2 <SIDE> - the side of the reinforcement groups to be sent
		@optional 3 <BOOLEAN> - true if the units should be send regardless of their current actions, default false
		@optional 4 <BOOLEAN> - true to let the units stay in the seized area, default false
		@optional 5 <BOOLEAN> - true to let the units work combined, default true --- ToDo

	RETURN:
		nil

	AUTHOR: [W] Fett_Li

*/

#include "..\header\header.hpp"

params [["_targets",[],["",objNull,[]]],["_rIDs",[],[[]]],["_side",sideUnknown,[sideUnknown]],["_force",false,[true]],["_stayInArea",false,[true]],["_combined",true,[true]]];

if (_targets isEqualTo [] || _targets isEqualTo objNull || _targets isEqualTo "" || _rIDs isEqualTo [] || _side isEqualTo sideUnknown) throw ILLEGALARGUMENTSEXCEPTION;

[["Sending reinforcements to: %1",_targets],true,false,ACTIONS_LOG] call FUPS_fnc_log;

// create the reinforcements array
private _reinfGroups = [];
private _reinfArray = FUPS_reinforcements select (FUPS_sideOrder find _side);
{
	_reinfGroups append (_reinfArray param [_x,[]]);
} forEach _rIDs;

// Create the marker to seize
private _areaInfo = [];
private _revealTargets = [];

if (_targets isEqualType objNull) then {
	if (_targets isKindOf "EmptyDetector") then {
		_areaInfo = [_targets] call FUPS_fnc_markerData;
	} else {
		_areaInfo = [[_targets],50] call FUPS_fnc_coverMarker;
		_revealTargets = [_targets];
	};
};

if (_targets isEqualType "") then {
	_areaInfo = [_targets] call FUPS_fnc_markerData;
};

if (_targets isEqualType []) then {
	_areaInfo = [_targets,50] call FUPS_fnc_coverMarker;
	_revealTargets = _targets;
};

// --- ToDo
// Do the groups act combined?
// _combined = if (_combined) then {_reinfGroups} else {[]};

// Order the reinforcements to begin
{
	private _grp = _x;

	// Handle disabled simulation
	if (!isNil {_grp getVariable "FUPS_simulation"}) then {
		if (!simulationEnabled (leader _grp)) then {
			[_grp,true,true] call FUPS_fnc_simulation;
		};
		_grp setVariable ["FUPS_simulation",{true}];
	};

	_grp setVariable ["FUPS_reinforcementReady",false];
	_grp setVariable ["FUPS_reinfInfo",[_areaInfo,_stayInArea,[],_revealTargets]];
	[_grp,"FUPS_fnc_task_reinf",_force] call FUPS_fnc_do;
} forEach _reinfGroups;
