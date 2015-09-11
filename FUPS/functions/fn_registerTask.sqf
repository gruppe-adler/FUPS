/*

    Description: Creates an executable task. The task name has to be the name of a global function.
    FUPS will automatically append _men, _land, _air or _vehicle depending on the group.
    Via this you can specify a tasks behaviour for different unit types.
    For more information see fups task explanation (wip)

    PARAMS:
    0 <STRING> - task name, has to be function name of the code
    1 <CODE> - Function that will generate a priority for this task to be assigned, can make use of mainHandler variables. Has to return a scalar
    2 <CODE> - Condition under which the task will be aborted. Can make use of mainHandler variables, too. Has to return boolean


    Author: [W] Fett_Li
*/

params ["_task","_taskPriority","_taskBreak","_taskParams"];
_task = toUpper _task;

missionNamespace setVariable [_task + "_prior",_taskPriority];
missionNamespace setVariable [_task + "_break",_taskBreak];
missionNamespace setVariable [_task + "_params",_taskParams];
