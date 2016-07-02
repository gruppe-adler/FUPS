params [["_leader",objNull,[objNull]],["_flankPos",[],[[]],[3]]];

_flankPos set [2,0];
[_leader,_flankPos,0.6,60] call FUPS_ai_fnc_flank_rec;
