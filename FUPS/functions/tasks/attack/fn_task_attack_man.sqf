params ["_group","_mode","_target"];

switch _mode do {
	case ("init"): {
		["Attacking"] call FUPS_fnc_log;

		_group setBehaviour "COMBAT";
		_group setSpeedMode "FULL";

		// position calculation
		private ["_offsVal","_offsX","_offsY"];
		_offsVal = if (_maxknowledge != 0) then {50 / (_maxknowledge * _maxknowledge * 3)} else {300};
		_offsX = (random (2 * _offsVal) + random _offsVal) * ([1,-1] select (floor random 2));
		_offsY = (random (2 * _offsVal) + random _offsVal) * ([1,-1] select (floor random 2));

		private "_targetPos";
		_targetPos = getPosATL leader _target;
		_targetPos set [0,(_targetPos select 0) + _offsX];
		_targetPos set [1,(_targetPos select 1) + _offsX];

		// let all units watch into the enemy direction
		{ _x doWatch _targetPos } forEach (units _group);

		// get safepos in the vicinity, if hit
		private ["_pos","_build","_inBuilding"];
		_pos = [];
		_build = [_currpos,20] call FUPS_fnc_nearestBuilding;
		_inBuilding = false;
		if !(isNull _build) then {
			_inBuilding = [_group,_build] call FUPS_fnc_useBuilding;
		};

		if (_inBuilding) then {
			_pos = getPosATL _build;
		}
		else {
			_pos = (selectBestPlaces [_currpos,20,"hills + forest + trees - meadow",5,1]) select 0 select 0;
			_group move _pos;
		};

		_group setVariable ["FUPS_movePos",_pos];
		if (_leader distance leader _target < 100) then {
			// skip flanking, etc. when enemy is too close
			_group setVariable ["FUPS_taskState","flank"];
		}
		else {
			_group setVariable ["FUPS_taskState","evase"];
		};
	};
	case ("evase"): {
		if (_currpos distance (_group getVariable ["FUPS_movePos",_currpos]) < (_group getVariable "FUPS_closeenough")) then {
			// only sortie if not to far away
			if (_leader distance leader _target < 800) then {
				// position calculation
				private ["_offsVal","_offsX","_offsY"];
				_offsVal = if (_maxknowledge != 0) then {50 / (_maxknowledge * _maxknowledge * 3)} else {300};
				_offsX = (random (2 * _offsVal) + random _offsVal) * ([1,-1] select (floor random 2));
				_offsY = (random (2 * _offsVal) + random _offsVal) * ([1,-1] select (floor random 2));

				private "_targetPos";
				_targetPos = getPosATL leader _target;
				_targetPos set [0,(_targetPos select 0) + _offsX];
				_targetPos set [1,(_targetPos select 1) + _offsX];

				private ["_dir","_dist","_pos"];
				_dir = [_currpos,_targetPos] call FUPS_fnc_getDir;
				_dir = if (random 1 < .5) then {_dir + 90} else {_dir - 90};
				_dist = ((_currpos distance _targetPos) * 2 / 3) min 200;
				_pos = [_currpos,_dist * 2 / 3,_dir] call FUPS_fnc_relPos;

				_group move _pos;

				_group setVariable ["FUPS_movePos",_pos];
				_group setVariable ["FUPS_taskState","evase"];
			};
		};
	};
	case ("flank"): {
		// evasing finished?
		if (_currpos distance (_group getVariable ["FUPS_movePos",_currpos]) < (_group getVariable "FUPS_closeenough")) then {
			// go to flanking position
			private ["_offsVal","_offsX","_offsY"];
			_offsVal = if (_maxknowledge != 0) then {50 / (_maxknowledge * _maxknowledge * 3)} else {300};
			_offsX = (random (2 * _offsVal) + random _offsVal) * ([1,-1] select (floor random 2));
			_offsY = (random (2 * _offsVal) + random _offsVal) * ([1,-1] select (floor random 2));
			_targetPos = getPosATL leader _target;
			_targetPos set [0,(_targetPos select 0) + _offsX];
			_targetPos set [1,(_targetPos select 1) + _offsX];
			_dist = if ([_targetPos] call FUPS_fnc_inTown) then {100} else {200};
			private "_dir";
			_dir = [_currpos,_targetPos] call FUPS_fnc_getDir;

			_pos = [_targetPos,_dist,_dir] call FUPS_fnc_relPos;
			if (_nofollow) then {_pos = [_group,_pos] call FUPS_fnc_stayInside};

			_group move _pos;

			_group setVariable ["FUPS_movePos",_pos];
			_group setVariable ["FUPS_taskState","attack"];
		};
	};
	case ("attack"): {
		// flanking finished?
		if (_currpos distance (_group getVariable ["FUPS_movePos",_currpos]) < (_group getVariable "FUPS_closeenough")) then {
			{ _x doWatch (leader _target) } forEach (units _group);

			private "_build";
			_build = [getPosATL leader _group,20] call FUPS_fnc_nearestBuilding;
			if !(isNull _build) then {[_group,_build] call FUPS_fnc_useBuilding};

			_group setVariable ["FUPS_movePos",nil];
			_group setVariable ["FUPS_taskState","fight"];
			_group setVariable ["FUPS_tot",time + 600];
		};
	};
	case ("fight"): {
		if (_group knowsAbout leader _target > 0.2) then {_timeOnTarget = _group setVariable ["FUPS_timeOnTarget",time + 600]};

		if (({alive _x} count units _target == 0) or (time > (_group getVariable "FUPS_timeOnTarget"))) then {
			_group setVariable ["FUPS_task",""];
		};
	};
};
