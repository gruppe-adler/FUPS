/*

    Description: Logs a message to the .rpt, format:
    FUNCTION: GROUP, MESSAGE
    FUNCTION will be the function in which FUPS_fnc_log was called (if present)
    GROUP will be the FUPS group for which log was called (if present)
    MESSAGE will be the given message

    PARAMS:
    0 <ARRAY/ANY> - The message, if it is a array, it'll be interpreted as format array
    1 <BOOLEAN> - if true message will always be logged, otherwise FUPS_log will be used to decide whether this message will be logged

    RETURN:
    -

    Author: [W] Fett_Li

*/


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
