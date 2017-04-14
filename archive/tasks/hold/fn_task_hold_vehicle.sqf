#include "..\..\..\header\header.hpp"

params ["_group","_mode"];

switch _mode do {
    case ("init"): {
        ["Holding",false,false,ACTIONS_LOG] call FUPS_fnc_log;

        private _holdPos = (selectBestPlaces [_currpos,50,"hills - forest + trees + meadow",5,1]) select 0 select 0;
        _group move _holdPos;

        _group setVariable ["FUPS_taskState","idle"];
        _group setVariable ["FUPS_movePos",_holdPos];
    };
    case ("idle"): {
        private _pos = _group getVariable "FUPS_movePos";
        {
            if (_x distance _pos > 50) then {
                _x doMove ([_pos,random 20,random 360] call FUPS_fnc_relPos);
            };
        } forEach (units _group);
    };
};
