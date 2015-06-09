switch (_group getVariable ["FUPS_taskState","init"]) do {
    case ("init"): {
		["Holding"] call FUPS_fnc_log;

		private ["_holdPos","_build"];
		_build = [_currpos,50] call FUPS_fnc_nearestBuilding;
		if !(isNull _build) then {
			_holdPos = getPosATL _build;
			[_group,_build] call FUPS_fnc_useBuilding;

			_group setVariable ["FUPS_movePos",_holdPos];
			_group setVariable ["FUPS_building",_build];
			_group setVariable ["FUPS_taskState","idleBuilding"];
		} else {
			_holdPos = (selectBestPlaces [_currpos,20,"hills + forest + trees - meadow",5,1]) select 0 select 0;
			_group move _holdPos;

			_group setVariable ["FUPS_movePos",_holdPos];
			_group setVariable ["FUPS_taskState","idle"];
		};
	};
	case ("idle"): {
		if (_x distance (_group getVariable "FUPS_movePos") > 50) then {
			_x doMove ([_holdPos,random 5,random 360] call FUPS_fnc_relPos);
		};
	};
	case ("idleBuilding"): {
		if (_x distance (_group getVariable "FUPS_movePos") > 50) then {
			[_x,(_group getVariable "FUPS_building")] call FUPS_fnc_solUseBuilding
		};
	};
};
