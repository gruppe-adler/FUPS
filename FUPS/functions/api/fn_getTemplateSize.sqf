
/*

	Gets the amount of units in the template

	PARAMS:
		0 <SCALAR> - index of the template

	RETURN:
		<SCALAR> - amount of units in the template

	AUTHOR: [W] Fett_Li

*/

params ["_template"];
_template = FUPS_templates param [_template,[]];

count _template
