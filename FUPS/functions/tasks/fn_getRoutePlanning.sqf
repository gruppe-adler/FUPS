scopeName _fnc_scriptName;
params ["_target"];
if (typeName _target == "OBJECT") then { _target = typeOf _target };
if (typeName _target != "STRING") then { _target = typename _target };

FUPS_routePlaningPatterns params ["_types","_patterns"];

private "_index";
_index = _types find _target;
if (_index >= 0) exitWith { _patterns select _index };

{
	if (_target isKindOf _x || _target == _x) then {
		(_patterns select _forEachIndex) breakOut _fnc_scriptName;
	};
} forEach _types;
