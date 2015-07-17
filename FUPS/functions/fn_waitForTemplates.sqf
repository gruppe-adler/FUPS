/*

    Description: When called this script will sleep until all given indexes will be intialized as templates

    PARAMS:
    . <SCALAR> - indexes to wait for

    RETURN:
    -

    Author: [W] Fett_Li
*/

private "_highest";
_highest = -1;
{
    _highest = _highest max _x;
} forEach _this;

waitUntil {!isNil "FUPS_templates"};
waitUntil {count FUPS_templates > _highest};
waitUntil {{isNil {FUPS_templates select _x}} count _this == 0};
