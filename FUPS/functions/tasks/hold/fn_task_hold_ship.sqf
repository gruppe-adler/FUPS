#include "..\..\..\header\header.hpp"

params ["_group","_mode"];

switch _mode do {
    case ("init"): {
        ["Holding",false,false,ACTIONS_LOG] call FUPS_fnc_log;

        {doStop _x} forEach (units _group);

        _group setVariable ["FUPS_movePos",_currpos];
        _group setVariable ["FUPS_taskState","idle"];
    };
    case ("idle"): {
        private _pos = _group getVariable ["FUPS_movePos",_currpos];
        {
            if (_x distance _pos > 50) then {
                _x doMove ([_pos,random 20,random 360] call FUPS_fnc_relPos);
            };
        } forEach (units _group);
    };
};


