private ["_str","_log","_message"];
_str = _this select 0;
_log = FUPS_log || (count _this == 2 && {_this select 1});

if (_str isEqualTo "" || !_log) exitWith {};

_message = "FUPS_log: ";
//--- Insert function name where available
if !(isnil "_fnc_scriptNameParent") then { _message = "FUPS_log in " + _fnc_scriptNameParent + ": " };

if (!isNil "_group") then { _message = _message + str _group + ", " };
if (typename _str == "ARRAY") then {
	_message = _message + format _str;
} else {
	_message = _message +  str _str;
};

diag_log _message;
