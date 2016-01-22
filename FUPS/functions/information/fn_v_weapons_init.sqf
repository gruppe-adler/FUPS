/*

    Calculates the weapons of an object.

    PARAMS:
        0 <OBJECT> - object to calcluate from

    RETURN:
        <<BOOL> ARRAY> - array of bool, matching type indexes

    AUTHOR: [W] Fett_Li
*/

#include "..\..\header\header.hpp"

params [["_v",objNull,[objNull]]];
if (isNull _group) throw NULLPOINTEREXCEPTION;

private _weapons = weapons _v;
private _magazines = magazines _v;
{
    private _weaponMagazines = (getArray (configFile >> "CfgWeapons" >> _x >> "magazines")) arrayIntersect _magazines;

    {
        private _ammo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
        _weaponMagazines set [_forEachIndex,_ammo];
    } forEach _weaponMagazines;

    _weapons set [_forEachIndex,[_x,_weaponMagazines]];
} forEach _weapons;

_effectiveness = [false,false,false,false];

{
	private _hit = 0;
	private _isLauncher = getNumber (configFile >> "CfgWeapons" >> (_x select 0) >> "canLock") == 2;
    private _isAA = false;

    {
        private _cfg = configFile >> "CfgAmmo" >> _x;
        _hit = _hit max (getNumber (_cfg >> "hit"));
        _isAA = _isAA || (_isLauncher && (getNumber (_cfg >> "airLock") == 1));
    } forEach (_x select 1);

	_effectiveness set [0,(_effectiveness select 0) || (_hit > 0)];
	_effectiveness set [1,(_effectiveness select 1) || (_hit >= 120 && !_isAA)];
	_effectiveness set [2,(_effectiveness select 2) || _isAA];
	_effectiveness set [3,(_effectiveness select 3) || (_hit >= 120 && !_isAA)];

} forEach _weapons;

_v setVariable ["FUPS_weapons", _effectiveness];

_effectiveness
