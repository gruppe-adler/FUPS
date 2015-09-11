params ["_group","_list"];
_group = _this select 0;
_list = _this select 1;
private "_args";
_args = [
	"SAFE",		// 0 - BEHAVIOUR:
	"LIMITED",	// 1 - SPEED:
	false,		// 2 - NOFOLLOW
	false,		// 3 - NOSHARE
	false,		// 4 - NOWAIT
	[],			// 5 - ROUTE
	objNull,	// 6 - VEHICLE:
	false,		// 7 - RANDOM
	objNull,	// 8 - SIMULATION:
	[]			// 9 - REINForCEMENT:
];
if (count _list == 2) exitWith { _args };

_list deleteAt 0; // delete leader
_list deleteAt 0; // delete marker

// convert arguments to upper
{
	if (typename _x == typename "") then { _list set [_forEachIndex,toUpper _x] };
} forEach _list;

// get behaviour
private "_index";
_index = _list find "BEHAVIOUR:";
if (_index > -1) then {
	private "_value";
	_value = [_list,_index + 1,"SAFE",[""]] call BIS_fnc_param;
	if (toUpper _value in ["SAFE","AWARE","COMBAT","STEALTH","CARELESS"]) then { _args set [0,_value] } else { ["Error: Wrong param for 'BEHAVIOUR:'",true] call FUPS_fnc_log };
	_list deleteAt _index;
	_list deleteAt _index;
};

// get speedmode
_index = _list find "SPEED:";
if (_index > -1) then {
	private "_value";
	_value = [_list,_index + 1,"LIMITED",[""]] call BIS_fnc_param;
	if (toUpper _value in ["LIMITED","NorMAL","FULL"]) then { _args set [1,_value] } else {  ["Error: Wrong param for 'SPEED:'",true] call FUPS_fnc_log };
	_list deleteAt _index;
	_list deleteAt _index;
};

// get nofollow
_index = _list find "NOFOLLOW";
if (_index > -1) then {
	_args set [2,true];
	_list deleteAt _index;
};

// get noshare
_index = _list find "NOSHARE";
if (_index > -1) then {
	_args set [3,true];
	_list deleteAt _index;
};

// get nowait
_index = _list find "NOWAIT";
if (_index > -1) then {
	_args set [4,true];
	_list deleteAt _index;
};

// get route
_index = _list find "ROUTE";
if (_index > -1) then {
	private ["_wps"];
	_wps = [_group] call FUPS_fnc_getWaypoints;
	_args set [5,_wps];
	_list deleteAt _index;
};

// get support vehicle
_index = _list find "VEHICLE:";
if (_index > -1) then {
	private "_value";
	_value = [_list,_index + 1,objNull,[objNull]] call BIS_fnc_param;
	if !(isNull _value) then { _args set [6,_value] } else { ["Error: Wrong param for 'VEHICLE:'",true] call FUPS_fnc_log };
	_List deleteAt _index;
	_list deleteAt _index;
};

// get random spawn
_index = _list find "RANDOM";
if (_index > -1) then {
	_args set [7,true];
	_list deleteAt _index;
};

// get simulation
_index = _list find "SIMULATION:";
if (_index > -1) then {
	private "_value";
	_value = [_list,_index + 1,objNull,[objNull,0]] call BIS_fnc_param;
	if !(_value isEqualTo objNull) then { _args set [8,_value] } else { ["Error: Wrong param for 'SIMULATION:'",true] call FUPS_fnc_log };
	_list deleteAt _index;
	_list deleteAt _index;
};

// get reinf areas
_index = _list find "REINForCEMENT:";
if (_index > -1) then {
	private "_value";
	_value = [_list,_index + 1,[],[[]]] call BIS_fnc_param;
	if !(_value isEqualTo []) then { _args set [9,_value] } else { ["Error: Wrong params for REINForCEMENT:",true] call FUPS_fnc_log };
	_list deleteAt _index;
	_list deleteAt _index;
};

// print all unknown params
if (count _list != 0) then {
	[["Error: unknown params given in FUPS - %1",_list],true] call FUPS_fnc_log;
};

_args
