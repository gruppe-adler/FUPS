params ["_obj"];
private "_uniform";
_uniform = getText (configFile >> "CfgWeapons" >> uniform _obj >> "ItemInfo" >> "uniformClass");

getNumber (configFile >> "CfgVehicles" >> _uniform >> "camouflage")
