/*

	Takes care of the simulation of a group

	PARAMS:
	0 <GROUP> - group that should be simulated
	1 <BOOLEAN> - true for simulation turned on, otherwise false
	2 <BOOLEAN> - true to attach hit eventhandlers to turn simulation on

	RETURN:
		nil

	AUTHOR: [W] Fett_Li

*/

params ["_grp","_simulate",["_allowEH",true]];

[["enableSimulationGlobal %1 for %2",_simulate,_grp]] call FUPS_fnc_log;

if (isServer) then {
	private "_vs";
	_vs = [];
	{
		_v = vehicle _x;
		if ([_v] isEqualTo crew _v) then {
			_x enableSimulationGlobal _simulate;
		} else {
			if !(_v in _vs) then { _vs pushBack _v; };
			_x enableSimulationGlobal _simulate;
		};
	} forEach (units _grp);

	{
		_x enableSimulationGlobal _simulate;
	} forEach _vs;
} else {
	[_grp,_simulate] remoteExecCall ["FUPS_fnc_simulation",2];
};

if (local _grp) then {
	private "_added";
	_added = [];
	if (_simulate) then {
		{
			vehicle _x removeEventhandler ["Hit",(vehicle _x getVariable ["FUPS_hitHandler",-1])];
			vehicle _x setVariable ["FUPS_hitHandler",-1];
			vehicle _x removeEventhandler ["Hit",(vehicle _x getVariable ["FUPS_killedHandler",-1])];
			vehicle _x setVariable ["FUPS_killedHandler",-1];
		} forEach (units _grp);
	} else {
		if (_allowEH) then {
			{
				if !(vehicle _x in _added) then {
					_eh = (vehicle _x) addEventHandler ["Hit",{
						["Got hit while not simulated"] call FUPS_fnc_log;
						[(group (_this select 0)),true] call FUPS_fnc_simulation;
						_group setVariable ["FUPS_simulation",{true}];
					}];
					(vehicle _x) setVariable ["FUPS_hitHandler",_eh];

					_eh = (vehicle _x) addEventHandler ["Killed",{
						["Got hit while not simulated"] call FUPS_fnc_log;
						[(group (_this select 0)),true] call FUPS_fnc_simulation;
						_group setVariable ["FUPS_simulation",{true}];
					}];
					(vehicle _x) setVariable ["FUPS_killedHandler",_eh];

					_added pushBack (vehicle _x);
				};
			} forEach (units _grp);
		};
	};
};
