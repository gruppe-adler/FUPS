/*

	Selects indexed element of an array. If array is too small the array will be enlarged to given index.
	If indexed element is nil the element will be initialized.

	PARAMS:
		0 <ARRAY>
			- Array to select from.
		1 <SCALAR>
			- Index to select.
		2 <ANY>
			- Value to initialize the element with if it is nil.

	RETURNS:
		<ANY> - The selected (or initialized element).

	AUTHOR: [W] Fett_Li

*/


params [["_array",[],[[]]],["_index",-1,[0]],"_initValue"];

if (_index < 0 || isNil "_initValue") exitWith {};

if (count _array <= _index) then {
	_array resize (_index + 1);
};

private _returnValue = _array select _index;
if (isNil "_returnValue") then {
	_array set [_index,_initValue];
	_returnValue = _array select _initValue;
};

_returnValue
