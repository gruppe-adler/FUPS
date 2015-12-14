params ["_group"];
private _units = units _group;
private _centerPos = [0,0];
{
	(getPosATL _x) params ["_xCord","_yCord"];
	_centerPos params ["_xCenter","_yCenter"];
	_centerPos set [0,_xCenter + _xCord];
	_centerPos set [1,_yCenter + _yCord];
} forEach _units;

_centerPos params ["_xCenter","_yCenter"];
_centerPos set [0,_xCenter / count _units];
_centerPos set [1,_yCenter / count _units];

_centerPos
