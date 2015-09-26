
/*

	Reveals all given units or groups to the side in FUPS.

	PARAMS:
		0 <ARRAY> - an array containing objects or groups to be revealed
		1 <SIDE> - side to reveal to

	RETURN:
		nil

	AUTHOR: [W] Fett_Li

*/

params [["_toReveal",[],[[]]],["_side",sideUnknown,[sideUnknown]]];

private "_share";
_share = FUPS_share select (FUPS_sideOrder find _side);

{
	private "_target";
	_target = if (typeName _x == typeName objNull) then {group _x} else {_x};

	if (typeName _target == typeName grpNull && !(_target in _share)) then {
		_target setVariable ["FUPS_revealedAt",time];
		_share pushBack _target;
	};
} forEach _toReveal;

