params ["_unit","_raise"];
private "_group";
_group = if (typename _unit == "GROUP") then {_unit} else {group _unit};

private "_level";
_level = _group getVariable ["FUPS_panic",0];
_group setVariable ["FUPS_panic",_level + _raise];
