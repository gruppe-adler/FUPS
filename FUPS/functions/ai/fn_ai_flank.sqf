params [["_leader",objNull,[objNull]],["_flankPos",[],[[]],[3]]];

_flankPos set [2,0];
[_leader,_flankPos,0.6,60] call FUPS_fnc_ai_flank_rec;
