params ["_unit"];

// Audio reaveal eh
_unit addEventHandler ["Fired",{
	params ["_unit"];
	// commander if this eh is attached to a land vehicle, etc.
	(commander _unit) setVariable ["FUPS_firedLast",time]; // maybe set to group?
}];
