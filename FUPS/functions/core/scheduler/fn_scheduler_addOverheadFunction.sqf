/*

	Adds a function to be calculated as overhead.
	Each overhead function will be calculated after all scheduled groups have been calculated.
	There is no guaranteed order of overhead function calls.

	PARAMS:
		0 <CODE/STRING>
			- Code to be executed as overhead. If value type is string, the string will be compiled.
		1 <ANY> @optional default []
			- Arguments to your code.
		2 <BOOLEAN> @optional default: false
			- true if the function should be executed only once.

	RETURN VALUE:
		NONE

	AUTHOR: [W] Fett_Li

*/

#include "macros.hpp"

params [["_func",{},[{},""]],["_args",[]],["_execOnce",false,[true]]];

if (_func isEqualType "") then {
	_func = compile _func;
};

private _a = if (_execOnce) then {FUPS_scheduler_oefToppedOnce} else {FUPS_scheduler_oefTopped};
_a pushBackUnique [_func,_args];

nil
