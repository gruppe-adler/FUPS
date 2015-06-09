private ["_group","_fsm","_directions","_currpos"];
_group = _this select 1;
["Retreating"] call FUPS_fnc_log;
_fsm = _this select 2;
_directions = _this select 19;
_currpos = getPosATL leader _group;

private ["_settings","_closeenough"];
_settings = _group getVariable "FUPS_settings";
if (isNil "_settings") exitWith {["Error: FUPS not initialized (no settings)",true] call FUPS_fnc_log};
_closeenough = _settings select 12;

private "_escaping";
_escaping = true;
while {_escaping} do {
	private ["_escapeDir","_escapePos"];
	_escapeDir = _directions call FUPS_fnc_escapeDirection;
	_escapePos = [_currpos,300,_escapeDir] call FUPS_fnc_relPos;

	if !(completedFSM _fsm) then {
		[_fsm,_escapePos] call FUPS_fnc_combinedEmbark;
	} else {
		_group move _escapePos;
	};
	waituntil { leader _group distance _escapePos < _closeenough };

	// _nearEnemies isEqualTo []
	if (_this select 13 isEqualTo []) then {_escaping = false};
};

if !(completedFSM _fsm) then {[_fsm] call FUPS_fnc_combinedDisembark};

[_group,"HOLD"] call FUPS_fnc_do;
