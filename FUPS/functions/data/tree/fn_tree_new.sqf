/*

	This function creates a new tree

	PARAMS:
		0 <STRING> - name of the tree

	RETURNS:
		<TREE> - array format [children: <ARRAY>, value: nil, father: <ARRAY>, name: <STRING>]

	AUTHOR: [W] Fett_Li

*/


params [["_name","",[""]]];
if (_name == "") exitWith {}; // ToDo: maybe throw exception

private _tree = [[],nil,nil,_name];
private _index = (FUPS_trees select 0) pushBackUnique _name;
if (_index == -1) exitWith {}; // ToDo: maybe throw exception
(FUPS_trees select 1) set [_index,_tree];

_tree
