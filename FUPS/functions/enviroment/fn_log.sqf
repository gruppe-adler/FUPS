/*

	Logs a message to the .rpt, format:
	FUNCTION: GROUP, MESSAGE
	FUNCTION will be the function in which FUPS_fnc_log was called (if present)
	GROUP will be the FUPS group for which log was called (if present)
	MESSAGE will be the given message

	PARAMS:
		0 <ARRAY/ANY> - The message
		@optional 1 <BOOLEAN> default true - True if param 0 is an array and should be formatted voa format [...].
		@optional 2 <BOOLEAN> defualt true - True if also a screen message shuld be displayed - default is false
		@optional 3 <BOOLEAN/SCALAR> default false - if true message will always be logged, otherwise FUPS_log will be used to decide whether this message will be logged. If scalar message will only be logged if FUPS_logLevel == param 2 or FUPS_log is true.

	RETURN:
		-

	Author: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_str","",["",[]]],["_format",true,[true]],["_notification",false,[true]],["_log",FUPS_log,[true,0]]];
_log = FUPS_log || (_log isEqualTo true) || (_log isEqualType 0 && {_log >= 0 && FUPS_logLevels param [_log,false]});

if (_str isEqualTo "" || !_log) exitWith {};

private _message = "FUPS_log: ";
//--- Insert function name where available
if !(isnil "_fnc_scriptNameParent") then { _message = "FUPS_log in " + _fnc_scriptNameParent + ": " };

if (!isNil "_group") then { _message = _message + str _group + ", " };
if (_str isEqualType [] && _format) then {
	_message = _message + format _str;
} else {
	_message = _message +  str _str;
};

diag_log _message;
if (_notification) then {
	[_message] call BIS_fnc_error;
};
