#include "..\..\header\header.hpp"

params ["_obj"];

private _uniform = getText (configFile >> "CfgWeapons" >> uniform _obj >> "ItemInfo" >> "uniformClass");

getNumber (configFile >> "CfgVehicles" >> _uniform >> "camouflage")
