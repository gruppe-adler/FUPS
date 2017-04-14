#include "..\..\..\header\header.hpp"

params ["_group","_mode"];

switch _mode do {
    case ("init"): {
        ["Getting out of water",false,false,ACTIONS_LOG] call FUPS_fnc_log;

        private _pos	= _currpos;
        private _angle	= 0;
        private _dist	= 10;
        while {surfaceIsWater _pos} do {
        	if (_angle == 360) then {
        		_angle = 0;
        		_dist	= _dist + 10;
        	};
        	_angle	= _angle + 30;
        	_pos	= [_currpos,_dist,_angle] call FUPS_fnc_relPos;
        };

        {
        	_x doMove _pos;
        } forEach (units _group);

        _group move _pos;
        _group setSpeedMode "FULL";

        _group setVariable ["FUPS_taskState","move"];
    };
    case ("move"): {
        if ({surfaceIsWater getPosATL _x} count (units _group) == 0) then {
            _group setVariable ["FUPS_task",""];
        };
    };
};
