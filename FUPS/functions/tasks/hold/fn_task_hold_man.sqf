#include "..\..\..\header\header.hpp"

params ["_group","_mode"];

switch _mode do {
    case ("init"): {
		["Holding",false,false,ACTIONS_LOG] call FUPS_fnc_log;

		private _build = [_currpos,50] call FUPS_fnc_nearestBuilding;
		if !(isNull _build) then {
			private _holdPos = getPosATL _build;
			[_group,_build] call FUPS_fnc_useBuilding;

			_group setVariable ["FUPS_movePos",_holdPos];
			_group setVariable ["FUPS_building",_build];
			_group setVariable ["FUPS_taskState","idleBuilding"];
		} else {
			private _holdPos = (selectBestPlaces [_currpos,20,"hills + forest + trees - meadow",5,1]) select 0 select 0;
			_group move _holdPos;

			_group setVariable ["FUPS_movePos",_holdPos];
			_group setVariable ["FUPS_taskState","idle"];
		};
	};
	case ("idle"): {
			private _holdPos = _grou getVariable "FUPS_movePos";
		if (_x distance _holdPos > 50) then {
			_x doMove ([_holdPos,random 5,random 360] call FUPS_fnc_relPos);
		};
	};
	case ("idleBuilding"): {
		if (_x distance (_group getVariable "FUPS_movePos") > 50) then {
			[_x,(_group getVariable "FUPS_building")] call FUPS_fnc_solUseBuilding
		};
	};
};
