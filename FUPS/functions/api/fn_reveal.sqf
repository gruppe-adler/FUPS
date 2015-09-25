params [["_grp",grpNull,[objNull,grpNull]],["_side",sideUnknown,[sideUnknown]]];
if (typeName _grp == typeName objNull) then { _grp = group _grp };

_grp setVariable ["FUPS_revealedAt",time];
(FUPS_share select (FUPS_sideOrder find _side)) pushBack _grp;
