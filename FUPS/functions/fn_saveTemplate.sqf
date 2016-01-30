/*

    Will save the given group as template to be spawned. Only direct vehicles are taken into account. No loadout, etc.

    PARAMS:
    0 <GROUP/OBJECT> - group that should be saved
    1 <SCALAR> - the index of the template
    @optional 2 <BOOLEAN> - true when the objects should be deleted after saving, default false

    RETURN:
        nil

    AUTHOR: [W] Fett_Li

*/

#include "..\header\header.hpp"

params [["_group",grpNull,[grpNull,objNull]],["_template",-1,[0]],["_doDelete",false]];

if (isNull _group) throw ILLEGALARGUMENTSEXCEPTION;

if (_group isEqualType objNull) then {
    _group = group _group;
};

private _units = [[vehicle leader _group,skill commander leader _group]];
private _checked = [vehicle leader _group];
{
    if !(vehicle _x in _checked) then {
        _units pushBack [vehicle _x,skill commander _x];
        _checked pushBack (vehicle _x);
    };
} forEach (units _group);

{
    (_units select _forEachIndex) set [0,typeOf (_x select 0)];
} forEach _units;

private _saved = [side _group,_units];

if (_template > -1 && {count (FUPS_templates param [_template,[]]) == 0}) then {
    FUPS_templates set [_template,_saved];
};

if (_doDelete) then {
    {
        if (vehicle _x != _x) then {
            deleteVehicle (vehicle _x);
        };
        deleteVehicle _x;
    } forEach (units _group);
};

_saved
