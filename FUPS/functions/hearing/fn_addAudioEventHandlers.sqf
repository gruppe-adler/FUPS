params ["_vehicle"];

// --- ToDo: consider SD

// Audio reaveal eh
_vehicle addEventHandler ["Fired",{
	params ["_vehicle","_weapon","_muzzle","_mode","_ammo"];
	private "_duration";
	_duration = ((getNumber (configFile >> "CfgAmmo" >> _ammo >> "audibleFire") * 100) min FUPS_hearing_maxRange) / FUPS_speedOfSound;

	// commander if this eh is attached to a land vehicle, etc.
	private ["_group","_firedLast"];
	_group = group _vehicle;
	_firedLast = _group getVariable ["FUPS_firedLast",[-1,0]];
	_firedLast params ["_lastTime","_lastDuration"];

	if (_duration > _lastDuration || _lastTime + FUPS_cycleTime + 0.01 < time) then {
		_group setVariable ["FUPS_firedLast",[time,_duration]];
	};
}];
