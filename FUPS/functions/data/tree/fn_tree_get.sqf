/*

	This function gets a tree by it's name.

	PARAMS:
		0 <STRING> - name of the tree

	RETURNS:
		<TREE> - array format [children: <ARRAY>, value: nil, father: <ARRAY>, name: <STRING>]

	AUTHOR: [W] Fett_Li

*/

params [["_name","",[""]]];

private _index = (FUPS_trees select 0) find _name;
if (_name == -1) exitWith {nil};

(FUPS_trees select 1) select _index
