/*

	Gets the amount of units in the template

	PARAMS:
		0 <SCALAR> - index of the template

	RETURN:
		<SCALAR> - amount of units in the template

	AUTHOR: [W] Fett_Li

*/

#include "..\..\header\header.hpp"

params [["_template",count FUPS_templates,[0]]];
_template = FUPS_templates param [_template,[]];

count _template
