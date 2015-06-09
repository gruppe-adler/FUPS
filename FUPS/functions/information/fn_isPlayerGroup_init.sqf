private ["_group","_isPlayerGroup"];
_group = _this select 0;
_isPlayerGroup = count (units _x) > {isPlayer _x} count (units _x);

_group setVariable ["FUPS_grpIsPlayer",_isPlayerGroup];

_isPlayerGroup
