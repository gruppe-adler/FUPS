scopeName _fnc_scriptName;

params ["_group","_target"];
private "_moveQueue";
_moveQueue = _group getVariable "FUPS_moveQueue";

private "_movePos";
_movePos = _group getVariable "FUPS_movePos";
if !(isNil "_movePos") then {
	// --- ToDo: apply waiting time
	if (leader _group distance _movePos > _group getVariable "FUPS_closeEnough" || (true)) then {
		_movePos breakOut _fnc_scriptName;
	};
};

if !(_moveQueue isEqualTo []) exitWith { _moveQueue deleteAt 0 };

[_group] call ([_target] call FUPS_fnc_getRoutePlaning);
