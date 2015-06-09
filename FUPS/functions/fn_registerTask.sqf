private ["_task","_taskPriority","_taskBreak","_taskFile","_taskStdIndex"];
_task			= toUpper (_this select 0);
_taskPriority	= _this select 1;
_taskBreak		= _this select 2;

missionNamespace setVariable [_task + "_prior",_taskPriority];
missionNamespace setVariable [_task + "_break",_taskBreak];
