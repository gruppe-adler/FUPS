/*

	Creates an executable task. The task name has to be the name of a global function.
	FUPS will automatically append _men, _land, _air or _vehicle depending on the group.
	Via this you can specify a tasks behaviour for different unit types.
	For more information see fups task explanation --- ToDo

	Arguments passed to the task code will be:
		0 - the group that is exectuing the task
		1 - the task state, "init" on initial call, can be modified later on in the code
		2 - other parameters, manually defined

	PARAMS:
		0 <STRING> - task name, has to be function name of the code
		1 <CODE> - Function that will generate a priority for this task to be assigned, can make use of mainHandler variables. Has to return a scalar
		2 <CODE> - Condition under which the task will be aborted. Can make use of mainHandler variables, too. Has to return boolean.
		3 <ANY> - any parameters for the task. Will be _this select 3 in the function.


	AUTHOR: [W] Fett_Li

*/

#include "..\header\header.hpp"

params [["_task","",[""]],["_taskPriority",{},[{}]],["_taskBreak",{},[{}]],["_taskParams",{[]}]];

if (_task == "" || _taskPriority isEqualTo {} ||_taskBreak isEqualTo {}) throw ILLEGALARGUMENTSEXCEPTION;

_task = toUpper _task;

missionNamespace setVariable [_task + "_prior",_taskPriority];
missionNamespace setVariable [_task + "_break",_taskBreak];
missionNamespace setVariable [_task + "_params",_taskParams];
missionNamespace setVariable [_task + "_isTask",true];
