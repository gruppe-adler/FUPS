/*

	Description: Orders a unit to be sent as reinforcement

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


private ["_areaInfo","_targets","_rIDs","_side","_skipVars","_stayInArea","_reinfGroups","_groups_str","_markerName","_sideStr","_sidePlayerStr","_array","_centerPos","_markerSizeA","_markerSizeB","_marker","_angle","_reinfTrigger","_enemyTrigger","_nil"];

_targets	= [_this,0,[],[[],""]]		call BIS_fnc_param;
_rIDs		= [_this,1,[],[[]]]			call BIS_fnc_param;
_side		= [_this,2,"",["",sideUnknown]]	call BIS_fnc_param;
_skipVars	= [_this,3,false,[true]]	call BIS_fnc_param;
_stayInArea	= [_this,4,false,[true]]	call BIS_fnc_param;
_combined	= [_this,5,true,[true]]		call BIS_fnc_param;

if ((_targets isEqualTo []) || (_rIDs isEqualTo []) || (typename _side == "STRING" && { _side == "" })) exitWith { "exiting, wrong params given" call FUPS_fnc_error; };

[["Sending reinforcements to: %1",_targets]] call FUPS_fnc_log;

// create the reinforcements array
_reinfGroups = [];
_reinfArray = missionNamespace getVariable (format ["FUPS_reinforcements_%1",_side]);
_countReinf	= count _reinfArray;
{
	if (_countReinf > _x && { !isNil { _reinfArray select _x } }) then {
		{
			if (!(isNull _x) && (local leader _x) && {!(count (units _x) == 0) && !(_x in _reinfGroups)}) then {
				_reinfGroups pushBack _x;
			};
		} forEach (_reinfArray select _x);
	};
} forEach _rIDs;

// set the reinf params
if (typeName _targets == typeName "") then {
	_areaInfo = _targets call FUPS_fnc_markerData;
	_targets = [];
} else {
	_areaInfo = [_targets,50] call FUPS_fnc_coverMarker
};

_params = [_areaInfo,_stayInArea,[],_targets];
if (_combined) then {
	_array = [];
	{
		_array pushBack _x;
	} forEach _reinfGroups;
	_params set [2,_array];
};

{
	_grp = _x;
	systemchat str leader _x;
	if (local _grp) then {
		if !(isNull (_grp getVariable ["FUPS_simulationTrigger",objNull])) then {
			_array = ((_grp getVariable "FUPS_simulationTrigger") getVariable "FUPS_simulationGroups");
			 _array deleteAt (_array find _grp);

			[_grp,true,true] call FUPS_fnc_simulation;
		};
		_grp setVariable ["FUPS_reinforcementReady",false];
		{ _grp reveal _x } forEach _targets;
		[_x,"REINFORCEMENT",_skipVars,_params] call FUPS_fnc_do;
	};
} forEach _reinfGroups;
