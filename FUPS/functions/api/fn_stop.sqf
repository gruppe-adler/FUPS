
/*

	Stops the calculation of an ai group with FUPS.

	PARAMS:
		0 <GROUP/OBJECT> - Group or member of a group whos execution should be stopped

	RETURN:
		nil

	AUTHOR: [W] Fett_Li

*/

params [["_group",grpNull,[grpNull,objNull]]];
if (typeName _group == "OBJECT") then {_group = group _group};

private "_index";
_index = FUPS_oefGroups find _group;
if (_index >= 0) then {
	FUPS_oefGroups_toDelete pushBack _index;
};
