/*

	Adds a script for group initialization. Arguments to the init sccript will be: [_group]

	PARAMS:
		0 <CODE/STRING>
			- Code to exec upon initialization. If data type is string it will be compiled.

	RETURNS:
		NONE

	AUTHOR: [W] Fett_Li

*/

#include "macros.hpp"

params [["_script",{},[{},""]]];

if (_script isEqualType "") then {
	_script = compile _script;
};

FUPS_scheduler_initScripts pushBackUnique _script;
