params ["_index","_side"];
private "_reinfArray";
_reinfArray = FUPS_reinforcements select (FUPS_sideOrder find _side);

!(_reinfArray param [_index,[]] isEqualTo [])
