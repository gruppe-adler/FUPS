params ["_targetType","_code",["_overwrite",false]];

FUPS_routePlaningPatterns params ["_types","_patterns"];

private "_index";
_index = _types find _targetType;
if (_index >= 0) exitWith {
	if (_overwrite) then {
		_patterns set [_index,_code];
		true
	} else {
		[["Fatal error: type %1 already present in FUPS route Planing!",_targetType]] call FUPS_fnc_log;
		false
	};
};

private "_inherits";
_inherits = 0;
{
	#define SCOPE "forEach"
	scopeName SCOPE;
	if (_x isKindOf _targetType) then {
		_inherits = _forEachIndex;
	} else { if (_targetType isKindOf _x) then {
		breakOut SCOPE;
	}};
	#undef SCOPE
} forEach _types;

// Insert the elements
private ["_tmp","_tmp_1"];
_tmp = [_types,_inherits] call FUPS_fnc_slice;
_tmp_1 = [_patterns,_inherits] call FUPS_fnc_slice;

_types resize _inherits;
_patterns resize _inherits;
_types pushBack _targetType;
_patterns pushBack _code;
_types append _tmp;
_patterns append _tmp_1;

true