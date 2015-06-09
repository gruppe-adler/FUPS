private ["_v","_weapons"];
_v = _this select 0;
_weapons = [false,false,false];

{
	private ["_ammo","_hit","_airLock"];
	_ammo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
	_hit = getNumber (configFile >> "CfgAmmo" >> _ammo >> "hit");
	_airLock = getNumber (configFile >> "CfgAmmo" >> _ammo >> "airLock") == 1;

	_weapons set [0,_weapons select 0 || _hit > 0];
	_weapons set [1,_weapons select 1 || (_hit >= 120 && !_airLock)];
	_weapons set [2,_weapons select 2 || _airLock];
	_weapons set [3,_weapons select 3 || (_hit >= 120 && !_airLock)];
} forEach (magazines _v);
_v setVariable ["FUPS_weapons", _weapons];

_weapons