private ["_group","_target"];
_group = _this select 0;
_target = _this select 2;

switch (_this select 1) do {
	case ("init"): {
		["Attacking"] call FUPS_fnc_log;

		_group setBehaviour "COMBAT";
		_group setSpeedMode "FULL";

		private ["_maxknowledge","_offsVal","_offsX","_offsY","_targetPos"];
		_maxknowledge = _this select 17;
		_offsVal = if (_maxknowledge != 0) then {50 / (_maxknowledge * _maxknowledge * 3)} else {300};
		_offsX = (random (2 * _offsVal) + random _offsVal) * ([1,-1] select (floor random 2));
		_offsY = (random (2 * _offsVal) + random _offsVal) * ([1,-1] select (floor random 2));
		_targetPos = getPosATL leader _target;
		_targetPos set [0,(_targetPos select 0) + _offsX];
		_targetPos set [1,(_targetPos select 1) + _offsX];

		{_x doWatch _targetPos} forEach (units _group);

		if (_currpos distance leader _target > 500) then { // enemy far enough away to flank
			private ["_dir","_pos"];
			_dir = [_currpos,_targetPos] call FUPS_fnc_getDir;
			_dir = if (random 1 < 0.5) then {_dir + 90} else {_dir - 90};
			_pos = [_targetPos,500,_dir] call FUPS_fnc_relPos;
			_pos = (selectbestPlaces [_pos,50,"meadow + trees - forest + hill - houses",5,1]) select 0 select 0;

			_group move _pos;

			_group setVariable ["FUPS_movePos",_pos];
		}
		else {
			// do not flank, so set this to nil
			_group setVariable ["FUPS_movePos",nil];
		};
		_group setVariable ["FUPS_taskState","flank"];
	};
	case ("flank"): {
		if (_currpos distance (_group getVariable ["FUPS_movePos",_currpos]) < (_group getVariable "FUPS_closeenough")) then {
			_offsVal = if (_maxknowledge != 0) then {50 / (_maxknowledge * _maxknowledge * 3)} else {300};
			_offsX = (random (2 * _offsVal) + random _offsVal) * ([1,-1] select (floor random 2));
			_offsY = (random (2 * _offsVal) + random _offsVal) * ([1,-1] select (floor random 2));
			_targetPos = getPosATL leader _target;
			_targetPos set [0,(_targetPos select 0) + _offsX];
			_targetPos set [1,(_targetPos select 1) + _offsX];

			private "_pos";
			_pos = (selectbestPlaces [_currpos,50,"meadow + trees - forest + hill - houses",5,1]) select 0 select 0;

			_group move _pos;

			{_x doWatch _targetPos} forEach (units _group);

			_group setVariable ["FUPS_taskState","fight"];
			_group setVariable ["FUPS_timeOnTarget",time + 600];
		};
	};
	case ("fight"): {
		if (_group knowsAbout leader _target > 0.2) then {
			_group setVariable ["FUPS_timeOnTarget",time + 600];
		};

		if (({alive _x} count units _target == 0) || (time > (_group getVariable "FUPS_timeOnTarget"))) then {
			_group setVariable ["FUPS_task",""];
		};
	};
};
