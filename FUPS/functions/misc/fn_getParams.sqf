/*

	Parses all FUPS parameters of an array.
	Not-matched parameters will be printed afterwards.

	PARAMS:
		0 <GROUP> - group to parse for.
		1 <ARRAY> - array to parse from.

	RETURN:
		<ARRAY> - array with settings values

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params ["_group","_list"];

private _args = [
	"SAFE",		// 0 - BEHAVIOUR:
	"LIMITED",	// 1 - SPEED:
	false,		// 2 - NOFOLLOW --- ToDo
	false,		// 3 - NOSHARE
	false,		// 4 - NOSUPPORT
	false,		// 5 - NOWAIT
	[],			// 6 - ROUTE
	objNull,	// 7 - VEHICLE: --- ToDO
	false,		// 8 - RANDOM
	objNull,	// 9 - SIMULATION:
	[]			// 10 - REINFORCEMENT:
];
if (count _list == 2) exitWith { _args };

_list deleteAt 0; // delete leader
_list deleteAt 0; // delete marker

// convert arguments to upper
{
	if (_x isEqualType "") then { _list set [_forEachIndex,toUpper _x] };
} forEach _list;

// get behaviour
private _index = _list find "BEHAVIOUR:";
if (_index > -1) then {
	private _value = _list param [_index + 1,"SAFE",[""]];
	if (toUpper _value in ["SAFE","AWARE","COMBAT","STEALTH","CARELESS"]) then { _args set [0,_value] } else { ["Error: Wrong param for 'BEHAVIOUR:'",false,true,true] call FUPS_fnc_log };
	_list deleteAt _index;
	_list deleteAt _index;
};

// get speedmode
_index = _list find "SPEED:";
if (_index > -1) then {
	private _value = _list param [_index + 1,"LIMITED",[""]];
	if (toUpper _value in ["LIMITED","NorMAL","FULL"]) then { _args set [1,_value] } else {  ["Error: Wrong param for 'SPEED:'",false,true,true] call FUPS_fnc_log };
	_list deleteAt _index;
	_list deleteAt _index;
};

// get nofollow --- ToDo
/*
_index = _list find "NOFOLLOW";
if (_index > -1) then {
	_args set [2,true];
	_list deleteAt _index;
};
*/

// get noshare
_index = _list find "NOSHARE";
if (_index > -1) then {
	_args set [3,true];
	_list deleteAt _index;
};

// get nosupport
_index =_list find "NOSUPPORT";
if (_index > -1) then {
	_args set [4,true];
	_list deleteAt _index;
};

// get nowait
_index = _list find "NOWAIT";
if (_index > -1) then {
	_args set [5,true];
	_list deleteAt _index;
};

// get route
_index = _list find "ROUTE";
if (_index > -1) then {
	private _wps = [_group] call FUPS_fnc_getWaypoints;
	_args set [6,_wps];
	_list deleteAt _index;
};

// get support vehicle --- ToDo
/*
_index = _list find "VEHICLE:";
if (_index > -1) then {
	private _value = _list param [_index + 1,objNull,[objNull]];
	if !(isNull _value) then { _args set [7,_value] } else { ["Error: Wrong param for 'VEHICLE:'",false,true,true] call FUPS_fnc_log };
	_List deleteAt _index;
	_list deleteAt _index;
};
*/

// get random spawn
_index = _list find "RANDOM";
if (_index > -1) then {
	_args set [8,true];
	_list deleteAt _index;
};

// get simulation
_index = _list find "SIMULATION:";
if (_index > -1) then {
	private _value = _list param [_index + 1,objNull,[objNull,0]];
	if !(_value isEqualTo objNull) then { _args set [9,_value] } else { ["Error: Wrong param for 'SIMULATION:'",false,true,true] call FUPS_fnc_log };
	_list deleteAt _index;
	_list deleteAt _index;
};

// get reinf areas
_index = _list find "REINFORCEMENT:";
if (_index > -1) then {
	private _value = _list param [_index + 1,[],[[]]];
	if !(_value isEqualTo []) then { _args set [10,_value] } else { ["Error: Wrong params for REINFORCEMENT:",false,true,true] call FUPS_fnc_log };
	_list deleteAt _index;
	_list deleteAt _index;
};

// print all unknown params
if (count _list != 0) then {
	[["Error: unknown params given in FUPS - %1",_list],true,true,true] call FUPS_fnc_log;
};

_args
